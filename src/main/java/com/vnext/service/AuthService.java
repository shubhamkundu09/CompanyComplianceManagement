// service/AuthService.java
package com.vnext.service;

import com.vnext.dto.AuthRequest;
import com.vnext.dto.AuthResponse;
import com.vnext.dto.UserDTO;
import com.vnext.entity.NotificationType;
import com.vnext.entity.User;
import com.vnext.exception.BusinessException;
import com.vnext.repository.UserRepository;
import com.vnext.security.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private static final ZoneId IST_ZONE = ZoneId.of("Asia/Kolkata");

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final NotificationEventService notificationEventService;
    private final DeviceTokenService deviceTokenService;

    @Transactional
    public AuthResponse login(AuthRequest request) {
        log.info("Login attempt for user: {}", request.getEmail());

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = (User) authentication.getPrincipal();
        user.setLastLoginAt(LocalDateTime.now(IST_ZONE));
        userRepository.save(user);

        // Generate tokens
        String accessToken = jwtService.generateToken(user);
        String refreshToken = jwtService.generateRefreshToken(user);

        // Create user DTO
        UserDTO userDTO = mapToUserDTO(user);

        log.info("User logged in successfully: {}", request.getEmail());

        // Multi-device login notifications: strictly isolated to this user's other active devices
        String title;
        String body;
        NotificationType type;
        if (user.isSuperAdmin()) {
            title = "SuperAdmin Login";
            body = "SUPER_ADMIN logged in successfully";
            type = NotificationType.SUPER_ADMIN_LOGIN;
        } else if (user.isCompanyAdmin()) {
            title = "Company Admin Login";
            body = "Company Admin logged in successfully";
            type = NotificationType.COMPANY_ADMIN_LOGIN;
        } else {
            title = "Employee Login";
            body = "Employee logged in successfully";
            type = NotificationType.EMPLOYEE_LOGIN;
        }

        // 1. Send push notification to this user's OTHER active devices (excluding the newly logged-in device)
        notificationEventService.notifyUserOtherDevicesPushOnly(
                user.getId(), request.getDeviceToken(), title, body, type, "dashboard"
        );

        // 2. Register/update current device token for this user if provided in the login request
        if (request.getDeviceToken() != null && !request.getDeviceToken().trim().isEmpty()) {
            deviceTokenService.registerDeviceToken(
                    user.getId(),
                    request.getDeviceToken().trim(),
                    request.getPlatform(),
                    request.getDeviceName(),
                    request.getAppVersion()
            );
        }

        return new AuthResponse(accessToken, refreshToken, "Bearer", jwtService.getExpiration(), userDTO);
    }

    private UserDTO mapToUserDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setFirstName(user.getFirstName());
        dto.setLastName(user.getLastName());
        dto.setEmail(user.getEmail());
        dto.setRole(user.getRole());
        dto.setStatus(user.getStatus());

        if (user.getCompany() != null) {
            dto.setCompanyId(user.getCompany().getId());
            dto.setCompanyName(user.getCompany().getName());
            // Add these for employee limit tracking
            dto.setEmployeeLimit(user.getCompany().getEmployeeLimit());
            dto.setCurrentEmployeeCount(user.getCompany().getCurrentEmployeeCount());
        }

        return dto;
    }
}