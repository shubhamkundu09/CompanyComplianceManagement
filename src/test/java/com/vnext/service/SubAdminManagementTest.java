package com.vnext.service;

import com.vnext.dto.EmployeeDTO;
import com.vnext.dto.EmployeeResponseDTO;
import com.vnext.entity.Company;
import com.vnext.entity.User;
import com.vnext.entity.UserRole;
import com.vnext.entity.UserStatus;
import com.vnext.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class SubAdminManagementTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CompanyService companyService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private EmailService emailService;

    @Mock
    private NotificationEventService notificationEventService;

    @InjectMocks
    private EmployeeService employeeService;

    private Company company;
    private User companyAdmin;

    @BeforeEach
    void setUp() {
        company = new Company();
        company.setId(1L);
        company.setName("Test Corp");
        company.setDeleted(false);

        companyAdmin = new User();
        companyAdmin.setId(10L);
        companyAdmin.setFirstName("Admin");
        companyAdmin.setLastName("User");
        companyAdmin.setEmail("admin@testcorp.com");
        companyAdmin.setRole(UserRole.COMPANY_ADMIN);
        companyAdmin.setCompany(company);
        company.setCompanyAdmin(companyAdmin);
    }

    @Test
    @DisplayName("Successfully create a Sub-Admin under company")
    void testCreateSubAdmin() {
        EmployeeDTO dto = new EmployeeDTO();
        dto.setFirstName("John");
        dto.setLastName("Doe");
        dto.setEmail("subadmin@testcorp.com");
        dto.setPhone("9876543210");
        dto.setDesignation("Compliance Lead");
        dto.setDepartment("Legal");

        when(companyService.getCompanyEntityById(1L)).thenReturn(company);
        when(userRepository.existsByEmail(dto.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User u = invocation.getArgument(0);
            u.setId(100L);
            return u;
        });

        EmployeeResponseDTO result = employeeService.createSubAdmin(1L, dto);

        assertNotNull(result);
        assertEquals(100L, result.getId());
        assertEquals("John", result.getFirstName());
        assertEquals(UserRole.SUB_ADMIN, result.getRole());
        assertEquals(UserStatus.ACTIVE, result.getStatus());

        verify(emailService, times(1)).sendCredentialsEmail(eq(dto.getEmail()), anyString(), anyString(), anyString());
        verify(companyService, times(1)).canAddEmployee(eq(1L));
        verify(companyService, times(1)).updateActiveEmployeeCount(eq(1L));
        verify(notificationEventService, atLeastOnce()).notifyUserPushOnly(eq(10L), anyString(), anyString(), any(), anyString());
    }

    @Test
    @DisplayName("Successfully update Sub-Admin details")
    void testUpdateSubAdmin() {
        User subAdmin = new User();
        subAdmin.setId(100L);
        subAdmin.setFirstName("John");
        subAdmin.setLastName("Doe");
        subAdmin.setEmail("subadmin@testcorp.com");
        subAdmin.setRole(UserRole.SUB_ADMIN);
        subAdmin.setCompany(company);

        EmployeeDTO updateDto = new EmployeeDTO();
        updateDto.setFirstName("Johnny");
        updateDto.setLastName("Doe");
        updateDto.setEmail("subadmin@testcorp.com");
        updateDto.setPhone("9998887776");
        updateDto.setDesignation("Head of Compliance");

        when(userRepository.findById(100L)).thenReturn(Optional.of(subAdmin));
        when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

        EmployeeResponseDTO result = employeeService.updateSubAdmin(100L, updateDto);

        assertNotNull(result);
        assertEquals("Johnny", result.getFirstName());
        assertEquals("Head of Compliance", result.getDesignation());
    }

    @Test
    @DisplayName("Successfully delete Sub-Admin (soft-delete) and update company capacity")
    void testDeleteSubAdmin() {
        User subAdmin = new User();
        subAdmin.setId(100L);
        subAdmin.setEmail("subadmin@testcorp.com");
        subAdmin.setRole(UserRole.SUB_ADMIN);
        subAdmin.setCompany(company);

        when(userRepository.findById(100L)).thenReturn(Optional.of(subAdmin));

        employeeService.deleteSubAdmin(100L);

        assertTrue(subAdmin.isDeleted());
        assertEquals(UserStatus.DEACTIVE, subAdmin.getStatus());
        assertTrue(subAdmin.getEmail().contains("_deleted_"));
        verify(userRepository, times(1)).save(subAdmin);
        verify(companyService, times(1)).updateActiveEmployeeCount(eq(1L));
    }

    @Test
    @DisplayName("Successfully list Sub-Admins for company")
    void testGetSubAdminsByCompany() {
        User subAdmin = new User();
        subAdmin.setId(100L);
        subAdmin.setFirstName("John");
        subAdmin.setLastName("Doe");
        subAdmin.setEmail("subadmin@testcorp.com");
        subAdmin.setRole(UserRole.SUB_ADMIN);
        subAdmin.setCompany(company);

        Page<User> page = new PageImpl<>(List.of(subAdmin));
        when(userRepository.findByCompanyIdAndRoleAndDeletedFalse(eq(1L), eq(UserRole.SUB_ADMIN), any()))
                .thenReturn(page);

        Page<EmployeeResponseDTO> result = employeeService.getSubAdminsByCompany(1L, PageRequest.of(0, 10));

        assertNotNull(result);
        assertEquals(1, result.getTotalElements());
        assertEquals(UserRole.SUB_ADMIN, result.getContent().get(0).getRole());
    }
}
