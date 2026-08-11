package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "compliance_history")
@Data
public class ComplianceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_compliance_id", nullable = false)
    private CompanyCompliance companyCompliance;

    @Enumerated(EnumType.STRING)
    @Column(name = "previous_status")
    private ComplianceStatus previousStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "new_status")
    private ComplianceStatus newStatus;

    private String action;

    @Column(length = 1000)
    private String remarks;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "performed_by")
    private User performedBy;

    @Column(name = "performed_at")
    private LocalDateTime performedAt;
}