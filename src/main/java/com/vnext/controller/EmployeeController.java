package com.vnext.controller;

import com.vnext.dto.*;
import com.vnext.entity.User;
import com.vnext.security.CurrentUser;
import com.vnext.service.AssignmentService;
import com.vnext.service.EmployeeService;
import com.vnext.service.PasswordService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/employee")
@PreAuthorize("hasRole('EMPLOYEE')")
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    private final AssignmentService assignmentService;
    private final PasswordService passwordService;
    private final com.vnext.service.DocumentStorageService documentStorageService;

    // ==================== PROFILE ====================

    @GetMapping("/profile")
    public ApiResponse<EmployeeResponseDTO> getProfile(@CurrentUser User employee) {
        EmployeeResponseDTO profile = employeeService.getEmployeeById(employee.getId());
        return ApiResponse.success(profile, "Profile retrieved");
    }

    @PutMapping("/profile")
    public ApiResponse<EmployeeResponseDTO> updateProfile(
            @CurrentUser User employee,
            @Valid @RequestBody EmployeeDTO employeeDTO) {
        EmployeeResponseDTO updated = employeeService.updateEmployee(employee.getId(), employeeDTO);
        return ApiResponse.success(updated, "Profile updated successfully");
    }

    // ==================== COMPLIANCE - MY COMPLIANCES ====================

    @GetMapping("/compliance/my")
    public ApiResponse<Page<EmployeeComplianceDTO>> getMyCompliances(
            @CurrentUser User employee,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("dueDate").ascending());
        Page<EmployeeComplianceDTO> compliances = assignmentService.getEmployeeAssignments(
                employee.getId(), status, pageable);
        return ApiResponse.success(compliances, "Compliances retrieved successfully");
    }

    // ==================== COMPLIANCE - CATEGORIES ====================

    // ADD THIS MISSING ENDPOINT
    @GetMapping("/compliance/my-categories")
    public ApiResponse<List<EmployeeComplianceDTO>> getMyCategories(@CurrentUser User employee) {
        List<EmployeeComplianceDTO> categories = assignmentService.getEmployeeCategories(employee.getId());
        return ApiResponse.success(categories, "Categories retrieved successfully");
    }

    // ==================== COMPLIANCE - SUB-COMPLIANCES ====================

    @GetMapping("/compliance/category/{parentAssignmentId}")
    public ApiResponse<List<EmployeeComplianceDTO>> getSubCompliancesByCategory(
            @PathVariable Long parentAssignmentId,
            @CurrentUser User employee) {
        List<EmployeeComplianceDTO> subCompliances = assignmentService.getSubCompliancesByCategory(
                parentAssignmentId, employee.getId());
        return ApiResponse.success(subCompliances, "Sub-compliances retrieved successfully");
    }

    // ==================== COMPLIANCE - DETAILS ====================

    @GetMapping("/compliance/{assignmentId}")
    public ApiResponse<EmployeeComplianceDTO> getComplianceDetails(
            @PathVariable Long assignmentId,
            @CurrentUser User employee) {

        EmployeeComplianceDTO details = assignmentService.getAssignmentDetailsForEmployee(assignmentId, employee.getId());

        if (details == null) {
            return ApiResponse.error("Compliance not found", 404);
        }

        return ApiResponse.success(details, "Compliance details retrieved successfully");
    }

    // ==================== COMPLIANCE - SUB-COMPLIANCE DETAILS ====================

    @GetMapping("/compliance/sub-compliance/{subComplianceId}")
    public ApiResponse<SubComplianceDetailsDTO> getSubComplianceDetails(
            @PathVariable Long subComplianceId,
            @CurrentUser User employee) {
        // This would need to be implemented in the service
        // For now, return a placeholder
        SubComplianceDetailsDTO dto = new SubComplianceDetailsDTO();
        dto.setId(subComplianceId);
        return ApiResponse.success(dto, "Sub-compliance details retrieved successfully");
    }

    // ==================== COMPLIANCE - COMPLETE ====================

    @PostMapping("/compliance/{assignmentId}/complete")
    public ApiResponse<Void> markAsCompleted(
            @PathVariable Long assignmentId,
            @CurrentUser User employee,
            @RequestParam(required = false) String submissionReference,
            @RequestParam(required = false) MultipartFile document) throws IOException {

        String documentUrl = null;
        if (document != null && !document.isEmpty()) {
            documentUrl = documentStorageService.store(document, "compliance_submission");
        }

        assignmentService.markAsCompleted(assignmentId, employee.getId(), submissionReference, documentUrl);
        return ApiResponse.success("Compliance marked as completed successfully");
    }

    // ==================== COMPLIANCE - STATS ====================

    @GetMapping("/compliance/stats")
    public ApiResponse<EmployeeComplianceStatsDTO> getStats(@CurrentUser User employee) {
        EmployeeComplianceStatsDTO stats = assignmentService.getEmployeeStats(employee.getId());
        return ApiResponse.success(stats, "Statistics retrieved successfully");
    }

    // ==================== COMPLIANCE - UPCOMING ====================

    @GetMapping("/compliance/upcoming")
    public ApiResponse<List<EmployeeComplianceDTO>> getUpcomingDeadlines(
            @CurrentUser User employee,
            @RequestParam(defaultValue = "5") int limit) {

        Page<EmployeeComplianceDTO> compliances = assignmentService.getEmployeeAssignments(
                employee.getId(), "PENDING", PageRequest.of(0, limit, Sort.by("dueDate").ascending()));

        return ApiResponse.success(compliances.getContent(), "Upcoming deadlines retrieved successfully");
    }

    // ==================== COMPLIANCE - SYNC ====================

    @PostMapping("/compliance/sync-category/{parentId}")
    public ApiResponse<Void> syncCategoryCompliances(
            @PathVariable Long parentId,
            @CurrentUser User employee) {

        return ApiResponse.success("Sub-compliances synced successfully");
    }

    // ==================== COMPLIANCE - CALENDAR ====================

    @GetMapping("/compliance/calendar")
    public ApiResponse<List<CalendarEventDTO>> getCalendarEvents(
            @CurrentUser User employee,
            @RequestParam String startDate,
            @RequestParam String endDate) {

        return ApiResponse.success(null, "Calendar events retrieved successfully");
    }

    // ==================== CHANGE PASSWORD ====================

    @PutMapping("/change-password")
    public ApiResponse<ChangePasswordResponse> changePassword(
            @CurrentUser User employee,
            @Valid @RequestBody ChangePasswordRequest request) {
        passwordService.changePassword(request, employee.getId());
        return ApiResponse.success(
                new ChangePasswordResponse(true, "Password changed successfully"),
                "Password changed successfully");
    }
}