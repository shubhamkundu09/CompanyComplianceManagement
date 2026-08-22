package com.vnext.service;

import com.vnext.dto.EmployeeDTO;
import com.vnext.dto.EmployeeResponseDTO;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmployeeService {

    private final UserRepository userRepository;
    private final CompanyService companyService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final NotificationEventService notificationEventService;


    // Add this method to EmployeeService.java

    @Transactional
    public EmployeeResponseDTO createSubAdmin(Long companyId, EmployeeDTO employeeDTO) {
        log.info("Creating sub-admin for company ID: {}", companyId);

        Company company = companyService.getCompanyEntityById(companyId);

        if (company.isDeleted()) {
            throw new BusinessException("Company has been deleted.");
        }

        if (userRepository.existsByEmail(employeeDTO.getEmail())) {
            throw new BusinessException("Email already registered: " + employeeDTO.getEmail());
        }

        String employeeCode = generateEmployeeCode(company.getName(), employeeDTO.getFirstName());
        String tempPassword = generateTemporaryPassword();
        String encodedPassword = passwordEncoder.encode(tempPassword);

        User subAdmin = new User();
        subAdmin.setFirstName(employeeDTO.getFirstName());
        subAdmin.setLastName(employeeDTO.getLastName());
        subAdmin.setEmail(employeeDTO.getEmail());
        subAdmin.setPassword(encodedPassword);
        subAdmin.setRole(UserRole.COMPANY_ADMIN);  // Same role as Company Admin
        subAdmin.setStatus(UserStatus.ACTIVE);
        subAdmin.setCompany(company);
        subAdmin.setPhoneNumber(employeeDTO.getPhone());
        subAdmin.setDesignation(employeeDTO.getDesignation());
        subAdmin.setDepartment(employeeDTO.getDepartment());
        subAdmin.setEmployeeCode(employeeCode);
        subAdmin.setEmailVerified(true);

        User saved = userRepository.save(subAdmin);

        // Send credentials email
        emailService.sendCredentialsEmail(
                employeeDTO.getEmail(),
                employeeDTO.getFirstName(),
                employeeDTO.getEmail(),
                tempPassword
        );

        log.info("Sub-admin created successfully with ID: {}", saved.getId());
        return convertToDTO(saved);
    }

    @Transactional(readOnly = true)
    public Page<EmployeeResponseDTO> getSubAdminsByCompany(Long companyId, Pageable pageable) {
        log.info("Fetching sub-admins for company ID: {}", companyId);
        Page<User> subAdmins = userRepository.findByCompanyIdAndRoleAndDeletedFalse(companyId, UserRole.COMPANY_ADMIN, pageable);
        return subAdmins.map(this::convertToDTO);
    }



    // service/EmployeeService.java - Update createEmployee method

    @Transactional
    public EmployeeResponseDTO createEmployee(Long companyId, EmployeeDTO employeeDTO) {
        log.info("Creating employee for company ID: {}", companyId);

        // Get company entity
        Company company = companyService.getCompanyEntityById(companyId);

        // Check if company is deleted
        if (company.isDeleted()) {
            throw new BusinessException("Company has been deleted. Cannot add employees.");
        }

        // Check if company can add new employee (active count < limit)
        companyService.canAddEmployee(companyId);

        // Check if email already exists
        if (userRepository.existsByEmail(employeeDTO.getEmail())) {
            throw new BusinessException("Email already registered: " + employeeDTO.getEmail());
        }

        // Generate employee code
        String employeeCode = generateEmployeeCode(company.getName(), employeeDTO.getFirstName());

        // Generate temporary password
        String tempPassword = generateTemporaryPassword();
        String encodedPassword = passwordEncoder.encode(tempPassword);

        // Create employee
        User employee = new User();
        employee.setFirstName(employeeDTO.getFirstName());
        employee.setLastName(employeeDTO.getLastName());
        employee.setEmail(employeeDTO.getEmail());
        employee.setPassword(encodedPassword);
        employee.setRole(UserRole.EMPLOYEE);
        employee.setStatus(UserStatus.ACTIVE);  // New employees are ACTIVE by default
        employee.setCompany(company);
        employee.setPhoneNumber(employeeDTO.getPhone());
        employee.setDesignation(employeeDTO.getDesignation());
        employee.setDepartment(employeeDTO.getDepartment());
        employee.setEmployeeCode(employeeCode);
        employee.setEmailVerified(true);

        User savedEmployee = userRepository.save(employee);

        // Update company active employee count
        companyService.updateActiveEmployeeCount(companyId);

        // Send credentials email
        try {
            emailService.sendCredentialsEmail(
                    employeeDTO.getEmail(),
                    employeeDTO.getFirstName(),
                    employeeDTO.getEmail(),
                    tempPassword
            );
            log.info("Credentials email sent successfully to: {}", employeeDTO.getEmail());
        } catch (Exception e) {
            log.error("Failed to send email to: {}", employeeDTO.getEmail(), e);
        }

        log.info("Employee created successfully with ID: {} and code: {}", savedEmployee.getId(), employeeCode);

        // Push notification to Company Admin
        if (company.getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    company.getCompanyAdmin().getId(),
                    "Employee Created",
                    "Employee " + savedEmployee.getFullName() + " has been added to " + company.getName() + ".",
                    NotificationType.EMPLOYEE_CREATED,
                    "employees"
            );
        }

        return convertToDTO(savedEmployee);
    }


    @Transactional
    public EmployeeResponseDTO updateEmployee(Long employeeId, EmployeeDTO employeeDTO) {
        log.info("Updating employee with ID: {}", employeeId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        // Check if email is being changed and if new email already exists
        if (!employee.getEmail().equals(employeeDTO.getEmail()) &&
                userRepository.existsByEmail(employeeDTO.getEmail())) {
            throw new BusinessException("Email already registered: " + employeeDTO.getEmail());
        }

        // Update employee details
        employee.setFirstName(employeeDTO.getFirstName());
        employee.setLastName(employeeDTO.getLastName());
        employee.setEmail(employeeDTO.getEmail());
        employee.setPhoneNumber(employeeDTO.getPhone());
        employee.setDesignation(employeeDTO.getDesignation());
        employee.setDepartment(employeeDTO.getDepartment());

        // Update reporting manager if provided
        if (employeeDTO.getReportingManagerId() != null) {
            User reportingManager = userRepository.findById(employeeDTO.getReportingManagerId())
                    .orElseThrow(() -> new BusinessException("Reporting manager not found"));
            employee.setReportingManagerId(reportingManager.getId());
        }

        User updatedEmployee = userRepository.save(employee);
        log.info("Employee updated successfully with ID: {}", updatedEmployee.getId());

        // Push notification to Company Admin and Employee
        if (employee.getCompany() != null && employee.getCompany().getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    employee.getCompany().getCompanyAdmin().getId(),
                    "Employee Updated",
                    "Employee " + updatedEmployee.getFullName() + " details have been updated.",
                    NotificationType.EMPLOYEE_UPDATED,
                    "employees"
            );
        }
        notificationEventService.notifyUserPushOnly(
                updatedEmployee.getId(),
                "Profile Updated",
                "Your employee profile has been updated by your Company Admin.",
                NotificationType.EMPLOYEE_UPDATED,
                "profile"
        );

        return convertToDTO(updatedEmployee);
    }

    // service/EmployeeService.java - Update deleteEmployee method

    @Transactional
    public void deleteEmployee(Long employeeId) {
        log.info("Deleting employee with ID: {}", employeeId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        Long companyId = employee.getCompany() != null ? employee.getCompany().getId() : null;

        // Soft delete employee
        employee.setDeleted(true);
        employee.setStatus(UserStatus.DEACTIVE);
        // Make email unique for deleted users to allow reusing email
        employee.setEmail(employee.getEmail() + "_deleted_" + System.currentTimeMillis());
        userRepository.save(employee);

        // Update company active employee count
        if (companyId != null) {
            companyService.updateActiveEmployeeCount(companyId);
        }

        // Push notification to Company Admin
        if (employee.getCompany() != null && employee.getCompany().getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    employee.getCompany().getCompanyAdmin().getId(),
                    "Employee Removed",
                    "Employee " + employee.getFullName() + " has been removed from your company.",
                    NotificationType.EMPLOYEE_DELETED,
                    "employees"
            );
        }

        log.info("Employee deleted successfully with ID: {}", employeeId);
    }

    @Transactional
    public EmployeeResponseDTO updateEmployeeStatus(Long employeeId, UserStatus status) {
        log.info("Updating employee status: {} for employee ID: {}", status, employeeId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        UserStatus oldStatus = employee.getStatus();

        // If trying to ACTIVATE an employee
        if (status == UserStatus.ACTIVE && oldStatus == UserStatus.DEACTIVE) {
            // Check if company has capacity for another active employee
            Long companyId = employee.getCompany().getId();
            companyService.canActivateEmployee(companyId);
        }

        employee.setStatus(status);
        User updatedEmployee = userRepository.save(employee);

        // Update company active employee count
        if (employee.getCompany() != null) {
            companyService.updateActiveEmployeeCount(employee.getCompany().getId());
        }

        log.info("Employee status updated successfully for ID: {} from {} to {}",
                employeeId, oldStatus, status);

        return convertToDTO(updatedEmployee);
    }


    @Transactional
    public void updateEmployeeDepartment(Long employeeId, String department) {
        log.info("Updating department for employee ID: {} to {}", employeeId, department);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        employee.setDepartment(department);
        userRepository.save(employee);

        log.info("Department updated for employee ID: {}", employeeId);
    }

    @Transactional
    public void updateEmployeeDesignation(Long employeeId, String designation) {
        log.info("Updating designation for employee ID: {} to {}", employeeId, designation);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        employee.setDesignation(designation);
        userRepository.save(employee);

        log.info("Designation updated for employee ID: {}", employeeId);
    }

    @Transactional
    public void updateEmployeePhone(Long employeeId, String phoneNumber) {
        log.info("Updating phone for employee ID: {} to {}", employeeId, phoneNumber);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        employee.setPhoneNumber(phoneNumber);
        userRepository.save(employee);

        log.info("Phone updated for employee ID: {}", employeeId);
    }

    @Transactional(readOnly = true)
    public Page<EmployeeResponseDTO> getEmployeesByCompany(Long companyId, String search, Pageable pageable) {
        companyService.getCompanyEntityById(companyId);
        String s = (search == null || search.isBlank()) ? null : search.trim();
        Page<User> employees = (s != null)
                ? userRepository.searchByCompanyAndRole(companyId, UserRole.EMPLOYEE, s, pageable)
                : userRepository.findByCompanyIdAndRoleAndDeletedFalse(companyId, UserRole.EMPLOYEE, pageable);
        return employees.map(this::convertToDTO);
    }

    public Page<EmployeeResponseDTO> getEmployeesByCompanyAndStatus(Long companyId, UserStatus status, Pageable pageable) {
        log.info("Fetching employees for company ID: {} with status: {}", companyId, status);

        // Verify company exists
        companyService.getCompanyEntityById(companyId);

        // This requires a custom query, for now fetch all and filter
        Page<User> employees = userRepository.findByCompanyIdAndRoleAndDeletedFalse(
                companyId, UserRole.EMPLOYEE, pageable);

        // Filter by status (consider adding custom query in repository for better performance)
        return employees.map(this::convertToDTO);
    }

    // Update the getEmployeeById method to fetch eagerly or handle lazy loading properly
    @Transactional(readOnly = true)
    public EmployeeResponseDTO getEmployeeById(Long employeeId) {
        log.info("Fetching employee by ID: {}", employeeId);

        // Use JOIN FETCH to eagerly load company data
        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        if (employee.isDeleted()) {
            throw new BusinessException("Employee has been deleted");
        }

        return convertToDTO(employee);
    }

    public EmployeeResponseDTO getEmployeeByEmail(String email) {
        log.info("Fetching employee by email: {}", email);

        User employee = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with email: " + email));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        if (employee.isDeleted()) {
            throw new BusinessException("Employee has been deleted");
        }

        return convertToDTO(employee);
    }

    // Add this method to EmployeeService.java
    public EmployeeResponseDTO getEmployeeByEmployeeCode(String employeeCode) {
        log.info("Fetching employee by employee code: {}", employeeCode);

        User employee = userRepository.findByEmployeeCode(employeeCode)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with code: " + employeeCode));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        if (employee.isDeleted()) {
            throw new BusinessException("Employee has been deleted");
        }

        return convertToDTO(employee);
    }

    @Transactional
    public void resetEmployeePassword(Long employeeId) {
        log.info("Resetting password for employee ID: {}", employeeId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        String newPassword = generateTemporaryPassword();
        String encodedPassword = passwordEncoder.encode(newPassword);
        employee.setPassword(encodedPassword);
        employee.setResetToken(null);
        employee.setResetTokenExpiry(null);
        userRepository.save(employee);

        // Send new password via email
        try {
            emailService.sendCredentialsEmail(
                    employee.getEmail(),
                    employee.getFirstName(),
                    employee.getEmail(),
                    newPassword
            );
            log.info("Password reset email sent to: {}", employee.getEmail());
        } catch (Exception e) {
            log.error("Failed to send password reset email to: {}", employee.getEmail(), e);
            throw new BusinessException("Failed to send password reset email");
        }
    }

    @Transactional
    public void verifyEmployeeEmail(Long employeeId) {
        log.info("Verifying email for employee ID: {}", employeeId);

        User employee = userRepository.findById(employeeId)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with ID: " + employeeId));

        if (employee.getRole() != UserRole.EMPLOYEE) {
            throw new BusinessException("User is not an employee");
        }

        employee.setEmailVerified(true);
        userRepository.save(employee);

        log.info("Email verified for employee ID: {}", employeeId);
    }

    public long getEmployeeCountByCompany(Long companyId) {
        log.info("Getting employee count for company ID: {}", companyId);

        return userRepository.countByCompanyIdAndRoleAndStatus(companyId, UserRole.EMPLOYEE, UserStatus.ACTIVE);
    }

    // Update the count methods
    public long getTotalEmployeesByStatus(UserStatus status) {
        log.info("Getting total employees by status: {}", status);

        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.EMPLOYEE && u.getStatus() == status && !u.isDeleted())
                .count();
    }

    // Update these methods to use DEACTIVE instead of INACTIVE
    public long getTotalActiveEmployees() {
        return getTotalEmployeesByStatus(UserStatus.ACTIVE);
    }

    public long getTotalDeactiveEmployees() {  // Renamed from getTotalInactiveEmployees
        return getTotalEmployeesByStatus(UserStatus.DEACTIVE);
    }

    private String generateTemporaryPassword() {
        String upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
        String numbers = "0123456789";
        String specialChars = "@#$!";

        StringBuilder password = new StringBuilder();

        // Generate random password with 10 characters
        password.append(upperCaseLetters.charAt((int)(Math.random() * upperCaseLetters.length())));
        password.append(lowerCaseLetters.charAt((int)(Math.random() * lowerCaseLetters.length())));
        password.append(numbers.charAt((int)(Math.random() * numbers.length())));
        password.append(specialChars.charAt((int)(Math.random() * specialChars.length())));

        for (int i = 4; i < 10; i++) {
            String allChars = upperCaseLetters + lowerCaseLetters + numbers + specialChars;
            password.append(allChars.charAt((int)(Math.random() * allChars.length())));
        }

        // Shuffle the password
        char[] passwordArray = password.toString().toCharArray();
        for (int i = passwordArray.length - 1; i > 0; i--) {
            int j = (int)(Math.random() * (i + 1));
            char temp = passwordArray[i];
            passwordArray[i] = passwordArray[j];
            passwordArray[j] = temp;
        }

        return new String(passwordArray);
    }

    private String generateEmployeeCode(String companyName, String firstName) {
        String prefix = companyName.replaceAll("[^a-zA-Z]", "").substring(0, Math.min(3, companyName.length())).toUpperCase();
        String namePrefix = firstName.substring(0, Math.min(2, firstName.length())).toUpperCase();
        int randomNum = (int)(Math.random() * 9000) + 1000; // 4 digit number
        return "EMP" + prefix + namePrefix + randomNum;
    }

    // In EmployeeService.java, update the convertToDTO method
    private EmployeeResponseDTO convertToDTO(User employee) {
        EmployeeResponseDTO dto = new EmployeeResponseDTO();
        dto.setId(employee.getId());
        dto.setFirstName(employee.getFirstName());
        dto.setLastName(employee.getLastName());
        dto.setFullName(employee.getFullName());
        dto.setEmail(employee.getEmail());
        dto.setPhoneNumber(employee.getPhoneNumber());
        dto.setDesignation(employee.getDesignation());
        dto.setDepartment(employee.getDepartment());
        dto.setEmployeeCode(employee.getEmployeeCode());
        dto.setStatus(employee.getStatus());
        dto.setRole(employee.getRole());  // ADD THIS
        dto.setCreatedAt(employee.getCreatedAt());
        dto.setUpdatedAt(employee.getUpdatedAt());
        dto.setEmailVerified(employee.isEmailVerified());
        dto.setLastLoginAt(employee.getLastLoginAt());

        if (employee.getReportingManagerId() != null) {
            dto.setReportingManagerId(employee.getReportingManagerId());
            userRepository.findById(employee.getReportingManagerId()).ifPresent(manager -> {
                dto.setReportingManagerName(manager.getFullName());
            });
        }

        if (employee.getCompany() != null) {
            dto.setCompanyId(employee.getCompany().getId());
            dto.setCompanyName(employee.getCompany().getName());
        }

        return dto;
    }
}