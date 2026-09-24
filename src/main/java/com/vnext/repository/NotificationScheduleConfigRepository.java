package com.vnext.repository;

import com.vnext.entity.NotificationScheduleConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface NotificationScheduleConfigRepository extends JpaRepository<NotificationScheduleConfig, Long> {

    Optional<NotificationScheduleConfig> findByNotificationType(String notificationType);
}
