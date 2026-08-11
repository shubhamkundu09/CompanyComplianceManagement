package com.vnext.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CategoryDetailsDTO {
    private Long id;
    private String name;
    private String description;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Sub-compliances
    private List<SubComplianceInfoDTO> subCompliances;

    // Configurations
    private ConfigInfoDTO config;

    // Assigned companies
    private List<CompanyAssignmentDTO> assignments;

    // Statistics
    private int totalCompaniesAssigned;
    private int activeCompaniesCount;
    private int configuredCompaniesCount;
    private int pendingConfigCount;
    private int completedCount;

    @Data
    public static class SubComplianceInfoDTO {
        private Long id;
        private String name;
        private String description;
        private Boolean isActive;
        private Integer displayOrder;
        private Boolean isConfigured;
        private ConfigInfoDTO configDetails;
    }

    @Data
    public static class ConfigInfoDTO {
        private Long id;
        private String frequency;
        private String customDueDate;
        private Integer dueDayOfMonth;
        private Integer dueQuarter;
        private Integer dueHalf;
        private Integer dueMonth;
        private Integer reminderDaysBefore;
        private Boolean repeatReminder;
        private Integer reminderIntervalDays;
        private String description;
        private String documentRequired;
        private String externalLink;
        private String instructions;
        private Boolean isActive;
        private String effectiveDueDate;
    }

    @Data
    public static class CompanyAssignmentDTO {
        private Long companyId;
        private Long companyComplianceId;
        private String companyName;
        private String companyEmail;
        private String complianceStatus;
        private Boolean isConfigured;
        private Boolean isActive;
        private String assignedAt;
        private String dueDate;
        private String completedAt;
        private String notes;
        private String assignedByName;
    }
}