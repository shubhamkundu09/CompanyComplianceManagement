package com.vnext.service;

import com.google.firebase.messaging.*;
import com.vnext.entity.DeviceToken;
import com.vnext.repository.DeviceTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PushNotificationService {

    private final DeviceTokenRepository deviceTokenRepository;
    private final DeviceTokenService deviceTokenService;

    public void sendToUser(Long userId, NotificationPayload payload) {
        log.info("Sending push notification to user {}: {} - {}", userId, payload.getTitle(), payload.getBody());
        var tokens = deviceTokenRepository.findByUserId(userId)
                .stream()
                .map(DeviceToken::getDeviceToken)
                .filter(t -> t != null && !t.trim().isEmpty())
                .collect(Collectors.toList());

        if (tokens.isEmpty()) {
            log.info("No active device token registered for user {}", userId);
            return;
        }
        sendMulticast(tokens, payload);
    }

    public void sendToUsers(List<Long> userIds, NotificationPayload payload) {
        log.info("Sending push notification to user IDs {}: {} - {}", userIds, payload.getTitle(), payload.getBody());
        if (userIds.isEmpty()) return;

        var tokens = deviceTokenRepository.findByUserIdIn(userIds)
                .stream()
                .map(DeviceToken::getDeviceToken)
                .filter(t -> t != null && !t.trim().isEmpty())
                .collect(Collectors.toList());

        var realTokens = tokens.stream()
                .filter(t -> !t.startsWith("SIMULATOR_") && !t.startsWith("MOCK_"))
                .collect(Collectors.toList());

        if (realTokens.isEmpty()) {
            log.info("No real FCM device tokens registered for target user IDs {} (simulator/mock tokens ignored for FCM remote call)", userIds);
            return;
        }
        sendMulticast(realTokens, payload);
    }

    private void sendMulticast(List<String> tokens, NotificationPayload payload) {
        if (tokens.isEmpty()) return;

        try {
            MulticastMessage message = MulticastMessage.builder()
                    .addAllTokens(tokens)
                    .setNotification(Notification.builder()
                            .setTitle(payload.getTitle())
                            .setBody(payload.getBody())
                            .build())
                    .putAllData(payload.getData())
                    .setApnsConfig(ApnsConfig.builder()
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
                            .build())
                    .build();

            // Use sendEachForMulticast instead of deprecated sendMulticast
            BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
            log.info("Multicast push: success={}, failure={}", response.getSuccessCount(), response.getFailureCount());

            if (response.getFailureCount() > 0) {
                for (int i = 0; i < response.getResponses().size(); i++) {
                    var r = response.getResponses().get(i);
                    if (!r.isSuccessful()) {
                        log.warn("FCM push failed for token {}: error={}", tokens.get(i), r.getException() != null ? r.getException().getMessage() : "Unknown");
                    }
                }
                List<String> invalidTokens = response.getResponses().stream()
                        .filter(r -> !r.isSuccessful() && r.getException() instanceof FirebaseMessagingException)
                        .map(r -> {
                            var ex = (FirebaseMessagingException) r.getException();
                            MessagingErrorCode code = ex.getMessagingErrorCode();
                            if (code == MessagingErrorCode.INVALID_ARGUMENT ||
                                    code == MessagingErrorCode.UNREGISTERED ||
                                    code == MessagingErrorCode.SENDER_ID_MISMATCH) {
                                return tokens.get(response.getResponses().indexOf(r));
                            }
                            return null;
                        })
                        .filter(t -> t != null)
                        .collect(Collectors.toList());

                if (!invalidTokens.isEmpty()) {
                    deviceTokenService.removeInvalidTokens(invalidTokens);
                }
            }
        } catch (FirebaseMessagingException e) {
            log.error("Firebase multicast error: {}", e.getMessage());
        }
    }
}