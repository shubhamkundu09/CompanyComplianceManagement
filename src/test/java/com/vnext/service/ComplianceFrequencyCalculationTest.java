package com.vnext.service;

import com.vnext.entity.CompanyCompliance;
import com.vnext.entity.ComplianceConfig;
import com.vnext.entity.ComplianceFrequency;
import com.vnext.entity.ComplianceStatus;
import com.vnext.repository.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ComplianceFrequencyCalculationTest {

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
    private NotificationEventService notificationEventService;

    @InjectMocks
    private ComplianceService complianceService;

    @Test
    @DisplayName("Quarterly calculation: 15 June -> 15 Sep -> 15 Dec -> 15 Mar")
    void testQuarterlyCalculationForJuneSeptemberDecemberMarch() {
        ComplianceConfig config = new ComplianceConfig();
        config.setFrequency(ComplianceFrequency.QUARTERLY);
        config.setDueQuarter(1); // Q1 (Apr-Jun)
        config.setDueMonth(3);   // 3rd month in quarter -> June
        config.setDueDayOfMonth(15);

        LocalDate initialDueDate = complianceService.calculateDueDate(config);
        assertNotNull(initialDueDate);
        assertEquals(6, initialDueDate.getMonthValue(), "Initial month should be June (6)");
        assertEquals(15, initialDueDate.getDayOfMonth(), "Day should be 15");

        config.setDueDate(initialDueDate);

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(100L);
        cc.setStatus(ComplianceStatus.COMPLETED);

        when(configRepository.findByCompanyComplianceId(100L)).thenReturn(Optional.of(config));

        // Next quarterly renewal: June 15 + 3 months = Sep 15
        LocalDate nextDueDate1 = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextDueDate1);
        assertEquals(9, nextDueDate1.getMonthValue(), "Next quarter due date should be September (9)");
        assertEquals(15, nextDueDate1.getDayOfMonth(), "Day should be 15");

        // Next quarterly renewal: Sep 15 + 3 months = Dec 15
        config.setDueDate(nextDueDate1);
        LocalDate nextDueDate2 = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextDueDate2);
        assertEquals(12, nextDueDate2.getMonthValue(), "Next quarter due date should be December (12)");
        assertEquals(15, nextDueDate2.getDayOfMonth(), "Day should be 15");

        // Next quarterly renewal: Dec 15 + 3 months = Mar 15 (next year)
        config.setDueDate(nextDueDate2);
        LocalDate nextDueDate3 = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextDueDate3);
        assertEquals(3, nextDueDate3.getMonthValue(), "Next quarter due date should be March (3)");
        assertEquals(15, nextDueDate3.getDayOfMonth(), "Day should be 15");
        assertEquals(nextDueDate2.getYear() + 1, nextDueDate3.getYear(), "Year should advance by 1");
    }

    @Test
    @DisplayName("Half-Yearly calculation: 30 September and 31 March")
    void testHalfYearlyCalculation() {
        ComplianceConfig config = new ComplianceConfig();
        config.setFrequency(ComplianceFrequency.HALF_YEARLY);
        config.setDueHalf(1);   // H1 (Apr-Sep)
        config.setDueMonth(6);  // 6th month in H1 -> September
        config.setDueDayOfMonth(30);

        LocalDate initialDueDate = complianceService.calculateDueDate(config);
        assertNotNull(initialDueDate);
        assertEquals(9, initialDueDate.getMonthValue(), "Month should be September (9)");
        assertEquals(30, initialDueDate.getDayOfMonth(), "Day should be 30");

        config.setDueDate(initialDueDate);

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(200L);
        cc.setStatus(ComplianceStatus.COMPLETED);

        when(configRepository.findByCompanyComplianceId(200L)).thenReturn(Optional.of(config));

        // Next half-yearly renewal: Sep 30 + 6 months = Mar 30
        LocalDate nextDueDate = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextDueDate);
        assertEquals(3, nextDueDate.getMonthValue(), "Next half-yearly month should be March (3)");
        assertEquals(30, nextDueDate.getDayOfMonth());
    }

    @Test
    @DisplayName("Monthly calculation: 15th of every month")
    void testMonthlyCalculation() {
        ComplianceConfig config = new ComplianceConfig();
        config.setFrequency(ComplianceFrequency.MONTHLY);
        config.setDueDayOfMonth(15);

        LocalDate initialDueDate = complianceService.calculateDueDate(config);
        assertNotNull(initialDueDate);
        assertEquals(15, initialDueDate.getDayOfMonth());

        config.setDueDate(LocalDate.of(2026, 1, 15));

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(300L);
        cc.setStatus(ComplianceStatus.COMPLETED);

        when(configRepository.findByCompanyComplianceId(300L)).thenReturn(Optional.of(config));

        LocalDate nextMonth = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextMonth);
        assertEquals(LocalDate.of(2026, 2, 15), nextMonth);
    }

    @Test
    @DisplayName("Yearly calculation: 31 December every year")
    void testYearlyCalculation() {
        ComplianceConfig config = new ComplianceConfig();
        config.setFrequency(ComplianceFrequency.YEARLY);
        config.setDueMonth(12);
        config.setDueDayOfMonth(31);

        LocalDate initialDueDate = complianceService.calculateDueDate(config);
        assertNotNull(initialDueDate);
        assertEquals(12, initialDueDate.getMonthValue());
        assertEquals(31, initialDueDate.getDayOfMonth());

        config.setDueDate(LocalDate.of(2026, 12, 31));

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(400L);
        cc.setStatus(ComplianceStatus.COMPLETED);

        when(configRepository.findByCompanyComplianceId(400L)).thenReturn(Optional.of(config));

        LocalDate nextYear = complianceService.getNextDueDateForCompliance(cc);
        assertNotNull(nextYear);
        assertEquals(LocalDate.of(2027, 12, 31), nextYear);
    }
}
