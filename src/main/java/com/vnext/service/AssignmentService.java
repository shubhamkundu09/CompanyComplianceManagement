package com.vnext.service;

import com.vnext.dto.EmployeeComplianceDTO;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssignmentService {

    private final EmployeeAssignmentRepository assignmentRepository;
    private final ComplianceConfigRepository configRepository;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final UserRepository userRepository;
    private final ComplianceHistoryRepository historyRepository;
    private final ComplianceDocumentRepository documentRepository;
    private final NotificationEventService notificationEventService;

    // ==================== EMPLOYEE ASSIGNMENTS ====================

    @Transactional
    public void syncMissingSubAssignmentsForEmployee(Long employeeId) {
        try {
            List<EmployeeAssignment> parentAssignments = assignmentRepository.findByEmployeeIdAndIsActiveTrue(employeeId)
                    .stream()
                    .filter(a -> a.getConfig() != null && Boolean.FALSE.equals(a.getIsSubAssignment()))
                    .collect(Collectors.toList());

            for (EmployeeAssignment parentAssign : parentAssignments) {
                ComplianceConfig parentConfig = parentAssign.getConfig();
                CompanyCompliance parentCC = parentConfig.getCompanyCompliance();
                if (parentCC == null || parentCC.getCompany() == null) continue;

                Long companyId = parentCC.getCompany().getId();
                Long templateId = parentCC.getTemplate() != null ? parentCC.getTemplate().getId() : parentCC.getParentTemplateId();
                if (templateId == null) continue;

                List<CompanyCompliance> subCCs = companyComplianceRepository
                        .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, templateId);

                for (CompanyCompliance subCC : subCCs) {
                    if (!Boolean.TRUE.equals(subCC.getIsActive()) || subCC.isDeleted()) continue;

                    ComplianceConfig subConfig = configRepository.findByCompanyComplianceId(subCC.getId()).orElse(null);
                    if (subConfig == null) {
                        subConfig = new ComplianceConfig();
                        subConfig.setCompanyCompliance(subCC);
                        subConfig.setTemplate(null);
                        subConfig.setSubTemplate(subCC.getSubTemplate());
                        subConfig.setFrequency(parentConfig.getFrequency() != null ? parentConfig.getFrequency() : ComplianceFrequency.YEARLY);
                        subConfig.setDueDate(parentConfig.getDueDate() != null ? parentConfig.getDueDate() : LocalDate.now().plusMonths(1));
                        subConfig.setIsActive(true);
                        subConfig.setConfiguredBy(parentConfig.getConfiguredBy());
                        subConfig = configRepository.save(subConfig);
                    }

                    Optional<EmployeeAssignment> existingSub = assignmentRepository
                            .findByConfigIdAndEmployeeIdAndIsActiveTrue(subConfig.getId(), employeeId);

                    if (existingSub.isEmpty()) {
                        EmployeeAssignment subAssign = new EmployeeAssignment();
                        subAssign.setConfig(subConfig);
                        subAssign.setEmployeeId(employeeId);
                        subAssign.setDueDate(subConfig.getDueDate() != null ? subConfig.getDueDate() : parentAssign.getDueDate());
                        subAssign.setAssignedAt(LocalDateTime.now());
                        subAssign.setIsActive(true);
                        subAssign.setIsSubAssignment(true);
                        subAssign.setParentAssignmentId(parentAssign.getId());
                        if (subCC.getStatus() == ComplianceStatus.COMPLETED || subCC.getCompletedAt() != null) {
                            subAssign.setCompletedAt(subCC.getCompletedAt() != null ? subCC.getCompletedAt() : LocalDateTime.now());
                            subAssign.setCompletedBy(subCC.getCompletedBy());
                            subAssign.setSubmissionReference(subCC.getAdminSubmissionReference());
                            subAssign.setSubmissionDocumentUrl(subCC.getAdminSubmissionDocumentUrl());
                        }
                        assignmentRepository.save(subAssign);
                        log.info("Synced newly added sub-compliance {} to employee {}", subCC.getId(), employeeId);
                    } else {
                        EmployeeAssignment sub = existingSub.get();
                        if (sub.getParentAssignmentId() == null) {
                            sub.setParentAssignmentId(parentAssign.getId());
                            sub.setIsSubAssignment(true);
                            assignmentRepository.save(sub);
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error during syncMissingSubAssignmentsForEmployee for employee {}: {}", employeeId, e.getMessage(), e);
        }
    }

    @Transactional
    public Page<EmployeeComplianceDTO> getEmployeeAssignments(Long employeeId, String status, Pageable pageable) {
        log.info("Fetching assignments for employee: {}", employeeId);

        syncMissingSubAssignmentsForEmployee(employeeId);

        List<EmployeeAssignment> allAssignments = assignmentRepository
                .findByEmployeeIdAndIsActiveTrue(employeeId);

        List<EmployeeComplianceDTO> dtos = allAssignments.stream()
                .filter(a -> a.getConfig() != null)
                .filter(a -> {
                    if (Boolean.FALSE.equals(a.getIsSubAssignment())) {
                        boolean hasChildSubs = assignmentRepository.existsByParentAssignmentIdAndIsActiveTrue(a.getId());
                        return !hasChildSubs;
                    }
                    return true;
                })
                .map(this::convertToEmployeeDTO)
                .collect(Collectors.toList());

        if (status != null && !status.isEmpty()) {
            dtos = dtos.stream()
                    .filter(dto -> dto.getStatus().name().equals(status))
                    .collect(Collectors.toList());
        }

        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), dtos.size());
        List<EmployeeComplianceDTO> pageContent = (start <= end && start < dtos.size()) ? dtos.subList(start, end) : (start == 0 ? dtos : List.of());

        return new PageImpl<>(pageContent, pageable, dtos.size());
    }


    @Transactional
    public void markAsCompletedByAdmin(Long companyComplianceId, Long adminId, String submissionReference, String documentUrl) {
        log.info("Admin {} marking company compliance {} as completed", adminId, companyComplianceId);

        CompanyCompliance companyCompliance = companyComplianceRepository.findById(companyComplianceId)
                .orElseGet(() -> {
                    User admin = userRepository.findById(adminId).orElse(null);
                    Long companyId = (admin != null && admin.getCompany() != null) ? admin.getCompany().getId() : null;

                    if (companyId != null) {
                        Optional<CompanyCompliance> bySub = companyComplianceRepository
                                .findByCompanyIdAndSubTemplateId(companyId, companyComplianceId);
                        if (bySub.isPresent()) return bySub.get();

                        List<CompanyCompliance> byTemplate = companyComplianceRepository
                                .findByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(companyId, companyComplianceId);
                        if (!byTemplate.isEmpty()) return byTemplate.get(0);
                    }

                    Optional<ComplianceConfig> configOpt = configRepository.findById(companyComplianceId);
                    if (configOpt.isPresent() && configOpt.get().getCompanyCompliance() != null) {
                        return configOpt.get().getCompanyCompliance();
                    }
                    return null;
                });

        if (companyCompliance == null) {
            throw new ResourceNotFoundException("Company compliance not found with ID: " + companyComplianceId);
        }

        // Validate that this compliance/sub-compliance is configured first
        ComplianceConfig config = configRepository.findByCompanyComplianceId(companyCompliance.getId()).orElse(null);
        if (config == null || (config.getFrequency() == null && config.getDueDate() == null && config.getCustomDueDate() == null)) {
            throw new BusinessException("Please configure this sub-compliance first before marking it as complete.");
        }

        LocalDateTime now = LocalDateTime.now();

        // Save admin submission data on CompanyCompliance
        companyCompliance.setStatus(ComplianceStatus.COMPLETED);
        companyCompliance.setCompletedAt(now);
        companyCompliance.setCompletedBy(adminId);
        if (submissionReference != null && !submissionReference.trim().isEmpty()) {
            companyCompliance.setAdminSubmissionReference(submissionReference);
        }
        if (documentUrl != null && !documentUrl.trim().isEmpty()) {
            companyCompliance.setAdminSubmissionDocumentUrl(documentUrl);
        }
        companyComplianceRepository.save(companyCompliance);

        // Update ALL active EmployeeAssignment records for this config
        if (config != null) {
            List<EmployeeAssignment> assignments = assignmentRepository.findByConfigIdAndIsActiveTrue(config.getId());
            for (EmployeeAssignment assignment : assignments) {
                assignment.setCompletedAt(now);
                assignment.setCompletedBy(adminId);
                if (submissionReference != null && !submissionReference.trim().isEmpty()) {
                    assignment.setSubmissionReference(submissionReference);
                }
                if (documentUrl != null && !documentUrl.trim().isEmpty()) {
                    assignment.setSubmissionDocumentUrl(documentUrl);
                }
                assignmentRepository.save(assignment);
                addHistory(assignment, "Marked as Completed by Admin",
                        "Completed by Company Admin: " + adminId + ". Reference: " + (submissionReference != null ? submissionReference : "N/A"),
                        adminId);
            }
        }

        // If it's a sub-compliance, update parent compliance status
        if (!Boolean.TRUE.equals(companyCompliance.getIsParent()) && companyCompliance.getCompany() != null) {
            Long companyId = companyCompliance.getCompany().getId();
            Long parentTemplateId = companyCompliance.getParentTemplateId() != null
                    ? companyCompliance.getParentTemplateId()
                    : (companyCompliance.getTemplate() != null ? companyCompliance.getTemplate().getId() : null);

            if (parentTemplateId != null) {
                List<CompanyCompliance> parentCCs = companyComplianceRepository
                        .findByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(companyId, parentTemplateId);
                List<CompanyCompliance> subCCs = companyComplianceRepository
                        .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentTemplateId);

                boolean allSubsCompleted = subCCs != null && !subCCs.isEmpty() && subCCs.stream()
                        .allMatch(sub -> sub.getStatus() == ComplianceStatus.COMPLETED);

                for (CompanyCompliance parentCC : parentCCs) {
                    if (allSubsCompleted) {
                        parentCC.setStatus(ComplianceStatus.COMPLETED);
                        parentCC.setCompletedAt(now);
                        parentCC.setCompletedBy(adminId);
                        companyComplianceRepository.save(parentCC);

                        // Sync parent EmployeeAssignments
                        Optional<ComplianceConfig> pConfig = configRepository.findByCompanyComplianceId(parentCC.getId());
                        if (pConfig.isPresent()) {
                            List<EmployeeAssignment> parentAssigns = assignmentRepository.findByConfigIdAndIsActiveTrue(pConfig.get().getId());
                            for (EmployeeAssignment pa : parentAssigns) {
                                pa.setCompletedAt(now);
                                pa.setCompletedBy(adminId);
                                assignmentRepository.save(pa);
                            }
                        }
                    } else {
                        parentCC.setStatus(ComplianceStatus.IN_PROGRESS);
                        companyComplianceRepository.save(parentCC);
                    }
                }
            }
        }

        String complianceName = companyCompliance.getSubTemplate() != null
                ? companyCompliance.getSubTemplate().getName()
                : (companyCompliance.getTemplate() != null ? companyCompliance.getTemplate().getName() : "Compliance");
        String companyName = companyCompliance.getCompany() != null ? companyCompliance.getCompany().getName() : "Company";

        // Push to completing Company Admin
        notificationEventService.notifyUserPushOnly(
                adminId,
                "Compliance Completed",
                "You have marked compliance \"" + complianceName + "\" as completed.",
                NotificationType.COMPLIANCE_COMPLETED,
                "compliance_details"
        );

        // Push to all assigned employees under this compliance
        if (config != null) {
            List<Long> assignedEmpIds = assignmentRepository.findByConfigIdAndIsActiveTrue(config.getId())
                    .stream()
                    .map(EmployeeAssignment::getEmployeeId)
                    .filter(Objects::nonNull)
                    .distinct()
                    .collect(Collectors.toList());
            if (!assignedEmpIds.isEmpty()) {
                notificationEventService.notifyUsersPushOnly(
                        assignedEmpIds,
                        "Compliance Completed",
                        "Compliance \"" + complianceName + "\" has been marked as completed by your Company Admin.",
                        NotificationType.COMPLIANCE_COMPLETED,
                        "employee_compliance"
                );
            }
        }

        // Push to SuperAdmins
        notificationEventService.notifySuperAdminsWithSave(
                "Compliance Completed",
                "Company " + companyName + " completed compliance \"" + complianceName + "\" and marked as completed.",
                NotificationType.COMPLIANCE_COMPLETED,
                "compliance_details"
        );
    }

    @Transactional
    public List<EmployeeComplianceDTO> getEmployeeCategories(Long employeeId) {
        log.info("Fetching categories for employee: {}", employeeId);

        syncMissingSubAssignmentsForEmployee(employeeId);

        List<EmployeeAssignment> assignments = assignmentRepository
                .findByEmployeeIdAndIsActiveTrue(employeeId, Pageable.unpaged()).getContent();

        Map<Long, EmployeeComplianceDTO> categoryMap = new HashMap<>();

        for (EmployeeAssignment a : assignments) {
            if (a.getConfig() != null && a.getIsSubAssignment() != null && !a.getIsSubAssignment()) {
                EmployeeComplianceDTO dto = new EmployeeComplianceDTO();
                dto.setId(a.getId());

                if (a.getConfig().getCompanyCompliance() != null) {
                    dto.setCompanyComplianceId(a.getConfig().getCompanyCompliance().getId());
                }

                if (a.getConfig().getTemplate() != null) {
                    dto.setComplianceName(a.getConfig().getTemplate().getName());
                } else if (a.getConfig().getCompanyCompliance() != null &&
                        a.getConfig().getCompanyCompliance().getTemplate() != null) {
                    dto.setComplianceName(a.getConfig().getCompanyCompliance().getTemplate().getName());
                }

                List<EmployeeAssignment> subAssignments = assignmentRepository
                        .findByParentAssignmentIdAndIsActiveTrue(a.getId());
                dto.setTotalSubCompliances(subAssignments.size());

                long completed = subAssignments.stream()
                        .filter(sa -> sa.getCompletedAt() != null)
                        .count();
                dto.setCompletedSubCompliances((int) completed);

                if (subAssignments.size() > 0) {
                    dto.setCompletionPercentage((int) ((completed * 100) / subAssignments.size()));
                }

                if (completed == subAssignments.size() && subAssignments.size() > 0) {
                    dto.setStatus(ComplianceStatus.COMPLETED);
                } else if (subAssignments.stream().anyMatch(sa -> sa.getIsOverdue() != null && sa.getIsOverdue())) {
                    dto.setStatus(ComplianceStatus.OVERDUE);
                } else if (completed > 0) {
                    dto.setStatus(ComplianceStatus.IN_PROGRESS);
                } else {
                    dto.setStatus(ComplianceStatus.PENDING);
                }

                for (EmployeeAssignment sa : subAssignments) {
                    if (sa.getDueDate() != null && sa.getCompletedAt() == null) {
                        dto.setDueDate(sa.getDueDate());
                        break;
                    }
                }

                categoryMap.put(a.getId(), dto);
            }
        }

        return new ArrayList<>(categoryMap.values());
    }

    @Transactional
    public List<EmployeeComplianceDTO> getSubCompliancesByCategory(Long parentAssignmentId, Long employeeId) {
        log.info("Fetching sub-compliances for parent: {}", parentAssignmentId);

        syncMissingSubAssignmentsForEmployee(employeeId);

        EmployeeAssignment parent = assignmentRepository.findById(parentAssignmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Assignment not found"));

        if (!parent.getEmployeeId().equals(employeeId)) {
            throw new BusinessException("Access denied");
        }

        List<EmployeeAssignment> subAssignments = assignmentRepository
                .findByParentAssignmentIdAndIsActiveTrue(parentAssignmentId);

        return subAssignments.stream()
                .map(this::convertToEmployeeDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public void markAsCompleted(Long assignmentId, Long userId, String submissionReference, String documentUrl) {
        log.info("User {} marking assignment {} as completed", userId, assignmentId);

        EmployeeAssignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Assignment not found"));

        if (assignment.getCompletedAt() != null) {
            throw new BusinessException("This compliance is already marked as completed");
        }

        ComplianceConfig config = assignment.getConfig();
        if (config != null && config.getCompanyCompliance() != null && config.getCompanyCompliance().getStatus() == ComplianceStatus.COMPLETED) {
            throw new BusinessException("This compliance is already marked as completed");
        }

        LocalDateTime now = LocalDateTime.now();

        // 1. Mark ALL employee assignments for this specific config as completed so all assigned employees see it
        Long configId = (config != null) ? config.getId() : null;
        if (configId != null) {
            List<EmployeeAssignment> allAssigns = assignmentRepository.findByConfigIdAndIsActiveTrue(configId);
            for (EmployeeAssignment ea : allAssigns) {
                ea.setCompletedAt(now);
                ea.setCompletedBy(userId);
                if (submissionReference != null && !submissionReference.trim().isEmpty()) {
                    ea.setSubmissionReference(submissionReference);
                }
                if (documentUrl != null && !documentUrl.trim().isEmpty()) {
                    ea.setSubmissionDocumentUrl(documentUrl);
                }
                assignmentRepository.save(ea);
                addHistory(ea, "Marked as Completed",
                        "Completed by User: " + userId + ". Reference: " + (submissionReference != null ? submissionReference : "N/A"),
                        userId);
            }
        } else {
            assignment.setCompletedAt(now);
            assignment.setCompletedBy(userId);
            if (submissionReference != null) assignment.setSubmissionReference(submissionReference);
            if (documentUrl != null) assignment.setSubmissionDocumentUrl(documentUrl);
            assignmentRepository.save(assignment);
        }

        // 2. Mark CompanyCompliance as COMPLETED
        if (config != null && config.getCompanyCompliance() != null) {
            CompanyCompliance cc = config.getCompanyCompliance();
            cc.setStatus(ComplianceStatus.COMPLETED);
            cc.setCompletedAt(now);
            cc.setCompletedBy(userId);
            if (submissionReference != null && !submissionReference.trim().isEmpty()) {
                cc.setAdminSubmissionReference(submissionReference);
            }
            if (documentUrl != null && !documentUrl.trim().isEmpty()) {
                cc.setAdminSubmissionDocumentUrl(documentUrl);
            }
            companyComplianceRepository.save(cc);

            // 3. If it's a sub-compliance, update parent compliance status
            if (!Boolean.TRUE.equals(cc.getIsParent()) && cc.getCompany() != null) {
                Long companyId = cc.getCompany().getId();
                Long parentTemplateId = cc.getParentTemplateId() != null
                        ? cc.getParentTemplateId()
                        : (cc.getTemplate() != null ? cc.getTemplate().getId() : null);

                if (parentTemplateId != null) {
                    List<CompanyCompliance> parentCCs = companyComplianceRepository
                            .findByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(companyId, parentTemplateId);
                    List<CompanyCompliance> subCCs = companyComplianceRepository
                            .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentTemplateId);

                    boolean allSubsCompleted = subCCs != null && !subCCs.isEmpty() && subCCs.stream()
                            .allMatch(sub -> sub.getStatus() == ComplianceStatus.COMPLETED);

                    for (CompanyCompliance parentCC : parentCCs) {
                        if (allSubsCompleted) {
                            parentCC.setStatus(ComplianceStatus.COMPLETED);
                            parentCC.setCompletedAt(now);
                            parentCC.setCompletedBy(userId);
                            companyComplianceRepository.save(parentCC);

                            // Sync parent EmployeeAssignments
                            Optional<ComplianceConfig> pConfig = configRepository.findByCompanyComplianceId(parentCC.getId());
                            if (pConfig.isPresent()) {
                                List<EmployeeAssignment> parentAssigns = assignmentRepository.findByConfigIdAndIsActiveTrue(pConfig.get().getId());
                                for (EmployeeAssignment pa : parentAssigns) {
                                    pa.setCompletedAt(now);
                                    pa.setCompletedBy(userId);
                                    assignmentRepository.save(pa);
                                }
                            }
                        } else {
                            parentCC.setStatus(ComplianceStatus.IN_PROGRESS);
                            companyComplianceRepository.save(parentCC);
                        }
                    }
                }
            }
        }

        String completerName = "Employee";
        Long companyAdminId = null;
        try {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                completerName = user.getFullName();
                if (user.getCompany() != null && user.getCompany().getCompanyAdmin() != null) {
                    companyAdminId = user.getCompany().getCompanyAdmin().getId();
                }
            }
        } catch (Exception e) {
            // Ignore
        }

        String complianceName = "Compliance";
        String companyName = "Company";
        if (assignment.getConfig() != null && assignment.getConfig().getCompanyCompliance() != null) {
            CompanyCompliance cc = assignment.getConfig().getCompanyCompliance();
            if (cc.getSubTemplate() != null) {
                complianceName = cc.getSubTemplate().getName();
            } else if (cc.getTemplate() != null) {
                complianceName = cc.getTemplate().getName();
            }
            if (cc.getCompany() != null) {
                companyName = cc.getCompany().getName();
                if (companyAdminId == null && cc.getCompany().getCompanyAdmin() != null) {
                    companyAdminId = cc.getCompany().getCompanyAdmin().getId();
                }
            }
        }

        // 1. Push to completing user/employee
        notificationEventService.notifyUserPushOnly(
                userId,
                "Compliance Completed",
                "You have successfully completed compliance \"" + complianceName + "\".",
                NotificationType.COMPLIANCE_COMPLETED,
                "employee_compliance"
        );

        // 2. Push to Company Admin (if not the one who completed it)
        if (companyAdminId != null && !companyAdminId.equals(userId)) {
            notificationEventService.notifyUserPushOnly(
                    companyAdminId,
                    "Compliance Completed",
                    "Employee " + completerName + " completed compliance \"" + complianceName + "\".",
                    NotificationType.COMPLIANCE_COMPLETED,
                    "compliance_details"
            );
        }

        // 3. Push to other employees assigned to this same compliance config
        if (assignment.getConfig() != null) {
            List<Long> otherAssignedEmpIds = assignmentRepository.findByConfigIdAndIsActiveTrue(assignment.getConfig().getId())
                    .stream()
                    .map(EmployeeAssignment::getEmployeeId)
                    .filter(eId -> eId != null && !eId.equals(userId))
                    .distinct()
                    .collect(Collectors.toList());
            if (!otherAssignedEmpIds.isEmpty()) {
                notificationEventService.notifyUsersPushOnly(
                        otherAssignedEmpIds,
                        "Compliance Completed",
                        "Compliance \"" + complianceName + "\" has been completed by " + completerName + ".",
                        NotificationType.COMPLIANCE_COMPLETED,
                        "employee_compliance"
                );
            }
        }

        // 4. Push to SuperAdmins
        notificationEventService.notifySuperAdminsWithSave(
                "Compliance Completed",
                "Company " + companyName + " completed compliance \"" + complianceName + "\" and marked as completed.",
                NotificationType.COMPLIANCE_COMPLETED,
                "compliance_details"
        );

        log.info("Assignment {} marked as completed by user {}", assignmentId, userId);
    }

    // ==================== COMPANY ADMIN VIEW ====================

    @Transactional(readOnly = true)
    public Page<EmployeeComplianceDTO> getCompanyAssignments(Long companyId, Long employeeId, String status, Pageable pageable) {
        log.info("Fetching assignments for company: {}", companyId);

        Page<EmployeeAssignment> assignments;

        if (employeeId != null) {
            assignments = assignmentRepository.findByEmployeeIdAndIsActiveTrue(employeeId, pageable);
        } else {
            List<User> employees = userRepository.findByCompanyIdAndRoleAndDeletedFalse(
                    companyId, UserRole.EMPLOYEE, Pageable.unpaged()).getContent();

            List<EmployeeAssignment> allAssignments = new ArrayList<>();
            for (User emp : employees) {
                Page<EmployeeAssignment> empAssignments = assignmentRepository
                        .findByEmployeeIdAndIsActiveTrue(emp.getId(), pageable);
                allAssignments.addAll(empAssignments.getContent());
            }
            assignments = new PageImpl<>(allAssignments, pageable, allAssignments.size());
        }

        List<EmployeeComplianceDTO> dtos = assignments.getContent().stream()
                .filter(a -> a.getConfig() != null)
                .filter(a -> {
                    if (Boolean.FALSE.equals(a.getIsSubAssignment())) {
                        boolean hasChildSubs = assignmentRepository.existsByParentAssignmentIdAndIsActiveTrue(a.getId());
                        return !hasChildSubs;
                    }
                    return true;
                })
                .map(this::convertToEmployeeDTO)
                .collect(Collectors.toList());

        if (status != null && !status.isEmpty()) {
            dtos = dtos.stream()
                    .filter(dto -> dto.getStatus().name().equals(status))
                    .collect(Collectors.toList());
        }

        return new PageImpl<>(dtos, pageable, dtos.size());
    }

    // ==================== HELPER METHODS ====================

    private EmployeeComplianceDTO convertToEmployeeDTO(EmployeeAssignment assignment) {
        EmployeeComplianceDTO dto = new EmployeeComplianceDTO();
        dto.setId(assignment.getId());
        dto.setDueDate(assignment.getDueDate());
        dto.setIsSubAssignment(assignment.getIsSubAssignment());

        CompanyCompliance cc = null;
        if (assignment.getConfig() != null) {
            ComplianceConfig config = assignment.getConfig();
            dto.setConfigId(config.getId());
            cc = config.getCompanyCompliance();

            if (cc != null) {
                dto.setCompanyComplianceId(cc.getId());

                if (cc.getTemplate() != null) {
                    dto.setComplianceName(cc.getTemplate().getName());
                    dto.setCategory(cc.getTemplate().getName());
                    dto.setTemplateId(cc.getTemplate().getId());
                }

                if (cc.getSubTemplate() != null) {
                    dto.setSubTemplateId(cc.getSubTemplate().getId());
                    dto.setSubTemplateName(cc.getSubTemplate().getName());
                    dto.setComplianceName(cc.getSubTemplate().getName());
                } else if (config.getSubTemplate() != null) {
                    dto.setSubTemplateId(config.getSubTemplate().getId());
                    dto.setSubTemplateName(config.getSubTemplate().getName());
                    dto.setComplianceName(config.getSubTemplate().getName());
                }
            } else {
                if (config.getTemplate() != null) {
                    dto.setComplianceName(config.getTemplate().getName());
                    dto.setCategory(config.getTemplate().getName());
                    dto.setTemplateId(config.getTemplate().getId());
                }
                if (config.getSubTemplate() != null) {
                    dto.setSubTemplateId(config.getSubTemplate().getId());
                    dto.setSubTemplateName(config.getSubTemplate().getName());
                    dto.setComplianceName(config.getSubTemplate().getName());
                }
            }

            dto.setDescription(config.getDescription());
            dto.setDocumentRequired(config.getDocumentRequired());
            dto.setExternalLink(config.getExternalLink());
            dto.setInstructions(config.getInstructions());
            dto.setFrequency(config.getFrequency() != null ? config.getFrequency().name() : "ONE_TIME");
        }

        // Check completion at assignment level OR company compliance level
        boolean isCompleted = assignment.getCompletedAt() != null || (cc != null && cc.getStatus() == ComplianceStatus.COMPLETED);

        if (isCompleted) {
            dto.setStatus(ComplianceStatus.COMPLETED);
            LocalDateTime compAt = assignment.getCompletedAt() != null ? assignment.getCompletedAt() : (cc != null ? cc.getCompletedAt() : null);
            dto.setCompletedAt(compAt);

            String ref = assignment.getSubmissionReference() != null ? assignment.getSubmissionReference() : (cc != null ? cc.getAdminSubmissionReference() : null);
            dto.setSubmissionReference(ref);

            String doc = assignment.getSubmissionDocumentUrl() != null ? assignment.getSubmissionDocumentUrl() : (cc != null ? cc.getAdminSubmissionDocumentUrl() : null);
            dto.setSubmissionDocumentUrl(doc);

            Long compBy = assignment.getCompletedBy() != null ? assignment.getCompletedBy() : (cc != null ? cc.getCompletedBy() : null);
            dto.setCompletedBy(compBy);
            if (compBy != null) {
                userRepository.findById(compBy).ifPresent(u -> {
                    String roleLabel = u.getRole() == UserRole.COMPANY_ADMIN ? "Company Admin" : (u.getRole() == UserRole.SUPER_ADMIN ? "SuperAdmin" : "Employee");
                    dto.setCompletedByName(u.getFullName() != null ? u.getFullName() : (u.getFirstName() + " " + u.getLastName()));
                    dto.setCompletedByRole(roleLabel);
                });
            }
            dto.setOverdue(false);
            dto.setIsOverdue(false);
            dto.setDaysRemaining(0);
        } else if (assignment.getDueDate() != null && assignment.getDueDate().isBefore(LocalDate.now())) {
            dto.setStatus(ComplianceStatus.OVERDUE);
            dto.setDaysRemaining((int) ChronoUnit.DAYS.between(LocalDate.now(), assignment.getDueDate()));
            dto.setOverdue(true);
            dto.setIsOverdue(true);
        } else if (assignment.getDueDate() != null) {
            long days = ChronoUnit.DAYS.between(LocalDate.now(), assignment.getDueDate());
            dto.setDaysRemaining((int) days);
            dto.setStatus(days <= 7 ? ComplianceStatus.IN_PROGRESS : ComplianceStatus.PENDING);
            dto.setOverdue(false);
            dto.setIsOverdue(false);
        } else {
            dto.setStatus(ComplianceStatus.PENDING);
            dto.setDaysRemaining(0);
            dto.setOverdue(false);
            dto.setIsOverdue(false);
        }

        dto.setCanEditCompletion(false);

        if (assignment.getEmployeeId() != null) {
            userRepository.findById(assignment.getEmployeeId()).ifPresent(emp -> {
                dto.setEmployeeId(emp.getId());
                dto.setEmployeeName(emp.getFullName());
                dto.setEmployeeEmail(emp.getEmail());
            });
        }

        return dto;
    }

    private void addHistory(EmployeeAssignment assignment, String action, String remarks, Long performedBy) {
        try {
            ComplianceHistory history = new ComplianceHistory();
            if (assignment != null && assignment.getConfig() != null && assignment.getConfig().getCompanyCompliance() != null) {
                history.setCompanyCompliance(assignment.getConfig().getCompanyCompliance());
            } else {
                // If no assignment, try to find the company compliance from the config
                // This is a fallback, but we'll handle it gracefully
            }
            history.setAction(action);
            history.setRemarks(remarks);
            history.setPerformedAt(LocalDateTime.now());

            userRepository.findById(performedBy).ifPresent(history::setPerformedBy);

            historyRepository.save(history);
        } catch (Exception e) {
            log.error("Failed to add history: {}", e.getMessage());
        }
    }
}