package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "company_documents")
@Data
public class CompanyDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id", nullable = false)
    private Company company;

    // ===== ADD THIS RELATIONSHIP =====
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_compliance_id")
    private CompanyCompliance companyCompliance;

    @Column(name = "file_name", nullable = false)
    private String fileName;        // original name shown to user

    @Column(name = "stored_name", nullable = false)
    private String storedName;      // name on disk / in storage

    @Column(name = "file_url")
    private String fileUrl;         // URL to access via API

    @Column(name = "file_type")
    private String fileType;        // mime type

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "uploaded_at")
    private LocalDateTime uploadedAt;

    @Column(name = "uploaded_by")
    private Long uploadedBy;
}