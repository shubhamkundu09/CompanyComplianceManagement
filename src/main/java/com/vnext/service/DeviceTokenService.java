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

        // Dissociate this physical device token from any other users to prevent cross-account notifications
        deviceTokenRepository.deleteByDeviceTokenAndUserIdNot(cleanToken, userId);

        var existing = deviceTokenRepository.findByUserIdAndDeviceToken(userId, cleanToken);
        if (existing.isPresent()) {
            var device = existing.get();
            device.setPlatform(p);
            if (deviceName != null && !deviceName.trim().isEmpty()) {
                device.setDeviceName(deviceName.trim());
            }
            if (appVersion != null && !appVersion.trim().isEmpty()) {
                device.setAppVersion(appVersion.trim());
            }
            device.setLastSeen(LocalDateTime.now(IST_ZONE));
            deviceTokenRepository.save(device);
            log.info("Updated device token for user {}: platform={}, device={}, token={}", userId, p, device.getDeviceName(), cleanToken);
            return;
        }

        var newDevice = new DeviceToken();
        newDevice.setUserId(userId);
        newDevice.setDeviceToken(cleanToken);
        newDevice.setPlatform(p);
        newDevice.setDeviceName(deviceName != null && !deviceName.trim().isEmpty() ? deviceName.trim() : (p == Platform.IOS ? "iPhone" : "Android Device"));
        newDevice.setAppVersion(appVersion != null && !appVersion.trim().isEmpty() ? appVersion.trim() : "1.0.0");
        newDevice.setLastSeen(LocalDateTime.now(IST_ZONE));
        deviceTokenRepository.save(newDevice);
        log.info("Registered new device token for user {}: platform={}, device={}, token={}", userId, p, newDevice.getDeviceName(), cleanToken);
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