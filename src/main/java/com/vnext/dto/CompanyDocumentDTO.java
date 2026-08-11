package com.vnext.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CompanyDocumentDTO {
    private Long id;
    private String fileName;
    private String fileUrl;
    private String fileType;
    private Long fileSize;
    private LocalDateTime uploadedAt;
    private String uploadedByName;
}