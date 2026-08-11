package com.vnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "users",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "email", name = "uk_users_email")
        },
        indexes = {
                @Index(name = "idx_users_email", columnList = "email"),
                @Index(name = "idx_users_company_id", columnList = "company_id"),
                @Index(name = "idx_users_role", columnList = "role"),
                @Index(name = "idx_users_status", columnList = "status")
        })
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User extends BaseEntity implements UserDetails {

    @Column(nullable = false, length = 50)
    private String firstName;

    @Column(nullable = false, length = 50)
    private String lastName;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(nullable = false)
    @JsonIgnore
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private UserRole role;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private UserStatus status = UserStatus.ACTIVE;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id", foreignKey = @ForeignKey(name = "fk_users_company"))
    @JsonIgnore
    private Company company;

    @Column(name = "email_verified")
    private boolean emailVerified = false;

    @Column(name = "reset_token", length = 255)
    @JsonIgnore
    private String resetToken;

    @Column(name = "reset_token_expiry")
    @JsonIgnore
    private LocalDateTime resetTokenExpiry;

    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;

    @Column(length = 20)
    private String phoneNumber;

    @Column(length = 100)
    private String designation;

    @Column(length = 100)
    private String department;

    @Column(name = "employee_code", length = 50)
    private String employeeCode;

    @Column(name = "reporting_manager_id")
    private Long reportingManagerId;

    @Column(name = "profile_image_url", length = 500)
    private String profileImageUrl;

    @Override
    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonExpired() {
        return true;
    }


    @Override
    @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return true;
    }


    // Helper method to get full name
    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Helper method to check if user is super admin
    public boolean isSuperAdmin() {
        return role == UserRole.SUPER_ADMIN;
    }

    // Helper method to check if user is company admin
    public boolean isCompanyAdmin() {
        return role == UserRole.COMPANY_ADMIN;
    }

    // Helper method to check if user is employee
    public boolean isEmployee() {
        return role == UserRole.EMPLOYEE;
    }


    @Override
    @JsonIgnore
    public boolean isAccountNonLocked() {
        return status == UserStatus.ACTIVE && !isDeleted();
    }

    @Override
    @JsonIgnore
    public boolean isEnabled() {
        return status == UserStatus.ACTIVE && !isDeleted() && emailVerified;
    }



    @Column(name = "last_reminder_sent")
    private LocalDate lastReminderSent;


}