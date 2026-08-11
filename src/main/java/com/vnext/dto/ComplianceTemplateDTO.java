package com.vnext.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ComplianceTemplateDTO {
    private Long id;

    @NotBlank(message = "Name is required")
    private String name;

    private String description;
    private Boolean isActive = true;
    private Boolean isCompanySpecific = false;
    private Long companyId;
    private String companyName;

    private Integer priority = 0;

    // NEW
    private Boolean editableForCompanies = false;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}