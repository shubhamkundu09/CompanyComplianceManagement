package com.vnext.dto;

import com.vnext.entity.ComplianceStatus;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class SubComplianceDetailsDTO {
    private Long id;
    private String name;
    private String description;
    private String parentName;
    private Long parentId;
    private ComplianceStatus status;
    private Boolean isConfigured;
    private Boolean isActive;  // Add this field
    private String frequency;
    private LocalDateTime dueDate;
    private String instructions;
    private String documentRequired;
    private String externalLink;
    private Integer reminderDaysBefore;
    private Boolean isOverdue;
    private Integer daysRemaining;
    private String periodInfo;

    // Completion info
    private Boolean canComplete;
    private LocalDateTime completedAt;
    private String completedByEmployeeName;
    private String submissionReference;
    private String submissionDocumentUrl;

    // Lists
    private List<ComplianceDocumentDTO> documents;
    private List<ComplianceHistoryDTO> history;
}