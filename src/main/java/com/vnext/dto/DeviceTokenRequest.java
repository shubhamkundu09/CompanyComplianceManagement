package com.vnext.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class DeviceTokenRequest {

    @NotBlank(message = "Device token is required")
    private String deviceToken;

    @NotBlank(message = "Platform is required")
    @Pattern(regexp = "IOS|ANDROID", message = "Platform must be IOS or ANDROID")
    private String platform;

    private String deviceName;
    private String appVersion;
}