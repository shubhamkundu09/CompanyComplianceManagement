<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: companyadmin/employee-details.jsp --%>

<%
    // Get employeeId from model attribute (set by controller)
    Long employeeIdObj = (Long) request.getAttribute("employeeId");
    String employeeId = employeeIdObj != null ? String.valueOf(employeeIdObj) : null;

    // If not found in attribute, try path parameter extraction
    if (employeeId == null || employeeId.trim().isEmpty()) {
        String uri = request.getRequestURI();
        String[] parts = uri.split("/");
        if (parts.length > 0) {
            String last = parts[parts.length - 1];
            try {
                Long.parseLong(last);
                employeeId = last;
            } catch (NumberFormatException e) {
                // Not a number
            }
        }
    }

    if (employeeId == null || employeeId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/company-admin/employees");
        return;
    }
    pageContext.setAttribute("employeeId", employeeId);
    pageContext.setAttribute("pageTitle", "Employee Details");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Employee Details</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-light: #818cf8;
            --primary-dark: #3730a3;
            --primary-bg: #eef2ff;
            --success: #10b981;
            --success-bg: #d1fae5;
            --danger: #ef4444;
            --danger-bg: #fee2e2;
            --warning: #f59e0b;
            --warning-bg: #fef3c7;
            --info: #3b82f6;
            --info-bg: #dbeafe;
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-400: #94a3b8;
            --gray-500: #64748b;
            --gray-600: #475569;
            --gray-700: #334155;
            --gray-800: #1e293b;
            --gray-900: #0f172a;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --radius: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
        }

        /* ==================== LOGO BACKGROUND ==================== */
        .logo-bg {
            position: fixed;
            top: 50%;
            left: 54%;
            transform: translate(-50%, -50%);
            width: 500px;
            height: 900px;
            opacity: 0.38;
            pointer-events: none;
            z-index: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            filter: blur(0px);
        }

        .logo-bg img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        /* ==================== APP LAYOUT ==================== */
        .app-wrapper {
            display: flex;
            min-height: 100vh;
            position: relative;
            z-index: 1;
        }

        /* ==================== SIDEBAR ==================== */
        .sidebar {
            width: 260px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(226, 232, 240, 0.6);
            padding: 24px 16px;
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            overflow-y: auto;
            z-index: 50;
            transition: transform 0.3s ease;
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 8px 24px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            margin-bottom: 24px;
        }

        .sidebar-brand .brand-icon {
            width: 42px;
            height: 42px;

            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .sidebar-brand .brand-text {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-900);
            letter-spacing: -0.5px;
        }

        .sidebar-brand .brand-badge {
            font-size: 10px;
            font-weight: 600;
            color: var(--gray-500);
            background: var(--gray-100);
            padding: 2px 8px;
            border-radius: 20px;
            margin-left: -4px;
        }

        .sidebar-label {
            font-size: 11px;
            font-weight: 600;
            color: var(--gray-400);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 8px 12px 6px;
            margin-top: 8px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-radius: var(--radius);
            color: var(--gray-600);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            margin-bottom: 2px;
            cursor: pointer;
        }

        .nav-item:hover {
            background: rgba(79, 70, 229, 0.08);
            color: var(--gray-900);
        }

        .nav-item.active {
            background: rgba(79, 70, 229, 0.12);
            color: var(--primary);
        }

        .nav-item i {
            width: 20px;
            text-align: center;
            font-size: 15px;
        }

        .nav-item .nav-badge {
            margin-left: auto;
            background: var(--danger);
            color: white;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 20px;
        }

        /* ==================== HEADER ==================== */
        .header {
            position: fixed;
            top: 0;
            left: 260px;
            right: 0;
            height: 64px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            z-index: 40;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            transition: left 0.3s ease;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-left .menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray-600);
            cursor: pointer;
            padding: 4px;
        }

        .header-left .page-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--gray-900);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 1px solid rgba(226, 232, 240, 0.6);
            background: rgba(255, 255, 255, 0.5);
            color: var(--gray-600);
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            position: relative;
        }

        .header-btn:hover {
            background: var(--gray-100);
            border-color: var(--gray-300);
            color: var(--gray-800);
        }

        .header-btn .badge-dot {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 8px;
            height: 8px;
            background: var(--danger);
            border-radius: 50%;
            border: 2px solid white;
        }

        .header-btn .badge-count {
            position: absolute;
            top: -4px;
            right: -4px;
            background: var(--danger);
            color: white;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 20px;
            min-width: 18px;
            text-align: center;
            border: 2px solid white;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 4px 12px 4px 4px;
            border-radius: 40px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: all 0.2s;
        }

        .header-user:hover {
            background: var(--gray-100);
            border-color: var(--gray-300);
        }

        .header-user .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 12px;
        }

        .header-user .user-info {
            display: flex;
            flex-direction: column;
        }

        .header-user .user-name {
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-800);
            line-height: 1.2;
        }

        .header-user .user-role {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        /* ==================== NOTIFICATION DROPDOWN ==================== */
        .notification-dropdown {
            display: none;
            position: absolute;
            top: 56px;
            right: 0;
            width: 380px;
            max-height: 460px;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-xl);
            z-index: 60;
        }

        .notification-dropdown.open {
            display: block;
            animation: slideDown 0.25s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .notification-header {
            padding: 16px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h4 {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-900);
        }

        .notification-header .mark-all {
            font-size: 12px;
            color: var(--primary);
            cursor: pointer;
            font-weight: 500;
        }

        .notification-header .mark-all:hover {
            text-decoration: underline;
        }

        .notification-item {
            padding: 14px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.4);
            transition: background 0.2s;
            cursor: default;
        }

        .notification-item:hover {
            background: rgba(79, 70, 229, 0.04);
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-item .notif-title {
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-800);
        }

        .notification-item .notif-message {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 2px;
            line-height: 1.4;
        }

        .notification-item .notif-time {
            font-size: 11px;
            color: var(--gray-400);
            margin-top: 4px;
        }

        .notification-item .notif-dot {
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .notification-item .notif-dot.urgent { background: var(--danger); }
        .notification-item .notif-dot.important { background: var(--warning); }
        .notification-item .notif-dot.general { background: var(--primary); }

        .notification-footer {
            padding: 12px 20px;
            border-top: 1px solid rgba(226, 232, 240, 0.6);
            text-align: center;
        }

        .notification-footer a {
            font-size: 12px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .notification-footer a:hover {
            text-decoration: underline;
        }

        .notification-empty {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-500);
        }

        .notification-empty i {
            font-size: 32px;
            opacity: 0.3;
            margin-bottom: 8px;
        }

        /* ==================== MAIN CONTENT ==================== */
        .main-content {
            margin-left: 260px;
            margin-top: 64px;
            padding: 32px 40px;
            flex: 1;
            min-height: calc(100vh - 64px);
            position: relative;
            z-index: 1;
        }

        /* ==================== GLASSMORPHISM CARDS ==================== */
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            transition: all 0.3s;
        }

        .glass-card:hover {
            background: rgba(255, 255, 255, 0.85);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }

        /* ==================== BREADCRUMB ==================== */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            color: var(--gray-500);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb .sep {
            color: var(--gray-400);
            font-size: 9px;
        }

        .breadcrumb .current {
            color: var(--gray-800);
            font-weight: 500;
        }

        /* ==================== CARDS ==================== */
        .card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        /* ==================== BADGES ==================== */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge-success { background: var(--success-bg); color: var(--success); }
        .badge-danger { background: var(--danger-bg); color: var(--danger); }
        .badge-warning { background: var(--warning-bg); color: var(--warning); }
        .badge-info { background: var(--info-bg); color: var(--info); }
        .badge-primary { background: var(--primary-bg); color: var(--primary); }

        .badge-active { background: var(--success-bg); color: var(--success); }
        .badge-inactive { background: var(--danger-bg); color: var(--danger); }
        .badge-pending { background: var(--warning-bg); color: var(--warning); }

        /* ==================== BUTTONS ==================== */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: var(--radius);
            font-size: 13px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(226, 232, 240, 0.6);
            color: var(--gray-600);
            text-decoration: none;
        }

        .btn:hover {
            background: var(--gray-100);
            border-color: var(--gray-300);
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            box-shadow: 0 4px 16px rgba(79, 70, 229, 0.3);
        }

        .btn-success {
            background: var(--success);
            color: white;
            border-color: var(--success);
        }

        .btn-success:hover {
            background: #059669;
            border-color: #059669;
        }

        .btn-danger {
            background: var(--danger);
            color: white;
            border-color: var(--danger);
        }

        .btn-danger:hover {
            background: #dc2626;
            border-color: #dc2626;
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
        }

        /* ==================== EMPLOYEE HEADER ==================== */
        .emp-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .emp-header .emp-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .emp-header .emp-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            color: white;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
        }

        .emp-header .emp-details h1 {
            font-size: 24px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .emp-header .emp-details .emp-email {
            font-size: 13px;
            color: var(--gray-500);
        }

        .emp-header .emp-details .emp-code {
            margin-top: 4px;
        }

        .emp-header .emp-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        /* ==================== COMPLIANCE SECTION ==================== */
        .compliance-section .section-header {
            padding: 16px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .compliance-section .section-header .title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .compliance-section .section-header .title i {
            color: var(--primary);
            margin-right: 8px;
        }

        .compliance-section .section-header .subtitle {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        .compliance-stats {
            display: flex;
            gap: 12px;
            padding: 12px 20px;
            background: rgba(79, 70, 229, 0.04);
            border-bottom: 1px solid rgba(226, 232, 240, 0.3);
            flex-wrap: wrap;
        }

        .compliance-filter {
            padding: 12px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.3);
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .compliance-filter .form-label {
            margin-bottom: 0;
            font-size: 12px;
        }

        .compliance-filter .form-input {
            width: auto;
            padding: 6px 12px;
            font-size: 12px;
            min-width: 140px;
        }

        .compliance-list {
            padding: 0 20px 16px 20px;
        }

        .compliance-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            margin-top: 10px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(226, 232, 240, 0.3);
            border-radius: var(--radius);
            transition: all 0.2s;
        }

        .compliance-item:hover {
            border-color: var(--primary-light);
            background: rgba(255, 255, 255, 0.7);
        }

        .compliance-item .item-left {
            flex: 1;
            min-width: 0;
        }

        .compliance-item .item-left .item-title {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .compliance-item .item-left .item-title strong {
            font-size: 14px;
            color: var(--gray-800);
        }

        .compliance-item .item-left .item-meta {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 4px;
        }

        .compliance-item .item-left .item-meta .due-warning {
            color: var(--warning);
        }

        .compliance-item .item-left .item-meta .due-danger {
            color: var(--danger);
            font-weight: 600;
        }

        .compliance-item .item-right {
            flex-shrink: 0;
            margin-left: 12px;
        }

        /* ==================== INFO GRID ==================== */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-card {
            padding: 20px;
        }

        .info-card .info-title {
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            margin-bottom: 12px;
        }

        .info-card .info-title i {
            margin-right: 6px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.2);
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-row .label {
            font-size: 12px;
            color: var(--gray-500);
        }

        .info-row .value {
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-800);
        }

        /* ==================== FORM ==================== */
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 4px;
        }

        .form-input {
            padding: 8px 12px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            color: var(--gray-800);
            transition: all 0.2s;
            outline: none;
            width: 100%;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background: rgba(255, 255, 255, 0.8);
        }

        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        /* ==================== MODAL ==================== */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 100;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-xl);
            max-width: 450px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from { opacity: 0; transform: translateY(20px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-shrink: 0;
        }

        .modal-header .modal-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .modal-header .modal-close {
            background: none;
            border: none;
            color: var(--gray-400);
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            transition: color 0.2s;
        }

        .modal-header .modal-close:hover {
            color: var(--gray-800);
        }

        .modal-body {
            padding: 20px 24px;
            overflow-y: auto;
            flex: 1;
        }

        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid rgba(226, 232, 240, 0.6);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-shrink: 0;
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 36px;
            opacity: 0.3;
            display: block;
            margin-bottom: 10px;
        }

        /* ==================== SPINNER ==================== */
        .spinner {
            width: 36px;
            height: 36px;
            border: 3px solid rgba(226, 232, 240, 0.6);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 0.7s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* ==================== TOAST ==================== */
        #toast-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 999;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .toast {
            padding: 12px 18px;
            border-radius: var(--radius);
            font-size: 13px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 280px;
            animation: slideIn 0.3s ease;
            box-shadow: var(--shadow-lg);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .toast-success { color: var(--success); }
        .toast-error { color: var(--danger); }
        .toast-info { color: var(--primary); }
        .toast-warning { color: var(--warning); }

        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .logo-bg { width: 500px; height: 500px; }
            .info-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .emp-header { flex-direction: column; align-items: stretch; }
            .emp-header .emp-info { flex-wrap: wrap; }
            .emp-header .emp-actions { width: 100%; }
            .emp-header .emp-actions .btn { flex: 1; justify-content: center; }
            .compliance-item { flex-direction: column; align-items: stretch; gap: 10px; }
            .compliance-item .item-right { margin-left: 0; }
            .compliance-stats { gap: 8px; }
            .compliance-stats .badge { font-size: 10px; }
            .modal-box { max-width: 100%; margin: 10px; }
        }

        @media (max-width: 480px) {
            .emp-header .emp-details h1 { font-size: 20px; }
            .info-row { flex-direction: column; gap: 2px; }
            .compliance-filter { flex-direction: column; align-items: stretch; }
            .compliance-filter .form-input { width: 100%; }
            .notification-dropdown { width: 280px; right: -80px; }
        }
    </style>
