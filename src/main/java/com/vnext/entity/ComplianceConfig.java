package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "compliance_configs")
@Data
public class ComplianceConfig extends BaseEntity {

    // Link to the template (if configured at template level - no sub-compliances)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "template_id")
    private ComplianceTemplate template;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_template_id")
    private ComplianceSubTemplate subTemplate;




    // OR link to the CompanyCompliance (if configured at company level for sub-compliances)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_compliance_id")
    private CompanyCompliance companyCompliance;

    // Configuration fields
    @Enumerated(EnumType.STRING)
    private ComplianceFrequency frequency;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "custom_due_date")
    private LocalDate customDueDate;

    @Column(name = "due_day_of_month")
    private Integer dueDayOfMonth;

    @Column(name = "due_quarter")
    private Integer dueQuarter;

    @Column(name = "due_half")
    private Integer dueHalf;

    @Column(name = "due_month")
    private Integer dueMonth;

    // Reminders
    @Column(name = "reminder_days_before")
    private Integer reminderDaysBefore = 10;

    @Column(name = "repeat_reminder")
    private Boolean repeatReminder = true;

    @Column(name = "reminder_interval_days")
    private Integer reminderIntervalDays = 3;

    // Additional info
    @Column(length = 2000)
    private String description;

    @Column(name = "document_required", length = 500)
    private String documentRequired;

    @Column(name = "external_link", length = 500)
    private String externalLink;

    @Column(length = 1000)
    private String instructions;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // Who configured this
    @Column(name = "configured_by")
    private Long configuredBy;

    // Whether this was configured by SuperAdmin (true) or CompanyAdmin (false)
    @Column(name = "is_super_admin_config")
    private Boolean isSuperAdminConfig = false;
}