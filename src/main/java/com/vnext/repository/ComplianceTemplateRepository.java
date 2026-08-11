package com.vnext.repository;

import com.vnext.entity.ComplianceTemplate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComplianceTemplateRepository extends JpaRepository<ComplianceTemplate, Long> {

    // ===== ADD THIS METHOD =====
    List<ComplianceTemplate> findByIsCompanySpecificFalseAndIsActiveTrue();

    // SuperAdmin templates (not company specific) - Sorted by priority
    List<ComplianceTemplate> findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc();

    Page<ComplianceTemplate> findByIsCompanySpecificFalseAndIsActiveTrueOrderByPriorityAsc(Pageable pageable);

    // Company-specific templates - Sorted by priority
    List<ComplianceTemplate> findByCompanyIdAndIsCompanySpecificTrueAndIsActiveTrueOrderByPriorityAsc(Long companyId);

    Page<ComplianceTemplate> findByCompanyIdAndIsCompanySpecificTrueAndIsActiveTrueOrderByPriorityAsc(Long companyId, Pageable pageable);

    // Existence checks
    boolean existsByNameAndIsCompanySpecificFalse(String name);

    boolean existsByNameAndCompanyIdAndIsCompanySpecificTrue(String name, Long companyId);

    // Search - Sorted by priority
    @Query("SELECT ct FROM ComplianceTemplate ct WHERE ct.isCompanySpecific = false AND ct.isActive = true " +
            "AND LOWER(ct.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "ORDER BY ct.priority ASC, ct.name ASC")
    Page<ComplianceTemplate> searchSuperAdminTemplates(@Param("search") String search, Pageable pageable);

    @Query("SELECT ct FROM ComplianceTemplate ct WHERE ct.company.id = :companyId AND ct.isCompanySpecific = true AND ct.isActive = true " +
            "AND LOWER(ct.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "ORDER BY ct.priority ASC, ct.name ASC")
    Page<ComplianceTemplate> searchCompanyTemplates(@Param("companyId") Long companyId,
                                                    @Param("search") String search,
                                                    Pageable pageable);

    // Statistics
    long countByIsCompanySpecificFalseAndIsActiveTrue();

    long countByCompanyIdAndIsCompanySpecificTrueAndIsActiveTrue(Long companyId);
}