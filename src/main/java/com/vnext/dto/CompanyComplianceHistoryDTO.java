package com.vnext.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.vnext.entity.ComplianceFrequency;
import com.vnext.entity.ComplianceStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyComplianceHistoryDTO {
    private Long id;
    private Long companyId;
    private String companyName;
    private String complianceName;
    private String categoryName;
    private String subComplianceName;
    private ComplianceFrequency frequency;
    private LocalDate dueDate;
    private Integer dueMonth;
    private Integer dueYear;
    private String monthName;
    private ComplianceStatus status;

    @JsonProperty("isOverdue")
    private boolean isOverdue;

    @JsonProperty("completedLate")
    private boolean completedLate;

    private Integer daysOverdue;
    private LocalDateTime completedAt;
    private String completedByName;
    private String adminNotes;
    private String submissionReference;
    private String submissionDocumentUrl;

    @JsonProperty("isHistorical")
    private boolean isHistorical;

    private Long historicalRecordId;
    private List<ComplianceHistoryDTO> historyLogs;
}
