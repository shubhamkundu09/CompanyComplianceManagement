package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PushNotificationDashboardDTO {

    // Current schedule config
    private NotificationScheduleConfigDTO schedule;

    // Next scheduled push run calculations
    private String nextRunTime;         // e.g. "2026-09-23T16:00:00"
    private String nextRunFormatted;    // e.g. "Today, 04:00 PM"
    private String timeRemaining;       // e.g. "in 1h 39m"
    private Integer intervalMinutes;    // e.g. 240
    private String intervalFormatted;   // e.g. "Every 4 hours"
    private List<DailySlotDTO> dailySlots;

    // Today's metrics (00:00 to now)
    private Long todayPushesCount;
    private Long todaySuccessCount;
    private Long todayFailureCount;
    private Long todayRecipientsCount;
    private Double todaySuccessRate;

    // This week's metrics (last 7 days)
    private Long weekPushesCount;
    private Long weekSuccessCount;
    private Long weekFailureCount;
    private Long weekRecipientsCount;
    private Double weekSuccessRate;

    // All-time metrics
    private Long totalPushesCount;
    private Long totalSuccessCount;
    private Long totalFailureCount;

    // Device token metrics
    private Long totalRegisteredDevices;
    private Long androidDevicesCount;
    private Long iosDevicesCount;
    private Long activeUsersWithDevices;

    // Recent delivery logs
    private List<PushDeliveryLogDTO> recentLogs;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailySlotDTO {
        private Integer slotNumber; // 1, 2, ...
        private String timeFormatted; // "08:00 AM"
        private String status; // "COMPLETED", "NEXT", "PENDING"
        private Boolean isNext;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PushDeliveryLogDTO {
        private Long id;
        private String traceId;
        private String notificationType;
        private String title;
        private String body;
        private Integer recipientCount;
        private Integer successCount;
        private Integer failureCount;
        private String status;
        private String errorMessage;
        private String sentAtFormatted;
        private String timeAgo;
    }
}
