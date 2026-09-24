package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PushEventDTO {
    private Long id;
    private Long userId;
    private String title;
    private String body;
    private String type;
    private String screen;
    private String action;
    private String traceId;
    private Map<String, String> data;
    private String createdAt;
}
