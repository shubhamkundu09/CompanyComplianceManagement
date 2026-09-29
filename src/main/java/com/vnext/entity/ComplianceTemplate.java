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

    // NEW FIELDS
    @Column(name = "editable_for_companies")
    private Boolean editableForCompanies = false;

    @Column(name = "is_semi_editable")
    private Boolean isSemiEditable = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "template_type", length = 30)
    private ComplianceTemplateType templateType = ComplianceTemplateType.NON_EDITABLE;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @Column(name = "configured_by")
    private Long configuredBy;

    @OneToOne(mappedBy = "template", cascade = CascadeType.ALL, orphanRemoval = true)
    private ComplianceConfig directConfig;

    // Helper methods
    public boolean isEditable() {
        return (editableForCompanies != null && editableForCompanies) || templateType == ComplianceTemplateType.EDITABLE;
    }

    public boolean isSemiEditable() {
        return (isSemiEditable != null && isSemiEditable) || templateType == ComplianceTemplateType.SEMI_EDITABLE;
    }

    public boolean isNonEditable() {
        return !isEditable() && !isSemiEditable();
    }

    public ComplianceTemplateType resolveTemplateType() {
        if (templateType != null) {
            return templateType;
        }
        if (Boolean.TRUE.equals(editableForCompanies)) {
            return ComplianceTemplateType.EDITABLE;
        }
        if (Boolean.TRUE.equals(isSemiEditable)) {
            return ComplianceTemplateType.SEMI_EDITABLE;
        }
        return ComplianceTemplateType.NON_EDITABLE;
    }
}