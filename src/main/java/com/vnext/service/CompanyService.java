package com.vnext.service;

import com.vnext.dto.*;
import com.vnext.entity.*;
import com.vnext.exception.BusinessException;
import com.vnext.exception.ResourceNotFoundException;
import com.vnext.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CompanyService {

    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final CompanyDocumentRepository documentRepository;
    private final DocumentStorageService documentStorageService;
    private final ComplianceService complianceService;
    private final CompanyDocumentRepository companyDocumentRepository;
    private final CompanyComplianceRepository companyComplianceRepository;
    private final ComplianceConfigRepository complianceConfigRepository;
    private final EmployeeAssignmentRepository employeeAssignmentRepository;
    private final ComplianceHistoryRepository complianceHistoryRepository;
    private final ComplianceDocumentRepository complianceDocumentRepository;
    private final ComplianceSubTemplateRepository complianceSubTemplateRepository; // if needed
    private final ComplianceTemplateRepository complianceTemplateRepository;
    private final NotificationEventService notificationEventService;

    // ==================== COMPANY CRUD ====================

    @Transactional
    public CompanyResponseDTO createCompany(CompanyDTO companyDTO) {
        log.info("Creating new company: {}", companyDTO.getName());

        if (companyRepository.existsByName(companyDTO.getName())) {
            throw new BusinessException("Company name already exists");
        }
        if (companyRepository.existsByEmail(companyDTO.getEmail())) {
            throw new BusinessException("Company email already exists");
        }
        if (userRepository.existsByEmail(companyDTO.getAdminEmail())) {
            throw new BusinessException("Admin email already registered");
        }

        // Validate GST number format if provided
        if (companyDTO.getGstNumber() != null && !companyDTO.getGstNumber().trim().isEmpty()) {
            if (!companyDTO.getGstNumber().matches("^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")) {
                throw new BusinessException("Invalid GST number format");
            }
            if (companyRepository.findByGstNumber(companyDTO.getGstNumber()).isPresent()) {
                throw new BusinessException("GST number already registered");
            }
        }

        if (companyDTO.getPanNumber() != null && !companyDTO.getPanNumber().trim().isEmpty()) {
            if (!companyDTO.getPanNumber().matches("^[A-Z]{5}[0-9]{4}[A-Z]{1}$")) {
                throw new BusinessException("Invalid PAN number format");
            }
            if (companyRepository.findByPanNumber(companyDTO.getPanNumber()).isPresent()) {
                throw new BusinessException("PAN number already registered");
            }
        }

        String tempPassword = generateTemporaryPassword();
        String encodedPassword = passwordEncoder.encode(tempPassword);

        User companyAdmin = new User();
        companyAdmin.setFirstName(companyDTO.getAdminFirstName());
        companyAdmin.setLastName(companyDTO.getAdminLastName());
        companyAdmin.setEmail(companyDTO.getAdminEmail());
        companyAdmin.setPassword(encodedPassword);
        companyAdmin.setRole(UserRole.COMPANY_ADMIN);
        companyAdmin.setStatus(UserStatus.ACTIVE);
        companyAdmin.setEmailVerified(true);

        User savedAdmin = userRepository.save(companyAdmin);

        Company company = new Company();
        company.setName(companyDTO.getName());
        company.setEmail(companyDTO.getEmail());
        company.setPhone(companyDTO.getPhone());
        company.setAddress(companyDTO.getAddress());
        company.setCity(companyDTO.getCity());
        company.setState(companyDTO.getState());
        company.setCountry(companyDTO.getCountry());
        company.setPostalCode(companyDTO.getPostalCode());
        company.setWebsite(companyDTO.getWebsite());
        company.setTaxId(companyDTO.getTaxId());
        company.setRegistrationNumber(companyDTO.getRegistrationNumber());
        company.setDescription(companyDTO.getDescription());
        company.setGstNumber(companyDTO.getGstNumber());
        company.setPanNumber(companyDTO.getPanNumber());
        company.setEmployeeLimit(companyDTO.getEmployeeLimit() != null ? companyDTO.getEmployeeLimit() : 100);
        company.setCurrentEmployeeCount(0);
        company.setCompanyAdmin(savedAdmin);
        company.setStatus(CompanyStatus.ACTIVE);
        company.setSubscriptionStartDate(LocalDateTime.now());
        company.setSubscriptionEndDate(LocalDateTime.now().plusYears(1));
        company.setDocumentsVerified(false);

        Company savedCompany = companyRepository.save(company);

        savedAdmin.setCompany(savedCompany);
        userRepository.save(savedAdmin);

        // ===== FIX: Assign all existing compliances to the new company =====
        try {
            assignAllCompliancesToCompany(savedCompany.getId());
            log.info("All existing compliances assigned to new company: {}", savedCompany.getId());
        } catch (Exception e) {
            log.error("Failed to assign compliances to new company: {}", e.getMessage(), e);
            // Don't throw - company creation should succeed even if compliance assignment fails
        }

        // Send credentials email
        try {
            emailService.sendCredentialsEmail(
                    companyDTO.getAdminEmail(),
                    companyDTO.getAdminFirstName(),
                    companyDTO.getAdminEmail(),
                    tempPassword
            );
            log.info("Credentials email sent successfully to: {}", companyDTO.getAdminEmail());
        } catch (Exception e) {
            log.error("Failed to send email to: {}", companyDTO.getAdminEmail(), e);
        }

        log.info("Company created successfully with ID: {}", savedCompany.getId());
        // Push-only to SuperAdmins
        notificationEventService.notifySuperAdminsPushOnly(
                "Company Created",
                "Company " + savedCompany.getName() + " has been created.",
                NotificationType.COMPANY_CREATED,
                "company_details"
        );
        return convertToDTO(savedCompany);
    }



    @Transactional
    public void assignAllCompliancesToCompany(Long companyId) {
        log.info("Assigning all existing compliances to company: {}", companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        // Get all SuperAdmin compliance templates (not company-specific)
        List<ComplianceTemplate> templates = complianceService.getAllSuperAdminTemplates();

        if (templates.isEmpty()) {
            log.info("No SuperAdmin compliance templates found to assign");
            return;
        }

        log.info("Found {} SuperAdmin compliance templates to assign", templates.size());

        int assignedCount = 0;

        for (ComplianceTemplate template : templates) {
            try {
                // Assign each template to the company
                complianceService.assignComplianceToCompany(template.getId(), companyId, company.getCreatedBy());
                assignedCount++;
                log.info("Assigned template '{}' to company: {}", template.getName(), company.getName());
            } catch (Exception e) {
                log.error("Failed to assign template '{}' to company: {}", template.getName(), e.getMessage());
            }
        }

        log.info("Successfully assigned {} out of {} compliances to company: {}",
                assignedCount, templates.size(), company.getName());
    }



    @Transactional
    public CompanyResponseDTO updateCompany(Long companyId, CompanyDTO companyDTO) {
        log.info("Updating company with ID: {}", companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        if (!company.getName().equals(companyDTO.getName()) &&
                companyRepository.existsByName(companyDTO.getName())) {
            throw new BusinessException("Company name already exists");
        }

        if (!company.getEmail().equals(companyDTO.getEmail()) &&
                companyRepository.existsByEmail(companyDTO.getEmail())) {
            throw new BusinessException("Company email already exists");
        }

        if (companyDTO.getGstNumber() != null && !companyDTO.getGstNumber().trim().isEmpty()) {
            if (!companyDTO.getGstNumber().equals(company.getGstNumber()) &&
                    companyRepository.existsByGstNumber(companyDTO.getGstNumber())) {
                throw new BusinessException("GST number already registered");
            }
        }

        if (companyDTO.getPanNumber() != null && !companyDTO.getPanNumber().trim().isEmpty()) {
            if (!companyDTO.getPanNumber().equals(company.getPanNumber()) &&
                    companyRepository.existsByPanNumber(companyDTO.getPanNumber())) {
                throw new BusinessException("PAN number already registered");
            }
        }

        company.setName(companyDTO.getName());
        company.setEmail(companyDTO.getEmail());
        company.setPhone(companyDTO.getPhone());
        company.setAddress(companyDTO.getAddress());
        company.setCity(companyDTO.getCity());
        company.setState(companyDTO.getState());
        company.setCountry(companyDTO.getCountry());
        company.setPostalCode(companyDTO.getPostalCode());
        company.setWebsite(companyDTO.getWebsite());
        company.setTaxId(companyDTO.getTaxId());
        company.setRegistrationNumber(companyDTO.getRegistrationNumber());
        company.setDescription(companyDTO.getDescription());
        company.setGstNumber(companyDTO.getGstNumber());
        company.setPanNumber(companyDTO.getPanNumber());

        if (companyDTO.getEmployeeLimit() != null) {
            if (companyDTO.getEmployeeLimit() < company.getCurrentEmployeeCount()) {
                throw new BusinessException(
                        String.format("Employee limit cannot be less than current employee count (%d)",
                                company.getCurrentEmployeeCount())
                );
            }
            company.setEmployeeLimit(companyDTO.getEmployeeLimit());
        }

        Company updatedCompany = companyRepository.save(company);
        log.info("Company updated successfully with ID: {}", updatedCompany.getId());
        notificationEventService.notifySuperAdminsPushOnly(
                "Company Updated",
                "Company " + company.getName() + " has been updated.",
                NotificationType.COMPANY_UPDATED,
                "company_details"
        );

        if (company.getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    company.getCompanyAdmin().getId(),
                    "Company Updated",
                    "Your company " + company.getName() + " has been updated.",
                    NotificationType.COMPANY_UPDATED,
                    "company_details"
            );
        }

        return convertToDTO(updatedCompany);
    }

    @Transactional
    public void deleteCompany(Long companyId) {
        log.info("Permanently deleting company with ID: {}", companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        // 1. Delete all employees (EMPLOYEE role) and their assignments
        List<User> employees = userRepository.findByCompanyIdAndRoleAndDeletedFalse(
                companyId, UserRole.EMPLOYEE, Pageable.unpaged()).getContent();
        for (User employee : employees) {
            // Delete employee assignments (if any) – assignments are not FK to User, only have employeeId
            List<EmployeeAssignment> assignments = employeeAssignmentRepository
                    .findByEmployeeIdAndIsActiveTrue(employee.getId());
            if (!assignments.isEmpty()) {
                employeeAssignmentRepository.deleteAll(assignments);
            }
            // Delete the employee user
            userRepository.delete(employee);
        }

        // 2. Delete company admin (if exists)
        User admin = company.getCompanyAdmin();
        if (admin != null) {
            // Admin might have no assignments, but delete anyway
            userRepository.delete(admin);
        }

        // 3. Delete all CompanyCompliances and their associated records
        List<CompanyCompliance> companyCompliances = companyComplianceRepository
                .findByCompanyIdAndIsActiveTrueAndDeletedFalse(companyId);
        for (CompanyCompliance cc : companyCompliances) {
            // 3a. Delete EmployeeAssignments linked to this compliance config
            complianceConfigRepository.findByCompanyComplianceId(cc.getId())
                    .ifPresent(config -> {
                        List<EmployeeAssignment> assignments = employeeAssignmentRepository
                                .findByConfigIdAndIsActiveTrue(config.getId());
                        if (!assignments.isEmpty()) {
                            employeeAssignmentRepository.deleteAll(assignments);
                        }
                        // 3b. Delete the config itself
                        complianceConfigRepository.delete(config);
                    });

            // 3c. Delete ComplianceHistory
            List<ComplianceHistory> histories = complianceHistoryRepository
                    .findByCompanyComplianceId(cc.getId());
            if (!histories.isEmpty()) {
                complianceHistoryRepository.deleteAll(histories);
            }

            // 3d. Delete ComplianceDocuments
            List<ComplianceDocument> docs = complianceDocumentRepository
                    .findByCompanyComplianceId(cc.getId());
            if (!docs.isEmpty()) {
                complianceDocumentRepository.deleteAll(docs);
            }

            // 3e. Delete the CompanyCompliance itself
            companyComplianceRepository.delete(cc);
        }

        // 4. Delete company-specific compliance templates (isCompanySpecific = true)
        List<ComplianceTemplate> customTemplates = complianceTemplateRepository
                .findByCompanyIdAndIsCompanySpecificTrueAndIsActiveTrueOrderByPriorityAsc(companyId);
        for (ComplianceTemplate template : customTemplates) {
            // Delete sub-templates (and their configs) – this is handled by template deletion cascade?
            // We need to delete sub-templates manually if not cascaded.
            // For simplicity, we delete sub-templates first.
            List<ComplianceSubTemplate> subTemplates = complianceSubTemplateRepository
                    .findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(template.getId());
            for (ComplianceSubTemplate sub : subTemplates) {
                // Delete any template-level config for this sub (companyComplianceId = null)
                complianceConfigRepository.findBySubTemplateIdAndCompanyComplianceIsNull(sub.getId())
                        .ifPresent(complianceConfigRepository::delete);
                complianceSubTemplateRepository.delete(sub);
            }
            // Delete the template itself
            complianceTemplateRepository.delete(template);
        }

        // 5. Delete all CompanyDocuments
        List<CompanyDocument> companyDocs = companyDocumentRepository.findByCompanyIdOrderByUploadedAtDesc(companyId);
        if (!companyDocs.isEmpty()) {
            companyDocumentRepository.deleteAll(companyDocs);
        }

        // 6. Finally, delete the Company
        companyRepository.delete(company);

        notificationEventService.notifySuperAdminsPushOnly(
                "Company Deleted",
                "Company " + company.getName() + " has been permanently deleted.",
                NotificationType.COMPANY_DELETED,
                "companies"
        );

        log.info("Company with ID: {} permanently deleted", companyId);
    }


    @Transactional
    public CompanyResponseDTO updateCompanyStatus(Long companyId, CompanyStatus status) {
        log.info("Updating company status: {} for company ID: {}", status, companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        company.setStatus(status);

        if (company.getCompanyAdmin() != null) {
            User admin = company.getCompanyAdmin();
            if (status == CompanyStatus.ACTIVE) {
                admin.setStatus(UserStatus.ACTIVE);
            } else if (status == CompanyStatus.DEACTIVATED) {
                admin.setStatus(UserStatus.DEACTIVE);
            }
            userRepository.save(admin);
        }

        Company updatedCompany = companyRepository.save(company);

        String statusText = status == CompanyStatus.ACTIVE ? "activated" : "deactivated";
        notificationEventService.notifySuperAdminsPushOnly(
                "Company Status Changed",
                "Company " + company.getName() + " has been " + statusText + ".",
                NotificationType.COMPANY_STATUS_CHANGED,
                "company_details"
        );

        if (company.getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    company.getCompanyAdmin().getId(),
                    "Company Status Changed",
                    "Your company has been " + statusText + ".",
                    NotificationType.COMPANY_STATUS_CHANGED,
                    "company_details"
            );
        }


        log.info("Company status updated successfully for ID: {}", companyId);
        return convertToDTO(updatedCompany);
    }

    @Transactional(readOnly = true)
    public Page<CompanyResponseDTO> getAllCompanies(Pageable pageable) {
        log.info("Fetching all companies with pagination");
        Page<Company> companies = companyRepository.findByDeletedFalse(pageable);
        return companies.map(this::convertToDTO);
    }

    @Transactional(readOnly = true)
    public Page<CompanyResponseDTO> getCompaniesByStatus(CompanyStatus status, Pageable pageable) {
        log.info("Fetching companies by status: {}", status);
        Page<Company> companies = companyRepository.findByStatusAndDeletedFalse(status, pageable);
        return companies.map(this::convertToDTO);
    }

    @Transactional(readOnly = true)
    public CompanyResponseDTO getCompanyById(Long companyId) {
        log.info("Fetching company by ID: {}", companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        if (company.isDeleted()) {
            throw new BusinessException("Company has been deleted");
        }

        return convertToDTO(company);
    }

    public Company getCompanyEntityById(Long companyId) {
        return companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));
    }

    @Transactional(readOnly = true)
    public Page<CompanyResponseDTO> searchCompanies(String search, CompanyStatus status,
                                                    String sortBy, String sortDir, Pageable pageable) {
        String s = (search == null || search.isBlank()) ? null : search.trim();
        return companyRepository.searchCompanies(status, s, pageable)
                .map(this::convertToDTO);
    }

    // ==================== EMPLOYEE COUNT MANAGEMENT ====================

    @Transactional
    public void updateEmployeeCount(Long companyId) {
        log.info("Updating employee count for company ID: {}", companyId);

        long actualCount = userRepository.countByCompanyIdAndRoleAndStatus(
                companyId, UserRole.EMPLOYEE, UserStatus.ACTIVE
        );

        Company company = getCompanyEntityById(companyId);
        company.setCurrentEmployeeCount((int) actualCount);
        companyRepository.save(company);

        log.info("Employee count updated for company {}: {}/{}",
                companyId, actualCount, company.getEmployeeLimit());
    }

    @Transactional
    public CompanyResponseDTO updateEmployeeLimit(Long companyId, Integer newLimit) {
        log.info("Updating employee limit for company ID: {} to {}", companyId, newLimit);

        if (newLimit == null || newLimit <= 0) {
            throw new BusinessException("Employee limit must be greater than 0");
        }

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        if (newLimit < company.getCurrentEmployeeCount()) {
            throw new BusinessException(
                    String.format("Cannot set limit to %d because current employee count is %d",
                            newLimit, company.getCurrentEmployeeCount())
            );
        }

        company.setEmployeeLimit(newLimit);
        Company updatedCompany = companyRepository.save(company);

        log.info("Employee limit updated for company {}", companyId);
        return convertToDTO(updatedCompany);
    }

    public long getActiveEmployeeCount(Long companyId) {
        return userRepository.countByCompanyIdAndRoleAndStatus(
                companyId, UserRole.EMPLOYEE, UserStatus.ACTIVE
        );
    }

    public boolean canAddEmployee(Long companyId) {
        Company company = getCompanyEntityById(companyId);

        if (company.getStatus() != CompanyStatus.ACTIVE) {
            throw new BusinessException("Company is not active. Cannot add employees.");
        }

        long activeCount = getActiveEmployeeCount(companyId);

        if (activeCount >= company.getEmployeeLimit()) {
            throw new BusinessException(
                    String.format("Employee limit reached. Cannot add more active employees. Limit: %d, Active: %d",
                            company.getEmployeeLimit(), activeCount)
            );
        }

        return true;
    }

    public boolean canActivateEmployee(Long companyId) {
        Company company = getCompanyEntityById(companyId);
        long activeCount = getActiveEmployeeCount(companyId);

        if (activeCount >= company.getEmployeeLimit()) {
            throw new BusinessException(
                    String.format("Cannot activate employee. Active employee limit reached. Limit: %d, Active: %d",
                            company.getEmployeeLimit(), activeCount)
            );
        }

        return true;
    }

    @Transactional
    public void updateActiveEmployeeCount(Long companyId) {
        log.info("Updating active employee count for company ID: {}", companyId);

        long activeCount = userRepository.countByCompanyIdAndRoleAndStatus(
                companyId, UserRole.EMPLOYEE, UserStatus.ACTIVE
        );

        Company company = getCompanyEntityById(companyId);
        company.setCurrentEmployeeCount((int) activeCount);
        companyRepository.save(company);

        log.info("Active employee count updated for company {}: {}", companyId, activeCount);
    }

    // ==================== DOCUMENT MANAGEMENT ====================

    @Transactional
    public List<CompanyDocumentDTO> uploadDocuments(Long companyId,
                                                    List<MultipartFile> files, Long uploadedById) {
        Company company = getCompanyEntityById(companyId);
        List<CompanyDocumentDTO> result = new ArrayList<>();

        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) continue;
            try {
                String storedName = documentStorageService.storeCompanyDocument(file);
                String url = documentStorageService.getUrl(storedName);

                CompanyDocument doc = new CompanyDocument();
                doc.setCompany(company);
                doc.setFileName(file.getOriginalFilename());
                doc.setStoredName(storedName);
                doc.setFileUrl(url);
                doc.setFileType(file.getContentType());
                doc.setFileSize(file.getSize());
                doc.setUploadedAt(LocalDateTime.now());
                doc.setUploadedBy(uploadedById);
                documentRepository.save(doc);

                result.add(convertDocToDTO(doc, uploadedById));
            } catch (Exception e) {
                log.error("Failed to store document {}: {}", file.getOriginalFilename(), e.getMessage());
            }
        }
        return result;
    }

    @Transactional
    public void deleteDocument(Long documentId, Long requestedBy) {
        CompanyDocument doc = documentRepository.findById(documentId)
                .orElseThrow(() -> new ResourceNotFoundException("Document not found"));
        try {
            documentStorageService.delete(doc.getStoredName());
        } catch (Exception e) {
            log.warn("Could not delete file from disk: {}", e.getMessage());
        }
        documentRepository.delete(doc);
    }

    @Transactional(readOnly = true)
    public List<CompanyDocumentDTO> getCompanyDocuments(Long companyId) {
        return documentRepository.findByCompanyIdOrderByUploadedAtDesc(companyId)
                .stream().map(d -> convertDocToDTO(d, d.getUploadedBy()))
                .collect(Collectors.toList());
    }

    @Transactional
    public void verifyCompanyDocuments(Long companyId) {
        log.info("Verifying documents for company ID: {}", companyId);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        company.setDocumentsVerified(true);
        companyRepository.save(company);

        log.info("Documents verified for company ID: {}", companyId);
    }

    @Transactional
    public void extendSubscription(Long companyId, int additionalMonths) {
        log.info("Extending subscription for company ID: {} by {} months", companyId, additionalMonths);

        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new ResourceNotFoundException("Company not found with ID: " + companyId));

        LocalDateTime newEndDate = company.getSubscriptionEndDate().plusMonths(additionalMonths);
        company.setSubscriptionEndDate(newEndDate);
        companyRepository.save(company);

        log.info("Subscription extended for company {}", companyId);


        notificationEventService.notifySuperAdminsPushOnly(
                "Subscription Extended",
                "Subscription for " + company.getName() + " extended by " + additionalMonths + " months.",
                NotificationType.SUBSCRIPTION_EXTENDED,
                "company_details"
        );

        if (company.getCompanyAdmin() != null) {
            notificationEventService.notifyUserPushOnly(
                    company.getCompanyAdmin().getId(),
                    "Subscription Extended",
                    "Your subscription has been extended by " + additionalMonths + " months.",
                    NotificationType.SUBSCRIPTION_EXTENDED,
                    "company_details"
            );
        }
    }

    // ==================== PASSWORD MANAGEMENT ====================

    @Transactional
    public ChangePasswordResponse changePassword(Long adminId, ChangePasswordRequest request) {
        log.info("Changing password for company admin ID: {}", adminId);

        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new BusinessException("New password and confirm password do not match");
        }

        User admin = userRepository.findById(adminId)
                .orElseThrow(() -> new ResourceNotFoundException("Admin not found with ID: " + adminId));

        if (!passwordEncoder.matches(request.getCurrentPassword(), admin.getPassword())) {
            throw new BusinessException("Current password is incorrect");
        }

        if (passwordEncoder.matches(request.getNewPassword(), admin.getPassword())) {
            throw new BusinessException("New password cannot be the same as current password");
        }

        String encodedNewPassword = passwordEncoder.encode(request.getNewPassword());
        admin.setPassword(encodedNewPassword);
        admin.setResetToken(null);
        admin.setResetTokenExpiry(null);

        userRepository.save(admin);

        log.info("Password changed successfully for company admin ID: {}", adminId);

        return new ChangePasswordResponse(true, "Password changed successfully");
    }

    // ==================== STATISTICS ====================

    public long getTotalCompanies() {
        return companyRepository.findByDeletedFalse(Pageable.unpaged()).getTotalElements();
    }

    public long getTotalActiveCompanies() {
        return companyRepository.countByStatus(CompanyStatus.ACTIVE);
    }

    public long getTotalDeactivatedCompanies() {
        return companyRepository.countByStatus(CompanyStatus.DEACTIVATED);
    }

    // ==================== HELPER METHODS ====================

    private String generateTemporaryPassword() {
        String upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
        String numbers = "0123456789";
        String specialChars = "@#$!";

        StringBuilder password = new StringBuilder();

        password.append(upperCaseLetters.charAt((int)(Math.random() * upperCaseLetters.length())));
        password.append(lowerCaseLetters.charAt((int)(Math.random() * lowerCaseLetters.length())));
        password.append(numbers.charAt((int)(Math.random() * numbers.length())));
        password.append(specialChars.charAt((int)(Math.random() * specialChars.length())));

        for (int i = 4; i < 10; i++) {
            String allChars = upperCaseLetters + lowerCaseLetters + numbers + specialChars;
            password.append(allChars.charAt((int)(Math.random() * allChars.length())));
        }

        char[] passwordArray = password.toString().toCharArray();
        for (int i = passwordArray.length - 1; i > 0; i--) {
            int j = (int)(Math.random() * (i + 1));
            char temp = passwordArray[i];
            passwordArray[i] = passwordArray[j];
            passwordArray[j] = temp;
        }

        return new String(passwordArray);
    }

    private CompanyDocumentDTO convertDocToDTO(CompanyDocument doc, Long uploadedBy) {
        CompanyDocumentDTO dto = new CompanyDocumentDTO();
        dto.setId(doc.getId());
        dto.setFileName(doc.getFileName());
        dto.setFileUrl(doc.getFileUrl());
        dto.setFileType(doc.getFileType());
        dto.setFileSize(doc.getFileSize());
        dto.setUploadedAt(doc.getUploadedAt());
        if (uploadedBy != null) {
            userRepository.findById(uploadedBy).ifPresent(u ->
                    dto.setUploadedByName(u.getFullName()));
        }
        return dto;
    }

    private CompanyResponseDTO convertToDTO(Company company) {
        CompanyResponseDTO dto = new CompanyResponseDTO();
        dto.setId(company.getId());
        dto.setName(company.getName());
        dto.setEmail(company.getEmail());
        dto.setPhone(company.getPhone());
        dto.setAddress(company.getAddress());
        dto.setCity(company.getCity());
        dto.setState(company.getState());
        dto.setCountry(company.getCountry());
        dto.setPostalCode(company.getPostalCode());
        dto.setWebsite(company.getWebsite());
        dto.setTaxId(company.getTaxId());
        dto.setRegistrationNumber(company.getRegistrationNumber());
        dto.setDescription(company.getDescription());
        dto.setGstNumber(company.getGstNumber());
        dto.setPanNumber(company.getPanNumber());
        dto.setStatus(company.getStatus());
        dto.setEmployeeLimit(company.getEmployeeLimit());
        dto.setCurrentEmployeeCount(company.getCurrentEmployeeCount());
        dto.setCreatedAt(company.getCreatedAt());
        dto.setUpdatedAt(company.getUpdatedAt());
        dto.setSubscriptionStartDate(company.getSubscriptionStartDate());
        dto.setSubscriptionEndDate(company.getSubscriptionEndDate());
        dto.setDocumentsVerified(company.isDocumentsVerified());

        if (company.getCompanyAdmin() != null) {
            CompanyResponseDTO.AdminInfoDTO adminDto = new CompanyResponseDTO.AdminInfoDTO();
            adminDto.setId(company.getCompanyAdmin().getId());
            adminDto.setFirstName(company.getCompanyAdmin().getFirstName());
            adminDto.setLastName(company.getCompanyAdmin().getLastName());
            adminDto.setEmail(company.getCompanyAdmin().getEmail());
            adminDto.setStatus(company.getCompanyAdmin().getStatus());
            adminDto.setPhoneNumber(company.getCompanyAdmin().getPhoneNumber());
            adminDto.setCreatedAt(company.getCompanyAdmin().getCreatedAt());
            dto.setCompanyAdmin(adminDto);
        }

        return dto;
    }
}