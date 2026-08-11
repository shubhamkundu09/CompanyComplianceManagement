package com.vnext.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ComplianceSubTemplateDTO {
    private Long id;
    private Long parentTemplateId;
    private String parentTemplateName;

    @NotBlank(message = "Name is required")
    private String name;

    private String description;
    private Integer displayOrder = 0;
    private Boolean isActive = true;

    // NEW fields for company-specific sub‑templates
    private Long companyId;
    private String companyName;
}