package com.vnext.repository;

import com.vnext.entity.UserPushNotification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserPushNotificationRepository extends JpaRepository<UserPushNotification, Long> {

    @Query("SELECT p FROM UserPushNotification p WHERE p.userId = :userId AND p.id > :afterId AND p.deleted = false ORDER BY p.id ASC")
    List<UserPushNotification> findPendingForUser(@Param("userId") Long userId, @Param("afterId") Long afterId);

    void deleteByUserId(Long userId);
}
