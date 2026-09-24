package com.vnext.controller;

import com.vnext.dto.*;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.*;
import com.vnext.security.CurrentUser;
import com.vnext.security.SecurityUtils;
import com.vnext.service.CompanyService;
import com.vnext.service.ComplianceService;
import com.vnext.service.EmployeeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;
import java.util.stream.Collectors;
import org.springframework.transaction.annotation.Transactional;

@RestController
@RequestMapping("/api/super-admin")
@PreAuthorize("hasRole('SUPER_ADMIN')")
@RequiredArgsConstructor
@Slf4j
public class SuperAdminController {

    private final CompanyService companyService;
    private final ComplianceService complianceService;
    private final EmployeeService employeeService;
    private final ComplianceTemplateRepository templateRepository;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final CompanyRepository companyRepository;
    private final ComplianceSubTemplateRepository subTemplateRepository;
    private final ComplianceConfigRepository configRepository;
    private final NotificationScheduleConfigRepository notificationScheduleConfigRepository;
    private final DeviceTokenRepository deviceTokenRepository;
    private final PushDeliveryLogRepository pushDeliveryLogRepository;
    private final com.vnext.service.PushNotificationService pushNotificationService;
    private final com.vnext.service.SchedulerService schedulerService;
    private final UserRepository userRepository;
    private final com.vnext.security.JwtService jwtService;

    // ==================== COMPANY MANAGEMENT ====================

    @PostMapping("/companies")
    public ApiResponse<CompanyResponseDTO> createCompany(@Valid @RequestBody CompanyDTO companyDTO) {
        CompanyResponseDTO company = companyService.createCompany(companyDTO);
        return ApiResponse.success(company, "Company created successfully");
    }

    @GetMapping("/compliance/categories/{id}/details")
    public ApiResponse<CategoryDetailsDTO> getCategoryDetails(@PathVariable Long id) {
        CategoryDetailsDTO details = complianceService.getCategoryDetails(id);
        return ApiResponse.success(details, "Category details retrieved successfully");
    }

    @GetMapping("/compliance/templates/{templateId}/history")
    public ApiResponse<List<ComplianceHistoryDTO>> getTemplateHistory(@PathVariable Long templateId) {
        List<ComplianceHistoryDTO> history = complianceService.getTemplateHistory(templateId);
        return ApiResponse.success(history, "Template history retrieved successfully");
    }

    @PostMapping("/compliance/templates/{templateId}/assign-to-companies")
    public ApiResponse<Void> assignComplianceToAllCompanies(
            @PathVariable Long templateId,
            @CurrentUser User admin) {

        log.info("SuperAdmin assigning compliance template {} to all active companies", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new ResourceNotFoundException("Template not found with ID: " + templateId));

        List<Company> activeCompanies = companyRepository.findByStatusAndIsActiveTrue(CompanyStatus.ACTIVE);

        if (activeCompanies.isEmpty()) {
            throw new BusinessException("No active companies found to assign compliance");
        }

        // For editable templates, do not auto‑assign global sub‑templates.
        // The assignment logic in service handles this.
        complianceService.assignComplianceToAllActiveCompanies(templateId, admin.getId());
        return ApiResponse.success("Compliance assigned to all active companies successfully");
    }

    @GetMapping("/compliance/debug/template/{templateId}")
    public ApiResponse<Map<String, Object>> debugTemplateConfigs(@PathVariable Long templateId) {
        Map<String, Object> result = new HashMap<>();
        result.put("templateId", templateId);

        ComplianceTemplate template = templateRepository.findById(templateId).orElse(null);
        if (template == null) {
            return ApiResponse.error("Template not found", 404);
        }
        result.put("templateName", template.getName());

        if (template.getDirectConfig() != null) {
            result.put("hasParentConfig", true);
            result.put("parentConfig", template.getDirectConfig().getFrequency());
        } else {
            result.put("hasParentConfig", false);
        }

        List<ComplianceSubTemplate> subTemplates = subTemplateRepository
                .findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(templateId);
        result.put("subTemplateCount", subTemplates.size());

        List<Map<String, Object>> subConfigs = new ArrayList<>();
        for (ComplianceSubTemplate sub : subTemplates) {
            Map<String, Object> subInfo = new HashMap<>();
            subInfo.put("id", sub.getId());
            subInfo.put("name", sub.getName());

            Optional<ComplianceConfig> config = configRepository
                    .findByTemplateIdAndCompanyComplianceId(sub.getId(), null);
            if (config.isPresent()) {
                subInfo.put("hasConfig", true);
                subInfo.put("frequency", config.get().getFrequency());
                subInfo.put("dueDate", config.get().getDueDate());
            } else {
                subInfo.put("hasConfig", false);
            }
            subConfigs.add(subInfo);
        }
        result.put("subTemplateConfigs", subConfigs);

        return ApiResponse.success(result, "Debug info retrieved");
    }

    @GetMapping("/companies")
    public ApiResponse<Page<CompanyResponseDTO>> getAllCompanies(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestParam(required = false) CompanyStatus status,
            @RequestParam(required = false) String search) {

        Sort sort = sortDir.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<CompanyResponseDTO> companies = companyService.searchCompanies(search, status, sortBy, sortDir, pageable);
        return ApiResponse.success(companies, "Companies retrieved successfully");
    }

    @GetMapping("/companies/{companyId}")
    public ApiResponse<CompanyResponseDTO> getCompanyById(@PathVariable Long companyId) {
        CompanyResponseDTO company = companyService.getCompanyById(companyId);
        return ApiResponse.success(company, "Company retrieved successfully");
    }

    @PutMapping("/companies/{companyId}")
    public ApiResponse<CompanyResponseDTO> updateCompany(@PathVariable Long companyId, @Valid @RequestBody CompanyDTO companyDTO) {
        CompanyResponseDTO company = companyService.updateCompany(companyId, companyDTO);
        return ApiResponse.success(company, "Company updated successfully");
    }

