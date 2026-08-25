// src/main/java/com/vnext/repository/NotificationRepository.java
package com.vnext.repository;

import com.vnext.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    // === FOR WEB JSP (HEADER & NOTIFICATIONS PAGE - SUPERADMIN ANNOUNCEMENTS ONLY) ===
    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) AND (n.notificationType IN ('SYSTEM_ANNOUNCEMENT', 'ANNOUNCEMENT', 'GENERAL', 'IMPORTANT', 'URGENT', 'CUSTOM') OR n.createdBy IS NOT NULL) ORDER BY n.id DESC")
    List<Notification> findActiveAnnouncements(@Param("now") LocalDateTime now);

    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) AND (n.targetRole IS NULL OR n.targetRole = :role) AND (n.notificationType IN ('SYSTEM_ANNOUNCEMENT', 'ANNOUNCEMENT', 'GENERAL', 'IMPORTANT', 'URGENT', 'CUSTOM') OR n.createdBy IS NOT NULL) ORDER BY n.id DESC")
    List<Notification> findActiveAnnouncementsForRole(@Param("now") LocalDateTime now, @Param("role") String role);

    @Query("SELECT COUNT(n) FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) AND (n.notificationType IN ('SYSTEM_ANNOUNCEMENT', 'ANNOUNCEMENT', 'GENERAL', 'IMPORTANT', 'URGENT', 'CUSTOM') OR n.createdBy IS NOT NULL)")
    long countActiveAnnouncementNotifications(@Param("now") LocalDateTime now);

    // === FOR REAL-TIME MOBILE APP POLLER (ALL EVENT NOTIFICATIONS INCL. LOGINS, CREATION, CONFIGS) ===
    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) ORDER BY n.id DESC")
    List<Notification> findPollerNotifications(@Param("now") LocalDateTime now);

    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) AND (n.targetRole IS NULL OR n.targetRole = :role) ORDER BY n.id DESC")
    List<Notification> findPollerNotificationsForRole(@Param("now") LocalDateTime now, @Param("role") String role);
}