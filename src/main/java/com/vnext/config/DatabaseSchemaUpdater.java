package com.vnext.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
@RequiredArgsConstructor
@Slf4j
public class DatabaseSchemaUpdater implements CommandLineRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) {
        log.info("Checking and updating database column types for role enums and sub-admins...");

        // 1. Modify users.role column to VARCHAR(50) so SUB_ADMIN, COMPANY_ADMIN, EMPLOYEE, SUPER_ADMIN can all be stored
        try {
            jdbcTemplate.execute("ALTER TABLE users MODIFY COLUMN role VARCHAR(50) NOT NULL");
            log.info("Successfully ensured users.role is VARCHAR(50)");
        } catch (Exception e) {
            log.warn("Notice updating users.role column: {}", e.getMessage());
        }

        // 2. Modify users.status column to VARCHAR(50)
        try {
            jdbcTemplate.execute("ALTER TABLE users MODIFY COLUMN status VARCHAR(50) NOT NULL");
            log.info("Successfully ensured users.status is VARCHAR(50)");
        } catch (Exception e) {
            log.warn("Notice updating users.status column: {}", e.getMessage());
        }

        // 3. Modify compliance_templates.template_type column to VARCHAR(50)
        try {
            jdbcTemplate.execute("ALTER TABLE compliance_templates MODIFY COLUMN template_type VARCHAR(50)");
            log.info("Successfully ensured compliance_templates.template_type is VARCHAR(50)");
        } catch (Exception e) {
            log.warn("Notice updating compliance_templates.template_type column: {}", e.getMessage());
        }


        // 5. Modify company_compliances.status column to VARCHAR(50)
        try {
            jdbcTemplate.execute("ALTER TABLE company_compliances MODIFY COLUMN status VARCHAR(50)");
        } catch (Exception e) {
            log.warn("Notice updating company_compliances.status column: {}", e.getMessage());
        }

    }
}
