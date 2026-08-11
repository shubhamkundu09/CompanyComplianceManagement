package com.vnext.dto;

import lombok.Data;

@Data
public class ComplianceStatsDTO {
    private long totalTemplates;
    private long totalAssignments;
    private long pendingAssignments;
    private long inProgressAssignments;
    private long completedAssignments;
    private long overdueAssignments;
}