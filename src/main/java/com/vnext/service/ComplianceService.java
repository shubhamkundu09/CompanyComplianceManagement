package com.vnext.service;

import com.vnext.dto.*;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.*;
import com.vnext.security.SecurityUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ComplianceService {

    public static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");

    private final ComplianceTemplateRepository templateRepository;
    private final ComplianceSubTemplateRepository subTemplateRepository;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final ComplianceConfigRepository configRepository;
    private final EmployeeAssignmentRepository assignmentRepository;
    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final ComplianceHistoryRepository historyRepository;
    private final ComplianceDocumentRepository documentRepository;
    private final CompanyDocumentRepository companyDocumentRepository;
    private final NotificationEventService notificationEventService;

    @PersistenceContext
    private EntityManager entityManager;

    // ==================== SUPER ADMIN COMPLIANCE MANAGEMENT ====================

    // In ComplianceService.java

    @Transactional
    public ComplianceTemplateDTO createTemplate(ComplianceTemplateDTO dto, Long adminId) {
        log.info("SuperAdmin creating compliance template: {}", dto.getName());

        if (templateRepository.existsByNameAndIsCompanySpecificFalse(dto.getName())) {
            throw new BusinessException("Compliance template already exists: " + dto.getName());
        }

        ComplianceTemplate template = new ComplianceTemplate();
        template.setName(dto.getName());
        template.setDescription(dto.getDescription());
        template.setIsActive(true);
        template.setIsCompanySpecific(false);
        template.setPriority(dto.getPriority() != null ? dto.getPriority() : 0);

        // Resolve template type
        if (dto.getTemplateType() == ComplianceTemplateType.SEMI_EDITABLE || Boolean.TRUE.equals(dto.getIsSemiEditable())) {
            template.setTemplateType(ComplianceTemplateType.SEMI_EDITABLE);
            template.setIsSemiEditable(true);
            template.setEditableForCompanies(false);
        } else if (dto.getTemplateType() == ComplianceTemplateType.EDITABLE || Boolean.TRUE.equals(dto.getEditableForCompanies())) {
            template.setTemplateType(ComplianceTemplateType.EDITABLE);
            template.setIsSemiEditable(false);
            template.setEditableForCompanies(true);
        } else {
            template.setTemplateType(ComplianceTemplateType.NON_EDITABLE);
            template.setIsSemiEditable(false);
            template.setEditableForCompanies(false);
        }
        template.setCreatedBy(adminId);

        ComplianceTemplate saved = templateRepository.save(template);
        log.info("Compliance template created with ID: {} and type: {}", saved.getId(), saved.resolveTemplateType());

        // Auto-assign template to all active companies IF EDITABLE OR SEMI-EDITABLE
        if (saved.isEditable() || saved.isSemiEditable()) {
            log.info("Editable or Semi-editable compliance template created – auto‑assigning to all active companies");
            assignComplianceToAllActiveCompanies(saved.getId(), adminId);
        } else {
            log.info("Non-editable compliance template created – will be assigned after sub-compliances are configured by SuperAdmin");
        }

        notificationEventService.notifySuperAdminsPushOnly(
                "Compliance Created",
                "Compliance category \"" + saved.getName() + "\" has been created.",
                NotificationType.COMPLIANCE_CREATED,
                "compliance_details"
        );
        return convertToTemplateDTO(saved);
    }


    @Transactional
    public ComplianceTemplateDTO updateTemplate(Long id, ComplianceTemplateDTO dto, Long adminId) {
        log.info("Updating compliance template: {}", id);

        ComplianceTemplate template = templateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Compliance template not found with ID: " + id));

        if (!template.getName().equals(dto.getName()) &&
                templateRepository.existsByNameAndIsCompanySpecificFalse(dto.getName())) {
            throw new BusinessException("Compliance template name already exists: " + dto.getName());
        }

        template.setName(dto.getName());
        template.setDescription(dto.getDescription());
        template.setPriority(dto.getPriority() != null ? dto.getPriority() : 0);
        // Note: editableForCompanies is immutable once created. Do not overwrite existing value.
        template.setUpdatedBy(adminId);

        ComplianceTemplate saved = templateRepository.save(template);
        log.info("Compliance template updated with ID: {}", saved.getId());

        notificationEventService.notifySuperAdminsPushOnly(
                "Compliance Updated",
                "Compliance category \"" + saved.getName() + "\" has been updated.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        return convertToTemplateDTO(saved);
    }

    @Transactional
    public ComplianceSubTemplateDTO createSubTemplate(Long parentId, ComplianceSubTemplateDTO dto, Long adminId) {
        log.info("SuperAdmin creating sub-template for parent: {}", parentId);

        ComplianceTemplate parent = templateRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent template not found"));

        // If parent is fully editable, disallow SuperAdmin from adding global sub‑templates
        if (parent.isEditable()) {
            throw new BusinessException("This compliance is editable by companies; SuperAdmin cannot add global sub‑compliances. Companies will manage their own sub‑compliances.");
        }

        if (subTemplateRepository.existsByParentTemplateIdAndNameAndIsActiveTrue(parentId, dto.getName())) {
            throw new BusinessException("Sub-template already exists: " + dto.getName());
        }

        ComplianceSubTemplate subTemplate = new ComplianceSubTemplate();
        subTemplate.setParentTemplate(parent);
        subTemplate.setName(dto.getName());
        subTemplate.setDescription(dto.getDescription());
        subTemplate.setDisplayOrder(dto.getDisplayOrder() != null ? dto.getDisplayOrder() : 0);
        subTemplate.setIsActive(true);
        subTemplate.setCompany(null); // global
        subTemplate.setCreatedBy(adminId);

        ComplianceSubTemplate saved = subTemplateRepository.save(subTemplate);
        log.info("Sub-template created with ID: {} and displayOrder: {}", saved.getId(), saved.getDisplayOrder());

        // If parent is semi-editable, auto-assign this new sub-template to all companies that have this parent assigned!
        if (parent.isSemiEditable()) {
            log.info("Semi-editable parent template sub-compliance created – auto-distributing to assigned companies");
            List<CompanyCompliance> parentCCs = companyComplianceRepository
                    .findAllByTemplateIdAndIsParentTrueAndDeletedFalse(parentId);
            for (CompanyCompliance parentCC : parentCCs) {
                Company company = parentCC.getCompany();
                if (company != null && company.getStatus() == CompanyStatus.ACTIVE && !company.isDeleted()) {
                    boolean subExists = companyComplianceRepository
                            .existsByCompanyIdAndSubTemplateIdAndDeletedFalse(company.getId(), saved.getId());
                    if (!subExists) {
                        CompanyCompliance subCC = new CompanyCompliance();
                        subCC.setCompany(company);
                        subCC.setTemplate(parent);
                        subCC.setSubTemplate(saved);
                        subCC.setIsParent(false);
                        subCC.setParentTemplateId(parentId);
                        subCC.setStatus(ComplianceStatus.PENDING);
                        subCC.setIsActive(true);
                        subCC.setCreatedBy(adminId);
                        subCC.setIsSuperAdminConfig(true);
                        subCC.setAdminNotes("Auto-created from SuperAdmin semi-editable sub-template");
                        companyComplianceRepository.save(subCC);
                        log.info("Auto-assigned semi-editable sub-compliance {} to company {}", saved.getName(), company.getName());
                    }
                }
            }
        }

        // Add history for sub-template creation at template level
        addHistoryForTemplate(parentId, "Sub-Compliance Added",
                "Added sub-compliance: " + saved.getName() + " under parent: " + parent.getName() + " with display order: " + saved.getDisplayOrder(), adminId);

        notificationEventService.notifySuperAdminsPushOnly(
                "Sub-Compliance Created",
                "Sub-compliance \"" + saved.getName() + "\" has been created under \"" + parent.getName() + "\".",
                NotificationType.SUB_COMPLIANCE_CREATED,
                "compliance_details"
        );
        return convertToSubTemplateDTO(saved);
    }

    @Transactional
    public ComplianceSubTemplateDTO updateSubTemplate(Long id, ComplianceSubTemplateDTO dto, Long adminId) {
        log.info("Updating sub-template: {}", id);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        if (subTemplate.getParentTemplate().isEditable()) {
            throw new BusinessException("SuperAdmin cannot edit sub-compliances for editable compliance categories.");
        }

        subTemplate.setName(dto.getName());
        subTemplate.setDescription(dto.getDescription());
        subTemplate.setDisplayOrder(dto.getDisplayOrder() != null ? dto.getDisplayOrder() : 0);
        subTemplate.setUpdatedBy(adminId);

        subTemplateRepository.save(subTemplate);
        log.info("Sub-template updated successfully with displayOrder: {}", subTemplate.getDisplayOrder());

        notificationEventService.notifySuperAdminsPushOnly(
                "Sub-Compliance Updated",
                "Sub-compliance \"" + subTemplate.getName() + "\" has been updated.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        return convertToSubTemplateDTO(subTemplate);
    }

    @Transactional
    public ComplianceSubTemplateDTO updateCompanySubTemplate(Long id, Long companyId, ComplianceSubTemplateDTO dto, Long adminId) {
        log.info("CompanyAdmin updating sub-template {} for company {}", id, companyId);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        if (subTemplate.getCompany() == null || !subTemplate.getCompany().getId().equals(companyId)) {
            throw new BusinessException("You do not have permission to edit this sub-compliance.");
        }

        if (!subTemplate.getParentTemplate().isEditable()) {
            throw new BusinessException("Parent compliance is non-editable; sub-compliance cannot be modified.");
        }

        subTemplate.setName(dto.getName());
        subTemplate.setDescription(dto.getDescription());
        subTemplate.setDisplayOrder(dto.getDisplayOrder() != null ? dto.getDisplayOrder() : 0);
        subTemplate.setUpdatedBy(adminId);

        subTemplateRepository.save(subTemplate);
        log.info("Company sub-template updated successfully with ID: {}", subTemplate.getId());

        return convertToSubTemplateDTO(subTemplate);
    }

    @Transactional
    public ComplianceSubTemplateDTO toggleSubTemplateStatus(Long id) {
        log.info("Toggling sub-template status: {}", id);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        boolean newStatus = !subTemplate.getIsActive();
        subTemplate.setIsActive(newStatus);
        subTemplateRepository.updateActiveStatus(id, newStatus);

        log.info("Sub-template {} successfully", newStatus ? "activated" : "deactivated");
        return convertToSubTemplateDTO(subTemplate);
    }

    // ==================== COMPANY ADMIN: ADD SUB-COMPLIANCE TO EDITABLE PARENT ====================

    @Transactional
    public ComplianceSubTemplateDTO createCompanySubTemplate(Long parentId, Long companyId, ComplianceSubTemplateDTO dto, Long adminId) {
        log.info("CompanyAdmin creating company‑specific sub‑template for parent: {} and company: {}", parentId, companyId);

        ComplianceTemplate parent = templateRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent template not found"));

        // Only allowed if parent is editable and assigned to this company
        if (!parent.isEditable()) {
            throw new BusinessException("This compliance is not editable by companies. You cannot add sub‑compliances.");
        }

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found"));
        boolean assigned = companyComplianceRepository
                .existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parentId);
        if (!assigned) {
            throw new BusinessException("This compliance is not assigned to your company.");
        }

        // Check uniqueness per parent + company + name
        List<ComplianceSubTemplate> existing = subTemplateRepository
                .findByParentTemplateIdAndCompanyIdAndIsActiveTrueOrderByDisplayOrderAsc(parentId, companyId);
        for (ComplianceSubTemplate e : existing) {
            if (e.getName().equalsIgnoreCase(dto.getName())) {
                throw new BusinessException("Sub‑compliance with name '" + dto.getName() + "' already exists for your company under this compliance.");
            }
        }

        ComplianceSubTemplate subTemplate = new ComplianceSubTemplate();
        subTemplate.setParentTemplate(parent);
        subTemplate.setName(dto.getName());
        subTemplate.setDescription(dto.getDescription());
        subTemplate.setDisplayOrder(dto.getDisplayOrder() != null ? dto.getDisplayOrder() : 0);
        subTemplate.setIsActive(true);
        subTemplate.setCompany(company);
        subTemplate.setCreatedBy(adminId);

        ComplianceSubTemplate saved = subTemplateRepository.save(subTemplate);
        log.info("Company‑specific sub‑template created with ID: {}", saved.getId());

        // Create CompanyCompliance for this sub‑template
        CompanyCompliance subCC = new CompanyCompliance();
        subCC.setCompany(company);
        subCC.setTemplate(parent);
        subCC.setSubTemplate(saved);
        subCC.setIsParent(false);
        subCC.setParentTemplateId(parentId);
        subCC.setStatus(ComplianceStatus.PENDING);
        subCC.setIsActive(true);
        subCC.setCreatedBy(adminId);
        subCC.setIsSuperAdminConfig(false);
        subCC = companyComplianceRepository.save(subCC);

        addHistoryForCompanyCompliance(subCC, null, ComplianceStatus.PENDING,
                "Sub‑Compliance Added",
                "Company added sub‑compliance: " + saved.getName() + " under editable compliance: " + parent.getName(),
                userRepository.findById(adminId).orElse(null));

        notificationEventService.notifySuperAdminsPushOnly(
                "Company Added Sub‑Compliance",
                "Company " + company.getName() + " added sub‑compliance \"" + saved.getName() + "\" under \"" + parent.getName() + "\".",
                NotificationType.SUB_COMPLIANCE_CREATED,
                "compliance_details"
        );

        return convertToSubTemplateDTO(saved);
    }

    // ==================== GET SUB-COMPLIANCES FOR COMPANY (based on editable flag) ====================

    @Transactional(readOnly = true)
    public List<ComplianceSubTemplateDTO> getCompanySubTemplates(Long parentId, Long companyId) {
        log.info("Getting sub‑templates for parent {} and company {}", parentId, companyId);

        ComplianceTemplate parent = templateRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent template not found"));

        List<ComplianceSubTemplate> subTemplates;
        if (parent.isEditable()) {
            // For editable, fetch company‑specific sub‑templates
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIdAndIsActiveTrueOrderByDisplayOrderAsc(parentId, companyId);
        } else {
            // For non‑editable and semi-editable, fetch global sub‑templates (company IS NULL)
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIsNullAndIsActiveTrueOrderByDisplayOrderAsc(parentId);
        }

        return subTemplates.stream()
                .map(this::convertToSubTemplateDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getEditableTemplateCompanySubCompliances(Long templateId) {
        log.info("Fetching company sub-compliances for editable template: {}", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Compliance template not found with ID: " + templateId));

        if (!template.isEditable()) {
            throw new BusinessException("This compliance template is not editable.");
        }

        List<CompanyCompliance> parentCCs = companyComplianceRepository
                .findByTemplateIdAndIsParentTrue(templateId);

        List<Map<String, Object>> companyList = new ArrayList<>();

        for (CompanyCompliance parentCC : parentCCs) {
            Company company = parentCC.getCompany();
            if (company == null || company.isDeleted()) continue;

            Map<String, Object> companyMap = new HashMap<>();
            companyMap.put("companyId", company.getId());
            companyMap.put("companyName", company.getName());
            companyMap.put("registrationNumber", company.getRegistrationNumber());

            List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIdAndIsActiveTrueOrderByDisplayOrderAsc(templateId, company.getId());

            List<Map<String, Object>> subList = new ArrayList<>();
            for (ComplianceSubTemplate sub : subTemplates) {
                Map<String, Object> subMap = new HashMap<>();
                subMap.put("id", sub.getId());
                subMap.put("name", sub.getName());
                subMap.put("description", sub.getDescription());
                subMap.put("displayOrder", sub.getDisplayOrder());

                Optional<CompanyCompliance> subCCOpt = companyComplianceRepository
                        .findByCompanyIdAndSubTemplateId(company.getId(), sub.getId());

                if (subCCOpt.isPresent()) {
                    CompanyCompliance subCC = subCCOpt.get();
                    subMap.put("companyComplianceId", subCC.getId());

                    Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(subCC.getId());
                    if (configOpt.isEmpty() && sub.getId() != null) {
                        configOpt = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(sub.getId());
                    }
                    boolean isConfigured = configOpt.isPresent();
                    subMap.put("isConfigured", isConfigured);

                    ComplianceStatus currentStatus = subCC.getStatus() != null ? subCC.getStatus() : ComplianceStatus.PENDING;
                    String completedByName = null;
                    LocalDateTime completedAt = subCC.getCompletedAt();
                    String submissionReference = subCC.getAdminSubmissionReference();
                    String submissionDocumentUrl = subCC.getAdminSubmissionDocumentUrl();

                    if (subCC.getCompletedBy() != null) {
                        User completedUser = userRepository.findById(subCC.getCompletedBy()).orElse(null);
                        if (completedUser != null) {
                            completedByName = completedUser.getFullName();
                        }
                    }

                    if (configOpt.isPresent()) {
                        ComplianceConfig config = configOpt.get();
                        subMap.put("frequency", config.getFrequency() != null ? config.getFrequency().name() : null);
                        LocalDate dueDate = calculateEffectiveDueDate(config);
                        subMap.put("dueDate", dueDate != null ? dueDate.toString() : null);

                        // Check employee assignments for completion
                        Optional<EmployeeAssignment> completedAssignment = assignmentRepository
                                .findByConfigIdAndIsActiveTrue(config.getId())
                                .stream().filter(a -> a.getCompletedAt() != null).findFirst();

                        if (completedAssignment.isPresent()) {
                            EmployeeAssignment a = completedAssignment.get();
                            currentStatus = ComplianceStatus.COMPLETED;
                            completedAt = a.getCompletedAt();
                            if (a.getSubmissionReference() != null) submissionReference = a.getSubmissionReference();
                            if (a.getSubmissionDocumentUrl() != null) submissionDocumentUrl = a.getSubmissionDocumentUrl();

                            if (a.getCompletedBy() != null) {
                                User u = userRepository.findById(a.getCompletedBy()).orElse(null);
                                if (u != null) completedByName = u.getFullName();
                            } else if (a.getEmployeeId() != null) {
                                User u = userRepository.findById(a.getEmployeeId()).orElse(null);
                                if (u != null) completedByName = u.getFullName();
                            }

                            if (subCC.getStatus() != ComplianceStatus.COMPLETED) {
                                subCC.setStatus(ComplianceStatus.COMPLETED);
                                subCC.setCompletedAt(completedAt);
                                if (a.getCompletedBy() != null) subCC.setCompletedBy(a.getCompletedBy());
                                companyComplianceRepository.save(subCC);
                            }
                        } else if (subCC.getStatus() == ComplianceStatus.COMPLETED || subCC.getCompletedAt() != null) {
                            currentStatus = ComplianceStatus.COMPLETED;
                            if (subCC.getStatus() != ComplianceStatus.COMPLETED) {
                                subCC.setStatus(ComplianceStatus.COMPLETED);
                                companyComplianceRepository.save(subCC);
                            }
                        } else if (dueDate != null && dueDate.isBefore(LocalDate.now())) {
                            currentStatus = ComplianceStatus.OVERDUE;
                        }
                    } else if (subCC.getStatus() == ComplianceStatus.COMPLETED || subCC.getCompletedAt() != null) {
                        currentStatus = ComplianceStatus.COMPLETED;
                    }

                    subMap.put("status", currentStatus.name());
                    subMap.put("completedAt", completedAt != null ? completedAt.toString() : null);
                    subMap.put("completedByName", completedByName);
                    subMap.put("submissionReference", submissionReference);
                    subMap.put("submissionDocumentUrl", submissionDocumentUrl);
                } else {
                    subMap.put("isConfigured", false);
                    subMap.put("status", ComplianceStatus.PENDING.name());
                    subMap.put("completedAt", null);
                    subMap.put("completedByName", null);
                    subMap.put("submissionReference", null);
                    subMap.put("submissionDocumentUrl", null);
                }
                subList.add(subMap);
            }

            companyMap.put("subCompliancesCount", subList.size());
            companyMap.put("subCompliances", subList);

            companyList.add(companyMap);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("templateId", template.getId());
        result.put("templateName", template.getName());
        result.put("companiesCount", companyList.size());
        result.put("companies", companyList);

        return result;
    }

    // ==================== ASSIGNMENT METHODS ====================

    /**
     * Assigns a compliance template to a single company.
     * For non‑editable templates, it also creates sub‑compliances (if any) and copies
     * their configurations. For editable templates, only the parent is created.
     *
     * @param templateId ID of the compliance template
     * @param companyId  ID of the company
     * @param adminId    ID of the admin performing the assignment (SuperAdmin)
     */
    @Transactional
    public void assignComplianceToCompany(Long templateId, Long companyId, Long adminId) {
        assignComplianceToCompany(templateId, companyId, adminId, true);
    }

    @Transactional
    public void assignComplianceToCompany(Long templateId, Long companyId, Long adminId, boolean sendNotifications) {
        log.info("=== Assigning compliance template {} to company {} (sendNotifications={}) ===", templateId, companyId, sendNotifications);

        User admin = userRepository.findById(adminId)
                .orElseThrow(() -> new ResourceNotFoundException("Admin not found with ID: " + adminId));

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found with ID: " + templateId));

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        // Check if there is already a live parent assignment for this company+template
        List<CompanyCompliance> allExistingForPair = companyComplianceRepository
                .findAllByCompanyIdAndTemplateId(companyId, templateId);

        boolean hasLiveParent = allExistingForPair.stream()
                .anyMatch(cc -> cc.isParent() && Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted());

        if (hasLiveParent) {
            log.warn("Compliance already assigned to company: {}", companyId);
            throw new BusinessException("Compliance is already assigned to this company");
        }

        // Purge any leftover soft-deleted or orphaned records for a clean reassignment
        if (!allExistingForPair.isEmpty()) {
            log.info("Purging {} leftover compliance record(s) for company {} / template {} before reassigning",
                    allExistingForPair.size(), companyId, templateId);
            for (CompanyCompliance cc : allExistingForPair) {
                deleteCompanyCompliancePermanently(cc);
            }
        }

        // Determine if parent is editable or semi-editable
        boolean editable = template.isEditable();
        boolean semiEditable = template.isSemiEditable();

        // For non-editable and semi-editable templates, fetch global sub-templates
        List<ComplianceSubTemplate> subTemplates = new ArrayList<>();
        Map<Long, ComplianceConfig> subTemplateConfigMap = new HashMap<>();

        if (!editable) {
            // Only fetch sub‑templates if NOT editable (global sub‑templates from SuperAdmin)
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIsNullAndIsActiveTrueOrderByDisplayOrderAsc(templateId);
            if (!semiEditable) {
                for (ComplianceSubTemplate sub : subTemplates) {
                    Optional<ComplianceConfig> configOpt = configRepository
                            .findBySubTemplateIdAndCompanyComplianceIsNull(sub.getId());
                    if (configOpt.isPresent()) {
                        subTemplateConfigMap.put(sub.getId(), configOpt.get());
                    }
                }
            }
        }

        // Get parent‑level config (only if non‑editable and no sub‑templates)
        ComplianceConfig parentTemplateConfig = null;
        if (!editable && !semiEditable && subTemplates.isEmpty()) {
            parentTemplateConfig = template.getDirectConfig();
        }

        // 1. Create parent CompanyCompliance (always, for editable, semi-editable, and non‑editable)
        CompanyCompliance parentCC = new CompanyCompliance();
        parentCC.setCompany(company);
        parentCC.setTemplate(template);
        parentCC.setIsParent(true);
        parentCC.setParentTemplateId(null);
        parentCC.setStatus(ComplianceStatus.IN_PROGRESS);
        parentCC.setIsActive(true);
        parentCC.setCreatedBy(adminId);
        parentCC.setIsSuperAdminConfig(true);
        parentCC.setAdminNotes("Auto-assigned on company creation");
        parentCC = companyComplianceRepository.save(parentCC);
        log.info("Created parent CompanyCompliance ID: {}", parentCC.getId());

        // 2. Create sub‑compliances if not fully editable and sub‑templates exist
        if (!editable && !subTemplates.isEmpty()) {
            for (ComplianceSubTemplate subTemplate : subTemplates) {
                CompanyCompliance subCC = new CompanyCompliance();
                subCC.setCompany(company);
                subCC.setTemplate(template);
                subCC.setSubTemplate(subTemplate);
                subCC.setIsParent(false);
                subCC.setParentTemplateId(templateId);
                subCC.setStatus(semiEditable ? ComplianceStatus.PENDING : ComplianceStatus.IN_PROGRESS);
                subCC.setIsActive(true);
                subCC.setCreatedBy(adminId);
                subCC.setIsSuperAdminConfig(true);
                subCC.setAdminNotes("Auto-assigned on company creation");
                subCC = companyComplianceRepository.save(subCC);
                log.info("Created sub CompanyCompliance ID: {} for sub-template: {}", subCC.getId(), subTemplate.getId());

                // Copy configuration from template‑level to company‑specific config only for non-editable
                if (!semiEditable) {
                    ComplianceConfig sourceConfig = subTemplateConfigMap.get(subTemplate.getId());
                    if (sourceConfig != null) {
                        copyConfigToCompany(sourceConfig, subCC, adminId);
                    }
                }
            }
        } else if (!editable && !semiEditable && parentTemplateConfig != null) {
            // No sub‑templates, parent has config (non‑editable, single‑level)
            copyConfigToCompany(parentTemplateConfig, parentCC, adminId);
        } else {
            // Editable: only parent created, no sub‑compliances.
            log.info("Compliance assigned; sub-compliances managed according to template type: {}", template.resolveTemplateType());
        }

        // Add history for the parent assignment
        addHistoryForCompanyCompliance(parentCC, null, parentCC.getStatus(),
                "Compliance Assigned",
                "Compliance auto-assigned on company creation: " + template.getName() +
                        (editable ? " (editable)" : (semiEditable ? " (semi-editable)" : "")),
                admin);

        log.info("=== Compliance assigned successfully to company: {} ===", companyId);

        // Notifications (only if single direct assignment, not inside bulk loops)
        if (sendNotifications) {
            notificationEventService.notifySuperAdminsPushOnly(
                    "Company Assigned to Compliance",
                    "Company " + company.getName() + " has been assigned to \"" + template.getName() + "\".",
                    NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                    "compliance_details"
            );

            notificationEventService.notifyCompanyAdminsPushOnly(
                    companyId,
                    "New Compliance Assigned",
                    "Compliance \"" + template.getName() + "\" has been assigned to your company.",
                    NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                    "compliance_details"
            );
        }
    }

    @Transactional
    public void assignComplianceToCompanies(ComplianceAssignDTO assignDTO, Long adminId) {
        log.info("Assigning compliance template {} to {} companies", assignDTO.getTemplateId(), assignDTO.getCompanyIds().size());

        ComplianceTemplate template = templateRepository.findById(assignDTO.getTemplateId())
                .orElse(null);
        String templateName = template != null ? template.getName() : "Compliance";

        int successCount = 0;
        List<Long> assignedCompanyIds = new ArrayList<>();
        for (Long companyId : assignDTO.getCompanyIds()) {
            try {
                assignComplianceToCompany(assignDTO.getTemplateId(), companyId, adminId, false);
                successCount++;
                assignedCompanyIds.add(companyId);
            } catch (BusinessException e) {
                log.warn("Skipping company {}: {}", companyId, e.getMessage());
            } catch (Exception e) {
                log.error("Failed to assign to company {}: {}", companyId, e.getMessage(), e);
            }
        }

        if (successCount > 0) {
            notificationEventService.notifySuperAdminsPushOnly(
                    "Compliance Assigned",
                    "Compliance \"" + templateName + "\" assigned to " + successCount + " companies.",
                    NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                    "compliance_details"
            );
            for (Long cid : assignedCompanyIds) {
                notificationEventService.notifyCompanyAdminsPushOnly(
                        cid,
                        "New Compliance Assigned",
                        "Compliance \"" + templateName + "\" has been assigned to your company.",
                        NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                        "compliance_details"
                );
            }
        }
    }

    @Transactional
    public void assignComplianceToAllActiveCompanies(Long templateId, Long adminId) {
        log.info("Manually assigning compliance template {} to all active companies", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found"));

        List<Company> activeCompanies = companyRepository.findActiveCompaniesByStatus(CompanyStatus.ACTIVE);
        if (activeCompanies.isEmpty()) {
            throw new BusinessException("No active companies found to assign compliance");
        }

        int successCount = 0;
        for (Company company : activeCompanies) {
            try {
                assignComplianceToCompany(templateId, company.getId(), adminId, false);
                successCount++;
            } catch (BusinessException e) {
                log.warn("Skipping company {}: {}", company.getId(), e.getMessage());
            } catch (Exception e) {
                log.error("Failed to assign to company {}: {}", company.getId(), e.getMessage(), e);
            }
        }

        if (successCount > 0) {
            notificationEventService.notifySuperAdminsPushOnly(
                    "Compliance Assigned to All Companies",
                    "Compliance \"" + template.getName() + "\" has been assigned to " + successCount + " active companies.",
                    NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                    "compliance_details"
            );
            notificationEventService.notifyAllActiveCompanyAdminsPushOnly(
                    "New Compliance Assigned",
                    "Compliance \"" + template.getName() + "\" has been assigned to your company.",
                    NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                    "compliance_details"
            );
        }
    }

    // ==================== GET PARENT COMPLIANCE DETAILS ====================

    @Transactional
    public ParentComplianceDetailsDTO getParentComplianceDetails(Long parentId, Long companyId) {
        log.info("Getting parent compliance details for ID: {} and company: {}", parentId, companyId);

        if (companyId != null) {
            renewCompletedRecurringCompliancesForCompany(companyId);
        }

        CompanyCompliance parentCC = null;

        // Try 1: Find by companyId and templateId (as parent)
        parentCC = companyComplianceRepository
                .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parentId)
                .orElse(null);

        // Try 2: Find by CompanyCompliance primary key ID
        if (parentCC == null) {
            CompanyCompliance byId = companyComplianceRepository.findById(parentId).orElse(null);
            if (byId != null && byId.getCompany().getId().equals(companyId)) {
                if (byId.isParent()) {
                    parentCC = byId;
                } else if (byId.getTemplate() != null) {
                    Long tId = byId.getParentTemplateId() != null ? byId.getParentTemplateId() : byId.getTemplate().getId();
                    parentCC = companyComplianceRepository
                            .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, tId)
                            .orElse(null);
                }
            }
        }

        // Try 3: Find by companyId and any compliance under templateId
        if (parentCC == null) {
            List<CompanyCompliance> byTemplate = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndDeletedFalse(companyId, parentId);
            if (!byTemplate.isEmpty()) {
                parentCC = byTemplate.stream().filter(CompanyCompliance::isParent).findFirst()
                        .orElse(byTemplate.get(0));
            }
        }

        if (parentCC == null) {
            throw new ResourceNotFoundException("Parent compliance not found with ID/Template ID: " + parentId);
        }

        if (!parentCC.getCompany().getId().equals(companyId)) {
            throw new BusinessException("This compliance does not belong to your company");
        }

        ParentComplianceDetailsDTO dto = new ParentComplianceDetailsDTO();
        dto.setId(parentCC.getId());
        dto.setTemplateId(parentCC.getTemplate().getId());
        dto.setTemplateName(parentCC.getTemplate().getName());
        dto.setTemplateDescription(parentCC.getTemplate().getDescription());
        dto.setIsSuperAdminConfig(parentCC.getIsSuperAdminConfig());
        dto.setIsActive(parentCC.getIsActive());
        dto.setStatus(parentCC.getStatus());
        dto.setAssignedAt(parentCC.getCreatedAt());

        Boolean isCompanySpecific = parentCC.getTemplate().getIsCompanySpecific();
        dto.setIsCompanySpecific(isCompanySpecific);
        dto.setCompanyId(parentCC.getCompany().getId());

        // Determine if company can manage (add sub‑compliances)
        Boolean editable = parentCC.getTemplate().isEditable();
        Boolean semiEditable = parentCC.getTemplate().isSemiEditable();
        dto.setCanManage(editable != null && editable);
        dto.setEditableForCompanies(editable);
        dto.setIsSemiEditable(semiEditable);
        dto.setTemplateType(parentCC.getTemplate().resolveTemplateType());

        // Get sub‑compliances based on editable flag
        List<CompanyCompliance> subCompliances;
        if (Boolean.TRUE.equals(editable)) {
            subCompliances = companyComplianceRepository
                    .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentCC.getTemplate().getId());
        } else {
            // For non‑editable and semi-editable, fetch all sub‑compliances for this company and parent
            subCompliances = companyComplianceRepository
                    .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentCC.getTemplate().getId());
        }

        dto.setTotalSubCompliances(subCompliances.size());

        int configuredCount = 0;
        List<ParentComplianceDetailsDTO.SubComplianceInfoDTO> subDtoList = new ArrayList<>();

        for (CompanyCompliance subCC : subCompliances) {
            ParentComplianceDetailsDTO.SubComplianceInfoDTO subDto = new ParentComplianceDetailsDTO.SubComplianceInfoDTO();
            subDto.setId(subCC.getId());

            if (subCC.getSubTemplate() != null) {
                subDto.setSubTemplateId(subCC.getSubTemplate().getId());
                subDto.setName(subCC.getSubTemplate().getName());
                subDto.setDescription(subCC.getSubTemplate().getDescription());
                subDto.setIsCompanySpecific(subCC.getTemplate().getIsCompanySpecific());
            } else {
                subDto.setName("Sub-Compliance #" + (subDtoList.size() + 1));
                subDto.setIsCompanySpecific(false);
            }

            subDto.setIsActive(subCC.getIsActive());
            subDto.setStatus(subCC.getStatus());
            subDto.setIsSemiEditable(semiEditable);
            subDto.setCanConfigure(Boolean.TRUE.equals(semiEditable) || Boolean.TRUE.equals(editable));
            subDto.setCanDelete(Boolean.TRUE.equals(editable) && !Boolean.TRUE.equals(semiEditable));

            boolean hasConfig = configRepository.existsByCompanyComplianceId(subCC.getId());
            subDto.setIsConfigured(hasConfig);

            if (hasConfig) {
                configuredCount++;
                configRepository.findByCompanyComplianceId(subCC.getId()).ifPresent(config -> {
                    if (config.getFrequency() != null) {
                        subDto.setFrequency(config.getFrequency().name());
                    }
                    LocalDate effectiveDueDate = config.getDueDate() != null ? config.getDueDate()
                            : (config.getCustomDueDate() != null ? config.getCustomDueDate() : calculateEffectiveDueDate(config));
                    if (effectiveDueDate != null) {
                        subDto.setDueDate(effectiveDueDate.atStartOfDay());
                        if (subDto.getStatus() != ComplianceStatus.COMPLETED && subCC.getCompletedAt() == null) {
                            if (effectiveDueDate.isBefore(LocalDate.now(IST_ZONE))) {
                                subDto.setStatus(ComplianceStatus.OVERDUE);
                            } else if (subDto.getStatus() == ComplianceStatus.OVERDUE) {
                                subDto.setStatus(ComplianceStatus.IN_PROGRESS);
                            }
                        }
                    }
                    subDto.setInstructions(config.getInstructions());
                    subDto.setDocumentRequired(config.getDocumentRequired());
                    subDto.setExternalLink(config.getExternalLink());
                    subDto.setReminderDaysBefore(config.getFrequency() != null ? config.getReminderDaysBefore() : null);
                });
            }

            subDtoList.add(subDto);
        }

        dto.setConfiguredSubCompliances(configuredCount);
        dto.setSubCompliances(subDtoList);

        if (subCompliances.isEmpty()) {
            boolean hasParentConfig = configRepository.existsByCompanyComplianceId(parentCC.getId());
            dto.setIsConfigured(hasParentConfig);
        } else {
            dto.setIsConfigured(configuredCount > 0);
        }

        return dto;
    }

    // ==================== COMPLIANCE CONFIGURATION ====================

    @Transactional
    public ComplianceConfigDTO configureCompliance(Long templateId, ComplianceConfigDTO dto, Long adminId) {
        log.info("Configuring compliance template: {}", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found"));

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(templateId);

        if (!subTemplates.isEmpty()) {
            throw new BusinessException("Cannot configure parent compliance that has sub-compliances. Please configure sub-compliances individually.");
        }

        ComplianceConfig config = template.getDirectConfig();
        if (config == null) {
            config = new ComplianceConfig();
            config.setTemplate(template);
        }

        config.setFrequency(dto.getFrequency());
        if (dto.getFrequency() == null) {
            config.setDueDate(null);
            config.setCustomDueDate(null);
            config.setDueDayOfMonth(null);
            config.setDueQuarter(null);
            config.setDueHalf(null);
            config.setDueMonth(null);
            config.setReminderDaysBefore(null);
            config.setRepeatReminder(null);
            config.setReminderIntervalDays(null);
        } else {
            config.setCustomDueDate(dto.getCustomDueDate());
            config.setDueDayOfMonth(dto.getDueDayOfMonth());
            config.setDueQuarter(dto.getDueQuarter());
            config.setDueHalf(dto.getDueHalf());
            config.setDueMonth(dto.getDueMonth());
            config.setDueDate(dto.getDueDate() != null ? dto.getDueDate() : calculateEffectiveDueDate(config));
            config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
            config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
            config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
        }

        config.setDescription(dto.getDescription());
        config.setDocumentRequired(dto.getDocumentRequired());
        config.setExternalLink(dto.getExternalLink());
        config.setInstructions(dto.getInstructions());
        config.setIsActive(true);
        config.setConfiguredBy(adminId);
        config.setIsSuperAdminConfig(true);

        ComplianceConfig saved = configRepository.save(config);

        // Auto‑assign to all active companies
        createConfigForTemplate(template, dto, adminId, true);

        addHistoryForTemplate(templateId, "Compliance Configured",
                "Configured compliance with frequency: " + (dto.getFrequency() != null ? dto.getFrequency().getDisplayName() : "None") +
                        (dto.getDueDate() != null ? ", Due: " + dto.getDueDate().toString() : ""), adminId);

        // Notifications
        notificationEventService.notifyAllActiveCompanyAdminsPushOnly(
                "New Compliance Configured",
                "SuperAdmin configured compliance \"" + template.getName() + "\" and it is now assigned to your company.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        notificationEventService.notifySuperAdminsPushOnly(
                "Compliance Configured Successfully",
                "Compliance \"" + template.getName() + "\" details with configurations saved successfully.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );
        return convertToConfigDTO(saved);
    }

    @Transactional
    public ComplianceConfigDTO configureSubCompliance(Long subTemplateId, ComplianceConfigDTO dto, Long adminId) {
        log.info("Configuring sub-compliance: {}", subTemplateId);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findByIdAndIsActiveTrue(subTemplateId)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        if (subTemplate.getParentTemplate().isEditable() || subTemplate.getParentTemplate().isSemiEditable()) {
            throw new BusinessException("SuperAdmin cannot configure sub-compliances for editable or semi-editable compliance categories. Companies manage their own sub-compliances.");
        }

        // Get or create template‑level config
        Optional<ComplianceConfig> existingTemplateConfig = configRepository
                .findBySubTemplateIdAndCompanyComplianceIsNull(subTemplateId);
        ComplianceConfig templateConfig;
        if (existingTemplateConfig.isPresent()) {
            templateConfig = existingTemplateConfig.get();
            log.info("Updating existing template‑level config for sub‑template: {}", subTemplateId);
        } else {
            templateConfig = new ComplianceConfig();
            templateConfig.setSubTemplate(subTemplate);
            log.info("Creating new template‑level config for sub‑template: {}", subTemplateId);
        }

        templateConfig.setFrequency(dto.getFrequency());
        if (dto.getFrequency() == null) {
            templateConfig.setDueDate(null);
            templateConfig.setCustomDueDate(null);
            templateConfig.setDueDayOfMonth(null);
            templateConfig.setDueQuarter(null);
            templateConfig.setDueHalf(null);
            templateConfig.setDueMonth(null);
            templateConfig.setReminderDaysBefore(null);
            templateConfig.setRepeatReminder(null);
            templateConfig.setReminderIntervalDays(null);
        } else {
            templateConfig.setCustomDueDate(dto.getCustomDueDate());
            templateConfig.setDueDayOfMonth(dto.getDueDayOfMonth());
            templateConfig.setDueQuarter(dto.getDueQuarter());
            templateConfig.setDueHalf(dto.getDueHalf());
            templateConfig.setDueMonth(dto.getDueMonth());
            templateConfig.setDueDate(dto.getDueDate() != null ? dto.getDueDate() : calculateEffectiveDueDate(templateConfig));
            templateConfig.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
            templateConfig.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
            templateConfig.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
        }

        templateConfig.setDescription(dto.getDescription());
        templateConfig.setDocumentRequired(dto.getDocumentRequired());
        templateConfig.setExternalLink(dto.getExternalLink());
        templateConfig.setInstructions(dto.getInstructions());
        templateConfig.setIsActive(true);
        templateConfig.setConfiguredBy(adminId);
        templateConfig.setIsSuperAdminConfig(true);
        templateConfig.setTemplate(null); // important: for sub‑template configs, template_id must be null

        templateConfig = configRepository.save(templateConfig);

        // Propagate to all company‑specific configs
        List<Company> activeCompanies = companyRepository.findActiveCompaniesByStatus(CompanyStatus.ACTIVE);
        int assignedCount = 0;

        for (Company company : activeCompanies) {
            // Ensure parent CompanyCompliance exists for this company
            CompanyCompliance parentCC = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(company.getId(), subTemplate.getParentTemplate().getId())
                    .orElse(null);
            if (parentCC == null) {
                parentCC = new CompanyCompliance();
                parentCC.setCompany(company);
                parentCC.setTemplate(subTemplate.getParentTemplate());
                parentCC.setIsParent(true);
                parentCC.setIsActive(true);
                parentCC.setStatus(ComplianceStatus.IN_PROGRESS);
                parentCC.setIsSuperAdminConfig(true);
                parentCC.setCreatedBy(adminId);
                parentCC.setAdminNotes("Auto-created parent category on sub-compliance configuration");
                companyComplianceRepository.save(parentCC);
            }

            CompanyCompliance companyCompliance = companyComplianceRepository
                    .findByCompanyIdAndSubTemplateId(company.getId(), subTemplateId)
                    .orElse(null);

            if (companyCompliance == null) {
                companyCompliance = new CompanyCompliance();
                companyCompliance.setCompany(company);
                companyCompliance.setTemplate(subTemplate.getParentTemplate());
                companyCompliance.setSubTemplate(subTemplate);
                companyCompliance.setIsParent(false);
                companyCompliance.setParentTemplateId(subTemplate.getParentTemplate().getId());
                companyCompliance.setStatus(ComplianceStatus.PENDING);
                companyCompliance.setIsActive(true);
                companyCompliance.setCreatedBy(adminId);
                companyCompliance.setIsSuperAdminConfig(true);
                companyCompliance = companyComplianceRepository.save(companyCompliance);
                assignedCount++;
            }

            // Get or create company config
            Optional<ComplianceConfig> existingCompanyConfig = configRepository
                    .findByCompanyComplianceId(companyCompliance.getId());
            ComplianceConfig companyConfig;
            if (existingCompanyConfig.isPresent()) {
                companyConfig = existingCompanyConfig.get();
            } else {
                companyConfig = new ComplianceConfig();
                companyConfig.setCompanyCompliance(companyCompliance);
            }

            // Copy all fields from templateConfig
            companyConfig.setFrequency(templateConfig.getFrequency());
            if (templateConfig.getFrequency() == null) {
                companyConfig.setDueDate(null);
                companyConfig.setCustomDueDate(null);
                companyConfig.setDueDayOfMonth(null);
                companyConfig.setDueQuarter(null);
                companyConfig.setDueHalf(null);
                companyConfig.setDueMonth(null);
                companyConfig.setReminderDaysBefore(null);
                companyConfig.setRepeatReminder(null);
                companyConfig.setReminderIntervalDays(null);
            } else {
                companyConfig.setCustomDueDate(templateConfig.getCustomDueDate());
                companyConfig.setDueDayOfMonth(templateConfig.getDueDayOfMonth());
                companyConfig.setDueQuarter(templateConfig.getDueQuarter());
                companyConfig.setDueHalf(templateConfig.getDueHalf());
                companyConfig.setDueMonth(templateConfig.getDueMonth());
                companyConfig.setDueDate(templateConfig.getDueDate() != null ? templateConfig.getDueDate() : calculateEffectiveDueDate(companyConfig));
                companyConfig.setReminderDaysBefore(templateConfig.getReminderDaysBefore());
                companyConfig.setRepeatReminder(templateConfig.getRepeatReminder());
                companyConfig.setReminderIntervalDays(templateConfig.getReminderIntervalDays());
            }
            companyConfig.setDescription(templateConfig.getDescription());
            companyConfig.setDocumentRequired(templateConfig.getDocumentRequired());
            companyConfig.setExternalLink(templateConfig.getExternalLink());
            companyConfig.setInstructions(templateConfig.getInstructions());
            companyConfig.setIsActive(true);
            companyConfig.setConfiguredBy(adminId);
            companyConfig.setIsSuperAdminConfig(true);

            configRepository.save(companyConfig);

            companyCompliance.setStatus(ComplianceStatus.IN_PROGRESS);
            companyComplianceRepository.save(companyCompliance);

            autoAssignSubComplianceToEmployees(companyCompliance, companyConfig, adminId);

            addHistoryForCompanyCompliance(companyCompliance, ComplianceStatus.PENDING,
                    ComplianceStatus.IN_PROGRESS, "Sub-Compliance Configured",
                    "Configured sub-compliance: " + subTemplate.getName(),
                    userRepository.findById(adminId).orElse(null));

            sendAssignmentEmailToCompany(company, subTemplate.getParentTemplate());
        }

        addHistoryForTemplate(subTemplate.getParentTemplate().getId(), "Sub-Compliance Configured",
                "Configured sub-compliance: " + subTemplate.getName() + " and assigned to " +
                        (assignedCount > 0 ? assignedCount : "existing") + " companies", adminId);

        notificationEventService.notifyAllActiveCompanyAdminsPushOnly(
                "New Sub-Compliance Configured",
                "SuperAdmin configured sub-compliance \"" + subTemplate.getName() + "\" under \"" + subTemplate.getParentTemplate().getName() + "\" and it is now assigned to your company.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        notificationEventService.notifySuperAdminsPushOnly(
                "Sub-Compliance Configured Successfully",
                "Sub-compliance \"" + subTemplate.getName() + "\" under \"" + subTemplate.getParentTemplate().getName() + "\" details with configurations saved successfully.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        return convertToConfigDTO(templateConfig);
    }

    @Transactional
    public ComplianceConfigDTO updateComplianceConfig(Long configId, Long companyId, ComplianceConfigDTO dto, Long adminId) {
        log.info("Updating compliance configuration: {}", configId);

        ComplianceConfig config = configRepository.findById(configId)
                .orElseThrow(() -> new ResourceNotFoundException("Configuration not found with ID: " + configId));

        if (config.getCompanyCompliance() != null) {
            if (!config.getCompanyCompliance().getCompany().getId().equals(companyId)) {
                throw new BusinessException("You don't have permission to update this configuration");
            }
        }

        config.setFrequency(dto.getFrequency());
        if (dto.getFrequency() == null) {
            config.setDueDate(null);
            config.setCustomDueDate(null);
            config.setDueDayOfMonth(null);
            config.setDueQuarter(null);
            config.setDueHalf(null);
            config.setDueMonth(null);
            config.setReminderDaysBefore(null);
            config.setRepeatReminder(false);
            config.setReminderIntervalDays(null);
        } else {
            config.setCustomDueDate(dto.getCustomDueDate());
            config.setDueDayOfMonth(dto.getDueDayOfMonth());
            config.setDueQuarter(dto.getDueQuarter());
            config.setDueHalf(dto.getDueHalf());
            config.setDueMonth(dto.getDueMonth());
            config.setDueDate(dto.getDueDate() != null ? dto.getDueDate() : calculateEffectiveDueDate(config));
            config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
            config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
            config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
        }
        config.setDescription(dto.getDescription());
        config.setDocumentRequired(dto.getDocumentRequired());
        config.setExternalLink(dto.getExternalLink());
        config.setInstructions(dto.getInstructions());
        config.setIsActive(true);
        config.setUpdatedBy(adminId);

        ComplianceConfig saved = configRepository.save(config);
        if (saved.getDueDate() != null) {
            assignmentRepository.updateDueDateForConfig(saved.getId(), saved.getDueDate());
        }
        log.info("Configuration updated successfully: {}", saved.getId());

        List<Long> companyAdminUserIds = new ArrayList<>();
        if (config.getCompanyCompliance() != null && config.getCompanyCompliance().getCompany() != null) {
            Company c = config.getCompanyCompliance().getCompany();
            if (c.getCompanyAdmin() != null && c.getCompanyAdmin().getId() != null) {
                companyAdminUserIds.add(c.getCompanyAdmin().getId());
            }
        }
        String configName = config.getTemplate() != null ? config.getTemplate().getName() :
                (config.getSubTemplate() != null ? config.getSubTemplate().getName() : "Compliance");

        if (!companyAdminUserIds.isEmpty()) {
            notificationEventService.notifyUsersPushOnly(
                    companyAdminUserIds,
                    "Compliance Configuration Updated",
                    "Configuration for \"" + configName + "\" has been updated.",
                    NotificationType.COMPLIANCE_CONFIG_UPDATED,
                    "compliance_details"
            );
        }

        notificationEventService.notifySuperAdminsPushOnly(
                "Compliance Configuration Updated",
                "Configuration for \"" + configName + "\" details saved successfully.",
                NotificationType.COMPLIANCE_CONFIG_UPDATED,
                "compliance_details"
        );

        return convertToConfigDTO(saved);
    }

    @Transactional
    public ComplianceConfigDTO configureSubComplianceForCompany(Long subTemplateId, Long companyId,
                                                                ComplianceConfigDTO dto, Long adminId) {
        log.info("CompanyAdmin configuring sub-compliance: {} for company: {}", subTemplateId, companyId);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findByIdAndIsActiveTrue(subTemplateId)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        // Check if this sub-template belongs to the company (if company-specific) or is global
        if (subTemplate.getCompany() != null && !subTemplate.getCompany().getId().equals(companyId)) {
            throw new BusinessException("This sub-compliance does not belong to your company.");
        }
        // If subTemplate.getCompany() is null, it's a global sub-template; the parent must be non-editable and assigned to the company.

        // Verify the parent compliance is assigned to this company
        ComplianceTemplate parent = subTemplate.getParentTemplate();
        boolean assigned = companyComplianceRepository
                .existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parent.getId());
        if (!assigned) {
            throw new BusinessException("Parent compliance is not assigned to your company.");
        }

        // Find or create CompanyCompliance for this sub-template
        CompanyCompliance companyCompliance = companyComplianceRepository
                .findByCompanyIdAndSubTemplateId(companyId, subTemplateId)
                .orElseThrow(() -> new ResourceNotFoundException("CompanyCompliance not found for this sub-template"));

        // Find existing config or create new
        ComplianceConfig config = configRepository
                .findByCompanyComplianceId(companyCompliance.getId())
                .orElse(new ComplianceConfig());

        config.setCompanyCompliance(companyCompliance);
        config.setFrequency(dto.getFrequency());
        if (dto.getFrequency() == null) {
            config.setDueDate(null);
            config.setCustomDueDate(null);
            config.setDueDayOfMonth(null);
            config.setDueQuarter(null);
            config.setDueHalf(null);
            config.setDueMonth(null);
            config.setReminderDaysBefore(null);
            config.setRepeatReminder(false);
            config.setReminderIntervalDays(null);
        } else {
            config.setCustomDueDate(dto.getCustomDueDate());
            config.setDueDayOfMonth(dto.getDueDayOfMonth());
            config.setDueQuarter(dto.getDueQuarter());
            config.setDueHalf(dto.getDueHalf());
            config.setDueMonth(dto.getDueMonth());
            config.setDueDate(dto.getDueDate() != null ? dto.getDueDate() : calculateEffectiveDueDate(config));
            config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
            config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
            config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
        }
        config.setDescription(dto.getDescription());
        config.setDocumentRequired(dto.getDocumentRequired());
        config.setExternalLink(dto.getExternalLink());
        config.setInstructions(dto.getInstructions());
        config.setIsActive(true);
        config.setConfiguredBy(adminId);
        config.setIsSuperAdminConfig(false);

        ComplianceConfig saved = configRepository.save(config);

        companyCompliance.setStatus(ComplianceStatus.IN_PROGRESS);
        companyComplianceRepository.save(companyCompliance);

        autoAssignSubComplianceToEmployees(companyCompliance, saved, adminId);

        log.info("Sub-compliance configured with config ID: {}", saved.getId());

        if (companyCompliance != null && companyCompliance.getCompany() != null) {
            notificationEventService.notifySuperAdminsPushOnly(
                    "Sub-Compliance Configured",
                    "Company " + companyCompliance.getCompany().getName() + " configured sub-compliance \"" + subTemplate.getName() + "\".",
                    NotificationType.COMPLIANCE_CONFIG_UPDATED,
                    "compliance_details"
            );
        }

        return convertToConfigDTO(saved);
    }

    @Transactional
    public void autoAssignSubComplianceToEmployees(CompanyCompliance subCC, ComplianceConfig subConfig, Long adminId) {
        if (subCC == null || subCC.getCompany() == null) return;

        Long companyId = subCC.getCompany().getId();
        Long parentTemplateId = subCC.getParentTemplateId() != null
                ? subCC.getParentTemplateId()
                : (subCC.getTemplate() != null ? subCC.getTemplate().getId() : null);

        if (parentTemplateId == null) return;

        // Find parent CompanyCompliance for this company
        CompanyCompliance parentCC = companyComplianceRepository
                .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parentTemplateId)
                .orElse(null);
        if (parentCC == null) return;

        ComplianceConfig parentConfig = configRepository.findByCompanyComplianceId(parentCC.getId()).orElse(null);
        if (parentConfig == null) return;

        // Find all active parent EmployeeAssignments for this parent config
        List<EmployeeAssignment> parentAssignments = assignmentRepository.findByConfigIdAndIsActiveTrue(parentConfig.getId());
        for (EmployeeAssignment parentAssign : parentAssignments) {
            Long employeeId = parentAssign.getEmployeeId();
            if (employeeId == null) continue;

            Optional<EmployeeAssignment> existingSubAssign = assignmentRepository
                    .findByConfigIdAndEmployeeIdAndIsActiveTrue(subConfig.getId(), employeeId);

            LocalDate subDueDate = subConfig.getFrequency() != null ? (subConfig.getDueDate() != null ? subConfig.getDueDate() : parentAssign.getDueDate()) : null;
            boolean subAlreadyCompleted = subCC.getStatus() == ComplianceStatus.COMPLETED || subCC.getCompletedAt() != null;

            if (existingSubAssign.isEmpty()) {
                EmployeeAssignment subAssign = new EmployeeAssignment();
                subAssign.setConfig(subConfig);
                subAssign.setEmployeeId(employeeId);
                subAssign.setDueDate(subDueDate);
                subAssign.setAssignedAt(LocalDateTime.now(IST_ZONE));
                subAssign.setIsActive(true);
                subAssign.setIsSubAssignment(true);
                subAssign.setParentAssignmentId(parentAssign.getId());
                if (subAlreadyCompleted) {
                    subAssign.setCompletedAt(subCC.getCompletedAt() != null ? subCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                    subAssign.setCompletedBy(subCC.getCompletedBy());
                    subAssign.setSubmissionReference(subCC.getAdminSubmissionReference());
                    subAssign.setSubmissionDocumentUrl(subCC.getAdminSubmissionDocumentUrl());
                }
                assignmentRepository.save(subAssign);
                log.info("Auto-assigned newly added sub-compliance {} to employee {}", subCC.getId(), employeeId);
            } else {
                EmployeeAssignment subAssign = existingSubAssign.get();
                subAssign.setIsActive(true);
                subAssign.setIsSubAssignment(true);
                subAssign.setParentAssignmentId(parentAssign.getId());
                if (subAssign.getDueDate() == null && subDueDate != null) {
                    subAssign.setDueDate(subDueDate);
                }
                if (subAlreadyCompleted && subAssign.getCompletedAt() == null) {
                    subAssign.setCompletedAt(subCC.getCompletedAt() != null ? subCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                    subAssign.setCompletedBy(subCC.getCompletedBy());
                    subAssign.setSubmissionReference(subCC.getAdminSubmissionReference());
                    subAssign.setSubmissionDocumentUrl(subCC.getAdminSubmissionDocumentUrl());
                }
                assignmentRepository.save(subAssign);
            }
        }
    }

    // ==================== DELETE OPERATIONS ====================

    @Transactional
    public void deleteSubTemplatePermanently(Long id) {
        log.info("Permanently deleting sub-template: {}", id);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        if (subTemplate.getParentTemplate().isEditable()) {
            throw new BusinessException("Sub-compliances under editable compliance categories can only be managed by companies.");
        }

        performSubTemplateDeletion(subTemplate);
    }

    @Transactional
    public void deleteCompanySubTemplatePermanently(Long id, Long companyId) {
        log.info("CompanyAdmin (company {}) permanently deleting sub-template {}", companyId, id);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

        if (subTemplate.getCompany() == null || !subTemplate.getCompany().getId().equals(companyId)) {
            throw new BusinessException("You do not have permission to delete this sub-compliance.");
        }

        if (!subTemplate.getParentTemplate().isEditable()) {
            throw new BusinessException("Parent compliance is non-editable; sub-compliance cannot be deleted.");
        }

        performSubTemplateDeletion(subTemplate);
    }

    private void performSubTemplateDeletion(ComplianceSubTemplate subTemplate) {
        Long id = subTemplate.getId();
        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findBySubTemplateId(id);

        log.info("Found {} CompanyCompliance records referencing sub-template {}", companyCompliances.size(), id);

        for (CompanyCompliance cc : companyCompliances) {
            Long ccId = cc.getId();
            log.info("Processing CompanyCompliance ID: {}", ccId);

            Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(ccId);
            if (configOpt.isPresent()) {
                ComplianceConfig config = configOpt.get();
                List<EmployeeAssignment> assignments = assignmentRepository
                        .findByConfigIdAndIsActiveTrue(config.getId());
                if (!assignments.isEmpty()) {
                    log.info("Deleting {} employee assignments for config ID: {}", assignments.size(), config.getId());
                    assignmentRepository.deleteAll(assignments);
                }
                configRepository.delete(config);
                log.info("Deleted config ID: {}", config.getId());
            }

            List<ComplianceHistory> histories = historyRepository.findByCompanyComplianceId(ccId);
            if (!histories.isEmpty()) {
                log.info("Deleting {} history records for CompanyCompliance ID: {}", histories.size(), ccId);
                historyRepository.deleteAll(histories);
            }

            companyComplianceRepository.delete(cc);
            log.info("Deleted CompanyCompliance ID: {}", ccId);
        }

        Optional<ComplianceConfig> templateLevelConfigOpt = configRepository
                .findBySubTemplateIdAndCompanyComplianceIsNull(id);
        if (templateLevelConfigOpt.isPresent()) {
            ComplianceConfig templateLevelConfig = templateLevelConfigOpt.get();
            log.info("Deleting template-level config ID: {} for sub-template: {}", templateLevelConfig.getId(), id);

            List<EmployeeAssignment> assignments = assignmentRepository
                    .findByConfigIdAndIsActiveTrue(templateLevelConfig.getId());
            if (!assignments.isEmpty()) {
                log.info("Deleting {} employee assignments for template-level config", assignments.size());
                assignmentRepository.deleteAll(assignments);
            }

            configRepository.delete(templateLevelConfig);
            log.info("Deleted template-level config ID: {}", templateLevelConfig.getId());
        } else {
            log.info("No template-level config found for sub-template: {}", id);
        }

        subTemplateRepository.deleteById(id);

        notificationEventService.notifySuperAdminsPushOnly(
                "Sub-Compliance Deleted",
                "Sub-compliance \"" + subTemplate.getName() + "\" has been deleted.",
                NotificationType.SUB_COMPLIANCE_DELETED,
                "compliance_details"
        );
        log.info("Sub-template permanently deleted with ID: {}", id);
    }

    @Transactional
    public void deleteTemplatePermanently(Long id) {
        log.info("Permanently deleting compliance template: {}", id);

        ComplianceTemplate template = templateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Compliance template not found with ID: " + id));

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(id);

        for (ComplianceSubTemplate subTemplate : subTemplates) {
            Long subId = subTemplate.getId();
            log.info("Deleting sub‑template ID: {}", subId);

            List<CompanyCompliance> subCompanyCompliances = companyComplianceRepository
                    .findBySubTemplateId(subId);
            List<Long> ccIds = subCompanyCompliances.stream()
                    .map(CompanyCompliance::getId)
                    .collect(Collectors.toList());

            for (Long ccId : ccIds) {
                historyRepository.deleteAll(historyRepository.findByCompanyComplianceId(ccId));
                documentRepository.deleteAll(documentRepository.findByCompanyComplianceId(ccId));
            }

            List<Long> configIdsForSubTemplate = configRepository.findConfigIdsBySubTemplateId(subId);
            for (Long configId : configIdsForSubTemplate) {
                assignmentRepository.deleteByConfigId(configId);
            }
            for (Long ccId : ccIds) {
                configRepository.findByCompanyComplianceId(ccId)
                        .ifPresent(cfg -> assignmentRepository.deleteByConfigId(cfg.getId()));
            }

            entityManager.flush();
            entityManager.clear();

            configRepository.deleteAllBySubTemplateId(subId);

            entityManager.clear();

            for (Long ccId : ccIds) {
                configRepository.findByCompanyComplianceId(ccId)
                        .ifPresent(cfg -> configRepository.deleteById(cfg.getId()));
            }

            for (Long ccId : ccIds) {
                companyComplianceRepository.deleteById(ccId);
            }

            subTemplateRepository.deleteById(subId);
            log.info("Deleted sub‑template ID: {}", subId);
        }

        List<CompanyCompliance> parentCompliances = companyComplianceRepository
                .findByTemplateIdAndIsParentTrue(id);

        for (CompanyCompliance cc : parentCompliances) {
            Long ccId = cc.getId();
            historyRepository.deleteAll(historyRepository.findByCompanyComplianceId(ccId));
            documentRepository.deleteAll(documentRepository.findByCompanyComplianceId(ccId));

            configRepository.findByCompanyComplianceId(ccId).ifPresent(config -> {
                assignmentRepository.deleteByConfigId(config.getId());
                configRepository.deleteById(config.getId());
            });

            companyComplianceRepository.deleteById(ccId);
        }

        configRepository.findByTemplateIdAndCompanyComplianceIsNull(id)
                .ifPresent(config -> {
                    assignmentRepository.deleteByConfigId(config.getId());
                    configRepository.deleteById(config.getId());
                });

        entityManager.flush();
        entityManager.clear();

        templateRepository.deleteById(id);
        log.info("Compliance template permanently deleted with ID: {}", id);

        notificationEventService.notifySuperAdminsPushOnly(
                "Compliance Deleted",
                "Compliance \"" + template.getName() + "\" has been deleted.",
                NotificationType.COMPLIANCE_DELETED,
                "compliance_templates"
        );
    }

    @Transactional
    public void deleteCustomTemplateForCompany(Long templateId, Long companyId, Long adminId) {
        log.info("CompanyAdmin (company {}) attempting to delete custom template {}", companyId, templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Compliance template not found with ID: " + templateId));

        if (!Boolean.TRUE.equals(template.getIsCompanySpecific())) {
            throw new BusinessException("Cannot delete a compliance created by SuperAdmin");
        }
        if (template.getCompany() == null || !template.getCompany().getId().equals(companyId)) {
            throw new BusinessException("You do not have permission to delete this compliance");
        }

        // Delete sub-templates and their CompanyCompliance records
        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(templateId);

        for (ComplianceSubTemplate subTemplate : subTemplates) {
            List<CompanyCompliance> subCompanyCompliances = companyComplianceRepository
                    .findBySubTemplateId(subTemplate.getId());

            for (CompanyCompliance cc : subCompanyCompliances) {
                if (!cc.getCompany().getId().equals(companyId)) {
                    continue;
                }
                deleteCompanyCompliancePermanently(cc);
            }
            subTemplateRepository.delete(subTemplate);
        }

        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findByTemplateIdAndIsParentTrue(templateId);

        for (CompanyCompliance cc : companyCompliances) {
            if (!cc.getCompany().getId().equals(companyId)) {
                continue;
            }
            deleteCompanyCompliancePermanently(cc);
        }

        templateRepository.delete(template);
        log.info("Custom compliance template {} permanently deleted by CompanyAdmin {} (company {})",
                templateId, adminId, companyId);
    }

    // ==================== ASSIGNMENT TO EMPLOYEES ====================

    @Transactional
    public void assignToEmployees(Long configId, List<Long> employeeIds, Long companyId, Long assignedBy) {
        log.info("Assigning config {} to {} employees", configId, employeeIds.size());

        ComplianceConfig config = configRepository.findById(configId)
                .orElseThrow(() -> new ResourceNotFoundException("Config not found"));

        CompanyCompliance companyCompliance = config.getCompanyCompliance();

        if (companyCompliance != null && companyCompliance.getCompany() != null && !companyCompliance.getCompany().getId().equals(companyId)) {
            throw new BusinessException("Cannot assign this compliance to employees");
        }

        for (Long employeeId : employeeIds) {
            User employee = userRepository.findById(employeeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Employee not found: " + employeeId));

            if (employee.getRole() != UserRole.EMPLOYEE) {
                log.warn("User {} is not an employee, skipping", employeeId);
                continue;
            }

            Optional<EmployeeAssignment> existing = assignmentRepository
                    .findByConfigIdAndEmployeeIdAndIsActiveTrue(config.getId(), employeeId);

            EmployeeAssignment assignment;
            if (existing.isPresent()) {
                assignment = existing.get();
                assignment.setIsActive(true);
            } else {
                assignment = new EmployeeAssignment();
                assignment.setConfig(config);
                assignment.setEmployeeId(employeeId);
                assignment.setDueDate(config.getDueDate() != null ? config.getDueDate() : calculateEffectiveDueDate(config));
                assignment.setAssignedAt(LocalDateTime.now(IST_ZONE));
                assignment.setIsActive(true);
                assignment.setIsSubAssignment(companyCompliance != null && !companyCompliance.isParent());
                assignment.setParentAssignmentId(null);
            }

            assignmentRepository.save(assignment);

            try {
                emailService.sendAssignmentEmail(
                        employee.getEmail(),
                        employee.getFirstName(),
                        getComplianceName(config),
                        assignment.getDueDate()
                );
            } catch (Exception e) {
                log.error("Failed to send assignment email to: {}", employee.getEmail(), e);
            }
        }

        addHistoryForConfig(config.getId(), "Assigned to Employees",
                "Assigned to " + employeeIds.size() + " employees", assignedBy);
    }

    @Transactional
    public void assignParentWithSubCompliances(Long parentId, Long companyId, List<Long> employeeIds, Long adminId) {
        log.info("Assigning parent compliance {} with sub-compliances to {} employees for company {}", parentId, employeeIds != null ? employeeIds.size() : 0, companyId);

        if (employeeIds == null || employeeIds.isEmpty()) {
            throw new BusinessException("Please select at least one employee");
        }

        // Support CompanyCompliance.id, templateId, or extracted template from any CompanyCompliance reference
        CompanyCompliance parentCC = companyComplianceRepository.findById(parentId).orElse(null);
        if (parentCC != null && parentCC.getCompany().getId().equals(companyId) && parentCC.isParent()) {
            // Direct parent compliance match for this company
        } else {
            Long templateIdToLookup = (parentCC != null && parentCC.getTemplate() != null)
                    ? parentCC.getTemplate().getId()
                    : parentId;
            parentCC = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, templateIdToLookup)
                    .orElse(null);

            // Fallback 1: Check if any CompanyCompliance exists for this template & company
            if (parentCC == null) {
                List<CompanyCompliance> ccs = companyComplianceRepository
                        .findByCompanyIdAndTemplateIdAndDeletedFalse(companyId, templateIdToLookup);
                if (!ccs.isEmpty()) {
                    parentCC = ccs.stream()
                            .filter(c -> c.getSubTemplate() == null || (c.getIsParent() != null && c.getIsParent()))
                            .findFirst()
                            .orElse(ccs.get(0));
                    if (parentCC.getIsParent() == null || !parentCC.getIsParent()) {
                        parentCC.setIsParent(true);
                        parentCC = companyComplianceRepository.save(parentCC);
                    }
                }
            }

            // Fallback 2: Check if template exists and auto-create parent CompanyCompliance for this company
            if (parentCC == null) {
                Optional<ComplianceTemplate> templateOpt = templateRepository.findById(templateIdToLookup);
                if (templateOpt.isPresent()) {
                    ComplianceTemplate template = templateOpt.get();
                    parentCC = new CompanyCompliance();
                    parentCC.setCompany(companyRepository.findById(companyId).orElse(null));
                    parentCC.setTemplate(template);
                    parentCC.setIsParent(true);
                    parentCC.setIsActive(true);
                    parentCC.setStatus(ComplianceStatus.PENDING);
                    parentCC = companyComplianceRepository.save(parentCC);
                }
            }
        }

if (parentCC == null) {
            throw new ResourceNotFoundException("Parent compliance not found for company " + companyId + " with ID/Template " + parentId);
        }

        // 1. Ensure parent ComplianceConfig exists
        ComplianceConfig parentConfig = configRepository.findByCompanyComplianceId(parentCC.getId()).orElse(null);
        if (parentConfig == null) {
            parentConfig = new ComplianceConfig();
            parentConfig.setCompanyCompliance(parentCC);
            parentConfig.setTemplate(null);
            parentConfig.setSubTemplate(null);
            parentConfig.setFrequency(ComplianceFrequency.YEARLY);
            parentConfig.setDueDate(calculateEffectiveDueDate(parentConfig));
            parentConfig.setIsActive(true);
            parentConfig.setConfiguredBy(adminId);
            parentConfig = configRepository.save(parentConfig);
        }

        LocalDate parentDueDate = parentConfig.getDueDate() != null ? parentConfig.getDueDate() : calculateEffectiveDueDate(parentConfig);
        if (parentConfig.getDueDate() == null && parentDueDate != null) {
            parentConfig.setDueDate(parentDueDate);
            parentConfig = configRepository.save(parentConfig);
        }

        // 2. Fetch all active sub-compliances for this company & parent template
        List<CompanyCompliance> subCompliances = companyComplianceRepository
                .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentCC.getTemplate().getId());

        // 3. For each employee, assign parent category and all sub-compliances
        for (Long employeeId : employeeIds) {
            User employee = userRepository.findById(employeeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

            if (employee.getCompany() == null || !employee.getCompany().getId().equals(companyId)) {
                log.warn("Employee {} does not belong to company {}, skipping", employeeId, companyId);
                continue;
            }

            if (employee.getRole() != UserRole.EMPLOYEE) {
                log.warn("User {} is not an employee (role: {}), skipping", employeeId, employee.getRole());
                continue;
            }

            // Create or get Parent EmployeeAssignment (isSubAssignment = false)
            Optional<EmployeeAssignment> existingParentAssign = assignmentRepository
                    .findByConfigIdAndEmployeeIdAndIsActiveTrue(parentConfig.getId(), employeeId);

            EmployeeAssignment parentAssign;
            if (existingParentAssign.isPresent()) {
                parentAssign = existingParentAssign.get();
                parentAssign.setIsActive(true);
                parentAssign.setIsSubAssignment(false);
                if (parentAssign.getDueDate() == null && parentDueDate != null) {
                    parentAssign.setDueDate(parentDueDate);
                }
                if (parentCC.getStatus() == ComplianceStatus.COMPLETED || parentCC.getCompletedAt() != null) {
                    if (parentAssign.getCompletedAt() == null) {
                        parentAssign.setCompletedAt(parentCC.getCompletedAt() != null ? parentCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                        parentAssign.setCompletedBy(parentCC.getCompletedBy());
                        parentAssign.setSubmissionReference(parentCC.getAdminSubmissionReference());
                        parentAssign.setSubmissionDocumentUrl(parentCC.getAdminSubmissionDocumentUrl());
                    }
                }
                parentAssign = assignmentRepository.save(parentAssign);
            } else {
                parentAssign = new EmployeeAssignment();
                parentAssign.setConfig(parentConfig);
                parentAssign.setEmployeeId(employeeId);
                parentAssign.setDueDate(parentDueDate);
                parentAssign.setAssignedAt(LocalDateTime.now(IST_ZONE));
                parentAssign.setIsActive(true);
                parentAssign.setIsSubAssignment(false);
                parentAssign.setParentAssignmentId(null);
                if (parentCC.getStatus() == ComplianceStatus.COMPLETED || parentCC.getCompletedAt() != null) {
                    parentAssign.setCompletedAt(parentCC.getCompletedAt() != null ? parentCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                    parentAssign.setCompletedBy(parentCC.getCompletedBy());
                    parentAssign.setSubmissionReference(parentCC.getAdminSubmissionReference());
                    parentAssign.setSubmissionDocumentUrl(parentCC.getAdminSubmissionDocumentUrl());
                }
                parentAssign = assignmentRepository.save(parentAssign);
            }

            // If there are sub-compliances, auto-assign ALL of them to this employee linked to parent assignment
            if (subCompliances != null && !subCompliances.isEmpty()) {
                for (CompanyCompliance subCC : subCompliances) {
                    ComplianceConfig subConfig = configRepository.findByCompanyComplianceId(subCC.getId()).orElse(null);
                    if (subConfig == null) {
                        subConfig = new ComplianceConfig();
                        subConfig.setCompanyCompliance(subCC);
                        subConfig.setTemplate(null);
                        subConfig.setSubTemplate(subCC.getSubTemplate());
                        subConfig.setFrequency(parentConfig.getFrequency() != null ? parentConfig.getFrequency() : ComplianceFrequency.YEARLY);
                        LocalDate calculatedSubDue = calculateEffectiveDueDate(subConfig);
                        subConfig.setDueDate(calculatedSubDue != null ? calculatedSubDue : parentDueDate);
                        subConfig.setIsActive(true);
                        subConfig.setConfiguredBy(adminId);
                        subConfig = configRepository.save(subConfig);
                    }

                    Optional<EmployeeAssignment> existingSubAssign = assignmentRepository
                            .findByConfigIdAndEmployeeIdAndIsActiveTrue(subConfig.getId(), employeeId);

                    LocalDate subDueDate = subConfig.getDueDate() != null ? subConfig.getDueDate() : (subConfig.getFrequency() != null ? calculateEffectiveDueDate(subConfig) : parentDueDate);
                    boolean subAlreadyCompleted = subCC.getStatus() == ComplianceStatus.COMPLETED || subCC.getCompletedAt() != null;

                    if (existingSubAssign.isEmpty()) {
                        EmployeeAssignment subAssign = new EmployeeAssignment();
                        subAssign.setConfig(subConfig);
                        subAssign.setEmployeeId(employeeId);
                        subAssign.setDueDate(subDueDate);
                        subAssign.setAssignedAt(LocalDateTime.now(IST_ZONE));
                        subAssign.setIsActive(true);
                        subAssign.setIsSubAssignment(true);
                        subAssign.setParentAssignmentId(parentAssign.getId());
                        if (subAlreadyCompleted) {
                            subAssign.setCompletedAt(subCC.getCompletedAt() != null ? subCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                            subAssign.setCompletedBy(subCC.getCompletedBy());
                            subAssign.setSubmissionReference(subCC.getAdminSubmissionReference());
                            subAssign.setSubmissionDocumentUrl(subCC.getAdminSubmissionDocumentUrl());
                        }
                        assignmentRepository.save(subAssign);
                    } else {
                        EmployeeAssignment subAssign = existingSubAssign.get();
                        subAssign.setIsActive(true);
                        subAssign.setIsSubAssignment(true);
                        subAssign.setParentAssignmentId(parentAssign.getId());
                        if (subAssign.getDueDate() == null) {
                            subAssign.setDueDate(subDueDate);
                        }
                        if (subAlreadyCompleted && subAssign.getCompletedAt() == null) {
                            subAssign.setCompletedAt(subCC.getCompletedAt() != null ? subCC.getCompletedAt() : LocalDateTime.now(IST_ZONE));
                            subAssign.setCompletedBy(subCC.getCompletedBy());
                            subAssign.setSubmissionReference(subCC.getAdminSubmissionReference());
                            subAssign.setSubmissionDocumentUrl(subCC.getAdminSubmissionDocumentUrl());
                        }
                        assignmentRepository.save(subAssign);
                    }
                }
            }

            // Send notification and email
            try {
                String parentName = parentCC.getTemplate() != null ? parentCC.getTemplate().getName() : "Compliance";
                int subCount = subCompliances != null ? subCompliances.size() : 0;
                String emailMsg = subCount > 0
                        ? "You have been assigned to compliance \"" + parentName + "\" along with " + subCount + " sub-compliance task(s)."
                        : "You have been assigned to compliance \"" + parentName + "\".";

                emailService.sendAssignmentEmail(
                        employee.getEmail(),
                        employee.getFirstName(),
                        parentName + (subCount > 0 ? " (" + subCount + " sub-compliances)" : ""),
                        parentAssign.getDueDate()
                );

                notificationEventService.notifyUsersPushOnly(
                        List.of(employeeId),
                        "New Compliance Assigned",
                        emailMsg,
                        NotificationType.COMPLIANCE_ASSIGNMENT_UPDATED,
                        "employee_compliance"
                );
            } catch (Exception e) {
                log.error("Failed to send assignment notification/email to employee {}: {}", employee.getEmail(), e.getMessage());
            }
        }

        log.info("Parent compliance {} assigned with {} sub-compliances to {} employees",
                parentId, (subCompliances != null ? subCompliances.size() : 0), employeeIds.size());
    }

    @Transactional
    public void assignMultipleParentCompliancesToEmployee(Long employeeId, List<Long> parentComplianceIds, Long companyId, Long adminId) {
        log.info("Assigning {} parent compliances to employee ID {}", parentComplianceIds != null ? parentComplianceIds.size() : 0, employeeId);

        if (parentComplianceIds == null || parentComplianceIds.isEmpty()) {
            throw new BusinessException("Please select at least one parent compliance");
        }

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() == UserRole.SUB_ADMIN) {
            throw new BusinessException("Sub-admins have full access to all company compliances and cannot be assigned individually.");
        }

        if (employee.getCompany() == null || !employee.getCompany().getId().equals(companyId)) {
            throw new BusinessException("Employee does not belong to your company");
        }

        for (Long parentId : parentComplianceIds) {
            assignParentWithSubCompliances(parentId, companyId, List.of(employeeId), adminId);
        }
    }

    @Transactional
    public void assignParentCompliancesToMultipleEmployees(List<Long> parentComplianceIds, List<Long> employeeIds, Long companyId, Long adminId) {
        log.info("Assigning {} parent compliances to {} employees", parentComplianceIds != null ? parentComplianceIds.size() : 0, employeeIds != null ? employeeIds.size() : 0);

        if (parentComplianceIds == null || parentComplianceIds.isEmpty()) {
            throw new BusinessException("Please select at least one parent compliance");
        }
        if (employeeIds == null || employeeIds.isEmpty()) {
            throw new BusinessException("Please select at least one employee");
        }

        for (Long parentId : parentComplianceIds) {
            assignParentWithSubCompliances(parentId, companyId, employeeIds, adminId);
        }
    }

    @Transactional(readOnly = true)
    public Set<Long> getAssignedParentComplianceIdsForEmployee(Long employeeId, Long companyId) {
        log.info("Fetching assigned parent compliance IDs for employee: {} in company: {}", employeeId, companyId);
        User employee = userRepository.findById(employeeId).orElse(null);
        if (employee != null && employee.getRole() == UserRole.SUB_ADMIN) {
            return Collections.emptySet();
        }

        List<EmployeeAssignment> assignments = assignmentRepository.findByEmployeeIdAndIsActiveTrue(employeeId);
        Set<Long> parentIds = new HashSet<>();

        for (EmployeeAssignment a : assignments) {
            if (a.getConfig() != null && a.getConfig().getCompanyCompliance() != null) {
                CompanyCompliance cc = a.getConfig().getCompanyCompliance();
                if (cc.getCompany() != null && cc.getCompany().getId().equals(companyId) && Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted()) {
                    if (cc.isParent() || cc.getSubTemplate() == null) {
                        parentIds.add(cc.getId());
                    } else {
                        Long tId = cc.getParentTemplateId() != null ? cc.getParentTemplateId() : (cc.getTemplate() != null ? cc.getTemplate().getId() : null);
                        if (tId != null) {
                            companyComplianceRepository
                                    .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, tId)
                                    .ifPresent(p -> parentIds.add(p.getId()));
                        }
                    }
                }
            }
        }
        return parentIds;
    }

    @Transactional(readOnly = true)
    public Set<Long> getAssignedEmployeeIdsForParentCompliance(Long parentId, Long companyId) {
        log.info("Fetching assigned employee IDs for parent compliance: {} in company: {}", parentId, companyId);
        CompanyCompliance parentCC = companyComplianceRepository.findByIdAndDeletedFalse(parentId).orElse(null);
        if (parentCC == null || !parentCC.getCompany().getId().equals(companyId)) {
            parentCC = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parentId)
                    .orElse(null);
        }

        Long templateId = (parentCC != null && parentCC.getTemplate() != null)
                ? parentCC.getTemplate().getId()
                : parentId;

        Set<Long> employeeIds = new HashSet<>();

        // Check parent config assignments
        if (parentCC != null) {
            Optional<ComplianceConfig> parentConfigOpt = configRepository.findByCompanyComplianceId(parentCC.getId());
            if (parentConfigOpt.isPresent()) {
                List<EmployeeAssignment> pAssigns = assignmentRepository.findByConfigIdAndIsActiveTrue(parentConfigOpt.get().getId());
                for (EmployeeAssignment pa : pAssigns) {
                    if (pa.getEmployeeId() != null) employeeIds.add(pa.getEmployeeId());
                }
            }
        }

        // Also check sub-compliance assignments
        List<CompanyCompliance> subCCs = companyComplianceRepository
                .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, templateId);
        for (CompanyCompliance subCC : subCCs) {
            Optional<ComplianceConfig> subConfigOpt = configRepository.findByCompanyComplianceId(subCC.getId());
            if (subConfigOpt.isPresent()) {
                List<EmployeeAssignment> sAssigns = assignmentRepository.findByConfigIdAndIsActiveTrue(subConfigOpt.get().getId());
                for (EmployeeAssignment sa : sAssigns) {
                    if (sa.getEmployeeId() != null) employeeIds.add(sa.getEmployeeId());
                }
            }
        }

        return employeeIds;
    }

    @Transactional
    public void removeParentComplianceFromEmployee(Long parentId, Long employeeId, Long companyId, Long adminId) {
        log.info("Removing parent compliance {} from employee {} for company {} by admin {}", parentId, employeeId, companyId, adminId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getCompany() == null || !employee.getCompany().getId().equals(companyId)) {
            throw new BusinessException("Employee does not belong to your company");
        }

        CompanyCompliance parentCC = companyComplianceRepository.findByIdAndDeletedFalse(parentId).orElse(null);
        if (parentCC == null || !parentCC.getCompany().getId().equals(companyId)) {
            parentCC = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, parentId)
                    .orElse(null);
        }

        if (parentCC == null) {
            // Check if parentId is actually a config ID or sub-compliance ID
            Optional<ComplianceConfig> cfgOpt = configRepository.findById(parentId);
            if (cfgOpt.isPresent() && cfgOpt.get().getCompanyCompliance() != null) {
                CompanyCompliance cc = cfgOpt.get().getCompanyCompliance();
                if (cc.getCompany() != null && cc.getCompany().getId().equals(companyId)) {
                    if (cc.isParent() || cc.getSubTemplate() == null) {
                        parentCC = cc;
                    } else if (cc.getParentTemplateId() != null) {
                        parentCC = companyComplianceRepository
                                .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, cc.getParentTemplateId())
                                .orElse(null);
                    }
                }
            }
        }

        // If parentCC resolved to a sub-compliance entity, find its true parent CompanyCompliance
        if (parentCC != null && (!parentCC.isParent() || parentCC.getSubTemplate() != null || parentCC.getParentTemplateId() != null)) {
            Long tId = parentCC.getParentTemplateId() != null ? parentCC.getParentTemplateId() : (parentCC.getTemplate() != null ? parentCC.getTemplate().getId() : null);
            if (tId != null) {
                CompanyCompliance resolvedParent = companyComplianceRepository
                        .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, tId)
                        .orElse(null);
                if (resolvedParent != null) {
                    parentCC = resolvedParent;
                }
            }
        }

        if (parentCC == null) {
            log.warn("Parent compliance {} not found for company {}", parentId, companyId);
            return;
        }

        Long templateId = parentCC.getTemplate() != null ? parentCC.getTemplate().getId() : parentCC.getParentTemplateId();

        // 1. Delete parent assignment
        Optional<ComplianceConfig> parentConfigOpt = configRepository.findByCompanyComplianceId(parentCC.getId());
        Long parentAssignmentId = null;
        if (parentConfigOpt.isPresent()) {
            Optional<EmployeeAssignment> parentAssign = assignmentRepository
                    .findByConfigIdAndEmployeeIdAndIsActiveTrue(parentConfigOpt.get().getId(), employeeId);
            if (parentAssign.isPresent()) {
                parentAssignmentId = parentAssign.get().getId();
                assignmentRepository.delete(parentAssign.get());
            }
        }

        // 2. Delete all sub-compliance assignments for this employee & parent template
        if (templateId != null) {
            List<CompanyCompliance> subCCs = companyComplianceRepository
                    .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, templateId);

            for (CompanyCompliance subCC : subCCs) {
                Optional<ComplianceConfig> subConfigOpt = configRepository.findByCompanyComplianceId(subCC.getId());
                if (subConfigOpt.isPresent()) {
                    Optional<EmployeeAssignment> subAssign = assignmentRepository
                            .findByConfigIdAndEmployeeIdAndIsActiveTrue(subConfigOpt.get().getId(), employeeId);
                    subAssign.ifPresent(assignmentRepository::delete);
                }
            }
        }

        // 3. Delete any orphaned sub-assignments linked by parentAssignmentId
        if (parentAssignmentId != null) {
            List<EmployeeAssignment> linkedSubs = assignmentRepository
                    .findByParentAssignmentIdAndIsActiveTrue(parentAssignmentId);
            for (EmployeeAssignment sa : linkedSubs) {
                assignmentRepository.delete(sa);
            }
        }

        // 4. If parentId was a direct config/sub-assignment, delete if still active
        Optional<ComplianceConfig> directConfigOpt = configRepository.findById(parentId);
        if (directConfigOpt.isPresent()) {
            Optional<EmployeeAssignment> directAssign = assignmentRepository
                    .findByConfigIdAndEmployeeIdAndIsActiveTrue(directConfigOpt.get().getId(), employeeId);
            directAssign.ifPresent(assignmentRepository::delete);
        }

        // 5. Notify employee
        try {
            String parentName = parentCC.getTemplate() != null ? parentCC.getTemplate().getName() : "Compliance";
            notificationEventService.notifyUserPushOnly(
                    employeeId,
                    "Compliance Unassigned",
                    "Compliance category \"" + parentName + "\" has been removed from your assignments.",
                    NotificationType.COMPLIANCE_ASSIGNMENT_UPDATED,
                    "employee_compliance"
            );
        } catch (Exception e) {
            log.warn("Failed to notify employee {} about compliance unassignment: {}", employeeId, e.getMessage());
        }

        log.info("Successfully removed parent compliance {} and sub-compliances from employee {}", parentId, employeeId);
    }

    @Transactional
    public void syncParentCompliancesForEmployee(Long employeeId, List<Long> parentComplianceIds, Long companyId, Long adminId) {
        log.info("Syncing parent compliances for employee ID: {}, target IDs: {}", employeeId, parentComplianceIds);
        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() == UserRole.SUB_ADMIN) {
            throw new BusinessException("Sub-admins have full access to all company compliances and cannot be assigned individually.");
        }

        if (parentComplianceIds == null) {
            parentComplianceIds = Collections.emptyList();
        }

        Set<Long> currentlyAssignedIds = getAssignedParentComplianceIdsForEmployee(employeeId, companyId);
        Set<Long> desiredIds = new HashSet<>(parentComplianceIds);

        // Add newly checked
        Set<Long> toAdd = new HashSet<>(desiredIds);
        toAdd.removeAll(currentlyAssignedIds);

        // Remove unchecked
        Set<Long> toRemove = new HashSet<>(currentlyAssignedIds);
        toRemove.removeAll(desiredIds);

        for (Long idToAdd : toAdd) {
            assignParentWithSubCompliances(idToAdd, companyId, List.of(employeeId), adminId);
        }

        for (Long idToRemove : toRemove) {
            removeParentComplianceFromEmployee(idToRemove, employeeId, companyId, adminId);
        }
    }

    @Transactional
    public void syncEmployeesForParentCompliance(Long parentId, List<Long> employeeIds, Long companyId, Long adminId) {
        log.info("Syncing employees for parent compliance ID: {}, target employee IDs: {}", parentId, employeeIds);
        if (employeeIds == null) {
            employeeIds = Collections.emptyList();
        }

        Set<Long> currentlyAssignedEmployees = getAssignedEmployeeIdsForParentCompliance(parentId, companyId);
        Set<Long> desiredEmployees = new HashSet<>(employeeIds);

        Set<Long> toAdd = new HashSet<>(desiredEmployees);
        toAdd.removeAll(currentlyAssignedEmployees);

        Set<Long> toRemove = new HashSet<>(currentlyAssignedEmployees);
        toRemove.removeAll(desiredEmployees);

        if (!toAdd.isEmpty()) {
            assignParentWithSubCompliances(parentId, companyId, new ArrayList<>(toAdd), adminId);
        }

        for (Long empIdToRemove : toRemove) {
            removeParentComplianceFromEmployee(parentId, empIdToRemove, companyId, adminId);
        }
    }




    @Transactional
    public ComplianceConfigDTO configureCustomSubCompliance(Long subTemplateId, Long companyId,
                                                            ComplianceConfigDTO dto, Long adminId) {
        // Delegate to the new implementation
        return configureSubComplianceForCompany(subTemplateId, companyId, dto, adminId);
    }

    // ==================== REMOVE COMPANY FROM COMPLIANCE ====================

    @Transactional
    public void removeCompanyFromCompliancePermanently(Long companyId, Long templateId, Long adminId) {
        log.info("Permanently removing company {} from template {} by admin {}", companyId, templateId, adminId);

        // 1. Fetch all CompanyCompliance records (both parent and sub-compliances)
        List<CompanyCompliance> allCompliances = companyComplianceRepository
                .findAllByCompanyIdAndTemplateOrParentTemplateId(companyId, templateId);

        // Deduplicate and separate sub-compliances from parent compliances so subs are deleted first
        Map<Long, CompanyCompliance> distinctMap = new LinkedHashMap<>();
        for (CompanyCompliance cc : allCompliances) {
            if (cc != null && cc.getId() != null) {
                distinctMap.put(cc.getId(), cc);
            }
        }

        List<CompanyCompliance> subCompliances = new ArrayList<>();
        List<CompanyCompliance> parentCompliances = new ArrayList<>();
        for (CompanyCompliance cc : distinctMap.values()) {
            if (cc.isSubCompliance() || Boolean.FALSE.equals(cc.getIsParent()) || cc.getParentTemplateId() != null || cc.getSubTemplate() != null) {
                subCompliances.add(cc);
            } else {
                parentCompliances.add(cc);
            }
        }

        // Delete all sub-compliances first
        for (CompanyCompliance subCC : subCompliances) {
            deleteCompanyCompliancePermanently(subCC);
        }

        // Delete all parent compliances next
        for (CompanyCompliance parentCC : parentCompliances) {
            deleteCompanyCompliancePermanently(parentCC);
        }

        // 2. Delete company-specific sub-templates created for this parent template
        List<ComplianceSubTemplate> companySubTemplates = subTemplateRepository
                .findCompanySubTemplatesByParent(templateId, companyId);
        for (ComplianceSubTemplate subTemplate : companySubTemplates) {
            Long subId = subTemplate.getId();
            log.info("Deleting company-specific sub-template ID: {}", subId);

            List<Long> configIds = configRepository.findConfigIdsBySubTemplateId(subId);
            for (Long cfgId : configIds) {
                assignmentRepository.deleteByConfigId(cfgId);
            }
            configRepository.deleteAllBySubTemplateId(subId);
            subTemplateRepository.delete(subTemplate);
            log.info("Deleted company-specific sub-template ID: {}", subId);
        }

        // 3. Notifications
        Company company = companyRepository.findById(companyId).orElse(null);
        ComplianceTemplate template = templateRepository.findById(templateId).orElse(null);
        if (company != null && template != null) {
            try {
                notificationEventService.notifySuperAdminsPushOnly(
                        "Company Removed from Compliance",
                        "Company " + company.getName() + " has been removed from \"" + template.getName() + "\".",
                        NotificationType.COMPANY_REMOVED_FROM_COMPLIANCE,
                        "compliance_details"
                );
                if (company.getCompanyAdmin() != null) {
                    notificationEventService.notifyUserPushOnly(
                            company.getCompanyAdmin().getId(),
                            "Compliance Removed",
                            "Compliance \"" + template.getName() + "\" has been removed from your company.",
                            NotificationType.COMPANY_REMOVED_FROM_COMPLIANCE,
                            "compliance_details"
                    );
                }
            } catch (Exception e) {
                log.warn("Notification failed during removeCompanyFromCompliancePermanently: {}", e.getMessage());
            }
        }

        log.info("Company compliance permanently removed for company: {}, template: {}", companyId, templateId);
    }

    private void deleteCompanyCompliancePermanently(CompanyCompliance companyCompliance) {
        if (companyCompliance == null || companyCompliance.getId() == null) {
            return;
        }
        Long ccId = companyCompliance.getId();
        log.info("Permanently deleting CompanyCompliance ID: {}", ccId);

        // 1. Unlink any CompanyDocument records pointing to this CompanyCompliance
        List<CompanyDocument> companyDocs = companyDocumentRepository.findByCompanyComplianceId(ccId);
        if (companyDocs != null && !companyDocs.isEmpty()) {
            for (CompanyDocument cd : companyDocs) {
                cd.setCompanyCompliance(null);
                companyDocumentRepository.save(cd);
            }
        }

        // 2. Delete all ComplianceDocument records for this CompanyCompliance
        List<ComplianceDocument> documents = documentRepository.findByCompanyComplianceId(ccId);
        if (documents != null && !documents.isEmpty()) {
            documentRepository.deleteAll(documents);
        }

        // 3. Delete all ComplianceHistory records for this CompanyCompliance
        List<ComplianceHistory> histories = historyRepository.findByCompanyComplianceId(ccId);
        if (histories != null && !histories.isEmpty()) {
            historyRepository.deleteAll(histories);
        }

        // 4. Find config(s) linked to this CompanyCompliance and delete their employee assignments and config
        Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(ccId);
        if (configOpt.isPresent()) {
            ComplianceConfig config = configOpt.get();
            assignmentRepository.deleteByConfigId(config.getId());
            companyCompliance.setConfig(null);
            config.setCompanyCompliance(null);
            configRepository.delete(config);
        }

        if (companyCompliance.getConfig() != null) {
            ComplianceConfig directConfig = companyCompliance.getConfig();
            assignmentRepository.deleteByConfigId(directConfig.getId());
            companyCompliance.setConfig(null);
            directConfig.setCompanyCompliance(null);
            configRepository.delete(directConfig);
        }

        // 5. Delete the CompanyCompliance itself
        companyComplianceRepository.delete(companyCompliance);
        log.info("CompanyCompliance ID: {} deleted successfully", ccId);
    }

    // ==================== VIEW METHODS ====================

    @Transactional(readOnly = true)
    public ComplianceTemplateDTO getTemplateById(Long id) {
        ComplianceTemplate template = templateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found"));
        return convertToTemplateDTO(template);
    }

    @Transactional(readOnly = true)
    public List<ComplianceTemplateDTO> getSuperAdminCompliances() {
        return templateRepository.findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc()
                .stream()
                .map(this::convertToTemplateDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<ComplianceTemplateDTO> getSuperAdminCompliances(Pageable pageable) {
        return templateRepository.findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc(pageable)
                .map(this::convertToTemplateDTO);
    }

    @Transactional(readOnly = true)
    public List<ComplianceTemplate> getAllSuperAdminTemplates() {
        log.info("Fetching all SuperAdmin compliance templates");
        return templateRepository.findByIsCompanySpecificFalseAndIsActiveTrue();
    }

    @Transactional(readOnly = true)
    public List<ComplianceSubTemplateDTO> getSubTemplatesByParent(Long parentId) {
        return subTemplateRepository.findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(parentId)
                .stream()
                .map(this::convertToSubTemplateDTO)
                .collect(Collectors.toList());
    }

    public boolean isParentWithSubCompliances(CompanyCompliance cc) {
        if (cc == null || cc.getTemplate() == null) return false;
        if (cc.getSubTemplate() != null || Boolean.FALSE.equals(cc.getIsParent())) {
            return false;
        }
        if (cc.getCompany() != null) {
            List<CompanyCompliance> subs = companyComplianceRepository.findSubCompliancesByCompanyIdAndParentTemplateId(
                    cc.getCompany().getId(), cc.getTemplate().getId());
            if (subs != null && !subs.isEmpty()) {
                return true;
            }
        }
        if (subTemplateRepository != null) {
            return !subTemplateRepository.findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(cc.getTemplate().getId()).isEmpty();
        }
        return false;
    }

    @Transactional
    public void syncOverdueComplianceStatuses() {
        LocalDate today = LocalDate.now(IST_ZONE);

        // Self-heal: ensure compliances with completedAt are marked COMPLETED in database
        List<CompanyCompliance> completedWithWrongStatus = companyComplianceRepository.findAll().stream()
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED && cc.getCompletedAt() != null)
                .collect(Collectors.toList());
        for (CompanyCompliance completedCC : completedWithWrongStatus) {
            completedCC.setStatus(ComplianceStatus.COMPLETED);
            companyComplianceRepository.save(completedCC);
        }

        // Auto-renew completed recurring compliances whose past due date has passed
        try {
            renewCompletedRecurringCompliances();
        } catch (Exception e) {
            log.warn("Error renewing completed recurring compliances in sync: {}", e.getMessage());
        }

        // Self-heal: ensure compliances with due dates in future/today are not lingering as OVERDUE
        List<CompanyCompliance> futureOverdue = companyComplianceRepository.findAll().stream()
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> cc.getStatus() == ComplianceStatus.OVERDUE && cc.getCompletedAt() == null)
                .collect(Collectors.toList());
        for (CompanyCompliance cc : futureOverdue) {
            LocalDate due = resolveEffectiveDueDate(cc);
            if (due != null && !due.isBefore(today)) {
                cc.setStatus(ComplianceStatus.IN_PROGRESS);
                companyComplianceRepository.save(cc);
            }
        }

        List<CompanyCompliance> allCCs = companyComplianceRepository.findAll().stream()
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED && cc.getCompletedAt() == null)
                .filter(cc -> cc.getStatus() != ComplianceStatus.EXEMPTED)
                .collect(Collectors.toList());

        for (CompanyCompliance cc : allCCs) {
            if (isParentWithSubCompliances(cc)) {
                // Parent containers are synced in second pass
                continue;
            }

            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
                config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
            }
            if (config == null) continue;

            // Check if completed via employee assignments
            if (assignmentRepository.isConfigCompletedByAnyEmployee(config.getId())) {
                cc.setStatus(ComplianceStatus.COMPLETED);
                companyComplianceRepository.save(cc);
                continue;
            }

            LocalDate due = config.getDueDate() != null ? config.getDueDate()
                    : (config.getCustomDueDate() != null ? config.getCustomDueDate() : calculateEffectiveDueDate(config));

            if (due != null) {
                if (due.isBefore(today)) {
                    if (cc.getStatus() != ComplianceStatus.OVERDUE) {
                        ComplianceStatus oldStatus = cc.getStatus();
                        cc.setStatus(ComplianceStatus.OVERDUE);
                        companyComplianceRepository.save(cc);
                        try {
                            addHistoryForCompanyCompliance(cc, oldStatus, ComplianceStatus.OVERDUE,
                                    "MARKED_OVERDUE", "Compliance became OVERDUE (due date was " + due + ")", null);
                        } catch (Exception ex) {
                            log.debug("History recording for overdue skipped: {}", ex.getMessage());
                        }
                    }
                } else if (cc.getStatus() == ComplianceStatus.OVERDUE) {
                    ComplianceStatus oldStatus = cc.getStatus();
                    cc.setStatus(ComplianceStatus.IN_PROGRESS);
                    companyComplianceRepository.save(cc);
                    try {
                        addHistoryForCompanyCompliance(cc, oldStatus, ComplianceStatus.IN_PROGRESS,
                                "STATUS_UPDATED", "Status updated back to IN_PROGRESS", null);
                    } catch (Exception ex) {
                        log.debug("History recording skipped: {}", ex.getMessage());
                    }
                }
            }
        }

        // Second pass: sync parent container compliances based on sub-compliances
        List<CompanyCompliance> parents = allCCs.stream()
                .filter(this::isParentWithSubCompliances)
                .collect(Collectors.toList());

        for (CompanyCompliance p : parents) {
            if (p.getCompany() != null && p.getTemplate() != null) {
                List<CompanyCompliance> subs = companyComplianceRepository
                        .findSubCompliancesByCompanyIdAndParentTemplateId(p.getCompany().getId(), p.getTemplate().getId());
                if (subs != null && !subs.isEmpty()) {
                    boolean allCompleted = subs.stream().allMatch(s -> s.getStatus() == ComplianceStatus.COMPLETED || s.getCompletedAt() != null);
                    boolean anyOverdue = subs.stream().anyMatch(s -> s.getStatus() == ComplianceStatus.OVERDUE);
                    boolean anyInProgress = subs.stream().anyMatch(s -> s.getStatus() == ComplianceStatus.IN_PROGRESS || s.getStatus() == ComplianceStatus.COMPLETED || s.getCompletedAt() != null);

                    if (allCompleted) {
                        p.setStatus(ComplianceStatus.COMPLETED);
                        companyComplianceRepository.save(p);
                    } else if (anyOverdue) {
                        if (p.getStatus() != ComplianceStatus.OVERDUE) {
                            p.setStatus(ComplianceStatus.OVERDUE);
                            companyComplianceRepository.save(p);
                        }
                    } else if (anyInProgress) {
                        if (p.getStatus() != ComplianceStatus.IN_PROGRESS) {
                            p.setStatus(ComplianceStatus.IN_PROGRESS);
                            companyComplianceRepository.save(p);
                        }
                    } else {
                        if (p.getStatus() != ComplianceStatus.PENDING) {
                            p.setStatus(ComplianceStatus.PENDING);
                            companyComplianceRepository.save(p);
                        }
                    }
                }
            }
        }
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getOverdueCompliancesForDashboard() {
        // Step 1: lightweight paginated query (no JOIN FETCH)
        Page<CompanyCompliance> page = companyComplianceRepository
                .findOverdueAssignmentsFiltered(null, null, true, null,
                        PageRequest.of(0, 50, Sort.by(Sort.Direction.ASC, "createdAt")));

        List<Long> ids = page.getContent().stream().map(CompanyCompliance::getId).collect(Collectors.toList());
        if (ids.isEmpty()) return new ArrayList<>();

        // Step 2: load full entity graph for only these IDs
        List<CompanyCompliance> fullList = companyComplianceRepository.fetchByIds(ids);
        Map<Long, CompanyCompliance> byId = new java.util.LinkedHashMap<>();
        fullList.forEach(cc -> byId.put(cc.getId(), cc));

        LocalDate today = LocalDate.now(IST_ZONE);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Long id : ids) {
            CompanyCompliance cc = byId.get(id);
            if (cc == null) continue;
            Map<String, Object> map = new HashMap<>();
            map.put("id", cc.getId());
            map.put("companyId", cc.getCompany() != null ? cc.getCompany().getId() : null);
            map.put("companyName", cc.getCompany() != null ? cc.getCompany().getName() : "N/A");
            map.put("templateId", cc.getTemplate() != null ? cc.getTemplate().getId() : null);
            map.put("templateName", cc.getTemplate() != null ? cc.getTemplate().getName() : "Compliance");
            map.put("subTemplateId", cc.getSubTemplate() != null ? cc.getSubTemplate().getId() : null);
            map.put("subTemplateName", cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : null);

            LocalDate due = null;
            if (cc.getConfig() != null) {
                due = cc.getConfig().getDueDate() != null ? cc.getConfig().getDueDate() : cc.getConfig().getCustomDueDate();
                if (due == null) due = calculateEffectiveDueDate(cc.getConfig());
            }

            if (due != null) {
                map.put("dueDate", due.toString());
                long overdueDays = Math.max(1, ChronoUnit.DAYS.between(due, today));
                map.put("overdueDays", overdueDays);
            } else {
                map.put("dueDate", "—");
                map.put("overdueDays", 1L);
            }

            map.put("status", "OVERDUE");
            map.put("assignedByName", (cc.getCompany() != null && cc.getCompany().getCompanyAdmin() != null)
                    ? cc.getCompany().getCompanyAdmin().getFullName() : "—");
            result.add(map);
        }

        return result;
    }

    @Transactional(readOnly = true)
    public Page<Map<String, Object>> getOverdueCompaniesSummary(String search, Pageable pageable) {
        String cleanSearch = (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        Page<Object[]> rawPage = companyComplianceRepository.findOverdueCompaniesSummary(cleanSearch, pageable);

        LocalDate today = LocalDate.now(IST_ZONE);
        List<Map<String, Object>> list = new ArrayList<>();

        for (Object[] row : rawPage.getContent()) {
            if (row != null && row.length >= 4) {
                Map<String, Object> item = new HashMap<>();
                item.put("companyId", row[0]);
                item.put("companyName", row[1]);
                item.put("email", row[2]);
                item.put("overdueCount", row[3]);

                LocalDate oldestDueDate = (row.length > 4 && row[4] instanceof LocalDate) ? (LocalDate) row[4] : null;
                item.put("oldestDueDate", oldestDueDate != null ? oldestDueDate.toString() : null);
                item.put("maxOverdueDays", oldestDueDate != null ? Math.max(1, ChronoUnit.DAYS.between(oldestDueDate, today)) : 0);

                list.add(item);
            }
        }

        return new PageImpl<>(list, pageable, rawPage.getTotalElements());
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStatsSummary() {
        Map<String, Object> stats = new HashMap<>();

        long totalCompanies = companyRepository.countActiveCompanies();
        long activeCompanies = companyRepository.countByStatus(CompanyStatus.ACTIVE);
        long deactivatedCompanies = companyRepository.countByStatus(CompanyStatus.DEACTIVATED);
        long totalTemplates = templateRepository.countByIsCompanySpecificFalseAndIsActiveTrue();
        long totalAssignments = companyComplianceRepository.countTotalActiveAssignments();

        List<Object[]> statusCounts = companyComplianceRepository.countAssignmentsGroupedByStatus();
        long overdueCount = companyComplianceRepository.countOverdueActiveAssignments();
        long completedCount = 0;
        long pendingCount = 0;
        long inProgressCount = 0;

        for (Object[] row : statusCounts) {
            if (row != null && row.length >= 2) {
                ComplianceStatus st = (ComplianceStatus) row[0];
                Number cnt = (Number) row[1];
                if (st != null && cnt != null) {
                    switch (st) {
                        case COMPLETED -> completedCount += cnt.longValue();
                        case PENDING -> pendingCount += cnt.longValue();
                        case IN_PROGRESS -> inProgressCount += cnt.longValue();
                        default -> {}
                    }
                }
            }
        }

        long totalStatus = overdueCount + completedCount + pendingCount + inProgressCount;
        int avgRate = totalStatus > 0 ? (int) Math.round(((double) completedCount / totalStatus) * 100) : 0;

        stats.put("totalCompanies", totalCompanies);
        stats.put("activeCompanies", activeCompanies);
        stats.put("deactivatedCompanies", deactivatedCompanies);
        stats.put("totalCategories", totalTemplates);
        stats.put("configuredCategories", totalTemplates);
        stats.put("totalAssignments", totalAssignments);
        stats.put("overdueCount", overdueCount);
        stats.put("completedCount", completedCount);
        stats.put("pendingCount", pendingCount + inProgressCount);
        stats.put("inProgressCount", inProgressCount);
        stats.put("avgCompletionRate", avgRate);

        return stats;
    }

    @Transactional(readOnly = true)
    public Page<CompanyComplianceDTO> getAllAssignments(Long companyId, ComplianceStatus status,
                                                        Long templateId, Boolean isActive,
                                                        Pageable pageable) {
        return getAllAssignments(companyId, status, templateId, isActive, null, pageable);
    }

    @Transactional(readOnly = true)
    public Page<CompanyComplianceDTO> getAllAssignments(Long companyId, ComplianceStatus status,
                                                        Long templateId, Boolean isActive,
                                                        String search,
                                                        Pageable pageable) {
        log.info("Fetching compliance assignments - companyId: {}, status: {}, templateId: {}, isActive: {}, search: {}",
                companyId, status, templateId, isActive, search);

        String cleanSearch = (search != null && !search.trim().isEmpty()) ? search.trim() : null;

        // Step 1: lightweight paginated query (no JOIN FETCH — avoids Hibernate in-memory pagination)
        Page<CompanyCompliance> assignmentsPage;
        if (status == ComplianceStatus.OVERDUE) {
            assignmentsPage = companyComplianceRepository
                    .findOverdueAssignmentsFiltered(companyId, templateId, isActive, cleanSearch, pageable);
        } else {
            assignmentsPage = companyComplianceRepository
                    .findAllAssignmentsFiltered(companyId, status, templateId, isActive, cleanSearch, pageable);
        }

        // Step 2: fetch full associations only for the small result set
        List<Long> ids = assignmentsPage.getContent().stream().map(CompanyCompliance::getId).collect(Collectors.toList());
        List<CompanyCompliance> fullEntities = ids.isEmpty()
                ? new ArrayList<>()
                : companyComplianceRepository.fetchByIds(ids);

        // Maintain the original page order
        Map<Long, CompanyCompliance> byId = new java.util.LinkedHashMap<>();
        fullEntities.forEach(cc -> byId.put(cc.getId(), cc));

        List<CompanyComplianceDTO> dtos = ids.stream()
                .map(id -> byId.containsKey(id) ? convertToCompanyComplianceDTO(byId.get(id)) : null)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toList());

        return new PageImpl<>(dtos, pageable, assignmentsPage.getTotalElements());
    }

    @Transactional(readOnly = true)
    public Page<CompanyComplianceDTO> getCompliancesByCompany(Long companyId, Pageable pageable) {
        log.info("Fetching compliances for company: {}", companyId);

        // Step 1: lightweight paginated query
        Page<CompanyCompliance> page = companyComplianceRepository
                .findAllAssignmentsFiltered(companyId, null, null, true, null, pageable);

        // Step 2: fetch full entity graph for paginated IDs only
        List<Long> ids = page.getContent().stream().map(CompanyCompliance::getId).collect(Collectors.toList());
        List<CompanyCompliance> full = ids.isEmpty()
                ? new ArrayList<>()
                : companyComplianceRepository.fetchByIds(ids);

        Map<Long, CompanyCompliance> byId = new java.util.LinkedHashMap<>();
        full.forEach(cc -> byId.put(cc.getId(), cc));

        List<CompanyComplianceDTO> dtos = ids.stream()
                .map(id -> byId.containsKey(id) ? convertToCompanyComplianceDTO(byId.get(id)) : null)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toList());

        return new PageImpl<>(dtos, pageable, page.getTotalElements());
    }

    @Transactional(readOnly = true)
    public CompanyComplianceDTO getComplianceById(Long id) {
        log.info("Fetching compliance by ID: {}", id);
        CompanyCompliance compliance = companyComplianceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Compliance not found with ID: " + id));
        return convertToCompanyComplianceDTO(compliance);
    }

    @Transactional
    public CompanyComplianceDTO toggleAssignmentStatus(Long assignmentId) {
        log.info("Toggling compliance assignment status: {}", assignmentId);
        CompanyCompliance assignment = companyComplianceRepository.findById(assignmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Assignment not found"));

        assignment.setIsActive(!assignment.getIsActive());

        String action = assignment.getIsActive() ? "Activated" : "Deactivated";
        addHistoryForCompanyCompliance(assignment, assignment.getStatus(),
                assignment.getStatus(), action,
                "Compliance " + action + " by SuperAdmin",
                userRepository.findById(SecurityUtils.getCurrentUserId()).orElse(null));

        CompanyCompliance saved = companyComplianceRepository.save(assignment);
        return convertToCompanyComplianceDTO(saved);
    }

    @Transactional
    public void deleteAssignment(Long assignmentId) {
        log.info("Permanently deleting compliance assignment: {}", assignmentId);

        CompanyCompliance assignment = companyComplianceRepository.findById(assignmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Assignment not found"));

        if (assignment.isParent() && assignment.getTemplate() != null && assignment.getCompany() != null) {
            removeCompanyFromCompliancePermanently(
                    assignment.getCompany().getId(),
                    assignment.getTemplate().getId(),
                    SecurityUtils.getCurrentUserId()
            );
        } else {
            deleteCompanyCompliancePermanently(assignment);
        }
        log.info("Compliance assignment {} permanently deleted successfully", assignmentId);
    }

    // ==================== COMPLIANCE CONFIG RETRIEVAL ====================

    @Transactional(readOnly = true)
    public ComplianceConfigDTO getSubTemplateConfig(Long subTemplateId) {
        log.info("Getting config for sub-template: {}", subTemplateId);

        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findBySubTemplateId(subTemplateId);

        if (companyCompliances.isEmpty()) {
            log.warn("No CompanyCompliance found for sub-template ID: {}", subTemplateId);
            return null;
        }

        CompanyCompliance first = companyCompliances.get(0);
        Optional<ComplianceConfig> configOpt = configRepository
                .findBySubTemplateIdAndCompanyComplianceIsNull(subTemplateId);
        if (configOpt.isPresent()) {
            ComplianceConfig config = configOpt.get();
            ComplianceConfigDTO dto = convertToConfigDTO(config);
            dto.setConfigured(true);

            if (first.getStatus() == ComplianceStatus.COMPLETED) {
                LocalDate nextDueDate = getNextDueDateForCompliance(first);
                dto.setNextDueDate(nextDueDate);
            } else {
                dto.setNextDueDate(dto.getEffectiveDueDate());
            }

            if (dto.getCreatedAt() == null) {
                dto.setCreatedAt(first.getCreatedAt());
            }

            return dto;
        }

        log.warn("No config found for sub-template ID: {}", subTemplateId);
        return null;
    }

    @Transactional(readOnly = true)
    public ComplianceConfigDTO getComplianceConfigByTemplate(Long templateId) {
        log.info("Getting compliance config for template: {}", templateId);

        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findByTemplateIdAndIsParentTrue(templateId);

        if (companyCompliances.isEmpty()) {
            return null;
        }

        CompanyCompliance first = companyCompliances.get(0);
        Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(first.getId());

        if (configOpt.isPresent()) {
            ComplianceConfigDTO dto = convertToConfigDTO(configOpt.get());
            dto.setConfigured(true);

            if (first.getStatus() == ComplianceStatus.COMPLETED) {
                LocalDate nextDueDate = getNextDueDateForCompliance(first);
                dto.setNextDueDate(nextDueDate);
            } else {
                dto.setNextDueDate(dto.getEffectiveDueDate());
            }

            if (dto.getCreatedAt() == null) {
                dto.setCreatedAt(first.getCreatedAt());
            }

            return dto;
        }

        return null;
    }

    @Transactional(readOnly = true)
    public List<ComplianceConfigDTO> getConfigsByCompany(Long companyId) {
        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findByCompanyIdAndIsActiveTrue(companyId);

        List<ComplianceConfigDTO> result = new ArrayList<>();
        for (CompanyCompliance cc : companyCompliances) {
            configRepository.findByCompanyComplianceId(cc.getId())
                    .ifPresent(config -> {
                        ComplianceConfigDTO dto = convertToConfigDTO(config);
                        if (cc.getStatus() != null) {
                            dto.setStatus(cc.getStatus());
                        }

                        if (cc.getStatus() == ComplianceStatus.COMPLETED) {
                            LocalDate nextDueDate = getNextDueDateForCompliance(cc);
                            dto.setNextDueDate(nextDueDate);
                        }

                        result.add(dto);
                    });
        }
        return result;
    }

    // ==================== CALENDAR EVENTS ====================

    @Transactional(readOnly = true)
    public List<CalendarEventDTO> getCalendarEvents(Long companyId, String startDate, String endDate,
                                                    Long employeeId, String status, Long categoryId) {
        log.info("Getting calendar events for company: {} from {} to {}", companyId, startDate, endDate);

        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        List<CalendarEventDTO> events = new ArrayList<>();

        List<EmployeeAssignment> assignments;
        if (employeeId != null) {
            assignments = assignmentRepository.findByEmployeeIdAndIsActiveTrue(employeeId, Pageable.unpaged()).getContent();
        } else {
            List<User> employees = userRepository.findByCompanyIdAndRoleAndDeletedFalse(
                    companyId, UserRole.EMPLOYEE, Pageable.unpaged()).getContent();

            assignments = new ArrayList<>();
            for (User emp : employees) {
                assignments.addAll(assignmentRepository.findByEmployeeIdAndIsActiveTrue(emp.getId(), Pageable.unpaged()).getContent());
            }
        }

        for (EmployeeAssignment assignment : assignments) {
            if (assignment.getDueDate() == null) continue;

            if (assignment.getDueDate().isBefore(start) || assignment.getDueDate().isAfter(end)) continue;

            if (status != null && !status.isEmpty()) {
                if (assignment.getConfig() != null && assignment.getConfig().getCompanyCompliance() != null) {
                    ComplianceStatus compStatus = assignment.getConfig().getCompanyCompliance().getStatus();
                    if (compStatus != null && !compStatus.name().equals(status)) continue;
                }
            }

            if (categoryId != null) {
                if (assignment.getConfig() == null || assignment.getConfig().getCompanyCompliance() == null) continue;
                Long templateId = assignment.getConfig().getCompanyCompliance().getTemplate().getId();
                if (!templateId.equals(categoryId)) continue;
            }

            CalendarEventDTO event = new CalendarEventDTO();
            event.setId(assignment.getId());

            if (assignment.getConfig() != null && assignment.getConfig().getCompanyCompliance() != null) {
                CompanyCompliance cc = assignment.getConfig().getCompanyCompliance();
                if (cc.getSubTemplate() != null) {
                    event.setTitle(cc.getSubTemplate().getName());
                } else if (cc.getTemplate() != null) {
                    event.setTitle(cc.getTemplate().getName());
                } else {
                    event.setTitle("Compliance");
                }

                if (cc.getTemplate() != null) {
                    event.setCategory(cc.getTemplate().getName());
                }

                if (cc.getStatus() != null) {
                    event.setStatus(cc.getStatus().name());
                }

                if (assignment.getConfig() != null) {
                    event.setDescription(assignment.getConfig().getInstructions());
                }
            }

            event.setStartDate(assignment.getDueDate());
            event.setEndDate(assignment.getDueDate());

            userRepository.findById(assignment.getEmployeeId()).ifPresent(user ->
                    event.setAssignedTo(user.getFullName())
            );

            if (assignment.getConfig() != null && assignment.getConfig().getFrequency() != null) {
                event.setPeriodInfo(assignment.getConfig().getFrequency().getDisplayName());
            }

            event.setIsOverdue(assignment.getDueDate().isBefore(LocalDate.now()) && assignment.getCompletedAt() == null);

            if (assignment.getCompletedAt() == null) {
                event.setDaysRemaining((int) LocalDate.now().until(assignment.getDueDate()).getDays());
            }

            events.add(event);
        }

        events.sort((a, b) -> a.getStartDate().compareTo(b.getStartDate()));

        return events;
    }

    // ==================== SUB-COMPLIANCE DETAILS ====================

    @Transactional(readOnly = true)
    public SubComplianceDetailsDTO getSubComplianceDetails(Long subComplianceId, Long companyId) {
        log.info("Getting sub-compliance details for ID: {}", subComplianceId);

        CompanyCompliance subCC = companyComplianceRepository.findById(subComplianceId)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-compliance not found with ID: " + subComplianceId));

        if (!subCC.getCompany().getId().equals(companyId)) {
            throw new BusinessException("This sub-compliance does not belong to your company");
        }

        SubComplianceDetailsDTO dto = new SubComplianceDetailsDTO();
        dto.setId(subCC.getId());

        if (subCC.getSubTemplate() != null) {
            dto.setName(subCC.getSubTemplate().getName());
            dto.setDescription(subCC.getSubTemplate().getDescription());
            dto.setParentId(subCC.getTemplate().getId());
            dto.setParentName(subCC.getTemplate().getName());
        }

        dto.setStatus(subCC.getStatus());
        dto.setIsActive(subCC.getIsActive());

        configRepository.findByCompanyComplianceId(subCC.getId()).ifPresent(config -> {
            dto.setIsConfigured(true);
            dto.setFrequency(config.getFrequency() != null ? config.getFrequency().name() : null);

            LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
            if (effectiveDueDate != null) {
                dto.setDueDate(effectiveDueDate.atStartOfDay());
            }

            dto.setInstructions(config.getInstructions());
            dto.setDocumentRequired(config.getDocumentRequired());
            dto.setExternalLink(config.getExternalLink());
            dto.setReminderDaysBefore(config.getFrequency() != null ? config.getReminderDaysBefore() : null);
        });

        List<EmployeeAssignment> assignments = assignmentRepository.findByConfigIdAndIsActiveTrue(
                configRepository.findByCompanyComplianceId(subCC.getId()).map(ComplianceConfig::getId).orElse(null));

        if (assignments != null) {
            for (EmployeeAssignment assignment : assignments) {
                if (assignment.getCompletedAt() != null) {
                    dto.setCompletedAt(assignment.getCompletedAt());
                    userRepository.findById(assignment.getCompletedBy()).ifPresent(user ->
                            dto.setCompletedByEmployeeName(user.getFullName())
                    );
                    dto.setSubmissionReference(assignment.getSubmissionReference());
                    dto.setSubmissionDocumentUrl(assignment.getSubmissionDocumentUrl());
                }
            }
        }

        List<ComplianceDocument> documents = documentRepository.findByCompanyComplianceId(subCC.getId());
        List<ComplianceDocumentDTO> docDTOs = documents.stream()
                .map(this::convertToDocumentDTO)
                .collect(Collectors.toList());
        dto.setDocuments(docDTOs);

        List<ComplianceHistory> history = historyRepository.findByCompanyComplianceId(subCC.getId());
        List<ComplianceHistoryDTO> historyDTOs = history.stream()
                .map(this::convertToHistoryDTO)
                .collect(Collectors.toList());
        dto.setHistory(historyDTOs);

        return dto;
    }

    @Transactional(readOnly = true)
    public List<SubmissionHistoryDTO> getSubmissionHistory(Long subComplianceId, Long companyId) {
        log.info("Getting submission history for sub-compliance: {}", subComplianceId);

        CompanyCompliance subCC = companyComplianceRepository.findById(subComplianceId)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-compliance not found"));

        if (!subCC.getCompany().getId().equals(companyId)) {
            throw new BusinessException("Access denied");
        }

        Long configId = configRepository.findByCompanyComplianceId(subCC.getId())
                .map(ComplianceConfig::getId)
                .orElse(null);

        if (configId == null) {
            return new ArrayList<>();
        }

        List<EmployeeAssignment> assignments = assignmentRepository.findByConfigIdAndIsActiveTrue(configId);
        List<SubmissionHistoryDTO> history = new ArrayList<>();

        for (EmployeeAssignment assignment : assignments) {
            if (assignment.getCompletedAt() != null) {
                SubmissionHistoryDTO dto = new SubmissionHistoryDTO();
                dto.setId(assignment.getId());

                userRepository.findById(assignment.getEmployeeId()).ifPresent(user -> {
                    dto.setEmployeeName(user.getFullName());
                    dto.setEmployeeEmail(user.getEmail());
                });

                dto.setDueDate(assignment.getDueDate() != null ? assignment.getDueDate().atStartOfDay() : null);
                dto.setCompletedAt(assignment.getCompletedAt());
                dto.setSubmissionReference(assignment.getSubmissionReference());
                dto.setSubmissionDocumentUrl(assignment.getSubmissionDocumentUrl());

                if (subCC.getSubTemplate() != null) {
                    dto.setPeriodInfo(subCC.getSubTemplate().getName());
                }

                dto.setStatus("COMPLETED");
                history.add(dto);
            }
        }

        history.sort((a, b) -> {
            if (a.getCompletedAt() == null) return 1;
            if (b.getCompletedAt() == null) return -1;
            return b.getCompletedAt().compareTo(a.getCompletedAt());
        });

        return history;
    }

    // ==================== CATEGORY DETAILS (SUPERADMIN) ====================

    @Transactional(readOnly = true)
    public CategoryDetailsDTO getCategoryDetails(Long templateId) {
        log.info("Getting category details for template ID: {}", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found with ID: " + templateId));

        CategoryDetailsDTO dto = new CategoryDetailsDTO();
        dto.setId(template.getId());
        dto.setName(template.getName());
        dto.setDescription(template.getDescription());
        dto.setIsActive(template.getIsActive());
        dto.setEditableForCompanies(template.isEditable());
        dto.setIsSemiEditable(template.isSemiEditable());
        dto.setTemplateType(template.resolveTemplateType());
        dto.setCreatedAt(template.getCreatedAt());
        dto.setUpdatedAt(template.getUpdatedAt());

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(templateId);

        List<CategoryDetailsDTO.SubComplianceInfoDTO> subDtoList = new ArrayList<>();
        for (ComplianceSubTemplate sub : subTemplates) {
            CategoryDetailsDTO.SubComplianceInfoDTO subDto = new CategoryDetailsDTO.SubComplianceInfoDTO();
            subDto.setId(sub.getId());
            subDto.setName(sub.getName());
            subDto.setDescription(sub.getDescription());
            subDto.setIsActive(sub.getIsActive());
            subDto.setDisplayOrder(sub.getDisplayOrder());

            List<CompanyCompliance> subCCs = companyComplianceRepository
                    .findBySubTemplateId(sub.getId());

            boolean isConfigured = false;
            CategoryDetailsDTO.ConfigInfoDTO configDto = null;

            for (CompanyCompliance cc : subCCs) {
                Optional<ComplianceConfig> config = configRepository.findByCompanyComplianceId(cc.getId());
                if (config.isPresent()) {
                    isConfigured = true;
                    configDto = convertToConfigInfoDTO(config.get());
                    break;
                }
            }

            subDto.setIsConfigured(isConfigured);
            subDto.setConfigDetails(configDto);
            subDtoList.add(subDto);
        }
        dto.setSubCompliances(subDtoList);

        if (subTemplates.isEmpty()) {
            if (template.getDirectConfig() != null) {
                dto.setConfig(convertToConfigInfoDTO(template.getDirectConfig()));
            }
        }

        Page<CompanyCompliance> assignments = companyComplianceRepository
                .findByTemplateIdAndIsParentTrueAndDeletedFalse(templateId, Pageable.unpaged());

        List<CategoryDetailsDTO.CompanyAssignmentDTO> companyList = new ArrayList<>();
        int activeCount = 0;
        int configuredCount = 0;
        int completedCount = 0;

        for (CompanyCompliance cc : assignments.getContent()) {
            CategoryDetailsDTO.CompanyAssignmentDTO assignDto = new CategoryDetailsDTO.CompanyAssignmentDTO();
            assignDto.setCompanyId(cc.getCompany().getId());
            assignDto.setCompanyComplianceId(cc.getId());
            assignDto.setCompanyName(cc.getCompany().getName());
            assignDto.setCompanyEmail(cc.getCompany().getEmail());
            assignDto.setComplianceStatus(cc.getStatus() != null ? cc.getStatus().name() : "PENDING");
            assignDto.setIsActive(cc.getIsActive());
            assignDto.setAssignedAt(cc.getCreatedAt() != null ? cc.getCreatedAt().toString() : null);
            assignDto.setNotes(cc.getAdminNotes());

            if (cc.getCreatedBy() != null) {
                userRepository.findById(cc.getCreatedBy()).ifPresent(user ->
                        assignDto.setAssignedByName(user.getFullName())
                );
            }

            Optional<ComplianceConfig> config = configRepository.findByCompanyComplianceId(cc.getId());
            assignDto.setIsConfigured(config.isPresent());

            if (config.isPresent()) {
                configuredCount++;
                LocalDate dueDate = calculateEffectiveDueDate(config.get());
                if (dueDate != null) {
                    assignDto.setDueDate(dueDate.toString());
                }
            }

            if (cc.getStatus() == ComplianceStatus.COMPLETED) {
                completedCount++;
            }

            if (cc.getIsActive() != null && cc.getIsActive()) {
                activeCount++;
            }

            companyList.add(assignDto);
        }

        dto.setAssignments(companyList);
        dto.setTotalCompaniesAssigned(companyList.size());
        dto.setActiveCompaniesCount(activeCount);
        dto.setConfiguredCompaniesCount(configuredCount);
        dto.setPendingConfigCount(companyList.size() - configuredCount);
        dto.setCompletedCount(completedCount);

        return dto;
    }

    // ==================== HISTORY ====================

    @Transactional(readOnly = true)
    public List<ComplianceHistoryDTO> getTemplateHistory(Long templateId) {
        log.info("Getting history for template: {}", templateId);

        List<ComplianceHistoryDTO> historyDTOs = new ArrayList<>();

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found with ID: " + templateId));

        if (template.getCreatedAt() != null) {
            ComplianceHistoryDTO creationDTO = new ComplianceHistoryDTO();
            creationDTO.setAction("Compliance Category Created");
            creationDTO.setRemarks("Created compliance category: " + template.getName() +
                    (template.getDescription() != null ? " - " + template.getDescription() : ""));
            creationDTO.setPerformedAt(template.getCreatedAt());
            creationDTO.setPerformedByName("System Administrator");
            creationDTO.setCompanyName("System");
            historyDTOs.add(creationDTO);
        }

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(templateId);

        for (ComplianceSubTemplate sub : subTemplates) {
            if (sub.getCreatedAt() != null) {
                ComplianceHistoryDTO subDTO = new ComplianceHistoryDTO();
                subDTO.setAction("Sub-Compliance Added");
                subDTO.setRemarks("Added sub-compliance: " + sub.getName() +
                        (sub.getDescription() != null ? " - " + sub.getDescription() : ""));
                subDTO.setPerformedAt(sub.getCreatedAt());
                subDTO.setPerformedByName("System Administrator");
                subDTO.setCompanyName("System");
                historyDTOs.add(subDTO);
            }
        }

        if (template.getDirectConfig() != null && template.getDirectConfig().getCreatedAt() != null) {
            ComplianceConfig config = template.getDirectConfig();
            ComplianceHistoryDTO configDTO = new ComplianceHistoryDTO();
            configDTO.setAction("Compliance Configured");
            configDTO.setRemarks("Configured with frequency: " +
                    (config.getFrequency() != null ? config.getFrequency().getDisplayName() : "N/A"));
            configDTO.setPerformedAt(config.getCreatedAt());
            configDTO.setPerformedByName("System Administrator");
            configDTO.setCompanyName("System");
            historyDTOs.add(configDTO);
        }

        for (ComplianceSubTemplate sub : subTemplates) {
            List<CompanyCompliance> subCCs = companyComplianceRepository
                    .findBySubTemplateId(sub.getId());

            for (CompanyCompliance cc : subCCs) {
                ComplianceConfig config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
                if (config != null && config.getCreatedAt() != null) {
                    ComplianceHistoryDTO configDTO = new ComplianceHistoryDTO();
                    configDTO.setAction("Sub-Compliance Configured");
                    configDTO.setRemarks("Configured sub-compliance: " + sub.getName() +
                            " with frequency: " + (config.getFrequency() != null ? config.getFrequency().getDisplayName() : "N/A"));
                    configDTO.setPerformedAt(config.getCreatedAt());
                    configDTO.setPerformedByName("System Administrator");
                    configDTO.setCompanyName(cc.getCompany() != null ? cc.getCompany().getName() : "System");
                    historyDTOs.add(configDTO);
                    break;
                }
            }
        }

        historyDTOs.sort((a, b) -> {
            if (a.getPerformedAt() == null) return 1;
            if (b.getPerformedAt() == null) return -1;
            return b.getPerformedAt().compareTo(a.getPerformedAt());
        });

        log.info("Found {} history entries for template {}", historyDTOs.size(), templateId);
        return historyDTOs;
    }

    // ==================== TEMPLATE STATS FOR SUPERADMIN ====================

    @Transactional(readOnly = true)
    public Page<ComplianceTemplateSummaryDTO> getSuperAdminTemplatesWithStats(Pageable pageable) {
        return getSuperAdminTemplatesWithStats(null, pageable);
    }

    @Transactional(readOnly = true)
    public Page<ComplianceTemplateSummaryDTO> getSuperAdminTemplatesWithStats(String search, Pageable pageable) {
        Page<ComplianceTemplate> templatePage;
        if (search != null && !search.trim().isEmpty()) {
            templatePage = templateRepository.searchSuperAdminTemplates(search.trim(), pageable);
        } else {
            templatePage = templateRepository.findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc(pageable);
        }
        List<ComplianceTemplate> templates = templatePage.getContent();

        if (templates.isEmpty()) {
            return new PageImpl<>(Collections.emptyList(), pageable, 0);
        }

        List<Long> templateIds = templates.stream()
                .map(ComplianceTemplate::getId)
                .collect(Collectors.toList());

        Map<Long, Integer> subCountMap = new HashMap<>();
        List<Object[]> subCounts = subTemplateRepository.countSubTemplatesByTemplateIds(templateIds);
        for (Object[] row : subCounts) {
            Long id = (Long) row[0];
            Long count = (Long) row[1];
            subCountMap.put(id, count.intValue());
        }

        Map<Long, Integer> assignedCountMap = new HashMap<>();
        List<Object[]> assignedCounts = companyComplianceRepository.countAssignedCompaniesByTemplateIds(templateIds);
        for (Object[] row : assignedCounts) {
            Long id = (Long) row[0];
            Long count = (Long) row[1];
            assignedCountMap.put(id, count.intValue());
        }

        List<ComplianceConfig> directConfigs = configRepository.findAllByTemplateIds(templateIds);
        Set<Long> configuredTemplateIds = directConfigs.stream()
                .map(cc -> cc.getTemplate().getId())
                .collect(Collectors.toSet());

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findAllByParentTemplateIds(templateIds);
        List<Long> subTemplateIds = subTemplates.stream()
                .map(ComplianceSubTemplate::getId)
                .collect(Collectors.toList());
        if (!subTemplateIds.isEmpty()) {
            List<ComplianceConfig> subConfigs = configRepository.findAllBySubTemplateIds(subTemplateIds);
            Set<Long> subTemplateIdsWithConfig = subConfigs.stream()
                    .map(cc -> cc.getSubTemplate().getId())
                    .collect(Collectors.toSet());
            for (ComplianceSubTemplate st : subTemplates) {
                if (subTemplateIdsWithConfig.contains(st.getId())) {
                    configuredTemplateIds.add(st.getParentTemplate().getId());
                }
            }
        }

        List<ComplianceTemplateSummaryDTO> dtos = new ArrayList<>();
        for (ComplianceTemplate template : templates) {
            ComplianceTemplateSummaryDTO dto = new ComplianceTemplateSummaryDTO();
            dto.setId(template.getId());
            dto.setName(template.getName());
            dto.setDescription(template.getDescription());
            dto.setIsActive(template.getIsActive());
            dto.setIsCompanySpecific(template.getIsCompanySpecific());
            dto.setPriority(template.getPriority());
            dto.setEditableForCompanies(template.isEditable());
            dto.setIsSemiEditable(template.isSemiEditable());
            dto.setTemplateType(template.resolveTemplateType());
            dto.setCreatedAt(template.getCreatedAt());
            dto.setUpdatedAt(template.getUpdatedAt());
            dto.setSubTemplateCount(subCountMap.getOrDefault(template.getId(), 0));
            dto.setAssignedCompaniesCount(assignedCountMap.getOrDefault(template.getId(), 0));
            dto.setConfigured(configuredTemplateIds.contains(template.getId()));
            dtos.add(dto);
        }

        return new PageImpl<>(dtos, pageable, templatePage.getTotalElements());
    }

    // ==================== HELPERS ====================

    LocalDate calculateDueDate(ComplianceConfig config) {
        return calculateEffectiveDueDate(config);
    }

    public LocalDate calculateEffectiveDueDate(ComplianceConfig config) {
        if (config == null || config.getFrequency() == null) {
            return null;
        }

        LocalDate today = LocalDate.now(IST_ZONE);
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();
        int fiscalYear = (currentMonth >= 4) ? currentYear : currentYear - 1;

        switch (config.getFrequency()) {
            case ONE_TIME:
                return config.getCustomDueDate() != null ? config.getCustomDueDate() : config.getDueDate();
            case MONTHLY:
                int dayOfMonth = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                int lastDay = today.lengthOfMonth();
                return LocalDate.of(today.getYear(), today.getMonth(), Math.min(dayOfMonth, lastDay));
            case QUARTERLY:
                int quarter = config.getDueQuarter() != null ? config.getDueQuarter() : 1;
                int monthInQuarter = 1;
                if (config.getDueMonth() != null) {
                    if (config.getDueMonth() >= 1 && config.getDueMonth() <= 3) {
                        monthInQuarter = config.getDueMonth();
                    } else if (config.getDueMonth() >= 4 && config.getDueMonth() <= 12) {
                        monthInQuarter = ((config.getDueMonth() - 1) % 3) + 1;
                    }
                }
                int monthOffset = (quarter - 1) * 3 + (monthInQuarter - 1);
                int month = 4 + monthOffset;
                int year = fiscalYear;
                if (month > 12) {
                    month -= 12;
                    year += 1;
                }
                int qDay = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                LocalDate firstOfMonth = LocalDate.of(year, month, 1);
                int lastDayOfMonth = firstOfMonth.lengthOfMonth();
                return LocalDate.of(year, month, Math.min(qDay, lastDayOfMonth));
            case HALF_YEARLY:
                int half = config.getDueHalf() != null ? config.getDueHalf() : 1;
                int monthInHalf = 1;
                if (config.getDueMonth() != null) {
                    if (config.getDueMonth() >= 1 && config.getDueMonth() <= 6) {
                        monthInHalf = config.getDueMonth();
                    } else if (config.getDueMonth() >= 7 && config.getDueMonth() <= 12) {
                        monthInHalf = ((config.getDueMonth() - 1) % 6) + 1;
                    }
                }
                int hMonthOffset = (half - 1) * 6 + (monthInHalf - 1);
                int hMonth = 4 + hMonthOffset;
                int hYear = fiscalYear;
                if (hMonth > 12) {
                    hMonth -= 12;
                    hYear += 1;
                }
                int hDay = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                LocalDate hFirst = LocalDate.of(hYear, hMonth, 1);
                int hLast = hFirst.lengthOfMonth();
                return LocalDate.of(hYear, hMonth, Math.min(hDay, hLast));
            case YEARLY:
                int yearMonth = config.getDueMonth() != null ? config.getDueMonth() : 1;
                int yDay = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                LocalDate yFirst = LocalDate.of(today.getYear(), yearMonth, 1);
                int yLast = yFirst.lengthOfMonth();
                return LocalDate.of(today.getYear(), yearMonth, Math.min(yDay, yLast));
            default:
                return null;
        }
    }

    public LocalDate getNextDueDateForCompliance(CompanyCompliance companyCompliance) {
        if (companyCompliance.getStatus() != ComplianceStatus.COMPLETED) {
            Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(companyCompliance.getId());
            if (configOpt.isPresent()) {
                ComplianceConfig config = configOpt.get();
                return config.getDueDate() != null ? config.getDueDate() : calculateEffectiveDueDate(config);
            }
            return null;
        }

        Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(companyCompliance.getId());
        if (configOpt.isEmpty()) {
            return null;
        }

        ComplianceConfig config = configOpt.get();
        if (config.getFrequency() == null || config.getFrequency() == ComplianceFrequency.ONE_TIME) {
            return null;
        }

        LocalDate currentDueDate = config.getCustomDueDate() != null ? config.getCustomDueDate() : config.getDueDate();
        if (currentDueDate == null) {
            currentDueDate = calculateEffectiveDueDate(config);
        }
        if (currentDueDate == null) {
            return null;
        }

        switch (config.getFrequency()) {
            case MONTHLY:
                return advanceDueDate(currentDueDate, ComplianceFrequency.MONTHLY, config.getDueDayOfMonth());
            case QUARTERLY:
                return advanceDueDate(currentDueDate, ComplianceFrequency.QUARTERLY, config.getDueDayOfMonth());
            case HALF_YEARLY:
                return advanceDueDate(currentDueDate, ComplianceFrequency.HALF_YEARLY, config.getDueDayOfMonth());
            case YEARLY:
                return advanceDueDate(currentDueDate, ComplianceFrequency.YEARLY, config.getDueDayOfMonth());
            default:
                return null;
        }
    }

    public LocalDate advanceDueDate(LocalDate currentDue, ComplianceFrequency frequency, Integer dueDayOfMonth) {
        if (currentDue == null || frequency == null) return currentDue;
        int targetDay = dueDayOfMonth != null ? dueDayOfMonth : currentDue.getDayOfMonth();
        switch (frequency) {
            case MONTHLY: {
                LocalDate nextMonth = currentDue.plusMonths(1);
                int maxDays = nextMonth.lengthOfMonth();
                return LocalDate.of(nextMonth.getYear(), nextMonth.getMonth(), Math.min(targetDay, maxDays));
            }
            case QUARTERLY: {
                LocalDate nextQuarter = currentDue.plusMonths(3);
                int maxDays = nextQuarter.lengthOfMonth();
                return LocalDate.of(nextQuarter.getYear(), nextQuarter.getMonth(), Math.min(targetDay, maxDays));
            }
            case HALF_YEARLY: {
                LocalDate nextHalf = currentDue.plusMonths(6);
                int maxDays = nextHalf.lengthOfMonth();
                return LocalDate.of(nextHalf.getYear(), nextHalf.getMonth(), Math.min(targetDay, maxDays));
            }
            case YEARLY: {
                LocalDate nextYear = currentDue.plusYears(1);
                int maxDays = nextYear.lengthOfMonth();
                return LocalDate.of(nextYear.getYear(), nextYear.getMonth(), Math.min(targetDay, maxDays));
            }
            default:
                return currentDue;
        }
    }

    @Transactional
    public void renewCompletedRecurringCompliances() {
        renewCompletedRecurringCompliancesForCompany(null);
    }

    @Transactional
    public void renewCompletedRecurringCompliancesForCompany(Long targetCompanyId) {
        LocalDate today = LocalDate.now(IST_ZONE);

        List<CompanyCompliance> completedRecurring = (targetCompanyId != null
                ? companyComplianceRepository.findByCompanyIdAndIsActiveTrueAndDeletedFalse(targetCompanyId)
                : companyComplianceRepository.findAll()).stream()
                .filter(cc -> cc.getStatus() == ComplianceStatus.COMPLETED || cc.getCompletedAt() != null)
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> !isParentWithSubCompliances(cc))
                .collect(Collectors.toList());

        if (completedRecurring.isEmpty()) {
            return;
        }

        for (CompanyCompliance cc : completedRecurring) {
            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                // Check template-level fallback config
                ComplianceConfig templateCfg = configRepository
                        .findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId())
                        .orElse(null);
                if (templateCfg != null && templateCfg.getFrequency() != null && templateCfg.getFrequency() != ComplianceFrequency.ONE_TIME) {
                    config = new ComplianceConfig();
                    config.setCompanyCompliance(cc);
                    config.setFrequency(templateCfg.getFrequency());
                    config.setDueDate(templateCfg.getDueDate());
                    config.setCustomDueDate(templateCfg.getCustomDueDate());
                    config.setDueDayOfMonth(templateCfg.getDueDayOfMonth());
                    config.setInstructions(templateCfg.getInstructions());
                    config.setDocumentRequired(templateCfg.getDocumentRequired());
                    config = configRepository.save(config);
                    cc.setConfig(config);
                }
            }
            if (config == null || config.getFrequency() == null
                    || config.getFrequency() == ComplianceFrequency.ONE_TIME) {
                continue;
            }

            LocalDate lastDueDate = config.getDueDate() != null ? config.getDueDate() : config.getCustomDueDate();
            if (lastDueDate == null) {
                lastDueDate = calculateEffectiveDueDate(config);
            }
            if (lastDueDate == null) continue;

            boolean shouldRenew = false;
            LocalDate nextDueDate = lastDueDate;

            if (config.getFrequency() == ComplianceFrequency.MONTHLY) {
                if (YearMonth.from(lastDueDate).isBefore(YearMonth.from(today))) {
                    shouldRenew = true;
                    while (YearMonth.from(nextDueDate).isBefore(YearMonth.from(today))) {
                        nextDueDate = advanceDueDate(nextDueDate, ComplianceFrequency.MONTHLY, config.getDueDayOfMonth());
                    }
                }
            } else if (config.getFrequency() == ComplianceFrequency.QUARTERLY) {
                if (nextDueDate.plusMonths(3).isBefore(today) || YearMonth.from(nextDueDate.plusMonths(1)).isBefore(YearMonth.from(today))) {
                    LocalDate advanced = advanceDueDate(nextDueDate, ComplianceFrequency.QUARTERLY, config.getDueDayOfMonth());
                    if (advanced.isAfter(nextDueDate)) {
                        shouldRenew = true;
                        nextDueDate = advanced;
                    }
                }
            } else if (config.getFrequency() == ComplianceFrequency.HALF_YEARLY) {
                if (nextDueDate.plusMonths(6).isBefore(today)) {
                    LocalDate advanced = advanceDueDate(nextDueDate, ComplianceFrequency.HALF_YEARLY, config.getDueDayOfMonth());
                    if (advanced.isAfter(nextDueDate)) {
                        shouldRenew = true;
                        nextDueDate = advanced;
                    }
                }
            } else if (config.getFrequency() == ComplianceFrequency.YEARLY) {
                if (nextDueDate.getYear() < today.getYear()) {
                    LocalDate advanced = advanceDueDate(nextDueDate, ComplianceFrequency.YEARLY, config.getDueDayOfMonth());
                    if (advanced.isAfter(nextDueDate)) {
                        shouldRenew = true;
                        nextDueDate = advanced;
                    }
                }
            }

            if (!shouldRenew || !nextDueDate.isAfter(lastDueDate)) {
                continue;
            }

            log.info("Renewing recurring compliance ID: {} for company: {} from {} to next due date: {}",
                    cc.getId(), cc.getCompany() != null ? cc.getCompany().getName() : "N/A", lastDueDate, nextDueDate);

            try {
                addHistoryForCompanyCompliance(cc, ComplianceStatus.COMPLETED, ComplianceStatus.PENDING,
                        "RECURRING_RENEWED", "Cycle completed for due date " + lastDueDate + ". Rolled forward to next due date " + nextDueDate, null);
            } catch (Exception e) {
                log.debug("History recording for renewal skipped: {}", e.getMessage());
            }

            config.setDueDate(nextDueDate);
            config.setCustomDueDate(nextDueDate);
            config.setUpdatedAt(LocalDateTime.now(IST_ZONE));
            configRepository.save(config);

            cc.setStatus(ComplianceStatus.PENDING);
            cc.setCompletedAt(null);
            cc.setCompletedBy(null);
            cc.setAdminSubmissionReference(null);
            cc.setAdminSubmissionDocumentUrl(null);
            companyComplianceRepository.save(cc);

            List<EmployeeAssignment> oldAssignments = assignmentRepository
                    .findByConfigIdAndIsActiveTrue(config.getId());
            if (!oldAssignments.isEmpty()) {
                for (EmployeeAssignment old : oldAssignments) {
                    old.setDueDate(nextDueDate);
                    old.setCompletedAt(null);
                    old.setSubmissionReference(null);
                    old.setSubmissionDocumentUrl(null);
                    old.setCompletedBy(null);
                    old.setIsOverdue(false);
                    old.setOverdueNotifiedAt(null);
                    old.setLastReminderSent(null);
                    assignmentRepository.save(old);
                }
            }
        }
    }

    private void addHistoryForTemplate(Long templateId, String action, String remarks, Long performedBy) {
        log.info("Template history - template: {}, action: {}, remarks: {}, performedBy: {}",
                templateId, action, remarks, performedBy);
    }

    private void addHistoryForConfig(Long configId, String action, String remarks, Long performedBy) {
        log.info("History added for config {}: {} - {}", configId, action, remarks);
    }

    public void addHistoryForCompanyCompliance(CompanyCompliance companyCompliance, ComplianceStatus oldStatus,
                                               ComplianceStatus newStatus, String action, String remarks, User performedBy) {
        ComplianceHistory history = new ComplianceHistory();
        history.setCompanyCompliance(companyCompliance);
        history.setPreviousStatus(oldStatus);
        history.setNewStatus(newStatus);
        history.setAction(action);
        history.setRemarks(remarks);
        history.setPerformedBy(performedBy);
        history.setPerformedAt(LocalDateTime.now(IST_ZONE));
        historyRepository.save(history);
    }

    private ComplianceConfigDTO createConfigForTemplate(ComplianceTemplate template, ComplianceConfigDTO dto,
                                                        Long adminId, boolean isSuperAdminConfig) {
        log.info("Creating config for template: {}", template.getId());

        List<Company> activeCompanies = companyRepository.findActiveCompaniesByStatus(CompanyStatus.ACTIVE);

        if (activeCompanies.isEmpty()) {
            log.warn("No active companies found to assign compliance");
            throw new BusinessException("No active companies available for auto-assignment");
        }

        ComplianceConfigDTO result = null;

        for (Company company : activeCompanies) {
            CompanyCompliance companyCompliance = companyComplianceRepository
                    .findByCompanyIdAndTemplateIdAndIsParentTrue(company.getId(), template.getId())
                    .orElse(null);

            if (companyCompliance == null) {
                companyCompliance = new CompanyCompliance();
                companyCompliance.setCompany(company);
                companyCompliance.setTemplate(template);
                companyCompliance.setIsParent(true);
                companyCompliance.setParentTemplateId(null);
                companyCompliance.setStatus(ComplianceStatus.PENDING);
                companyCompliance.setIsActive(true);
                companyCompliance.setCreatedBy(adminId);
                companyCompliance.setIsSuperAdminConfig(isSuperAdminConfig);
                companyCompliance = companyComplianceRepository.save(companyCompliance);
            }

            ComplianceConfig config = configRepository.findByCompanyComplianceId(companyCompliance.getId())
                    .orElse(new ComplianceConfig());

            config.setCompanyCompliance(companyCompliance);
            config.setFrequency(dto.getFrequency());
            if (dto.getFrequency() == null) {
                config.setDueDate(null);
                config.setCustomDueDate(null);
                config.setDueDayOfMonth(null);
                config.setDueQuarter(null);
                config.setDueHalf(null);
                config.setDueMonth(null);
                config.setReminderDaysBefore(null);
                config.setRepeatReminder(null);
                config.setReminderIntervalDays(null);
            } else {
                config.setCustomDueDate(dto.getCustomDueDate());
                config.setDueDayOfMonth(dto.getDueDayOfMonth());
                config.setDueQuarter(dto.getDueQuarter());
                config.setDueHalf(dto.getDueHalf());
                config.setDueMonth(dto.getDueMonth());
                config.setDueDate(dto.getDueDate() != null ? dto.getDueDate() : calculateEffectiveDueDate(config));
                config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
                config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
                config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
            }

            config.setDescription(dto.getDescription());
            config.setDocumentRequired(dto.getDocumentRequired());
            config.setExternalLink(dto.getExternalLink());
            config.setInstructions(dto.getInstructions());
            config.setIsActive(true);
            config.setConfiguredBy(adminId);
            config.setIsSuperAdminConfig(isSuperAdminConfig);

            config = configRepository.save(config);

            companyCompliance.setStatus(ComplianceStatus.IN_PROGRESS);
            companyComplianceRepository.save(companyCompliance);

            if (result == null) {
                result = convertToConfigDTO(config);
            }

            sendAssignmentEmailToCompany(company, template);
        }

        return result;
    }

    private void copyConfigToCompany(ComplianceConfig sourceConfig, CompanyCompliance targetCC, Long adminId) {
        if (sourceConfig == null || targetCC == null) return;
        ComplianceConfig newConfig = new ComplianceConfig();
        newConfig.setCompanyCompliance(targetCC);
        newConfig.setFrequency(sourceConfig.getFrequency());
        newConfig.setDueDate(sourceConfig.getDueDate());
        newConfig.setCustomDueDate(sourceConfig.getCustomDueDate());
        newConfig.setDueDayOfMonth(sourceConfig.getDueDayOfMonth());
        newConfig.setDueQuarter(sourceConfig.getDueQuarter());
        newConfig.setDueHalf(sourceConfig.getDueHalf());
        newConfig.setDueMonth(sourceConfig.getDueMonth());
        newConfig.setReminderDaysBefore(sourceConfig.getReminderDaysBefore());
        newConfig.setRepeatReminder(sourceConfig.getRepeatReminder());
        newConfig.setReminderIntervalDays(sourceConfig.getReminderIntervalDays());
        newConfig.setDescription(sourceConfig.getDescription());
        newConfig.setDocumentRequired(sourceConfig.getDocumentRequired());
        newConfig.setExternalLink(sourceConfig.getExternalLink());
        newConfig.setInstructions(sourceConfig.getInstructions());
        newConfig.setIsActive(true);
        newConfig.setConfiguredBy(adminId);
        newConfig.setIsSuperAdminConfig(true);
        configRepository.save(newConfig);
        targetCC.setStatus(ComplianceStatus.IN_PROGRESS);
        companyComplianceRepository.save(targetCC);
        log.info("Config copied to company compliance: {}", targetCC.getId());
    }

    public void sendAssignmentEmailToCompany(Company company, ComplianceTemplate template) {
        try {
            String subject = "New Compliance Category Assigned: " + template.getName();
            String content = String.format("Dear Team,\n\nA new compliance category has been assigned to your company.\n\nCompliance Category: %s\n\nPlease log in to configure this compliance.\n\nBest regards,\nVNext LLP", template.getName());
            if (company.getCompanyAdmin() != null) {
                emailService.sendSimpleEmail(company.getCompanyAdmin().getEmail(), subject, content);
            }
        } catch (Exception e) {
            log.error("Failed to send assignment email to company: {}", company.getId(), e);
        }
    }

    // ==================== DTO CONVERTERS ====================

    private ComplianceTemplateDTO convertToTemplateDTO(ComplianceTemplate template) {
        ComplianceTemplateDTO dto = new ComplianceTemplateDTO();
        dto.setId(template.getId());
        dto.setName(template.getName());
        dto.setDescription(template.getDescription());
        dto.setIsActive(template.getIsActive());
        dto.setIsCompanySpecific(template.getIsCompanySpecific());
        dto.setCompanyId(template.getCompany() != null ? template.getCompany().getId() : null);
        dto.setCompanyName(template.getCompany() != null ? template.getCompany().getName() : null);
        dto.setPriority(template.getPriority() != null ? template.getPriority() : 0);
        dto.setEditableForCompanies(template.isEditable());
        dto.setIsSemiEditable(template.isSemiEditable());
        dto.setTemplateType(template.resolveTemplateType());
        dto.setCreatedAt(template.getCreatedAt());
        return dto;
    }

    private ComplianceSubTemplateDTO convertToSubTemplateDTO(ComplianceSubTemplate subTemplate) {
        ComplianceSubTemplateDTO dto = new ComplianceSubTemplateDTO();
        dto.setId(subTemplate.getId());
        dto.setParentTemplateId(subTemplate.getParentTemplate().getId());
        dto.setParentTemplateName(subTemplate.getParentTemplate().getName());
        dto.setName(subTemplate.getName());
        dto.setDescription(subTemplate.getDescription());
        dto.setDisplayOrder(subTemplate.getDisplayOrder() != null ? subTemplate.getDisplayOrder() : 0);
        dto.setIsActive(subTemplate.getIsActive());
        if (subTemplate.getCompany() != null) {
            dto.setCompanyId(subTemplate.getCompany().getId());
            dto.setCompanyName(subTemplate.getCompany().getName());
        }
        return dto;
    }

    private ComplianceConfigDTO convertToConfigDTO(ComplianceConfig config) {
        ComplianceConfigDTO dto = new ComplianceConfigDTO();
        dto.setId(config.getId());
        dto.setFrequency(config.getFrequency());

        if (config.getFrequency() != null) {
            dto.setDueDate(config.getDueDate());
            dto.setCustomDueDate(config.getCustomDueDate());
            dto.setDueDayOfMonth(config.getDueDayOfMonth());
            dto.setDueQuarter(config.getDueQuarter());
            dto.setDueHalf(config.getDueHalf());
            dto.setDueMonth(config.getDueMonth());
            dto.setReminderDaysBefore(config.getReminderDaysBefore());
            dto.setRepeatReminder(config.getRepeatReminder());
            dto.setReminderIntervalDays(config.getReminderIntervalDays());

            LocalDate effectiveDueDate = config.getDueDate() != null ? config.getDueDate()
                    : (config.getCustomDueDate() != null ? config.getCustomDueDate() : calculateEffectiveDueDate(config));
            dto.setEffectiveDueDate(effectiveDueDate);
            if (effectiveDueDate != null) {
                dto.setDueDate(effectiveDueDate);
            }
        } else {
            dto.setDueDate(null);
            dto.setCustomDueDate(null);
            dto.setDueDayOfMonth(null);
            dto.setDueQuarter(null);
            dto.setDueHalf(null);
            dto.setDueMonth(null);
            dto.setReminderDaysBefore(null);
            dto.setRepeatReminder(false);
            dto.setReminderIntervalDays(null);
            dto.setEffectiveDueDate(null);
        }

        dto.setDescription(config.getDescription());
        dto.setDocumentRequired(config.getDocumentRequired());
        dto.setExternalLink(config.getExternalLink());
        dto.setInstructions(config.getInstructions());
        dto.setIsActive(config.getIsActive());
        dto.setIsSuperAdminConfig(config.getIsSuperAdminConfig());
        dto.setCreatedAt(config.getCreatedAt());
        dto.setConfigured(true);

        if (config.getSubTemplate() != null) {
            dto.setSubTemplateId(config.getSubTemplate().getId());
            dto.setSubTemplateName(config.getSubTemplate().getName());
        }

        if (config.getCompanyCompliance() != null) {
            dto.setCompanyComplianceId(config.getCompanyCompliance().getId());
            dto.setCompanyId(config.getCompanyCompliance().getCompany().getId());
            dto.setCompanyName(config.getCompanyCompliance().getCompany().getName());

            ComplianceStatus actualStatus = config.getCompanyCompliance().getStatus();
            if (actualStatus != ComplianceStatus.COMPLETED && config.getCompanyCompliance().getCompletedAt() == null) {
                LocalDate effDue = dto.getEffectiveDueDate();
                if (effDue != null) {
                    if (effDue.isBefore(LocalDate.now(IST_ZONE))) {
                        actualStatus = ComplianceStatus.OVERDUE;
                    } else if (actualStatus == ComplianceStatus.OVERDUE) {
                        actualStatus = ComplianceStatus.IN_PROGRESS;
                    }
                }
            }
            if (actualStatus != null) {
                dto.setStatus(actualStatus);
            }

            if (config.getCompanyCompliance().getTemplate() != null) {
                dto.setTemplateId(config.getCompanyCompliance().getTemplate().getId());
                dto.setTemplateName(config.getCompanyCompliance().getTemplate().getName());
            }
            if (config.getCompanyCompliance().getSubTemplate() != null) {
                dto.setSubTemplateId(config.getCompanyCompliance().getSubTemplate().getId());
                dto.setSubTemplateName(config.getCompanyCompliance().getSubTemplate().getName());
            }

            if (config.getCompanyCompliance().getStatus() == ComplianceStatus.COMPLETED &&
                    config.getFrequency() != null) {
                LocalDate nextDueDate = getNextDueDateForCompliance(config.getCompanyCompliance());
                dto.setNextDueDate(nextDueDate);
            } else if (config.getFrequency() != null) {
                dto.setNextDueDate(dto.getEffectiveDueDate());
            } else {
                dto.setNextDueDate(null);
            }
        }

        return dto;
    }

    private CompanyComplianceDTO convertToCompanyComplianceDTO(CompanyCompliance cc) {
        CompanyComplianceDTO dto = new CompanyComplianceDTO();
        dto.setId(cc.getId());
        dto.setIsActive(cc.getIsActive());

        if (cc.getCompany() != null) {
            dto.setCompanyId(cc.getCompany().getId());
            dto.setCompanyName(cc.getCompany().getName());
        }
        if (cc.getTemplate() != null) {
            dto.setTemplateId(cc.getTemplate().getId());
            dto.setTemplateName(cc.getTemplate().getName());
            dto.setCategory(cc.getTemplate().getName());
            dto.setPriority(cc.getTemplate().getPriority() != null ? cc.getTemplate().getPriority() : 0);
            dto.setTemplateType(cc.getTemplate().resolveTemplateType().name());
            dto.setIsSemiEditable(cc.getTemplate().isSemiEditable());
            dto.setEditableForCompanies(cc.getTemplate().isEditable());
        }

        if (cc.getSubTemplate() != null) {
            dto.setSubTemplateId(cc.getSubTemplate().getId());
            dto.setSubTemplateName(cc.getSubTemplate().getName());
        }

        dto.setIsParent(cc.isParent());
        dto.setAssignedAt(cc.getCreatedAt());
        dto.setNotes(cc.getAdminNotes());

        ComplianceConfig config = cc.getConfig();
        if (config == null) {
            config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
        }
        boolean isConfigured = config != null;
        dto.setConfigured(isConfigured);

        ComplianceStatus status = cc.getStatus() != null ? cc.getStatus() : ComplianceStatus.PENDING;
        LocalDateTime completedAt = cc.getCompletedAt();
        String submissionReference = cc.getAdminSubmissionReference();
        String submissionDocumentUrl = cc.getAdminSubmissionDocumentUrl();

        if (config != null && config.getFrequency() != null) {
            dto.setFrequency(config.getFrequency().name());
            LocalDate effectiveDueDate = config.getDueDate() != null ? config.getDueDate()
                    : (config.getCustomDueDate() != null ? config.getCustomDueDate() : calculateEffectiveDueDate(config));
            dto.setEffectiveDueDate(effectiveDueDate);
            dto.setDueDate(effectiveDueDate);

            if (status != ComplianceStatus.COMPLETED && completedAt == null) {
                if (effectiveDueDate != null) {
                    if (effectiveDueDate.isBefore(LocalDate.now(IST_ZONE))) {
                        status = ComplianceStatus.OVERDUE;
                    } else if (status == ComplianceStatus.OVERDUE) {
                        status = ComplianceStatus.IN_PROGRESS;
                    }
                }
            }

            if (status == ComplianceStatus.COMPLETED) {
                LocalDate nextDueDate = getNextDueDateForCompliance(cc);
                dto.setNextDueDate(nextDueDate);
            } else {
                dto.setNextDueDate(effectiveDueDate);
            }
        }

        if (status == ComplianceStatus.COMPLETED || completedAt != null) {
            status = ComplianceStatus.COMPLETED;
            if (completedAt == null) completedAt = cc.getCompletedAt() != null ? cc.getCompletedAt() : cc.getUpdatedAt();
        }

        dto.setStatus(status);
        dto.setSubmissionReference(submissionReference);
        dto.setSubmissionDocumentUrl(submissionDocumentUrl);

        if (status == ComplianceStatus.COMPLETED) {
            dto.setCompletedAt(completedAt != null ? completedAt : cc.getUpdatedAt());
            dto.setCompletedByName("Company Admin");
        } else {
            dto.setCompletedAt(null);
            dto.setCompletedByName(null);
        }

        return dto;
    }

    private CategoryDetailsDTO.ConfigInfoDTO convertToConfigInfoDTO(ComplianceConfig config) {
        if (config == null) return null;

        CategoryDetailsDTO.ConfigInfoDTO dto = new CategoryDetailsDTO.ConfigInfoDTO();
        dto.setId(config.getId());
        dto.setFrequency(config.getFrequency() != null ? config.getFrequency().name() : null);
        if (config.getFrequency() != null) {
            dto.setCustomDueDate(config.getCustomDueDate() != null ? config.getCustomDueDate().toString() : null);
            dto.setDueDayOfMonth(config.getDueDayOfMonth());
            dto.setDueQuarter(config.getDueQuarter());
            dto.setDueHalf(config.getDueHalf());
            dto.setDueMonth(config.getDueMonth());
            dto.setReminderDaysBefore(config.getReminderDaysBefore());
            dto.setRepeatReminder(config.getRepeatReminder());
            dto.setReminderIntervalDays(config.getReminderIntervalDays());
            LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
            if (effectiveDueDate != null) {
                dto.setEffectiveDueDate(effectiveDueDate.toString());
            }
        } else {
            dto.setCustomDueDate(null);
            dto.setDueDayOfMonth(null);
            dto.setDueQuarter(null);
            dto.setDueHalf(null);
            dto.setDueMonth(null);
            dto.setReminderDaysBefore(null);
            dto.setRepeatReminder(false);
            dto.setReminderIntervalDays(null);
            dto.setEffectiveDueDate(null);
        }
        dto.setDescription(config.getDescription());
        dto.setDocumentRequired(config.getDocumentRequired());
        dto.setExternalLink(config.getExternalLink());
        dto.setInstructions(config.getInstructions());
        dto.setIsActive(config.getIsActive());

        return dto;
    }

    private ComplianceDocumentDTO convertToDocumentDTO(ComplianceDocument doc) {
        ComplianceDocumentDTO dto = new ComplianceDocumentDTO();
        dto.setId(doc.getId());
        dto.setDocumentName(doc.getDocumentName());
        dto.setDocumentUrl(doc.getDocumentUrl());
        dto.setDocumentType(doc.getDocumentType());
        dto.setFileSize(doc.getFileSize());
        dto.setUploadedAt(doc.getUploadedAt());
        dto.setRemarks(doc.getRemarks());

        if (doc.getUploadedBy() != null) {
            dto.setUploadedByName(doc.getUploadedBy().getFullName());
        }

        return dto;
    }

    private ComplianceHistoryDTO convertToHistoryDTO(ComplianceHistory history) {
        ComplianceHistoryDTO dto = new ComplianceHistoryDTO();
        dto.setId(history.getId());
        dto.setAction(history.getAction());
        dto.setRemarks(history.getRemarks());
        dto.setPerformedAt(history.getPerformedAt());

        if (history.getPreviousStatus() != null) {
            dto.setPreviousStatus(history.getPreviousStatus().name());
        }
        if (history.getNewStatus() != null) {
            dto.setNewStatus(history.getNewStatus().name());
        }

        if (history.getPerformedBy() != null) {
            dto.setPerformedByName(history.getPerformedBy().getFullName());
        }

        return dto;
    }

    public String getFrequencyLabel(ComplianceFrequency freq) {
        if (freq == null) return "None";
        switch (freq) {
            case ONE_TIME:   return "One Time";
            case MONTHLY:    return "Monthly";
            case QUARTERLY:  return "Quarterly";
            case HALF_YEARLY: return "Half Yearly";
            case YEARLY:     return "Yearly";
            default:         return freq.name();
        }
    }

    private String getComplianceName(ComplianceConfig config) {
        if (config.getCompanyCompliance() != null) {
            if (config.getCompanyCompliance().getSubTemplate() != null) {
                return config.getCompanyCompliance().getSubTemplate().getName();
            }
            if (config.getCompanyCompliance().getTemplate() != null) {
                return config.getCompanyCompliance().getTemplate().getName();
            }
        }
        return "Compliance";
    }

    // ==================== DEBUG ====================

    @Transactional(readOnly = true)
    public void debugTemplateConfigs(Long templateId) {
        log.info("=== DEBUG: Checking configs for template ID: {} ===", templateId);

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(templateId);

        for (ComplianceSubTemplate sub : subTemplates) {
            Optional<ComplianceConfig> config = configRepository
                    .findByTemplateIdAndCompanyComplianceId(sub.getId(), null);
            if (config.isPresent()) {
                log.info("FOUND config for sub-template {}: {}", sub.getId(), config.get().getFrequency());
            } else {
                log.info("NO config for sub-template {}", sub.getId());
            }
        }

        ComplianceTemplate template = templateRepository.findById(templateId).orElse(null);
        if (template != null && template.getDirectConfig() != null) {
            log.info("FOUND parent config for template: {}", template.getDirectConfig().getFrequency());
        } else {
            log.info("NO parent config for template");
        }
    }

    public Long getTemplateIdForConfigure(Long complianceId) {
        if (templateRepository.existsById(complianceId)) {
            return complianceId;
        }
        Optional<CompanyCompliance> cc = companyComplianceRepository.findById(complianceId);
        if (cc.isPresent() && cc.get().getTemplate() != null) {
            return cc.get().getTemplate().getId();
        }
        return null;
    }

    public Long getOrCreateCompanyComplianceId(Long templateId, Long companyId, Long adminId) {
        Optional<CompanyCompliance> existing = companyComplianceRepository
                .findByCompanyIdAndTemplateIdAndIsParentTrue(companyId, templateId);
        if (existing.isPresent()) {
            return existing.get().getId();
        }

        ComplianceTemplate template = templateRepository.findById(templateId).orElse(null);
        Company company = companyRepository.findById(companyId).orElse(null);
        if (template == null || company == null) {
            log.warn("Cannot auto-create CompanyCompliance: template {} or company {} not found", templateId, companyId);
            return null;
        }

        CompanyCompliance cc = new CompanyCompliance();
        cc.setCompany(company);
        cc.setTemplate(template);
        cc.setIsParent(true);
        cc.setParentTemplateId(null);
        cc.setStatus(ComplianceStatus.PENDING);
        cc.setIsActive(true);
        cc.setCreatedBy(adminId);
        cc.setIsSuperAdminConfig(false);
        cc = companyComplianceRepository.save(cc);
        log.info("Lazy-created CompanyCompliance ID: {} for legacy custom template: {}", cc.getId(), templateId);
        return cc.getId();
    }

    // ==================== COMPLIANCE HISTORY & OVERDUE TRACKING ====================

    public LocalDate resolveEffectiveDueDate(CompanyCompliance cc) {
        if (cc == null) return null;
        ComplianceConfig config = cc.getConfig();
        if (config == null && cc.getId() != null) {
            config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
        }
        if (config == null && cc.getSubTemplate() != null) {
            config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
        }
        if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
            config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
        }
        if (config == null) return null;
        LocalDate due = config.getDueDate();
        if (due == null) due = config.getCustomDueDate();
        if (due == null) due = calculateEffectiveDueDate(config);
        return due;
    }

    public static class ResolvedComplianceStatus {
        public boolean isCompleted;
        public boolean isOverdue;
        public boolean completedLate;
        public int daysOverdue;
        public ComplianceStatus effectiveStatus;
        public LocalDateTime completedAt;
        public Long completedBy;
        public String submissionReference;
        public String submissionDocumentUrl;
    }

    public ResolvedComplianceStatus resolveComplianceStatus(CompanyCompliance cc, LocalDate today) {
        ResolvedComplianceStatus res = new ResolvedComplianceStatus();
        LocalDate due = resolveEffectiveDueDate(cc);

        LocalDateTime compAt = cc.getCompletedAt();
        Long compBy = cc.getCompletedBy();
        String subRef = cc.getAdminSubmissionReference();
        String docUrl = cc.getAdminSubmissionDocumentUrl();

        boolean isCompleted = (cc.getStatus() == ComplianceStatus.COMPLETED || compAt != null);

        // Fallback: check config / employee assignments if not directly on cc
        if (!isCompleted) {
            ComplianceConfig config = cc.getConfig();
            if (config == null && cc.getId() != null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config != null && config.getId() != null) {
                Optional<EmployeeAssignment> doneOpt = assignmentRepository.findCompletedAssignmentByConfigId(config.getId());
                if (doneOpt.isPresent()) {
                    isCompleted = true;
                    EmployeeAssignment done = doneOpt.get();
                    compAt = done.getCompletedAt();
                    compBy = done.getCompletedBy() != null ? done.getCompletedBy() : done.getEmployeeId();
                    if (done.getSubmissionReference() != null) subRef = done.getSubmissionReference();
                    if (done.getSubmissionDocumentUrl() != null) docUrl = done.getSubmissionDocumentUrl();
                }
            }
        }

        res.isCompleted = isCompleted;
        res.completedAt = compAt;
        res.completedBy = compBy;
        res.submissionReference = subRef;
        res.submissionDocumentUrl = docUrl;

        if (isCompleted) {
            res.effectiveStatus = ComplianceStatus.COMPLETED;
            res.isOverdue = false;
            if (due != null && compAt != null && compAt.toLocalDate().isAfter(due)) {
                res.completedLate = true;
                res.daysOverdue = (int) ChronoUnit.DAYS.between(due, compAt.toLocalDate());
            } else {
                res.completedLate = false;
                res.daysOverdue = 0;
            }
        } else {
            // An uncompleted compliance is ONLY overdue if its due date has strictly passed today!
            // If due date is today or in the future, it CANNOT be overdue.
            boolean overdue = due != null && due.isBefore(today) && cc.getStatus() != ComplianceStatus.EXEMPTED;
            res.isOverdue = overdue;
            res.completedLate = false;
            if (overdue) {
                res.effectiveStatus = ComplianceStatus.OVERDUE;
                res.daysOverdue = Math.max(1, (int) ChronoUnit.DAYS.between(due, today));
            } else if (cc.getStatus() == ComplianceStatus.IN_PROGRESS || cc.getStatus() == ComplianceStatus.OVERDUE) {
                // If it was wrongly marked OVERDUE in DB but due is in the future or today, it is active IN_PROGRESS
                res.effectiveStatus = ComplianceStatus.IN_PROGRESS;
                res.daysOverdue = 0;
            } else {
                res.effectiveStatus = (cc.getStatus() != null) ? cc.getStatus() : ComplianceStatus.PENDING;
                res.daysOverdue = 0;
            }
        }

        return res;
    }

    @Transactional
    public CompanyHistorySummaryDTO getComplianceHistorySummary(Long companyId, int targetYear) {
        List<CompanyCompliance> all;
        String companyName = "All Companies";
        if (companyId != null && companyId > 0) {
            renewCompletedRecurringCompliancesForCompany(companyId);
            all = companyComplianceRepository.findByCompanyIdWithDetails(companyId);
            companyName = companyRepository.findById(companyId).map(Company::getName).orElse("Company #" + companyId);
        } else {
            renewCompletedRecurringCompliances();
            all = companyComplianceRepository.findAllActiveCompliancesWithDetails();
        }

        LocalDate today = LocalDate.now(IST_ZONE);

        String[] monthNames = {
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
        };
        List<MonthlyOverdueSummaryDTO> monthlyList = new ArrayList<>();
        for (int m = 1; m <= 12; m++) {
            monthlyList.add(MonthlyOverdueSummaryDTO.builder()
                    .month(m)
                    .monthName(monthNames[m - 1])
                    .year(targetYear)
                    .overdueCount(0)
                    .completedCount(0)
                    .completedLateCount(0)
                    .pendingCount(0)
                    .inProgressCount(0)
                    .totalCount(0)
                    .build());
        }

        List<CompanyComplianceHistoryDTO> allOccurrences = generateYearlyHistoryOccurrences(all, targetYear, today, monthNames);

        long totalOverdue = 0;
        long totalCompleted = 0;
        long totalCompletedLate = 0;
        long totalPending = 0;
        long totalCompliances = allOccurrences.size();

        for (CompanyComplianceHistoryDTO occ : allOccurrences) {
            int monthIdx = occ.getDueMonth() - 1;
            if (monthIdx < 0 || monthIdx >= 12) continue;

            MonthlyOverdueSummaryDTO mDto = monthlyList.get(monthIdx);
            mDto.setTotalCount(mDto.getTotalCount() + 1);

            if (occ.getStatus() == ComplianceStatus.COMPLETED) {
                mDto.setCompletedCount(mDto.getCompletedCount() + 1);
                totalCompleted++;
                if (occ.isCompletedLate()) {
                    mDto.setCompletedLateCount(mDto.getCompletedLateCount() + 1);
                    totalCompletedLate++;
                }
            } else if (occ.isOverdue() || occ.getStatus() == ComplianceStatus.OVERDUE) {
                mDto.setOverdueCount(mDto.getOverdueCount() + 1);
                totalOverdue++;
            } else if (occ.getStatus() == ComplianceStatus.IN_PROGRESS) {
                mDto.setInProgressCount(mDto.getInProgressCount() + 1);
                totalPending++;
            } else {
                mDto.setPendingCount(mDto.getPendingCount() + 1);
                totalPending++;
            }
        }

        String mostOverdueMonth = "None";
        long maxOverdue = 0;
        for (MonthlyOverdueSummaryDTO m : monthlyList) {
            if (m.getOverdueCount() > maxOverdue) {
                maxOverdue = m.getOverdueCount();
                mostOverdueMonth = m.getMonthName() + " (" + m.getOverdueCount() + " overdue)";
            }
        }

        return CompanyHistorySummaryDTO.builder()
                .companyId(companyId)
                .companyName(companyName)
                .year(targetYear)
                .totalCompliances(totalCompliances)
                .totalOverdue(totalOverdue)
                .totalCompleted(totalCompleted)
                .totalCompletedLate(totalCompletedLate)
                .totalPending(totalPending)
                .mostOverdueMonth(mostOverdueMonth)
                .monthlyBreakdown(monthlyList)
                .build();
    }

    @Transactional
    public Page<CompanyComplianceHistoryDTO> getComplianceHistoryRecords(
            Long companyId, Integer targetYear, Integer targetMonth,
            ComplianceStatus statusFilter, String search, Pageable pageable) {

        List<CompanyCompliance> all;
        if (companyId != null && companyId > 0) {
            renewCompletedRecurringCompliancesForCompany(companyId);
            all = companyComplianceRepository.findByCompanyIdWithDetails(companyId);
        } else {
            renewCompletedRecurringCompliances();
            all = companyComplianceRepository.findAllActiveCompliancesWithDetails();
        }

        LocalDate today = LocalDate.now(IST_ZONE);
        int year = (targetYear != null && targetYear > 0) ? targetYear : today.getYear();
        String cleanSearch = (search != null) ? search.trim().toLowerCase() : null;

        String[] monthNames = {
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
        };

        List<CompanyComplianceHistoryDTO> allOccurrences = generateYearlyHistoryOccurrences(all, year, today, monthNames);
        List<CompanyComplianceHistoryDTO> filteredList = new ArrayList<>();

        for (CompanyComplianceHistoryDTO item : allOccurrences) {
            if (targetMonth != null && targetMonth > 0 && !item.getDueMonth().equals(targetMonth)) {
                continue;
            }

            if (statusFilter != null) {
                if (statusFilter == ComplianceStatus.OVERDUE) {
                    if (!item.isOverdue() && item.getStatus() != ComplianceStatus.OVERDUE) continue;
                } else if (statusFilter == ComplianceStatus.COMPLETED) {
                    if (item.getStatus() != ComplianceStatus.COMPLETED) continue;
                } else if (item.getStatus() != statusFilter) {
                    continue;
                }
            }

            if (cleanSearch != null && !cleanSearch.isEmpty()) {
                String cName = item.getCompanyName() != null ? item.getCompanyName() : "";
                String tName = item.getComplianceName() != null ? item.getComplianceName() : "";
                String sName = item.getSubComplianceName() != null ? item.getSubComplianceName() : "";
                String catName = item.getCategoryName() != null ? item.getCategoryName() : "";

                boolean match = cName.toLowerCase().contains(cleanSearch) ||
                        tName.toLowerCase().contains(cleanSearch) ||
                        sName.toLowerCase().contains(cleanSearch) ||
                        catName.toLowerCase().contains(cleanSearch);
                if (!match) {
                    continue;
                }
            }

            filteredList.add(item);
        }

        filteredList.sort((a, b) -> {
            if (a.getDueDate() != null && b.getDueDate() != null) {
                int cmp = b.getDueDate().compareTo(a.getDueDate());
                if (cmp != 0) return cmp;
            } else if (a.getDueDate() != null) {
                return -1;
            } else if (b.getDueDate() != null) {
                return 1;
            }
            return Long.compare(b.getId() != null ? b.getId() : 0, a.getId() != null ? a.getId() : 0);
        });

        int total = filteredList.size();
        int page = pageable.getPageNumber();
        int size = pageable.getPageSize();
        int fromIndex = Math.min(page * size, total);
        int toIndex = Math.min(fromIndex + size, total);

        List<CompanyComplianceHistoryDTO> pageContent = filteredList.subList(fromIndex, toIndex);
        return new PageImpl<>(pageContent, pageable, total);
    }

    public List<CompanyComplianceHistoryDTO> generateYearlyHistoryOccurrences(
            List<CompanyCompliance> activeItems, int targetYear, LocalDate today, String[] monthNames) {

        List<CompanyComplianceHistoryDTO> occurrences = new ArrayList<>();
        int currentYear = today.getYear();
        int currentMonth = today.getMonthValue();

        for (CompanyCompliance cc : activeItems) {
            if (isParentWithSubCompliances(cc)) {
                continue;
            }

            LocalDate baseDue = resolveEffectiveDueDate(cc);
            if (baseDue == null) {
                continue;
            }

            ComplianceConfig config = cc.getConfig();
            if (config == null && cc.getId() != null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
                config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
            }

            ComplianceFrequency freq = (config != null && config.getFrequency() != null)
                    ? config.getFrequency() : ComplianceFrequency.ONE_TIME;

            int dueDay = (config != null && config.getDueDayOfMonth() != null)
                    ? config.getDueDayOfMonth() : baseDue.getDayOfMonth();

            String compName = cc.getCompany() != null ? cc.getCompany().getName() : "";
            String templateName = cc.getTemplate() != null ? cc.getTemplate().getName() : "";
            String subName = cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : "";
            String category = (templateName != null && !templateName.isEmpty()) ? templateName : "General";

            ResolvedComplianceStatus baseStatus = resolveComplianceStatus(cc, today);
            String completedByName = null;
            if (baseStatus.completedBy != null) {
                completedByName = userRepository.findById(baseStatus.completedBy)
                        .map(User::getFullName).orElse("User #" + baseStatus.completedBy);
            }

            // Determine effective start date for the company / compliance so we do not generate
            // synthetic occurrences for months prior to the company's onboarding / compliance creation
            LocalDate effectiveStartDate = null;
            if (cc.getCompany() != null && cc.getCompany().getSubscriptionStartDate() != null) {
                effectiveStartDate = cc.getCompany().getSubscriptionStartDate().toLocalDate();
            } else if (cc.getCompany() != null && cc.getCompany().getCreatedAt() != null) {
                effectiveStartDate = cc.getCompany().getCreatedAt().toLocalDate();
            } else if (cc.getCreatedAt() != null) {
                effectiveStartDate = cc.getCreatedAt().toLocalDate();
            }

            int startMonth = 1;
            if (effectiveStartDate != null) {
                if (effectiveStartDate.getYear() > targetYear) {
                    continue; // Company did not exist in targetYear
                } else if (effectiveStartDate.getYear() == targetYear) {
                    startMonth = effectiveStartDate.getMonthValue();
                }
            }

            // Determine which months in targetYear this compliance applies to
            List<Integer> applicableMonths = new ArrayList<>();
            if (freq == ComplianceFrequency.MONTHLY) {
                for (int m = startMonth; m <= 12; m++) {
                    applicableMonths.add(m);
                }
            } else if (freq == ComplianceFrequency.QUARTERLY) {
                int baseMonth = baseDue.getMonthValue();
                int m1 = ((baseMonth - 1) % 3) + 1; // 1, 2, or 3
                int[] qMonths = {m1, m1 + 3, m1 + 6, m1 + 9};
                for (int qm : qMonths) {
                    if (qm >= startMonth && qm <= 12) {
                        applicableMonths.add(qm);
                    }
                }
            } else if (freq == ComplianceFrequency.HALF_YEARLY) {
                int baseMonth = baseDue.getMonthValue();
                int m1 = ((baseMonth - 1) % 6) + 1;
                int[] hMonths = {m1, m1 + 6};
                for (int hm : hMonths) {
                    if (hm >= startMonth && hm <= 12) {
                        applicableMonths.add(hm);
                    }
                }
            } else if (freq == ComplianceFrequency.YEARLY) {
                int baseMonth = baseDue.getMonthValue();
                if (baseMonth >= startMonth) {
                    applicableMonths.add(baseMonth);
                }
            } else {
                // ONE_TIME: occurs in the baseDue month
                if (baseDue.getYear() == targetYear && baseDue.getMonthValue() >= startMonth) {
                    applicableMonths.add(baseDue.getMonthValue());
                }
            }

            for (int m : applicableMonths) {
                int maxDays = YearMonth.of(targetYear, m).lengthOfMonth();
                LocalDate occurrenceDueDate = LocalDate.of(targetYear, m, Math.min(dueDay, maxDays));

                ComplianceStatus occStatus;
                boolean occIsOverdue = false;
                boolean occCompletedLate = false;
                int occDaysOverdue = 0;
                LocalDateTime occCompletedAt = null;
                String occCompletedByName = null;
                String occSubmissionRef = null;
                String occSubmissionDocUrl = null;

                boolean isCurrentActiveRecordMonth = (baseDue.getYear() == targetYear && baseDue.getMonthValue() == m);

                if (isCurrentActiveRecordMonth) {
                    // This occurrence directly represents the current active database state
                    occStatus = baseStatus.effectiveStatus;
                    occIsOverdue = baseStatus.isOverdue;
                    occCompletedLate = baseStatus.completedLate;
                    occDaysOverdue = baseStatus.daysOverdue;
                    occCompletedAt = baseStatus.completedAt;
                    occCompletedByName = completedByName;
                    occSubmissionRef = baseStatus.submissionReference;
                    occSubmissionDocUrl = baseStatus.submissionDocumentUrl;
                } else if (occurrenceDueDate.isBefore(today)) {
                    // Past occurrence
                    if (m < baseDue.getMonthValue() || (baseDue.getYear() > targetYear)) {
                        // Occurrence prior to current active cycle was completed
                        occStatus = ComplianceStatus.COMPLETED;
                        occCompletedLate = false;
                        occDaysOverdue = 0;
                        occCompletedAt = occurrenceDueDate.atTime(18, 0);
                        occCompletedByName = completedByName != null ? completedByName : "System";
                        occSubmissionRef = "Completed";
                    } else {
                        // An occurrence whose due date passed before today and was not completed -> OVERDUE
                        occStatus = ComplianceStatus.OVERDUE;
                        occIsOverdue = true;
                        occDaysOverdue = (int) ChronoUnit.DAYS.between(occurrenceDueDate, today);
                    }
                } else if (occurrenceDueDate.isEqual(today) || (targetYear == currentYear && m == currentMonth)) {
                    // Current month but due date is today or future in current month
                    occStatus = ComplianceStatus.IN_PROGRESS;
                    occIsOverdue = false;
                    occDaysOverdue = 0;
                } else {
                    // Future occurrence
                    occStatus = ComplianceStatus.PENDING;
                    occIsOverdue = false;
                    occDaysOverdue = 0;
                }

                CompanyComplianceHistoryDTO dto = CompanyComplianceHistoryDTO.builder()
                        .id(cc.getId())
                        .companyId(cc.getCompany() != null ? cc.getCompany().getId() : null)
                        .companyName(compName)
                        .complianceName(templateName)
                        .subComplianceName(subName != null && !subName.isEmpty() ? subName : null)
                        .categoryName(category)
                        .frequency(freq)
                        .dueDate(occurrenceDueDate)
                        .dueMonth(m)
                        .dueYear(targetYear)
                        .monthName(m >= 1 && m <= 12 ? monthNames[m - 1] : "Month " + m)
                        .status(occStatus)
                        .isOverdue(occIsOverdue)
                        .completedLate(occCompletedLate)
                        .daysOverdue(occDaysOverdue)
                        .completedAt(occCompletedAt)
                        .completedByName(occCompletedByName)
                        .adminNotes(cc.getAdminNotes())
                        .submissionReference(occSubmissionRef)
                        .submissionDocumentUrl(occSubmissionDocUrl)
                        .build();

                occurrences.add(dto);
            }
        }

        return occurrences;
    }

    @Transactional(readOnly = true)
    public List<ComplianceHistoryDTO> getComplianceItemLogs(Long complianceId) {
        List<ComplianceHistory> list = historyRepository.findByCompanyComplianceIdOrderByPerformedAtDesc(complianceId);
        if (list.isEmpty()) {
            CompanyCompliance cc = companyComplianceRepository.findById(complianceId).orElse(null);
            if (cc != null && cc.getCreatedAt() != null) {
                ComplianceHistoryDTO baseline = new ComplianceHistoryDTO();
                baseline.setId(0L);
                baseline.setAction("Compliance Configured / Activated");
                baseline.setNewStatus(cc.getStatus() != null ? cc.getStatus().name() : "PENDING");
                baseline.setPerformedAt(cc.getCreatedAt());
                baseline.setPerformedByName("System Administrator");
                baseline.setRemarks("Compliance initialized for " + (cc.getCompany() != null ? cc.getCompany().getName() : "company"));
                baseline.setCompanyName(cc.getCompany() != null ? cc.getCompany().getName() : "");
                return List.of(baseline);
            }
        }
        return list.stream().map(h -> {
            ComplianceHistoryDTO dto = new ComplianceHistoryDTO();
            dto.setId(h.getId());
            dto.setAction(h.getAction());
            dto.setPreviousStatus(h.getPreviousStatus() != null ? h.getPreviousStatus().name() : null);
            dto.setNewStatus(h.getNewStatus() != null ? h.getNewStatus().name() : null);
            dto.setRemarks(h.getRemarks());
            dto.setPerformedAt(h.getPerformedAt());
            dto.setPerformedByName(h.getPerformedBy() != null ? h.getPerformedBy().getFullName() : "System / Auto");
            dto.setCompanyName(h.getCompanyCompliance() != null && h.getCompanyCompliance().getCompany() != null
                    ? h.getCompanyCompliance().getCompany().getName() : "");
            return dto;
        }).collect(Collectors.toList());
    }
}