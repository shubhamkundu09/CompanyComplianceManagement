package com.vnext.service;

import com.vnext.dto.ComplianceConfigDTO;
import com.vnext.entity.*;
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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ComplianceConfigNoneFrequencyTest {

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
    @DisplayName("updateComplianceConfig with frequency=null clears due dates and reminders")
    void testUpdateComplianceConfigWithNoneFrequency() {
        Long configId = 10L;
        Long companyId = 1L;
        Long adminId = 5L;

        Company company = new Company();
        company.setId(companyId);
        company.setName("Test Company");

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(20L);
        cc.setCompany(company);

        ComplianceConfig existingConfig = new ComplianceConfig();
        existingConfig.setId(configId);
        existingConfig.setCompanyCompliance(cc);
        existingConfig.setFrequency(ComplianceFrequency.MONTHLY);
        existingConfig.setDueDate(LocalDate.now().plusDays(10));
        existingConfig.setReminderDaysBefore(10);
        existingConfig.setRepeatReminder(true);
        existingConfig.setReminderIntervalDays(3);

        when(configRepository.findById(configId)).thenReturn(Optional.of(existingConfig));
        when(configRepository.save(any(ComplianceConfig.class))).thenAnswer(invocation -> invocation.getArgument(0));

        ComplianceConfigDTO updateDto = new ComplianceConfigDTO();
        updateDto.setFrequency(null); // Frequency is None
        updateDto.setDescription("Updated Description");

        ComplianceConfigDTO result = complianceService.updateComplianceConfig(configId, companyId, updateDto, adminId);

        assertNotNull(result);
        assertTrue(result.getConfigured());
        assertNull(result.getFrequency());
        assertNull(result.getDueDate());
        assertNull(result.getEffectiveDueDate());
        assertNull(result.getReminderDaysBefore());
        assertFalse(result.getRepeatReminder());
        assertNull(result.getReminderIntervalDays());
        assertEquals("Updated Description", result.getDescription());
    }

    @Test
    @DisplayName("configureSubComplianceForCompany with frequency=null sets reminders to null/false")
    void testConfigureSubComplianceForCompanyWithNoneFrequency() {
        Long subTemplateId = 2L;
        Long companyId = 1L;
        Long adminId = 5L;

        Company company = new Company();
        company.setId(companyId);
        company.setName("Test Company");

        ComplianceTemplate parentTemplate = new ComplianceTemplate();
        parentTemplate.setId(100L);
        parentTemplate.setName("GST");
        parentTemplate.setEditableForCompanies(false);

        ComplianceSubTemplate subTemplate = new ComplianceSubTemplate();
        subTemplate.setId(subTemplateId);
        subTemplate.setName("GST 1");
        subTemplate.setParentTemplate(parentTemplate);
        subTemplate.setCompany(company);

        CompanyCompliance cc = new CompanyCompliance();
        cc.setId(200L);
        cc.setCompany(company);
        cc.setTemplate(parentTemplate);
        cc.setSubTemplate(subTemplate);

        when(subTemplateRepository.findByIdAndIsActiveTrue(subTemplateId)).thenReturn(Optional.of(subTemplate));
        when(companyComplianceRepository.existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, 100L)).thenReturn(true);
        when(companyComplianceRepository.findByCompanyIdAndSubTemplateId(companyId, subTemplateId)).thenReturn(Optional.of(cc));
        when(configRepository.findByCompanyComplianceId(cc.getId())).thenReturn(Optional.empty());
        when(configRepository.save(any(ComplianceConfig.class))).thenAnswer(invocation -> invocation.getArgument(0));

        ComplianceConfigDTO dto = new ComplianceConfigDTO();
        dto.setFrequency(null);
        dto.setDescription("Sub-compliance GST 1");

        ComplianceConfigDTO result = complianceService.configureSubComplianceForCompany(subTemplateId, companyId, dto, adminId);

        assertNotNull(result);
        assertTrue(result.getConfigured());
        assertNull(result.getFrequency());
        assertNull(result.getDueDate());
        assertNull(result.getEffectiveDueDate());
        assertNull(result.getReminderDaysBefore());
        assertFalse(result.getRepeatReminder());
        assertNull(result.getReminderIntervalDays());
    }
}
