package com.vnext.entity;

public enum ComplianceTemplateType {
    NON_EDITABLE("Non-Editable"),
    SEMI_EDITABLE("Semi-Editable"),
    EDITABLE("Editable");

    private final String displayName;

    ComplianceTemplateType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
