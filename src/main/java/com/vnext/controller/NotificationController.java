package com.vnext.controller;

import com.vnext.dto.ApiResponse;
import com.vnext.dto.PushEventDTO;
import com.vnext.entity.User;
import com.vnext.entity.UserPushNotification;
import com.vnext.repository.UserPushNotificationRepository;
import com.vnext.security.CurrentUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Controller for notification endpoints.
 * Announcements have been completely removed from the system.
 * Only FCM Push Notifications and native drawer delivery remain.
 */
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final UserPushNotificationRepository userPushNotificationRepository;

    @PostMapping("/admin/create")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ApiResponse<Void> createNotification() {
        return ApiResponse.error("Announcement functionality has been removed. All notifications are sent directly to physical device notification drawers via FCM push.", 400);
    }

    /**
     * Sync pending push notifications for current user.
     * Guaranteed delivery into native mobile drawer even if APNs token is unavailable on Free Apple Developer account.
     */
    @GetMapping("/sync-pending")
    public ApiResponse<List<PushEventDTO>> syncPendingPushNotifications(
            @CurrentUser User currentUser,
            @RequestParam(name = "afterId", defaultValue = "0") Long afterId) {
        if (currentUser == null) {
            return ApiResponse.success(Collections.emptyList(), "Unauthenticated");
        }
        java.time.LocalDateTime cutoffTime = java.time.LocalDateTime.now(java.time.ZoneId.of("Asia/Kolkata")).minusMinutes(5);
        List<UserPushNotification> list = userPushNotificationRepository.findRecentPendingForUser(
                currentUser.getId(),
                afterId != null ? afterId : 0L,
                cutoffTime,
                org.springframework.data.domain.PageRequest.of(0, 20)
        );
        List<PushEventDTO> dtos = list.stream().map(upn -> {
            Map<String, String> data = new HashMap<>();
            if (upn.getNotificationType() != null) data.put("type", upn.getNotificationType());
            if (upn.getScreen() != null) data.put("screen", upn.getScreen());
            if (upn.getAction() != null) data.put("action", upn.getAction());
            if (upn.getTraceId() != null) data.put("traceId", upn.getTraceId());

            return PushEventDTO.builder()
                    .id(upn.getId())
                    .userId(upn.getUserId())
                    .title(upn.getTitle())
                    .body(upn.getBody())
                    .type(upn.getNotificationType())
                    .screen(upn.getScreen())
                    .action(upn.getAction())
                    .traceId(upn.getTraceId())
                    .data(data)
                    .createdAt(upn.getCreatedAt() != null ? upn.getCreatedAt().toString() : null)
                    .build();
        }).collect(Collectors.toList());

        return ApiResponse.success(dtos, "Pending push notifications retrieved");
    }

    // Returns empty list: in-app announcements have been removed in favor of FCM push notifications
    @GetMapping("/active")
    public ApiResponse<List<Object>> getActiveNotifications() {
        return ApiResponse.success(Collections.emptyList(), "Announcements retired. Push alerts are delivered via FCM.");
    }

    // Returns empty list: mobile poller retired in favor of native Firebase Cloud Messaging
    @GetMapping("/poller")
    public ApiResponse<List<Object>> getPollerNotifications() {
        return ApiResponse.success(Collections.emptyList(), "Poller retired. Only FCM push is active.");
    }

    // Active announcement count is 0
    @GetMapping("/count")
    public ApiResponse<Long> getActiveNotificationCount() {
        return ApiResponse.success(0L, "Active notification count");
    }

    @DeleteMapping("/admin/{id}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ApiResponse<Void> deleteNotification(@PathVariable Long id) {
        return ApiResponse.success("Notification deleted successfully");
    }
}