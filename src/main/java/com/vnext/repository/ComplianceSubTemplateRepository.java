package com.vnext.repository;

import com.vnext.entity.ComplianceSubTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComplianceSubTemplateRepository extends JpaRepository<ComplianceSubTemplate, Long> {

    // ===== NEW METHODS =====

    // Global sub‑templates (company is null)
    @Query("SELECT st FROM ComplianceSubTemplate st WHERE st.parentTemplate.id = :parentId AND st.company IS NULL AND st.isActive = true ORDER BY st.displayOrder ASC")
    List<ComplianceSubTemplate> findByParentTemplateIdAndCompanyIsNullAndIsActiveTrueOrderByDisplayOrderAsc(@Param("parentId") Long parentId);

    // Company‑specific sub‑templates
    @Query("SELECT st FROM ComplianceSubTemplate st WHERE st.parentTemplate.id = :parentId AND st.company.id = :companyId AND st.isActive = true ORDER BY st.displayOrder ASC")
    List<ComplianceSubTemplate> findByParentTemplateIdAndCompanyIdAndIsActiveTrueOrderByDisplayOrderAsc(@Param("parentId") Long parentId, @Param("companyId") Long companyId);

    // NEW: Find all by parent template IDs
    @Query("SELECT st FROM ComplianceSubTemplate st WHERE st.parentTemplate.id IN :templateIds")
    List<ComplianceSubTemplate> findAllByParentTemplateIds(@Param("templateIds") List<Long> templateIds);

    // ===== EXISTING METHODS =====

    List<ComplianceSubTemplate> findByParentTemplateIdAndIsActiveTrueOrderByDisplayOrderAsc(Long parentTemplateId);

    List<ComplianceSubTemplate> findByParentTemplateIdOrderByDisplayOrderAsc(Long parentTemplateId);

    Optional<ComplianceSubTemplate> findByIdAndIsActiveTrue(Long id);

    @Query("SELECT cst FROM ComplianceSubTemplate cst WHERE cst.parentTemplate.id = :parentTemplateId AND cst.deleted = false ORDER BY cst.displayOrder ASC")
    List<ComplianceSubTemplate> findByParentTemplateIdAndDeletedFalseOrderByDisplayOrderAsc(@Param("parentTemplateId") Long parentTemplateId);

    boolean existsByParentTemplateIdAndNameAndIsActiveTrue(Long parentTemplateId, String name);

    // For counting sub‑templates per template (global only)
    @Query("SELECT st.parentTemplate.id, COUNT(st) FROM ComplianceSubTemplate st WHERE st.parentTemplate.id IN :templateIds AND st.company IS NULL GROUP BY st.parentTemplate.id")
    List<Object[]> countSubTemplatesByTemplateIds(@Param("templateIds") List<Long> templateIds);

    @Query("SELECT COUNT(c) FROM CompanyCompliance c WHERE c.subTemplate.id = :subTemplateId AND c.isActive = true")
    long countAssignmentsBySubTemplateId(@Param("subTemplateId") Long subTemplateId);

    @Modifying
    @Transactional
    @Query("UPDATE ComplianceSubTemplate cst SET cst.isActive = :active WHERE cst.id = :id")
    int updateActiveStatus(@Param("id") Long id, @Param("active") Boolean active);

    // Additional utility methods
    @Query("SELECT st FROM ComplianceSubTemplate st WHERE st.parentTemplate.id = :parentId AND st.company IS NULL AND st.deleted = false ORDER BY st.displayOrder ASC")
    List<ComplianceSubTemplate> findGlobalSubTemplatesByParent(@Param("parentId") Long parentId);

    @Query("SELECT st FROM ComplianceSubTemplate st WHERE st.parentTemplate.id = :parentId AND st.company.id = :companyId AND st.deleted = false ORDER BY st.displayOrder ASC")
    List<ComplianceSubTemplate> findCompanySubTemplatesByParent(@Param("parentId") Long parentId, @Param("companyId") Long companyId);
}