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
            @RequestParam(required = false, defaultValue = "GENERAL") String notificationType,
            @CurrentUser User admin) {

        // Save the announcement
        Notification notification = notificationService.createNotification(title, message, notificationType, admin.getId());

        // Send push notification to all admins (SuperAdmin + CompanyAdmin)
        notificationEventService.notifyAllAdminsPushOnly(
                title,
                message,
                NotificationType.SYSTEM_ANNOUNCEMENT,
                "notifications"
        );

        return ApiResponse.success(notification, "Notification created successfully");
    }

    // Get active announcements only (used by JSP header bell, dropdown, and notifications page)
    @GetMapping("/active")
    public ApiResponse<List<Notification>> getActiveNotifications(@CurrentUser User user) {
        var role = user != null ? user.getRole() : null;
        List<Notification> notifications = notificationService.getActiveAnnouncementsForRole(role);
        return ApiResponse.success(notifications, "Active notifications retrieved");
    }

    // Get all events for real-time mobile in-app poller
    @GetMapping("/poller")
    public ApiResponse<List<Notification>> getPollerNotifications(@CurrentUser User user) {
        var role = user != null ? user.getRole() : null;
        List<Notification> notifications = notificationService.getPollerNotificationsForRole(role);
        return ApiResponse.success(notifications, "Poller notifications retrieved");
    }

    // Get active announcement count for header badge
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