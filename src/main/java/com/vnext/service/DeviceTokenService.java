package com.vnext.service;

import com.vnext.entity.DeviceToken;
import com.vnext.entity.Platform;
import com.vnext.repository.DeviceTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class DeviceTokenService {

    private final DeviceTokenRepository deviceTokenRepository;

    @Transactional
    public void registerDeviceToken(Long userId, String token, String platform, String deviceName, String appVersion) {
        if (token == null || token.trim().isEmpty() || userId == null) return;

        Platform p = Platform.ANDROID;
        try {
            if (platform != null) {
                p = Platform.valueOf(platform.toUpperCase());
            }
        } catch (Exception e) {
            p = Platform.ANDROID;
        }

        var existing = deviceTokenRepository.findByUserIdAndDeviceToken(userId, token);
        if (existing.isPresent()) {
            var device = existing.get();
            device.setPlatform(p);
            device.setDeviceName(deviceName);
            device.setAppVersion(appVersion);
            device.setLastSeen(LocalDateTime.now());
            deviceTokenRepository.save(device);
            log.info("Updated device token for user {}: platform={}, device={}", userId, p, deviceName);
            return;
        }

        var newDevice = new DeviceToken();
        newDevice.setUserId(userId);
        newDevice.setDeviceToken(token);
        newDevice.setPlatform(p);
        newDevice.setDeviceName(deviceName);
        newDevice.setAppVersion(appVersion);
        newDevice.setLastSeen(LocalDateTime.now());
        deviceTokenRepository.save(newDevice);
        log.info("Registered new device token for user {}: platform={}, device={}", userId, p, deviceName);
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