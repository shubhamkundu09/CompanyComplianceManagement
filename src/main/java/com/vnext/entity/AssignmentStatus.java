package com.vnext.entity;

public enum AssignmentStatus {
    PENDING("Pending"),
    IN_PROGRESS("In Progress"),
    COMPLETED("Completed"),
    OVERDUE("Overdue"),
    EXEMPTED("Exempted");

    private final String displayName;

    AssignmentStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}