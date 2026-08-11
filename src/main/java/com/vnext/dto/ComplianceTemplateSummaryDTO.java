package com.vnext.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class ComplianceTemplateSummaryDTO extends ComplianceTemplateDTO {
    private int subTemplateCount;
    private int assignedCompaniesCount;
    private boolean configured;
}

