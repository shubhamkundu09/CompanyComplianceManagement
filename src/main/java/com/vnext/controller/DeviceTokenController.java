package com.vnext.controller;

import com.vnext.dto.ApiResponse;
import com.vnext.dto.DeviceTokenRequest;
import com.vnext.entity.User;
import com.vnext.security.CurrentUser;
import com.vnext.service.DeviceTokenService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class DeviceTokenController {

    private final DeviceTokenService deviceTokenService;

    @PostMapping("/device-token")
    public ApiResponse<Void> registerToken(
            @CurrentUser User user,
            @Valid @RequestBody DeviceTokenRequest request) {
        deviceTokenService.registerDeviceToken(
                user.getId(),
                request.getDeviceToken(),
                request.getPlatform(),
                request.getDeviceName(),
                request.getAppVersion()
        );
        return ApiResponse.success("Device token registered");
    }

    @DeleteMapping("/device-token")
    public ApiResponse<Void> removeToken(
            @CurrentUser User user,
            @RequestParam String deviceToken) {
        deviceTokenService.removeDeviceToken(user.getId(), deviceToken);
        return ApiResponse.success("Device token removed");
    }
}