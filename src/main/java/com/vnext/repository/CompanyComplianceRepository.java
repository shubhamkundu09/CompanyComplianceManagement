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




    @Query("SELECT DISTINCT cc FROM CompanyCompliance cc " +
            "JOIN FETCH cc.template " +
            "LEFT JOIN FETCH cc.subTemplate " +
            "LEFT JOIN FETCH cc.config " +
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

    @Query("SELECT cc FROM CompanyCompliance cc WHERE (cc.parentTemplateId = :parentId OR cc.parentTemplateId = (SELECT p.template.id FROM CompanyCompliance p WHERE p.id = :parentId)) AND cc.isParent = false AND cc.deleted = false")
    List<CompanyCompliance> findByParentCompanyComplianceIdAndIsSubComplianceTrue(@Param("parentId") Long parentId);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.parentTemplateId = :parentId AND cc.isParent = false AND cc.deleted = false")
    List<CompanyCompliance> findSubCompliancesByParentTemplateId(@Param("parentId") Long parentId);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE (cc.parentTemplateId = :parentId OR cc.parentTemplateId = (SELECT p.template.id FROM CompanyCompliance p WHERE p.id = :parentId)) AND cc.isParent = false AND cc.deleted = false")
    long countSubCompliancesByParentId(@Param("parentId") Long parentId);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE (cc.parentTemplateId = :parentId OR cc.parentTemplateId = (SELECT p.template.id FROM CompanyCompliance p WHERE p.id = :parentId)) AND cc.isParent = false AND cc.deleted = false AND cc.status = :status")
    long countSubCompliancesByParentIdAndStatus(@Param("parentId") Long parentId, @Param("status") ComplianceStatus status);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE (cc.parentTemplateId = :parentId OR cc.parentTemplateId = (SELECT p.template.id FROM CompanyCompliance p WHERE p.id = :parentId)) AND cc.isParent = false AND cc.deleted = false AND EXISTS " +
            "(SELECT c FROM ComplianceConfig c WHERE c.companyCompliance.id = cc.id AND c.isActive = true)")
    long countConfiguredSubCompliancesByParentId(@Param("parentId") Long parentId);

    @Query("SELECT COUNT(cc) > 0 FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.template.id = :templateId AND cc.isParent = true AND cc.deleted = false")
    boolean existsByCompanyIdAndTemplateIdAndIsParentTrueAndDeletedFalse(@Param("companyId") Long companyId, @Param("templateId") Long templateId);

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.template.id = :templateId AND cc.isParent = true AND cc.deleted = false")
    List<CompanyCompliance> findAllByTemplateIdAndIsParentTrueAndDeletedFalse(@Param("templateId") Long templateId);

    @Query("SELECT COUNT(cc) > 0 FROM CompanyCompliance cc " +
            "WHERE cc.company.id = :companyId AND cc.subTemplate.id = :subTemplateId AND cc.deleted = false")
    boolean existsByCompanyIdAndSubTemplateIdAndDeletedFalse(@Param("companyId") Long companyId, @Param("subTemplateId") Long subTemplateId);


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

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId " +
            "AND cc.parentTemplateId = :templateId")
    List<CompanyCompliance> findAllSubCompliancesByCompanyIdAndParentTemplateId(@Param("companyId") Long companyId,
                                                                                @Param("templateId") Long templateId);

    @Query("SELECT DISTINCT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId " +
            "AND (cc.template.id = :templateId OR cc.parentTemplateId = :templateId)")
    List<CompanyCompliance> findAllByCompanyIdAndTemplateOrParentTemplateId(@Param("companyId") Long companyId,
                                                                           @Param("templateId") Long templateId);






    // ==================== ASSIGNMENTS: FILTERED + SORTED (DB-level) ====================

    /**
     * Paginated ID-only query — no JOIN FETCH here.
     * JOIN FETCH with Pageable causes Hibernate to load ALL rows into memory.
     * Step 1: get the page of IDs. Step 2: fetch associations via fetchByIds.
     */
    @Query(value = "SELECT cc FROM CompanyCompliance cc " +
            "LEFT JOIN cc.company c " +
            "LEFT JOIN cc.template t " +
            "LEFT JOIN cc.subTemplate st " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (:status IS NULL OR cc.status = :status) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(t.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR (st IS NOT NULL AND LOWER(st.name) LIKE LOWER(CONCAT('%', :search, '%'))))",
           countQuery = "SELECT COUNT(cc) FROM CompanyCompliance cc " +
            "LEFT JOIN cc.company c " +
            "LEFT JOIN cc.template t " +
            "LEFT JOIN cc.subTemplate st " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (:status IS NULL OR cc.status = :status) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(t.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR (st IS NOT NULL AND LOWER(st.name) LIKE LOWER(CONCAT('%', :search, '%'))))")
    Page<CompanyCompliance> findAllAssignmentsFiltered(@Param("companyId") Long companyId,
                                                       @Param("status") ComplianceStatus status,
                                                       @Param("templateId") Long templateId,
                                                       @Param("isActive") Boolean isActive,
                                                       @Param("search") String search,
                                                       Pageable pageable);

    /**
     * Overdue-specific paginated query (no JOIN FETCH, safe with Pageable).
     * Includes rows with OVERDUE status OR where due date has passed and not COMPLETED.
     */
    @Query(value = "SELECT cc FROM CompanyCompliance cc " +
            "LEFT JOIN cc.company c " +
            "LEFT JOIN cc.template t " +
            "LEFT JOIN cc.subTemplate st " +
            "LEFT JOIN cc.config cfg " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (cc.status = com.vnext.entity.ComplianceStatus.OVERDUE OR (cfg.dueDate IS NOT NULL AND cfg.dueDate < CURRENT_DATE AND cc.status != com.vnext.entity.ComplianceStatus.COMPLETED)) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(t.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR (st IS NOT NULL AND LOWER(st.name) LIKE LOWER(CONCAT('%', :search, '%'))))",
           countQuery = "SELECT COUNT(cc) FROM CompanyCompliance cc " +
            "LEFT JOIN cc.company c " +
            "LEFT JOIN cc.template t " +
            "LEFT JOIN cc.subTemplate st " +
            "LEFT JOIN cc.config cfg " +
            "WHERE cc.deleted = false " +
            "AND (:companyId IS NULL OR cc.company.id = :companyId) " +
            "AND (cc.status = com.vnext.entity.ComplianceStatus.OVERDUE OR (cfg.dueDate IS NOT NULL AND cfg.dueDate < CURRENT_DATE AND cc.status != com.vnext.entity.ComplianceStatus.COMPLETED)) " +
            "AND (:templateId IS NULL OR cc.template.id = :templateId) " +
            "AND (:isActive IS NULL OR cc.isActive = :isActive) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(t.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR (st IS NOT NULL AND LOWER(st.name) LIKE LOWER(CONCAT('%', :search, '%'))))")
    Page<CompanyCompliance> findOverdueAssignmentsFiltered(@Param("companyId") Long companyId,
                                                           @Param("templateId") Long templateId,
                                                           @Param("isActive") Boolean isActive,
                                                           @Param("search") String search,
                                                           Pageable pageable);

    /**
     * Step 2: Efficiently load full entity graph for a specific set of IDs (no pagination).
     * Use this AFTER pagination to avoid in-memory pagination.
     */
    @Query("SELECT cc FROM CompanyCompliance cc " +
            "LEFT JOIN FETCH cc.company comp " +
            "LEFT JOIN FETCH cc.template t " +
            "LEFT JOIN FETCH cc.subTemplate st " +
            "LEFT JOIN FETCH cc.config cfg " +
            "LEFT JOIN FETCH comp.companyAdmin " +
            "WHERE cc.id IN :ids")
    List<CompanyCompliance> fetchByIds(@Param("ids") List<Long> ids);

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc LEFT JOIN cc.config cfg WHERE cc.deleted = false AND cc.isActive = true AND (cc.status = com.vnext.entity.ComplianceStatus.OVERDUE OR (cfg.dueDate IS NOT NULL AND cfg.dueDate < CURRENT_DATE AND cc.status != com.vnext.entity.ComplianceStatus.COMPLETED))")
    long countOverdueActiveAssignments();

    @Query("SELECT cc.status, COUNT(cc) FROM CompanyCompliance cc WHERE cc.deleted = false AND cc.isActive = true GROUP BY cc.status")
    List<Object[]> countAssignmentsGroupedByStatus();

    @Query("SELECT COUNT(cc) FROM CompanyCompliance cc WHERE cc.deleted = false AND cc.isActive = true")
    long countTotalActiveAssignments();

    @Query("SELECT cc FROM CompanyCompliance cc WHERE cc.company.id = :companyId")
    List<CompanyCompliance> findAllByCompanyIdRaw(@Param("companyId") Long companyId);

    @Query(value = "SELECT c.id, c.name, c.email, COUNT(cc), MIN(cfg.dueDate) FROM CompanyCompliance cc " +
            "JOIN cc.company c " +
            "LEFT JOIN cc.config cfg " +
            "WHERE cc.deleted = false AND cc.isActive = true " +
            "AND (cc.status = com.vnext.entity.ComplianceStatus.OVERDUE OR (cfg.dueDate IS NOT NULL AND cfg.dueDate < CURRENT_DATE AND cc.status != com.vnext.entity.ComplianceStatus.COMPLETED)) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(c.email) LIKE LOWER(CONCAT('%', :search, '%'))) " +
            "GROUP BY c.id, c.name, c.email " +
            "ORDER BY COUNT(cc) DESC",
           countQuery = "SELECT COUNT(DISTINCT c.id) FROM CompanyCompliance cc " +
            "JOIN cc.company c " +
            "LEFT JOIN cc.config cfg " +
            "WHERE cc.deleted = false AND cc.isActive = true " +
            "AND (cc.status = com.vnext.entity.ComplianceStatus.OVERDUE OR (cfg.dueDate IS NOT NULL AND cfg.dueDate < CURRENT_DATE AND cc.status != com.vnext.entity.ComplianceStatus.COMPLETED)) " +
            "AND (:search IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(c.email) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Object[]> findOverdueCompaniesSummary(@Param("search") String search, Pageable pageable);
}