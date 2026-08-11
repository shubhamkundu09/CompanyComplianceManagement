// entity/Company.java
package com.vnext.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "companies")
@Data
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Company extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String name;

    @Column(nullable = false, unique = true)
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

    // New fields for GST and PAN
    @Column(name = "gst_number", length = 50)
    private String gstNumber;

    @Column(name = "pan_number", length = 20)
    private String panNumber;

    @Column(length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CompanyStatus status = CompanyStatus.ACTIVE;

    private Integer employeeLimit = 100;
    private Integer currentEmployeeCount = 0;

    private LocalDateTime subscriptionStartDate;
    private LocalDateTime subscriptionEndDate;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "company_admin_id")
    @JsonIgnoreProperties({"company", "password", "resetToken", "resetTokenExpiry"})
    private User companyAdmin;

    private String documentsPath;
    private boolean documentsVerified = false;
}