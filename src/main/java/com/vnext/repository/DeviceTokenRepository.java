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

    long countByPlatform(com.vnext.entity.Platform platform);

    @Query("SELECT COUNT(DISTINCT dt.userId) FROM DeviceToken dt")
    long countDistinctUsers();

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
    @Query("DELETE FROM DeviceToken dt WHERE dt.deviceToken = :deviceToken AND dt.userId != :userId")
    void deleteByDeviceTokenAndUserIdNot(String deviceToken, Long userId);

    @Modifying
    @Transactional
    @Query("UPDATE DeviceToken dt SET dt.lastSeen = CURRENT_TIMESTAMP WHERE dt.deviceToken = :token")
    void updateLastSeen(String token);

    /**
     * Bulk-deletes ALL device tokens for a given user.
     * Must be called BEFORE deleting the User row to satisfy the FK constraint
     * device_tokens.user_id → users.id.
     */
    @Modifying
    @Transactional
    @Query("DELETE FROM DeviceToken dt WHERE dt.userId = :userId")
    void deleteAllByUserId(Long userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM DeviceToken dt WHERE dt.userId IN :userIds")
    void deleteAllByUserIdIn(@org.springframework.data.repository.query.Param("userIds") List<Long> userIds);
}