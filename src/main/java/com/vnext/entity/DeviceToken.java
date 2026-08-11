package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Entity
@Table(name = "device_tokens",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "device_token"}))
@Data
@EqualsAndHashCode(callSuper = true)
public class DeviceToken extends BaseEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "device_token", nullable = false, length = 500)
    private String deviceToken;

    @Enumerated(EnumType.STRING)
    @Column(name = "platform", nullable = false)
    private Platform platform;

    @Column(name = "device_name", length = 100)
    private String deviceName;

    @Column(name = "app_version", length = 20)
    private String appVersion;

    @Column(name = "last_seen")
    private LocalDateTime lastSeen;
}