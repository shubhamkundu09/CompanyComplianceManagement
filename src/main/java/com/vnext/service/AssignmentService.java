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

    @Transactional(readOnly = true)
    public Page<EmployeeComplianceDTO> getEmployeeAssignments(Long employeeId, String status, Pageable pageable) {
        log.info("Fetching assignments for employee: {}", employeeId);

        Page<EmployeeAssignment> assignments = assignmentRepository
                .findByEmployeeIdAndIsActiveTrue(employeeId, pageable);

        List<EmployeeComplianceDTO> dtos = assignments.getContent().stream()
                .filter(a -> a.getConfig() != null)
                .map(this::convertToEmployeeDTO)
                .collect(Collectors.toList());

        if (status != null && !status.isEmpty()) {
            dtos = dtos.stream()
                    .filter(dto -> dto.getStatus().name().equals(status))
                    .collect(Collectors.toList());
        }

        return new PageImpl<>(dtos, pageable, dtos.size());
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

        // Save admin submission data
        companyCompliance.setAdminSubmissionReference(submissionReference);
        companyCompliance.setAdminSubmissionDocumentUrl(documentUrl);
        companyCompliance.setCompletedAt(LocalDateTime.now());
        companyCompliance.setCompletedBy(adminId);

        // Mark assignments if any
        ComplianceConfig config = configRepository.findByCompanyComplianceId(companyCompliance.getId()).orElse(null);

        List<EmployeeAssignment> assignments = config != null
                ? assignmentRepository.findByConfigIdAndIsActiveTrue(config.getId())
                : List.of();

        if (assignments.isEmpty()) {
            companyCompliance.setStatus(ComplianceStatus.COMPLETED);
            companyComplianceRepository.save(companyCompliance);
            log.info("Company compliance {} marked as completed by admin (no active assignments)", companyComplianceId);

            String complianceName = companyCompliance.getSubTemplate() != null
                    ? companyCompliance.getSubTemplate().getName()
                    : (companyCompliance.getTemplate() != null ? companyCompliance.getTemplate().getName() : "Compliance");
            String companyName = companyCompliance.getCompany() != null ? companyCompliance.getCompany().getName() : "Company";

            notificationEventService.notifySuperAdminsWithSave(
                    "Compliance Completed",
                    "Company " + companyName + " completed compliance \"" + complianceName + "\" and marked as completed.",
                    NotificationType.COMPLIANCE_COMPLETED,
                    "compliance_details"
            );
            return;
        }

        boolean anyCompleted = false;
        for (EmployeeAssignment assignment : assignments) {
            if (assignment.getCompletedAt() == null) {
                LocalDateTime now = LocalDateTime.now();
                assignment.setCompletedAt(now);
                assignment.setSubmissionReference(submissionReference);
                assignment.setSubmissionDocumentUrl(documentUrl);
                assignment.setCompletedBy(adminId);
                assignmentRepository.save(assignment);
                anyCompleted = true;
                addHistory(assignment, "Marked as Completed by Admin",
                        "Completed by Admin: " + adminId + ". Reference: " + (submissionReference != null ? submissionReference : "N/A"),
                        adminId);
            }
        }

        if (!anyCompleted) {
            throw new BusinessException("All assignments are already completed");
        }

        companyCompliance.setStatus(ComplianceStatus.COMPLETED);
        companyComplianceRepository.save(companyCompliance);


        String complianceName = companyCompliance.getSubTemplate() != null
                ? companyCompliance.getSubTemplate().getName()
                : (companyCompliance.getTemplate() != null ? companyCompliance.getTemplate().getName() : "Compliance");
        String companyName = companyCompliance.getCompany() != null ? companyCompliance.getCompany().getName() : "Company";

        notificationEventService.notifySuperAdminsWithSave(
                "Compliance Completed",
                "Company " + companyName + " completed compliance \"" + complianceName + "\" and marked as completed.",
                NotificationType.COMPLIANCE_COMPLETED,
                "compliance_details"
        );
    }


    @Transactional(readOnly = true)
    public List<EmployeeComplianceDTO> getEmployeeCategories(Long employeeId) {
        log.info("Fetching categories for employee: {}", employeeId);

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

    @Transactional(readOnly = true)
    public List<EmployeeComplianceDTO> getSubCompliancesByCategory(Long parentAssignmentId, Long employeeId) {
        log.info("Fetching sub-compliances for parent: {}", parentAssignmentId);

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
            throw new BusinessException("This assignment is already completed");
        }

        LocalDateTime now = LocalDateTime.now();
        assignment.setCompletedAt(now);
        assignment.setSubmissionReference(submissionReference);
        assignment.setSubmissionDocumentUrl(documentUrl);
        assignment.setCompletedBy(userId);

        assignmentRepository.save(assignment);

        if (assignment.getConfig() != null && assignment.getConfig().getCompanyCompliance() != null) {
            CompanyCompliance cc = assignment.getConfig().getCompanyCompliance();

            if (assignment.getIsSubAssignment() != null && assignment.getIsSubAssignment()) {
                if (assignment.getParentAssignmentId() != null) {
                    List<EmployeeAssignment> siblings = assignmentRepository
                            .findByParentAssignmentIdAndIsActiveTrue(assignment.getParentAssignmentId());

                    boolean allCompleted = siblings.stream()
                            .allMatch(a -> a.getCompletedAt() != null);

                    if (allCompleted) {
                        CompanyCompliance parentCC = companyComplianceRepository
                                .findById(cc.getParentTemplateId())
                                .orElse(null);
                        if (parentCC != null) {
                            parentCC.setStatus(ComplianceStatus.COMPLETED);
                            companyComplianceRepository.save(parentCC);
                        }
                    }
                }
            } else {
                cc.setStatus(ComplianceStatus.COMPLETED);
                companyComplianceRepository.save(cc);
            }
        }

        String userName = "User #" + userId;
        try {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                userName = user.getFullName() + " (" + user.getRole().name() + ")";
            }
        } catch (Exception e) {
            // Ignore
        }

        addHistory(assignment, "Marked as Completed",
                "Completed by: " + userName + ". Reference: " + (submissionReference != null ? submissionReference : "N/A"),
                userId);

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
            }
        }

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
        dto.setCompletedAt(assignment.getCompletedAt());
        dto.setSubmissionReference(assignment.getSubmissionReference());
        dto.setSubmissionDocumentUrl(assignment.getSubmissionDocumentUrl());
        dto.setIsSubAssignment(assignment.getIsSubAssignment());

        if (assignment.getConfig() != null) {
            ComplianceConfig config = assignment.getConfig();
            dto.setConfigId(config.getId());

            if (config.getCompanyCompliance() != null) {
                CompanyCompliance cc = config.getCompanyCompliance();
                dto.setCompanyComplianceId(cc.getId());

                if (cc.getTemplate() != null) {
                    dto.setComplianceName(cc.getTemplate().getName());
                    dto.setCategory(cc.getTemplate().getName());
                    dto.setTemplateId(cc.getTemplate().getId());
                }

                if (cc.getSubTemplate() != null) {
                    dto.setSubTemplateId(cc.getSubTemplate().getId());
                    dto.setSubTemplateName(cc.getSubTemplate().getName());
                }

                dto.setStatus(cc.getStatus());
            }

            dto.setDescription(config.getDescription());
            dto.setDocumentRequired(config.getDocumentRequired());
            dto.setExternalLink(config.getExternalLink());
            dto.setInstructions(config.getInstructions());
            dto.setFrequency(config.getFrequency() != null ? config.getFrequency().name() : "ONE_TIME");
        }

        if (assignment.getDueDate() != null && assignment.getCompletedAt() == null) {
            long days = ChronoUnit.DAYS.between(LocalDate.now(), assignment.getDueDate());
            dto.setDaysRemaining((int) days);
            dto.setOverdue(days < 0);
            dto.setIsOverdue(days < 0);
        }

        userRepository.findById(assignment.getEmployeeId()).ifPresent(emp -> {
            dto.setEmployeeId(emp.getId());
            dto.setEmployeeName(emp.getFullName());
            dto.setEmployeeEmail(emp.getEmail());
        });

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