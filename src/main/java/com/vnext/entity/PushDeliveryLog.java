package com.vnext.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Table(name = "push_delivery_logs")
@Data
@EqualsAndHashCode(callSuper = true)
public class PushDeliveryLog extends BaseEntity {

    @Column(name = "trace_id", length = 100)
    private String traceId;

    @Column(name = "notification_type", length = 100)
    private String notificationType;

    @Column(name = "title", length = 255)
    private String title;

    @Column(name = "body", length = 1000)
    private String body;

    @Column(name = "recipient_count")
    private Integer recipientCount = 0;

    @Column(name = "success_count")
    private Integer successCount = 0;

    @Column(name = "failure_count")
    private Integer failureCount = 0;

    @Column(name = "status", length = 50)
    private String status; // "SUCCESS", "PARTIAL", "FAILED", "NO_DEVICES"

    @Column(name = "error_message", length = 1000)
    private String errorMessage;
}
