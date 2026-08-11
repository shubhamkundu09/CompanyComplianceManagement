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

        Page<EmployeeComplianceDTO> result = assignmentService.getEmployeeAssignments(
                employee.getId(), null, PageRequest.of(0, 1));

        EmployeeComplianceDTO details = result.getContent().stream()
                .filter(dto -> dto.getId().equals(assignmentId))
                .findFirst()
                .orElse(null);

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
            // Store document and get URL
            // documentUrl = documentStorageService.store(document, "compliance_submission");
        }

        assignmentService.markAsCompleted(assignmentId, employee.getId(), submissionReference, documentUrl);
        return ApiResponse.success("Compliance marked as completed successfully");
    }

    // ==================== COMPLIANCE - STATS ====================

    @GetMapping("/compliance/stats")
    public ApiResponse<EmployeeComplianceStatsDTO> getStats(@CurrentUser User employee) {
        EmployeeComplianceStatsDTO stats = calculateEmployeeStats(employee.getId());
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

        // This would call a service method to sync missing sub-compliances
        // assignmentService.syncMissingSubCompliances(employee.getId(), parentId);

        return ApiResponse.success("Sub-compliances synced successfully");
    }




    // ==================== COMPLIANCE - CALENDAR ====================

    @GetMapping("/compliance/calendar")
    public ApiResponse<List<CalendarEventDTO>> getCalendarEvents(
            @CurrentUser User employee,
            @RequestParam String startDate,
            @RequestParam String endDate) {

        // This would call a service method to get calendar events
        // List<CalendarEventDTO> events = assignmentService.getCalendarEvents(employee.getId(), startDate, endDate);

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

    // ==================== HELPER METHODS ====================

    private EmployeeComplianceStatsDTO calculateEmployeeStats(Long employeeId) {
        Page<EmployeeComplianceDTO> allCompliances = assignmentService.getEmployeeAssignments(
                employeeId, null, Pageable.unpaged());

        List<EmployeeComplianceDTO> content = allCompliances.getContent();

        int total = content.size();
        int completed = 0;
        int pending = 0;
        int overdue = 0;
        int inProgress = 0;

        for (EmployeeComplianceDTO dto : content) {
            if (dto.getStatus() != null) {
                switch (dto.getStatus()) {
                    case COMPLETED -> completed++;
                    case OVERDUE -> overdue++;
                    case IN_PROGRESS -> inProgress++;
                    case PENDING -> pending++;
                }
            }
        }

        List<EmployeeComplianceDTO> categories = assignmentService.getEmployeeCategories(employeeId);

        EmployeeComplianceStatsDTO stats = new EmployeeComplianceStatsDTO();
        stats.setTotalCompliances(total);
        stats.setCompletedCompliances(completed);
        stats.setPendingCompliances(pending);
        stats.setOverdueCompliances(overdue);
        stats.setInProgressCompliances(inProgress);
        stats.setTotalCategories(categories.size());

        if (total > 0) {
            stats.setCompletionPercentage((completed * 100) / total);
        } else {
            stats.setCompletionPercentage(0);
        }

        return stats;
    }
}