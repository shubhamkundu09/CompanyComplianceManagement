package com.vnext.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ComplianceHistoryDTO {
    private Long id;
    private String action;
    private String previousStatus;
    private String newStatus;
    private String remarks;
    private String performedByName;
    private LocalDateTime performedAt;
    private String companyName;  // ADD THIS FIELD
}