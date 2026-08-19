// src/main/java/com/vnext/service/NotificationService.java
package com.vnext.service;

import com.vnext.entity.Notification;
import com.vnext.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private final NotificationRepository notificationRepository;

    @Transactional
    public Notification createNotification(String title, String message, Long adminId) {
        Notification notification = new Notification();
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setIsActive(true);
        notification.setCreatedBy(adminId);
        notification.setNotificationType("SYSTEM_ANNOUNCEMENT");
        return notificationRepository.save(notification);
    }

    @Transactional(readOnly = true)
    public List<Notification> getActiveNotifications() {
        return notificationRepository.findActiveNotifications(LocalDateTime.now());
    }

    @Transactional(readOnly = true)
    public List<Notification> getActiveNotificationsForRole(com.vnext.entity.UserRole role) {
        if (role == null) {
            return notificationRepository.findActiveNotifications(LocalDateTime.now());
        }
        return notificationRepository.findActiveNotificationsForRole(LocalDateTime.now(), role.name());
    }

    @Transactional(readOnly = true)
    public long getActiveNotificationCount() {
        return notificationRepository.countActiveAnnouncementNotifications(LocalDateTime.now());
    }

    @Transactional
    public void deleteNotification(Long id) {
        notificationRepository.deleteById(id);
    }
}