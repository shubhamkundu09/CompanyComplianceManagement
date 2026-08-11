// dto/CompanyResponseDTO.java
package com.vnext.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.vnext.entity.CompanyStatus;
import com.vnext.entity.UserStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CompanyResponseDTO {
    private Long id;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String city;
    private String state;
    private String country;
    private String postalCode;
    private String website;
    private String taxId;
    private String registrationNumber;
    private String gstNumber;
    private String panNumber;
    private String description;
    private CompanyStatus status;
    private Integer employeeLimit;
    private Integer currentEmployeeCount;
    private boolean documentsVerified;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime subscriptionStartDate;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime subscriptionEndDate;

    private AdminInfoDTO companyAdmin;

    @Data
    public static class AdminInfoDTO {
        private Long id;
        private String firstName;
        private String lastName;
        private String email;
        private String phoneNumber;
        private UserStatus status;

        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private LocalDateTime createdAt;
    }
}