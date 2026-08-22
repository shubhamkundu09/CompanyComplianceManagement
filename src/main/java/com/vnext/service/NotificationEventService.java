package com.vnext.service;

import com.vnext.entity.Notification;
import com.vnext.entity.NotificationType;
import com.vnext.entity.User;
import com.vnext.entity.UserRole;
import com.vnext.repository.NotificationRepository;
import com.vnext.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationEventService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final com.vnext.repository.CompanyRepository companyRepository;
    private final PushNotificationService pushNotificationService;

    // ─── SAVE + PUSH (for SuperAdmin announcements) ─────────────────────────

    @Transactional
    public void notifyUsersWithSave(List<Long> userIds, String title, String body, NotificationType type, String screen, String targetRole) {
        var notification = new Notification();
        notification.setTitle(title);
        notification.setMessage(body);
        notification.setIsActive(true);
        notification.setNotificationType(type.name());
        notification.setTargetRole(targetRole);
        var saved = notificationRepository.save(notification);

        if (userIds != null && !userIds.isEmpty()) {
            var payload = NotificationPayload.builder()
                    .title(title)
                    .body(body)
                    .type(type)
                    .notificationId(saved.getId())
                    .screen(screen)
                    .build();

            sendPushAsync(userIds, payload);
        }
    }

    public void notifyUsersWithSave(List<Long> userIds, String title, String body, NotificationType type, String screen) {
        notifyUsersWithSave(userIds, title, body, type, screen, null);
    }

    public void notifySuperAdminsWithSave(String title, String body, NotificationType type, String screen) {
        var userIds = userRepository.findAllByRoleAndDeletedFalse(UserRole.SUPER_ADMIN)
                .stream().map(User::getId).collect(Collectors.toList());
        notifyUsersWithSave(userIds, title, body, type, screen, UserRole.SUPER_ADMIN.name());
    }

    public void notifyAllAdminsWithSave(String title, String body, NotificationType type, String screen) {
        var userIds = userRepository.findAllByRoleInAndDeletedFalse(List.of(UserRole.SUPER_ADMIN, UserRole.COMPANY_ADMIN))
                .stream().map(User::getId).collect(Collectors.toList());
        notifyUsersWithSave(userIds, title, body, type, screen, null);
    }

    public void notifyAllAdminsPushOnly(String title, String body, NotificationType type, String screen) {
        var userIds = userRepository.findAllByRoleInAndDeletedFalse(List.of(UserRole.SUPER_ADMIN, UserRole.COMPANY_ADMIN))
                .stream().map(User::getId).collect(Collectors.toList());
        notifyUsersPushOnly(userIds, title, body, type, screen);
    }

    // ─── PUSH ONLY (for business events) ─────────────────────────────────────

    public void notifyUsersPushOnly(List<Long> userIds, String title, String body, NotificationType type, String screen) {
        if (userIds == null || userIds.isEmpty()) return;

        List<Long> distinctUserIds = userIds.stream().filter(java.util.Objects::nonNull).distinct().collect(Collectors.toList());
        if (distinctUserIds.isEmpty()) return;

        var payload = NotificationPayload.builder()
                .title(title)
                .body(body)
                .type(type)
                .screen(screen)
                .build();

        sendPushAsync(distinctUserIds, payload);
    }

    public void notifySuperAdminsPushOnly(String title, String body, NotificationType type, String screen) {
        var userIds = userRepository.findAllByRoleAndDeletedFalse(UserRole.SUPER_ADMIN)
                .stream().map(User::getId).collect(Collectors.toList());
        notifyUsersPushOnly(userIds, title, body, type, screen);
    }

    public void notifyUserPushOnly(Long userId, String title, String body, NotificationType type, String screen) {
        if (userId != null) {
            notifyUsersPushOnly(List.of(userId), title, body, type, screen);
        }
    }

    public List<Long> getCompanyAdminUserIds(Long companyId) {
        java.util.Set<Long> adminIds = new java.util.HashSet<>();
        if (companyId != null) {
            userRepository.findByCompanyIdAndRoleAndDeletedFalse(companyId, UserRole.COMPANY_ADMIN, Pageable.unpaged())
                    .forEach(u -> adminIds.add(u.getId()));
            companyRepository.findById(companyId).ifPresent(c -> {
                if (c.getCompanyAdmin() != null && c.getCompanyAdmin().getId() != null) {
                    adminIds.add(c.getCompanyAdmin().getId());
                }
            });
        }
        return new java.util.ArrayList<>(adminIds);
    }

    public List<Long> getAllActiveCompanyAdminUserIds() {
        java.util.Set<Long> adminIds = new java.util.HashSet<>();
        List<com.vnext.entity.Company> activeCompanies = companyRepository.findActiveCompaniesByStatus(com.vnext.entity.CompanyStatus.ACTIVE);
        for (com.vnext.entity.Company c : activeCompanies) {
            userRepository.findByCompanyIdAndRoleAndDeletedFalse(c.getId(), UserRole.COMPANY_ADMIN, Pageable.unpaged())
                    .forEach(u -> adminIds.add(u.getId()));
            if (c.getCompanyAdmin() != null && c.getCompanyAdmin().getId() != null) {
                adminIds.add(c.getCompanyAdmin().getId());
            }
        }
        return new java.util.ArrayList<>(adminIds);
    }

    public void notifyCompanyAdminsPushOnly(Long companyId, String title, String body, NotificationType type, String screen) {
        List<Long> adminIds = getCompanyAdminUserIds(companyId);
        if (!adminIds.isEmpty()) {
            notifyUsersPushOnly(adminIds, title, body, type, screen);
        }
    }

    public void notifyAllActiveCompanyAdminsPushOnly(String title, String body, NotificationType type, String screen) {
        List<Long> adminIds = getAllActiveCompanyAdminUserIds();
        if (!adminIds.isEmpty()) {
            notifyUsersPushOnly(adminIds, title, body, type, screen);
        }
    }

    public void notifyAllActiveCompanyAdminsWithSave(String title, String body, NotificationType type, String screen) {
        List<Long> adminIds = getAllActiveCompanyAdminUserIds();
        if (!adminIds.isEmpty()) {
            notifyUsersWithSave(adminIds, title, body, type, screen, UserRole.COMPANY_ADMIN.name());
        }
    }

    public void notifyCompanyUsersPushOnly(Long companyId, String title, String body, NotificationType type, String screen) {
        var userIds = userRepository.findAllByCompanyIdAndDeletedFalse(companyId)
                .stream().map(User::getId).collect(Collectors.toList());
        notifyUsersPushOnly(userIds, title, body, type, screen);
    }

    // ─── ASYNC HELPER ─────────────────────────────────────────────────────────

    @Async
    public void sendPushAsync(List<Long> userIds, NotificationPayload payload) {
        pushNotificationService.sendToUsers(userIds, payload);
    }
}