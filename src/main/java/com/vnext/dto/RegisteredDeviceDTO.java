package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisteredDeviceDTO {
    private Long id;
    private Long userId;
    private String userName;
    private String userEmail;
    private String userRole;
    private String companyName;
    private String platform;
    private String deviceName;
    private String appVersion;
    private String lastSeen;
    private String lastSeenFormatted;
    private String tokenMasked;
}
