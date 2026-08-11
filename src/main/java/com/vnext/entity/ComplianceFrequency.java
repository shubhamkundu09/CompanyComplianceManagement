package com.vnext.entity;

public enum ComplianceFrequency {
    MONTHLY("Monthly"),
    QUARTERLY("Quarterly"),
    HALF_YEARLY("Half Yearly"),
    YEARLY("Yearly"),
    ONE_TIME("One Time");

    private final String displayName;

    ComplianceFrequency(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}