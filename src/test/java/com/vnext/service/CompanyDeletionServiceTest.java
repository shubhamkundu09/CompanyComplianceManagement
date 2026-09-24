package com.vnext.service;

import com.vnext.entity.*;
import com.vnext.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CompanyDeletionServiceTest {

    @Mock
    private CompanyRepository companyRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private EmailService emailService;

    @Mock
    private CompanyDocumentRepository documentRepository;

    @Mock
    private DocumentStorageService documentStorageService;

    @Mock
    private ComplianceService complianceService;

    @Mock
    private CompanyComplianceRepository companyComplianceRepository;

    @Mock
    private ComplianceConfigRepository complianceConfigRepository;

    @Mock
    private EmployeeAssignmentRepository employeeAssignmentRepository;

    @Mock
    private ComplianceHistoryRepository complianceHistoryRepository;

    @Mock
    private ComplianceDocumentRepository complianceDocumentRepository;

    @Mock
    private ComplianceSubTemplateRepository complianceSubTemplateRepository;

    @Mock
    private ComplianceTemplateRepository complianceTemplateRepository;

    @Mock
    private NotificationEventService notificationEventService;

    @Mock
    private DeviceTokenRepository deviceTokenRepository;

    @InjectMocks
    private CompanyService companyService;

    private Company testCompany;
    private User companyAdmin;
    private User employee;

    @BeforeEach
    void setUp() {
        testCompany = new Company();
        testCompany.setId(13L);
        testCompany.setName("Acme Legal Corp");

        companyAdmin = new User();
        companyAdmin.setId(101L);
        companyAdmin.setEmail("admin@acme.com");
        companyAdmin.setRole(UserRole.COMPANY_ADMIN);
        companyAdmin.setCompany(testCompany);
        testCompany.setCompanyAdmin(companyAdmin);

        employee = new User();
        employee.setId(102L);
        employee.setEmail("emp@acme.com");
        employee.setRole(UserRole.EMPLOYEE);
        employee.setCompany(testCompany);
    }

    @Test
    @DisplayName("deleteCompany should delete compliance_sub_templates, compliance_templates, device_tokens, and child records in FK-safe order")
    void testDeleteCompany_FKSafeOrder() {
        Long companyId = 13L;
        when(companyRepository.findById(companyId)).thenReturn(Optional.of(testCompany));
        when(userRepository.findAllByCompanyId(companyId)).thenReturn(List.of(employee, companyAdmin));

        // Company compliances
        CompanyCompliance compliance = new CompanyCompliance();
        compliance.setId(201L);
        compliance.setCompany(testCompany);
        when(companyComplianceRepository.findAllByCompanyIdRaw(companyId)).thenReturn(List.of(compliance));

        // Company sub-template
        ComplianceSubTemplate subTemplate = new ComplianceSubTemplate();
        subTemplate.setId(301L);
        subTemplate.setCompany(testCompany);
        when(complianceSubTemplateRepository.findByCompanyId(companyId)).thenReturn(List.of(subTemplate));

        // Company template
        ComplianceTemplate template = new ComplianceTemplate();
        template.setId(401L);
        template.setCompany(testCompany);
        when(complianceTemplateRepository.findByCompanyId(companyId)).thenReturn(List.of(template));

        // Execute deletion
        companyService.deleteCompany(companyId);

        // 1. Verify compliance sub-templates were queried and deleted
        verify(complianceSubTemplateRepository).findByCompanyId(companyId);
        verify(complianceSubTemplateRepository).deleteAll(List.of(subTemplate));
        verify(complianceSubTemplateRepository, atLeastOnce()).flush();

        // 2. Verify compliance templates were queried and deleted
        verify(complianceTemplateRepository).findByCompanyId(companyId);
        verify(complianceTemplateRepository).deleteAll(List.of(template));
        verify(complianceTemplateRepository, atLeastOnce()).flush();

        // 3. Verify device tokens were deleted for both users before user deletion
        verify(deviceTokenRepository).deleteAllByUserId(102L);
        verify(deviceTokenRepository).deleteAllByUserId(101L);
        verify(deviceTokenRepository).flush();

        // 4. Verify company document deletion
        verify(documentRepository).deleteByCompanyId(companyId);

        // 5. Verify company compliances were deleted
        verify(companyComplianceRepository).deleteAll(List.of(compliance));
        verify(companyComplianceRepository).flush();

        // 6. Verify users deleted
        verify(userRepository).delete(employee);
        verify(userRepository).delete(companyAdmin);
        verify(userRepository).flush();

        // 7. Verify company deleted
        verify(companyRepository).delete(testCompany);
        verify(companyRepository).flush();

        // 8. Verify SuperAdmin notification sent
        verify(notificationEventService).notifySuperAdminsPushOnly(
                eq("Company Deleted"),
                contains("Acme Legal Corp"),
                eq(NotificationType.COMPANY_DELETED),
                eq("companies")
        );
    }
}
