package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MonthlyOverdueSummaryDTO {
    private int month;              // 1 - 12
    private String monthName;       // "January", "February", etc.
    private int year;
    private long overdueCount;
    private long completedCount;
    private long completedLateCount;
    private long pendingCount;
    private long inProgressCount;
    private long totalCount;
}
