package com.vnext.repository;

import com.vnext.entity.DeviceToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface DeviceTokenRepository extends JpaRepository<DeviceToken, Long> {

    List<DeviceToken> findByUserId(Long userId);

    @Query("SELECT dt FROM DeviceToken dt WHERE dt.userId IN :userIds")
    List<DeviceToken> findByUserIdIn(List<Long> userIds);

    Optional<DeviceToken> findByUserIdAndDeviceToken(Long userId, String deviceToken);

    @Modifying
    @Transactional
    @Query("DELETE FROM DeviceToken dt WHERE dt.userId = :userId AND dt.deviceToken = :deviceToken")
    void deleteByUserIdAndDeviceToken(Long userId, String deviceToken);

    @Modifying
    @Transactional
    @Query("DELETE FROM DeviceToken dt WHERE dt.deviceToken IN :tokens")
    void deleteAllByDeviceTokenIn(List<String> tokens);

    @Modifying
    @Transactional
    @Query("DELETE FROM DeviceToken dt WHERE dt.deviceToken = :deviceToken")
    void deleteByDeviceToken(String deviceToken);

    @Modifying
    @Transactional
    @Query("UPDATE DeviceToken dt SET dt.lastSeen = CURRENT_TIMESTAMP WHERE dt.deviceToken = :token")
    void updateLastSeen(String token);
}