package com.vnext.controller;

import com.vnext.dto.*;
import com.vnext.entity.*;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.CompanyComplianceRepository;
import com.vnext.repository.ComplianceConfigRepository;
import com.vnext.repository.ComplianceSubTemplateRepository;
import com.vnext.repository.ComplianceTemplateRepository;
import com.vnext.repository.EmployeeAssignmentRepository;
import com.vnext.repository.UserRepository;
import com.vnext.security.CurrentUser;
import com.vnext.service.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/company-admin")
@PreAuthorize("hasRole('COMPANY_ADMIN')")
@RequiredArgsConstructor
@Slf4j
public class CompanyAdminController {

    private final CompanyService companyService;
    private final EmployeeService employeeService;
    private final ComplianceService complianceService;
    private final AssignmentService assignmentService;
    private final PasswordService passwordService;
    private final DocumentStorageService documentStorageService;
    private final ComplianceTemplateRepository templateRepository;
    private final ComplianceSubTemplateRepository subTemplateRepository;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final ComplianceConfigRepository configRepository;
    private final EmployeeAssignmentRepository assignmentRepository;
    private final UserRepository userRepository;

    // ==================== COMPANY DETAILS ====================

    @GetMapping("/company")
    public ApiResponse<CompanyResponseDTO> getCompany(@CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        CompanyResponseDTO company = companyService.getCompanyById(companyId);
        return ApiResponse.success(company, "Company retrieved successfully");
    }

    // ==================== EMPLOYEE MANAGEMENT ====================

    @PostMapping("/employees")
    public ApiResponse<EmployeeResponseDTO> createEmployee(
            @CurrentUser User admin,
            @Valid @RequestBody EmployeeDTO employeeDTO) {
        Long companyId = admin.getCompany().getId();
        EmployeeResponseDTO employee = employeeService.createEmployee(companyId, employeeDTO);
        return ApiResponse.success(employee, "Employee created successfully");
    }

    @GetMapping("/employees")
    public ApiResponse<Page<EmployeeResponseDTO>> getEmployees(
            @CurrentUser User admin,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestParam(required = false) String search) {

        Long companyId = admin.getCompany().getId();
        Sort sort = sortDir.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<EmployeeResponseDTO> employees = employeeService.getEmployeesByCompany(companyId, search, pageable);
        return ApiResponse.success(employees, "Employees retrieved successfully");
    }

    @GetMapping("/employees/{employeeId}")
    public ApiResponse<EmployeeResponseDTO> getEmployeeById(@PathVariable Long employeeId) {
        EmployeeResponseDTO employee = employeeService.getEmployeeById(employeeId);
        return ApiResponse.success(employee, "Employee retrieved successfully");
    }

    @PutMapping("/employees/{employeeId}")
    public ApiResponse<EmployeeResponseDTO> updateEmployee(
            @PathVariable Long employeeId,
            @Valid @RequestBody EmployeeDTO employeeDTO) {
        EmployeeResponseDTO employee = employeeService.updateEmployee(employeeId, employeeDTO);
        return ApiResponse.success(employee, "Employee updated successfully");
    }

    @PatchMapping("/employees/{employeeId}/status")
    public ApiResponse<EmployeeResponseDTO> updateEmployeeStatus(
            @PathVariable Long employeeId,
            @RequestParam UserStatus status) {
        EmployeeResponseDTO employee = employeeService.updateEmployeeStatus(employeeId, status);
        return ApiResponse.success(employee, "Employee status updated successfully");
    }

    @DeleteMapping("/employees/{employeeId}")
    public ApiResponse<Void> deleteEmployee(@PathVariable Long employeeId) {
        employeeService.deleteEmployee(employeeId);
        return ApiResponse.success("Employee deleted successfully");
    }

    @PostMapping("/employees/{employeeId}/reset-password")
    public ApiResponse<Void> resetEmployeePassword(@PathVariable Long employeeId) {
        employeeService.resetEmployeePassword(employeeId);
        return ApiResponse.success("Password reset successfully. New credentials sent to email.");
    }

    // ==================== SUB-ADMIN MANAGEMENT ====================

    @PostMapping("/sub-admins")
    public ApiResponse<EmployeeResponseDTO> createSubAdmin(
            @CurrentUser User admin,
            @Valid @RequestBody EmployeeDTO employeeDTO) {
        Long companyId = admin.getCompany().getId();
        EmployeeResponseDTO subAdmin = employeeService.createSubAdmin(companyId, employeeDTO);
        return ApiResponse.success(subAdmin, "Sub-admin created successfully");
    }

    @GetMapping("/sub-admins")
    public ApiResponse<Page<EmployeeResponseDTO>> getSubAdmins(
            @CurrentUser User admin,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long companyId = admin.getCompany().getId();
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<EmployeeResponseDTO> subAdmins = employeeService.getSubAdminsByCompany(companyId, pageable);
        return ApiResponse.success(subAdmins, "Sub-admins retrieved successfully");
    }

