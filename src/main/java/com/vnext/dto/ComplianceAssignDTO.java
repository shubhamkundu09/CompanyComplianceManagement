package com.vnext.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class ComplianceAssignDTO {
    @NotNull(message = "Template ID is required")
    private Long templateId;

    @NotNull(message = "Company IDs are required")
    private List<Long> companyIds;

    private String notes;
}