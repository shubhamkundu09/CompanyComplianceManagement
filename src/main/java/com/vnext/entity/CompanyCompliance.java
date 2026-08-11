package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "company_compliances")
@Data
public class CompanyCompliance extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id", nullable = false)
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "template_id", nullable = false)
    private ComplianceTemplate template;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_template_id")
    private ComplianceSubTemplate subTemplate;

    // NEW: Indicates if this is a parent compliance (no sub-templates) or a sub-compliance
    @Column(name = "is_parent")
    private Boolean isParent = true;

    // NEW: For sub-compliances, reference to parent template ID
    @Column(name = "parent_template_id")
    private Long parentTemplateId;

    @Enumerated(EnumType.STRING)
    private ComplianceStatus status = ComplianceStatus.PENDING;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // NEW: Whether this was created by SuperAdmin (true) or CompanyAdmin (false)
    @Column(name = "is_super_admin_config")
    private Boolean isSuperAdminConfig = false;

    @Column(length = 1000)
    private String adminNotes;


    @Column(name = "admin_submission_reference", length = 200)
    private String adminSubmissionReference;

    @Column(name = "admin_submission_document_url", length = 500)
    private String adminSubmissionDocumentUrl;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "completed_by")
    private Long completedBy;

    // One-to-one with config
    @OneToOne(mappedBy = "companyCompliance", cascade = CascadeType.ALL, orphanRemoval = true)
    private ComplianceConfig config;

    // Helper methods
    public boolean isParent() {
        return isParent != null && isParent;
    }

    public boolean isSubCompliance() {
        return isParent != null && !isParent;
    }
}