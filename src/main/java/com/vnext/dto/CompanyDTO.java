// dto/CompanyDTO.java
package com.vnext.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class CompanyDTO {

    private Long id;

    @NotBlank(message = "Company name is required")
    @Size(min = 2, max = 100, message = "Company name must be between 2 and 100 characters")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @Pattern(regexp = "^[0-9]{10,15}$", message = "Phone number must be 10-15 digits")
    private String phone;

    private String address;
    private String city;
    private String state;
    private String country;
    private String postalCode;
    private String website;
    private String taxId;
    private String registrationNumber;

    // GST number validation (India specific)
    @Pattern(regexp = "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$",
            message = "Invalid GST number format")
    private String gstNumber;

    // PAN number validation (India specific)
    @Pattern(regexp = "^[A-Z]{5}[0-9]{4}[A-Z]{1}$",
            message = "Invalid PAN number format")
    private String panNumber;

    private String description;

    private Integer employeeLimit;
    private Integer currentEmployeeCount;

    // Company Admin Details
    @NotBlank(message = "Company admin first name is required")
    private String adminFirstName;

    @NotBlank(message = "Company admin last name is required")
    private String adminLastName;

    @NotBlank(message = "Company admin email is required")
    @Email(message = "Invalid admin email format")
    private String adminEmail;
}