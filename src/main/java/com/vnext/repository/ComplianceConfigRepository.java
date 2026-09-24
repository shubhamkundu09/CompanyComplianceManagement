package com.vnext.repository;

import com.vnext.entity.ComplianceConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComplianceConfigRepository extends JpaRepository<ComplianceConfig, Long> {

    Optional<ComplianceConfig> findByCompanyComplianceId(Long companyComplianceId);

    @Query("SELECT c FROM ComplianceConfig c WHERE c.template.id IN :templateIds")
    List<ComplianceConfig> findAllByTemplateIds(@Param("templateIds") List<Long> templateIds);

    @Query("SELECT c FROM ComplianceConfig c WHERE c.subTemplate.id IN :subTemplateIds")
    List<ComplianceConfig> findAllBySubTemplateIds(@Param("subTemplateIds") List<Long> subTemplateIds);


    // Alternative method using the ID approach
    Optional<ComplianceConfig> findByTemplateIdAndCompanyComplianceId(Long templateId, Long companyComplianceId);

    boolean existsByCompanyComplianceId(Long companyComplianceId);

    void deleteByCompanyComplianceId(Long companyComplianceId);


    // In ComplianceConfigRepository.java - Add this method

    @Query("SELECT c FROM ComplianceConfig c WHERE c.template.id = :templateId AND c.companyCompliance IS NULL")
    Optional<ComplianceConfig> findByTemplateIdAndCompanyComplianceIsNull(@Param("templateId") Long templateId);




    // Optional: also by both parent and sub‑template
    @Query("SELECT c FROM ComplianceConfig c WHERE c.template.id = :templateId AND c.subTemplate.id = :subTemplateId AND c.companyCompliance IS NULL")
    Optional<ComplianceConfig> findByTemplateIdAndSubTemplateIdAndCompanyComplianceIsNull(
            @Param("templateId") Long templateId,
            @Param("subTemplateId") Long subTemplateId);



    // In ComplianceConfigRepository.java
    @Query("SELECT c FROM ComplianceConfig c WHERE c.subTemplate.id = :subTemplateId AND c.companyCompliance IS NULL")
    Optional<ComplianceConfig> findBySubTemplateIdAndCompanyComplianceIsNull(@Param("subTemplateId") Long subTemplateId);

    @Query("SELECT c FROM ComplianceConfig c WHERE c.template.id = :templateId")
    List<ComplianceConfig> findAllByTemplateId(@Param("templateId") Long templateId);

    @Query("SELECT c FROM ComplianceConfig c WHERE c.subTemplate.id = :subTemplateId")
    List<ComplianceConfig> findAllBySubTemplateId(@Param("subTemplateId") Long subTemplateId);








    @Modifying
    @Transactional
    @Query("DELETE FROM ComplianceConfig c WHERE c.subTemplate.id = :subTemplateId")
    void deleteAllBySubTemplateId(@Param("subTemplateId") Long subTemplateId);


    @Query("SELECT c.id FROM ComplianceConfig c WHERE c.subTemplate.id = :subTemplateId")
    List<Long> findConfigIdsBySubTemplateId(@Param("subTemplateId") Long subTemplateId);

    @Query("SELECT c FROM ComplianceConfig c WHERE c.companyCompliance.id IN :complianceIds")
    List<ComplianceConfig> findAllByCompanyComplianceIdIn(@Param("complianceIds") List<Long> complianceIds);

    @Modifying
    @Transactional
    @Query("DELETE FROM ComplianceConfig c WHERE c.id IN :configIds")
    void deleteAllByIdIn(@Param("configIds") List<Long> configIds);
}