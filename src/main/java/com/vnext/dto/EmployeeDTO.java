package com.vnext.dto;

import com.vnext.entity.UserRole;
import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class EmployeeDTO {

    private Long id;

    @NotBlank(message = "First name is required")
    @Size(min = 2, max = 50, message = "First name must be between 2 and 50 characters")
    private String firstName;

    @NotBlank(message = "Last name is required")
    @Size(min = 2, max = 50, message = "Last name must be between 2 and 50 characters")
    private String lastName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @Pattern(regexp = "^[0-9]{10,15}$", message = "Phone number must be 10-15 digits")
    private String phone;

    private String designation;
    private String department;

    @DecimalMin(value = "0.0", inclusive = false, message = "Salary must be greater than 0")
    private Double salary;

    private String employeeCode;
    private Long reportingManagerId;

    // ADD THIS - Role field for creating sub-admin or employee
    @NotNull(message = "User role is required")
    private UserRole role;  // Can be COMPANY_ADMIN or EMPLOYEE
}