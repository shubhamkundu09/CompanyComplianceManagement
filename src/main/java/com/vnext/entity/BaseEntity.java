// entity/BaseEntity.java
package com.vnext.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@MappedSuperclass
@Data
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedDate
    @Column(updatable = false, name = "created_at")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @CreatedBy
    @Column(updatable = false, name = "created_by")
    private Long createdBy;

    @LastModifiedBy
    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "is_deleted")
    private boolean deleted = false;

    @Version
    @Column(name = "version")
    private Long version = 0L;

    // Helper method for soft delete
    public void softDelete() {
        this.deleted = true;
    }

    // Helper method to restore soft deleted entity
    public void restore() {
        this.deleted = false;
    }

    // Check if entity is soft deleted
    public boolean isDeleted() {
        return deleted;
    }
}