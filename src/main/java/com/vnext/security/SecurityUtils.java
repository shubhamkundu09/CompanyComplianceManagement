package com.vnext.security;

import com.vnext.entity.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@Slf4j
public class SecurityUtils {

    public static Long getCurrentUserId() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof User) {
                return ((User) authentication.getPrincipal()).getId();
            }
        } catch (Exception e) {
            log.error("Error getting current user ID: {}", e.getMessage());
        }
        return null;
    }

    public static User getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof User) {
                return (User) authentication.getPrincipal();
            }
        } catch (Exception e) {
            log.error("Error getting current user: {}", e.getMessage());
        }
        return null;
    }

    // Additional helper methods
    public static boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated()
                && !(authentication.getPrincipal() instanceof String);
    }

    public static String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return null;
    }
}