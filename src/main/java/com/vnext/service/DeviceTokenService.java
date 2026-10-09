package com.vnext.service;

import com.vnext.entity.DeviceToken;
import com.vnext.entity.Platform;
import com.vnext.repository.DeviceTokenRepository;
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
public class DeviceTokenService {

    private static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");

    private final DeviceTokenRepository deviceTokenRepository;

    @Transactional
    public void registerDeviceToken(Long userId, String token, String platform, String deviceName, String appVersion) {
        if (token == null || token.trim().isEmpty() || userId == null) return;

        String cleanToken = token.trim();
        Platform p = Platform.ANDROID;
        try {
            if (platform != null) {
                p = Platform.valueOf(platform.toUpperCase());
            }
        } catch (Exception e) {
            p = Platform.ANDROID;
        }

        String targetDeviceName = (deviceName != null && !deviceName.trim().isEmpty())
                ? deviceName.trim()
                : (p == Platform.IOS ? "iPhone" : "Android Device");

        // 1. Dissociate this physical device token from any other users to prevent cross-account notifications
        deviceTokenRepository.deleteByDeviceTokenAndUserIdNot(cleanToken, userId);

        // 2. Check if this exact token is already registered for this user
        var existingExact = deviceTokenRepository.findByUserIdAndDeviceToken(userId, cleanToken);
        if (existingExact.isPresent()) {
            var device = existingExact.get();
            device.setPlatform(p);
            device.setDeviceName(targetDeviceName);
            if (appVersion != null && !appVersion.trim().isEmpty()) {
                device.setAppVersion(appVersion.trim());
            }
            device.setLastSeen(LocalDateTime.now(IST_ZONE));
            deviceTokenRepository.save(device);
            log.info("Updated existing device token for user {}: platform={}, device={}, token={}", userId, p, device.getDeviceName(), cleanToken);
            pruneStaleTokensForUser(userId);
            return;
        }

        // 3. Check if the user already has a device record on the same platform with the same device name (e.g., token rotation / app reinstall)
        var existingSameDevice = deviceTokenRepository.findFirstByUserIdAndPlatformAndDeviceName(userId, p, targetDeviceName);
        if (existingSameDevice.isPresent()) {
            var device = existingSameDevice.get();
            device.setDeviceToken(cleanToken);
            if (appVersion != null && !appVersion.trim().isEmpty()) {
                device.setAppVersion(appVersion.trim());
            }
            device.setLastSeen(LocalDateTime.now(IST_ZONE));
            deviceTokenRepository.save(device);
            log.info("Replaced rotated device token for user {} on {}: token={}", userId, targetDeviceName, cleanToken);
            pruneStaleTokensForUser(userId);
            return;
        }

        // 4. Register new distinct device
        var newDevice = new DeviceToken();
        newDevice.setUserId(userId);
        newDevice.setDeviceToken(cleanToken);
        newDevice.setPlatform(p);
        newDevice.setDeviceName(targetDeviceName);
        newDevice.setAppVersion(appVersion != null && !appVersion.trim().isEmpty() ? appVersion.trim() : "1.0.0");
        newDevice.setLastSeen(LocalDateTime.now(IST_ZONE));
        deviceTokenRepository.save(newDevice);
        log.info("Registered new device token for user {}: platform={}, device={}, token={}", userId, p, newDevice.getDeviceName(), cleanToken);

        // 5. Keep max 3 latest active devices per user to prevent accumulating stale/ghost tokens
        pruneStaleTokensForUser(userId);
    }

    private void pruneStaleTokensForUser(Long userId) {
        try {
            List<DeviceToken> userTokens = deviceTokenRepository.findByUserIdOrderByLastSeenDesc(userId);
            if (userTokens.size() > 3) {
                List<DeviceToken> stale = userTokens.subList(3, userTokens.size());
                for (DeviceToken dt : stale) {
                    deviceTokenRepository.delete(dt);
                    log.info("Pruned stale device token ID={} (last seen: {}) for user ID={}", dt.getId(), dt.getLastSeen(), userId);
                }
            }
        } catch (Exception e) {
            log.warn("Error pruning stale device tokens for user {}: {}", userId, e.getMessage());
        }
    }

    @Transactional
    public void removeDeviceToken(Long userId, String token) {
        if (userId != null) {
            deviceTokenRepository.deleteByUserIdAndDeviceToken(userId, token);
            log.info("Removed device token for user {}", userId);
        }
    }

    @Transactional
    public void removeInvalidTokens(List<String> invalidTokens) {
        if (invalidTokens.isEmpty()) return;
        deviceTokenRepository.deleteAllByDeviceTokenIn(invalidTokens);
        log.info("Removed {} invalid device tokens", invalidTokens.size());
    }

    public List<DeviceToken> getTokensForUser(Long userId) {
        return deviceTokenRepository.findByUserId(userId);
    }

    public List<DeviceToken> getTokensForUsers(List<Long> userIds) {
        return deviceTokenRepository.findByUserIdIn(userIds);
    }
}