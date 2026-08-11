package com.vnext.repository;

import com.vnext.entity.Company;
import com.vnext.entity.CompanyStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface CompanyRepository extends JpaRepository<Company, Long> {

    Optional<Company> findByName(String name);

    Optional<Company> findByEmail(String email);

    boolean existsByName(String name);

    boolean existsByEmail(String email);

    Page<Company> findByDeletedFalse(Pageable pageable);

    Page<Company> findByStatusAndDeletedFalse(CompanyStatus status, Pageable pageable);

    // FIXED: Use deleted = false instead of isActive = true
    @Query("SELECT c FROM Company c WHERE c.status = :status AND c.deleted = false")
    List<Company> findActiveCompaniesByStatus(@Param("status") CompanyStatus status);

    // FIXED: Use deleted = false instead of isActive = true
    @Query("SELECT c FROM Company c WHERE c.status = :status AND c.deleted = false")
    List<Company> findByStatusAndIsActiveTrue(@Param("status") CompanyStatus status);

    @Modifying
    @Transactional
    @Query("UPDATE Company c SET c.currentEmployeeCount = c.currentEmployeeCount + 1 WHERE c.id = :companyId AND c.currentEmployeeCount < c.employeeLimit")
    int incrementEmployeeCount(@Param("companyId") Long companyId);

    @Modifying
    @Transactional
    @Query("UPDATE Company c SET c.currentEmployeeCount = c.currentEmployeeCount - 1 WHERE c.id = :companyId AND c.currentEmployeeCount > 0")
    int decrementEmployeeCount(@Param("companyId") Long companyId);

    @Query("SELECT c FROM Company c WHERE c.deleted = false AND c.currentEmployeeCount < c.employeeLimit")
    Page<Company> findCompaniesWithAvailableSlots(Pageable pageable);

    Page<Company> findByNameContainingIgnoreCaseAndDeletedFalse(String name, Pageable pageable);

    Page<Company> findByEmailContainingIgnoreCaseAndDeletedFalse(String email, Pageable pageable);

    @Query("SELECT COUNT(c) FROM Company c WHERE c.deleted = false")
    long countActiveCompanies();

    @Query("SELECT COUNT(c) FROM Company c WHERE c.deleted = false AND c.status = :status")
    long countByStatus(@Param("status") CompanyStatus status);

    @Query("SELECT c FROM Company c WHERE c.deleted = false AND c.subscriptionEndDate <= CURRENT_DATE + 30")
    Page<Company> findCompaniesWithSubscriptionEndingSoon(Pageable pageable);

    Optional<Company> findByGstNumber(String gstNumber);

    Optional<Company> findByPanNumber(String panNumber);

    boolean existsByGstNumber(String gstNumber);

    boolean existsByPanNumber(String panNumber);

    @Query("SELECT COUNT(u) FROM User u WHERE u.company.id = :companyId AND u.role = 'EMPLOYEE' AND u.status = 'ACTIVE' AND u.deleted = false")
    long countActiveEmployeesByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT c FROM Company c WHERE c.deleted = false " +
            "AND (:status IS NULL OR c.status = :status) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(c.email) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(c.gstNumber) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Company> searchCompanies(@Param("status") CompanyStatus status,
                                  @Param("search") String search,
                                  Pageable pageable);
}