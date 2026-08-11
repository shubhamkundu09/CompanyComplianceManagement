package com.vnext.dto;

import lombok.Data;

@Data
public class EmployeeComplianceStatsDTO {
    private int totalCompliances;
    private int completedCompliances;
    private int pendingCompliances;
    private int overdueCompliances;
    private int inProgressCompliances;
    private int totalCategories;
    private int completionPercentage;
}