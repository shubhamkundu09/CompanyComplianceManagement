package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "compliance_sub_templates",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"parent_template_id", "name", "company_id"}, name = "uk_parent_sub_name_company")
        })
@Data
public class ComplianceSubTemplate extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_template_id", nullable = false)
    private ComplianceTemplate parentTemplate;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(name = "display_order")
    private Integer displayOrder = 0;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // NEW: company-specific sub‑template (null means global)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;
}