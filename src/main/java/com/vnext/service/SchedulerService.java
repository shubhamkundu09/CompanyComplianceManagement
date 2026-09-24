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
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SchedulerService {

    public static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");

    private final EmployeeAssignmentRepository assignmentRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final ComplianceService complianceService;
    private final ComplianceConfigRepository configRepository;
    private final NotificationEventService notificationEventService;
    private final CompanyRepository companyRepository;
    private final NotificationScheduleConfigRepository scheduleConfigRepository;

    // ─── 1. RECURRING COMPLIANCE RENEWAL ──────────────────────────────────────
    @Scheduled(cron = "0 5 0 * * *", zone = "Asia/Kolkata") // daily at 00:05 IST
    @Transactional
    public void renewCompletedRecurringCompliances() {
        log.info("Running recurring compliance renewal check...");

        LocalDate today = LocalDate.now(IST_ZONE);

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
            if (lastDueDate == null) {
                lastDueDate = complianceService.calculateEffectiveDueDate(config);
            }
            if (lastDueDate == null) continue;

            LocalDate nextDueDate = complianceService.getNextDueDateForCompliance(cc);
            if (nextDueDate == null) continue;

            // Renew when completed compliance has reached or passed its due date
            boolean shouldRenew = today.isAfter(lastDueDate) || (today.getDayOfMonth() == 1 && !today.isBefore(lastDueDate));
            if (!shouldRenew) continue;

            log.info("Renewing compliance ID: {} for company: {}", cc.getId(), cc.getCompany().getName());

            // Update config due date
            config.setDueDate(nextDueDate);
            config.setCustomDueDate(nextDueDate);
            config.setUpdatedAt(LocalDateTime.now(IST_ZONE));
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
                    old.setLastReminderSent(null);
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
                    newAssign.setAssignedAt(LocalDateTime.now(IST_ZONE));
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

    // ─── 2. OVERDUE EMPLOYEE COMPLIANCES (Push Notifications to SuperAdmin, CompanyAdmin & Employee) ──────────────
    @Scheduled(cron = "0 30 8 * * *", zone = "Asia/Kolkata") // daily at 08:30 IST
    @Transactional
    public void checkOverdueEmployeeCompliances() {
        log.info("Checking overdue employee compliances...");
        LocalDate today = LocalDate.now(IST_ZONE);

        List<EmployeeAssignment> overdueAssignments = assignmentRepository
                .findByDueDateBeforeAndCompletedAtIsNullAndIsActiveTrue(today);

        if (overdueAssignments.isEmpty()) {
            log.info("No overdue employee assignments found.");
            return;
        }

        log.info("Found {} overdue assignments", overdueAssignments.size());

        for (EmployeeAssignment assignment : overdueAssignments) {
            var config = assignment.getConfig();
            int intervalDays = (config != null && config.getReminderIntervalDays() != null && config.getReminderIntervalDays() > 0) ? config.getReminderIntervalDays() : 3;
            boolean repeat = (config == null || config.getRepeatReminder() == null || Boolean.TRUE.equals(config.getRepeatReminder()));

            // Check if already notified and whether repeat interval has elapsed
            if (assignment.getOverdueNotifiedAt() != null) {
                if (!repeat) {
                    continue;
                }
                long daysSinceLast = ChronoUnit.DAYS.between(assignment.getOverdueNotifiedAt().toLocalDate(), today);
                if (daysSinceLast < intervalDays) {
                    continue;
                }
            }

            String complianceName = getComplianceName(assignment);
            String employeeName = getUserName(assignment.getEmployeeId());
            Long companyId = getCompanyIdFromAssignment(assignment);
            String companyName = getCompanyNameFromAssignment(assignment);
            LocalDate dueDate = assignment.getDueDate();

            // 1. Push to assigned employee
            notificationEventService.notifyUserPushOnly(
                    assignment.getEmployeeId(),
                    "Compliance Overdue",
                    "Your assigned compliance \"" + complianceName + "\" was due on " + (dueDate != null ? dueDate.toString() : "schedule") + " and is now overdue.",
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

            // 3. Push to all SuperAdmins
            notificationEventService.notifySuperAdminsPushOnly(
                    "Compliance Overdue",
                    "Company " + companyName + " is overdue on compliance \"" + complianceName + "\" (Employee: " + employeeName + ").",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "compliance_details"
            );

            // Mark as notified
            assignment.setOverdueNotifiedAt(LocalDateTime.now(IST_ZONE));
            assignment.setIsOverdue(true);
            assignmentRepository.save(assignment);
        }

        log.info("Overdue employee notifications sent for {} assignments.", overdueAssignments.size());
    }

    // ─── 3. DUE REMINDERS — DB-CONFIG-DRIVEN POLLER ─────────────────────────────
    /**
     * Polls every 5 minutes (configurable via scheduler.poll.interval-ms) and sends
     * due-reminder notifications if the current IST time falls inside one of the
     * evenly-distributed daily slots defined in NotificationScheduleConfig.
     *
     * Configuration key: "DUE_REMINDER"
     * Defaults if the DB row does not yet exist:
     *   enabled=true, timesPerDay=3, startHour=9, endHour=19
     *
     * Idempotency: sentTodayCount tracks how many slots have already fired today.
     */
    @Scheduled(fixedDelayString = "${scheduler.poll.interval-ms:30000}", initialDelay = 10000)
    @Transactional
    public void sendDueReminders() {
        LocalDateTime nowIst = LocalDateTime.now(IST_ZONE);
        LocalDate todayIst = nowIst.toLocalDate();

        // ── Load or create the DUE_REMINDER schedule config ──────────────────
        NotificationScheduleConfig cfg = scheduleConfigRepository
                .findByNotificationType("DUE_REMINDER")
                .orElseGet(() -> scheduleConfigRepository.findByNotificationType("FCM_DUE_REMINDER")
                        .orElseGet(() -> {
                            NotificationScheduleConfig seed = new NotificationScheduleConfig();
                            seed.setNotificationType("DUE_REMINDER");
                            seed.setEnabled(true);
                            seed.setTimesPerDay(3);
                            seed.setStartHour(8);
                            seed.setEndHour(20);
                            seed.setSentTodayCount(0);
                            return scheduleConfigRepository.save(seed);
                        }));

        if (!Boolean.TRUE.equals(cfg.getEnabled())) {
            log.debug("DUE_REMINDER schedule is disabled — skipping.");
            return;
        }

        int timesPerDay = Math.max(1, Math.min(20, cfg.getTimesPerDay() != null ? cfg.getTimesPerDay() : 3));
        int startHour   = cfg.getStartHour()  != null ? cfg.getStartHour()  : 8;
        int endHour     = cfg.getEndHour()    != null ? cfg.getEndHour()    : 20;

        // Start-of-day anchor
        LocalDateTime dayStart = todayIst.atTime(startHour, 0);

        // ── Reset today counter if date changed or last send was before today's window start ───
        if (!todayIst.equals(cfg.getLastSentDate()) || (cfg.getLastSentAt() != null && cfg.getLastSentAt().isBefore(dayStart))) {
            cfg.setLastSentDate(todayIst);
            cfg.setSentTodayCount(0);
            cfg.setLastSentAt(null);
        }

        if (cfg.getSentTodayCount() != null && cfg.getSentTodayCount() > timesPerDay) {
            cfg.setSentTodayCount(0);
        }

        // ── Already sent the full quota for today? ────────────────────────────
        if (cfg.getSentTodayCount() >= timesPerDay) {
            log.debug("DUE_REMINDER: already sent {} / {} times today — skipping.", cfg.getSentTodayCount(), timesPerDay);
            return;
        }

        // ── Check if within active hours ──────────────────────────────────────
        int currentHour = nowIst.getHour();
        if (currentHour < startHour || currentHour > endHour) {
            log.debug("DUE_REMINDER: current hour {} outside active window [{} – {}] — skipping.",
                    currentHour, startHour, endHour);
            return;
        }

        // Within endHour — allow last slot to fire even if current minute is past endHour:00
        // This handles e.g. endHour=16, last slot at 16:00 firing at 16:01

        // Interval in minutes between consecutive slots
        double intervalMinutes = timesPerDay <= 1
                ? 0
                : ((endHour - startHour) * 60.0) / (timesPerDay - 1);

        // Determine which slot index corresponds to current time
        long minutesFromStart = Math.max(0, java.time.Duration.between(dayStart, nowIst).toMinutes());
        int expectedSlotIndex = timesPerDay <= 1 ? 0 : (int) Math.floor(minutesFromStart / (intervalMinutes > 0 ? intervalMinutes : 1.0));
        expectedSlotIndex = Math.max(0, Math.min(timesPerDay - 1, expectedSlotIndex));

        int currentSentCount = cfg.getSentTodayCount() != null ? cfg.getSentTodayCount() : 0;

        // If this slot has already fired today, wait for the next scheduled slot
        if (currentSentCount > expectedSlotIndex) {
            log.debug("DUE_REMINDER slot {}/{} already sent (currentSentCount={}) — waiting for next slot.",
                    expectedSlotIndex + 1, timesPerDay, currentSentCount);
            return;
        }

        LocalDateTime slotTime = timesPerDay <= 1
                ? dayStart
                : dayStart.plusMinutes(Math.round(intervalMinutes * expectedSlotIndex));

        // Enforce cooldown between consecutive slot triggers (in seconds)
        if (cfg.getLastSentAt() != null) {
            long secondsSinceLast = java.time.Duration.between(cfg.getLastSentAt(), nowIst).getSeconds();
            long minCooldownSeconds = Math.max(30, Math.min(1800, Math.round(intervalMinutes * 60.0 * 0.45)));
            if (secondsSinceLast < minCooldownSeconds) {
                log.debug("DUE_REMINDER cooldown active (last sent {}s ago, min cooldown {}s) — skipping.",
                        secondsSinceLast, minCooldownSeconds);
                return;
            }
        }

        log.info("DUE_REMINDER: firing slot {}/{} (slot expected {}, now {})", expectedSlotIndex + 1, timesPerDay, slotTime, nowIst);

        // ── Claim the slot immediately to prevent duplicate sends ─────────────
        cfg.setSentTodayCount(expectedSlotIndex + 1);
        cfg.setLastSentAt(nowIst);
        cfg.setLastSentDate(todayIst);
        scheduleConfigRepository.save(cfg);

        // ── Execute reminder checks ──────────────────────────────────────────
        executeDueReminderChecks();
    }

    /**
     * Executes the actual due and overdue reminder check for both employee assignments
     * and company-level compliances.
     */
    @Transactional
    public void executeDueReminderChecks() {
        LocalDate today = LocalDate.now(IST_ZONE);
        LocalDate future = today.plusDays(60);

        log.info("Checking compliance due and overdue reminders for date: {}...", today);

        // ── 1. EMPLOYEE ASSIGNMENTS (Due Soon & Due Today) ──
        List<EmployeeAssignment> upcomingAssignments = assignmentRepository
                .findActiveUpcomingAssignments(today, future);

        log.info("Found {} upcoming/due-today employee assignments for reminder check", upcomingAssignments.size());

        for (EmployeeAssignment assignment : upcomingAssignments) {
            var config = assignment.getConfig();
            if (config == null) continue;
            LocalDate dueDate = assignment.getDueDate();
            if (dueDate == null) continue;

            String complianceName = getComplianceName(assignment);
            String employeeName = getUserName(assignment.getEmployeeId());
            Long companyId = getCompanyIdFromAssignment(assignment);
            String companyName = getCompanyNameFromAssignment(assignment);
            List<Long> companyAdminIds = notificationEventService.getCompanyAdminUserIds(companyId);

            if (dueDate.equals(today)) {
                // DUE TODAY
                notificationEventService.notifyUserPushOnly(
                        assignment.getEmployeeId(),
                        "Compliance Due TODAY",
                        "Compliance \"" + complianceName + "\" is DUE TODAY (" + today + ")! Please complete and submit.",
                        NotificationType.COMPLIANCE_DUE_SOON,
                        "employee_compliance"
                );

                if (!companyAdminIds.isEmpty()) {
                    notificationEventService.notifyUsersPushOnly(
                            companyAdminIds,
                            "Compliance Due TODAY",
                            "Employee " + employeeName + " has compliance \"" + complianceName + "\" DUE TODAY (" + today + ").",
                            NotificationType.COMPLIANCE_DUE_SOON,
                            "compliance_details"
                    );
                }
                notificationEventService.notifySuperAdminsPushOnly(
                        "Compliance Due TODAY",
                        "Company " + companyName + " has compliance \"" + complianceName + "\" (Employee: " + employeeName + ") DUE TODAY (" + today + ").",
                        NotificationType.COMPLIANCE_DUE_SOON,
                        "compliance_details"
                );
                assignment.setLastReminderSent(today);
                assignmentRepository.save(assignment);
            } else if (dueDate.isAfter(today)) {
                // DUE SOON (NEARBY)
                int reminderDays = config.getReminderDaysBefore() != null ? config.getReminderDaysBefore() : 10;
                long daysRemaining = ChronoUnit.DAYS.between(today, dueDate);
                boolean shouldSend = (daysRemaining <= reminderDays);

                if (shouldSend) {
                    notificationEventService.notifyUserPushOnly(
                            assignment.getEmployeeId(),
                            "Compliance Due Soon",
                            "Compliance \"" + complianceName + "\" is due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + " (" + dueDate + ").",
                            NotificationType.COMPLIANCE_DUE_SOON,
                            "employee_compliance"
                    );

                    if (!companyAdminIds.isEmpty()) {
                        notificationEventService.notifyUsersPushOnly(
                                companyAdminIds,
                                "Compliance Due Soon",
                                "Employee " + employeeName + " has compliance \"" + complianceName + "\" due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + " (" + dueDate + ").",
                                NotificationType.COMPLIANCE_DUE_SOON,
                                "compliance_details"
                        );
                    }

                    notificationEventService.notifySuperAdminsPushOnly(
                            "Compliance Due Soon",
                            "Company " + companyName + " has compliance \"" + complianceName + "\" (Employee: " + employeeName + ") due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + ".",
                            NotificationType.COMPLIANCE_DUE_SOON,
                            "compliance_details"
                    );

                    assignment.setLastReminderSent(today);
                    assignmentRepository.save(assignment);
                }
            }
        }

        // ── 2. EMPLOYEE ASSIGNMENTS (Overdue) ──
        List<EmployeeAssignment> overdueAssignments = assignmentRepository
                .findByDueDateBeforeAndCompletedAtIsNullAndIsActiveTrue(today);

        log.info("Found {} overdue employee assignments for reminder check", overdueAssignments.size());

        for (EmployeeAssignment assignment : overdueAssignments) {
            LocalDate dueDate = assignment.getDueDate();
            if (dueDate == null) continue;

            long daysOverdue = ChronoUnit.DAYS.between(dueDate, today);
            String complianceName = getComplianceName(assignment);
            String employeeName = getUserName(assignment.getEmployeeId());
            Long companyId = getCompanyIdFromAssignment(assignment);
            String companyName = getCompanyNameFromAssignment(assignment);
            List<Long> companyAdminIds = notificationEventService.getCompanyAdminUserIds(companyId);

            notificationEventService.notifyUserPushOnly(
                    assignment.getEmployeeId(),
                    "Compliance OVERDUE",
                    "Compliance \"" + complianceName + "\" was due on " + dueDate + " and is OVERDUE by " + daysOverdue + " day" + (daysOverdue == 1 ? "" : "s") + "! Immediate submission required.",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "employee_compliance"
            );

            if (!companyAdminIds.isEmpty()) {
                notificationEventService.notifyUsersPushOnly(
                        companyAdminIds,
                        "Compliance OVERDUE",
                        "Employee " + employeeName + " has overdue compliance \"" + complianceName + "\" (" + daysOverdue + " day" + (daysOverdue == 1 ? "" : "s") + " overdue).",
                        NotificationType.COMPLIANCE_OVERDUE,
                        "compliance_details"
                );
            }

            notificationEventService.notifySuperAdminsPushOnly(
                    "Compliance OVERDUE",
                    "Company " + companyName + " has overdue compliance \"" + complianceName + "\" (Employee: " + employeeName + ", " + daysOverdue + " day" + (daysOverdue == 1 ? "" : "s") + " overdue).",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "compliance_details"
            );
        }

        // ── 3. COMPANY-LEVEL COMPLIANCES (Due Soon, Due Today & Overdue) ──
        List<CompanyCompliance> activeCompanyCompliances = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED)
                .filter(cc -> cc.getStatus() != ComplianceStatus.EXEMPTED)
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .collect(Collectors.toList());

        log.info("Found {} active company compliance records for reminder evaluation", activeCompanyCompliances.size());

        for (CompanyCompliance cc : activeCompanyCompliances) {
            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
            }
            if (config == null && cc.getTemplate() != null) {
                config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
            }
            if (config == null) {
                continue;
            }

            LocalDate dueDate = config.getDueDate();
            if (dueDate == null) {
                dueDate = config.getCustomDueDate();
            }
            if (dueDate == null) {
                dueDate = complianceService.calculateEffectiveDueDate(config);
            }
            if (dueDate == null) {
                continue;
            }

            String complianceTitle = cc.getSubTemplate() != null
                    ? cc.getSubTemplate().getName()
                    : (cc.getTemplate() != null ? cc.getTemplate().getName() : "Compliance");
            Long companyId = cc.getCompany() != null ? cc.getCompany().getId() : null;
            String companyName = cc.getCompany() != null ? cc.getCompany().getName() : "Company";
            List<Long> companyAdminIds = notificationEventService.getCompanyAdminUserIds(companyId);

            if (dueDate.equals(today)) {
                // DUE TODAY
                log.info("Sending DUE TODAY reminder for compliance '{}' (ID: {}) to company '{}'", complianceTitle, cc.getId(), companyName);
                if (!companyAdminIds.isEmpty()) {
                    notificationEventService.notifyUsersPushOnly(
                            companyAdminIds,
                            "Compliance Due TODAY",
                            "Company compliance \"" + complianceTitle + "\" is DUE TODAY (" + today + "). Please complete and submit.",
                            NotificationType.COMPLIANCE_DUE_SOON,
                            "compliance_details"
                    );
                }
                notificationEventService.notifySuperAdminsPushOnly(
                        "Company Compliance Due TODAY",
                        "Company " + companyName + " compliance \"" + complianceTitle + "\" is DUE TODAY (" + today + ").",
                        NotificationType.COMPLIANCE_DUE_SOON,
                        "compliance_details"
                );
            } else if (dueDate.isBefore(today)) {
                // OVERDUE
                long daysOverdue = ChronoUnit.DAYS.between(dueDate, today);
                log.info("Sending OVERDUE reminder for compliance '{}' (ID: {}, {} days overdue) to company '{}'", complianceTitle, cc.getId(), daysOverdue, companyName);
                if (!companyAdminIds.isEmpty()) {
                    notificationEventService.notifyUsersPushOnly(
                            companyAdminIds,
                            "Compliance OVERDUE",
                            "Company compliance \"" + complianceTitle + "\" was due on " + dueDate + " and is OVERDUE by " + daysOverdue + " day" + (daysOverdue == 1 ? "" : "s") + "! Immediate action required.",
                            NotificationType.COMPLIANCE_OVERDUE,
                            "compliance_details"
                    );
                }
                notificationEventService.notifySuperAdminsPushOnly(
                        "Company Compliance OVERDUE",
                        "Company " + companyName + " compliance \"" + complianceTitle + "\" is OVERDUE by " + daysOverdue + " day" + (daysOverdue == 1 ? "" : "s") + " (" + dueDate + ").",
                        NotificationType.COMPLIANCE_OVERDUE,
                        "compliance_details"
                );
            } else if (dueDate.isAfter(today) && !dueDate.isAfter(future)) {
                // DUE SOON
                int reminderDays = config.getReminderDaysBefore() != null ? config.getReminderDaysBefore() : 10;
                long daysRemaining = ChronoUnit.DAYS.between(today, dueDate);
                boolean shouldSend = (daysRemaining <= reminderDays);

                if (shouldSend) {
                    log.info("Sending DUE SOON reminder for compliance '{}' (ID: {}, due in {} days) to company '{}'", complianceTitle, cc.getId(), daysRemaining, companyName);
                    if (!companyAdminIds.isEmpty()) {
                        notificationEventService.notifyUsersPushOnly(
                                companyAdminIds,
                                "Compliance Due Soon",
                                "Company compliance \"" + complianceTitle + "\" is due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + " (" + dueDate + ").",
                                NotificationType.COMPLIANCE_DUE_SOON,
                                "compliance_details"
                        );
                    }
                    notificationEventService.notifySuperAdminsPushOnly(
                            "Compliance Due Soon",
                            "Company " + companyName + " compliance \"" + complianceTitle + "\" is due in " + daysRemaining + " day" + (daysRemaining == 1 ? "" : "s") + " (" + dueDate + ").",
                            NotificationType.COMPLIANCE_DUE_SOON,
                            "compliance_details"
                    );
                }
            }
        }

        log.info("Due and overdue reminders processed successfully.");
    }

    // ─── 4. OVERDUE COMPANY COMPLIANCES (Email & Push to SuperAdmin & Company Admin) ──────────────
    @Scheduled(cron = "0 0 9 * * *", zone = "Asia/Kolkata") // daily at 09:00 IST
    @Transactional
    public void checkOverdueCompanyCompliances() {
        log.info("Checking overdue company compliances...");

        LocalDate today = LocalDate.now(IST_ZONE);

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

        // Build email content and send FCM notifications
        List<EmailService.OverdueComplianceInfo> overdueList = new ArrayList<>();
        for (CompanyCompliance cc : overdueCCs) {
            String complianceTitle = cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : (cc.getTemplate() != null ? cc.getTemplate().getName() : "Compliance");
            String companyName = cc.getCompany() != null ? cc.getCompany().getName() : "Company";
            LocalDate due = complianceService.calculateEffectiveDueDate(cc.getConfig());

            EmailService.OverdueComplianceInfo info = new EmailService.OverdueComplianceInfo();
            info.setCompanyName(companyName);
            info.setComplianceName(cc.getTemplate() != null ? cc.getTemplate().getName() : complianceTitle);
            info.setSubComplianceName(cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : null);
            info.setDueDate(due);
            info.setOverdueDays(due != null ? (int) ChronoUnit.DAYS.between(due, today) : 0);
            info.setAssignedTo("Company Admin");
            overdueList.add(info);

            // Push to Company Admin
            if (cc.getCompany() != null && cc.getCompany().getCompanyAdmin() != null) {
                notificationEventService.notifyUserPushOnly(
                        cc.getCompany().getCompanyAdmin().getId(),
                        "Compliance Overdue",
                        "Your company compliance \"" + complianceTitle + "\" is overdue.",
                        NotificationType.COMPLIANCE_OVERDUE,
                        "compliance_details"
                );
            }

            // Push to SuperAdmins
            notificationEventService.notifySuperAdminsPushOnly(
                    "Company Compliance Overdue",
                    "Company " + companyName + " has overdue compliance \"" + complianceTitle + "\".",
                    NotificationType.COMPLIANCE_OVERDUE,
                    "compliance_details"
            );
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