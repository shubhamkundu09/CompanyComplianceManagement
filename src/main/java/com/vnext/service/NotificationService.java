// src/main/java/com/vnext/service/NotificationService.java
package com.vnext.service;

import com.vnext.entity.Notification;
import com.vnext.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");

    private final NotificationRepository notificationRepository;

    @Transactional
    public Notification createNotification(String title, String message, Long adminId) {
        return createNotification(title, message, "SYSTEM_ANNOUNCEMENT", adminId);
    }

    @Transactional
    public Notification createNotification(String title, String message, String notificationType, Long adminId) {
        Notification notification = new Notification();
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setIsActive(true);
        notification.setCreatedBy(adminId);
        notification.setNotificationType(notificationType != null && !notificationType.trim().isEmpty() ? notificationType : "SYSTEM_ANNOUNCEMENT");
        return notificationRepository.save(notification);
    }

    // === FOR WEB JSP (HEADER & NOTIFICATIONS PAGE - ANNOUNCEMENTS ONLY) ===
    @Transactional(readOnly = true)
    public List<Notification> getActiveNotifications() {
        return notificationRepository.findActiveAnnouncements(LocalDateTime.now(IST_ZONE));
    }

    @Transactional(readOnly = true)
    public List<Notification> getActiveNotificationsForRole(com.vnext.entity.UserRole role) {
        if (role == null) {
            return notificationRepository.findActiveAnnouncements(LocalDateTime.now(IST_ZONE));
        }
        return notificationRepository.findActiveAnnouncementsForRole(LocalDateTime.now(IST_ZONE), role.name());
    }

    @Transactional(readOnly = true)
    public List<Notification> getActiveAnnouncementsForRole(com.vnext.entity.UserRole role) {
        if (role == null) {
            return notificationRepository.findActiveAnnouncements(LocalDateTime.now(IST_ZONE));
        }
        return notificationRepository.findActiveAnnouncementsForRole(LocalDateTime.now(IST_ZONE), role.name());
    }

    @Transactional(readOnly = true)
    public long getActiveNotificationCount() {
        return notificationRepository.countActiveAnnouncementNotifications(LocalDateTime.now(IST_ZONE));
    }

    @Transactional(readOnly = true)
    public long getActiveAnnouncementCount() {
        return notificationRepository.countActiveAnnouncementNotifications(LocalDateTime.now(IST_ZONE));
    }

    // === FOR MOBILE APP POLLER (ALL EVENT NOTIFICATIONS INCL. LOGINS, CREATION, CONFIGS) ===
    @Transactional(readOnly = true)
    public List<Notification> getPollerNotificationsForRole(com.vnext.entity.UserRole role) {
        if (role == null) {
            return notificationRepository.findPollerNotifications(LocalDateTime.now(IST_ZONE));
        }
        return notificationRepository.findPollerNotificationsForRole(LocalDateTime.now(IST_ZONE), role.name());
    }

    @Transactional
    public void deleteNotification(Long id) {
        notificationRepository.deleteById(id);
    }
}