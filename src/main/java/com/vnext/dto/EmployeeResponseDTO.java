package com.vnext.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.vnext.entity.UserRole;
import com.vnext.entity.UserStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class EmployeeResponseDTO {
    private Long id;
    private String firstName;
    private String lastName;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String designation;
    private String department;
    private String employeeCode;
    private UserStatus status;
    private UserRole role;  // ADD THIS
    private boolean emailVerified;
    private Long reportingManagerId;
    private String reportingManagerName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastLoginAt;

    private Long companyId;
    private String companyName;
}