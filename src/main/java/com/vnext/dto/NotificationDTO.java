// dto/NotificationDTO.java
package com.vnext.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationDTO {
    private Long id;
    private String title;
    private String message;
    private String notificationType;
    private Boolean isActive;
    private LocalDateTime expiresAt;
    private Long createdBy;
    private String createdByName;
    private Integer priority;
    private String icon;
    private LocalDateTime createdAt;
    private String timeAgo;
}