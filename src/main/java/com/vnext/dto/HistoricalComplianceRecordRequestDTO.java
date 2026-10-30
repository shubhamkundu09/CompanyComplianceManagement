package com.vnext.dto;

import com.vnext.entity.ComplianceStatus;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HistoricalComplianceRecordRequestDTO {

    private Long id;

    @NotNull(message = "Company ID is required")
    private Long companyId;

    @NotNull(message = "Compliance template ID is required")
    private Long templateId;

    private Long subTemplateId;

    @NotNull(message = "Period year is required")
    @Min(2000)
    private Integer year;

    @NotNull(message = "Period month is required")
    @Min(1)
    @Max(12)
    private Integer month;

    @NotNull(message = "Due date is required")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dueDate;

    @NotNull(message = "Status is required")
    private ComplianceStatus status;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime completedAt;

    private String submissionReference;

    private String remarks;
}

