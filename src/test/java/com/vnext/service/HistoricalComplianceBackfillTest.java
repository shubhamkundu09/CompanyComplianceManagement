package com.vnext.service;

import com.vnext.dto.CompanyComplianceHistoryDTO;
import com.vnext.dto.ComplianceHistoryDTO;
import com.vnext.dto.HistoricalComplianceRecordRequestDTO;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class HistoricalComplianceBackfillTest {

    private static final ZoneId IST = ZoneId.of("Asia/Kolkata");

    @Mock
    private ComplianceTemplateRepository templateRepository;
    @Mock
    private ComplianceSubTemplateRepository subTemplateRepository;
    @Mock
    private CompanyComplianceRepository companyComplianceRepository;
    @Mock
    private ComplianceConfigRepository configRepository;
    @Mock
    private EmployeeAssignmentRepository assignmentRepository;
    @Mock
    private CompanyRepository companyRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private EmailService emailService;
    @Mock
    private ComplianceHistoryRepository historyRepository;
    @Mock
    private ComplianceDocumentRepository documentRepository;
    @Mock
    private CompanyDocumentRepository companyDocumentRepository;
    @Mock
    private NotificationEventService notificationEventService;
    @Mock
    private CompanyComplianceHistoricalRecordRepository historicalRecordRepository;
    @Mock
    private DocumentStorageService documentStorageService;

    @InjectMocks
    private ComplianceService complianceService;

    private User superAdmin;
    private User companyAdmin;
    private Company testCompany;
    private ComplianceTemplate gstTemplate;
    private ComplianceSubTemplate gstr1SubTemplate;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(complianceService, "historicalRecordRepository", historicalRecordRepository);
        ReflectionTestUtils.setField(complianceService, "documentStorageService", documentStorageService);

        superAdmin = new User();
        superAdmin.setId(1L);
        superAdmin.setEmail("superadmin@vnext.com");
        superAdmin.setRole(UserRole.SUPER_ADMIN);
        superAdmin.setFirstName("Super");
        superAdmin.setLastName("Admin");

        companyAdmin = new User();
        companyAdmin.setId(2L);
        companyAdmin.setEmail("admin@company.com");
        companyAdmin.setRole(UserRole.COMPANY_ADMIN);

        testCompany = new Company();
        testCompany.setId(20L);
        testCompany.setName("Proto Plus Tech");

        gstTemplate = new ComplianceTemplate();
        gstTemplate.setId(10L);
        gstTemplate.setName("GST");

        gstr1SubTemplate = new ComplianceSubTemplate();
        gstr1SubTemplate.setId(101L);
        gstr1SubTemplate.setName("GSTR-1");
        gstr1SubTemplate.setParentTemplate(gstTemplate);
    }

    @Test
    @DisplayName("SuperAdmin can successfully add past historical compliance record")
    void testSuperAdminAddPastHistoricalRecordSuccess() {
        HistoricalComplianceRecordRequestDTO dto = new HistoricalComplianceRecordRequestDTO();
        dto.setCompanyId(20L);
        dto.setTemplateId(10L);
        dto.setSubTemplateId(101L);
        dto.setYear(2026);
        dto.setMonth(3); // March (past month)
        dto.setDueDate(LocalDate.of(2026, 3, 20));
        dto.setStatus(ComplianceStatus.COMPLETED);
        dto.setCompletedAt(LocalDateTime.of(2026, 3, 18, 14, 30));
        dto.setSubmissionReference("ARN-GST123456");
        dto.setRemarks("Backfilled by Super Admin during onboarding");

        when(companyRepository.findById(20L)).thenReturn(Optional.of(testCompany));
        when(templateRepository.findById(10L)).thenReturn(Optional.of(gstTemplate));
        when(subTemplateRepository.findById(101L)).thenReturn(Optional.of(gstr1SubTemplate));
        when(companyComplianceRepository.findByCompanyIdAndTemplateIdAndDeletedFalse(20L, 10L)).thenReturn(List.of());
        when(historicalRecordRepository.findExistingRecord(20L, 10L, 101L, 2026, 3)).thenReturn(Optional.empty());

        when(historicalRecordRepository.save(any(CompanyComplianceHistoricalRecord.class))).thenAnswer(invocation -> {
            CompanyComplianceHistoricalRecord r = invocation.getArgument(0);
            r.setId(999L);
            return r;
        });

        CompanyComplianceHistoryDTO result = complianceService.addHistoricalComplianceRecord(dto, null, superAdmin);

        assertNotNull(result);
        assertEquals(999L, result.getId());
        assertTrue(result.isHistorical());
        assertEquals(ComplianceStatus.COMPLETED, result.getStatus());
        assertEquals("ARN-GST123456", result.getSubmissionReference());
        assertEquals("GSTR-1", result.getSubComplianceName());
        assertEquals(3, result.getDueMonth());
        verify(historicalRecordRepository).save(any(CompanyComplianceHistoricalRecord.class));
    }

    @Test
    @DisplayName("Adding current or future month compliance as history is rejected")
    void testAddingFutureComplianceAsHistoryRejected() {
        LocalDate today = LocalDate.now(IST);
        HistoricalComplianceRecordRequestDTO dto = new HistoricalComplianceRecordRequestDTO();
        dto.setCompanyId(20L);
        dto.setTemplateId(10L);
        dto.setYear(today.getYear() + 1); // Future year
        dto.setMonth(1);
        dto.setDueDate(LocalDate.of(today.getYear() + 1, 1, 20));
        dto.setStatus(ComplianceStatus.COMPLETED);

        when(companyRepository.findById(20L)).thenReturn(Optional.of(testCompany));
        when(templateRepository.findById(10L)).thenReturn(Optional.of(gstTemplate));

        BusinessException ex = assertThrows(BusinessException.class, () ->
                complianceService.addHistoricalComplianceRecord(dto, null, superAdmin));

        assertTrue(ex.getMessage().contains("Only past/previous compliance records"));
        verify(historicalRecordRepository, never()).save(any());
    }

    @Test
    @DisplayName("SuperAdmin cannot edit or overwrite compliance already completed by Company Admin")
    void testCannotOverwriteComplianceCompletedByCompanyAdmin() {
        HistoricalComplianceRecordRequestDTO dto = new HistoricalComplianceRecordRequestDTO();
        dto.setCompanyId(20L);
        dto.setTemplateId(10L);
        dto.setSubTemplateId(101L);
        dto.setYear(2026);
        dto.setMonth(5); // May
        dto.setDueDate(LocalDate.of(2026, 5, 20));
        dto.setStatus(ComplianceStatus.COMPLETED);

        when(companyRepository.findById(20L)).thenReturn(Optional.of(testCompany));
        when(templateRepository.findById(10L)).thenReturn(Optional.of(gstTemplate));
        when(subTemplateRepository.findById(101L)).thenReturn(Optional.of(gstr1SubTemplate));

        // Mock an active compliance completed by Company Admin for May 2026
        CompanyCompliance existingLiveCC = new CompanyCompliance();
        existingLiveCC.setId(55L);
        existingLiveCC.setCompany(testCompany);
        existingLiveCC.setTemplate(gstTemplate);
        existingLiveCC.setSubTemplate(gstr1SubTemplate);
        existingLiveCC.setStatus(ComplianceStatus.COMPLETED);
        existingLiveCC.setCompletedAt(LocalDateTime.of(2026, 5, 19, 11, 0));
        existingLiveCC.setCompletedBy(2L); // company admin
        existingLiveCC.setAdminSubmissionReference("CA-ACK-7788");

        ComplianceConfig cfg = new ComplianceConfig();
        cfg.setDueDate(LocalDate.of(2026, 5, 20));
        existingLiveCC.setConfig(cfg);

        when(companyComplianceRepository.findByCompanyIdAndTemplateIdAndDeletedFalse(20L, 10L))
                .thenReturn(List.of(existingLiveCC));

        BusinessException ex = assertThrows(BusinessException.class, () ->
                complianceService.addHistoricalComplianceRecord(dto, null, superAdmin));

        assertTrue(ex.getMessage().contains("already completed by"));
        verify(historicalRecordRepository, never()).save(any());
    }

    @Test
    @DisplayName("Non-SuperAdmin cannot access addHistoricalComplianceRecord")
    void testNonSuperAdminAccessDenied() {
        HistoricalComplianceRecordRequestDTO dto = new HistoricalComplianceRecordRequestDTO();
        dto.setCompanyId(20L);

        BusinessException ex = assertThrows(BusinessException.class, () ->
                complianceService.addHistoricalComplianceRecord(dto, null, companyAdmin));

        assertTrue(ex.getMessage().contains("Only Super Admin"));
        verify(historicalRecordRepository, never()).save(any());
    }

    @Test
    @DisplayName("Statutory due date is accurately calculated from compliance config")
    void testCalculateStatutoryDueDateFromConfig() {
        ComplianceConfig config = new ComplianceConfig();
        config.setDueDayOfMonth(11); // e.g. GSTR-1

        when(configRepository.findBySubTemplateIdAndCompanyComplianceIsNull(101L))
                .thenReturn(Optional.of(config));

        LocalDate calculatedDue = complianceService.calculateStatutoryDueDate(20L, 10L, 101L, 2026, 3);
        assertNotNull(calculatedDue);
        assertEquals(LocalDate.of(2026, 3, 11), calculatedDue);
    }

    @Test
    @DisplayName("Historical record filed late correctly calculates days overdue (e.g. May 30 to June 2 = 3 days late)")
    void testCompletedLateCalculatesCorrectDaysOverdue() {
        HistoricalComplianceRecordRequestDTO dto = HistoricalComplianceRecordRequestDTO.builder()
                .companyId(20L)
                .templateId(10L)
                .subTemplateId(101L)
                .year(2026)
                .month(5)
                .dueDate(LocalDate.of(2026, 5, 30))
                .status(ComplianceStatus.COMPLETED)
                .completedAt(LocalDateTime.of(2026, 6, 2, 18, 0, 0))
                .submissionReference("ARN-MAY-LATE-123")
                .remarks("Filed 3 days late")
                .build();

        when(companyRepository.findById(20L)).thenReturn(Optional.of(testCompany));
        when(templateRepository.findById(10L)).thenReturn(Optional.of(gstTemplate));
        when(subTemplateRepository.findById(101L)).thenReturn(Optional.of(gstr1SubTemplate));
        when(companyComplianceRepository.findByCompanyIdAndTemplateIdAndDeletedFalse(20L, 10L))
                .thenReturn(List.of());

        CompanyComplianceHistoricalRecord savedRecord = new CompanyComplianceHistoricalRecord();
        savedRecord.setId(4L);
        savedRecord.setCompany(testCompany);
        savedRecord.setTemplate(gstTemplate);
        savedRecord.setSubTemplate(gstr1SubTemplate);
        savedRecord.setPeriodYear(2026);
        savedRecord.setPeriodMonth(5);
        savedRecord.setDueDate(LocalDate.of(2026, 5, 30));
        savedRecord.setStatus(ComplianceStatus.COMPLETED);
        savedRecord.setCompletedAt(LocalDateTime.of(2026, 6, 2, 18, 0, 0));
        savedRecord.setCompletedLate(true);

        when(historicalRecordRepository.save(any(CompanyComplianceHistoricalRecord.class)))
                .thenAnswer(inv -> {
                    CompanyComplianceHistoricalRecord r = inv.getArgument(0);
                    r.setId(4L);
                    return r;
                });

        CompanyComplianceHistoryDTO result = complianceService.addHistoricalComplianceRecord(dto, null, superAdmin);

        assertNotNull(result);
        assertTrue(result.isCompletedLate());
        assertEquals(3, result.getDaysOverdue());
        assertEquals(LocalDate.of(2026, 5, 30), result.getDueDate());
        assertEquals(LocalDateTime.of(2026, 6, 2, 18, 0, 0), result.getCompletedAt());
    }

    @Test
    @DisplayName("Super Admin can get historical record by ID")
    void testGetHistoricalRecordById() {
        CompanyComplianceHistoricalRecord record = new CompanyComplianceHistoricalRecord();
        record.setId(4L);
        record.setCompany(testCompany);
        record.setTemplate(gstTemplate);
        record.setSubTemplate(gstr1SubTemplate);
        record.setPeriodYear(2026);
        record.setPeriodMonth(5);
        record.setDueDate(LocalDate.of(2026, 5, 30));
        record.setStatus(ComplianceStatus.COMPLETED);
        record.setCompletedAt(LocalDateTime.of(2026, 6, 2, 18, 0, 0));
        record.setCompletedLate(true);
        record.setSubmissionReference("ARN-12345");

        when(historicalRecordRepository.findById(4L)).thenReturn(Optional.of(record));

        java.util.Map<String, Object> map = complianceService.getHistoricalRecordById(4L, superAdmin);
        assertNotNull(map);
        assertEquals(4L, map.get("id"));
        assertEquals(20L, map.get("companyId"));
        assertEquals("2026-05-30", map.get("dueDate"));
        assertEquals(true, map.get("completedLate"));
        assertEquals("ARN-12345", map.get("submissionReference"));
    }

    @Test
    @DisplayName("CompanyComplianceHistoryDTO serializes to JSON without Jackson conflicts")
    void testCompanyComplianceHistoryDTOJacksonSerialization() throws Exception {
        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
        mapper.findAndRegisterModules();

        CompanyComplianceHistoryDTO dto = CompanyComplianceHistoryDTO.builder()
                .id(1L)
                .companyId(20L)
                .isHistorical(true)
                .isOverdue(false)
                .completedLate(true)
                .daysOverdue(5)
                .build();

        String json = mapper.writeValueAsString(dto);
        assertNotNull(json);
        System.out.println("SERIALIZED JSON: " + json);

        CompanyComplianceHistoryDTO deserialized = mapper.readValue(json, CompanyComplianceHistoryDTO.class);
        assertNotNull(deserialized);
        assertTrue(deserialized.isHistorical());
        assertFalse(deserialized.isOverdue());
        assertTrue(deserialized.isCompletedLate());
        assertEquals(5, deserialized.getDaysOverdue());
    }

    @Test
    @DisplayName("Company Admin can retrieve audit logs for historical compliance records of own company")
    void testCompanyAdminCanGetHistoricalComplianceItemLogsForOwnCompany() {
        CompanyComplianceHistoricalRecord record = new CompanyComplianceHistoricalRecord();
        record.setId(3L);
        record.setCompany(testCompany);
        record.setTemplate(gstTemplate);
        record.setStatus(ComplianceStatus.COMPLETED);
        record.setSubmissionReference("ARN-999");
        record.setRemarks("Jan 2026 backfilled");
        record.setCreatedByName("Super Admin");

        when(historicalRecordRepository.findByIdAndCompanyId(3L, 20L)).thenReturn(Optional.of(record));

        List<ComplianceHistoryDTO> logs = complianceService.getComplianceItemLogsForCompany(3L, 20L, true);

        assertNotNull(logs);
        assertEquals(1, logs.size());
        assertEquals(3L, logs.get(0).getId());
        assertEquals("Historical Compliance Record Added", logs.get(0).getAction());
        assertEquals("COMPLETED", logs.get(0).getNewStatus());
        assertEquals("Super Admin", logs.get(0).getPerformedByName());
        assertTrue(logs.get(0).getRemarks().contains("ARN-999"));
    }

    @Test
    @DisplayName("Company Admin fails with ResourceNotFoundException for another company's historical record")
    void testCompanyAdminCannotGetHistoricalComplianceItemLogsForOtherCompany() {
        when(historicalRecordRepository.findByIdAndCompanyId(3L, 99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () ->
                complianceService.getComplianceItemLogsForCompany(3L, 99L, true)
        );
    }

    @Test
    @DisplayName("Company Admin retrieves historical logs seamlessly via fallback when historical flag is false")
    void testCompanyAdminRetrievesHistoricalLogsViaFallback() {
        CompanyComplianceHistoricalRecord record = new CompanyComplianceHistoricalRecord();
        record.setId(3L);
        record.setCompany(testCompany);
        record.setStatus(ComplianceStatus.COMPLETED);
        record.setSubmissionReference("ARN-333");
        record.setRemarks("Backfill record");

        // Not found in regular company compliance table
        when(companyComplianceRepository.existsByIdAndCompanyIdAndDeletedFalse(3L, 20L)).thenReturn(false);
        // Found in historical record table
        when(historicalRecordRepository.findByIdAndCompanyId(3L, 20L)).thenReturn(Optional.of(record));

        List<ComplianceHistoryDTO> logs = complianceService.getComplianceItemLogsForCompany(3L, 20L, false);

        assertNotNull(logs);
        assertEquals(1, logs.size());
        assertEquals(3L, logs.get(0).getId());
        assertEquals("Historical Compliance Record Added", logs.get(0).getAction());
    }
}

