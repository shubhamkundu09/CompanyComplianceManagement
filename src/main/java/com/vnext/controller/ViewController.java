package com.vnext.controller;

import com.vnext.entity.User;
import com.vnext.security.CurrentUser;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ViewController {

    @GetMapping("/")
    public String home() {
    	return "index";
    }

    @GetMapping("/index")
    public String index() {
        return "index";
    }

    @GetMapping("/home")
    public String home2() {
        return "index";
    }

    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }


    @GetMapping("/about")
    public String about() {
        return "about";
    }


    @GetMapping("/service")
    public String service() {
        return "service";
    }


    @GetMapping("/team")
    public String team() {
        return "team";
    }

    // ==================== COMMON VIEWS ====================

    @GetMapping("/profile")
    public String profile() {
        return "profile";
    }

    @GetMapping("/change-password")
    public String changePassword() {
        return "change-password";
    }

    @GetMapping("/error")
    public String error() {
        return "error/error";
    }




    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            @RequestParam(required = false) String message,
                            Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid email or password");
        }
        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully");
        }
        if (message != null) {
            model.addAttribute("message", message);
        }
        return "auth/login";
    }

    // ==================== SUPER ADMIN VIEWS ====================

    @GetMapping("/super-admin/dashboard")
    public String superAdminDashboard() {
        return "superadmin/dashboard";
    }

    @GetMapping("/super-admin/companies")
    public String superAdminCompanies() {
        return "superadmin/companies";
    }

    @GetMapping("/super-admin/companies/{id}")
    public String superAdminCompanyDetails() {
        return "superadmin/company-details";
    }

    @GetMapping("/super-admin/compliance/templates")
    public String superAdminComplianceTemplates() {
        return "superadmin/compliance-templates";
    }

    @GetMapping("/super-admin/compliance/templates/{id}")
    public String superAdminTemplateDetails(@PathVariable Long id, Model model) {
        System.out.println("===== SUPER ADMIN TEMPLATE DETAILS =====");
        System.out.println("Template ID: " + id);
        model.addAttribute("templateId", id);
        return "superadmin/template-details";
    }

    @GetMapping("/super-admin/compliance/assign")
    public String superAdminComplianceAssign() {
        return "superadmin/compliance-assign";
    }

    @GetMapping("/super-admin/compliance/assignments")
    public String superAdminComplianceAssignments() {
        return "superadmin/compliance-assignments";
    }

    @GetMapping("/super-admin/compliance/compliance/{id}")
    public String superAdminComplianceDetails(@PathVariable Long id, Model model) {
        model.addAttribute("complianceId", id);
        return "superadmin/compliance-details";
    }

    @GetMapping("/super-admin/compliance/category/{id}")
    public String superAdminComplianceCategoryDetails(@PathVariable Long id, Model model) {
        model.addAttribute("categoryId", id);
        return "superadmin/compliance-category-details";
    }

    // ==================== COMPANY ADMIN VIEWS ====================

    @GetMapping("/company-admin/dashboard")
    public String companyAdminDashboard() {
        return "companyadmin/dashboard";
    }

    @GetMapping("/company-admin/employees")
    public String companyAdminEmployees() {
        return "companyadmin/employees";
    }

    @GetMapping("/company-admin/employees/add")
    public String addEmployee() {
        return "companyadmin/employee-form";
    }

    @GetMapping("/company-admin/employees/{id}")
    public String employeeDetails(@PathVariable Long id, Model model) {
        model.addAttribute("employeeId", id);
        return "companyadmin/employee-details";
    }

    @GetMapping("/company-admin/company-details")
    public String companyDetails() {
        return "companyadmin/company-details";
    }

    @GetMapping("/company-admin/compliance/parents")
    public String companyAdminParentCompliances() {
        return "companyadmin/parent-compliances";
    }

    @GetMapping("/company-admin/compliance/parent/{id}")
    public String companyAdminParentComplianceDetails(@PathVariable Long id, Model model) {
        model.addAttribute("parentId", id);
        return "companyadmin/parent-compliance-details";
    }

    // ===== FIX: Handle configure with String parameter to avoid null conversion =====
    @GetMapping("/company-admin/compliance/configure")
    public String companyAdminComplianceConfigure(@RequestParam(required = false) String id, Model model) {
        // If id is null, "null", or empty, redirect to compliance list
        if (id == null || id.equals("null") || id.trim().isEmpty()) {
            return "company-admin/compliance/parents";
        }

        try {
            Long configId = Long.parseLong(id);
            model.addAttribute("configId", configId);
            return "companyadmin/compliance/parents";
        } catch (NumberFormatException e) {
            return "company-admin/compliance/parents";
        }
    }

    @GetMapping("/company-admin/compliance/sub/create")
    public String companyAdminCreateSubCompliance(@RequestParam Long parentId, Model model) {
        model.addAttribute("parentId", parentId);
        return "companyadmin/sub-compliance-form";
    }

    @GetMapping("/company-admin/compliance/sub/{id}/configure")
    public String companyAdminSubComplianceConfigure(@PathVariable Long id, Model model) {
        model.addAttribute("subComplianceId", id);
        return "companyadmin/sub-compliance-configure";
    }

    @GetMapping("/company-admin/compliance/parent/{id}/assign")
    public String companyAdminAssignParentCompliance(@PathVariable Long id, Model model) {
        model.addAttribute("parentId", id);
        return "companyadmin/parent-compliance-assign";
    }

    @GetMapping("/company-admin/compliance/custom/create")
    public String companyAdminCreateCustomCompliance() {
        return "redirect:/company-admin/compliance/parents";
    }

    @GetMapping("/company-admin/compliance/list")
    public String companyAdminComplianceList() {
        return "company-admin/compliance/parents";
    }

    @GetMapping("/company-admin/compliance/calendar")
    public String companyAdminComplianceCalendar() {
        return "companyadmin/compliance-calendar";
    }

    @GetMapping("/company-admin/change-password")
    public String companyAdminChangePassword() {
        return "companyadmin/change-password";
    }



    @GetMapping("/company-admin/compliance/assign")
    public String companyAdminComplianceAssign(@RequestParam(required = false) Long id, Model model) {
        if (id != null) {
            return "company-admin/compliance/parent/" + id + "/assign";
        }
        return "company-admin/compliance/parents";
    }

    @GetMapping("/company-admin/sub-admins")
    public String companyAdminSubAdmins() {
        return "redirect:/company-admin/employees";
    }

    // ==================== EMPLOYEE VIEWS ====================

    @GetMapping("/employee/dashboard")
    public String employeeDashboard() {
        return "employee/dashboard";
    }

    @GetMapping("/employee/profile")
    public String employeeProfile() {
        return "employee/profile";
    }

    @GetMapping("/employee/compliances")
    public String employeeCompliances() {
        return "employee/compliances";
    }

    @GetMapping("/employee/compliance/category/{id}")
    public String employeeComplianceCategory(@PathVariable Long id, Model model) {
        model.addAttribute("parentId", id);
        return "employee/compliance-category";
    }

    @GetMapping("/employee/compliance/sub/{id}")
    public String employeeSubComplianceDetails(@PathVariable Long id, Model model) {
        model.addAttribute("subComplianceId", id);
        return "employee/sub-compliance-details";
    }

    @GetMapping("/employee/compliance/{id}")
    public String employeeComplianceDetails(@PathVariable Long id, Model model) {
        model.addAttribute("complianceId", id);
        return "employee/compliance-details";
    }

    @GetMapping("/employee/compliance-calendar")
    public String employeeComplianceCalendar() {
        return "employee/compliance-calendar";
    }

    @GetMapping("/employee/change-password")
    public String employeeChangePassword() {
        return "change-password";
    }





    // In ViewController.java
    @GetMapping("/super-admin/notifications")
    public String superAdminNotifications() {
        return "superadmin/notifications";
    }


    @GetMapping("/company-admin/notifications")
    public String companyAdminNotifications() {
        return "companyadmin/notifications";
    }


    @GetMapping("/super-admin/profile")
    public String superAdminProfile() {
        return "superadmin/profile";
    }

    @GetMapping("/notifications")
    public String notifications() {
        return "notifications";
    }
}