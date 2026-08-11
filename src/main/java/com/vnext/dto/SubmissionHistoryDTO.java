package com.vnext.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SubmissionHistoryDTO {
    private Long id;
    private String employeeName;
    private String employeeEmail;
    private LocalDateTime dueDate;
    private LocalDateTime completedAt;
    private String submissionReference;
    private String submissionDocumentUrl;
    private String periodInfo;
    private String status;
}