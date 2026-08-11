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

    // Optional: Add method to delete by company compliance ID
    void deleteByCompanyComplianceId(Long companyComplianceId);
}