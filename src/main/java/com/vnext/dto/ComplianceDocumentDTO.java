package com.vnext.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ComplianceDocumentDTO {
    private Long id;
    private String documentName;
    private String documentUrl;
    private String documentType;
    private Long fileSize;
    private String uploadedByName;
    private LocalDateTime uploadedAt;
    private String remarks;
}