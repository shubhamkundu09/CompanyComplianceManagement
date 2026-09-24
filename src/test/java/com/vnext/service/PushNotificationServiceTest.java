package com.vnext.service;

import com.vnext.entity.DeviceToken;
import com.vnext.entity.NotificationType;
import com.vnext.entity.Platform;
import com.vnext.repository.DeviceTokenRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PushNotificationServiceTest {

    @Mock
    private DeviceTokenRepository deviceTokenRepository;

    @Mock
    private DeviceTokenService deviceTokenService;

    @Mock
    private com.vnext.repository.PushDeliveryLogRepository pushDeliveryLogRepository;

    @InjectMocks
    private PushNotificationService pushNotificationService;

    @Test
    @DisplayName("sendToUserExcludingDevice filters out the excluded device token")
    void testSendToUserExcludingDevice() {
        Long userId = 1L;
        String excludedToken = "TOKEN_DEVICE_4";

        DeviceToken dt1 = new DeviceToken();
        dt1.setUserId(userId);
        dt1.setDeviceToken("TOKEN_DEVICE_1");
        dt1.setPlatform(Platform.IOS);

        DeviceToken dt2 = new DeviceToken();
        dt2.setUserId(userId);
        dt2.setDeviceToken("TOKEN_DEVICE_2");
        dt2.setPlatform(Platform.IOS);

        DeviceToken dt3 = new DeviceToken();
        dt3.setUserId(userId);
        dt3.setDeviceToken("TOKEN_DEVICE_3");
        dt3.setPlatform(Platform.IOS);

        DeviceToken dt4 = new DeviceToken();
        dt4.setUserId(userId);
        dt4.setDeviceToken("TOKEN_DEVICE_4");
        dt4.setPlatform(Platform.IOS);

        when(deviceTokenRepository.findByUserId(userId)).thenReturn(List.of(dt1, dt2, dt3, dt4));

        NotificationPayload payload = NotificationPayload.builder()
                .title("SuperAdmin Login")
                .body("SUPER_ADMIN logged in successfully")
                .type(NotificationType.SUPER_ADMIN_LOGIN)
                .screen("dashboard")
                .build();

        // Calling sendToUserExcludingDevice should find tokens, exclude TOKEN_DEVICE_4, and not fail
        assertDoesNotThrow(() -> {
            pushNotificationService.sendToUserExcludingDevice(userId, excludedToken, payload);
        });

        verify(deviceTokenRepository, times(1)).findByUserId(userId);
    }
}
