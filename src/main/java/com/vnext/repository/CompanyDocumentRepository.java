package com.vnext.repository;

import com.vnext.entity.CompanyDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CompanyDocumentRepository extends JpaRepository<CompanyDocument, Long> {

    List<CompanyDocument> findByCompanyIdOrderByUploadedAtDesc(Long companyId);

    void deleteByCompanyId(Long companyId);

    @Query("SELECT cd FROM CompanyDocument cd WHERE cd.companyCompliance.id = :companyComplianceId")
    List<CompanyDocument> findByCompanyComplianceId(@Param("companyComplianceId") Long companyComplianceId);
}