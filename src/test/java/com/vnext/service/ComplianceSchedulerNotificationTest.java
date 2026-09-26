package com.vnext.service;

import com.vnext.entity.*;
import com.vnext.repository.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ComplianceSchedulerNotificationTest {

    private static final ZoneId IST = ZoneId.of("Asia/Kolkata");

    @Mock
    private ComplianceConfigRepository configRepository;
    @Mock
    private CompanyComplianceRepository companyComplianceRepository;
    @Mock
    private ComplianceSubTemplateRepository subTemplateRepository;
    @Mock
    private EmployeeAssignmentRepository assignmentRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private CompanyRepository companyRepository;
    @Mock
    private ComplianceHistoryRepository historyRepository;
    @Mock
    private NotificationEventService notificationEventService;
    @Mock
    private EmailService emailService;
    @Mock
    private NotificationScheduleConfigRepository scheduleConfigRepository;
    @Mock
    private UserPushNotificationRepository userPushNotificationRepository;

    @InjectMocks
    private ComplianceService complianceService;

    @Test
    @DisplayName("calculateEffectiveDueDate for Monthly, Quarterly, Half-Yearly, Yearly, One-Time")
    void testCalculateEffectiveDueDateAllFrequencies() {
        // 1. ONE_TIME
        ComplianceConfig oneTimeConfig = new ComplianceConfig();
        oneTimeConfig.setFrequency(ComplianceFrequency.ONE_TIME);
        oneTimeConfig.setCustomDueDate(LocalDate.of(2026, 10, 25));
        assertEquals(LocalDate.of(2026, 10, 25), complianceService.calculateEffectiveDueDate(oneTimeConfig));

        // 2. MONTHLY
        ComplianceConfig monthlyConfig = new ComplianceConfig();
        monthlyConfig.setFrequency(ComplianceFrequency.MONTHLY);
        monthlyConfig.setDueDayOfMonth(20);
        LocalDate monthlyDue = complianceService.calculateEffectiveDueDate(monthlyConfig);
        assertNotNull(monthlyDue);
        assertEquals(20, monthlyDue.getDayOfMonth());

        // 3. QUARTERLY
        ComplianceConfig quarterlyConfig = new ComplianceConfig();
        quarterlyConfig.setFrequency(ComplianceFrequency.QUARTERLY);
        quarterlyConfig.setDueQuarter(1); // Q1: Apr-Jun
        quarterlyConfig.setDueMonth(3);   // 3rd month -> June
        quarterlyConfig.setDueDayOfMonth(15);
        LocalDate quarterlyDue = complianceService.calculateEffectiveDueDate(quarterlyConfig);
        assertNotNull(quarterlyDue);
        assertEquals(6, quarterlyDue.getMonthValue());
        assertEquals(15, quarterlyDue.getDayOfMonth());

        // 4. HALF_YEARLY
        ComplianceConfig halfYearlyConfig = new ComplianceConfig();
        halfYearlyConfig.setFrequency(ComplianceFrequency.HALF_YEARLY);
        halfYearlyConfig.setDueHalf(1);   // H1: Apr-Sep
        halfYearlyConfig.setDueMonth(6);  // 6th month -> September
        halfYearlyConfig.setDueDayOfMonth(30);
        LocalDate halfDue = complianceService.calculateEffectiveDueDate(halfYearlyConfig);
        assertNotNull(halfDue);
        assertEquals(9, halfDue.getMonthValue());
        assertEquals(30, halfDue.getDayOfMonth());

        // 5. YEARLY
        ComplianceConfig yearlyConfig = new ComplianceConfig();
        yearlyConfig.setFrequency(ComplianceFrequency.YEARLY);
        yearlyConfig.setDueMonth(12);
        yearlyConfig.setDueDayOfMonth(31);
        LocalDate yearlyDue = complianceService.calculateEffectiveDueDate(yearlyConfig);
        assertNotNull(yearlyDue);
        assertEquals(12, yearlyDue.getMonthValue());
        assertEquals(31, yearlyDue.getDayOfMonth());
    }

    @Test
    @DisplayName("getNextDueDateForCompliance advances by frequency period when renewing")
    void testNextDueDateAdvancement() {
        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(50L);
        cc.setStatus(ComplianceStatus.COMPLETED);

        // Monthly renewal
        ComplianceConfig monthlyCfg = new ComplianceConfig();
        monthlyCfg.setFrequency(ComplianceFrequency.MONTHLY);
        monthlyCfg.setDueDate(LocalDate.of(2026, 4, 15));
        when(configRepository.findByCompanyComplianceId(50L)).thenReturn(Optional.of(monthlyCfg));

        LocalDate nextMonthly = complianceService.getNextDueDateForCompliance(cc);
        assertEquals(LocalDate.of(2026, 5, 15), nextMonthly);

        // Quarterly renewal
        monthlyCfg.setFrequency(ComplianceFrequency.QUARTERLY);
        monthlyCfg.setDueDate(LocalDate.of(2026, 6, 15));
        LocalDate nextQuarterly = complianceService.getNextDueDateForCompliance(cc);
        assertEquals(LocalDate.of(2026, 9, 15), nextQuarterly);

        // Half-Yearly renewal
        monthlyCfg.setFrequency(ComplianceFrequency.HALF_YEARLY);
        monthlyCfg.setDueDate(LocalDate.of(2026, 9, 30));
        LocalDate nextHalf = complianceService.getNextDueDateForCompliance(cc);
        assertEquals(LocalDate.of(2027, 3, 30), nextHalf);

        // Yearly renewal
        monthlyCfg.setFrequency(ComplianceFrequency.YEARLY);
        monthlyCfg.setDueDate(LocalDate.of(2026, 12, 31));
        LocalDate nextYearly = complianceService.getNextDueDateForCompliance(cc);
        assertEquals(LocalDate.of(2027, 12, 31), nextYearly);
    }

    @Test
    @DisplayName("Scheduler renewCompletedRecurringCompliances resets lastReminderSent and updates due date")
    void testSchedulerRenewal() {
        SchedulerService schedulerService = new SchedulerService(
                assignmentRepository,
                userRepository,
                emailService,
                companyComplianceRepository,
                complianceService,
                configRepository,
                notificationEventService,
                companyRepository,
                scheduleConfigRepository,
                userPushNotificationRepository
        );

        Company company = new Company();
        company.setId(1L);
        company.setName("Test Corp");

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(10L);
        cc.setCompany(company);
        cc.setStatus(ComplianceStatus.COMPLETED);
        cc.setIsActive(true);

        ComplianceConfig config = new ComplianceConfig();
        config.setId(100L);
        config.setFrequency(ComplianceFrequency.MONTHLY);
        config.setDueDate(LocalDate.now(IST).minusDays(1)); // yesterday
        cc.setConfig(config);

        when(companyComplianceRepository.findAll()).thenReturn(List.of(cc));
        when(configRepository.findByCompanyComplianceId(10L)).thenReturn(Optional.of(config));

        EmployeeAssignment oldAssignment = new EmployeeAssignment();
        oldAssignment.setId(1L);
        oldAssignment.setConfig(config);
        oldAssignment.setEmployeeId(200L);
        oldAssignment.setDueDate(config.getDueDate());
        oldAssignment.setIsOverdue(true);
        oldAssignment.setOverdueNotifiedAt(LocalDateTime.now(IST).minusDays(1));
        oldAssignment.setLastReminderSent(LocalDate.now(IST).minusDays(2));

        when(assignmentRepository.findByConfigIdAndIsActiveTrue(100L)).thenReturn(List.of(oldAssignment));

        schedulerService.renewCompletedRecurringCompliances();

        // Verify config updated
        verify(configRepository).save(config);
        assertEquals(ComplianceStatus.PENDING, cc.getStatus());
        verify(companyComplianceRepository).save(cc);

        // Verify assignment reset
        verify(assignmentRepository).save(oldAssignment);
        assertNull(oldAssignment.getLastReminderSent(), "lastReminderSent should be reset on renewal");
        assertNull(oldAssignment.getOverdueNotifiedAt(), "overdueNotifiedAt should be reset on renewal");
        assertFalse(oldAssignment.getIsOverdue(), "isOverdue should be false on renewal");
    }

    @Test
    @DisplayName("Scheduler sendDueReminders skips when daily quota has already been reached")
    void testDueReminderSkippedWhenDailyQuotaReached() {
        SchedulerService schedulerService = new SchedulerService(
                assignmentRepository,
                userRepository,
                emailService,
                companyComplianceRepository,
                complianceService,
                configRepository,
                notificationEventService,
                companyRepository,
                scheduleConfigRepository,
                userPushNotificationRepository
        );

        LocalDate today = LocalDate.now(IST);

        NotificationScheduleConfig scheduleConfig = new NotificationScheduleConfig();
        scheduleConfig.setNotificationType("DUE_REMINDER");
        scheduleConfig.setEnabled(true);
        scheduleConfig.setTimesPerDay(10);
        scheduleConfig.setStartHour(0);
        scheduleConfig.setEndHour(23);
        scheduleConfig.setLastSentDate(today);
        scheduleConfig.setSentTodayCount(10); // Quota 10/10 reached
        when(scheduleConfigRepository.findByNotificationType("DUE_REMINDER")).thenReturn(Optional.of(scheduleConfig));

        schedulerService.sendDueReminders();

        // verify notification NOT sent because quota reached
        verify(notificationEventService, never()).notifyUserPushOnly(anyLong(), anyString(), anyString(), any(), anyString());
    }

    @Test
    @DisplayName("Scheduler sendDueReminders sends push notification on scheduled slot")
    void testDueReminderSentWhenScheduled() {
        SchedulerService schedulerService = new SchedulerService(
                assignmentRepository,
                userRepository,
                emailService,
                companyComplianceRepository,
                complianceService,
                configRepository,
                notificationEventService,
                companyRepository,
                scheduleConfigRepository,
                userPushNotificationRepository
        );

        NotificationScheduleConfig scheduleConfig = new NotificationScheduleConfig();
        scheduleConfig.setNotificationType("DUE_REMINDER");
        scheduleConfig.setEnabled(true);
        scheduleConfig.setTimesPerDay(10);
        scheduleConfig.setStartHour(0);
        scheduleConfig.setEndHour(23);
        scheduleConfig.setSentTodayCount(0);
        when(scheduleConfigRepository.findByNotificationType("DUE_REMINDER")).thenReturn(Optional.of(scheduleConfig));
        when(scheduleConfigRepository.save(any())).thenReturn(scheduleConfig);

        LocalDate today = LocalDate.now(IST);
        LocalDate dueDate = today.plusDays(4); // 4 days remaining -> (10 - 4) % 3 == 0

        ComplianceTemplate template = new ComplianceTemplate();
        template.setName("GST Return");

        ComplianceConfig config = new ComplianceConfig();
        config.setTemplate(template);
        config.setReminderDaysBefore(10);
        config.setRepeatReminder(true);
        config.setReminderIntervalDays(3);

        EmployeeAssignment assignment = new EmployeeAssignment();
        assignment.setId(2L);
        assignment.setConfig(config);
        assignment.setEmployeeId(400L);
        assignment.setDueDate(dueDate);
        assignment.setLastReminderSent(null);

        when(assignmentRepository.findActiveUpcomingAssignments(eq(today), any())).thenReturn(List.of(assignment));
        when(companyComplianceRepository.findAll()).thenReturn(List.of());

        schedulerService.sendDueReminders();

        // verify FCM push notification was sent to employee (pure push, NOT announcement)
        verify(notificationEventService).notifyUserPushOnly(
                eq(400L),
                eq("Compliance Due Soon"),
                contains("GST Return"),
                eq(NotificationType.COMPLIANCE_DUE_SOON),
                eq("employee_compliance")
        );
        assertEquals(today, assignment.getLastReminderSent());
        verify(assignmentRepository).save(assignment);
    }

    @Test
    @DisplayName("Scheduler sendDueReminders sends push notification on slot 2 even if slot 1 already sent today")
    void testMultiSlotSendsThroughoutTheDay() {
        SchedulerService schedulerService = new SchedulerService(
                assignmentRepository,
                userRepository,
                emailService,
                companyComplianceRepository,
                complianceService,
                configRepository,
                notificationEventService,
                companyRepository,
                scheduleConfigRepository,
                userPushNotificationRepository
        );

        LocalDate today = LocalDate.now(IST);
        LocalDateTime twoHoursAgo = LocalDateTime.now(IST).minusHours(2);

        NotificationScheduleConfig scheduleConfig = new NotificationScheduleConfig();
        scheduleConfig.setNotificationType("DUE_REMINDER");
        scheduleConfig.setEnabled(true);
        scheduleConfig.setTimesPerDay(10);
        scheduleConfig.setStartHour(0);
        scheduleConfig.setEndHour(23);
        scheduleConfig.setLastSentDate(today);
        scheduleConfig.setSentTodayCount(1); // Slot 1 already fired earlier today
        scheduleConfig.setLastSentAt(twoHoursAgo);

        when(scheduleConfigRepository.findByNotificationType("DUE_REMINDER")).thenReturn(Optional.of(scheduleConfig));
        when(scheduleConfigRepository.save(any())).thenReturn(scheduleConfig);

        LocalDate dueDate = today.plusDays(4);

        ComplianceTemplate template = new ComplianceTemplate();
        template.setName("Quarterly Audit");

        ComplianceConfig config = new ComplianceConfig();
        config.setTemplate(template);
        config.setReminderDaysBefore(10);
        config.setRepeatReminder(true);
        config.setReminderIntervalDays(3);

        EmployeeAssignment assignment = new EmployeeAssignment();
        assignment.setId(3L);
        assignment.setConfig(config);
        assignment.setEmployeeId(500L);
        assignment.setDueDate(dueDate);
        assignment.setLastReminderSent(today); // Already sent in slot 1 today!

        when(assignmentRepository.findActiveUpcomingAssignments(eq(today), any())).thenReturn(List.of(assignment));
        when(companyComplianceRepository.findAll()).thenReturn(List.of());

        schedulerService.sendDueReminders();

        // Slot 2 must still deliver the FCM push reminder to the physical phone!
        verify(notificationEventService).notifyUserPushOnly(
                eq(500L),
                eq("Compliance Due Soon"),
                contains("Quarterly Audit"),
                eq(NotificationType.COMPLIANCE_DUE_SOON),
                eq("employee_compliance")
        );
        assertTrue(scheduleConfig.getSentTodayCount() > 1, "sentTodayCount should advance beyond 1");
    }
}
