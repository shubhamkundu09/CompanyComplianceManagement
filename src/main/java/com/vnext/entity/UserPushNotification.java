package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_push_notifications", indexes = {
        @Index(name = "idx_upn_user_id", columnList = "user_id"),
        @Index(name = "idx_upn_user_id_id", columnList = "user_id, id")
})
@Data
@EqualsAndHashCode(callSuper = true)
public class UserPushNotification extends BaseEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "body", length = 1000)
    private String body;

    @Column(name = "notification_type", length = 100)
    private String notificationType;

    @Column(name = "screen", length = 100)
    private String screen;

    @Column(name = "action", length = 100)
    private String action;

    @Column(name = "trace_id", length = 100)
    private String traceId;

    @Column(name = "is_delivered")
    private Boolean isDelivered = false;
}
