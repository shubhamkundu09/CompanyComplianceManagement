package com.vnext.repository;

import com.vnext.entity.ComplianceDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ComplianceDocumentRepository extends JpaRepository<ComplianceDocument, Long> {

    List<ComplianceDocument> findByCompanyComplianceIdOrderByUploadedAtDesc(Long companyComplianceId);

    void deleteByCompanyComplianceId(Long companyComplianceId);

 
    // Add to ComplianceDocumentRepository.java
    List<ComplianceDocument> findByCompanyComplianceId(Long companyComplianceId);
}