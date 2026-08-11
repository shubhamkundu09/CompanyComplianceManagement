package com.vnext.service;

import com.vnext.dto.ChangePasswordRequest;
import com.vnext.dto.ChangePasswordResponse;
import com.vnext.entity.User;
import com.vnext.exception.BusinessException;
import com.vnext.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class PasswordService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public ChangePasswordResponse changePassword(ChangePasswordRequest request, Long userId) {
        log.info("Changing password for user ID: {}", userId);

        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new BusinessException("New password and confirm password do not match");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("User not found"));

        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            throw new BusinessException("Current password is incorrect");
        }

        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword())) {
            throw new BusinessException("New password must be different from the current password");
        }

        String encodedNewPassword = passwordEncoder.encode(request.getNewPassword());
        user.setPassword(encodedNewPassword);
        user.setResetToken(null);
        user.setResetTokenExpiry(null);

        userRepository.save(user);

        log.info("Password changed successfully for user ID: {}", userId);

        return new ChangePasswordResponse(true, "Password changed successfully");
    }
}