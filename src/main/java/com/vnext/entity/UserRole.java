// entity/UserRole.java
package com.vnext.entity;

public enum UserRole {
    SUPER_ADMIN("Super Administrator"),
    COMPANY_ADMIN("Company Administrator"),
    EMPLOYEE("Employee");

    private final String displayName;

    UserRole(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static UserRole fromString(String role) {
        for (UserRole userRole : UserRole.values()) {
            if (userRole.name().equalsIgnoreCase(role)) {
                return userRole;
            }
        }
        throw new IllegalArgumentException("No constant with text " + role + " found");
    }
}