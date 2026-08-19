package com.vnext.dto;

import com.vnext.entity.ComplianceStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class CompanyComplianceDTO {
    private Long id;
    private Long companyId;
    private String companyName;
    private Long templateId;
    private String templateName;
    private String category;
    private ComplianceStatus status;
    private LocalDate dueDate;
    private LocalDate nextDueDate;
    private LocalDateTime assignedAt;
    private String notes;
    private Boolean isActive;
    private Boolean configured;
    private String assignedByName;
    private LocalDate effectiveDueDate;
    private String frequency;
    private String subTemplateName;

    private Long subTemplateId;


    private String submissionReference;
    private String submissionDocumentUrl;
    private LocalDateTime completedAt;
    private String completedByName;

    // ===== ADD PRIORITY FIELD =====
    private Integer priority;
    private Boolean isParent;
}