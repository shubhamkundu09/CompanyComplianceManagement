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
import java.util.Objects;
import java.util.Optional;
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
    private final UserPushNotificationRepository userPushNotificationRepository;
    private final ComplianceSubTemplateRepository subTemplateRepository;

    // ─── AUTO-PURGE PUSH NOTIFICATIONS OLDER THAN 5 MINUTES ──────────────────
    @Scheduled(fixedRate = 60000, initialDelay = 5000) // runs every 60 seconds
    @Transactional
    public void purgeStalePushNotifications() {
        LocalDateTime cutoff = LocalDateTime.now(IST_ZONE).minusMinutes(5);
        try {
            userPushNotificationRepository.deleteOlderThan(cutoff);
            log.debug("Auto-purged user push notifications older than 5 minutes (cutoff: {})", cutoff);
        } catch (Exception e) {
            log.warn("Failed to purge stale push notifications: {}", e.getMessage());
        }
    }

    // ─── 1. RECURRING COMPLIANCE RENEWAL ──────────────────────────────────────
    @Scheduled(cron = "0 5 0 * * *", zone = "Asia/Kolkata") // daily at 00:05 IST
    @Transactional
    public void renewCompletedRecurringCompliances() {
        log.info("Running recurring compliance renewal check...");

        LocalDate today = LocalDate.now(IST_ZONE);

        // Find all completed recurring compliances
        List<CompanyCompliance> completedRecurring = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() == ComplianceStatus.COMPLETED)
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> !isParentWithSubCompliances(cc))
                .collect(Collectors.toList());

        if (completedRecurring.isEmpty()) {
            log.info("No completed recurring compliances to renew.");
            return;
        }

        for (CompanyCompliance cc : completedRecurring) {
            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null || config.getFrequency() == null || config.getFrequency() == ComplianceFrequency.ONE_TIME) {
                continue;
            }

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

            log.info("Renewing compliance ID: {} for company: {}", cc.getId(), cc.getCompany() != null ? cc.getCompany().getName() : "N/A");

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
            } else if (cc.getCompany() != null) {
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
            // Skip parent container assignments if sub-compliances exist
            if (isAssignmentForParentWithSubCompliances(assignment)) {
                continue;
            }

            // Skip if already completed (directly, via CompanyCompliance, or by another employee)
            if (isAssignmentCompleted(assignment)) {
                continue;
            }

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
            // Skip parent container assignments if sub-compliances exist
            if (isAssignmentForParentWithSubCompliances(assignment)) {
                continue;
            }

            // Skip if already completed (directly or via CompanyCompliance / other employee)
            if (isAssignmentCompleted(assignment)) {
                continue;
            }

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
                // DUE TODAY — notify Employee + Company Admin only (not SuperAdmin)
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
                assignment.setLastReminderSent(today);
                assignmentRepository.save(assignment);
            } else if (dueDate.isAfter(today)) {
                // DUE SOON (NEARBY)
                int reminderDays = config.getReminderDaysBefore() != null ? config.getReminderDaysBefore() : 10;
                long daysRemaining = ChronoUnit.DAYS.between(today, dueDate);
                boolean shouldSend = (daysRemaining <= reminderDays);

                if (shouldSend) {
                    // DUE SOON — notify Employee + Company Admin only (not SuperAdmin)
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

                    assignment.setLastReminderSent(today);
                    assignmentRepository.save(assignment);
                }
            }
        }

        // ── 2. EMPLOYEE ASSIGNMENTS (Overdue) ──
        List<EmployeeAssignment> overdueAssignments = assignmentRepository
                .findByDueDateBeforeAndCompletedAtIsNullAndIsActiveTrue(today);

        log.info("Found {} overdue employee assignments for reminder check", overdueAssignments.size());
        java.util.Set<Long> notifiedCompanyComplianceIds = new java.util.HashSet<>();
        java.util.Set<Long> notifiedConfigIds = new java.util.HashSet<>();

        for (EmployeeAssignment assignment : overdueAssignments) {
            // Skip parent container assignments if sub-compliances exist
            if (isAssignmentForParentWithSubCompliances(assignment)) {
                continue;
            }

            // Skip if already completed (directly or via CompanyCompliance / other employee)
            if (isAssignmentCompleted(assignment)) {
                continue;
            }

            LocalDate dueDate = assignment.getDueDate();
            if (dueDate == null) continue;

            if (assignment.getConfig() != null) {
                notifiedConfigIds.add(assignment.getConfig().getId());
                if (assignment.getConfig().getCompanyCompliance() != null) {
                    notifiedCompanyComplianceIds.add(assignment.getConfig().getCompanyCompliance().getId());
                }
            }

            // Send overdue reminder at most once per day
            if (today.equals(assignment.getLastReminderSent())) {
                continue;
            }

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

            assignment.setLastReminderSent(today);
            assignmentRepository.save(assignment);
        }

        // ── 3. COMPANY-LEVEL COMPLIANCES (Due Soon, Due Today & Overdue) ──
        List<CompanyCompliance> activeCompanyCompliances = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED && cc.getCompletedAt() == null)
                .filter(cc -> cc.getStatus() != ComplianceStatus.EXEMPTED)
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .collect(Collectors.toList());

        log.info("Found {} active company compliance records for reminder evaluation", activeCompanyCompliances.size());

        for (CompanyCompliance cc : activeCompanyCompliances) {
            // Skip parent container compliances when sub-compliances exist
            if (isParentWithSubCompliances(cc)) {
                log.debug("Skipping parent compliance ID: {} ({}) for reminders as sub-compliances exist",
                        cc.getId(), cc.getTemplate() != null ? cc.getTemplate().getName() : "Unknown");
                continue;
            }

            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
                config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
            }
            if (config == null) {
                continue;
            }

            // Skip if completed
            if (isCompanyComplianceCompleted(cc, config)) {
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

            // Skip if this compliance was already notified as an employee assignment in Section 2
            if (notifiedCompanyComplianceIds.contains(cc.getId()) || (config.getId() != null && notifiedConfigIds.contains(config.getId()))) {
                continue;
            }

            String complianceTitle = cc.getSubTemplate() != null
                    ? cc.getSubTemplate().getName()
                    : (cc.getTemplate() != null ? cc.getTemplate().getName() : "Compliance");
            Long companyId = cc.getCompany() != null ? cc.getCompany().getId() : null;
            String companyName = cc.getCompany() != null ? cc.getCompany().getName() : "Company";
            List<Long> companyAdminIds = notificationEventService.getCompanyAdminUserIds(companyId);

            if (dueDate.equals(today)) {
                // DUE TODAY — notify Company Admin only (not SuperAdmin)
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
                    // DUE SOON — notify Company Admin only (not SuperAdmin)
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
                }
            }
        }

        log.info("Due and overdue reminders processed successfully.");
    }

    // ─── 4. OVERDUE COMPANY COMPLIANCES (Email & Push to SuperAdmin & Company Admin) ──────────────
    @Scheduled(cron = "0 0 9 * * *", zone = "Asia/Kolkata") // daily at 09:00 IST
    @Transactional
    public void checkOverdueCompanyCompliances() {
        log.info("Checking overdue company compliances for daily email report...");

        LocalDate today = LocalDate.now(IST_ZONE);

        // Find all active CompanyCompliances that are not completed, not parent containers with sub-compliances, and have effective due date < today
        List<CompanyCompliance> overdueCCs = companyComplianceRepository.findAll().stream()
                .filter(cc -> cc.getStatus() != ComplianceStatus.COMPLETED && cc.getCompletedAt() == null)
                .filter(cc -> cc.getStatus() != ComplianceStatus.EXEMPTED)
                .filter(cc -> Boolean.TRUE.equals(cc.getIsActive()) && !cc.isDeleted())
                .filter(cc -> !isParentWithSubCompliances(cc))
                .filter(cc -> {
                    ComplianceConfig config = cc.getConfig();
                    if (config == null) {
                        config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
                    }
                    if (config == null && cc.getSubTemplate() != null) {
                        config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
                    }
                    if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
                        config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
                    }
                    if (config == null) return false;
                    if (isCompanyComplianceCompleted(cc, config)) return false;
                    LocalDate due = config.getDueDate();
                    if (due == null) due = config.getCustomDueDate();
                    if (due == null) due = complianceService.calculateEffectiveDueDate(config);
                    return due != null && due.isBefore(today);
                })
                .collect(Collectors.toList());

        if (overdueCCs.isEmpty()) {
            log.info("No overdue company compliances.");
            return;
        }

        // Build email content grouped by company
        List<EmailService.OverdueComplianceInfo> masterOverdueList = new ArrayList<>();
        java.util.Map<Long, List<EmailService.OverdueComplianceInfo>> companyOverdueMap = new java.util.HashMap<>();
        java.util.Map<Long, Company> companyMap = new java.util.HashMap<>();

        for (CompanyCompliance cc : overdueCCs) {
            ComplianceConfig config = cc.getConfig();
            if (config == null) {
                config = configRepository.findByCompanyComplianceId(cc.getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() != null) {
                config = configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(cc.getSubTemplate().getId()).orElse(null);
            }
            if (config == null && cc.getSubTemplate() == null && cc.getTemplate() != null) {
                config = configRepository.findByTemplateIdAndCompanyComplianceIsNull(cc.getTemplate().getId()).orElse(null);
            }
            LocalDate due = null;
            if (config != null) {
                due = config.getDueDate() != null ? config.getDueDate() : config.getCustomDueDate();
                if (due == null) due = complianceService.calculateEffectiveDueDate(config);
            }

            String complianceTitle = cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : (cc.getTemplate() != null ? cc.getTemplate().getName() : "Compliance");
            String companyName = cc.getCompany() != null ? cc.getCompany().getName() : "Company";

            EmailService.OverdueComplianceInfo info = new EmailService.OverdueComplianceInfo();
            info.setCompanyName(companyName);
            info.setComplianceName(cc.getTemplate() != null ? cc.getTemplate().getName() : complianceTitle);
            info.setSubComplianceName(cc.getSubTemplate() != null ? cc.getSubTemplate().getName() : null);
            info.setDueDate(due);
            info.setOverdueDays(due != null ? (int) ChronoUnit.DAYS.between(due, today) : 0);
            info.setAssignedTo("Company Admin");
            masterOverdueList.add(info);

            if (cc.getCompany() != null) {
                Long cId = cc.getCompany().getId();
                companyOverdueMap.computeIfAbsent(cId, k -> new ArrayList<>()).add(info);
                companyMap.putIfAbsent(cId, cc.getCompany());
            }
        }

        // Send overdue email report to each Company Admin for their company's items
        for (java.util.Map.Entry<Long, List<EmailService.OverdueComplianceInfo>> entry : companyOverdueMap.entrySet()) {
            Company comp = companyMap.get(entry.getKey());
            if (comp != null && comp.getCompanyAdmin() != null && comp.getCompanyAdmin().getEmail() != null) {
                emailService.sendOverdueEmailToCompanyAdmin(
                        comp.getCompanyAdmin().getEmail(),
                        comp.getCompanyAdmin().getFullName(),
                        comp.getName(),
                        entry.getValue()
                );
            }
        }

        // Send master overdue email report to SuperAdmin
        User superAdmin = userRepository.findAllByRoleAndDeletedFalse(UserRole.SUPER_ADMIN).stream().findFirst().orElse(null);
        if (superAdmin != null && !masterOverdueList.isEmpty()) {
            emailService.sendOverdueEmailToSuperAdmin(superAdmin.getEmail(), masterOverdueList);
            log.info("Master overdue compliance email sent to SuperAdmin.");
        }
    }

    // ─── HELPER METHODS ──────────────────────────────────────────────────────

    /**
     * Checks if a CompanyCompliance is a parent container compliance that groups sub-compliances.
     * Parent container compliances do not represent direct action items and should not trigger
     * due/overdue alerts on their own (only individual sub-compliances trigger alerts).
     */
    private boolean isParentWithSubCompliances(CompanyCompliance cc) {
        if (cc == null || cc.getTemplate() == null) return false;
        // If this is an actual sub-compliance (has subTemplate or isParent is false), it is NOT a parent container
        if (cc.getSubTemplate() != null || Boolean.FALSE.equals(cc.getIsParent())) {
            return false;
        }
        // If this is a parent compliance, check if sub-compliances exist for this company & template
        if (cc.getCompany() != null) {
            List<CompanyCompliance> subs = companyComplianceRepository.findSubCompliancesByCompanyIdAndParentTemplateId(
                    cc.getCompany().getId(), cc.getTemplate().getId());
            if (subs != null && !subs.isEmpty()) {
                return true;
            }
        }
        // Also check if the template has active sub-templates
        if (subTemplateRepository != null) {
            return !subTemplateRepository.findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(cc.getTemplate().getId()).isEmpty();
        }
        return false;
    }

    /**
     * Checks if an EmployeeAssignment belongs to a parent container compliance that groups sub-compliances.
     * Parent container assignments are category containers and should NOT trigger individual due/overdue alerts.
     */
    private boolean isAssignmentForParentWithSubCompliances(EmployeeAssignment assignment) {
        if (assignment == null) return false;
        if (assignmentRepository.existsByParentAssignmentIdAndIsActiveTrue(assignment.getId())) {
            return true;
        }
        var config = assignment.getConfig();
        if (config == null) return false;

        if (Boolean.TRUE.equals(assignment.getIsSubAssignment()) || config.getSubTemplate() != null) {
            return false;
        }

        if (config.getCompanyCompliance() != null) {
            CompanyCompliance cc = config.getCompanyCompliance();
            if (isParentWithSubCompliances(cc)) {
                return true;
            }
        }

        if (config.getTemplate() != null && subTemplateRepository != null) {
            return !subTemplateRepository.findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(config.getTemplate().getId()).isEmpty();
        }

        return false;
    }

    /**
     * Checks whether an EmployeeAssignment is completed, either directly or via its underlying CompanyCompliance
     * or via another employee in the company who completed the same compliance config.
     */
    private boolean isAssignmentCompleted(EmployeeAssignment assignment) {
        if (assignment == null) return false;
        if (assignment.getCompletedAt() != null) return true;

        var config = assignment.getConfig();
        if (config == null) return false;

        // Check if company compliance is marked completed
        CompanyCompliance cc = config.getCompanyCompliance();
        if (cc != null && (cc.getStatus() == ComplianceStatus.COMPLETED || cc.getCompletedAt() != null)) {
            assignment.setCompletedAt(cc.getCompletedAt() != null ? cc.getCompletedAt() : LocalDateTime.now(IST_ZONE));
            if (cc.getCompletedBy() != null) assignment.setCompletedBy(cc.getCompletedBy());
            if (cc.getAdminSubmissionReference() != null) assignment.setSubmissionReference(cc.getAdminSubmissionReference());
            if (cc.getAdminSubmissionDocumentUrl() != null) assignment.setSubmissionDocumentUrl(cc.getAdminSubmissionDocumentUrl());
            assignmentRepository.save(assignment);
            return true;
        }

        // Check if any employee completed this config
        if (assignmentRepository.isConfigCompletedByAnyEmployee(config.getId())) {
            assignmentRepository.findCompletedAssignmentByConfigId(config.getId()).ifPresent(done -> {
                assignment.setCompletedAt(done.getCompletedAt());
                assignment.setCompletedBy(done.getCompletedBy());
                assignment.setSubmissionReference(done.getSubmissionReference());
                assignment.setSubmissionDocumentUrl(done.getSubmissionDocumentUrl());
                assignmentRepository.save(assignment);
            });
            return true;
        }

        return false;
    }

    /**
     * Checks whether a CompanyCompliance is completed, either via its status/completedAt or via any employee assignment.
     */
    private boolean isCompanyComplianceCompleted(CompanyCompliance cc, ComplianceConfig config) {
        if (cc == null) return false;
        if (cc.getStatus() == ComplianceStatus.COMPLETED || cc.getCompletedAt() != null) {
            return true;
        }

        if (config != null) {
            if (assignmentRepository.isConfigCompletedByAnyEmployee(config.getId())) {
                cc.setStatus(ComplianceStatus.COMPLETED);
                assignmentRepository.findCompletedAssignmentByConfigId(config.getId()).ifPresent(done -> {
                    cc.setCompletedAt(done.getCompletedAt());
                    cc.setCompletedBy(done.getCompletedBy());
                    cc.setAdminSubmissionReference(done.getSubmissionReference());
                    cc.setAdminSubmissionDocumentUrl(done.getSubmissionDocumentUrl());
                });
                companyComplianceRepository.save(cc);
                return true;
            }
        }

        return false;
    }

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
        if (config != null && config.getCompanyCompliance() != null && config.getCompanyCompliance().getCompany() != null) {
            return config.getCompanyCompliance().getCompany().getId();
        }
        if (assignment.getEmployeeId() != null) {
            return userRepository.findById(assignment.getEmployeeId())
                    .map(u -> u.getCompany() != null ? u.getCompany().getId() : null)
                    .orElse(null);
        }
        return null;
    }

    private String getCompanyNameFromAssignment(EmployeeAssignment assignment) {
        if (assignment == null) return "Company";
        var config = assignment.getConfig();
        if (config != null && config.getCompanyCompliance() != null && config.getCompanyCompliance().getCompany() != null) {
            return config.getCompanyCompliance().getCompany().getName();
        }
        if (assignment.getEmployeeId() != null) {
            return userRepository.findById(assignment.getEmployeeId())
                    .map(u -> u.getCompany() != null ? u.getCompany().getName() : "Company")
                    .orElse("Company");
        }
        return "Company";
    }
}
