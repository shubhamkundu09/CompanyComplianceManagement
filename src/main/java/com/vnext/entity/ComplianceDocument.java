package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "compliance_documents")
@Data
public class ComplianceDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_compliance_id", nullable = false)
    private CompanyCompliance companyCompliance;

    @Column(name = "document_name", nullable = false)
    private String documentName;

    @Column(name = "document_url", nullable = false, length = 500)
    private String documentUrl;

    @Column(name = "document_type")
    private String documentType;

    @Column(name = "file_size")
    private Long fileSize;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "uploaded_by")
    private User uploadedBy;

    @Column(name = "uploaded_at")
    private LocalDateTime uploadedAt;

    @Column(length = 500)
    private String remarks;
}