</head>
<body>

<!-- ==================== LOGO BACKGROUND ==================== -->
<div class="logo-bg">
    <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<!-- ==================== TOAST CONTAINER ==================== -->
<div id="toast-container"></div>

<!-- ==================== APP WRAPPER ==================== -->
<div class="app-wrapper">

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar" id="sidebar">
            <div class="sidebar-brand">
                <div class="brand-icon">
                 <img style="width:100%;"  src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
                </div>
                <span class="brand-text">VNext Legal</span>
                <span class="brand-badge">LLP</span>
            </div>

            <div class="sidebar-label">Main</div>
            <a href="${pageContext.request.contextPath}/company-admin/dashboard" class="nav-item">
                <i class="fas fa-chart-pie"></i> Dashboard
            </a>

            <div class="sidebar-label">Management</div>
            <a href="${pageContext.request.contextPath}/company-admin/employees" class="nav-item active">
                <i class="fas fa-users"></i> Employees
                <span class="nav-badge" id="employeeCount">0</span>
            </a>

            <div class="sidebar-label">Compliance</div>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/list" class="nav-item">
                <i class="fas fa-tasks"></i> My Compliances
            </a>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/custom/create" class="nav-item">
                <i class="fas fa-plus-circle"></i> Custom Compliance
            </a>

            <div class="sidebar-label">Communication</div>
            <a href="${pageContext.request.contextPath}/company-admin/notifications" class="nav-item ">
                <i class="fas fa-bell"></i> Notifications
                <span class="nav-badge" id="notifCount">0</span>
            </a>

            <div class="sidebar-label">Account</div>
            <a href="${pageContext.request.contextPath}/company-admin/change-password" class="nav-item">
                <i class="fas fa-key"></i> Change Password
            </a>

            <div style="margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(226, 232, 240, 0.6);">
                <a href="#" onclick="handleLogout()" class="nav-item" style="color: var(--gray-400);">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </aside>

    <!-- ==================== HEADER ==================== -->
    <header class="header">
        <div class="header-left">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <span class="page-title">Employee Details</span>
        </div>
        <div class="header-right">

            <!-- Notifications -->
            <div style="position:relative;">
                <button class="header-btn" onclick="toggleNotifications()" title="Notifications">
                    <i class="fas fa-bell"></i>
                    <span class="badge-count" id="notifBadge">0</span>
                </button>

                <div class="notification-dropdown" id="notificationDropdown">
                    <div class="notification-header">
                        <h4><i class="fas fa-bell" style="color:var(--primary);margin-right:8px;"></i> Notifications</h4>
                        <span class="mark-all" onclick="markAllRead()">Mark all as read</span>
                    </div>
                    <div id="notificationList">
                        <div class="notification-empty">
                            <i class="fas fa-spinner fa-spin"></i>
                            <div style="margin-top:8px;">Loading...</div>
                        </div>
                    </div>
                    <div class="notification-footer">
                        <a href="${pageContext.request.contextPath}/company-admin/notifications">View all notifications</a>
                    </div>
                </div>
            </div>

            <!-- User -->
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/company-admin/company-details'">
                <div class="avatar" id="userAvatar">U</div>
                <div class="user-info">
                    <span class="user-name" id="userName">User</span>
                    <span class="user-role" id="userRole">Company Admin</span>
                </div>
            </div>
        </div>
    </header>

    <!-- ==================== MAIN CONTENT ==================== -->
    <main class="main-content">

        <!-- ==================== BREADCRUMB ==================== -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/company-admin/employees">
                <i class="fas fa-arrow-left"></i> Back to Employees
            </a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current" id="breadcrumbName">Loading...</span>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" style="display:flex;align-items:center;justify-content:center;padding:80px 0;">
            <div class="spinner"></div>
            <span style="margin-left:12px;color:var(--gray-500);">Loading employee details...</span>
        </div>

        <!-- ==================== PAGE CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- ==================== EMPLOYEE HEADER ==================== -->
            <div class="emp-header">
                <div class="emp-info">
                    <div class="emp-avatar" id="empAvatar">?</div>
                    <div class="emp-details">
                        <h1 id="empName">—</h1>
                        <div class="emp-email" id="empEmail">—</div>
                        <div class="emp-code" id="empCodeBadge"></div>
                    </div>
                </div>
                <div class="emp-actions">
                    <a href="#" id="editLink" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <button onclick="toggleEmployeeStatus()" class="btn" id="statusToggleBtn"></button>
                    <button onclick="openResetModal()" class="btn btn-ghost">
                        <i class="fas fa-key"></i> Reset Password
                    </button>
                </div>
            </div>

            <!-- ==================== COMPLIANCE SECTION ==================== -->
            <div class="card compliance-section" style="margin-bottom:20px;">
                <div class="section-header">
                    <div>
                        <div class="title"><i class="fas fa-tasks"></i>Assigned Compliances</div>
                        <div class="subtitle">Compliance categories assigned to this employee</div>
                    </div>
                    <button onclick="refreshCompliances()" class="btn btn-ghost" style="padding:5px 12px;">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>

                <!-- Compliance Stats -->
                <div class="compliance-stats">
                    <span class="badge badge-pending" id="pendingCount">0 Pending</span>
                    <span class="badge badge-info" id="inProgressCount">0 In Progress</span>
                    <span class="badge badge-success" id="completedCount">0 Completed</span>
                    <span class="badge badge-danger" id="overdueCount">0 Overdue</span>
                </div>

                <!-- Filter -->
                <div class="compliance-filter">
                    <label class="form-label">Filter by Status:</label>
                    <select id="complianceStatusFilter" class="form-input">
                        <option value="">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="OVERDUE">Overdue</option>
                    </select>
                    <button onclick="loadEmployeeCompliances()" class="btn btn-primary" style="padding:5px 14px;">
                        <i class="fas fa-filter"></i> Apply
                    </button>
                </div>

                <!-- Compliances List -->
                <div class="compliance-list" id="compliancesList">
                    <div style="text-align:center;padding:40px;">
                        <div class="spinner"></div>
                        Loading compliances...
                    </div>
                </div>
            </div>

            <!-- ==================== EMPLOYEE INFO GRID ==================== -->
            <div class="info-grid">

                <!-- Personal Information -->
                <div class="card info-card">
                    <div class="info-title"><i class="fas fa-user"></i> Personal Information</div>
                    <div id="personalInfo"></div>
                </div>

                <!-- Contact Information -->
                <div class="card info-card">
                    <div class="info-title"><i class="fas fa-address-card"></i> Contact Information</div>
                    <div id="contactInfo"></div>
                </div>

                <!-- Employment Details -->
                <div class="card info-card">
                    <div class="info-title"><i class="fas fa-briefcase"></i> Employment Details</div>
                    <div id="employmentInfo"></div>
                </div>

                <!-- Account Status -->
                <div class="card info-card">
                    <div class="info-title"><i class="fas fa-shield-alt"></i> Account Status</div>
                    <div id="accountInfo"></div>
                </div>

            </div>

        </div>

    </main>
