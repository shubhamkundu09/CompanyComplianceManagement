package com.vnext.repository;

import com.vnext.entity.CompanyComplianceHistoricalRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CompanyComplianceHistoricalRecordRepository extends JpaRepository<CompanyComplianceHistoricalRecord, Long> {

    @Query("SELECT r FROM CompanyComplianceHistoricalRecord r " +
           "JOIN FETCH r.company c " +
           "JOIN FETCH r.template t " +
           "LEFT JOIN FETCH r.subTemplate st " +
           "WHERE r.deleted = false AND r.periodYear = :year " +
           "ORDER BY r.periodMonth ASC, r.dueDate ASC")
    List<CompanyComplianceHistoricalRecord> findByYearWithDetails(@Param("year") int year);

    @Query("SELECT r FROM CompanyComplianceHistoricalRecord r " +
           "JOIN FETCH r.company c " +
           "JOIN FETCH r.template t " +
           "LEFT JOIN FETCH r.subTemplate st " +
           "WHERE r.deleted = false AND c.id = :companyId AND r.periodYear = :year " +
           "ORDER BY r.periodMonth ASC, r.dueDate ASC")
    List<CompanyComplianceHistoricalRecord> findByCompanyIdAndYearWithDetails(
            @Param("companyId") Long companyId,
            @Param("year") int year);

    @Query("SELECT r FROM CompanyComplianceHistoricalRecord r " +
           "WHERE r.deleted = false AND r.company.id = :companyId " +
           "AND r.template.id = :templateId " +
           "AND ((:subTemplateId IS NULL AND r.subTemplate IS NULL) OR (r.subTemplate.id = :subTemplateId)) " +
           "AND r.periodYear = :year AND r.periodMonth = :month")
    Optional<CompanyComplianceHistoricalRecord> findExistingRecord(
            @Param("companyId") Long companyId,
            @Param("templateId") Long templateId,
            @Param("subTemplateId") Long subTemplateId,
            @Param("year") int year,
            @Param("month") int month);

    @Query("SELECT r FROM CompanyComplianceHistoricalRecord r " +
           "JOIN FETCH r.company c " +
           "JOIN FETCH r.template t " +
           "LEFT JOIN FETCH r.subTemplate st " +
           "WHERE r.id = :id AND c.id = :companyId AND r.deleted = false")
    Optional<CompanyComplianceHistoricalRecord> findByIdAndCompanyId(
            @Param("id") Long id,
            @Param("companyId") Long companyId);

    @Query("SELECT COUNT(r) > 0 FROM CompanyComplianceHistoricalRecord r " +
           "WHERE r.id = :id AND r.company.id = :companyId AND r.deleted = false")
    boolean existsByIdAndCompanyId(@Param("id") Long id, @Param("companyId") Long companyId);

    @Modifying
    @Query("DELETE FROM CompanyComplianceHistoricalRecord r WHERE r.company.id = :companyId")
    void deleteByCompanyId(@Param("companyId") Long companyId);
}

