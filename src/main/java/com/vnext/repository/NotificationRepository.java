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

    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) ORDER BY n.id DESC")
    List<Notification> findActiveNotifications(@Param("now") LocalDateTime now);

    @Query("SELECT n FROM Notification n WHERE n.isActive = true AND (n.expiresAt IS NULL OR n.expiresAt > :now) AND (n.targetRole IS NULL OR n.targetRole = :role) ORDER BY n.id DESC")
    List<Notification> findActiveNotificationsForRole(@Param("now") LocalDateTime now, @Param("role") String role);

    long countByIsActiveTrueAndExpiresAtIsNullOrExpiresAtAfter(LocalDateTime now);
}