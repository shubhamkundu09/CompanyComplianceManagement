<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- File: companyadmin/parent-compliance-assign.jsp --%>

<%
    Object parentIdObj = request.getAttribute("parentId");
    String parentId = null;

    if (parentIdObj != null) {
        parentId = String.valueOf(parentIdObj);
    } else {
        parentId = request.getParameter("id");
    }

    if (parentId == null || parentId.trim().isEmpty() || "null".equals(parentId)) {
        String uri = request.getRequestURI();
        String[] parts = uri.split("/");
        for (int i = parts.length - 1; i >= 0; i--) {
            String part = parts[i];
            try {
                Long.parseLong(part);
                parentId = part;
                break;
            } catch (NumberFormatException e) {}
        }
    }

    if (parentId == null || parentId.trim().isEmpty() || "null".equals(parentId)) {
        response.sendRedirect(request.getContextPath() + "/company-admin/compliance/parents");
        return;
    }

    pageContext.setAttribute("parentId", parentId);
    pageContext.setAttribute("pageTitle", "Assign Compliance to Employees");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Assign Compliance</title>

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
            font-size: 13px;
            color: var(--gray-500);
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
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

        /* ==================== ASSIGN HEADER ==================== */
        .assign-header {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 24px 28px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .assign-header .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .assign-header .header-icon {
            width: 56px;
            height: 56px;
            background: rgba(79, 70, 229, 0.12);
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .assign-header .header-icon i {
            font-size: 26px;
            color: var(--primary);
        }

        .assign-header .header-left h1 {
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .assign-header .header-left .compliance-name {
            font-size: 14px;
            color: var(--primary-light);
        }

        /* ==================== INFO BANNER ==================== */
        .info-banner {
            background: rgba(79, 70, 229, 0.06);
            border-left: 3px solid var(--primary);
            border-radius: var(--radius);
            padding: 14px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .info-banner i {
            color: var(--primary);
            font-size: 20px;
            flex-shrink: 0;
        }

        .info-banner .info-text strong {
            color: var(--gray-800);
            font-size: 14px;
        }

        .info-banner .info-text p {
            font-size: 13px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        /* ==================== SUMMARY CARD ==================== */
        .summary-card {
            background: rgba(16, 185, 129, 0.04);
            border: 1px solid rgba(16, 185, 129, 0.15);
            border-radius: var(--radius);
            padding: 16px 20px;
            margin-bottom: 20px;
        }

        .summary-card .summary-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .summary-card .summary-header i {
            font-size: 18px;
            color: var(--success);
        }

        .summary-card .summary-header h3 {
            font-size: 14px;
            font-weight: 600;
            color: var(--success);
        }

        .summary-card .summary-content {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .summary-card .summary-content .sub-chip {
            background: rgba(16, 185, 129, 0.1);
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            color: var(--success);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .summary-card .summary-content .sub-chip .chip-icon {
            font-size: 10px;
        }

        /* ==================== EMPLOYEE SELECTION CARD ==================== */
        .selection-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .selection-card .card-header {
            padding: 18px 24px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .selection-card .card-header .card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .selection-card .card-header .card-title i {
            color: var(--primary);
            margin-right: 8px;
        }

        .selection-card .card-header .card-subtitle {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        .selection-card .card-header .selection-actions {
            display: flex;
            gap: 8px;
        }

        .selection-card .card-body {
            padding: 20px;
        }

        .selection-card .card-footer {
            padding: 16px 24px;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        /* ==================== EMPLOYEES GRID ==================== */
        .employees-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 12px;
        }

        .employee-card {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(226, 232, 240, 0.3);
            border-radius: var(--radius);
            padding: 14px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.25s ease;
            cursor: pointer;
        }

        .employee-card:hover {
            border-color: var(--primary-light);
            background: rgba(255, 255, 255, 0.8);
        }

        .employee-card.selected {
            background: rgba(79, 70, 229, 0.06);
            border-color: var(--primary);
        }

        .employee-card .emp-info {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 0;
        }

        .employee-card .emp-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            color: white;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
        }

        .employee-card .emp-details {
            flex: 1;
            min-width: 0;
        }

        .employee-card .emp-details .emp-name {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 14px;
        }

        .employee-card .emp-details .emp-email {
            font-size: 12px;
            color: var(--gray-500);
        }

        .employee-card .emp-details .emp-designation {
            font-size: 11px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        .employee-card .emp-details .emp-designation i {
            margin-right: 4px;
            font-size: 10px;
            color: var(--gray-400);
        }

        .employee-card .emp-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: var(--primary);
            flex-shrink: 0;
        }

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

        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            box-shadow: none;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
            color: var(--gray-600);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
        }

        .btn-outline-primary {
            background: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }

        .btn-outline-primary:hover {
            background: var(--primary-bg);
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
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

        /* ==================== SELECTION INFO ==================== */
        .selection-info {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--primary-light);
        }

        .selection-info i {
            font-size: 16px;
        }

        .selection-info .count {
            font-weight: 700;
            color: var(--gray-900);
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 60px 24px;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 48px;
            opacity: 0.3;
            display: block;
            margin-bottom: 12px;
        }

        .empty-state p {
            font-size: 14px;
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

        .loader-container {
            text-align: center;
            padding: 80px 0;
        }

        .loader-container p {
            color: var(--gray-500);
            margin-top: 16px;
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
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .assign-header { flex-direction: column; align-items: flex-start; }
            .assign-header .header-right { width: 100%; }
            .assign-header .header-right .btn { width: 100%; justify-content: center; }
            .employees-grid { grid-template-columns: 1fr; }
            .selection-card .card-header { flex-direction: column; align-items: flex-start; }
            .selection-card .card-header .selection-actions { width: 100%; }
            .selection-card .card-header .selection-actions .btn { flex: 1; justify-content: center; }
            .selection-card .card-footer { flex-direction: column; align-items: stretch; }
            .selection-card .card-footer .btn { justify-content: center; }
            .info-banner { flex-direction: column; align-items: flex-start; }
        }

        @media (max-width: 480px) {
            .assign-header .header-left { flex-wrap: wrap; }
            .assign-header .header-left h1 { font-size: 18px; }
            .employee-card { flex-wrap: wrap; }
            .employee-card .emp-checkbox { margin-top: 8px; }
            .summary-card .summary-content .sub-chip { font-size: 11px; }
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
             <a href="${pageContext.request.contextPath}/company-admin/employees" class="nav-item">
                 <i class="fas fa-users"></i> Employees
                 <span class="nav-badge" id="employeeCount">0</span>
             </a>

             <div class="sidebar-label">Compliance</div>
             <a href="${pageContext.request.contextPath}/company-admin/compliance/list" class="nav-item active">
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
            <span class="page-title">Assign Compliance</span>
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
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/company-admin/profile'">
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
            <a href="${pageContext.request.contextPath}/company-admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/list">Compliance Categories</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/parent/${parentId}">Compliance Details</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current">Assign to Employees</span>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" class="loader-container">
            <div class="spinner"></div>
            <p>Loading employee list...</p>
        </div>

        <!-- ==================== PAGE CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- ==================== ASSIGN HEADER ==================== -->
            <div class="assign-header">
                <div class="header-left">
                    <div class="header-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div>
                        <h1>Assign Compliance to Employees</h1>
                        <div class="compliance-name" id="complianceName">—</div>
                    </div>
                </div>
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/company-admin/compliance/parent/${parentId}" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Details
                    </a>
                </div>
            </div>

            <!-- ==================== INFO BANNER ==================== -->
            <div class="info-banner">
                <i class="fas fa-info-circle"></i>
                <div class="info-text">
                    <strong>Assign to Multiple Employees</strong>
                    <p>Select one or more employees to assign this compliance. All sub-compliances will be automatically assigned to each selected employee.</p>
                </div>
            </div>

            <!-- ==================== SUB-COMPLIANCES SUMMARY ==================== -->
            <div id="subSummaryCard" class="summary-card" style="display:none;">
                <div class="summary-header">
                    <i class="fas fa-tasks"></i>
                    <h3>Sub-Compliances to be Assigned</h3>
                </div>
                <div class="summary-content" id="subSummary"></div>
            </div>

            <!-- ==================== EMPLOYEE SELECTION ==================== -->
            <div class="selection-card">
                <div class="card-header">
                    <div>
                        <div class="card-title"><i class="fas fa-users"></i>Select Employees</div>
                        <div class="card-subtitle">Choose employees to assign this compliance</div>
                    </div>
                    <div class="selection-actions">
                        <button onclick="selectAll()" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-check-double"></i> Select All
                        </button>
                        <button onclick="deselectAll()" class="btn btn-outline btn-sm">
                            <i class="fas fa-times-circle"></i> Deselect All
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div id="employeesList" class="employees-grid"></div>
                </div>
                <div class="card-footer">
                    <div class="selection-info">
                        <i class="fas fa-user-check"></i>
                        <span><span class="count" id="selectedCount">0</span> employee(s) selected</span>
                    </div>
                    <button onclick="submitAssignment()" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-paper-plane"></i> Assign to Selected Employees
                    </button>
                </div>
            </div>

        </div>

    </main>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var PARENT_ID = '${parentId}';
    var parentData = null;
    var employees = [];
    var selectedEmployees = new Set();
    var subCompliances = [];

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
        return new Date(d).toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
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

    // ==================== LOAD DATA ====================
    async function loadData() {
        if (!PARENT_ID || PARENT_ID === 'null' || PARENT_ID === '') {
            toast('Invalid parent ID', 'error');
            return;
        }

        try {
            // Load compliance data
            var allData = await api('/api/company-admin/compliance/assigned');
            if (allData && allData.success) {
                var allCompliances = allData.data || [];
                var parentIdNum = parseInt(PARENT_ID);

                // Find parent entry by ID, companyComplianceId, or templateId
                var parentEntry = allCompliances.find(function(c) {
                    return c.id === parentIdNum && c.subTemplateId === null;
                });

                if (!parentEntry) {
                    parentEntry = allCompliances.find(function(c) {
                        return c.companyComplianceId === parentIdNum && c.subTemplateId === null;
                    });
                }

                if (!parentEntry) {
                    parentEntry = allCompliances.find(function(c) {
                        return c.templateId === parentIdNum && c.subTemplateId === null;
                    });
                }

                var templateId = parentEntry ? parentEntry.templateId : parentIdNum;

                var subCompliancesList = allCompliances.filter(function(c) {
                    return c.templateId === templateId && c.subTemplateId !== null;
                });

                if (parentEntry) {
                    parentData = {
                        id: parentEntry.id,
                        templateName: parentEntry.templateName || 'Compliance',
                        companyComplianceId: parentEntry.companyComplianceId || parentEntry.id,
                        templateId: parentEntry.templateId
                    };

                    subCompliances = subCompliancesList.map(function(s) {
                        return {
                            id: s.id,
                            subTemplateId: s.subTemplateId,
                            subTemplateName: s.subTemplateName || 'Sub-Compliance',
                            isActive: s.isActive,
                            configured: s.configured !== false,
                            frequency: s.frequency,
                            dueDate: s.dueDate,
                            status: s.status || 'PENDING'
                        };
                    });

                    document.getElementById('complianceName').textContent = parentData.templateName;

                    // Render sub-compliances summary
                    if (subCompliances.length > 0) {
                        document.getElementById('subSummaryCard').style.display = 'block';
                        var subHtml = '';
                        for (var i = 0; i < subCompliances.length; i++) {
                            var s = subCompliances[i];
                            var isConfigured = s.configured === true;
                            subHtml += '<span class="sub-chip">' +
                                '<span class="chip-icon"><i class="fas ' + (isConfigured ? 'fa-check-circle' : 'fa-clock') + '"></i></span> ' +
                                escapeHtml(s.subTemplateName) +
                            '</span>';
                        }
                        document.getElementById('subSummary').innerHTML = subHtml;
                    } else {
                        document.getElementById('subSummaryCard').style.display = 'none';
                    }
                } else {
                    toast('Compliance not found', 'error');
                    document.getElementById('loader').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Compliance not found</p></div>';
                    return;
                }
            }

            // Load employees
            var empData = await api('/api/company-admin/employees?page=0&size=1000');
            if (empData && empData.success) {
                employees = empData.data.content.filter(function(emp) {
                    return emp.role === 'EMPLOYEE';
                });
                renderEmployeesList();
            }

            document.getElementById('loader').style.display = 'none';
            document.getElementById('pageContent').style.display = 'block';

        } catch (error) {
            console.error('Error loading data:', error);
            toast('Failed to load data', 'error');
            document.getElementById('loader').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Failed to load data</p></div>';
        }
    }

    // ==================== RENDER EMPLOYEES ====================
    function renderEmployeesList() {
        var container = document.getElementById('employeesList');

        if (!employees.length) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-users-slash"></i><p>No employees found. Please add employees first.</p><a href="' + contextPath + '/company-admin/employees/add" class="btn btn-primary" style="margin-top:12px;">Add Employee</a></div>';
            return;
        }

        var html = '';
        for (var i = 0; i < employees.length; i++) {
            var emp = employees[i];
            var isSelected = selectedEmployees.has(emp.id);
            var fullName = emp.fullName || emp.firstName + ' ' + emp.lastName;
            var initials = ((emp.firstName || '')[0] || '') + ((emp.lastName || '')[0] || '');

            html += '<div class="employee-card ' + (isSelected ? 'selected' : '') + '" onclick="toggleEmployeeCard(' + emp.id + ')">' +
                '<div class="emp-info">' +
                '<div class="emp-avatar">' + (initials || '?') + '</div>' +
                '<div class="emp-details">' +
                '<div class="emp-name">' + escapeHtml(fullName) + '</div>' +
                '<div class="emp-email">' + escapeHtml(emp.email) + '</div>' +
                '<div class="emp-designation"><i class="fas fa-briefcase"></i> ' + (emp.designation || 'Employee') + '</div>' +
                '</div>' +
                '</div>' +
                '<input type="checkbox" class="emp-checkbox" data-id="' + emp.id + '" ' + (isSelected ? 'checked' : '') + ' onchange="toggleEmployee(' + emp.id + ', this.checked)" onclick="event.stopPropagation();">' +
                '</div>';
        }
        container.innerHTML = html;
        updateSelectedCount();
    }

    // ==================== SELECTION FUNCTIONS ====================
    function toggleEmployeeCard(id) {
        var checkbox = document.querySelector('.emp-checkbox[data-id="' + id + '"]');
        if (checkbox) {
            checkbox.checked = !checkbox.checked;
            toggleEmployee(id, checkbox.checked);
        }
    }

    function toggleEmployee(id, checked) {
        if (checked) {
            selectedEmployees.add(id);
        } else {
            selectedEmployees.delete(id);
        }

        var cards = document.querySelectorAll('.employee-card');
        for (var i = 0; i < cards.length; i++) {
            var checkbox = cards[i].querySelector('.emp-checkbox');
            if (checkbox && parseInt(checkbox.getAttribute('data-id')) === id) {
                if (checked) {
                    cards[i].classList.add('selected');
                } else {
                    cards[i].classList.remove('selected');
                }
                break;
            }
        }

        updateSelectedCount();
    }

    function updateSelectedCount() {
        document.getElementById('selectedCount').textContent = selectedEmployees.size;
    }

    function selectAll() {
        for (var i = 0; i < employees.length; i++) {
            selectedEmployees.add(employees[i].id);
        }
        renderEmployeesList();
    }

    function deselectAll() {
        selectedEmployees.clear();
        renderEmployeesList();
    }

    // ==================== SUBMIT ASSIGNMENT ====================
    async function submitAssignment() {
        if (selectedEmployees.size === 0) {
            toast('Please select at least one employee', 'error');
            return;
        }

        // Check for unconfigured sub-compliances
        var unconfiguredSubs = subCompliances.filter(function(s) { return s.configured !== true; });

        if (unconfiguredSubs.length > 0) {
            var subNames = unconfiguredSubs.map(function(s) { return s.subTemplateName || 'Sub-Compliance'; }).join(', ');
            if (!confirm('⚠️ Warning: The following sub-compliances are NOT configured: ' + subNames + '\n\nEmployees will not be able to complete these until they are configured.\n\nDo you want to continue?')) {
                return;
            }
        }

        if (!confirm('Are you sure you want to assign this compliance to ' + selectedEmployees.size + ' employee(s)?\n\nAll sub-compliances will be assigned automatically.')) {
            return;
        }

        var btn = document.getElementById('submitBtn');
        var originalHtml = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assigning...';

        // Find the compliance config ID to assign
        var configId = null;

        var configuredSub = subCompliances.find(function(s) { return s.configured === true; });

        if (configuredSub) {
            configId = configuredSub.id;
        } else if (subCompliances.length > 0) {
            configId = subCompliances[0].id;
        }

        if (!configId && parentData && parentData.id) {
            configId = parentData.id;
        }

        if (!configId) {
            toast('No compliance configuration found to assign', 'error');
            btn.disabled = false;
            btn.innerHTML = originalHtml;
            return;
        }

        var data = await api('/api/company-admin/compliance/assign?configId=' + configId, {
            method: 'POST',
            body: JSON.stringify(Array.from(selectedEmployees))
        });

        btn.disabled = false;
        btn.innerHTML = originalHtml;

        if (data && data.success) {
            toast('Successfully assigned to ' + selectedEmployees.size + ' employee(s)', 'success');
            setTimeout(function() {
                window.location.href = contextPath + '/company-admin/compliance/parent/' + PARENT_ID;
            }, 1500);
        } else {
            toast(data?.error || 'Assignment failed', 'error');
        }
    }

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

        loadData();
        loadNotifications();
    });
</script>

</body>
</html>