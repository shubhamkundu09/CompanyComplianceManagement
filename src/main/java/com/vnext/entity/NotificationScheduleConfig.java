package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Persists the SUPER_ADMIN-controlled notification frequency configuration.
 *
 * One row per notification type (e.g. "DUE_REMINDER").
 * The SchedulerService polls this table every N minutes and computes whether
 * the current time falls inside one of the evenly-distributed daily slots.
 *
 * Schema:
 *   notification_type  — unique key (e.g. "DUE_REMINDER")
 *   enabled            — master on/off switch
 *   times_per_day      — integer 1–20 (validated in service layer)
 *   start_hour         — hour of day (0–23) when the first slot begins
 *   end_hour           — hour of day (0–23) when the last slot is at / before
 *   last_sent_date     — date the last send was triggered (for daily idempotency)
 *   last_sent_at       — exact timestamp of last send
 *   updated_by         — ID of the super-admin who last changed the config
 */
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "notification_schedule_configs",
        uniqueConstraints = @UniqueConstraint(columnNames = "notification_type"))
@Data
public class NotificationScheduleConfig extends BaseEntity {

    /** Logical key — e.g. "DUE_REMINDER", "OVERDUE_ALERT" */
    @Column(name = "notification_type", nullable = false, length = 50)
    private String notificationType;

    /** Master switch; false = no notifications of this type are sent */
    @Column(name = "enabled", nullable = false)
    private Boolean enabled = true;

    /**
     * How many times per day to send. Valid range: 1–20.
     * The scheduler distributes sends evenly between start_hour and end_hour.
     */
    @Column(name = "times_per_day", nullable = false)
    private Integer timesPerDay = 3;

    /**
     * Hour of the first daily send slot (inclusive), IST, 0–23.
     * Default 8 = 08:00.
     */
    @Column(name = "start_hour", nullable = false)
    private Integer startHour = 8;

    /**
     * Hour of the last daily send slot (inclusive), IST, 0–23.
     * Default 20 = 20:00.  Must be > start_hour.
     */
    @Column(name = "end_hour", nullable = false)
    private Integer endHour = 20;

    /**
     * The calendar date on which the last send occurred.
     * Used to ensure idempotency: the poller will not trigger more than
     * {@code times_per_day} sends on any single calendar date.
     */
    @Column(name = "last_sent_date")
    private LocalDate lastSentDate;

    /** Exact IST timestamp of the most recent send. */
    @Column(name = "last_sent_at")
    private LocalDateTime lastSentAt;

    /**
     * How many times this type has already been sent today.
     * Reset to 0 when lastSentDate changes to a new calendar day.
     */
    @Column(name = "sent_today_count", nullable = false)
    private Integer sentTodayCount = 0;

    /** ID of the SUPER_ADMIN who last modified this configuration. */
    @Column(name = "updated_by")
    private Long updatedBy;
}
