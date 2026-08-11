package com.vnext.repository;

import com.vnext.entity.CompanyCompliance;
import com.vnext.entity.ComplianceConfig;
import com.vnext.entity.ComplianceStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface CompanyComplianceRepository extends JpaRepository<CompanyCompliance, Long> {


    @Query("SELECT cc.template.id, COUNT(DISTINCT cc.company.id) FROM CompanyCompliance cc " +
            "WHERE cc.template.id IN :templateIds AND cc.isActive = true AND cc.deleted = false GROUP BY cc.template.id")
    List<Object[]> countAssignedCompaniesByTemplateIds(@Param("templateIds") List<Long> templateIds);




    // ==================== BASIC QUERIES ====================

    @Query("SELECT CASE WHEN COUNT(cc) > 0 THEN true ELSE false END FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.template.id = :templateId AND cc.isActive = true AND cc.deleted = false")
    boolean existsByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId,
                                                                         @Param("templateId") Long templateId);



    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.template.id = :templateId AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdAndTemplateIdAndDeletedFalse(
            @Param("companyId") Long companyId,
            @Param("templateId") Long templateId);

// In CompanyComplianceRepository.java - Add/modify this method

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.template.id = :templateId " +
            "AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(
            @Param("companyId") Long companyId,
            @Param("templateId") Long templateId);


    // In ComplianceConfigRepository.java - Add this method

    @Query("SELECT c FROM ComplianceConfig c WHERE c.template.id = :templateId AND c.companyCompliance IS NULL")
    Optional<ComplianceConfig> findByTemplateIdAndCompanyComplianceIsNull(@Param("templateId") Long templateId);


    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId AND cc.isParent = false AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdAndIsParentFalseAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId);

    Optional<CompanyCompliance> findByIdAndDeletedFalse(Long id);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.deleted = false ORDER BY cc.createdAt DESC")
    Page<CompanyCompliance> findByDeletedFalseOrderByCreatedAtDesc(Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    Page<CompanyCompliance> findByCompanyIdAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId, Pageable pageable);




    @Query("SELECT cc FROM CompanyCompliance cc " +
            "JOIN FETCH cc.template " +
            "LEFT JOIN FETCH cc.subTemplate " +
            "WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId);




    Page<CompanyCompliance> findByIsActiveTrueAndDeletedFalse(Pageable pageable);

    Page<CompanyCompliance> findByCompanyIdAndDeletedFalse(Long companyId, Pageable pageable);

    // ==================== UNIQUENESS & EXISTENCE CHECKS ====================



    boolean existsByIdAndCompanyIdAndDeletedFalse(Long id, Long companyId);

    // ==================== STATUS-BASED QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.status = :status AND cc.isActive = true AND cc.deleted = false")
    Page<CompanyCompliance> findByCompanyIdAndStatusAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId,
                                                                                   @Param("status") ComplianceStatus status,
                                                                                   Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.status = :status AND cc.isActive = true AND cc.deleted = false")
    Page<CompanyCompliance> findByStatusAndIsActiveTrueAndDeletedFalse(@Param("status") ComplianceStatus status, Pageable pageable);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE cc.company.id = :companyId AND cc.status = :status AND cc.isActive = true AND cc.deleted = false")
    long countByCompanyIdAndStatusAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId, @Param("status") ComplianceStatus status);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE cc.status = :status AND cc.isActive = true AND cc.deleted = false")
    long countByStatusAndIsActiveTrueAndDeletedFalse(@Param("status") ComplianceStatus status);



    // ==================== TEMPLATE-BASED QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.template.id = :templateId AND cc.deleted = false")
    List<CompanyCompliance> findByTemplateIdAndDeletedFalse(@Param("templateId") Long templateId);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.template.id = :templateId AND cc.deleted = false")
    Page<CompanyCompliance> findByTemplateIdAndDeletedFalse(@Param("templateId") Long templateId, Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.template.id = :templateId AND cc.isActive = true AND cc.deleted = false")
    Page<CompanyCompliance> findByTemplateIdAndIsActiveTrueAndDeletedFalse(@Param("templateId") Long templateId, Pageable pageable);

    long countByTemplateIdAndIsActiveTrueAndDeletedFalse(Long templateId);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.template.name = :templateName AND cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByTemplateNameAndCompanyId(@Param("templateName") String templateName, @Param("companyId") Long companyId);

    // ==================== PARENT/SUB COMPLIANCE QUERIES ====================

    // FIXED: Use is_parent column and is_deleted (not deleted)
    @Query(value = "SELECT * FROM company_compliances WHERE template_id = :templateId AND is_parent = true AND is_deleted = false", nativeQuery = true)
    Page<CompanyCompliance> findByTemplateIdAndIsParentTrueAndDeletedFalse(@Param("templateId") Long templateId, Pageable pageable);

    @Query(value = "SELECT * FROM company_compliances WHERE template_id = :templateId AND is_parent = true", nativeQuery = true)
    List<CompanyCompliance> findByTemplateIdAndIsParentTrue(@Param("templateId") Long templateId);

    @Query(value = "SELECT * FROM company_compliances WHERE company_id = :companyId AND template_id = :templateId AND is_parent = true AND is_deleted = false", nativeQuery = true)
    Optional<CompanyCompliance> findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(@Param("companyId") Long companyId, @Param("templateId") Long templateId);


    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.subTemplate.id = :subTemplateId")
    List<CompanyCompliance> findBySubTemplateId(@Param("subTemplateId") Long subTemplateId);



    @Query(value = "SELECT * FROM company_compliances WHERE company_id = :companyId AND is_parent = true AND is_deleted = false", nativeQuery = true)
    Page<CompanyCompliance> findParentCompliancesByCompanyId(@Param("companyId") Long companyId, Pageable pageable);

    @Query(value = "SELECT * FROM company_compliances WHERE company_id = :companyId AND is_parent = true AND is_deleted = false", nativeQuery = true)
    List<CompanyCompliance> findAllParentCompliancesByCompanyId(@Param("companyId") Long companyId);

    // For sub-compliances: is_parent = false
    @Query(value = "SELECT * FROM company_compliances WHERE company_id = :companyId AND sub_template_id = :subTemplateId AND is_active = true AND is_deleted = false", nativeQuery = true)
    Optional<CompanyCompliance> findByCompanyIdAndSubTemplateIdAndIsActiveTrueAndDeletedFalse(@Param("companyId") Long companyId, @Param("subTemplateId") Long subTemplateId);

    @Query(value = "SELECT * FROM company_compliances WHERE company_id = :companyId AND sub_template_id = :subTemplateId", nativeQuery = true)
    Optional<CompanyCompliance> findByCompanyIdAndSubTemplateId(@Param("companyId") Long companyId, @Param("subTemplateId") Long subTemplateId);

    // If you have a parent_company_compliance_id column, but it's named differently
    @Query(value = "SELECT * FROM company_compliances WHERE parent_id = :parentId AND is_parent = false AND is_deleted = false", nativeQuery = true)
    List<CompanyCompliance> findByParentCompanyComplianceIdAndIsSubComplianceTrue(@Param("parentId") Long parentId);



    // ===== FIX: Use JPQL instead of native query =====
    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.parentTemplateId = :parentId AND cc.isParent = false AND cc.deleted = false")
    List<CompanyCompliance> findSubCompliancesByParentTemplateId(@Param("parentId") Long parentId);


    @Query(value = "SELECT COUNT(*) FROM company_compliances WHERE parent_company_compliance_id = :parentId AND is_parent = false", nativeQuery = true)
    long countSubCompliancesByParentId(@Param("parentId") Long parentId);

    @Query(value = "SELECT COUNT(*) FROM company_compliances WHERE parent_company_compliance_id = :parentId AND is_parent = false AND status = :status", nativeQuery = true)
    long countSubCompliancesByParentIdAndStatus(@Param("parentId") Long parentId, @Param("status") String status);

    @Query(value = "SELECT COUNT(*) FROM company_compliances cc WHERE cc.parent_company_compliance_id = :parentId AND cc.is_parent = false AND EXISTS " +
            "(SELECT 1 FROM compliance_configs c WHERE c.company_compliance_id = cc.id AND c.is_active = true)", nativeQuery = true)
    long countConfiguredSubCompliancesByParentId(@Param("parentId") Long parentId);

    @Query(value = "SELECT COUNT(*) > 0 FROM company_compliances " +
            "WHERE company_id = :companyId AND template_id = :templateId AND is_parent = true AND is_deleted = false", nativeQuery = true)
    boolean existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(@Param("companyId") Long companyId, @Param("templateId") Long templateId);


    // ==================== FILTERED QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.deleted = false " +
            "AND cc.isActive = true " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (:status IS NULL OR cc.status = :status) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId)")
    Page<CompanyCompliance> findAllActiveWithFilters(@Param("companyId") Long companyId,
                                                     @Param("status") ComplianceStatus status,
                                                     @Param("templateId") Long templateId,
                                                     Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (:status IS NULL OR cc.status = :status) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive)")
    Page<CompanyCompliance> findAllWithFilters(@Param("companyId") Long companyId,
                                               @Param("status") ComplianceStatus status,
                                               @Param("isActive") Boolean isActive,
                                               Pageable pageable);

    // ==================== DUE DATE & OVERDUE QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND cc.status != 'COMPLETED' " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.customDueDate BETWEEN :startDate AND :endDate)")
    List<CompanyCompliance> findUrgentCompliances(@Param("companyId") Long companyId,
                                                  @Param("startDate") LocalDate startDate,
                                                  @Param("endDate") LocalDate endDate);

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND cc.status != 'COMPLETED' " +
            "AND cc.status != 'EXEMPTED' " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.customDueDate < :date)")
    List<CompanyCompliance> findOverdueCompliances(@Param("date") LocalDate date);

    // ==================== BULK UPDATE QUERIES ====================

    @Modifying
    @Transactional
    @Query("UPDATE CompanyCompliance cc SET cc.status = 'OVERDUE' " +
            "WHERE cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND cc.status NOT IN ('COMPLETED', 'EXEMPTED') " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.customDueDate < :date)")
    int updateOverdueStatus(@Param("date") LocalDate date);

    @Modifying
    @Transactional
    @Query("UPDATE CompanyCompliance cc SET cc.deleted = true, cc.isActive = false " +
            "WHERE cc.company.id = :companyId AND cc.deleted = false")
    int softDeleteByCompanyId(@Param("companyId") Long companyId);

    @Modifying
    @Transactional
    @Query("UPDATE CompanyCompliance cc SET cc.deleted = true, cc.isActive = false " +
            "WHERE cc.template.id = :templateId AND cc.deleted = false")
    int softDeleteByTemplateId(@Param("templateId") Long templateId);

    // ==================== STATISTICS QUERIES ====================

    long countByCompanyIdAndDeletedFalse(Long companyId);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc)")
    long countConfiguredByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND NOT EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc)")
    long countUnconfiguredByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT DISTINCT cc.template.name FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    List<String> findDistinctTemplateNamesByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT DISTINCT cc.company.id FROM CompanyCompliance cc " +
            "WHERE cc.template.id = :templateId AND cc.isActive = true AND cc.deleted = false")
    List<Long> findCompanyIdsByTemplateId(@Param("templateId") Long templateId);

    // ==================== RECENT/TOP QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId AND cc.deleted = false ORDER BY cc.createdAt DESC")
    Page<CompanyCompliance> findByCompanyIdAndDeletedFalseOrderByCreatedAtDesc(@Param("companyId") Long companyId, Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.createdAt >= :since AND cc.deleted = false")
    List<CompanyCompliance> findRecentAssignments(@Param("since") LocalDate since);

    // ==================== CALENDAR/EVENT QUERIES ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.customDueDate BETWEEN :startDate AND :endDate)")
    List<CompanyCompliance> findByCompanyIdAndDueDateBetween(@Param("companyId") Long companyId,
                                                             @Param("startDate") LocalDate startDate,
                                                             @Param("endDate") LocalDate endDate);

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.customDueDate BETWEEN :startDate AND :endDate)")
    List<CompanyCompliance> findAllWithDueDateBetween(@Param("startDate") LocalDate startDate,
                                                      @Param("endDate") LocalDate endDate);

    // ==================== EMPLOYEE ASSIGNMENT RELATED ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND EXISTS (SELECT c FROM com.vnext.entity.ComplianceConfig c WHERE c.companyCompliance = cc AND c.isActive = true)")
    Page<CompanyCompliance> findAssignableCompliances(@Param("companyId") Long companyId, Pageable pageable);

    // ==================== TEMPLATE NAME SEARCH ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId " +
            "AND cc.isActive = true " +
            "AND cc.deleted = false " +
            "AND LOWER(cc.template.name) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    Page<CompanyCompliance> searchByTemplateName(@Param("companyId") Long companyId,
                                                 @Param("searchTerm") String searchTerm,
                                                 Pageable pageable);

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.deleted = false " +
            "AND (LOWER(cc.template.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
            "OR LOWER(cc.company.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')))")
    Page<CompanyCompliance> searchGlobal(@Param("searchTerm") String searchTerm, Pageable pageable);

    // ==================== BATCH OPERATIONS ====================

    @Modifying
    @Transactional
    @Query("UPDATE CompanyCompliance cc SET cc.isActive = false, cc.updatedAt = CURRENT_TIMESTAMP " +
            "WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    int deactivateByCompanyId(@Param("companyId") Long companyId);

    @Modifying
    @Transactional
    @Query("UPDATE CompanyCompliance cc SET cc.isActive = true, cc.updatedAt = CURRENT_TIMESTAMP " +
            "WHERE cc.company.id = :companyId AND cc.isActive = false AND cc.deleted = false")
    int activateByCompanyId(@Param("companyId") Long companyId);

    // ==================== COMPLETION RATE QUERIES ====================

    @Query("SELECT " +
            "COUNT(CASE WHEN cc.status = 'COMPLETED' THEN 1 END) as completed, " +
            "COUNT(CASE WHEN cc.status != 'COMPLETED' AND cc.status != 'EXEMPTED' THEN 1 END) as pending " +
            "FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    Object[] getCompletionStatsByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT " +
            "COUNT(CASE WHEN cc.status = 'COMPLETED' THEN 1 END) as completed, " +
            "COUNT(CASE WHEN cc.status != 'COMPLETED' AND cc.status != 'EXEMPTED' THEN 1 END) as pending " +
            "FROM CompanyCompliance cc " +
            "WHERE cc.isActive = true AND cc.deleted = false")
    Object[] getGlobalCompletionStats();

    // ==================== BULK FETCH ====================

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "LEFT JOIN FETCH cc.template " +
            "WHERE cc.company.id IN :companyIds AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdsWithTemplate(@Param("companyIds") List<Long> companyIds);

    @Query("SELECT cc FROM CompanyCompliance cc " +
            "LEFT JOIN FETCH cc.template " +
            "LEFT JOIN FETCH cc.company " +
            "WHERE cc.company.id = :companyId AND cc.isActive = true AND cc.deleted = false")
    List<CompanyCompliance> findByCompanyIdWithDetails(@Param("companyId") Long companyId);

    // ==================== CONVENIENCE METHODS (DEFAULT) ====================

    default Page<CompanyCompliance> findByCompanyIdAndIsActiveTrue(Long companyId, Pageable pageable) {
        return findByCompanyIdAndIsActiveTrueAndDeletedFalse(companyId, pageable);
    }

    default List<CompanyCompliance> findByCompanyIdAndIsActiveTrue(Long companyId) {
        return findByCompanyIdAndIsActiveTrueAndDeletedFalse(companyId);
    }

    // In CompanyComplianceRepository.java
    default boolean existsByCompanyIdAndTemplateIdAndIsActiveTrue(Long companyId, Long templateId) {
        return existsByCompanyIdAndTemplateIdAndIsActiveTrueAndDeletedFalse(companyId, templateId);
    }



    default Page<CompanyCompliance> findByTemplateIdAndIsActiveTrue(Long templateId, Pageable pageable) {
        return findByTemplateIdAndIsActiveTrueAndDeletedFalse(templateId, pageable);
    }

    default Optional<CompanyCompliance> findByCompanyIdAndTemplateIdAndIsParentTrue(Long companyId, Long templateId) {
        return findByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, templateId);
    }


    default boolean existsByCompanyIdAndTemplateIdAndIsSubComplianceFalseAndDeletedFalse(Long companyId, Long templateId) {
        return existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(companyId, templateId);
    }



    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId AND cc.template.id = :templateId")
    List<CompanyCompliance> findAllByCompanyIdAndTemplateId(@Param("companyId") Long companyId,
                                                            @Param("templateId") Long templateId);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId " +
            "AND cc.parentTemplateId = :templateId AND cc.isParent = false AND cc.deleted = false")
    List<CompanyCompliance> findSubCompliancesByCompanyIdAndParentTemplateId(@Param("companyId") Long companyId,
                                                                             @Param("templateId") Long templateId);






    // ==================== ASSIGNMENTS: FILTERED + SORTED (DB-level) ====================

    /**
     * Filters and sorts at the database level BEFORE pagination. Required so a company's
     * or template's assignment list can't be squeezed out of the page by unrelated rows
     * (e.g. a burst of new CompanyCompliance rows from auto-assigning every template to
     * a newly created company) getting a more recent createdAt.
     */
    @Query("SELECT cc FROM CompanyCompliance cc " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (:status IS NULL OR cc.status = :status) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive) " +
            "ORDER BY cc.template.priority ASC, cc.template.name ASC")
    Page<CompanyCompliance> findAllAssignmentsFiltered(@Param("companyId") Long companyId,
                                                       @Param("status") ComplianceStatus status,
                                                       @Param("templateId") Long templateId,
                                                       @Param("isActive") Boolean isActive,
                                                       Pageable pageable);







}