    @PatchMapping("/companies/{companyId}/status")
    public ApiResponse<CompanyResponseDTO> updateCompanyStatus(
            @PathVariable Long companyId,
            @RequestParam String status) {
        CompanyStatus statusEnum;
        try {
            statusEnum = CompanyStatus.valueOf(status.trim().toUpperCase());
        } catch (Exception e) {
            statusEnum = ("INACTIVE".equalsIgnoreCase(status) || "DEACTIVATED".equalsIgnoreCase(status))
                    ? CompanyStatus.DEACTIVATED : CompanyStatus.ACTIVE;
        }
        if (statusEnum == CompanyStatus.INACTIVE) {
            statusEnum = CompanyStatus.DEACTIVATED;
        }
        CompanyResponseDTO company = companyService.updateCompanyStatus(companyId, statusEnum);
        return ApiResponse.success(company, "Company status updated successfully");
    }

    @DeleteMapping("/companies/{companyId}")
    public ApiResponse<Void> deleteCompany(@PathVariable Long companyId) {
        companyService.deleteCompany(companyId);
        return ApiResponse.success("Company deleted successfully");
    }

    @PutMapping("/companies/{companyId}/employee-limit")
    public ApiResponse<CompanyResponseDTO> updateEmployeeLimit(
            @PathVariable Long companyId,
            @RequestParam Integer employeeLimit) {
        CompanyResponseDTO company = companyService.updateEmployeeLimit(companyId, employeeLimit);
        return ApiResponse.success(company, "Employee limit updated successfully");
    }

    // ==================== COMPANY DOCUMENTS ====================

    @PostMapping(value = "/companies/{companyId}/documents", consumes = "multipart/form-data")
    public ApiResponse<List<CompanyDocumentDTO>> uploadCompanyDocuments(
            @PathVariable Long companyId,
            @RequestParam("files") List<MultipartFile> files,
            @CurrentUser User admin) {
        List<CompanyDocumentDTO> docs = companyService.uploadDocuments(companyId, files, admin.getId());
        return ApiResponse.success(docs, "Documents uploaded successfully");
    }

    @GetMapping("/companies/{companyId}/documents")
    public ApiResponse<List<CompanyDocumentDTO>> getCompanyDocuments(@PathVariable Long companyId) {
        return ApiResponse.success(companyService.getCompanyDocuments(companyId), "Documents retrieved");
    }

    @DeleteMapping("/companies/{companyId}/documents/{documentId}")
    public ApiResponse<Void> deleteCompanyDocument(
            @PathVariable Long companyId,
            @PathVariable Long documentId,
            @CurrentUser User admin) {
        companyService.deleteDocument(documentId, admin.getId());
        return ApiResponse.success("Document deleted");
    }

    @PostMapping("/companies/{companyId}/verify-documents")
    public ApiResponse<Void> verifyCompanyDocuments(@PathVariable Long companyId) {
        companyService.verifyCompanyDocuments(companyId);
        return ApiResponse.success("Company documents verified successfully");
    }

    @PostMapping("/companies/{companyId}/extend-subscription")
    public ApiResponse<Void> extendSubscription(
            @PathVariable Long companyId,
            @RequestParam int months) {
        companyService.extendSubscription(companyId, months);
        return ApiResponse.success("Subscription extended successfully");
    }

    // ==================== COMPLIANCE MANAGEMENT ====================

    @PostMapping("/compliance/templates")
    public ApiResponse<ComplianceTemplateDTO> createCompliance(
            @Valid @RequestBody ComplianceTemplateDTO dto,
            @CurrentUser User admin) {
        ComplianceTemplateDTO created = complianceService.createTemplate(dto, admin.getId());
        return ApiResponse.success(created, "Compliance created successfully");
    }