    // ==================== COMPLIANCE ASSIGNMENT (Company View) ====================

    @GetMapping("/compliance/assigned")
    public ApiResponse<List<ComplianceConfigDTO>> getAssignedCompliances(@CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        Company company = companyService.getCompanyEntityById(companyId);
        String companyName = company.getName();

        // Get all company compliances (active and not deleted)
        List<CompanyCompliance> allCompliances = companyComplianceRepository
                .findByCompanyIdAndIsActiveTrueAndDeletedFalse(companyId);

        // Separate parent and sub-compliances
        List<CompanyCompliance> subCompliances = new ArrayList<>();
        List<CompanyCompliance> parentCompliances = new ArrayList<>();
        for (CompanyCompliance cc : allCompliances) {
            if (cc.isParent()) {
                parentCompliances.add(cc);
            } else {
                subCompliances.add(cc);
            }
        }

        // Map: templateId -> hasSubCompliances (for this company)
        Map<Long, Boolean> templateHasSubs = new HashMap<>();
        for (CompanyCompliance parent : parentCompliances) {
            Long templateId = parent.getTemplate().getId();
            boolean hasSubs = subCompliances.stream()
                    .anyMatch(s -> s.getParentTemplateId() != null && s.getParentTemplateId().equals(templateId));
            templateHasSubs.put(templateId, hasSubs);
        }

        List<ComplianceConfigDTO> configs = new ArrayList<>();

        // 1. SUB-COMPLIANCES (these are already company-specific)
        for (CompanyCompliance sub : subCompliances) {
            ComplianceConfigDTO dto = buildBaseDTO(sub, companyId, companyName);
            Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(sub.getId());
            if (configOpt.isPresent()) {
                fillConfigDTO(dto, configOpt.get());
                dto.setConfigured(true);

                Optional<EmployeeAssignment> completedAssignment = assignmentRepository
                        .findByConfigIdAndIsActiveTrue(configOpt.get().getId())
                        .stream().filter(a -> a.getCompletedAt() != null).findFirst();

                if (completedAssignment.isPresent()) {
                    EmployeeAssignment assign = completedAssignment.get();
                    dto.setStatus(ComplianceStatus.COMPLETED);
                    dto.setCompletedAt(assign.getCompletedAt());
                    dto.setSubmissionReference(assign.getSubmissionReference());
                    dto.setSubmissionDocumentUrl(assign.getSubmissionDocumentUrl());

                    if (assign.getCompletedBy() != null) {
                        userRepository.findById(assign.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                    } else if (assign.getEmployeeId() != null) {
                        userRepository.findById(assign.getEmployeeId()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                    }

                    if (sub.getStatus() != ComplianceStatus.COMPLETED) {
                        sub.setStatus(ComplianceStatus.COMPLETED);
                        sub.setCompletedAt(assign.getCompletedAt());
                        if (assign.getCompletedBy() != null) {
                            sub.setCompletedBy(assign.getCompletedBy());
                        }
                        companyComplianceRepository.save(sub);
                    }
                } else if (sub.getStatus() == ComplianceStatus.COMPLETED || sub.getCompletedAt() != null) {
                    dto.setStatus(ComplianceStatus.COMPLETED);
                    dto.setCompletedAt(sub.getCompletedAt());
                    dto.setSubmissionReference(sub.getAdminSubmissionReference());
                    dto.setSubmissionDocumentUrl(sub.getAdminSubmissionDocumentUrl());
                    if (sub.getCompletedBy() != null) {
                        userRepository.findById(sub.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                    }
                }
            } else {
                dto.setConfigured(false);
                if (sub.getStatus() == ComplianceStatus.COMPLETED || sub.getCompletedAt() != null) {
                    dto.setStatus(ComplianceStatus.COMPLETED);
                    dto.setCompletedAt(sub.getCompletedAt());
                    dto.setSubmissionReference(sub.getAdminSubmissionReference());
                    dto.setSubmissionDocumentUrl(sub.getAdminSubmissionDocumentUrl());
                    if (sub.getCompletedBy() != null) {
                        userRepository.findById(sub.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                    }
                }
            }
            configs.add(dto);
        }

        // 2. STANDALONE PARENT COMPLIANCES (no sub-compliances for this company)
        for (CompanyCompliance parent : parentCompliances) {
            Long templateId = parent.getTemplate().getId();
            if (!templateHasSubs.getOrDefault(templateId, false)) {
                ComplianceConfigDTO dto = buildBaseDTO(parent, companyId, companyName);
                dto.setSubTemplateId(null);
                dto.setSubTemplateName(null);
                Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(parent.getId());
                if (configOpt.isPresent()) {
                    fillConfigDTO(dto, configOpt.get());
                    dto.setConfigured(true);

                    Optional<EmployeeAssignment> completedAssignment = assignmentRepository
                            .findByConfigIdAndIsActiveTrue(configOpt.get().getId())
                            .stream().filter(a -> a.getCompletedAt() != null).findFirst();

                    if (completedAssignment.isPresent()) {
                        EmployeeAssignment assign = completedAssignment.get();
                        dto.setStatus(ComplianceStatus.COMPLETED);
                        dto.setCompletedAt(assign.getCompletedAt());
                        dto.setSubmissionReference(assign.getSubmissionReference());
                        dto.setSubmissionDocumentUrl(assign.getSubmissionDocumentUrl());

                        if (assign.getCompletedBy() != null) {
                            userRepository.findById(assign.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                        } else if (assign.getEmployeeId() != null) {
                            userRepository.findById(assign.getEmployeeId()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                        }

                        if (parent.getStatus() != ComplianceStatus.COMPLETED) {
                            parent.setStatus(ComplianceStatus.COMPLETED);
                            parent.setCompletedAt(assign.getCompletedAt());
                            if (assign.getCompletedBy() != null) {
                                parent.setCompletedBy(assign.getCompletedBy());
                            }
                            companyComplianceRepository.save(parent);
                        }
                    } else if (parent.getStatus() == ComplianceStatus.COMPLETED || parent.getCompletedAt() != null) {
                        dto.setStatus(ComplianceStatus.COMPLETED);
                        dto.setCompletedAt(parent.getCompletedAt());
                        dto.setSubmissionReference(parent.getAdminSubmissionReference());
                        dto.setSubmissionDocumentUrl(parent.getAdminSubmissionDocumentUrl());
                        if (parent.getCompletedBy() != null) {
                            userRepository.findById(parent.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                        }
                    }
                } else {
                    dto.setConfigured(false);
                    if (parent.getStatus() == ComplianceStatus.COMPLETED || parent.getCompletedAt() != null) {
                        dto.setStatus(ComplianceStatus.COMPLETED);
                        dto.setCompletedAt(parent.getCompletedAt());
                        dto.setSubmissionReference(parent.getAdminSubmissionReference());
                        dto.setSubmissionDocumentUrl(parent.getAdminSubmissionDocumentUrl());
                        if (parent.getCompletedBy() != null) {
                            userRepository.findById(parent.getCompletedBy()).ifPresent(u -> dto.setCompletedByName(u.getFullName()));
                        }
                    }
                }
                configs.add(dto);
            }
        }

        // NOTE: The "Custom Templates" section (section 3) is removed because
        // company admin can no longer create parent custom templates.
        // Existing custom templates (isCompanySpecific=true) are now treated as
        // editable, and they will appear as parent compliances in section 2.

        // Sort by priority
        configs.sort((a, b) -> {
            int priorityA = a.getPriority() != null ? a.getPriority() : 0;
            int priorityB = b.getPriority() != null ? b.getPriority() : 0;
            if (priorityA != priorityB) {
                return Integer.compare(priorityA, priorityB);
            }
            return a.getTemplateName().compareToIgnoreCase(b.getTemplateName());
        });

        return ApiResponse.success(configs, "Assigned compliances retrieved successfully");
    }

    @GetMapping("/compliance/parents")
    public ApiResponse<List<ParentComplianceDetailsDTO>> getCompanyParentCompliances(@CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        List<CompanyCompliance> allCCs = companyComplianceRepository
                .findByCompanyIdAndIsActiveTrueAndDeletedFalse(companyId);

        // Group by template ID while preserving order
        Map<Long, ComplianceTemplate> templateMap = new LinkedHashMap<>();
        Map<Long, CompanyCompliance> parentCCMap = new LinkedHashMap<>();

        for (CompanyCompliance cc : allCCs) {
            if (cc.getTemplate() != null && Boolean.TRUE.equals(cc.getTemplate().getIsActive()) && !cc.getTemplate().isDeleted()) {
                Long tId = cc.getTemplate().getId();
                templateMap.putIfAbsent(tId, cc.getTemplate());
                if (cc.isParent() || cc.getSubTemplate() == null) {
                    parentCCMap.putIfAbsent(tId, cc);
                }
            }
        }

        List<ParentComplianceDetailsDTO> dtos = new ArrayList<>();
        for (Map.Entry<Long, ComplianceTemplate> entry : templateMap.entrySet()) {
            Long tId = entry.getKey();
            ComplianceTemplate template = entry.getValue();

            CompanyCompliance cc = parentCCMap.get(tId);
            if (cc == null) {
                // Ensure parent CompanyCompliance exists for this company
                cc = companyComplianceRepository
                        .findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, tId)
                        .orElse(null);
                if (cc == null) {
                    cc = new CompanyCompliance();
                    cc.setCompany(admin.getCompany());
                    cc.setTemplate(template);
                    cc.setIsParent(true);
                    cc.setIsActive(true);
                    cc.setStatus(ComplianceStatus.IN_PROGRESS);
                    cc.setIsSuperAdminConfig(true);
                    cc.setAdminNotes("Auto-created parent category");
                    cc = companyComplianceRepository.save(cc);
                }
            }

            ParentComplianceDetailsDTO dto = new ParentComplianceDetailsDTO();
            dto.setId(cc.getId());
            dto.setTemplateId(template.getId());
            dto.setTemplateName(template.getName());
            dto.setTemplateDescription(template.getDescription());
            dto.setIsSuperAdminConfig(cc.getIsSuperAdminConfig());
            dto.setIsActive(cc.getIsActive());

            // Sub-compliances for this company & parent template
            List<CompanyCompliance> subCCs = companyComplianceRepository
                    .findSubCompliancesByCompanyIdAndParentTemplateId(companyId, tId);

            if (subCCs != null && !subCCs.isEmpty()) {
                boolean allCompleted = subCCs.stream().allMatch(sub -> {
                    if (sub.getStatus() == ComplianceStatus.COMPLETED) return true;
                    Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(sub.getId());
                    if (configOpt.isPresent()) {
                        return assignmentRepository.findByConfigIdAndIsActiveTrue(configOpt.get().getId())
                                .stream().anyMatch(a -> a.getCompletedAt() != null);
                    }
                    return false;
                });
                if (allCompleted) {
                    cc.setStatus(ComplianceStatus.COMPLETED);
                    companyComplianceRepository.save(cc);
                }
            } else {
                Optional<ComplianceConfig> configOpt = configRepository.findByCompanyComplianceId(cc.getId());
                if (configOpt.isPresent()) {
                    boolean isDone = assignmentRepository.findByConfigIdAndIsActiveTrue(configOpt.get().getId())
                            .stream().anyMatch(a -> a.getCompletedAt() != null);
                    if (isDone) {
                        cc.setStatus(ComplianceStatus.COMPLETED);
                        companyComplianceRepository.save(cc);
                    }
                }
            }

            dto.setStatus(cc.getStatus());
            dto.setAssignedAt(cc.getCreatedAt());
            dto.setTotalSubCompliances(subCCs != null ? subCCs.size() : 0);

            Boolean editable = template.getEditableForCompanies();
            dto.setCanManage(editable != null && editable);
            dto.setIsCompanySpecific(template.getIsCompanySpecific());
            dto.setCompanyId(companyId);

            dtos.add(dto);
        }

        return ApiResponse.success(dtos, "Parent compliances retrieved successfully");
    }

    // ==================== DELETE CUSTOM COMPLIANCE (for existing custom templates) ====================

    @DeleteMapping("/compliance/custom/templates/{templateId}")
    public ApiResponse<Void> deleteCustomCompliance(
            @PathVariable Long templateId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.deleteCustomTemplateForCompany(templateId, companyId, admin.getId());
        return ApiResponse.success("Custom compliance deleted successfully");
    }

    @GetMapping("/compliance/custom/templates")
    public ApiResponse<List<ComplianceTemplateDTO>> getCustomTemplatesFallback() {
        return ApiResponse.success(new ArrayList<>(), "Custom templates retrieved");
    }

    // ==================== SUB-COMPLIANCE MANAGEMENT (Company Admin) ====================

    /**
     * Add a sub‑compliance to an editable compliance parent.
     * This endpoint is for company admins to add their own sub‑compliances under editable categories.
     */
    @PostMapping("/compliance/editable/{parentId}/sub-templates")
    public ApiResponse<ComplianceSubTemplateDTO> addCompanySubCompliance(
            @PathVariable Long parentId,
            @Valid @RequestBody ComplianceSubTemplateDTO dto,
            @CurrentUser User admin) {
        log.info("Company Admin adding sub‑compliance to editable parent: {}", parentId);
        Long companyId = admin.getCompany().getId();
        ComplianceSubTemplateDTO created = complianceService.createCompanySubTemplate(parentId, companyId, dto, admin.getId());
        return ApiResponse.success(created, "Sub‑compliance added successfully");
    }

    // Legacy endpoint: keep for backward compatibility, delegates to new method.
    @PostMapping("/compliance/custom/{parentId}/sub-templates")
    public ApiResponse<ComplianceSubTemplateDTO> addCustomSubCompliance(
            @PathVariable Long parentId,
            @Valid @RequestBody ComplianceSubTemplateDTO dto,
            @CurrentUser User admin) {
        log.info("Company Admin adding sub‑compliance via legacy endpoint for parent: {}", parentId);
        return addCompanySubCompliance(parentId, dto, admin);
    }

    // Remove the template-based custom sub-template endpoint; no longer needed.
    // @PostMapping("/compliance/custom/template/{templateId}/sub-templates") - REMOVED

    // ==================== REMOVED CUSTOM COMPLIANCE CREATION ====================
    // The following endpoints are removed:
    // - POST /compliance/custom/templates
    // - GET /compliance/custom/templates
    // - POST /compliance/custom/config
    // - POST /compliance/custom/sub-config
    // - POST /compliance/custom/{parentId}/configure
    // - POST /compliance/custom/template/{templateId}/configure

    // ==================== COMPLIANCE CONFIGURATION ====================

    @GetMapping("/compliance/configurations/{configId}")
    public ApiResponse<ComplianceConfigDTO> getComplianceConfig(@PathVariable Long configId) {
        return ApiResponse.error("Endpoint not fully implemented", 404);
    }

    @PutMapping("/compliance/configurations/{configId}")
    public ApiResponse<ComplianceConfigDTO> updateComplianceConfig(
            @PathVariable Long configId,
            @Valid @RequestBody ComplianceConfigDTO dto,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ComplianceConfigDTO updated = complianceService.updateComplianceConfig(configId, companyId, dto, admin.getId());
        return ApiResponse.success(updated, "Configuration updated successfully");
    }

    // ==================== SUB-COMPLIANCE CONFIGURATION ====================

    @PostMapping("/compliance/sub-configure")
    public ApiResponse<ComplianceConfigDTO> configureSubCompliance(
            @Valid @RequestBody ComplianceConfigDTO dto,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        Long subTemplateId = dto.getSubTemplateId();
        if (subTemplateId == null) {
            return ApiResponse.error("Sub-template ID is required", 400);
        }
        // This service method handles both editable and non‑editable sub‑compliances.
        ComplianceConfigDTO config = complianceService.configureCustomSubCompliance(subTemplateId, companyId, dto, admin.getId());
        return ApiResponse.success(config, "Sub‑compliance configured successfully");
    }

    @PutMapping("/compliance/sub-configurations/{configId}")
    public ApiResponse<ComplianceConfigDTO> updateSubComplianceConfig(
            @PathVariable Long configId,
            @Valid @RequestBody ComplianceConfigDTO dto,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ComplianceConfigDTO updated = complianceService.updateComplianceConfig(configId, companyId, dto, admin.getId());
        return ApiResponse.success(updated, "Configuration updated successfully");
    }

    // ==================== SUB-COMPLIANCE LIST AND DETAILS ====================

    @GetMapping("/compliance/sub-templates")
    public ApiResponse<List<ComplianceSubTemplateDTO>> getSubCompliances(
            @RequestParam Long parentId,
            @CurrentUser User admin) {
        // For company admin, we want to show sub‑compliances specific to their company
        // if the parent is editable, otherwise global ones.
        Long companyId = admin.getCompany().getId();
        List<ComplianceSubTemplateDTO> subTemplates = complianceService.getCompanySubTemplates(parentId, companyId);
        return ApiResponse.success(subTemplates, "Sub‑compliances retrieved successfully");
    }

    @GetMapping("/compliance/sub-templates/{id}/config")
    public ApiResponse<ComplianceConfigDTO> getSubTemplateConfig(@PathVariable Long id) {
        ComplianceConfigDTO config = complianceService.getSubTemplateConfig(id);
        if (config == null) {
            return ApiResponse.success(null, "No configuration found for this sub-template");
        }
        return ApiResponse.success(config, "Sub-template configuration retrieved successfully");
    }

    @PutMapping("/compliance/sub-templates/{id}")
    public ApiResponse<ComplianceSubTemplateDTO> updateSubCompliance(
            @PathVariable Long id,
            @Valid @RequestBody ComplianceSubTemplateDTO dto,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ComplianceSubTemplateDTO updated = complianceService.updateCompanySubTemplate(id, companyId, dto, admin.getId());
        return ApiResponse.success(updated, "Sub-compliance updated successfully");
    }

    @DeleteMapping("/compliance/sub-templates/{id}")
    public ApiResponse<Void> deleteSubCompliance(
            @PathVariable Long id,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.deleteCompanySubTemplatePermanently(id, companyId);
        return ApiResponse.success("Sub-compliance deleted successfully");
    }

    // ==================== PARENT COMPLIANCE DETAILS ====================

    @GetMapping("/compliance/parents/{parentId}/progress")
    public ApiResponse<ParentComplianceDetailsDTO> getParentComplianceProgress(
            @PathVariable Long parentId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ParentComplianceDetailsDTO details = complianceService.getParentComplianceDetails(parentId, companyId);
        return ApiResponse.success(details, "Parent compliance progress retrieved successfully");
    }

    @GetMapping("/compliance/parent/{parentId}/details")
    public ApiResponse<ParentComplianceDetailsDTO> getParentComplianceDetails(
            @PathVariable Long parentId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ParentComplianceDetailsDTO details = complianceService.getParentComplianceDetails(parentId, companyId);
        return ApiResponse.success(details, "Parent compliance details retrieved successfully");
    }

    @GetMapping("/compliance/parents/{parentId}/sub-compliances")
    public ApiResponse<List<ParentComplianceDetailsDTO.SubComplianceInfoDTO>> getSubCompliancesByParent(
            @PathVariable Long parentId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        ParentComplianceDetailsDTO details = complianceService.getParentComplianceDetails(parentId, companyId);
        return ApiResponse.success(details.getSubCompliances(), "Sub-compliances retrieved successfully");
    }

    @PostMapping("/compliance/parents/{parentId}/assign-with-subs")
    public ApiResponse<Void> assignParentWithSubs(
            @PathVariable Long parentId,
            @RequestBody List<Long> employeeIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.assignParentWithSubCompliances(parentId, companyId, employeeIds, admin.getId());
        return ApiResponse.success("Compliance assigned to " + employeeIds.size() + " employees with all sub-compliances");
    }

    // ==================== SUB-COMPLIANCE DETAILS ====================

    @GetMapping("/compliance/sub-compliance/{subComplianceId}/details")
    public ApiResponse<SubComplianceDetailsDTO> getSubComplianceDetails(
            @PathVariable Long subComplianceId,
            @CurrentUser User admin) {
        SubComplianceDetailsDTO details = complianceService.getSubComplianceDetails(subComplianceId, admin.getCompany().getId());
        return ApiResponse.success(details, "Sub-compliance details retrieved successfully");
    }

    @GetMapping("/compliance/sub-compliance/{subComplianceId}/submission-history")
    public ApiResponse<List<SubmissionHistoryDTO>> getSubmissionHistory(
            @PathVariable Long subComplianceId,
            @CurrentUser User admin) {
        List<SubmissionHistoryDTO> history = complianceService.getSubmissionHistory(subComplianceId, admin.getCompany().getId());
        return ApiResponse.success(history, "Submission history retrieved successfully");
    }

    @GetMapping("/compliance/calendar")
    public ApiResponse<List<CalendarEventDTO>> getCalendarEvents(
            @CurrentUser User admin,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(required = false) Long employeeId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long categoryId) {

        Long companyId = admin.getCompany().getId();
        List<CalendarEventDTO> events = complianceService.getCalendarEvents(companyId, startDate, endDate, employeeId, status, categoryId);
        return ApiResponse.success(events, "Calendar events retrieved successfully");
    }

    @GetMapping("/compliance/configure")
    public String companyAdminComplianceConfigure(@RequestParam(required = false) Long id, Model model) {
        if (id == null) {
            return "redirect:/company-admin/compliance/list";
        }
        model.addAttribute("configId", id);
        return "companyadmin/compliance-configure";
    }

    // ==================== CHANGE PASSWORD ====================

    @PutMapping("/change-password")
    public ApiResponse<ChangePasswordResponse> changePassword(
            @CurrentUser User admin,
            @Valid @RequestBody ChangePasswordRequest request) {
        ChangePasswordResponse response = passwordService.changePassword(request, admin.getId());
        return ApiResponse.success(response, "Password changed successfully");
    }

    @PostMapping("/compliance/{companyComplianceId}/mark-complete")
    public ApiResponse<Void> markSubComplianceComplete(
            @PathVariable Long companyComplianceId,
            @RequestParam(required = false) String submissionReference,
            @RequestParam(required = false) MultipartFile document,
            @CurrentUser User admin) throws IOException {

        log.info("Company Admin {} marking sub-compliance {} as complete", admin.getId(), companyComplianceId);

        String documentUrl = null;
        if (document != null && !document.isEmpty()) {
            documentUrl = documentStorageService.store(document, "compliance_submission");
        }

        assignmentService.markAsCompletedByAdmin(companyComplianceId, admin.getId(), submissionReference, documentUrl);
        return ApiResponse.success("Compliance marked as completed successfully");
    }

    @GetMapping("/compliance/templates")
    public ApiResponse<Page<ComplianceTemplateDTO>> getComplianceTemplates(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        return ApiResponse.success(new PageImpl<>(new ArrayList<>()), "Templates retrieved");
    }

    // ==================== COMPLIANCE ASSIGNMENT TO EMPLOYEES ====================

    @PostMapping("/compliance/assign")
    public ApiResponse<Void> assignCompliance(
            @RequestParam Long configId,
            @RequestBody List<Long> employeeIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.assignToEmployees(configId, employeeIds, companyId, admin.getId());
        return ApiResponse.success("Compliance assigned to " + employeeIds.size() + " employees");
    }

    @GetMapping("/employees/{employeeId}/assigned-parent-ids")
    public ApiResponse<Set<Long>> getAssignedParentComplianceIds(
            @PathVariable Long employeeId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        Set<Long> parentIds = complianceService.getAssignedParentComplianceIdsForEmployee(employeeId, companyId);
        return ApiResponse.success(parentIds, "Assigned parent compliance IDs retrieved successfully");
    }

    @PostMapping("/employees/{employeeId}/assign-parent-compliances")
    public ApiResponse<Void> assignParentCompliancesToEmployee(
            @PathVariable Long employeeId,
            @RequestBody List<Long> parentComplianceIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.syncParentCompliancesForEmployee(employeeId, parentComplianceIds, companyId, admin.getId());
        return ApiResponse.success("Compliance assignments updated successfully");
    }

    @DeleteMapping("/employees/{employeeId}/compliances/{complianceId}")
    public ApiResponse<Void> removeComplianceFromEmployee(
            @PathVariable Long employeeId,
            @PathVariable Long complianceId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.removeParentComplianceFromEmployee(complianceId, employeeId, companyId, admin.getId());
        return ApiResponse.success("Compliance removed from employee successfully");
    }

    @PostMapping("/compliance/assign-multiple-parents")
    public ApiResponse<Void> assignMultipleParentsToEmployees(
            @RequestParam List<Long> parentComplianceIds,
            @RequestBody List<Long> employeeIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.assignParentCompliancesToMultipleEmployees(parentComplianceIds, employeeIds, companyId, admin.getId());
        return ApiResponse.success("Assigned " + parentComplianceIds.size() + " compliances to " + employeeIds.size() + " employees");
    }

    @GetMapping("/compliance/parent/{parentId}/assigned-employee-ids")
    public ApiResponse<Set<Long>> getAssignedEmployeeIdsForParent(
            @PathVariable Long parentId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        Set<Long> empIds = complianceService.getAssignedEmployeeIdsForParentCompliance(parentId, companyId);
        return ApiResponse.success(empIds, "Assigned employee IDs retrieved successfully");
    }

    @PostMapping("/compliance/parent/{parentId}/assign-employees")
    public ApiResponse<Void> assignParentComplianceToEmployees(
            @PathVariable Long parentId,
            @RequestBody List<Long> employeeIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.assignParentWithSubCompliances(parentId, companyId, employeeIds, admin.getId());
        return ApiResponse.success("Parent compliance assigned to " + employeeIds.size() + " employees with all sub-compliances");
    }

    @PostMapping("/compliance/parent/{parentId}/sync-employees")
    public ApiResponse<Void> syncEmployeesForParent(
            @PathVariable Long parentId,
            @RequestBody List<Long> employeeIds,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.syncEmployeesForParentCompliance(parentId, employeeIds, companyId, admin.getId());
        return ApiResponse.success("Employee assignments updated successfully");
    }

    @DeleteMapping("/compliance/parent/{parentId}/employees/{employeeId}")
    public ApiResponse<Void> unassignEmployeeFromParent(
            @PathVariable Long parentId,
            @PathVariable Long employeeId,
            @CurrentUser User admin) {
        Long companyId = admin.getCompany().getId();
        complianceService.removeParentComplianceFromEmployee(parentId, employeeId, companyId, admin.getId());
        return ApiResponse.success("Employee removed from compliance successfully");
    }

    @GetMapping("/compliance/assignments")
    public ApiResponse<Page<EmployeeComplianceDTO>> getAssignments(
            @CurrentUser User admin,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long employeeId,
            @RequestParam(required = false) String status) {

        Long companyId = admin.getCompany().getId();
        Pageable pageable = PageRequest.of(page, size, Sort.by("dueDate").ascending());
        Page<EmployeeComplianceDTO> assignments = assignmentService.getCompanyAssignments(
                companyId, employeeId, status, pageable);
        return ApiResponse.success(assignments, "Assignments retrieved successfully");
    }

    // ==================== EMPLOYEE COMPLIANCES ====================

    @GetMapping("/compliance/employee/{employeeId}/compliances")
    public ApiResponse<Page<EmployeeComplianceDTO>> getEmployeeCompliances(
            @PathVariable Long employeeId,
            @CurrentUser User admin,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status) {

        Long companyId = admin.getCompany().getId();
        Pageable pageable = PageRequest.of(page, size, Sort.by("dueDate").ascending());

        EmployeeResponseDTO employee = employeeService.getEmployeeById(employeeId);
        if (!employee.getCompanyId().equals(companyId)) {
            return ApiResponse.error("Employee does not belong to your company", 403);
        }

        Page<EmployeeComplianceDTO> compliances = assignmentService.getEmployeeAssignments(
                employeeId, status, pageable);

        return ApiResponse.success(compliances, "Employee compliances retrieved successfully");
    }

    @GetMapping("/compliance/employee/{employeeId}")
    public ApiResponse<Page<EmployeeComplianceDTO>> getEmployeeAssignments(
            @PathVariable Long employeeId,
            @CurrentUser User admin,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("dueDate").ascending());
        Page<EmployeeComplianceDTO> assignments = assignmentService.getCompanyAssignments(
                admin.getCompany().getId(), employeeId, status, pageable);
        return ApiResponse.success(assignments, "Employee assignments retrieved successfully");
    }

    // ==================== HELPER METHODS ====================

    private ComplianceConfigDTO buildBaseDTO(CompanyCompliance cc, Long companyId, String companyName) {
        ComplianceConfigDTO dto = new ComplianceConfigDTO();
        dto.setCompanyComplianceId(cc.getId());
        dto.setId(cc.getId());
        dto.setTemplateId(cc.getTemplate().getId());
        dto.setTemplateName(cc.getTemplate().getName());
        dto.setPriority(cc.getTemplate().getPriority() != null ? cc.getTemplate().getPriority() : 0);

        if (cc.getSubTemplate() != null) {
            dto.setSubTemplateId(cc.getSubTemplate().getId());
            dto.setSubTemplateName(cc.getSubTemplate().getName());
        }
        dto.setCompanyId(companyId);
        dto.setCompanyName(companyName);
        dto.setStatus(cc.getStatus());
        dto.setIsSuperAdminConfig(cc.getIsSuperAdminConfig());
        dto.setIsActive(cc.getIsActive());

        Boolean editable = cc.getTemplate() != null && Boolean.TRUE.equals(cc.getTemplate().getEditableForCompanies());
        dto.setEditableForCompanies(editable);
        dto.setCanManage(editable);

        if (cc.getCreatedAt() != null) {
            dto.setCreatedAt(cc.getCreatedAt());
        } else if (cc.getTemplate() != null && cc.getTemplate().getCreatedAt() != null) {
            dto.setCreatedAt(cc.getTemplate().getCreatedAt());
        }

        return dto;
    }

    private void fillConfigDTO(ComplianceConfigDTO dto, ComplianceConfig config) {
        dto.setId(config.getId());
        dto.setFrequency(config.getFrequency());
        LocalDate effectiveDueDate = complianceService.calculateEffectiveDueDate(config);
        dto.setEffectiveDueDate(effectiveDueDate);
        dto.setDueDate(effectiveDueDate);
        dto.setReminderDaysBefore(config.getReminderDaysBefore());
        dto.setRepeatReminder(config.getRepeatReminder());
        dto.setReminderIntervalDays(config.getReminderIntervalDays());
        dto.setInstructions(config.getInstructions());
        dto.setDocumentRequired(config.getDocumentRequired());
        dto.setExternalLink(config.getExternalLink());
        dto.setCreatedAt(config.getCreatedAt());
    }

    private int getStatusOrder(ComplianceStatus status) {
        if (status == null) return 3;
        switch (status) {
            case COMPLETED:   return 0;
            case IN_PROGRESS: return 1;
            case PENDING:     return 2;
            case OVERDUE:     return 3;
            default:          return 3;
        }
    }

    private ComplianceConfigDTO convertToConfigDTO(ComplianceConfig config) {
        ComplianceConfigDTO dto = new ComplianceConfigDTO();
        dto.setId(config.getId());
        dto.setFrequency(config.getFrequency());
        dto.setDueDate(config.getDueDate());
        dto.setCustomDueDate(config.getCustomDueDate());
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
        dto.setIsSuperAdminConfig(config.getIsSuperAdminConfig());

        LocalDate effectiveDueDate = complianceService.calculateEffectiveDueDate(config);
        dto.setEffectiveDueDate(effectiveDueDate);
        if (effectiveDueDate != null) {
            dto.setDueDate(effectiveDueDate);
        }

        if (config.getCompanyCompliance() != null) {
            dto.setCompanyComplianceId(config.getCompanyCompliance().getId());
            dto.setCompanyId(config.getCompanyCompliance().getCompany().getId());
            dto.setCompanyName(config.getCompanyCompliance().getCompany().getName());
            dto.setStatus(config.getCompanyCompliance().getStatus());

            if (config.getCompanyCompliance().getTemplate() != null) {
                dto.setTemplateId(config.getCompanyCompliance().getTemplate().getId());
                dto.setTemplateName(config.getCompanyCompliance().getTemplate().getName());
            }
            if (config.getCompanyCompliance().getSubTemplate() != null) {
                dto.setSubTemplateId(config.getCompanyCompliance().getSubTemplate().getId());
                dto.setSubTemplateName(config.getCompanyCompliance().getSubTemplate().getName());
            }
        }

        return dto;
    }
}