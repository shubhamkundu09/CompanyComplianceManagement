package com.vnext.config;

import com.vnext.entity.User;
import com.vnext.entity.UserRole;
import com.vnext.entity.UserStatus;
import com.vnext.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${superadmin.email}")
    private String superAdminEmail;

    @Value("${superadmin.password}")
    private String superAdminPassword;

    @Value("${superadmin.first-name}")
    private String superAdminFirstName;

    @Value("${superadmin.last-name}")
    private String superAdminLastName;

    @Override
    @Transactional
    public void run(String... args) {
        try {
            initializeSuperAdmin();
        } catch (Exception e) {
            log.error("Error initializing data: {}", e.getMessage(), e);
        }
    }

    @Transactional
    private void initializeSuperAdmin() {
        try {
            if (!userRepository.findByEmail(superAdminEmail).isPresent()) {
                User superAdmin = new User();
                superAdmin.setFirstName(superAdminFirstName);
                superAdmin.setLastName(superAdminLastName);
                superAdmin.setEmail(superAdminEmail);

                // FIXED: Ensure password encoder is available
                if (passwordEncoder == null) {
                    log.error("PasswordEncoder bean is not initialized!");
                    throw new IllegalStateException("PasswordEncoder not available");
                }

                String encodedPassword = passwordEncoder.encode(superAdminPassword);
                superAdmin.setPassword(encodedPassword);
                superAdmin.setRole(UserRole.SUPER_ADMIN);
                superAdmin.setStatus(UserStatus.ACTIVE);
                superAdmin.setEmailVerified(true);

                userRepository.save(superAdmin);
                log.info("Super Admin created successfully with email: {}", superAdminEmail);
                log.info("Default password: {} (Please change after first login)", superAdminPassword);
            } else {
                log.info("Super Admin already exists with email: {}", superAdminEmail);
            }
        } catch (Exception e) {
            log.error("Failed to initialize Super Admin: {}", e.getMessage(), e);
            throw e;
        }
    }
}