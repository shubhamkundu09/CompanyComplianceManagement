package com.vnext.repository;

import com.vnext.entity.PushDeliveryLog;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PushDeliveryLogRepository extends JpaRepository<PushDeliveryLog, Long> {

    List<PushDeliveryLog> findAllByOrderByCreatedAtDesc(Pageable pageable);

    @Query("SELECT COUNT(l) FROM PushDeliveryLog l WHERE l.createdAt >= :since")
    long countSince(@Param("since") LocalDateTime since);

    @Query("SELECT COALESCE(SUM(l.successCount), 0) FROM PushDeliveryLog l WHERE l.createdAt >= :since")
    long sumSuccessCountSince(@Param("since") LocalDateTime since);

    @Query("SELECT COALESCE(SUM(l.failureCount), 0) FROM PushDeliveryLog l WHERE l.createdAt >= :since")
    long sumFailureCountSince(@Param("since") LocalDateTime since);

    @Query("SELECT COALESCE(SUM(l.recipientCount), 0) FROM PushDeliveryLog l WHERE l.createdAt >= :since")
    long sumRecipientCountSince(@Param("since") LocalDateTime since);

    @Query("SELECT COALESCE(SUM(l.successCount), 0) FROM PushDeliveryLog l")
    long sumTotalSuccessCount();

    @Query("SELECT COALESCE(SUM(l.failureCount), 0) FROM PushDeliveryLog l")
    long sumTotalFailureCount();
}
