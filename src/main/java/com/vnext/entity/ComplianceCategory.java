package com.vnext.entity;

public enum ComplianceCategory {
    TAX("Tax & GST"),
    LABOUR("Labour Law"),
    LEGAL("Legal"),
    INSURANCE("Insurance"),
    LICENSE("License & Permit"),
    BILLING("Billing & Invoice"),
    DOCUMENTS("Documents"),
    NOTES("Notes & Remarks");

    private final String displayName;

    ComplianceCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}