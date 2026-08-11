// dto/UserDTO.java
package com.vnext.dto;

import lombok.Data;
import com.vnext.entity.UserRole;
import com.vnext.entity.UserStatus;

@Data
public class UserDTO {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private UserRole role;
    private UserStatus status;
    private Long companyId;
    private String companyName;
    private Integer employeeLimit;  // Add this
    private Integer currentEmployeeCount;  // Add this
}