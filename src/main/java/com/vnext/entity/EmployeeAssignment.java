package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "employee_assignments")
@Data
public class EmployeeAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "config_id", nullable = false)
    private ComplianceConfig config;

    @Column(name = "employee_id", nullable = false)
    private Long employeeId;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "submission_reference", length = 200)
    private String submissionReference;

    @Column(name = "submission_document_url", length = 500)
    private String submissionDocumentUrl;

    @Column(name = "assigned_at")
    private LocalDateTime assignedAt;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "completed_by")
    private Long completedBy;

    // Link to parent assignment (if this is a sub-compliance)
    @Column(name = "parent_assignment_id")
    private Long parentAssignmentId;

    @Column(name = "is_sub_assignment")
    private Boolean isSubAssignment = false;

    @Column(name = "is_overdue")
    private Boolean isOverdue = false;

    @Column(name = "overdue_notified_at")
    private LocalDateTime overdueNotifiedAt;



    @Column(name = "last_reminder_sent")
    private LocalDate lastReminderSent;
}