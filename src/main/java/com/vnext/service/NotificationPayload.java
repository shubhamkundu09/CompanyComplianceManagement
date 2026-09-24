package com.vnext.service;

import com.vnext.entity.NotificationType;
import lombok.Builder;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Data
@Builder
public class NotificationPayload {
    private String title;
    private String body;
    private NotificationType type;
    private Long notificationId;
    private String screen;
    private String traceId;
    private Map<String, Object> extra;

    public Map<String, String> getData() {
        var map = new HashMap<String, String>();
        if (type != null) map.put("type", type.name());
        if (notificationId != null) map.put("notificationId", notificationId.toString());
        if (screen != null) map.put("screen", screen);
        if (traceId != null && !traceId.isBlank()) {
            map.put("traceId", traceId);
        } else {
            String generated = java.util.UUID.randomUUID().toString();
            this.traceId = generated;
            map.put("traceId", generated);
        }
        if (extra != null) {
            extra.forEach((k, v) -> map.put(k, v.toString()));
        }
        return map;
    }
}