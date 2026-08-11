package com.vnext.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd MMM yyyy");

    // ==================== CREDENTIALS EMAIL ====================

    public void sendCredentialsEmail(String to, String firstName, String email, String password) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject("Welcome to VNext LLP - Your Login Credentials");

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #4F46E5;">Welcome to VNext LLP!</h2>
                    <p>Dear %s,</p>
                    <p>Your account has been created successfully. Here are your login credentials:</p>
                    <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
                        <p><strong>Email:</strong> %s</p>
                        <p><strong>Password:</strong> %s</p>
                    </div>
                    <p><strong>Important:</strong> Please change your password after first login.</p>
                    <p>You can login using the following link: <a href="http://localhost:8080/login">Login Here</a></p>
                    <hr style="margin: 20px 0;">
                    <p style="color: #6B7280; font-size: 12px;">This is an automated message, please do not reply.</p>
                </div>
                """, firstName, email, password);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Credentials email sent successfully to: {}", to);

        } catch (MessagingException | MailException e) {
            log.error("Failed to send credentials email to: {}", to, e);
        }
    }

    // ==================== PASSWORD RESET EMAIL ====================

    public void sendPasswordResetEmail(String to, String firstName, String resetToken) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject("VNext LLP - Password Reset Request");

            String resetLink = "http://localhost:8080/reset-password?token=" + resetToken;

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #4F46E5;">Password Reset Request</h2>
                    <p>Dear %s,</p>
                    <p>We received a request to reset your password. Click the link below to reset it:</p>
                    <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
                        <a href="%s" style="background-color: #4F46E5; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Reset Password</a>
                    </div>
                    <p>This link will expire in 24 hours.</p>
                    <p>If you didn't request this, please ignore this email.</p>
                    <hr style="margin: 20px 0;">
                    <p style="color: #6B7280; font-size: 12px;">This is an automated message, please do not reply.</p>
                </div>
                """, firstName, resetLink);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Password reset email sent successfully to: {}", to);

        } catch (MessagingException | MailException e) {
            log.error("Failed to send password reset email to: {}", to, e);
        }
    }

    // ==================== COMPLIANCE ASSIGNMENT EMAIL ====================

    public void sendAssignmentEmail(String to, String employeeName, String complianceName, LocalDate dueDate) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject("New Compliance Assigned: " + complianceName);

            String dueDateStr = dueDate != null ? dueDate.format(DATE_FORMATTER) : "Not set";
            long daysUntilDue = dueDate != null ?
                    LocalDate.now().until(dueDate).getDays() : 0;

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #4F46E5;">New Compliance Assigned</h2>
                    <p>Dear %s,</p>
                    <p>A new compliance has been assigned to you:</p>
                    <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
                        <p><strong>Compliance:</strong> %s</p>
                        <p><strong>Due Date:</strong> %s</p>
                        <p><strong>Days Remaining:</strong> %d</p>
                    </div>
                    <p>Please log in to complete this compliance.</p>
                    <hr style="margin: 20px 0;">
                    <p style="color: #6B7280; font-size: 12px;">This is an automated message, please do not reply.</p>
                </div>
                """, employeeName, complianceName, dueDateStr, daysUntilDue);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Assignment email sent to: {}", to);

        } catch (MessagingException | MailException e) {
            log.error("Failed to send assignment email to: {}", to, e);
        }
    }

    // ==================== OVERDUE NOTIFICATION EMAIL ====================

    public void sendOverdueEmailToSuperAdmin(String superAdminEmail, List<OverdueComplianceInfo> overdueList) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(superAdminEmail);
            helper.setSubject("⚠️ Compliance Overdue Alert");

            StringBuilder tableRows = new StringBuilder();
            for (OverdueComplianceInfo info : overdueList) {
                tableRows.append(String.format("""
                    <tr>
                        <td style="padding: 8px; border: 1px solid #ddd;">%s</td>
                        <td style="padding: 8px; border: 1px solid #ddd;">%s</td>
                        <td style="padding: 8px; border: 1px solid #ddd;">%s</td>
                        <td style="padding: 8px; border: 1px solid #ddd;">%s</td>
                        <td style="padding: 8px; border: 1px solid #ddd; color: #ef4444;">%d days</td>
                        <td style="padding: 8px; border: 1px solid #ddd;">%s</td>
                    </tr>
                    """,
                        info.getCompanyName(),
                        info.getComplianceName(),
                        info.getSubComplianceName() != null ? info.getSubComplianceName() : "—",
                        info.getDueDate().format(DATE_FORMATTER),
                        info.getOverdueDays(),
                        info.getAssignedTo()
                ));
            }

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto;">
                    <h2 style="color: #ef4444;">⚠️ Compliance Overdue Alert</h2>
                    <p>The following compliance(s) are overdue and require attention:</p>
                    
                    <table style="width: 100%%; border-collapse: collapse; margin: 20px 0;">
                        <thead>
                            <tr style="background-color: #f3f4f6;">
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Company</th>
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Compliance</th>
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Sub-Compliance</th>
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Due Date</th>
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Overdue By</th>
                                <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Assigned To</th>
                            </tr>
                        </thead>
                        <tbody>
                            %s
                        </tbody>
                    </table>
                    
                    <p>Please take necessary action.</p>
                    <hr style="margin: 20px 0;">
                    <p style="color: #6B7280; font-size: 12px;">This is an automated message from VNext LLP.</p>
                </div>
                """, tableRows.toString());

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Overdue email sent to superadmin: {}", superAdminEmail);

        } catch (MessagingException | MailException e) {
            log.error("Failed to send overdue email to superadmin: {}", superAdminEmail, e);
        }
    }

    // ==================== SIMPLE EMAIL ====================

    public void sendSimpleEmail(String to, String subject, String content) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content.replace("\n", "<br>"), true);

            mailSender.send(message);
            log.info("Simple email sent to: {}", to);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send simple email to: {}", to, e);
        }
    }

    // ==================== INNER CLASS ====================

    public static class OverdueComplianceInfo {
        private String companyName;
        private String complianceName;
        private String subComplianceName;
        private LocalDate dueDate;
        private int overdueDays;
        private String assignedTo;

        // Getters and Setters
        public String getCompanyName() { return companyName; }
        public void setCompanyName(String companyName) { this.companyName = companyName; }
        public String getComplianceName() { return complianceName; }
        public void setComplianceName(String complianceName) { this.complianceName = complianceName; }
        public String getSubComplianceName() { return subComplianceName; }
        public void setSubComplianceName(String subComplianceName) { this.subComplianceName = subComplianceName; }
        public LocalDate getDueDate() { return dueDate; }
        public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
        public int getOverdueDays() { return overdueDays; }
        public void setOverdueDays(int overdueDays) { this.overdueDays = overdueDays; }
        public String getAssignedTo() { return assignedTo; }
        public void setAssignedTo(String assignedTo) { this.assignedTo = assignedTo; }
    }
}