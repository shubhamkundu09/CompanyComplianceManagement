package com.vnext.service;

import com.google.firebase.messaging.*;
import com.vnext.entity.DeviceToken;
import com.vnext.entity.PushDeliveryLog;
import com.vnext.repository.DeviceTokenRepository;
import com.vnext.repository.PushDeliveryLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PushNotificationService {

    private final DeviceTokenRepository deviceTokenRepository;
    private final DeviceTokenService deviceTokenService;
    private final PushDeliveryLogRepository pushDeliveryLogRepository;
    private final com.vnext.repository.UserPushNotificationRepository userPushNotificationRepository;

    private void saveUserPushNotification(Long userId, NotificationPayload payload) {
        if (userId == null || payload == null) return;
        try {
            com.vnext.entity.UserPushNotification upn = new com.vnext.entity.UserPushNotification();
            upn.setUserId(userId);
            upn.setTitle(payload.getTitle() != null ? payload.getTitle() : "Compliance Notification");
            upn.setBody(payload.getBody() != null ? payload.getBody() : "");
            upn.setNotificationType(payload.getType() != null ? payload.getType().name() : "GENERAL");
            upn.setScreen(payload.getScreen());
            upn.setAction(payload.getExtra() != null && payload.getExtra().get("action") != null
                    ? payload.getExtra().get("action").toString() : null);
            upn.setTraceId(payload.getTraceId());
            upn.setIsDelivered(false);
            userPushNotificationRepository.save(upn);
        } catch (Exception e) {
            log.warn("Failed to persist user push notification for user {}: {}", userId, e.getMessage());
        }
    }

    private void recordDeliveryLog(NotificationPayload payload, int recipientCount, int successCount, int failureCount, String status, String errorMessage) {
        try {
            PushDeliveryLog deliveryLog = new PushDeliveryLog();
            deliveryLog.setTraceId(payload != null ? payload.getTraceId() : null);
            deliveryLog.setNotificationType(payload != null && payload.getType() != null ? payload.getType().name() : "FCM_PUSH");
            deliveryLog.setTitle(payload != null && payload.getTitle() != null ? payload.getTitle() : "Notification");
            deliveryLog.setBody(payload != null ? payload.getBody() : "");
            deliveryLog.setRecipientCount(recipientCount);
            deliveryLog.setSuccessCount(successCount);
            deliveryLog.setFailureCount(failureCount);
            deliveryLog.setStatus(status);
            deliveryLog.setErrorMessage(errorMessage);
            pushDeliveryLogRepository.save(deliveryLog);
        } catch (Exception e) {
            log.warn("Failed to record PushDeliveryLog: {}", e.getMessage());
        }
    }

    public void sendToUser(Long userId, NotificationPayload payload) {
        sendToUserExcludingDevice(userId, null, payload);
    }

    public void sendToUserExcludingDevice(Long userId, String excludeToken, NotificationPayload payload) {
        ensureTraceId(payload);
        String traceId = payload.getTraceId();
        log.info("[TraceID: {}] Sending push notification to user {} (excluding token {}): {} - {}",
                traceId, userId, excludeToken, payload.getTitle(), payload.getBody());
        if (userId == null) return;

        saveUserPushNotification(userId, payload);

        var tokens = deviceTokenRepository.findByUserId(userId)
                .stream()
                .map(DeviceToken::getDeviceToken)
                .filter(t -> t != null && !t.trim().isEmpty())
                .filter(t -> excludeToken == null || !t.trim().equalsIgnoreCase(excludeToken.trim()))
                .collect(Collectors.toList());

        var realTokens = tokens.stream()
                .filter(t -> !t.startsWith("SIMULATOR_") && !t.startsWith("MOCK_"))
                .collect(Collectors.toList());

        if (realTokens.isEmpty()) {
            log.info("[TraceID: {}] No other real FCM device token registered for user {} (after excluding {}). Total tokens: {}. Queued for local drawer sync.",
                    traceId, userId, excludeToken, tokens.size());
            recordDeliveryLog(payload, 1, 1, 0, "QUEUED_LOCAL", "Queued for native device notification drawer sync (APNs fallback)");
            return;
        }
        sendMulticast(realTokens, payload);
    }

    public void sendToUsers(List<Long> userIds, NotificationPayload payload) {
        ensureTraceId(payload);
        String traceId = payload.getTraceId();
        log.info("[TraceID: {}] Sending push notification to user IDs {}: {} - {}",
                traceId, userIds, payload.getTitle(), payload.getBody());
        if (userIds == null || userIds.isEmpty()) return;

        for (Long uid : userIds) {
            saveUserPushNotification(uid, payload);
        }

        var tokens = deviceTokenRepository.findByUserIdIn(userIds)
                .stream()
                .map(DeviceToken::getDeviceToken)
                .filter(t -> t != null && !t.trim().isEmpty())
                .collect(Collectors.toList());

        var realTokens = tokens.stream()
                .filter(t -> !t.startsWith("SIMULATOR_") && !t.startsWith("MOCK_"))
                .collect(Collectors.toList());

        if (realTokens.isEmpty()) {
            log.warn("[TraceID: {}] No real FCM device tokens registered for target user IDs {}. Total tokens found: {}. Queued for local drawer sync.",
                    traceId, userIds, tokens.size());
            recordDeliveryLog(payload, userIds.size(), userIds.size(), 0, "QUEUED_LOCAL", "Queued for native device notification drawer sync (APNs fallback)");
            return;
        }
        sendMulticast(realTokens, payload);
    }

    private void ensureTraceId(NotificationPayload payload) {
        if (payload != null && (payload.getTraceId() == null || payload.getTraceId().isBlank())) {
            payload.setTraceId(UUID.randomUUID().toString());
        }
    }

    public void sendToToken(String token, NotificationPayload payload) {
        if (token != null && !token.trim().isEmpty()) {
            sendMulticast(List.of(token.trim()), payload);
        }
    }

    public void sendMulticast(List<String> tokens, NotificationPayload payload) {
        if (tokens == null || tokens.isEmpty()) return;

        if (tokens.size() > 500) {
            for (int i = 0; i < tokens.size(); i += 500) {
                List<String> sub = tokens.subList(i, Math.min(i + 500, tokens.size()));
                sendMulticast(sub, payload);
            }
            return;
        }

        ensureTraceId(payload);
        String traceId = payload.getTraceId();

        if (com.google.firebase.FirebaseApp.getApps().isEmpty()) {
            log.warn("[TraceID: {}] FirebaseApp is not initialized. Skipping FCM multicast push.", traceId);
            recordDeliveryLog(payload, tokens.size(), tokens.size(), 0, "SUCCESS", "Simulated delivery (Firebase App not initialized in local/test mode)");
            return;
        }

        try {
            AndroidConfig androidConfig = AndroidConfig.builder()
                    .setPriority(AndroidConfig.Priority.HIGH)
                    .setNotification(AndroidNotification.builder()
                            .setTitle(payload.getTitle())
                            .setBody(payload.getBody())
                            .setSound("default")
                            .setChannelId("compliance_notifications")
                            .setDefaultSound(true)
                            .setDefaultVibrateTimings(true)
                            .build())
                    .build();

            ApnsConfig apnsConfig = ApnsConfig.builder()
                    .putHeader("apns-priority", "10")
                    .putHeader("apns-push-type", "alert")
                    .setAps(Aps.builder()
                            .setAlert(ApsAlert.builder()
                                    .setTitle(payload.getTitle())
                                    .setBody(payload.getBody())
                                    .build())
                            .setSound("default")
                            .setBadge(1)
                            .setContentAvailable(true)
                            .build())
                    .build();

            MulticastMessage message = MulticastMessage.builder()
                    .addAllTokens(tokens)
                    .setNotification(Notification.builder()
                            .setTitle(payload.getTitle())
                            .setBody(payload.getBody())
                            .build())
                    .putAllData(payload.getData())
                    .setAndroidConfig(androidConfig)
                    .setApnsConfig(apnsConfig)
                    .build();

            // Use sendEachForMulticast instead of deprecated sendMulticast
            BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
            int success = response.getSuccessCount();
            int failure = response.getFailureCount();
            String status = failure == 0 ? "SUCCESS" : (success > 0 ? "PARTIAL" : "FAILED");
            recordDeliveryLog(payload, tokens.size(), success, failure, status, failure > 0 ? failure + " tokens failed to deliver" : null);

            log.info("[TraceID: {}] Multicast push sent to {} devices: success={}, failure={}",
                    traceId, tokens.size(), response.getSuccessCount(), response.getFailureCount());

            if (response.getFailureCount() > 0) {
                List<String> invalidTokens = new ArrayList<>();
                for (int i = 0; i < response.getResponses().size(); i++) {
                    SendResponse r = response.getResponses().get(i);
                    String token = tokens.get(i);
                    if (!r.isSuccessful()) {
                        log.warn("[TraceID: {}] FCM push failed for token {}: error={}",
                                traceId, token, r.getException() != null ? r.getException().getMessage() : "Unknown");

                        if (r.getException() instanceof FirebaseMessagingException) {
                            FirebaseMessagingException ex = (FirebaseMessagingException) r.getException();
                            MessagingErrorCode code = ex.getMessagingErrorCode();
                            if (code == MessagingErrorCode.INVALID_ARGUMENT ||
                                    code == MessagingErrorCode.UNREGISTERED ||
                                    code == MessagingErrorCode.SENDER_ID_MISMATCH) {
                                invalidTokens.add(token);
                            }
                        }
                    }
                }

                if (!invalidTokens.isEmpty()) {
                    log.info("[TraceID: {}] Removing {} invalid/unregistered device tokens: {}",
                            traceId, invalidTokens.size(), invalidTokens);
                    deviceTokenService.removeInvalidTokens(invalidTokens);
                }
            }
        } catch (FirebaseMessagingException e) {
            log.error("[TraceID: {}] Firebase multicast error: {}", traceId, e.getMessage(), e);
            recordDeliveryLog(payload, tokens.size(), 0, tokens.size(), "FAILED", e.getMessage());
        }
    }
}