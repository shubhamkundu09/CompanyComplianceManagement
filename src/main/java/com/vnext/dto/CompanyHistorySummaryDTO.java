package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyHistorySummaryDTO {
    private Long companyId;
    private String companyName;
    private int year;
    private long totalCompliances;
    private long totalOverdue;
    private long totalCompleted;
    private long totalCompletedLate;
    private long totalPending;
    private String mostOverdueMonth;
    private List<MonthlyOverdueSummaryDTO> monthlyBreakdown;
}
