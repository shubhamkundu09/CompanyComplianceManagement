package com.vnext.repository;

import com.vnext.entity.User;
import com.vnext.entity.UserRole;
import com.vnext.entity.UserStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    Page<User> findByRoleAndDeletedFalse(UserRole role, Pageable pageable);

    @Query("SELECT u FROM User u WHERE u.role = :role AND (u.deleted IS NULL OR u.deleted = false)")
    List<User> findAllByRoleAndDeletedFalse(@Param("role") UserRole role);

    @Query("SELECT u FROM User u LEFT JOIN FETCH u.company WHERE u.id = :id AND u.deleted = false")
    Optional<User> findByIdWithCompany(@Param("id") Long id);

    Page<User> findByCompanyIdAndRoleAndDeletedFalse(Long companyId, UserRole role, Pageable pageable);

    Optional<User> findByResetToken(String resetToken);

    Optional<User> findByEmployeeCode(String employeeCode);

    Page<User> findByCompanyIdAndRoleAndStatusAndDeletedFalse(Long companyId, UserRole role, UserStatus status, Pageable pageable);

    @Query("SELECT COUNT(u) FROM User u WHERE u.company.id = :companyId AND u.role = :role AND u.status = :status AND u.deleted = false")
    long countByCompanyIdAndRoleAndStatus(@Param("companyId") Long companyId,
                                          @Param("role") UserRole role,
                                          @Param("status") UserStatus status);

    @Query("SELECT u FROM User u WHERE u.company.id = :companyId " +
            "AND u.role = :role AND u.deleted = false " +
            "AND (:search IS NULL OR LOWER(u.firstName) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(u.lastName)  LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(u.email)     LIKE LOWER(CONCAT('%', :search, '%')) " +
            "     OR LOWER(u.employeeCode) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<User> searchByCompanyAndRole(@Param("companyId") Long companyId,
                                      @Param("role") UserRole role,
                                      @Param("search") String search,
                                      Pageable pageable);




    @Query("SELECT u FROM User u WHERE u.role IN :roles AND u.deleted = false")
    List<User> findAllByRoleInAndDeletedFalse(@Param("roles") List<UserRole> roles);

    @Query("SELECT u FROM User u WHERE u.company.id = :companyId AND u.deleted = false")
    List<User> findAllByCompanyIdAndDeletedFalse(@Param("companyId") Long companyId);
}