</div>

<!-- ==================== RESET PASSWORD MODAL ==================== -->
<div id="resetModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-title"><i class="fas fa-key" style="color:var(--primary);margin-right:8px;"></i>Reset Password</div>
            <button class="modal-close" onclick="closeResetModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <p>Reset password for <strong id="resetEmpName"></strong>?</p>
            <p style="font-size:12px;color:var(--gray-500);margin-top:8px;">New credentials will be sent to their email address.</p>
        </div>
        <div class="modal-footer">
            <button onclick="closeResetModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmReset()" class="btn btn-primary">Send Reset Email</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var EMP_ID = '<%= employeeId %>';
    var employeeData = null;
    var currentCompliancePage = 0;
    var compliancePageSize = 10;

    // ==================== TOAST ====================
    function toast(message, type = 'info', duration = 3500) {
        const container = document.getElementById('toast-container');
        const icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle', warning: 'fa-exclamation-triangle' };
        const el = document.createElement('div');
        el.className = 'toast toast-' + type;
        el.innerHTML = '<i class="fas ' + icons[type] + '"></i><span>' + message + '</span>';
        container.appendChild(el);
        setTimeout(() => {
            el.style.opacity = '0';
            el.style.transform = 'translateX(20px)';
            el.style.transition = 'all .3s';
            setTimeout(() => el.remove(), 300);
        }, duration);
    }

    // ==================== API ====================
    async function api(url, options = {}) {
        const token = localStorage.getItem('accessToken');
        if (!token) {
            window.location.href = contextPath + '/login?error=Session expired';
            return null;
        }
        const defaults = {
            headers: {
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            }
        };
        const merged = { ...defaults, ...options, headers: { ...defaults.headers, ...(options.headers || {}) } };
        try {
            const response = await fetch(contextPath + url, merged);
            if (response.status === 401) {
                localStorage.removeItem('accessToken');
                localStorage.removeItem('user');
                window.location.href = contextPath + '/login?error=Session expired';
                return null;
            }
            return response.json();
        } catch (error) {
            console.error('API Error:', error);
            return null;
        }
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;';
            if (m === '<') return '&lt;';
            if (m === '>') return '&gt;';
            return m;
        });
    }

    function formatDate(d) {
        if (!d) return '—';
        try {
            return new Date(d).toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
        } catch(e) {
            return '—';
        }
    }

    function getStatusClass(status) {
        var map = {
            'PENDING': 'badge-pending',
            'IN_PROGRESS': 'badge-info',
            'COMPLETED': 'badge-success',
            'OVERDUE': 'badge-danger'
        };
        return map[status] || 'badge-info';
    }

    function infoRow(label, value) {
        return '<div class="info-row">' +
            '<span class="label">' + label + '</span>' +
            '<span class="value">' + (value || '—') + '</span>' +
        '</div>';
    }

    // ==================== SIDEBAR / LOGOUT / NOTIFICATIONS ====================
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open');
    }

    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 1024) {
            var sidebar = document.getElementById('sidebar');
            if (sidebar && sidebar.classList.contains('open')) {
                if (!sidebar.contains(e.target) && !e.target.closest('.menu-toggle')) {
                    sidebar.classList.remove('open');
                }
            }
        }
    });

    function handleLogout() {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('user');
        window.location.href = contextPath + '/login?logout=true';
    }

    function toggleNotifications() {
        var dropdown = document.getElementById('notificationDropdown');
        dropdown.classList.toggle('open');
        if (dropdown.classList.contains('open')) {
            loadNotifications();
        }
    }

    async function loadNotifications() {
        try {
            var data = await api('/api/notifications/active');
            var list = document.getElementById('notificationList');
            if (!list) return;

            if (data && data.success && data.data && data.data.length > 0) {
                var html = '';
                for (var i = 0; i < data.data.length; i++) {
                    var n = data.data[i];
                    var dotClass = 'general';
                    if (n.notificationType === 'URGENT') dotClass = 'urgent';
                    else if (n.notificationType === 'IMPORTANT') dotClass = 'important';

                    html += '<div class="notification-item">' +
                        '<div class="notif-title">' +
                        '<span class="notif-dot ' + dotClass + '"></span>' +
                        escapeHtml(n.title) +
                        '</div>' +
                        '<div class="notif-message">' + escapeHtml(n.message) + '</div>' +
                        '<div class="notif-time"><i class="far fa-clock"></i> ' + formatTimeAgo(n.createdAt) + '</div>' +
                        '</div>';
                }
                list.innerHTML = html;
                document.getElementById('notifBadge').textContent = data.data.length;
            } else {
                list.innerHTML = '<div class="notification-empty">' +
                    '<i class="fas fa-bell-slash"></i>' +
                    '<div>No notifications</div>' +
                    '</div>';
                document.getElementById('notifBadge').textContent = '0';
            }
        } catch(e) {
            console.log('Notification error:', e);
        }
    }

    function formatTimeAgo(dateStr) {
        if (!dateStr) return 'Just now';
        try {
            var date = new Date(dateStr);
            var now = new Date();
            var diff = Math.floor((now - date) / 1000);
            if (diff < 60) return diff + 's ago';
            if (diff < 3600) return Math.floor(diff / 60) + 'm ago';
            if (diff < 86400) return Math.floor(diff / 3600) + 'h ago';
            if (diff < 2592000) return Math.floor(diff / 86400) + 'd ago';
            return date.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
        } catch(e) {
            return 'Just now';
        }
    }

    function markAllRead() {
        toast('All notifications marked as read', 'success');
        var list = document.getElementById('notificationList');
        if (list) {
            list.innerHTML = '<div class="notification-empty">' +
                '<i class="fas fa-check-circle" style="color:var(--success);"></i>' +
                '<div>All caught up!</div>' +
                '</div>';
        }
        document.getElementById('notifBadge').textContent = '0';
    }

    document.addEventListener('click', function(e) {
        var dropdown = document.getElementById('notificationDropdown');
        var btn = document.querySelector('[onclick*="toggleNotifications"]');
        if (dropdown && btn) {
            if (dropdown.classList.contains('open') && !dropdown.contains(e.target) && !btn.contains(e.target)) {
                dropdown.classList.remove('open');
            }
        }
    });

    // ==================== LOAD EMPLOYEE ====================
    async function loadEmployee() {
        try {
            var data = await api('/api/company-admin/employees/' + EMP_ID);
            if (!data || !data.success) {
                toast('Employee not found', 'error');
                setTimeout(function() {
                    window.location.href = contextPath + '/company-admin/employees';
                }, 2000);
                return;
            }
            employeeData = data.data;
            renderEmployeeInfo();
            await loadEmployeeCompliances();
            document.getElementById('loader').style.display = 'none';
            document.getElementById('pageContent').style.display = 'block';
        } catch(e) {
            console.error('Error loading employee:', e);
            toast('Failed to load employee details', 'error');
        }
    }

    function renderEmployeeInfo() {
        var e = employeeData;
        var isActive = (e.status === 'ACTIVE');
        var fullName = e.fullName || e.firstName + ' ' + e.lastName;
        var initials = ((e.firstName || '')[0] || '') + ((e.lastName || '')[0] || '');

        // Header
        document.getElementById('breadcrumbName').textContent = fullName;
        document.getElementById('empName').textContent = fullName;
        document.getElementById('empEmail').textContent = e.email;
        document.getElementById('empAvatar').textContent = initials || '?';
        document.getElementById('empCodeBadge').innerHTML =
            '<span class="badge badge-info"><i class="fas fa-id-card"></i> ' + (e.employeeCode || 'No Code Assigned') + '</span>';

        // Edit link
        var editLink = document.getElementById('editLink');
        editLink.href = contextPath + '/company-admin/employees/add?id=' + e.id;

        // Status toggle button
        var toggleBtn = document.getElementById('statusToggleBtn');
        if (isActive) {
            toggleBtn.className = 'btn btn-danger';
            toggleBtn.innerHTML = '<i class="fas fa-ban"></i> Deactivate';
        } else {
            toggleBtn.className = 'btn btn-success';
            toggleBtn.innerHTML = '<i class="fas fa-check"></i> Activate';
        }

        // Personal Info
        document.getElementById('personalInfo').innerHTML =
            infoRow('Full Name', fullName) +
            infoRow('Email Address', e.email) +
            infoRow('Employee Code', e.employeeCode || '—');

        // Contact Info
        document.getElementById('contactInfo').innerHTML =
            infoRow('Phone Number', e.phoneNumber || '—');

        // Employment Info
        document.getElementById('employmentInfo').innerHTML =
            infoRow('Designation', e.designation || '—') +
            infoRow('Department', e.department || '—') +
            infoRow('Date Joined', formatDate(e.createdAt));

        // Account Status
        var statusBadge = isActive ? '<span class="badge badge-success">ACTIVE</span>' : '<span class="badge badge-danger">DEACTIVE</span>';
        var verifiedBadge = e.emailVerified ? '<span class="badge badge-success">✓ Verified</span>' : '<span class="badge badge-pending">⏳ Pending</span>';

        var accountHtml =
            '<div class="info-row"><span class="label">Status</span><span class="value">' + statusBadge + '</span></div>' +
            '<div class="info-row"><span class="label">Email Verification</span><span class="value">' + verifiedBadge + '</span></div>';

        if (e.lastLoginAt) {
            accountHtml += infoRow('Last Login', formatDate(e.lastLoginAt));
        }

        document.getElementById('accountInfo').innerHTML = accountHtml;
    }

    // ==================== LOAD EMPLOYEE COMPLIANCES ====================
    async function loadEmployeeCompliances() {
        var status = document.getElementById('complianceStatusFilter').value;
        var url = '/api/company-admin/compliance/employee/' + EMP_ID + '/compliances?page=' + currentCompliancePage + '&size=' + compliancePageSize;
        if (status) url += '&status=' + status;

        var data = await api(url);
        if (data && data.success) {
            renderCompliancesList(data.data.content || []);
            updateComplianceStats(data.data.content || []);
        } else {
            document.getElementById('compliancesList').innerHTML = '<div class="empty-state">Failed to load compliances</div>';
        }
    }

    function renderCompliancesList(compliances) {
        var container = document.getElementById('compliancesList');

        if (!compliances.length) {
            container.innerHTML = '<div class="empty-state">' +
                '<i class="fas fa-check-circle" style="color:var(--success);"></i>' +
                '<p style="margin-top:10px;">No compliances assigned to this employee yet</p>' +
                '<p style="font-size:12px;color:var(--gray-500);">Assign compliances from the Compliance Management section</p>' +
            '</div>';
            return;
        }

        var html = '';
        for (var i = 0; i < compliances.length; i++) {
            var c = compliances[i];
            var statusClass = getStatusClass(c.status);
            var daysRemaining = c.daysRemaining;
            var dueClass = '';
            var dueNote = '';

            if (c.status !== 'COMPLETED') {
                if (daysRemaining < 0) {
                    dueClass = 'due-danger';
                    dueNote = ' <span class="due-danger">(Overdue by ' + Math.abs(daysRemaining) + ' days)</span>';
                } else if (daysRemaining <= 7) {
                    dueClass = 'due-warning';
                    dueNote = ' <span class="due-warning">(' + daysRemaining + ' days left)</span>';
                }
            }

            html += '<div class="compliance-item">' +
                '<div class="item-left">' +
                    '<div class="item-title">' +
                        '<i class="fas fa-folder-open" style="color:var(--primary);"></i>' +
                        '<strong>' + escapeHtml(c.complianceName) + '</strong>' +
                        '<span class="badge ' + statusClass + '">' + c.status.replace('_', ' ') + '</span>' +
                    '</div>' +
                    '<div class="item-meta">' +
                        '<span><i class="fas fa-calendar-check"></i> Due: <span class="' + dueClass + '">' + formatDate(c.dueDate) + '</span>' + dueNote + '</span>' +
                        (c.documentRequired ? '<span><i class="fas fa-file-alt"></i> ' + escapeHtml(c.documentRequired) + '</span>' : '') +
                    '</div>' +
                '</div>' +
                '<div class="item-right">' +
                    '<a href="' + contextPath + '/company-admin/compliance/' + c.companyComplianceId + '" class="btn btn-ghost" style="padding:6px 12px;" title="View Compliance Details">' +
                        '<i class="fas fa-arrow-right"></i>' +
                    '</a>' +
                '</div>' +
            '</div>';
        }

        container.innerHTML = html;
    }

    function updateComplianceStats(compliances) {
        var pending = 0, inProgress = 0, completed = 0, overdue = 0;

        for (var i = 0; i < compliances.length; i++) {
            var status = compliances[i].status;
            if (status === 'PENDING') pending++;
            else if (status === 'IN_PROGRESS') inProgress++;
            else if (status === 'COMPLETED') completed++;

            if (compliances[i].overdue && status !== 'COMPLETED') overdue++;
        }

        document.getElementById('pendingCount').textContent = pending + ' Pending';
        document.getElementById('inProgressCount').textContent = inProgress + ' In Progress';
        document.getElementById('completedCount').textContent = completed + ' Completed';
        document.getElementById('overdueCount').textContent = overdue + ' Overdue';
    }

    function refreshCompliances() {
        currentCompliancePage = 0;
        loadEmployeeCompliances();
        toast('Compliances refreshed', 'info');
    }

    // ==================== TOGGLE STATUS ====================
    async function toggleEmployeeStatus() {
        if (!employeeData) return;
        var newStatus = (employeeData.status === 'ACTIVE') ? 'DEACTIVE' : 'ACTIVE';
        var action = (newStatus === 'ACTIVE') ? 'activate' : 'deactivate';
        if (!confirm('Are you sure you want to ' + action + ' this employee?')) return;

        var data = await api('/api/company-admin/employees/' + EMP_ID + '/status?status=' + newStatus, { method: 'PATCH' });
        if (data && data.success) {
            toast('Employee ' + action + 'd successfully', 'success');
            loadEmployee();
        } else {
            toast((data && data.error) || 'Failed to update status', 'error');
        }
    }

    // ==================== RESET PASSWORD ====================
    function openResetModal() {
        if (!employeeData) return;
        var fullName = employeeData.fullName || employeeData.firstName + ' ' + employeeData.lastName;
        document.getElementById('resetEmpName').textContent = fullName;
        document.getElementById('resetModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeResetModal() {
        document.getElementById('resetModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function confirmReset() {
        var data = await api('/api/company-admin/employees/' + EMP_ID + '/reset-password', { method: 'POST' });
        if (data && data.success) {
            toast('Password reset email sent to ' + employeeData.email, 'success');
            closeResetModal();
        } else {
            toast((data && data.error) || 'Failed to reset password', 'error');
        }
    }

    // ==================== CLOSE MODAL ON OVERLAY ====================
    document.getElementById('resetModal').addEventListener('click', function(e) {
        if (e.target === this) closeResetModal();
    });

    // ==================== EVENT LISTENERS ====================
    document.getElementById('complianceStatusFilter').addEventListener('change', function() {
        currentCompliancePage = 0;
        loadEmployeeCompliances();
    });

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        // Load user info
        const userStr = localStorage.getItem('user');
        if (userStr) {
            try {
                const u = JSON.parse(userStr);
                document.getElementById('userName').textContent = u.firstName + ' ' + u.lastName;
                document.getElementById('userAvatar').textContent = (u.firstName || 'U')[0] + (u.lastName || '')[0];
                document.getElementById('userRole').textContent = (u.role || '').replace('_', ' ');
            } catch(e) {}
        }

        // Load employee count for sidebar
        async function loadEmployeeCount() {
            var data = await api('/api/company-admin/employees?page=0&size=1');
            if (data && data.success) {
                document.getElementById('employeeCount').textContent = data.data.totalElements || 0;
            }
        }
        loadEmployeeCount();

        loadEmployee();
        loadNotifications();
    });
</script>

</body>
</html>