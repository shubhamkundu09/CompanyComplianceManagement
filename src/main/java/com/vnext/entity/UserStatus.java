// entity/UserStatus.java
package com.vnext.entity;

public enum UserStatus {
    ACTIVE("Active"),
    DEACTIVE("Deactive");  // Changed from DEACTIVATED to DEACTIVE

    private final String displayName;

    UserStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public boolean isActive() {
        return this == ACTIVE;
    }

    public boolean isDeactive() {
        return this == DEACTIVE;
    }

    public boolean canLogin() {
        return this == ACTIVE;
    }
}