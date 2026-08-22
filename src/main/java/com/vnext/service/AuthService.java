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

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final NotificationEventService notificationEventService;

    @Transactional
    public AuthResponse login(AuthRequest request) {
        log.info("Login attempt for user: {}", request.getEmail());

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = (User) authentication.getPrincipal();
        user.setLastLoginAt(LocalDateTime.now());
        userRepository.save(user);



        // Generate tokens
        String accessToken = jwtService.generateToken(user);
        String refreshToken = jwtService.generateRefreshToken(user);

        // Create user DTO
        UserDTO userDTO = mapToUserDTO(user);

        log.info("User logged in successfully: {}", request.getEmail());

        // Push-only login notification
        String title;
        NotificationType type;
        if (user.isSuperAdmin()) {
            title = "SuperAdmin Login";
            type = NotificationType.SUPER_ADMIN_LOGIN;
        } else if (user.isCompanyAdmin()) {
            title = "Company Admin Login";
            type = NotificationType.COMPANY_ADMIN_LOGIN;
        } else {
            title = "Employee Login";
            type = NotificationType.EMPLOYEE_LOGIN;
        }

        notificationEventService.notifyUserPushOnly(
                user.getId(),
                title,
                "You have successfully logged in.",
                type,
                "dashboard"
        );
        return new AuthResponse(accessToken, refreshToken, "Bearer", 86400000L, userDTO);
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