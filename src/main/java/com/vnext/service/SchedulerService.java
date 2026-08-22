package com.vnext.service;

import com.vnext.entity.*;
import com.vnext.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SchedulerService {

    private final EmployeeAssignmentRepository assignmentRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final ComplianceService complianceService;
    private final ComplianceConfigRepository configRepository;
    private final NotificationEventService notificationEventService;
    private final CompanyRepository companyRepository;

    // ─── 1. RECURRING COMPLIANCE RENEWAL ──────────────────────────────────────
    @Scheduled(cron = "0 5 0 * * *") // daily at 00:05
    @Transactional
    public void renewCompletedRecurringCompliances() {
        log.info("Running recurring compliance renewal check...");

        LocalDate today = LocalDate.now();

        // Find all completed recurring compliances
        List<CompanyCompliance> completedRecurring = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() == ComplianceStatus.COMPLETED)
                .filter(cc -> cc.getIsActive() && !cc.isDeleted())
                .filter(cc -> cc.getConfig() != null)
                .filter(cc -> cc.getConfig().getFrequency() != null)
                .filter(cc -> cc.getConfig().getFrequency() != ComplianceFrequency.ONE_TIME)
                .collect(Collectors.toList());

        if (completedRecurring.isEmpty()) {
            log.info("No completed recurring compliances to renew.");
            return;
        }

        for (CompanyCompliance cc : completedRecurring) {
            ComplianceConfig config = cc.getConfig();
            ComplianceFrequency freq = config.getFrequency();
            LocalDate lastDueDate = config.getDueDate() != null ? config.getDueDate() : config.getCustomDueDate();
            if (lastDueDate == null) continue;

            LocalDate nextDueDate = complianceService.getNextDueDateForCompliance(cc);
            if (nextDueDate == null) continue;

            // Renew only on the first day of the new period (simple check)
            boolean shouldRenew = false;
            int day = today.getDayOfMonth();
            if (day != 1) continue;

            if (freq == ComplianceFrequency.MONTHLY) {
                shouldRenew = true;
            } else if (freq == ComplianceFrequency.QUARTERLY) {
                int month = today.getMonthValue();
                if (month == 4 || month == 7 || month == 10 || month == 1) {
                    shouldRenew = true;
                }
            } else if (freq == ComplianceFrequency.HALF_YEARLY) {
                int month = today.getMonthValue();
                if (month == 1 || month == 7) {
                    shouldRenew = true;
                }
            } else if (freq == ComplianceFrequency.YEARLY) {
                if (today.getMonthValue() == 1) {
                    shouldRenew = true;
                }
            }

            if (!shouldRenew) continue;

            log.info("Renewing compliance ID: {} for company: {}", cc.getId(), cc.getCompany().getName());

            // Update config due date
            config.setDueDate(nextDueDate);
            config.setCustomDueDate(nextDueDate);
            config.setUpdatedAt(LocalDateTime.now());
            configRepository.save(config);

            // Reset company compliance status
            cc.setStatus(ComplianceStatus.PENDING);
            cc.setCompletedAt(null);
            cc.setCompletedBy(null);
            cc.setAdminSubmissionReference(null);
            cc.setAdminSubmissionDocumentUrl(null);
            companyComplianceRepository.save(cc);

            // Reset existing assignments or create new ones
            List<EmployeeAssignment> oldAssignments = assignmentRepository
                    .findByConfigIdAndIsActiveTrue(config.getId());
            if (!oldAssignments.isEmpty()) {
                for (EmployeeAssignment old : oldAssignments) {
                    old.setDueDate(nextDueDate);
                    old.setCompletedAt(null);
                    old.setSubmissionReference(null);
                    old.setSubmissionDocumentUrl(null);
                    old.setCompletedBy(null);
                    old.setIsOverdue(false);
                    old.setOverdueNotifiedAt(null);
                    assignmentRepository.save(old);
                }
                log.info("Renewed {} employee assignments for compliance ID: {}", oldAssignments.size(), cc.getId());
            } else {
                // Assign to all active employees in the company
                List<User> employees = userRepository.findByCompanyIdAndRoleAndDeletedFalse(
                        cc.getCompany().getId(), UserRole.EMPLOYEE, Pageable.unpaged()).getContent();
                for (User emp : employees) {
                    EmployeeAssignment newAssign = new EmployeeAssignment();
                    newAssign.setConfig(config);
                    newAssign.setEmployeeId(emp.getId());
                    newAssign.setDueDate(nextDueDate);
                    newAssign.setAssignedAt(LocalDateTime.now());
                    newAssign.setIsActive(true);
                    newAssign.setIsSubAssignment(cc.isSubCompliance());
                    if (cc.isSubCompliance() && cc.getParentTemplateId() != null) {
                        // For sub-compliances, we could link to a parent assignment if needed
                    }
                    assignmentRepository.save(newAssign);
                }
                log.info("Created new assignments for {} employees", employees.size());
            }

            // Add history
            complianceService.addHistoryForCompanyCompliance(cc, ComplianceStatus.COMPLETED, ComplianceStatus.PENDING,
                    "Auto-Renewed", "Compliance renewed for the next period: " + freq.name(), null);
        }
    }

    // ─── 2. OVERDUE EMPLOYEE COMPLIANCES (Push Notifications) ──────────────
    @Scheduled(cron = "0 30 8 * * *") // daily at 08:30
    @Transactional
    public void checkOverdueEmployeeCompliances() {
        log.info("Checking overdue employee compliances...");
        LocalDate today = LocalDate.now();

        List<EmployeeAssignment> overdueAssignments = assignmentRepository
                .findByDueDateBeforeAndCompletedAtIsNullAndIsActiveTrue(today);

        if (overdueAssignments.isEmpty()) {
            log.info("No overdue employee assignments found.");
            return;
        }

        log.info("Found {} overdue assignments", overdueAssignments.size());

        for (EmployeeAssignment assignment : overdueAssignments) {
            // Skip if already notified
            if (assignment.getOverdueNotifiedAt() != null) {
                continue;
            }

            String complianceName = getComplianceName(assignment);
            String employeeName = getUserName(assignment.getEmployeeId());
            Long companyId = getCompanyIdFromAssignment(assignment);
            String companyName = getCompanyNameFromAssignment(assignment);

            // 1. Push to employee
            notificationEventService.notifyUserPushOnly(
                    assignment.getEmployeeId(),
                    "Compliance Overdue",
                    "Your assigned compliance \"" + complianceName + "\" is overdue.",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "employee_compliance"
            );

            // 2. Push to company admin
            if (companyId != null) {
                var companyAdmin = companyRepository.findById(companyId)
                        .map(Company::getCompanyAdmin).orElse(null);
                if (companyAdmin != null) {
                    notificationEventService.notifyUserPushOnly(
                            companyAdmin.getId(),
                            "Compliance Overdue",
                            "Company " + companyName + " has overdue compliance \"" + complianceName + "\" (assigned to " + employeeName + ").",
                            NotificationType.COMPLIANCE_OVERDUE,
                            "compliance_details"
                    );
                }
            }

            // 3. Push to SuperAdmins
            notificationEventService.notifySuperAdminsPushOnly(
                    "Compliance Overdue",
                    "Company " + companyName + " is overdue on compliance \"" + complianceName + "\" (Employee: " + employeeName + ").",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "compliance_details"
            );

            // Mark as notified
            assignment.setOverdueNotifiedAt(LocalDateTime.now());
            assignment.setIsOverdue(true);
            assignmentRepository.save(assignment);
        }

        log.info("Overdue employee notifications sent for {} assignments.", overdueAssignments.size());
    }

    // ─── 3. DUE REMINDERS (Push Notifications - 3x Daily) ───────────────────
    @Scheduled(cron = "0 0 9,14,19 * * *") // 3 times daily at 09:00, 14:00, 19:00
    @Transactional
    public void sendDueReminders() {
        log.info("Checking due reminders (3x daily schedule)...");
        LocalDate today = LocalDate.now();
        LocalDate future = today.plusDays(60);

        List<EmployeeAssignment> upcomingAssignments = assignmentRepository
                .findActiveUpcomingAssignments(today, future);

        if (upcomingAssignments.isEmpty()) {
            log.info("No upcoming assignments for reminders.");
            return;
        }

        log.info("Found {} upcoming assignments for reminder check", upcomingAssignments.size());

        for (EmployeeAssignment assignment : upcomingAssignments) {
            var config = assignment.getConfig();
            if (config == null) continue;
            LocalDate dueDate = assignment.getDueDate();
            if (dueDate == null || !dueDate.isAfter(today)) continue;

            int reminderDays = config.getReminderDaysBefore() != null ? config.getReminderDaysBefore() : 10;
            int intervalDays = (config.getReminderIntervalDays() != null && config.getReminderIntervalDays() > 0) ? config.getReminderIntervalDays() : 3;
            long daysRemaining = ChronoUnit.DAYS.between(today, dueDate);

            // Check if today falls on the reminder schedule (e.g. 10 days before, then every 3 days: 10, 7, 4, 1)
            boolean shouldSend = (daysRemaining == reminderDays) ||
                    (daysRemaining < reminderDays && (reminderDays - daysRemaining) % intervalDays == 0);

            if (shouldSend) {
                String complianceName = getComplianceName(assignment);
                String employeeName = getUserName(assignment.getEmployeeId());
                Long companyId = getCompanyIdFromAssignment(assignment);

                // Push to assigned employee
                notificationEventService.notifyUserPushOnly(
                        assignment.getEmployeeId(),
                        "Compliance Due Soon",
                        "Compliance \"" + complianceName + "\" is due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + ".",
                        NotificationType.COMPLIANCE_DUE_SOON,
                        "employee_compliance"
                );

                // Push to company admin
                if (companyId != null) {
                    var companyAdmin = companyRepository.findById(companyId)
                            .map(Company::getCompanyAdmin).orElse(null);
                    if (companyAdmin != null) {
                        notificationEventService.notifyUserPushOnly(
                                companyAdmin.getId(),
                                "Compliance Due Soon",
                                "Employee " + employeeName + " has compliance \"" + complianceName + "\" due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + ".",
                                NotificationType.COMPLIANCE_DUE_SOON,
                                "compliance_details"
                        );
                    }
                }

                assignment.setLastReminderSent(today);
                assignmentRepository.save(assignment);
            }
        }

        log.info("Due reminders processed successfully.");
    }

    // ─── 4. OVERDUE COMPANY COMPLIANCES (Email to SuperAdmin) ──────────────
    @Scheduled(cron = "0 0 9 * * *") // daily at 09:00
    @Transactional
    public void checkOverdueCompanyCompliances() {
        log.info("Checking overdue company compliances...");

        LocalDate today = LocalDate.now();

        // Find all active CompanyCompliances that are not completed and have effective due date < today
        List<CompanyCompliance> overdueCCs = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED)
                .filter(cc -> cc.getStatus() != ComplianceStatus.EXEMPTED)
                .filter(cc -> cc.getIsActive() && !cc.isDeleted())
                .filter(cc -> cc.getConfig() != null)
                .filter(cc -> {
                    LocalDate due = complianceService.calculateEffectiveDueDate(cc.getConfig());
                    return due != null && due.isBefore(today);
                })
                .collect(Collectors.toList());

        if (overdueCCs.isEmpty()) {
            log.info("No overdue company compliances.");
            return;
        }

        // Build email content
        List<EmailService.OverdueComplianceInfo> overdueList = new ArrayList<>();
        for (CompanyCompliance cc : overdueCCs) {
            EmailService.OverdueComplianceInfo info = new EmailService.OverdueComplianceInfo();
            info.setCompanyName(cc.getCompany().getName());
            info.setComplianceName(cc.getTemplate().getName());
            info.setSubComplianceName(cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : null);
            LocalDate due = complianceService.calculateEffectiveDueDate(cc.getConfig());
            info.setDueDate(due);
            info.setOverdueDays((int) ChronoUnit.DAYS.between(due, today));
            info.setAssignedTo("Company Admin");
            overdueList.add(info);
        }

        // Send email to SuperAdmin
        User superAdmin = userRepository.findAllByRoleAndDeletedFalse(UserRole.SUPER_ADMIN).stream().findFirst().orElse(null);
        if (superAdmin != null && !overdueList.isEmpty()) {
            emailService.sendOverdueEmailToSuperAdmin(superAdmin.getEmail(), overdueList);
            log.info("Overdue company compliance email sent to SuperAdmin.");
        }
    }

    // ─── HELPER METHODS ──────────────────────────────────────────────────────

    private String getComplianceName(EmployeeAssignment assignment) {
        if (assignment == null) return "Compliance";
        var config = assignment.getConfig();
        if (config == null) return "Compliance";
        if (config.getSubTemplate() != null) return config.getSubTemplate().getName();
        if (config.getTemplate() != null) return config.getTemplate().getName();
        var cc = config.getCompanyCompliance();
        if (cc != null) {
            if (cc.getSubTemplate() != null) return cc.getSubTemplate().getName();
            if (cc.getTemplate() != null) return cc.getTemplate().getName();
        }
        return "Compliance";
    }

    private String getUserName(Long userId) {
        if (userId == null) return "Employee";
        return userRepository.findById(userId).map(User::getFullName).orElse("Employee");
    }

    private Long getCompanyIdFromAssignment(EmployeeAssignment assignment) {
        if (assignment == null) return null;
        var config = assignment.getConfig();
        if (config == null) return null;
        var cc = config.getCompanyCompliance();
        if (cc == null) return null;
        var company = cc.getCompany();
        if (company == null) return null;
        return company.getId();
    }

    private String getCompanyNameFromAssignment(EmployeeAssignment assignment) {
        if (assignment == null) return "Company";
        var config = assignment.getConfig();
        if (config == null) return "Company";
        var cc = config.getCompanyCompliance();
        if (cc == null) return "Company";
        var company = cc.getCompany();
        if (company == null) return "Company";
        return company.getName();
    }
}