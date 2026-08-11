package com.vnext.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class CalendarEventDTO {
    private Long id;
    private String title;
    private String description;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String category;
    private String assignedTo;
    private String periodInfo;
    private Boolean isOverdue;
    private Integer daysRemaining;
}