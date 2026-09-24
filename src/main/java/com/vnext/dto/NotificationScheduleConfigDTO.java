package com.vnext.dto;

import lombok.Data;

/**
 * DTO for reading and updating physical device FCM push reminder frequency.
 *
 * IMPORTANT ARCHITECTURAL DISTINCTION:
 * This controls how many times Firebase Cloud Messaging (FCM) pushes are sent
 * to physical device notification drawers per day (Android & iOS).
 * It does NOT create in-app announcement records.
 *
 * Example request (PUT /super-admin/notification-schedule/DUE_REMINDER):
 * {
 *   "enabled": true,
 *   "timesPerDay": 10,
 *   "startHour": 8,
 *   "endHour": 20
 * }
 *
 * Target Event: NotificationType.COMPLIANCE_DUE_SOON
 * Delivery Flow: SchedulerService -> NotificationEventService.notifyUserPushOnly -> PushNotificationService -> Firebase Admin SDK -> Physical Phone Drawer
 */
@Data
public class NotificationScheduleConfigDTO {

    /** Logical key — read-only on responses, provided in URL for updates */
    private String notificationType;

    /** Master on/off switch */
    private Boolean enabled;

    /**
     * Number of sends per calendar day. Valid: 1–20.
     * Sends are evenly distributed between startHour and endHour.
     */
    private Integer timesPerDay;

    /**
     * Hour of first daily slot (0–23), IST.
     * Must be strictly less than endHour.
     */
    private Integer startHour;

    /**
     * Hour of last daily slot (0–23), IST.
     * Must be strictly greater than startHour.
     */
    private Integer endHour;

    /** ISO-8601 timestamp of the last time this type was sent (read-only on response) */
    private String lastSentAt;

    /** How many times this type has been sent today (read-only on response) */
    private Integer sentTodayCount;
}
