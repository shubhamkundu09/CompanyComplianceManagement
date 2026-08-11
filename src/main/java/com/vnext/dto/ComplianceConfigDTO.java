package com.vnext.dto;

import com.vnext.entity.ComplianceFrequency;
import com.vnext.entity.ComplianceStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class ComplianceConfigDTO {
    private Long id;
    private Long templateId;
    private String templateName;
    private Long subTemplateId;
    private String subTemplateName;
    private Long companyComplianceId;
    private Long companyId;
    private String companyName;
    private Boolean configured;
    private ComplianceStatus status;

    // ===== ADD PRIORITY FIELD =====
    private Integer priority;

    private LocalDate nextDueDate;
    private ComplianceFrequency frequency;
    private LocalDate dueDate;
    private LocalDate customDueDate;
    private LocalDate effectiveDueDate;
    private Integer dueDayOfMonth;
    private Integer dueQuarter;
    private Integer dueHalf;
    private Integer dueMonth;

    private Integer reminderDaysBefore = 10;
    private Boolean repeatReminder = true;
    private Integer reminderIntervalDays = 3;

    private String description;
    private String documentRequired;
    private String externalLink;
    private String instructions;
    private Boolean isActive = true;
    private Boolean isSuperAdminConfig = false;
    private LocalDateTime createdAt;
}