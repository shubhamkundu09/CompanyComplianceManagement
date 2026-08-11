package com.vnext.entity;

public enum CompanyStatus {
    ACTIVE("Active"),
    DEACTIVATED("Deactivated");

    private final String displayName;

    CompanyStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public boolean isActive() {
        return this == ACTIVE;
    }

    public boolean isDeactivated() {
        return this == DEACTIVATED;
    }
}