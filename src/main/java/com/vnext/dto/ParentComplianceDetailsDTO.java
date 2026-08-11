package com.vnext.dto;

import com.vnext.entity.ComplianceStatus;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ParentComplianceDetailsDTO {
    private Long id;
    private Long templateId;
    private String templateName;
    private String templateDescription;
    private Boolean isSuperAdminConfig;
    private Boolean isActive;
    private ComplianceStatus status;
    private Boolean isConfigured;
    private LocalDateTime assignedAt;

    // NEW FIELDS
    private Boolean isCompanySpecific;  // Whether this is a custom compliance
    private Long companyId;              // The company that owns this custom compliance
    private Boolean canManage;           // Whether Company Admin can manage (add subs, configure)

    private Integer totalSubCompliances;
    private Integer configuredSubCompliances;
    private List<SubComplianceInfoDTO> subCompliances;

    @Data
    public static class SubComplianceInfoDTO {
        private Long id;
        private Long subTemplateId;
        private String name;
        private String description;
        private Boolean isConfigured;
        private ComplianceStatus status;
        private String frequency;
        private LocalDateTime dueDate;
        private Boolean isActive;
        private String instructions;
        private String documentRequired;
        private String externalLink;
        private Integer reminderDaysBefore;
        private Boolean isCompanySpecific;  // NEW - to show if sub is custom
    }
}