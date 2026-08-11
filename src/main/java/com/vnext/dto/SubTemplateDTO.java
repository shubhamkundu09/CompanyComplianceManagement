package com.vnext.dto;

import lombok.Data;

@Data
public class SubTemplateDTO {
    private Long id;
    private Long parentTemplateId;
    private String parentTemplateName;
    private String name;
    private String description;
    private Integer displayOrder;
    private Boolean isActive;
}