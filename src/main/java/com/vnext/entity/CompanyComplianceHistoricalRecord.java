package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "company_compliance_historical_records", indexes = {
    @Index(name = "idx_cchr_company_id", columnList = "company_id"),
    @Index(name = "idx_cchr_period", columnList = "company_id, period_year, period_month"),
    @Index(name = "idx_cchr_template", columnList = "company_id, template_id")
})
@Data
@EqualsAndHashCode(callSuper = true)
public class CompanyComplianceHistoricalRecord extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id", nullable = false)
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "template_id", nullable = false)
    private ComplianceTemplate template;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_template_id")
    private ComplianceSubTemplate subTemplate;

    @Column(name = "period_year", nullable = false)
    private Integer periodYear;

    @Column(name = "period_month", nullable = false)
    private Integer periodMonth;

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ComplianceStatus status;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "completed_late")
    private Boolean completedLate = false;

    @Column(name = "submission_reference", length = 200)
    private String submissionReference;

    @Column(name = "submission_document_url", length = 500)
    private String submissionDocumentUrl;

    @Column(length = 1000)
    private String remarks;

    @Column(name = "created_by_name", length = 100)
    private String createdByName;

    public boolean isCompletedLate() {
        return Boolean.TRUE.equals(completedLate);
    }
}

