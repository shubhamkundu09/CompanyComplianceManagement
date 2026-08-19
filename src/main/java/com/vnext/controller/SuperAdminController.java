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
            @RequestParam CompanyStatus status) {
        CompanyResponseDTO company = companyService.updateCompanyStatus(companyId, status);
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
}