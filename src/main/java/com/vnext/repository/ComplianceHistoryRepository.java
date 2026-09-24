package com.vnext.repository;

import com.vnext.entity.ComplianceHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ComplianceHistoryRepository extends JpaRepository<ComplianceHistory, Long> {

    List<ComplianceHistory> findByCompanyComplianceIdOrderByPerformedAtDesc(Long companyComplianceId);

    // Add this method for finding by company compliance ID
    List<ComplianceHistory> findByCompanyComplianceId(Long companyComplianceId);

    void deleteByCompanyComplianceId(Long companyComplianceId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM ComplianceHistory ch WHERE ch.companyCompliance.id IN :complianceIds")
    void deleteAllByCompanyComplianceIdIn(@org.springframework.data.repository.query.Param("complianceIds") List<Long> complianceIds);
}