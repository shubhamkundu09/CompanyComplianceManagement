package com.vnext.repository;

import com.vnext.entity.UserPushNotification;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface UserPushNotificationRepository extends JpaRepository<UserPushNotification, Long> {

    @Query("SELECT p FROM UserPushNotification p WHERE p.userId = :userId AND p.id > :afterId AND p.createdAt >= :cutoffTime AND p.deleted = false ORDER BY p.id ASC")
    List<UserPushNotification> findRecentPendingForUser(
            @Param("userId") Long userId,
            @Param("afterId") Long afterId,
            @Param("cutoffTime") LocalDateTime cutoffTime,
            Pageable pageable);

    @Query("SELECT p FROM UserPushNotification p WHERE p.userId = :userId AND p.id > :afterId AND p.deleted = false ORDER BY p.id ASC")
    List<UserPushNotification> findPendingForUser(@Param("userId") Long userId, @Param("afterId") Long afterId);

    @Modifying
    @Transactional
    @Query("DELETE FROM UserPushNotification p WHERE p.createdAt < :cutoffTime")
    void deleteOlderThan(@Param("cutoffTime") LocalDateTime cutoffTime);

    void deleteByUserId(Long userId);
}

