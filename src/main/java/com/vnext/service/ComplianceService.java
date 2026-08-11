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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ComplianceService {

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
    private final NotificationEventService notificationEventService;

    @PersistenceContext
    private EntityManager entityManager;

    // ==================== SUPER ADMIN COMPLIANCE MANAGEMENT ====================

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
        // NEW: set editableForCompanies
        template.setEditableForCompanies(dto.getEditableForCompanies() != null && dto.getEditableForCompanies());
        template.setCreatedBy(adminId);

        ComplianceTemplate saved = templateRepository.save(template);
        log.info("Compliance template created with ID: {}", saved.getId());

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
        // NEW: update editableForCompanies
        template.setEditableForCompanies(dto.getEditableForCompanies() != null && dto.getEditableForCompanies());
        template.setUpdatedBy(adminId);

        ComplianceTemplate saved = templateRepository.save(template);
        log.info("Compliance template updated with ID: {}", saved.getId());

        return convertToTemplateDTO(saved);
    }

    @Transactional
    public ComplianceSubTemplateDTO createSubTemplate(Long parentId, ComplianceSubTemplateDTO dto, Long adminId) {
        log.info("SuperAdmin creating sub-template for parent: {}", parentId);

        ComplianceTemplate parent = templateRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent template not found"));

        // NEW: if parent is editable, disallow SuperAdmin from adding global sub‑templates
        if (Boolean.TRUE.equals(parent.getEditableForCompanies())) {
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

        // Add history for sub-template creation at template level
        addHistoryForTemplate(parentId, "Sub-Compliance Added",
                "Added sub-compliance: " + saved.getName() + " under parent: " + parent.getName() + " with display order: " + saved.getDisplayOrder(), adminId);

        // Notify company admins (existing logic)
        List<Long> companyAdminUserIds = new ArrayList<>();
        List<CompanyCompliance> parentCCs = companyComplianceRepository.findByTemplateIdAndIsParentTrue(parentId);
        for (CompanyCompliance cc : parentCCs) {
            if (cc.getCompany() != null && cc.getCompany().getStatus() == CompanyStatus.ACTIVE && cc.getCompany().getCompanyAdmin() != null) {
                Long adminUserId = cc.getCompany().getCompanyAdmin().getId();
                if (adminUserId != null && !companyAdminUserIds.contains(adminUserId)) {
                    companyAdminUserIds.add(adminUserId);
                }
            }
        }
        if (companyAdminUserIds.isEmpty()) {
            companyRepository.findActiveCompaniesByStatus(CompanyStatus.ACTIVE).forEach(c -> {
                if (c.getCompanyAdmin() != null && c.getCompanyAdmin().getId() != null) {
                    if (!companyAdminUserIds.contains(c.getCompanyAdmin().getId())) {
                        companyAdminUserIds.add(c.getCompanyAdmin().getId());
                    }
                }
            });
        }

        if (!companyAdminUserIds.isEmpty()) {
            notificationEventService.notifyUsersWithSave(
                    companyAdminUserIds,
                    "New Sub-Compliance Created",
                    "SuperAdmin created a new sub-compliance \"" + saved.getName() + "\" under \"" + parent.getName() + "\" and it is assigned to your company. Go and check accordingly.",
                    NotificationType.SUB_COMPLIANCE_CREATED,
                    "compliance_details",
                    UserRole.COMPANY_ADMIN.name()
            );
        }

        notificationEventService.notifySuperAdminsWithSave(
                "Sub-Compliance Created Successfully",
                "Sub-compliance \"" + saved.getName() + "\" under \"" + parent.getName() + "\" details and configurations saved successfully.",
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

        subTemplate.setName(dto.getName());
        subTemplate.setDescription(dto.getDescription());
        subTemplate.setDisplayOrder(dto.getDisplayOrder() != null ? dto.getDisplayOrder() : 0);
        subTemplate.setUpdatedBy(adminId);

        subTemplateRepository.save(subTemplate);
        log.info("Sub-template updated successfully with displayOrder: {}", subTemplate.getDisplayOrder());

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
        if (!Boolean.TRUE.equals(parent.getEditableForCompanies())) {
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
        companyComplianceRepository.save(subCC);

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
        if (Boolean.TRUE.equals(parent.getEditableForCompanies())) {
            // For editable, fetch company‑specific sub‑templates
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIdAndIsActiveTrueOrderByDisplayOrderAsc(parentId, companyId);
        } else {
            // For non‑editable, fetch global sub‑templates (company IS NULL)
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIsNullAndIsActiveTrueOrderByDisplayOrderAsc(parentId);
        }

        return subTemplates.stream()
                .map(this::convertToSubTemplateDTO)
                .collect(Collectors.toList());
    }

    // ==================== ASSIGNMENT METHODS ====================

    @Transactional
    public void assignComplianceToCompany(Long templateId, Long companyId, Long adminId) {
        log.info("=== Assigning compliance template {} to company {} ===", templateId, companyId);

        User admin = userRepository.findById(adminId)
                .orElseThrow(() -> new ResourceNotFoundException("Admin not found with ID: " + adminId));

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found with ID: " + templateId));

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        List<CompanyCompliance> allExistingForPair = companyComplianceRepository
                .findAllByCompanyIdAndTemplateId(companyId, templateId);

        boolean hasLiveParent = allExistingForPair.stream()
                .anyMatch(cc -> cc.isParent() && Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted());

        if (hasLiveParent) {
            log.warn("Compliance already assigned to company: {}", companyId);
            throw new BusinessException("Compliance is already assigned to this company");
        }

        if (!allExistingForPair.isEmpty()) {
            log.info("Purging {} leftover compliance record(s) for company {} / template {} before reassigning",
                    allExistingForPair.size(), companyId, templateId);
            for (CompanyCompliance cc : allExistingForPair) {
                deleteCompanyCompliancePermanently(cc);
            }
        }

        // Determine if parent is editable
        boolean editable = Boolean.TRUE.equals(template.getEditableForCompanies());

        // For non‑editable: fetch global sub‑templates (company IS NULL)
        List<ComplianceSubTemplate> subTemplates = new ArrayList<>();
        Map<Long, ComplianceConfig> subTemplateConfigMap = new HashMap<>();
        if (!editable) {
            subTemplates = subTemplateRepository
                    .findByParentTemplateIdAndCompanyIsNullAndIsActiveTrueOrderByDisplayOrderAsc(templateId);
            for (ComplianceSubTemplate sub : subTemplates) {
                Optional<ComplianceConfig> configOpt = configRepository
                        .findBySubTemplateIdAndCompanyComplianceIsNull(sub.getId());
                if (configOpt.isPresent()) {
                    subTemplateConfigMap.put(sub.getId(), configOpt.get());
                }
            }
        }

        ComplianceConfig parentTemplateConfig = null;
        if (!editable && subTemplates.isEmpty()) {
            parentTemplateConfig = template.getDirectConfig();
        }

        // 1. Create parent CompanyCompliance
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

        // 2. If non‑editable and has sub‑templates, create sub‑compliances
        if (!editable && !subTemplates.isEmpty()) {
            for (ComplianceSubTemplate subTemplate : subTemplates) {
                CompanyCompliance subCC = new CompanyCompliance();
                subCC.setCompany(company);
                subCC.setTemplate(template);
                subCC.setSubTemplate(subTemplate);
                subCC.setIsParent(false);
                subCC.setParentTemplateId(templateId);
                subCC.setStatus(ComplianceStatus.IN_PROGRESS);
                subCC.setIsActive(true);
                subCC.setCreatedBy(adminId);
                subCC.setIsSuperAdminConfig(true);
                subCC.setAdminNotes("Auto-assigned on company creation");
                subCC = companyComplianceRepository.save(subCC);
                log.info("Created sub CompanyCompliance ID: {} for sub-template: {}", subCC.getId(), subTemplate.getId());

                ComplianceConfig sourceConfig = subTemplateConfigMap.get(subTemplate.getId());
                if (sourceConfig != null) {
                    copyConfigToCompany(sourceConfig, subCC, adminId);
                }
            }
        } else if (!editable && parentTemplateConfig != null) {
            // No sub‑templates, parent has config
            copyConfigToCompany(parentTemplateConfig, parentCC, adminId);
        } else {
            // Editable: only parent created, no sub‑compliances. Company admin will add them later.
            log.info("Editable compliance assigned; company admin will manage sub‑compliances.");
        }

        addHistoryForCompanyCompliance(parentCC, null, parentCC.getStatus(),
                "Compliance Assigned",
                "Compliance auto-assigned on company creation: " + template.getName() +
                        (editable ? " (editable)" : ""),
                admin);

        log.info("=== Compliance assigned successfully to company: {} ===", companyId);

        notificationEventService.notifySuperAdminsPushOnly(
                "Company Assigned to Compliance",
                "Company " + company.getName() + " has been assigned to \"" + template.getName() + "\".",
                NotificationType.COMPANY_ASSIGNED_TO_COMPLIANCE,
                "compliance_details"
        );

        if (company.getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    company.getCompanyAdmin().getId(),
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

        for (Long companyId : assignDTO.getCompanyIds()) {
            try {
                assignComplianceToCompany(assignDTO.getTemplateId(), companyId, adminId);
            } catch (BusinessException e) {
                log.warn("Skipping company {}: {}", companyId, e.getMessage());
            } catch (Exception e) {
                log.error("Failed to assign to company {}: {}", companyId, e.getMessage(), e);
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

        for (Company company : activeCompanies) {
            try {
                assignComplianceToCompany(templateId, company.getId(), adminId);
            } catch (BusinessException e) {
                log.warn("Skipping company {}: {}", company.getId(), e.getMessage());
            } catch (Exception e) {
                log.error("Failed to assign to company {}: {}", company.getId(), e.getMessage(), e);
            }
        }
    }

    // ==================== GET PARENT COMPLIANCE DETAILS ====================

    @Transactional(readOnly = true)
    public ParentComplianceDetailsDTO getParentComplianceDetails(Long parentId, Long companyId) {
        log.info("Getting parent compliance details for ID: {} and company: {}", parentId, companyId);

        CompanyCompliance parentCC = companyComplianceRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent compliance not found with ID: " + parentId));

        if (!parentCC.getCompany().getId().equals(companyId)) {
            throw new BusinessException("This compliance does not belong to your company");
        }

        if (!parentCC.isParent()) {
            throw new BusinessException("This is a sub-compliance, not a parent compliance");
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
        Boolean editable = parentCC.getTemplate().getEditableForCompanies();
        dto.setCanManage(editable != null && editable);

        // Get sub‑compliances based on editable flag
        List<CompanyCompliance> subCompliances;
        if (Boolean.TRUE.equals(editable)) {
            subCompliances = companyComplianceRepository
                    .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, parentCC.getTemplate().getId());
        } else {
            // For non‑editable, fetch all sub‑compliances for this company and parent
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

            boolean hasConfig = configRepository.existsByCompanyComplianceId(subCC.getId());
            subDto.setIsConfigured(hasConfig);

            if (hasConfig) {
                configuredCount++;
                configRepository.findByCompanyComplianceId(subCC.getId()).ifPresent(config -> {
                    if (config.getFrequency() != null) {
                        subDto.setFrequency(config.getFrequency().name());
                    }
                    LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
                    if (effectiveDueDate != null) {
                        subDto.setDueDate(effectiveDueDate.atStartOfDay());
                    }
                    subDto.setInstructions(config.getInstructions());
                    subDto.setDocumentRequired(config.getDocumentRequired());
                    subDto.setExternalLink(config.getExternalLink());
                    subDto.setReminderDaysBefore(config.getReminderDaysBefore());
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
            config.setDueDate(dto.getDueDate());
            config.setCustomDueDate(dto.getCustomDueDate());
            config.setDueDayOfMonth(dto.getDueDayOfMonth());
            config.setDueQuarter(dto.getDueQuarter());
            config.setDueHalf(dto.getDueHalf());
            config.setDueMonth(dto.getDueMonth());
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
        List<Long> companyAdminUserIds = new ArrayList<>();
        List<CompanyCompliance> assignedCCs = companyComplianceRepository.findByTemplateIdAndIsParentTrue(templateId);
        for (CompanyCompliance cc : assignedCCs) {
            if (cc.getCompany() != null && cc.getCompany().getStatus() == CompanyStatus.ACTIVE && cc.getCompany().getCompanyAdmin() != null) {
                Long adminUserId = cc.getCompany().getCompanyAdmin().getId();
                if (adminUserId != null && !companyAdminUserIds.contains(adminUserId)) {
                    companyAdminUserIds.add(adminUserId);
                }
            }
        }
        if (companyAdminUserIds.isEmpty()) {
            for (Company company : companyRepository.findActiveCompaniesByStatus(CompanyStatus.ACTIVE)) {
                if (company.getCompanyAdmin() != null && company.getCompanyAdmin().getId() != null) {
                    if (!companyAdminUserIds.contains(company.getCompanyAdmin().getId())) {
                        companyAdminUserIds.add(company.getCompanyAdmin().getId());
                    }
                }
            }
        }

        if (!companyAdminUserIds.isEmpty()) {
            notificationEventService.notifyUsersWithSave(
                    companyAdminUserIds,
                    "New Compliance Configured",
                    "SuperAdmin configured a new compliance \"" + template.getName() + "\" and it is assigned to your company. Go and check accordingly.",
                    NotificationType.COMPLIANCE_CONFIG_UPDATED,
                    "compliance_details",
                    UserRole.COMPANY_ADMIN.name()
            );
        }

        notificationEventService.notifySuperAdminsWithSave(
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
            templateConfig.setDueDate(dto.getDueDate());
            templateConfig.setCustomDueDate(dto.getCustomDueDate());
            templateConfig.setDueDayOfMonth(dto.getDueDayOfMonth());
            templateConfig.setDueQuarter(dto.getDueQuarter());
            templateConfig.setDueHalf(dto.getDueHalf());
            templateConfig.setDueMonth(dto.getDueMonth());
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
                companyConfig.setDueDate(templateConfig.getDueDate());
                companyConfig.setCustomDueDate(templateConfig.getCustomDueDate());
                companyConfig.setDueDayOfMonth(templateConfig.getDueDayOfMonth());
                companyConfig.setDueQuarter(templateConfig.getDueQuarter());
                companyConfig.setDueHalf(templateConfig.getDueHalf());
                companyConfig.setDueMonth(templateConfig.getDueMonth());
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

            addHistoryForCompanyCompliance(companyCompliance, ComplianceStatus.PENDING,
                    ComplianceStatus.IN_PROGRESS, "Sub-Compliance Configured",
                    "Configured sub-compliance: " + subTemplate.getName(),
                    userRepository.findById(adminId).orElse(null));

            sendAssignmentEmailToCompany(company, subTemplate.getParentTemplate());
        }

        addHistoryForTemplate(subTemplate.getParentTemplate().getId(), "Sub-Compliance Configured",
                "Configured sub-compliance: " + subTemplate.getName() + " and assigned to " +
                        (assignedCount > 0 ? assignedCount : "existing") + " companies", adminId);

        List<Long> subCompanyAdminUserIds = new ArrayList<>();
        if (!activeCompanies.isEmpty()) {
            for (Company company : activeCompanies) {
                if (company.getCompanyAdmin() != null && company.getCompanyAdmin().getId() != null) {
                    if (!subCompanyAdminUserIds.contains(company.getCompanyAdmin().getId())) {
                        subCompanyAdminUserIds.add(company.getCompanyAdmin().getId());
                    }
                }
            }
        }

        if (!subCompanyAdminUserIds.isEmpty()) {
            notificationEventService.notifyUsersWithSave(
                    subCompanyAdminUserIds,
                    "New Sub-Compliance Configured",
                    "SuperAdmin created a new sub-compliance \"" + subTemplate.getName() + "\" under \"" + subTemplate.getParentTemplate().getName() + "\" and it is assigned to your company. Go and check accordingly.",
                    NotificationType.COMPLIANCE_CONFIG_UPDATED,
                    "compliance_details",
                    UserRole.COMPANY_ADMIN.name()
            );
        }

        notificationEventService.notifySuperAdminsWithSave(
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
        config.setDueDate(dto.getDueDate());
        config.setCustomDueDate(dto.getCustomDueDate());
        config.setDueDayOfMonth(dto.getDueDayOfMonth());
        config.setDueQuarter(dto.getDueQuarter());
        config.setDueHalf(dto.getDueHalf());
        config.setDueMonth(dto.getDueMonth());
        config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
        config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
        config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
        config.setDescription(dto.getDescription());
        config.setDocumentRequired(dto.getDocumentRequired());
        config.setExternalLink(dto.getExternalLink());
        config.setInstructions(dto.getInstructions());
        config.setIsActive(true);
        config.setUpdatedBy(adminId);

        ComplianceConfig saved = configRepository.save(config);
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
            notificationEventService.notifyUsersWithSave(
                    companyAdminUserIds,
                    "Compliance Configuration Updated",
                    "Configuration for \"" + configName + "\" has been updated.",
                    NotificationType.COMPLIANCE_CONFIG_UPDATED,
                    "compliance_details",
                    UserRole.COMPANY_ADMIN.name()
            );
        }

        notificationEventService.notifySuperAdminsWithSave(
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
        config.setDueDate(dto.getDueDate());
        config.setCustomDueDate(dto.getCustomDueDate());
        config.setDueDayOfMonth(dto.getDueDayOfMonth());
        config.setDueQuarter(dto.getDueQuarter());
        config.setDueHalf(dto.getDueHalf());
        config.setDueMonth(dto.getDueMonth());
        config.setReminderDaysBefore(dto.getReminderDaysBefore() != null ? dto.getReminderDaysBefore() : 10);
        config.setRepeatReminder(dto.getRepeatReminder() != null ? dto.getRepeatReminder() : true);
        config.setReminderIntervalDays(dto.getReminderIntervalDays() != null ? dto.getReminderIntervalDays() : 3);
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

        log.info("Sub-compliance configured with config ID: {}", saved.getId());

        return convertToConfigDTO(saved);
    }

    // ==================== DELETE OPERATIONS ====================

    @Transactional
    public void deleteSubTemplatePermanently(Long id) {
        log.info("Permanently deleting sub-template: {}", id);

        ComplianceSubTemplate subTemplate = subTemplateRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Sub-template not found"));

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

        if (!companyCompliance.getCompany().getId().equals(companyId)) {
            throw new BusinessException("Cannot assign this compliance to employees");
        }

        for (Long employeeId : employeeIds) {
            User employee = userRepository.findById(employeeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Employee not found: " + employeeId));

            if (employee.getRole() != UserRole.EMPLOYEE) {
                log.warn("User {} is not an employee, skipping", employeeId);
                continue;
            }

            EmployeeAssignment assignment = new EmployeeAssignment();
            assignment.setConfig(config);
            assignment.setEmployeeId(employeeId);
            assignment.setDueDate(config.getDueDate() != null ? config.getDueDate() : calculateDueDate(config));
            assignment.setAssignedAt(LocalDateTime.now());
            assignment.setIsActive(true);
            assignment.setIsSubAssignment(false);

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
        log.info("Assigning parent compliance {} with sub-compliances to {} employees", parentId, employeeIds.size());

        CompanyCompliance parentCC = companyComplianceRepository.findById(parentId)
                .orElseThrow(() -> new ResourceNotFoundException("Parent compliance not found with ID: " + parentId));

        if (!parentCC.getCompany().getId().equals(companyId)) {
            throw new BusinessException("This compliance does not belong to your company");
        }

        List<CompanyCompliance> subCompliances = companyComplianceRepository
                .findByParentCompanyComplianceIdAndIsSubComplianceTrue(parentId);

        if (subCompliances.isEmpty()) {
            throw new BusinessException("No sub-compliances found for this parent");
        }

        for (CompanyCompliance subCC : subCompliances) {
            ComplianceConfig config = configRepository.findByCompanyComplianceId(subCC.getId())
                    .orElseThrow(() -> new ResourceNotFoundException("Config not found for sub-compliance: " + subCC.getId()));

            for (Long employeeId : employeeIds) {
                User employee = userRepository.findById(employeeId)
                        .orElseThrow(() -> new ResourceNotFoundException("Employee not found: " + employeeId));

                if (employee.getRole() != UserRole.EMPLOYEE) {
                    log.warn("User {} is not an employee, skipping", employeeId);
                    continue;
                }

                EmployeeAssignment assignment = new EmployeeAssignment();
                assignment.setConfig(config);
                assignment.setEmployeeId(employeeId);
                assignment.setDueDate(config.getDueDate() != null ? config.getDueDate() : calculateDueDate(config));
                assignment.setAssignedAt(LocalDateTime.now());
                assignment.setIsActive(true);
                assignment.setIsSubAssignment(true);
                assignment.setParentAssignmentId(null);

                assignmentRepository.save(assignment);

                try {
                    emailService.sendAssignmentEmail(
                            employee.getEmail(),
                            employee.getFirstName(),
                            subCC.getSubTemplate().getName(),
                            assignment.getDueDate()
                    );
                } catch (Exception e) {
                    log.error("Failed to send assignment email to: {}", employee.getEmail(), e);
                }
            }
        }

        log.info("Parent compliance {} assigned with {} sub-compliances to {} employees",
                parentId, subCompliances.size(), employeeIds.size());
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

        // Find the parent CompanyCompliance for this company+template
        Optional<CompanyCompliance> parentOpt = companyComplianceRepository
                .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, templateId);
        if (parentOpt.isEmpty()) {
            throw new ResourceNotFoundException("No compliance assignment found for this company and template.");
        }
        CompanyCompliance parentCC = parentOpt.get();

        // Delete all sub‑compliances
        List<CompanyCompliance> subCompliances = companyComplianceRepository
                .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, templateId);
        for (CompanyCompliance subCC : subCompliances) {
            deleteCompanyCompliancePermanently(subCC);
        }

        // Delete the parent
        deleteCompanyCompliancePermanently(parentCC);

        // Notifications
        Company company = companyRepository.findById(companyId).orElse(null);
        ComplianceTemplate template = templateRepository.findById(templateId).orElse(null);
        if (company != null && template != null) {
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
        }

        log.info("Company compliance permanently removed for company: {}, template: {}", companyId, templateId);
    }

    private void deleteCompanyCompliancePermanently(CompanyCompliance companyCompliance) {
        Long ccId = companyCompliance.getId();

        Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(ccId);
        if (configOpt.isPresent()) {
            ComplianceConfig config = configOpt.get();
            List<EmployeeAssignment> assignments = assignmentRepository
                    .findByConfigIdAndIsActiveTrue(config.getId());
            if (assignments != null && !assignments.isEmpty()) {
                assignmentRepository.deleteAll(assignments);
            }
            configRepository.delete(config);
        }

        List<ComplianceHistory> histories = historyRepository.findByCompanyComplianceId(ccId);
        if (histories != null && !histories.isEmpty()) historyRepository.deleteAll(histories);

        List<ComplianceDocument> documents = documentRepository.findByCompanyComplianceId(ccId);
        if (documents != null && !documents.isEmpty()) documentRepository.deleteAll(documents);

        companyComplianceRepository.delete(companyCompliance);
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

    @Transactional(readOnly = true)
    public Page<CompanyComplianceDTO> getAllAssignments(Long companyId, ComplianceStatus status,
                                                        Long templateId, Boolean isActive,
                                                        Pageable pageable) {
        log.info("Fetching compliance assignments - companyId: {}, status: {}, templateId: {}, isActive: {}",
                companyId, status, templateId, isActive);

        Pageable unsorted = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
        Page<CompanyCompliance> assignments = companyComplianceRepository
                .findAllAssignmentsFiltered(companyId, status, templateId, isActive, unsorted);

        List<CompanyComplianceDTO> dtos = assignments.getContent().stream()
                .map(this::convertToCompanyComplianceDTO)
                .collect(Collectors.toList());

        return new PageImpl<>(dtos, pageable, assignments.getTotalElements());
    }

    @Transactional(readOnly = true)
    public Page<CompanyComplianceDTO> getCompliancesByCompany(Long companyId, Pageable pageable) {
        log.info("Fetching compliances for company: {}", companyId);

        Pageable unsorted = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
        Page<CompanyCompliance> compliances = companyComplianceRepository
                .findAllAssignmentsFiltered(companyId, null, null, true, unsorted);

        List<CompanyComplianceDTO> dtos = compliances.getContent().stream()
                .map(this::convertToCompanyComplianceDTO)
                .collect(Collectors.toList());

        return new PageImpl<>(dtos, pageable, compliances.getTotalElements());
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
        log.info("Soft deleting compliance assignment: {}", assignmentId);

        CompanyCompliance assignment = companyComplianceRepository.findById(assignmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Assignment not found"));

        assignment.setIsActive(false);
        assignment.setDeleted(true);

        if (assignment.getConfig() != null) {
            List<EmployeeAssignment> employeeAssignments = assignmentRepository
                    .findByConfigIdAndIsActiveTrue(assignment.getConfig().getId());
            for (EmployeeAssignment empAssignment : employeeAssignments) {
                empAssignment.setIsActive(false);
                assignmentRepository.save(empAssignment);
            }
            log.info("Deactivated {} employee assignments", employeeAssignments.size());
        }

        addHistoryForCompanyCompliance(assignment, assignment.getStatus(),
                ComplianceStatus.PENDING, "Removed from Company",
                "Compliance removed from company by SuperAdmin",
                userRepository.findById(SecurityUtils.getCurrentUserId()).orElse(null));

        companyComplianceRepository.save(assignment);
        log.info("Compliance assignment {} soft deleted successfully", assignmentId);
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
            dto.setReminderDaysBefore(config.getReminderDaysBefore());
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
        Page<ComplianceTemplate> templatePage = templateRepository
                .findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc(pageable);
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

    private LocalDate calculateDueDate(ComplianceConfig config) {
        if (config == null || config.getFrequency() == null) {
            return null;
        }

        LocalDate today = LocalDate.now();
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();
        int fiscalYear = (currentMonth >= 4) ? currentYear : currentYear - 1;

        switch (config.getFrequency()) {
            case ONE_TIME:
                return config.getCustomDueDate();
            case MONTHLY:
                int dayOfMonth = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                int lastDay = today.lengthOfMonth();
                return LocalDate.of(today.getYear(), today.getMonth(), Math.min(dayOfMonth, lastDay));
            case QUARTERLY:
                int quarter = config.getDueQuarter() != null ? config.getDueQuarter() : 1;
                int monthOffset = (quarter - 1) * 3;
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
                int hMonth = (half == 1) ? 4 : 10;
                int hDay = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                int hYear = fiscalYear;
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

    public LocalDate calculateEffectiveDueDate(ComplianceConfig config) {
        if (config == null || config.getFrequency() == null) {
            return null;
        }

        LocalDate today = LocalDate.now();
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();
        int fiscalYear = (currentMonth >= 4) ? currentYear : currentYear - 1;

        switch (config.getFrequency()) {
            case ONE_TIME:
                return config.getCustomDueDate();
            case MONTHLY:
                int dayOfMonth = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                int lastDay = today.lengthOfMonth();
                return LocalDate.of(today.getYear(), today.getMonth(), Math.min(dayOfMonth, lastDay));
            case QUARTERLY:
                int quarter = config.getDueQuarter() != null ? config.getDueQuarter() : 1;
                int monthOffset = (quarter - 1) * 3;
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
                int hMonth = (half == 1) ? 4 : 10;
                int hDay = config.getDueDayOfMonth() != null ? config.getDueDayOfMonth() : 15;
                int hYear = fiscalYear;
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
                return calculateEffectiveDueDate(config);
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
            return null;
        }

        switch (config.getFrequency()) {
            case MONTHLY:
                return currentDueDate.plusMonths(1);
            case QUARTERLY:
                return currentDueDate.plusMonths(3);
            case HALF_YEARLY:
                return currentDueDate.plusMonths(6);
            case YEARLY:
                return currentDueDate.plusYears(1);
            default:
                return null;
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
        history.setPerformedAt(LocalDateTime.now());
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
                config.setDueDate(dto.getDueDate());
                config.setCustomDueDate(dto.getCustomDueDate());
                config.setDueDayOfMonth(dto.getDueDayOfMonth());
                config.setDueQuarter(dto.getDueQuarter());
                config.setDueHalf(dto.getDueHalf());
                config.setDueMonth(dto.getDueMonth());
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
        dto.setEditableForCompanies(template.getEditableForCompanies() != null && template.getEditableForCompanies());
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

            LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
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
            dto.setRepeatReminder(null);
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

            if (config.getCompanyCompliance().getStatus() != null) {
                dto.setStatus(config.getCompanyCompliance().getStatus());
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
        }

        dto.setStatus(cc.getStatus());
        dto.setAssignedAt(cc.getCreatedAt());
        dto.setNotes(cc.getAdminNotes());

        if (cc.getCreatedBy() != null) {
            userRepository.findById(cc.getCreatedBy()).ifPresent(user -> {
                dto.setAssignedByName(user.getFirstName() + " " + user.getLastName());
            });
        }

        Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(cc.getId());
        boolean isConfigured = configOpt.isPresent();
        dto.setConfigured(isConfigured);

        if (isConfigured) {
            ComplianceConfig config = configOpt.get();
            if (config.getFrequency() != null) {
                dto.setFrequency(config.getFrequency().name());

                LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
                dto.setEffectiveDueDate(effectiveDueDate);
                dto.setDueDate(effectiveDueDate);

                if (cc.getStatus() == ComplianceStatus.COMPLETED) {
                    LocalDate nextDueDate = getNextDueDateForCompliance(cc);
                    dto.setNextDueDate(nextDueDate);
                } else {
                    dto.setNextDueDate(effectiveDueDate);
                }
            } else {
                dto.setFrequency(null);
                dto.setEffectiveDueDate(null);
                dto.setDueDate(null);
                dto.setNextDueDate(null);
            }
        } else {
            dto.setFrequency(null);
            dto.setEffectiveDueDate(null);
            dto.setDueDate(null);
            dto.setNextDueDate(null);
        }

        if (cc.getSubTemplate() != null) {
            dto.setSubTemplateName(cc.getSubTemplate().getName());
        }

        dto.setSubmissionReference(cc.getAdminSubmissionReference());
        dto.setSubmissionDocumentUrl(cc.getAdminSubmissionDocumentUrl());

        if (cc.getStatus() == ComplianceStatus.COMPLETED) {
            LocalDateTime completedAt = cc.getCompletedAt() != null ? cc.getCompletedAt() : cc.getUpdatedAt();
            dto.setCompletedAt(completedAt);

            if (cc.getCompletedBy() != null) {
                userRepository.findById(cc.getCompletedBy()).ifPresent(user ->
                        dto.setCompletedByName(user.getFullName())
                );
            } else if (cc.getUpdatedBy() != null) {
                userRepository.findById(cc.getUpdatedBy()).ifPresent(user ->
                        dto.setCompletedByName(user.getFullName())
                );
            }
            if (dto.getCompletedByName() == null) {
                dto.setCompletedByName("Company Admin");
            }
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
        dto.setCustomDueDate(config.getCustomDueDate() != null ? config.getCustomDueDate().toString() : null);
        dto.setDueDayOfMonth(config.getDueDayOfMonth());
        dto.setDueQuarter(config.getDueQuarter());
        dto.setDueHalf(config.getDueHalf());
        dto.setDueMonth(config.getDueMonth());
        dto.setReminderDaysBefore(config.getReminderDaysBefore());
        dto.setRepeatReminder(config.getRepeatReminder());
        dto.setReminderIntervalDays(config.getReminderIntervalDays());
        dto.setDescription(config.getDescription());
        dto.setDocumentRequired(config.getDocumentRequired());
        dto.setExternalLink(config.getExternalLink());
        dto.setInstructions(config.getInstructions());
        dto.setIsActive(config.getIsActive());

        LocalDate effectiveDueDate = calculateEffectiveDueDate(config);
        if (effectiveDueDate != null) {
            dto.setEffectiveDueDate(effectiveDueDate.toString());
        }

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

    // ==================== DEPRECATED/REMOVED CUSTOM COMPLIANCE METHODS ====================
    // The following methods have been removed as company admin can no longer create custom parent compliances:
    // - createCustomTemplate
    // - getCustomTemplatesByCompany
    // - createCustomSubTemplate (old)
    // - configureCustomCompliance
    // The new method configureSubComplianceForCompany replaces the old configureCustomSubCompliance.
}