package com.vnext.dto;

import com.vnext.entity.ComplianceStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class EmployeeComplianceDTO {
    private Long id;
    private Long configId;
    private Long companyComplianceId;
    private Long templateId;
    private Long subTemplateId;

    private String complianceName;
    private String subTemplateName;
    private String category;
    private String description;

    private LocalDate dueDate;
    private ComplianceStatus status;
    private String frequency;

    private String documentRequired;
    private String externalLink;
    private String instructions;

    private Integer daysRemaining;
    private Boolean overdue;
    private Boolean isOverdue;
    private Boolean isSubAssignment;

    private LocalDateTime completedAt;
    private String submissionReference;
    private String submissionDocumentUrl;

    private Long employeeId;
    private String employeeName;
    private String employeeEmail;

    // For categories
    private Integer totalSubCompliances;
    private Integer completedSubCompliances;
    private Integer completionPercentage;
}