// src/main/java/com/vnext/entity/Notification.java
package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "notifications")
@Data
public class Notification extends BaseEntity {

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 1000)
    private String message;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "notification_type")
    private String notificationType = "GENERAL";

    @Column(name = "target_role")
    private String targetRole;
}