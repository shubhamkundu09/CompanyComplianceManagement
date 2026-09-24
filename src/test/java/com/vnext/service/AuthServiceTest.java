package com.vnext.service;

import com.vnext.dto.AuthRequest;
import com.vnext.dto.AuthResponse;
import com.vnext.entity.NotificationType;
import com.vnext.entity.User;
import com.vnext.entity.UserRole;
import com.vnext.repository.UserRepository;
import com.vnext.security.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private JwtService jwtService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private NotificationEventService notificationEventService;

    @Mock
    private DeviceTokenService deviceTokenService;

    @Mock
    private Authentication authentication;

    @InjectMocks
    private AuthService authService;

    private User superAdminUser;
    private User companyAdminUser;
    private User employeeUser;

    @BeforeEach
    void setUp() {
        superAdminUser = new User();
        superAdminUser.setId(1L);
        superAdminUser.setEmail("superadmin@vnext.com");
        superAdminUser.setRole(UserRole.SUPER_ADMIN);

        companyAdminUser = new User();
        companyAdminUser.setId(10L);
        companyAdminUser.setEmail("companyadmin@company.com");
        companyAdminUser.setRole(UserRole.COMPANY_ADMIN);

        employeeUser = new User();
        employeeUser.setId(20L);
        employeeUser.setEmail("employee@company.com");
        employeeUser.setRole(UserRole.EMPLOYEE);
    }

    @Test
    @DisplayName("SuperAdmin login should only notify own user other devices and NOT broadcast to all SuperAdmins")
    void testSuperAdminLoginNotificationIsolation() {
        AuthRequest request = new AuthRequest();
        request.setEmail("superadmin@vnext.com");
        request.setPassword("Password@123");
        request.setDeviceToken("DEVICE_TOKEN_4");
        request.setPlatform("IOS");
        request.setDeviceName("iPhone 15");
        request.setAppVersion("1.0.0");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(superAdminUser);
        when(jwtService.generateToken(superAdminUser)).thenReturn("access-token");
        when(jwtService.generateRefreshToken(superAdminUser)).thenReturn("refresh-token");

        AuthResponse response = authService.login(request);

        assertNotNull(response);
        assertEquals("access-token", response.getAccessToken());

        // Verify only notifyUserOtherDevicesPushOnly is called for user ID 1 excluding DEVICE_TOKEN_4
        verify(notificationEventService, times(1)).notifyUserOtherDevicesPushOnly(
                eq(1L),
                eq("DEVICE_TOKEN_4"),
                eq("SuperAdmin Login"),
                eq("SUPER_ADMIN logged in successfully"),
                eq(NotificationType.SUPER_ADMIN_LOGIN),
                eq("dashboard")
        );

        // Verify notifySuperAdminsPushOnly is NEVER called
        verify(notificationEventService, never()).notifySuperAdminsPushOnly(any(), any(), any(), any());

        // Verify current device token is registered/updated
        verify(deviceTokenService, times(1)).registerDeviceToken(
                eq(1L),
                eq("DEVICE_TOKEN_4"),
                eq("IOS"),
                eq("iPhone 15"),
                eq("1.0.0")
        );
    }

    @Test
    @DisplayName("CompanyAdmin login should only notify own user other devices and NEVER notify SuperAdmin")
    void testCompanyAdminLoginNotificationIsolation() {
        AuthRequest request = new AuthRequest();
        request.setEmail("companyadmin@company.com");
        request.setPassword("Password@123");
        request.setDeviceToken("DEVICE_TOKEN_D");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(companyAdminUser);
        when(jwtService.generateToken(companyAdminUser)).thenReturn("access-token");
        when(jwtService.generateRefreshToken(companyAdminUser)).thenReturn("refresh-token");

        AuthResponse response = authService.login(request);

        assertNotNull(response);

        // Verify only notifyUserOtherDevicesPushOnly is called for user ID 10 excluding DEVICE_TOKEN_D
        verify(notificationEventService, times(1)).notifyUserOtherDevicesPushOnly(
                eq(10L),
                eq("DEVICE_TOKEN_D"),
                eq("Company Admin Login"),
                eq("Company Admin logged in successfully"),
                eq(NotificationType.COMPANY_ADMIN_LOGIN),
                eq("dashboard")
        );

        // Verify no broadcast is sent to all SuperAdmins
        verify(notificationEventService, never()).notifySuperAdminsPushOnly(any(), any(), any(), any());

        // Verify device token is registered
        verify(deviceTokenService, times(1)).registerDeviceToken(
                eq(10L),
                eq("DEVICE_TOKEN_D"),
                isNull(),
                isNull(),
                isNull()
        );
    }

    @Test
    @DisplayName("Employee login should only notify own user other devices")
    void testEmployeeLoginNotificationIsolation() {
        AuthRequest request = new AuthRequest();
        request.setEmail("employee@company.com");
        request.setPassword("Password@123");
        request.setDeviceToken("DEVICE_TOKEN_E2");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(employeeUser);
        when(jwtService.generateToken(employeeUser)).thenReturn("access-token");
        when(jwtService.generateRefreshToken(employeeUser)).thenReturn("refresh-token");

        AuthResponse response = authService.login(request);

        assertNotNull(response);

        // Verify only notifyUserOtherDevicesPushOnly is called for user ID 20 excluding DEVICE_TOKEN_E2
        verify(notificationEventService, times(1)).notifyUserOtherDevicesPushOnly(
                eq(20L),
                eq("DEVICE_TOKEN_E2"),
                eq("Employee Login"),
                eq("Employee logged in successfully"),
                eq(NotificationType.EMPLOYEE_LOGIN),
                eq("dashboard")
        );

        // Verify no admin notifications are sent
        verify(notificationEventService, never()).notifySuperAdminsPushOnly(any(), any(), any(), any());
    }
}
