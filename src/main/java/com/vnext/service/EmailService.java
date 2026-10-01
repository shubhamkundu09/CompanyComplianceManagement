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

    // ==================== COMPANY EVENT EMAILS ====================

    public void sendCompanyRegistrationAlertToSuperAdmin(String superAdminEmail, String companyName, String companyEmail,
                                                        String adminName, String adminEmail, String phone,
                                                        String gstNumber, String panNumber) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(superAdminEmail);
            helper.setSubject("🏢 New Company Registered: " + companyName);

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #4F46E5; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">New Company Registration</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Hello Super Admin,</p>
                        <p>A new company has registered on the <strong>VNext Compliance Platform</strong>.</p>
                        <div style="background-color: #F9FAFB; padding: 16px; border-radius: 6px; margin: 16px 0; border-left: 4px solid #4F46E5;">
                            <p style="margin: 6px 0;"><strong>Company Name:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Company Email:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Company Admin:</strong> %s (%s)</p>
                            <p style="margin: 6px 0;"><strong>Phone:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>GST Number:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>PAN Number:</strong> %s</p>
                        </div>
                        <p>You can view and manage this company from the Super Admin dashboard.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated notification from VNext LLP.</p>
                    </div>
                </div>
                """, companyName, companyEmail, adminName, adminEmail,
                    phone != null ? phone : "N/A",
                    gstNumber != null ? gstNumber : "N/A",
                    panNumber != null ? panNumber : "N/A");

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Company registration alert email sent to Super Admin: {}", superAdminEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send company registration alert to Super Admin: {}", superAdminEmail, e);
        }
    }

    public void sendCompanyWelcomeEmail(String toEmail, String companyName, String adminName, String adminEmail, String tempPassword) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🎉 Welcome to VNext LLP - Company Registration Confirmed");

            String passwordSection = (tempPassword != null && !tempPassword.trim().isEmpty()) ? String.format("""
                <div style="background-color: #F3F4F6; padding: 16px; border-radius: 6px; margin: 16px 0;">
                    <p style="margin: 4px 0;"><strong>Admin Email:</strong> %s</p>
                    <p style="margin: 4px 0;"><strong>Temporary Password:</strong> %s</p>
                </div>
                <p style="color: #DC2626; font-size: 13px;"><em>Please change your password immediately after your first login.</em></p>
                """, adminEmail, tempPassword) : "";

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #4F46E5; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">Welcome to VNext LLP!</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Dear %s,</p>
                        <p>We are delighted to confirm that <strong>%s</strong> has been successfully registered on the VNext Compliance Management Platform.</p>
                        %s
                        <p>With VNext, you can manage your statutory compliances, track deadlines, assign tasks to employees, and stay ahead of audits effortlessly.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated message from VNext LLP.</p>
                    </div>
                </div>
                """, adminName, companyName, passwordSection);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Company welcome email sent successfully to: {}", toEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send company welcome email to: {}", toEmail, e);
        }
    }

    public void sendCompanyUpdatedEmail(String toEmail, String recipientName, String companyName, String updatedFieldsSummary) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("📝 Company Profile Updated: " + companyName);

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #2563EB; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">Company Profile Updated</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Hello %s,</p>
                        <p>The profile details for <strong>%s</strong> have been updated successfully.</p>
                        <div style="background-color: #F9FAFB; padding: 16px; border-radius: 6px; margin: 16px 0; border-left: 4px solid #2563EB;">
                            <p style="margin: 0;">%s</p>
                        </div>
                        <p>If you did not authorize these changes, please contact our support team immediately.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated notification from VNext LLP.</p>
                    </div>
                </div>
                """, recipientName, companyName, updatedFieldsSummary != null ? updatedFieldsSummary : "Profile information updated.");

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Company updated email sent to: {}", toEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send company updated email to: {}", toEmail, e);
        }
    }

    public void sendCompanyDeletedEmail(String toEmail, String recipientName, String companyName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("⚠️ Company Deactivated / Deleted: " + companyName);

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #DC2626; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">Company Deletion Notice</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Hello %s,</p>
                        <p>The company <strong>%s</strong> has been removed/deactivated on the VNext Compliance Platform.</p>
                        <p>All active compliance schedules, assignments, and access for this company have been deactivated.</p>
                        <p>If you believe this was done in error, please contact system administration.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated notification from VNext LLP.</p>
                    </div>
                </div>
                """, recipientName, companyName);

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Company deleted email sent to: {}", toEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send company deleted email to: {}", toEmail, e);
        }
    }

    // ==================== EMPLOYEE EVENT EMAILS ====================

    public void sendEmployeeCreatedAlertToSuperAdmin(String superAdminEmail, String companyName,
                                                    String employeeName, String employeeEmail,
                                                    String designation, String department, String employeeCode) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(superAdminEmail);
            helper.setSubject("👤 New Employee Added: " + employeeName + " (" + companyName + ")");

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #0D9488; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">New Employee Added</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Hello Super Admin,</p>
                        <p>A new employee has been added to company <strong>%s</strong>:</p>
                        <div style="background-color: #F9FAFB; padding: 16px; border-radius: 6px; margin: 16px 0; border-left: 4px solid #0D9488;">
                            <p style="margin: 6px 0;"><strong>Employee Name:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Email:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Employee Code:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Designation:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Department:</strong> %s</p>
                        </div>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated notification from VNext LLP.</p>
                    </div>
                </div>
                """, companyName, employeeName, employeeEmail,
                    employeeCode != null ? employeeCode : "N/A",
                    designation != null ? designation : "N/A",
                    department != null ? department : "N/A");

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Employee created alert email sent to Super Admin: {}", superAdminEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send employee created alert to Super Admin: {}", superAdminEmail, e);
        }
    }

    public void sendEmployeeCreatedConfirmationToCompanyAdmin(String companyAdminEmail, String companyAdminName,
                                                              String companyName, String employeeName,
                                                              String employeeEmail, String employeeCode) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(companyAdminEmail);
            helper.setSubject("✅ Employee Account Created: " + employeeName);

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #0D9488; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">Employee Created Successfully</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Dear %s,</p>
                        <p>You have successfully added a new employee to <strong>%s</strong>:</p>
                        <div style="background-color: #F9FAFB; padding: 16px; border-radius: 6px; margin: 16px 0; border-left: 4px solid #0D9488;">
                            <p style="margin: 6px 0;"><strong>Name:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Email:</strong> %s</p>
                            <p style="margin: 6px 0;"><strong>Employee Code:</strong> %s</p>
                        </div>
                        <p>An email with login credentials has been sent directly to the employee.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated notification from VNext LLP.</p>
                    </div>
                </div>
                """, companyAdminName, companyName, employeeName, employeeEmail,
                    employeeCode != null ? employeeCode : "N/A");

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Employee creation confirmation email sent to Company Admin: {}", companyAdminEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send employee creation confirmation to Company Admin: {}", companyAdminEmail, e);
        }
    }

    // ==================== COMPANY ADMIN OVERDUE EMAIL ====================

    public void sendOverdueEmailToCompanyAdmin(String companyAdminEmail, String companyAdminName,
                                              String companyName, List<OverdueComplianceInfo> overdueList) {
        if (overdueList == null || overdueList.isEmpty()) return;
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(companyAdminEmail);
            helper.setSubject("⚠️ Urgent: Overdue Compliances Alert - " + companyName);

            StringBuilder tableRows = new StringBuilder();
            for (OverdueComplianceInfo info : overdueList) {
                tableRows.append(String.format("""
                    <tr>
                        <td style="padding: 10px; border: 1px solid #E5E7EB;">%s</td>
                        <td style="padding: 10px; border: 1px solid #E5E7EB;">%s</td>
                        <td style="padding: 10px; border: 1px solid #E5E7EB;">%s</td>
                        <td style="padding: 10px; border: 1px solid #E5E7EB; color: #DC2626; font-weight: bold;">%d day%s</td>
                        <td style="padding: 10px; border: 1px solid #E5E7EB;">%s</td>
                    </tr>
                    """,
                        info.getComplianceName(),
                        info.getSubComplianceName() != null ? info.getSubComplianceName() : "—",
                        info.getDueDate() != null ? info.getDueDate().format(DATE_FORMATTER) : "N/A",
                        info.getOverdueDays(),
                        info.getOverdueDays() == 1 ? "" : "s",
                        info.getAssignedTo() != null ? info.getAssignedTo() : "Company Admin"
                ));
            }

            String htmlContent = String.format("""
                <div style="font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; color: #1F2937;">
                    <div style="background-color: #DC2626; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
                        <h2 style="color: #ffffff; margin: 0;">⚠️ Compliance Overdue Notice</h2>
                    </div>
                    <div style="border: 1px solid #E5E7EB; border-top: none; padding: 24px; border-radius: 0 0 8px 8px;">
                        <p>Dear %s,</p>
                        <p>The following statutory/regulatory compliance(s) for <strong>%s</strong> are currently <strong>OVERDUE</strong>. Immediate submission is required to avoid penalties or legal repercussions.</p>

                        <table style="width: 100%%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
                            <thead>
                                <tr style="background-color: #F3F4F6;">
                                    <th style="padding: 10px; border: 1px solid #E5E7EB; text-align: left;">Compliance</th>
                                    <th style="padding: 10px; border: 1px solid #E5E7EB; text-align: left;">Sub-Compliance</th>
                                    <th style="padding: 10px; border: 1px solid #E5E7EB; text-align: left;">Due Date</th>
                                    <th style="padding: 10px; border: 1px solid #E5E7EB; text-align: left;">Overdue By</th>
                                    <th style="padding: 10px; border: 1px solid #E5E7EB; text-align: left;">Assigned To</th>
                                </tr>
                            </thead>
                            <tbody>
                                %s
                            </tbody>
                        </table>

                        <p>Please log in to your Company Admin portal to review and complete these submissions.</p>
                        <hr style="border: none; border-top: 1px solid #E5E7EB; margin: 20px 0;">
                        <p style="color: #6B7280; font-size: 12px; margin: 0;">This is an automated reminder from VNext LLP.</p>
                    </div>
                </div>
                """, companyAdminName, companyName, tableRows.toString());

            helper.setText(htmlContent, true);
            mailSender.send(message);
            log.info("Overdue email sent to Company Admin: {}", companyAdminEmail);
        } catch (MessagingException | MailException e) {
            log.error("Failed to send overdue email to Company Admin: {}", companyAdminEmail, e);
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