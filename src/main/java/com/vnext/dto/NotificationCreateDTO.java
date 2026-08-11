// dto/NotificationCreateDTO.java
package com.vnext.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationCreateDTO {

    @NotBlank(message = "Title is required")
    @Size(max = 200, message = "Title must be less than 200 characters")
    private String title;

    @NotBlank(message = "Message is required")
    @Size(max = 1000, message = "Message must be less than 1000 characters")
    private String message;

    private String notificationType = "GENERAL";

    private Integer priority = 0;

    private String icon = "fa-bell";

    private LocalDateTime expiresAt;
}