    @GetMapping("/compliance/templates")
    public ApiResponse<Page<ComplianceTemplateSummaryDTO>> getCompliances(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size,
                Sort.by("priority").ascending().and(Sort.by("name").ascending()));
        Page<ComplianceTemplateSummaryDTO> templates = complianceService.getSuperAdminTemplatesWithStats(pageable);
        return ApiResponse.success(templates, "Compliances retrieved successfully");
    }

    @GetMapping("/compliance/templates/{templateId}/company-sub-compliances")
    public ApiResponse<Map<String, Object>> getCompanySubCompliancesForEditableTemplate(@PathVariable Long templateId) {
        Map<String, Object> result = complianceService.getEditableTemplateCompanySubCompliances(templateId);
        return ApiResponse.success(result, "Company sub-compliances retrieved successfully");
    }

    @GetMapping("/compliance/sub-templates/{id}/config")
    public ApiResponse<ComplianceConfigDTO> getSubTemplateConfig(@PathVariable Long id) {
        ComplianceConfigDTO config = complianceService.getSubTemplateConfig(id);
        if (config == null) {
            return ApiResponse.success(null, "No configuration found for this sub-template");
        }
        return ApiResponse.success(config, "Sub-template configuration retrieved successfully");
    }

    @DeleteMapping("/compliance/templates/{id}")
    public ApiResponse<Void> deleteTemplate(@PathVariable Long id) {
        complianceService.deleteTemplatePermanently(id);
        return ApiResponse.success("Template permanently deleted successfully");
    }

    @GetMapping("/compliance/config")
    public ApiResponse<ComplianceConfigDTO> getComplianceConfig(
            @RequestParam Long templateId) {
        ComplianceConfigDTO config = complianceService.getComplianceConfigByTemplate(templateId);
        return ApiResponse.success(config, "Configuration retrieved successfully");
    }

    @GetMapping("/compliance/templates/{id}")
    public ApiResponse<ComplianceTemplateDTO> getTemplateById(@PathVariable Long id) {
        ComplianceTemplateDTO template = complianceService.getTemplateById(id);
        return ApiResponse.success(template, "Template retrieved successfully");
    }

    @PostMapping("/compliance/sub-templates")
    public ApiResponse<ComplianceSubTemplateDTO> createSubCompliance(
            @RequestParam Long parentId,
            @Valid @RequestBody ComplianceSubTemplateDTO dto,
            @CurrentUser User admin) {
        ComplianceSubTemplateDTO created = complianceService.createSubTemplate(parentId, dto, admin.getId());
        return ApiResponse.success(created, "Sub-compliance created successfully");
    }

    @GetMapping("/compliance/sub-templates")
    public ApiResponse<List<ComplianceSubTemplateDTO>> getSubCompliances(
            @RequestParam Long parentId) {
        List<ComplianceSubTemplateDTO> subTemplates = complianceService.getSubTemplatesByParent(parentId);
        return ApiResponse.success(subTemplates, "Sub-compliances retrieved successfully");
    }

    @PutMapping("/compliance/sub-templates/{id}")
    public ApiResponse<ComplianceSubTemplateDTO> updateSubCompliance(
            @PathVariable Long id,
            @Valid @RequestBody ComplianceSubTemplateDTO dto,
            @CurrentUser User admin) {
        ComplianceSubTemplateDTO updated = complianceService.updateSubTemplate(id, dto, admin.getId());
        return ApiResponse.success(updated, "Sub-compliance updated successfully");
    }

    @PatchMapping("/compliance/sub-templates/{id}/toggle-status")
    public ApiResponse<ComplianceSubTemplateDTO> toggleSubTemplateStatus(@PathVariable Long id) {
        ComplianceSubTemplateDTO updated = complianceService.toggleSubTemplateStatus(id);
        return ApiResponse.success(updated, "Sub-compliance status toggled");
    }

    @DeleteMapping("/compliance/sub-templates/{id}")
    public ApiResponse<Void> deleteSubCompliance(@PathVariable Long id) {
        complianceService.deleteSubTemplatePermanently(id);
        return ApiResponse.success("Sub-compliance deleted successfully");
    }

    @PostMapping("/compliance/config")
    public ApiResponse<ComplianceConfigDTO> configureCompliance(
            @RequestParam Long templateId,
            @Valid @RequestBody ComplianceConfigDTO dto,
            @CurrentUser User admin) {
        ComplianceConfigDTO config = complianceService.configureCompliance(templateId, dto, admin.getId());
        return ApiResponse.success(config, "Compliance configured successfully");
    }

    @PostMapping("/compliance/sub-config")
    public ApiResponse<ComplianceConfigDTO> configureSubCompliance(
            @RequestParam Long subTemplateId,
            @Valid @RequestBody ComplianceConfigDTO dto,
            @CurrentUser User admin) {
        ComplianceConfigDTO config = complianceService.configureSubCompliance(subTemplateId, dto, admin.getId());
        return ApiResponse.success(config, "Sub-compliance configured successfully");
    }

    @PutMapping("/compliance/templates/{id}")
    public ApiResponse<ComplianceTemplateDTO> updateTemplate(
            @PathVariable Long id,
            @Valid @RequestBody ComplianceTemplateDTO dto,
            @CurrentUser User admin) {
        log.info("Updating compliance template: {}", id);
        ComplianceTemplateDTO updated = complianceService.updateTemplate(id, dto, admin.getId());
        return ApiResponse.success(updated, "Template updated successfully");
    }

    // ==================== ASSIGNMENTS ====================

    @GetMapping("/compliance/assignments")
    public ApiResponse<Page<CompanyComplianceDTO>> getAllAssignments(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long companyId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long templateId,
            @RequestParam(required = false) Boolean isActive) {

        log.info("=== GETTING ASSIGNMENTS ===");
        log.info("companyId: {}, templateId: {}", companyId, templateId);

        ComplianceStatus statusEnum = null;
        if (status != null && !status.isEmpty()) {
            try {
                statusEnum = ComplianceStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                log.warn("Ignoring invalid status filter: {}", status);
            }
        }

        Pageable pageable = PageRequest.of(page, size);
        Page<CompanyComplianceDTO> assignments = complianceService.getAllAssignments(
                companyId, statusEnum, templateId, isActive, pageable);

        List<CompanyComplianceDTO> filteredList = new ArrayList<>(assignments.getContent());

        Map<Long, Boolean> templateHasSubs = new HashMap<>();
        for (CompanyComplianceDTO dto : filteredList) {
            Long templateIdKey = dto.getTemplateId();
            if (templateIdKey != null && !templateHasSubs.containsKey(templateIdKey)) {
                List<ComplianceSubTemplateDTO> subs = complianceService.getSubTemplatesByParent(templateIdKey);
                templateHasSubs.put(templateIdKey, !subs.isEmpty());
            }
        }

        filteredList = filteredList.stream()
                .filter(dto -> {
                    if (dto.getSubTemplateName() == null &&
                            dto.getTemplateId() != null &&
                            templateHasSubs.getOrDefault(dto.getTemplateId(), false)) {
                        return false;
                    }
                    return true;
                })
                .collect(Collectors.toList());

        log.info("Returning {} assignments", filteredList.size());

        return ApiResponse.success(
                new PageImpl<>(filteredList, pageable, assignments.getTotalElements()),
                "Assignments retrieved successfully");
    }

    @GetMapping("/compliance/assignments/{id}")
    public ApiResponse<CompanyComplianceDTO> getAssignmentById(@PathVariable Long id) {
        CompanyComplianceDTO assignment = complianceService.getComplianceById(id);
        return ApiResponse.success(assignment, "Assignment retrieved successfully");
    }

    @PatchMapping("/compliance/assignments/{id}/toggle-status")
    public ApiResponse<CompanyComplianceDTO> toggleAssignmentStatus(@PathVariable Long id) {
        CompanyComplianceDTO assignment = complianceService.toggleAssignmentStatus(id);
        return ApiResponse.success(assignment, "Assignment status updated");
    }

    @DeleteMapping("/compliance/assignments/{id}")
    public ApiResponse<Void> deleteAssignment(@PathVariable Long id) {
        try {
            complianceService.deleteAssignment(id);
            return ApiResponse.success("Assignment deleted successfully");
        } catch (ResourceNotFoundException e) {
            log.error("Resource not found when deleting assignment {}: {}", id, e.getMessage());
            return ApiResponse.error(e.getMessage(), 404);
        } catch (BusinessException e) {
            log.error("Business exception when deleting assignment {}: {}", id, e.getMessage());
            return ApiResponse.error(e.getMessage(), 400);
        } catch (Exception e) {
            log.error("Error deleting assignment {}: {}", id, e.getMessage(), e);
            return ApiResponse.error("Failed to delete assignment: " + e.getMessage(), 500);
        }
    }

    @DeleteMapping("/compliance/companies/{companyId}/templates/{templateId}")
    public ApiResponse<Void> removeCompanyFromCompliancePermanently(
            @PathVariable Long companyId,
            @PathVariable Long templateId,
            @CurrentUser User admin) {
        log.info("Permanently removing company {} from template {}", companyId, templateId);
        try {
            Long adminId = admin != null ? admin.getId() : SecurityUtils.getCurrentUserId();
            if (adminId == null) {
                adminId = 1L;
            }
            complianceService.removeCompanyFromCompliancePermanently(companyId, templateId, adminId);
            return ApiResponse.success("Company removed from compliance permanently");
        } catch (ResourceNotFoundException e) {
            log.error("Resource not found when removing company {} from template {}: {}", companyId, templateId, e.getMessage());
            return ApiResponse.error(e.getMessage(), 404);
        } catch (BusinessException e) {
            log.error("Business exception when removing company {} from template {}: {}", companyId, templateId, e.getMessage());
            return ApiResponse.error(e.getMessage(), 400);
        } catch (Exception e) {
            log.error("Error permanently removing company {} from template {}: {}", companyId, templateId, e.getMessage(), e);
            return ApiResponse.error("Failed to remove company from compliance: " + e.getMessage(), 500);
        }
    }

    @PostMapping("/compliance/assign")
    public ApiResponse<Void> assignCompliance(
            @Valid @RequestBody ComplianceAssignDTO assignDTO,
            @CurrentUser User admin) {
        log.info("Assigning compliance template {} to {} companies", assignDTO.getTemplateId(), assignDTO.getCompanyIds().size());

        for (Long companyId : assignDTO.getCompanyIds()) {
            if (!companyRepository.existsById(companyId)) {
                return ApiResponse.error("Company not found with ID: " + companyId, 404);
            }
        }

        if (!templateRepository.existsById(assignDTO.getTemplateId())) {
            return ApiResponse.error("Template not found with ID: " + assignDTO.getTemplateId(), 404);
        }

        try {
            complianceService.assignComplianceToCompanies(assignDTO, admin.getId());
            return ApiResponse.success("Compliance assigned successfully");
        } catch (Exception e) {
            log.error("Error assigning compliance: {}", e.getMessage(), e);
            return ApiResponse.error("Failed to assign compliance: " + e.getMessage(), 500);
        }
    }

    @PostMapping("/compliance/assign-to-company")
    public ApiResponse<Void> assignComplianceToCompany(
            @RequestParam Long templateId,
            @RequestParam Long companyId,
            @CurrentUser User admin) {
        log.info("=== SuperAdmin assigning compliance {} to company {} ===", templateId, companyId);

        if (!templateRepository.existsById(templateId)) {
            return ApiResponse.error("Template not found with ID: " + templateId, 404);
        }

        if (!companyRepository.existsById(companyId)) {
            return ApiResponse.error("Company not found with ID: " + companyId, 404);
        }

        try {
            complianceService.assignComplianceToCompany(templateId, companyId, admin.getId());
            return ApiResponse.success("Compliance assigned to company successfully");
        } catch (BusinessException e) {
            return ApiResponse.error(e.getMessage(), 400);
        } catch (Exception e) {
            log.error("Error assigning compliance: {}", e.getMessage(), e);
            return ApiResponse.error("Failed to assign compliance: " + e.getMessage(), 500);
        }
    }

    @GetMapping("/compliance/companies/{companyId}")
    public ApiResponse<Page<CompanyComplianceDTO>> getCompanyCompliances(
            @PathVariable Long companyId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size,
                Sort.by("priority").ascending().and(Sort.by("name").ascending()));
        Page<CompanyComplianceDTO> compliances = complianceService.getCompliancesByCompany(companyId, pageable);
        return ApiResponse.success(compliances, "Compliances retrieved successfully");
    }

    // ==================== DASHBOARD ====================

    @GetMapping("/stats")
    public ApiResponse<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCompanies", companyService.getTotalCompanies());
        stats.put("activeCompanies", companyService.getTotalActiveCompanies());
        stats.put("deactivatedCompanies", companyService.getTotalDeactivatedCompanies());
        stats.put("totalCompliances", complianceService.getSuperAdminCompliances().size());
        stats.put("totalAssignments",
                complianceService.getAllAssignments(null, null, null, null, PageRequest.of(0, 1)).getTotalElements());
        return ApiResponse.success(stats, "Stats retrieved successfully");
    }

    @GetMapping("/dashboard/stats")
    public ApiResponse<Map<String, Object>> getDashboardStats() {
        return getStats();
    }

    @GetMapping("/dashboard/overdue")
    public ApiResponse<List<Map<String, Object>>> getOverdueCompliances() {
        List<Map<String, Object>> overdue = new ArrayList<>();
        return ApiResponse.success(overdue, "Overdue compliances retrieved");
    }

    // ==================== CHANGE PASSWORD ====================

    @PutMapping("/change-password")
    public ApiResponse<ChangePasswordResponse> changePassword(
            @CurrentUser User admin,
            @Valid @RequestBody ChangePasswordRequest request) {
        ChangePasswordResponse response = companyService.changePassword(admin.getId(), request);
        return ApiResponse.success(response, "Password changed successfully");
    }

    @GetMapping("/compliance/debug/company/{companyId}")
    public ApiResponse<Map<String, Object>> debugCompanyCompliances(@PathVariable Long companyId) {
        Map<String, Object> result = new HashMap<>();
        result.put("companyId", companyId);

        List<CompanyCompliance> allCompliances = companyComplianceRepository
                .findByCompanyIdAndDeletedFalse(companyId, Pageable.unpaged()).getContent();

        result.put("totalCompliances", allCompliances.size());

        List<Map<String, Object>> complianceList = new ArrayList<>();
        for (CompanyCompliance cc : allCompliances) {
            Map<String, Object> info = new HashMap<>();
            info.put("id", cc.getId());
            info.put("templateId", cc.getTemplate().getId());
            info.put("templateName", cc.getTemplate().getName());
            info.put("isParent", cc.isParent());
            info.put("isActive", cc.getIsActive());
            info.put("isDeleted", cc.isDeleted());
            info.put("status", cc.getStatus());
            info.put("subTemplateId", cc.getSubTemplate() != null ? cc.getSubTemplate().getId() : null);
            info.put("subTemplateName", cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : null);

            Optional<ComplianceConfig> config = configRepository.findByCompanyComplianceId(cc.getId());
            info.put("hasConfig", config.isPresent());
            if (config.isPresent()) {
                info.put("configId", config.get().getId());
                info.put("frequency", config.get().getFrequency());
                info.put("dueDate", config.get().getDueDate());
            }

            complianceList.add(info);
        }
        result.put("compliances", complianceList);

        return ApiResponse.success(result, "Debug info retrieved");
    }

    // ==================== FCM PUSH NOTIFICATION SCHEDULE CONFIG ====================
    // Controls the frequency of physical phone drawer FCM pushes (NOT in-app announcements).

    private String resolveScheduleKey(String notificationType) {
        if (notificationType == null) return "DUE_REMINDER";
        String upper = notificationType.trim().toUpperCase();
        if ("FCM_DUE_REMINDER".equals(upper) || "COMPLIANCE_DUE_SOON".equals(upper) || "DUE_REMINDER".equals(upper)) {
            return "DUE_REMINDER";
        }
        return upper;
    }

    @GetMapping("/notification-schedule")
    public ApiResponse<List<NotificationScheduleConfigDTO>> getAllNotificationSchedules() {
        List<NotificationScheduleConfig> configs = notificationScheduleConfigRepository.findAll();
        if (configs.isEmpty()) {
            NotificationScheduleConfig seed = new NotificationScheduleConfig();
            seed.setNotificationType("DUE_REMINDER");
            seed.setEnabled(true);
            seed.setTimesPerDay(3);
            seed.setStartHour(8);
            seed.setEndHour(20);
            seed.setSentTodayCount(0);
            configs = List.of(notificationScheduleConfigRepository.save(seed));
        }
        List<NotificationScheduleConfigDTO> dtos = configs.stream().map(this::mapToScheduleDTO).collect(Collectors.toList());
        return ApiResponse.success(dtos, "FCM push notification schedules retrieved successfully");
    }

    @GetMapping("/notification-schedule/{notificationType}")
    public ApiResponse<NotificationScheduleConfigDTO> getNotificationSchedule(@PathVariable String notificationType) {
        String key = resolveScheduleKey(notificationType);
        NotificationScheduleConfig config = notificationScheduleConfigRepository.findByNotificationType(key)
                .orElseGet(() -> {
                    if ("DUE_REMINDER".equalsIgnoreCase(key)) {
                        NotificationScheduleConfig seed = new NotificationScheduleConfig();
                        seed.setNotificationType("DUE_REMINDER");
                        seed.setEnabled(true);
                        seed.setTimesPerDay(3);
                        seed.setStartHour(8);
                        seed.setEndHour(20);
                        seed.setSentTodayCount(0);
                        return notificationScheduleConfigRepository.save(seed);
                    }
                    throw new ResourceNotFoundException("Notification schedule config not found for type: " + notificationType);
                });
        return ApiResponse.success(mapToScheduleDTO(config), "FCM push notification schedule retrieved successfully");
    }

    @PutMapping("/notification-schedule/{notificationType}")
    public ApiResponse<NotificationScheduleConfigDTO> updateNotificationSchedule(
            @PathVariable String notificationType,
            @RequestBody NotificationScheduleConfigDTO dto,
            @CurrentUser User admin) {

        String key = resolveScheduleKey(notificationType);

        if (dto.getTimesPerDay() != null && (dto.getTimesPerDay() < 1 || dto.getTimesPerDay() > 20)) {
            throw new BusinessException("timesPerDay must be between 1 and 20");
        }
        if (dto.getStartHour() != null && (dto.getStartHour() < 0 || dto.getStartHour() > 23)) {
            throw new BusinessException("startHour must be between 0 and 23");
        }
        if (dto.getEndHour() != null && (dto.getEndHour() < 0 || dto.getEndHour() > 23)) {
            throw new BusinessException("endHour must be between 0 and 23");
        }
        if (dto.getStartHour() != null && dto.getEndHour() != null && dto.getStartHour() >= dto.getEndHour()) {
            throw new BusinessException("startHour must be strictly less than endHour");
        }

        NotificationScheduleConfig config = notificationScheduleConfigRepository.findByNotificationType(key)
                .orElseGet(() -> {
                    NotificationScheduleConfig seed = new NotificationScheduleConfig();
                    seed.setNotificationType(key);
                    return seed;
                });

        if (dto.getEnabled() != null) {
            config.setEnabled(dto.getEnabled());
        }
        if (dto.getTimesPerDay() != null) {
            config.setTimesPerDay(Math.max(1, Math.min(20, dto.getTimesPerDay())));
        }
        if (dto.getStartHour() != null) {
            config.setStartHour(dto.getStartHour());
        }
        if (dto.getEndHour() != null) {
            config.setEndHour(dto.getEndHour());
        }
        if (admin != null) {
            config.setUpdatedBy(admin.getId());
        }

        // Always reset sent counts whenever schedule is saved so new timings apply cleanly
        config.setSentTodayCount(0);
        config.setLastSentAt(null);
        config.setLastSentDate(java.time.LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")));

        NotificationScheduleConfig saved = notificationScheduleConfigRepository.save(config);
        log.info("SuperAdmin {} updated FCM push schedule config for {}: enabled={}, timesPerDay={}, startHour={}, endHour={}",
                admin != null ? admin.getId() : "SYSTEM", key, saved.getEnabled(), saved.getTimesPerDay(), saved.getStartHour(), saved.getEndHour());

        return ApiResponse.success(mapToScheduleDTO(saved), "FCM push notification schedule updated successfully");
    }

    @PostMapping("/notification-schedule/trigger-reminders-now")
    public ApiResponse<String> triggerDueRemindersNow() {
        log.info("SuperAdmin manually triggered immediate due/overdue compliance reminder checks");
        schedulerService.executeDueReminderChecks();
        return ApiResponse.success("Due and overdue compliance reminders evaluated and dispatched to all target devices successfully!");
    }

    @GetMapping("/notification-schedule/metrics")
    public ApiResponse<PushNotificationDashboardDTO> getNotificationScheduleMetrics() {
        java.time.ZoneId istZone = java.time.ZoneId.of("Asia/Kolkata");
        java.time.LocalDateTime nowIst = java.time.LocalDateTime.now(istZone);
        java.time.LocalDate todayIst = nowIst.toLocalDate();
        java.time.LocalDateTime startOfToday = todayIst.atStartOfDay();
        java.time.LocalDateTime sevenDaysAgo = nowIst.minusDays(7);

        // 1. Config & Slots
        NotificationScheduleConfig config = notificationScheduleConfigRepository.findByNotificationType("DUE_REMINDER")
                .orElseGet(() -> {
                    NotificationScheduleConfig seed = new NotificationScheduleConfig();
                    seed.setNotificationType("DUE_REMINDER");
                    seed.setEnabled(true);
                    seed.setTimesPerDay(3);
                    seed.setStartHour(8);
                    seed.setEndHour(20);
                    seed.setSentTodayCount(0);
                    return notificationScheduleConfigRepository.save(seed);
                });

        int timesPerDay = config.getTimesPerDay() != null ? Math.max(1, Math.min(20, config.getTimesPerDay())) : 3;
        int startHour = config.getStartHour() != null ? config.getStartHour() : 8;
        int endHour = config.getEndHour() != null ? config.getEndHour() : 20;

        java.time.LocalDateTime dayStart = todayIst.atTime(startHour, 0);

        int sentTodayCount = config.getSentTodayCount() != null ? config.getSentTodayCount() : 0;
        if (!todayIst.equals(config.getLastSentDate()) || (config.getLastSentAt() != null && config.getLastSentAt().isBefore(dayStart))) {
            sentTodayCount = 0;
        }
        if (sentTodayCount > timesPerDay) {
            sentTodayCount = 0;
        }

        double intervalMinsDouble = timesPerDay <= 1 ? 0 : ((endHour - startHour) * 60.0) / (timesPerDay - 1);
        int intervalMins = (int) Math.round(intervalMinsDouble);
        String intervalFormatted = timesPerDay <= 1 ? "Once daily" : "Every " + (intervalMins >= 60 ? (intervalMins / 60) + "h " + (intervalMins % 60 > 0 ? (intervalMins % 60) + "m" : "") : intervalMins + "m");

        List<PushNotificationDashboardDTO.DailySlotDTO> dailySlots = new ArrayList<>();
        java.time.LocalDateTime nextSlotTime = null;

        java.time.format.DateTimeFormatter slotTimeFmt = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");

        for (int i = 0; i < timesPerDay; i++) {
            java.time.LocalDateTime slotTime = dayStart.plusMinutes(Math.round(intervalMinsDouble * i));
            String timeFormatted = slotTime.format(slotTimeFmt);
            String status;
            boolean isNext = false;

            boolean alreadySent = i < sentTodayCount;
            boolean timeHasPassed = slotTime.isBefore(nowIst.minusSeconds(30));

            if (alreadySent) {
                // Scheduler actually fired and sent this slot
                status = "SENT";
            } else if (timeHasPassed) {
                // Slot time passed but scheduler did NOT send it (e.g. server was down, or scheduler wasn't running)
                status = "MISSED";
            } else if (nextSlotTime == null) {
                // Earliest upcoming slot at or after current time
                nextSlotTime = slotTime;
                isNext = true;
                status = "NEXT";
            } else {
                status = "PENDING";
            }

            dailySlots.add(PushNotificationDashboardDTO.DailySlotDTO.builder()
                    .slotNumber(i + 1)
                    .timeFormatted(timeFormatted)
                    .status(status)
                    .isNext(isNext)
                    .build());
        }

        String nextRunTimeStr = null;
        String nextRunFormatted = null;
        String timeRemaining = null;

        if (!Boolean.TRUE.equals(config.getEnabled())) {
            nextRunFormatted = "Schedule Paused";
            timeRemaining = "Disabled";
        } else if (nextSlotTime != null) {
            nextRunTimeStr = nextSlotTime.toString();
            nextRunFormatted = "Today at " + nextSlotTime.format(slotTimeFmt);
            long totalMins = java.time.Duration.between(nowIst, nextSlotTime).toMinutes();
            if (totalMins > 0) {
                long h = totalMins / 60;
                long m = totalMins % 60;
                timeRemaining = "in " + (h > 0 ? h + "h " : "") + m + "m remaining";
            } else {
                timeRemaining = "Due now";
            }
        } else {
            java.time.LocalDateTime tomorrowFirstSlot = todayIst.plusDays(1).atTime(startHour, 0);
            nextRunTimeStr = tomorrowFirstSlot.toString();
            long totalMins = java.time.Duration.between(nowIst, tomorrowFirstSlot).toMinutes();
            long h = totalMins / 60;
            long m = totalMins % 60;
            nextRunFormatted = "Tomorrow at " + tomorrowFirstSlot.format(slotTimeFmt);
            timeRemaining = "in " + (h > 0 ? h + "h " : "") + m + "m remaining";
        }

        // 2. Metrics (Today & Week)
        long todayPushes = pushDeliveryLogRepository.countSince(startOfToday);
        long todaySuccess = pushDeliveryLogRepository.sumSuccessCountSince(startOfToday);
        long todayFailure = pushDeliveryLogRepository.sumFailureCountSince(startOfToday);
        long todayRecipients = pushDeliveryLogRepository.sumRecipientCountSince(startOfToday);
        double todayRate = (todaySuccess + todayFailure) > 0 ? Math.round(((double) todaySuccess / (todaySuccess + todayFailure)) * 1000.0) / 10.0 : 100.0;

        long weekPushes = pushDeliveryLogRepository.countSince(sevenDaysAgo);
        long weekSuccess = pushDeliveryLogRepository.sumSuccessCountSince(sevenDaysAgo);
        long weekFailure = pushDeliveryLogRepository.sumFailureCountSince(sevenDaysAgo);
        long weekRecipients = pushDeliveryLogRepository.sumRecipientCountSince(sevenDaysAgo);
        double weekRate = (weekSuccess + weekFailure) > 0 ? Math.round(((double) weekSuccess / (weekSuccess + weekFailure)) * 1000.0) / 10.0 : 100.0;

        long totalSuccess = pushDeliveryLogRepository.sumTotalSuccessCount();
        long totalFailure = pushDeliveryLogRepository.sumTotalFailureCount();

        // 3. Devices
        long totalDevices = deviceTokenRepository.count();
        long androidCount = deviceTokenRepository.countByPlatform(com.vnext.entity.Platform.ANDROID);
        long iosCount = deviceTokenRepository.countByPlatform(com.vnext.entity.Platform.IOS);
        long activeUsers = deviceTokenRepository.countDistinctUsers();

        // 4. Recent Logs
        java.time.format.DateTimeFormatter logDtFmt = java.time.format.DateTimeFormatter.ofPattern("dd MMM, hh:mm a");
        List<PushNotificationDashboardDTO.PushDeliveryLogDTO> recentLogs = pushDeliveryLogRepository
                .findAllByOrderByCreatedAtDesc(PageRequest.of(0, 20))
                .stream()
                .map(l -> {
                    String timeAgo = formatTimeAgo(l.getCreatedAt(), nowIst);
                    String sentAtFormatted = l.getCreatedAt() != null ? l.getCreatedAt().format(logDtFmt) : "-";
                    return PushNotificationDashboardDTO.PushDeliveryLogDTO.builder()
                            .id(l.getId())
                            .traceId(l.getTraceId())
                            .notificationType(l.getNotificationType())
                            .title(l.getTitle())
                            .body(l.getBody())
                            .recipientCount(l.getRecipientCount())
                            .successCount(l.getSuccessCount())
                            .failureCount(l.getFailureCount())
                            .status(l.getStatus())
                            .errorMessage(l.getErrorMessage())
                            .sentAtFormatted(sentAtFormatted)
                            .timeAgo(timeAgo)
                            .build();
                })
                .collect(Collectors.toList());

        PushNotificationDashboardDTO dto = PushNotificationDashboardDTO.builder()
                .schedule(mapToScheduleDTO(config))
                .nextRunTime(nextRunTimeStr)
                .nextRunFormatted(nextRunFormatted)
                .timeRemaining(timeRemaining)
                .intervalMinutes(intervalMins)
                .intervalFormatted(intervalFormatted)
                .dailySlots(dailySlots)
                .todayPushesCount(todayPushes)
                .todaySuccessCount(todaySuccess)
                .todayFailureCount(todayFailure)
                .todayRecipientsCount(todayRecipients)
                .todaySuccessRate(todayRate)
                .weekPushesCount(weekPushes)
                .weekSuccessCount(weekSuccess)
                .weekFailureCount(weekFailure)
                .weekRecipientsCount(weekRecipients)
                .weekSuccessRate(weekRate)
                .totalPushesCount(todayPushes + weekPushes)
                .totalSuccessCount(totalSuccess)
                .totalFailureCount(totalFailure)
                .totalRegisteredDevices(totalDevices)
                .androidDevicesCount(androidCount)
                .iosDevicesCount(iosCount)
                .activeUsersWithDevices(activeUsers)
                .recentLogs(recentLogs)
                .build();

        return ApiResponse.success(dto, "FCM push dashboard metrics retrieved successfully");
    }

    @PostMapping("/notification-schedule/test-push")
    public ApiResponse<String> sendTestPush(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String body,
            @CurrentUser User admin) {

        java.time.ZoneId istZone = java.time.ZoneId.of("Asia/Kolkata");
        String pushTitle = (title != null && !title.isBlank()) ? title : "FCM Push Delivery Test";
        String pushBody = (body != null && !body.isBlank()) ? body : "Test push notification dispatched directly from SuperAdmin dashboard at " +
                java.time.LocalDateTime.now(istZone).format(java.time.format.DateTimeFormatter.ofPattern("hh:mm:ss a"));

        com.vnext.service.NotificationPayload payload = com.vnext.service.NotificationPayload.builder()
                .title(pushTitle)
                .body(pushBody)
                .type(NotificationType.SYSTEM_ANNOUNCEMENT)
                .screen("notifications")
                .build();

        if (admin != null) {
            pushNotificationService.sendToUser(admin.getId(), payload);
        } else {
            List<Long> adminIds = userRepository.findAllByRoleAndDeletedFalse(UserRole.SUPER_ADMIN)
                    .stream().map(User::getId).collect(Collectors.toList());
            pushNotificationService.sendToUsers(adminIds, payload);
        }

        return ApiResponse.success("Test FCM push notification dispatched to registered devices successfully!");
    }

    // ==================== DEVICE FLEET & FORCE LOGOUT ====================

    @GetMapping("/devices")
    @Transactional(readOnly = true)
    public ApiResponse<List<RegisteredDeviceDTO>> getRegisteredDevices() {
        java.time.ZoneId istZone = java.time.ZoneId.of("Asia/Kolkata");
        java.time.LocalDateTime nowIst = java.time.LocalDateTime.now(istZone);
        java.time.format.DateTimeFormatter dtFmt = java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

        List<DeviceToken> tokens = deviceTokenRepository.findAll();
        Set<Long> userIds = tokens.stream().map(DeviceToken::getUserId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, User> userMap = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(User::getId, u -> u));

        List<RegisteredDeviceDTO> dtos = tokens.stream().map(t -> {
            User user = userMap.get(t.getUserId());
            String token = t.getDeviceToken() != null ? t.getDeviceToken() : "";
            String masked = token.length() > 14
                    ? token.substring(0, 6) + "..." + token.substring(token.length() - 6)
                    : token;

            String lastSeenFmt = "-";
            if (t.getLastSeen() != null) {
                lastSeenFmt = t.getLastSeen().format(dtFmt) + " (" + formatTimeAgo(t.getLastSeen(), nowIst) + ")";
            }

            String companyName = "VNext SuperAdmin";
            if (user != null) {
                if (user.getRole() == UserRole.SUPER_ADMIN) {
                    companyName = "VNext SuperAdmin";
                } else {
                    try {
                        if (user.getCompany() != null && user.getCompany().getId() != null) {
                            Long cid = user.getCompany().getId();
                            companyName = companyRepository.findById(cid).map(Company::getName).orElse("VNext LLP");
                        }
                    } catch (Exception e) {
                        companyName = "VNext LLP";
                    }
                }
            }

            return RegisteredDeviceDTO.builder()
                    .id(t.getId())
                    .userId(t.getUserId())
                    .userName(user != null ? (user.getFirstName() + " " + (user.getLastName() != null ? user.getLastName() : "")).trim() : "Unknown User")
                    .userEmail(user != null ? user.getEmail() : "-")
                    .userRole(user != null && user.getRole() != null ? user.getRole().name() : "-")
                    .companyName(companyName)
                    .platform(t.getPlatform() != null ? t.getPlatform().name() : "ANDROID")
                    .deviceName(t.getDeviceName() != null ? t.getDeviceName() : "Mobile Device")
                    .appVersion(t.getAppVersion() != null ? t.getAppVersion() : "1.0.0")
                    .lastSeen(t.getLastSeen() != null ? t.getLastSeen().toString() : null)
                    .lastSeenFormatted(lastSeenFmt)
                    .tokenMasked(masked)
                    .build();
        }).sorted((a, b) -> {
            if (a.getLastSeen() == null && b.getLastSeen() == null) return 0;
            if (a.getLastSeen() == null) return 1;
            if (b.getLastSeen() == null) return -1;
            return b.getLastSeen().compareTo(a.getLastSeen());
        }).collect(Collectors.toList());

        return ApiResponse.success(dtos, "Registered devices retrieved successfully");
    }

    @DeleteMapping("/devices/{id}")
    public ApiResponse<String> revokeDevice(@PathVariable Long id) {
        DeviceToken dt = deviceTokenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Device token not found with id: " + id));

        if (dt.getDeviceToken() != null && !dt.getDeviceToken().startsWith("SIMULATOR_") && !dt.getDeviceToken().startsWith("MOCK_")) {
            com.vnext.service.NotificationPayload payload = com.vnext.service.NotificationPayload.builder()
                    .title("Session Revoked")
                    .body("Your device token has been revoked by Administrator.")
                    .type(NotificationType.SYSTEM_ANNOUNCEMENT)
                    .screen("login")
                    .extra(Map.of("action", "FORCE_LOGOUT", "logout", "true"))
                    .build();
            pushNotificationService.sendToToken(dt.getDeviceToken(), payload);
        }

        deviceTokenRepository.delete(dt);
        log.info("SuperAdmin revoked device token ID: {} for user ID: {}", id, dt.getUserId());
        return ApiResponse.success("Device token revoked successfully");
    }

    @PostMapping("/devices/logout-all")
    public ApiResponse<Map<String, Object>> logoutAllDevices(jakarta.servlet.http.HttpServletRequest request) {
        // 1. Invalidate ALL existing JWT tokens globally
        jwtService.revokeAllTokens();
        log.warn("SYSTEM-WIDE LOGOUT: Global JWT revocation timestamp updated. All active mobile & web tokens are now invalidated.");

        // 2. Multicast FCM Force Logout push to all registered devices
        List<DeviceToken> allTokens = deviceTokenRepository.findAll();
        int totalDevices = allTokens.size();

        List<String> realTokens = allTokens.stream()
                .map(DeviceToken::getDeviceToken)
                .filter(t -> t != null && !t.isBlank() && !t.startsWith("MOCK_"))
                .distinct()
                .collect(Collectors.toList());

        if (!realTokens.isEmpty()) {
            com.vnext.service.NotificationPayload payload = com.vnext.service.NotificationPayload.builder()
                    .title("Session Terminated")
                    .body("A system-wide logout was executed by Super Admin. All sessions have ended.")
                    .type(NotificationType.SYSTEM_ANNOUNCEMENT)
                    .screen("login")
                    .extra(Map.of("action", "FORCE_LOGOUT", "logout", "true"))
                    .build();

            pushNotificationService.sendMulticast(realTokens, payload);
            log.info("Dispatched system-wide force logout push to {} device tokens", realTokens.size());
        }

        // 3. Purge all device tokens from database
        deviceTokenRepository.deleteAll();
        log.warn("SYSTEM-WIDE LOGOUT: Purged all {} device tokens from database.", totalDevices);

        // 4. Invalidate SuperAdmin web session immediately
        if (request != null && request.getSession(false) != null) {
            request.getSession(false).invalidate();
        }
        org.springframework.security.core.context.SecurityContextHolder.clearContext();

        return ApiResponse.success(
                Map.of("revokedCount", totalDevices, "multicastCount", realTokens.size()),
                "System-wide logout completed successfully! All " + totalDevices + " device tokens have been revoked and all sessions logged out."
        );
    }

    private String formatTimeAgo(java.time.LocalDateTime dt, java.time.LocalDateTime now) {
        if (dt == null) return "Just now";
        long seconds = java.time.Duration.between(dt, now).getSeconds();
        if (seconds < 60) return seconds + "s ago";
        if (seconds < 3600) return (seconds / 60) + "m ago";
        if (seconds < 86400) return (seconds / 3600) + "h ago";
        return (seconds / 86400) + "d ago";
    }

    private NotificationScheduleConfigDTO mapToScheduleDTO(NotificationScheduleConfig entity) {
        java.time.ZoneId istZone = java.time.ZoneId.of("Asia/Kolkata");
        java.time.LocalDate today = java.time.LocalDate.now(istZone);
        java.time.LocalDateTime dayStart = today.atTime(entity.getStartHour() != null ? entity.getStartHour() : 8, 0);

        int sentCount = entity.getSentTodayCount() != null ? entity.getSentTodayCount() : 0;
        if (!today.equals(entity.getLastSentDate()) || (entity.getLastSentAt() != null && entity.getLastSentAt().isBefore(dayStart))) {
            sentCount = 0;
        }

        NotificationScheduleConfigDTO dto = new NotificationScheduleConfigDTO();
        dto.setNotificationType(entity.getNotificationType());
        dto.setEnabled(entity.getEnabled());
        dto.setTimesPerDay(entity.getTimesPerDay());
        dto.setStartHour(entity.getStartHour());
        dto.setEndHour(entity.getEndHour());
        dto.setLastSentAt(entity.getLastSentAt() != null ? entity.getLastSentAt().toString() : null);
        dto.setSentTodayCount(sentCount);
        return dto;
    }
}