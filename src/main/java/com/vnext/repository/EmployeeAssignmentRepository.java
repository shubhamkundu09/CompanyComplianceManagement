package com.vnext.repository;

import com.vnext.entity.EmployeeAssignment;
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
public interface EmployeeAssignmentRepository extends JpaRepository<EmployeeAssignment, Long> {

    // Basic queries
    Page<EmployeeAssignment> findByEmployeeIdAndIsActiveTrue(Long employeeId, Pageable pageable);

    List<EmployeeAssignment> findByEmployeeIdAndIsActiveTrue(Long employeeId);

    @Query("SELECT ea FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId")
    List<EmployeeAssignment> findAllByEmployeeId(@Param("employeeId") Long employeeId);

    Optional<EmployeeAssignment> findByConfigIdAndEmployeeIdAndIsActiveTrue(Long configId, Long employeeId);

    boolean existsByConfigIdAndEmployeeIdAndIsActiveTrue(Long configId, Long employeeId);

    // In EmployeeAssignmentRepository.java - Add these methods

    @Query("SELECT e FROM EmployeeAssignment e WHERE e.config.id = :configId AND e.isActive = true")
    List<EmployeeAssignment> findByConfigIdAndIsActiveTrue(@Param("configId") Long configId);

    @Query("SELECT e FROM EmployeeAssignment e WHERE e.config.id IN :configIds AND e.isActive = true")
    List<EmployeeAssignment> findByConfigIdInAndIsActiveTrue(@Param("configIds") List<Long> configIds);


    @Query("SELECT ea FROM EmployeeAssignment ea " +
            "WHERE ea.isActive = true AND ea.completedAt IS NULL " +
            "AND ea.dueDate IS NOT NULL AND ea.dueDate >= :start AND ea.dueDate <= :end")
    List<EmployeeAssignment> findActiveUpcomingAssignments(@Param("start") LocalDate start,
                                                           @Param("end") LocalDate end);



    // Parent-child relationships
    List<EmployeeAssignment> findByParentAssignmentIdAndIsActiveTrue(Long parentAssignmentId);

    boolean existsByParentAssignmentIdAndIsActiveTrue(Long parentAssignmentId);

    boolean existsByParentAssignmentIdAndCompletedAtIsNotNull(Long parentAssignmentId);

    // Due date queries
    List<EmployeeAssignment> findByDueDateBeforeAndCompletedAtIsNullAndIsActiveTrue(LocalDate date);

    List<EmployeeAssignment> findByDueDateBetweenAndCompletedAtIsNullAndIsActiveTrue(LocalDate startDate, LocalDate endDate);

    // Completion queries
    @Query("SELECT COUNT(e) > 0 FROM EmployeeAssignment e WHERE e.config.id = :configId AND e.completedAt IS NOT NULL AND e.isActive = true")
    boolean isConfigCompletedByAnyEmployee(@Param("configId") Long configId);

    @Query("SELECT e FROM EmployeeAssignment e WHERE e.config.id = :configId AND e.completedAt IS NOT NULL AND e.isActive = true")
    Optional<EmployeeAssignment> findCompletedAssignmentByConfigId(@Param("configId") Long configId);

    // Bulk operations
    @Modifying
    @Transactional
    @Query("UPDATE EmployeeAssignment e SET e.completedAt = :completedAt, e.submissionReference = :submissionReference, " +
            "e.submissionDocumentUrl = :submissionDocumentUrl, e.completedBy = :completedBy " +
            "WHERE e.config.id = :configId AND e.employeeId = :employeeId AND e.isActive = true")
    int markAsCompleted(@Param("configId") Long configId,
                        @Param("employeeId") Long employeeId,
                        @Param("completedAt") LocalDate completedAt,
                        @Param("submissionReference") String submissionReference,
                        @Param("submissionDocumentUrl") String submissionDocumentUrl,
                        @Param("completedBy") Long completedBy);

    @Modifying
    @Transactional
    @Query("UPDATE EmployeeAssignment e SET e.completedAt = NULL, e.submissionReference = NULL, " +
            "e.submissionDocumentUrl = NULL, e.completedBy = NULL, e.isOverdue = false " +
            "WHERE e.config.id = :configId AND e.isActive = true")
    int resetCompletionsForConfig(@Param("configId") Long configId);

    @Modifying
    @Transactional
    @Query("UPDATE EmployeeAssignment e SET e.dueDate = :dueDate WHERE e.config.id = :configId AND e.isActive = true")
    int updateDueDateForConfig(@Param("configId") Long configId, @Param("dueDate") LocalDate dueDate);

    @Modifying
    @Transactional
    @Query("UPDATE EmployeeAssignment e SET e.isActive = false WHERE e.config.id = :configId AND e.isActive = true")
    int deactivateByConfigId(@Param("configId") Long configId);



    @Modifying
    @Transactional
    @Query("DELETE FROM EmployeeAssignment e WHERE e.config.id = :configId")
    void deleteByConfigId(@Param("configId") Long configId);



    @Modifying
    @Transactional
    @Query("DELETE FROM EmployeeAssignment e WHERE e.config.id IN :configIds")
    void deleteByConfigIds(@Param("configIds") List<Long> configIds);

    @Modifying
    @Transactional
    @Query("DELETE FROM EmployeeAssignment e WHERE e.employeeId IN :employeeIds")
    void deleteAllByEmployeeIdIn(@Param("employeeIds") List<Long> employeeIds);

    @Query(value = "SELECT ea FROM EmployeeAssignment ea " +
            "LEFT JOIN FETCH ea.config c " +
            "LEFT JOIN FETCH c.companyCompliance cc " +
            "LEFT JOIN FETCH cc.template t " +
            "LEFT JOIN FETCH cc.subTemplate st " +
            "LEFT JOIN FETCH c.template ct " +
            "LEFT JOIN FETCH c.subTemplate cst " +
            "WHERE ea.employeeId = :employeeId AND ea.isActive = true",
           countQuery = "SELECT COUNT(ea) FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId AND ea.isActive = true")
    Page<EmployeeAssignment> findByEmployeeIdWithDetails(@Param("employeeId") Long employeeId, Pageable pageable);

    @Query("SELECT COUNT(ea) FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId AND ea.isActive = true")
    long countByEmployeeIdAndIsActiveTrue(@Param("employeeId") Long employeeId);

    @Query("SELECT COUNT(ea) FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId AND ea.isActive = true AND ea.completedAt IS NOT NULL")
    long countCompletedByEmployeeId(@Param("employeeId") Long employeeId);

    @Query("SELECT COUNT(ea) FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId AND ea.isActive = true AND ea.completedAt IS NULL AND ea.dueDate < :today")
    long countOverdueByEmployeeId(@Param("employeeId") Long employeeId, @Param("today") LocalDate today);

    @Query("SELECT COUNT(ea) FROM EmployeeAssignment ea WHERE ea.employeeId = :employeeId AND ea.isActive = true AND ea.completedAt IS NULL AND (ea.dueDate >= :today OR ea.dueDate IS NULL)")
    long countPendingByEmployeeId(@Param("employeeId") Long employeeId, @Param("today") LocalDate today);
}