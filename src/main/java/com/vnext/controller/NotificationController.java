package com.vnext.controller;

import com.vnext.dto.ApiResponse;
import com.vnext.entity.Notification;
import com.vnext.entity.NotificationType;
import com.vnext.entity.User;
import com.vnext.security.CurrentUser;
import com.vnext.service.NotificationEventService;
import com.vnext.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationEventService notificationEventService;

    @PostMapping("/admin/create")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ApiResponse<Notification> createNotification(
            @RequestParam String title,
            @RequestParam String message,
            @CurrentUser User admin) {

        // Save the announcement
        Notification notification = notificationService.createNotification(title, message, admin.getId());

        // Send push AND save to all admins (SuperAdmin + CompanyAdmin)
        notificationEventService.notifyAllAdminsWithSave(
                "System Announcement",
                message,
                NotificationType.SYSTEM_ANNOUNCEMENT,
                "notifications"
        );

        return ApiResponse.success(notification, "Notification created successfully");
    }

    // Get active notifications (only those stored in DB)
    @GetMapping("/active")
    public ApiResponse<List<Notification>> getActiveNotifications(@CurrentUser User user) {
        var role = user != null ? user.getRole() : null;
        List<Notification> notifications = notificationService.getActiveNotificationsForRole(role);
        return ApiResponse.success(notifications, "Active notifications retrieved");
    }

    @GetMapping("/poller")
    public ApiResponse<List<Notification>> getPollerNotifications(@CurrentUser User user) {
        var role = user != null ? user.getRole() : null;
        List<Notification> notifications = notificationService.getActiveNotificationsForRole(role);
        return ApiResponse.success(notifications, "Poller notifications retrieved");
    }

    @GetMapping("/count")
    public ApiResponse<Long> getActiveNotificationCount() {
        long count = notificationService.getActiveNotificationCount();
        return ApiResponse.success(count, "Active notification count retrieved");
    }

    @DeleteMapping("/admin/{id}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ApiResponse<Void> deleteNotification(@PathVariable Long id) {
        notificationService.deleteNotification(id);
        return ApiResponse.success("Notification deleted successfully");
    }
}