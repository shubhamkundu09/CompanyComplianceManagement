package com.vnext.repository;

import com.vnext.entity.ComplianceDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ComplianceDocumentRepository extends JpaRepository<ComplianceDocument, Long> {

    List<ComplianceDocument> findByCompanyComplianceIdOrderByUploadedAtDesc(Long companyComplianceId);

    void deleteByCompanyComplianceId(Long companyComplianceId);

 
    List<ComplianceDocument> findByCompanyComplianceId(Long companyComplianceId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM ComplianceDocument cd WHERE cd.companyCompliance.id IN :complianceIds")
    void deleteAllByCompanyComplianceIdIn(@org.springframework.data.repository.query.Param("complianceIds") List<Long> complianceIds);
}