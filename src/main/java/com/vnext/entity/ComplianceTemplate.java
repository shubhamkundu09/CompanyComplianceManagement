package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "compliance_templates")
@Data
public class ComplianceTemplate extends BaseEntity {

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "priority")
    private Integer priority = 0;

    @Column(name = "is_company_specific")
    private Boolean isCompanySpecific = false;

    // NEW FIELD
    @Column(name = "editable_for_companies")
    private Boolean editableForCompanies = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @Column(name = "configured_by")
    private Long configuredBy;

    @OneToOne(mappedBy = "template", cascade = CascadeType.ALL, orphanRemoval = true)
    private ComplianceConfig directConfig;
}