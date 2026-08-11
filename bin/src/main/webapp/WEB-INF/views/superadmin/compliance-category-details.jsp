<%-- File: superadmin/compliance-category-details.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Try to get categoryId from request attribute (set by controller via model)
    String categoryId = null;

    Object attrId = request.getAttribute("categoryId");
    if (attrId != null) {
        categoryId = String.valueOf(attrId);
    }

    // Fallback: extract from URL path variable e.g. /super-admin/compliance/category/2
    if (categoryId == null || categoryId.trim().isEmpty() || "null".equals(categoryId)) {
        String uri = request.getRequestURI();
        String[] parts = uri.split("/");
        for (int i = parts.length - 1; i >= 0; i--) {
            String part = parts[i];
            if (part.contains("?")) part = part.substring(0, part.indexOf("?"));
            try {
                Long.parseLong(part);
                categoryId = part;
                break;
            } catch (NumberFormatException e) {
                // not a number, keep trying
            }
        }
    }

    // Fallback: query param ?id=2
    if (categoryId == null || categoryId.trim().isEmpty() || "null".equals(categoryId)) {
        categoryId = request.getParameter("id");
    }

    if (categoryId == null || categoryId.trim().isEmpty() || "null".equals(categoryId)) {
        response.sendRedirect(request.getContextPath() + "/super-admin/compliance/templates");
        return;
    }
    pageContext.setAttribute("categoryId", categoryId);
    pageContext.setAttribute("pageTitle", "Compliance Category Details");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Compliance Category Details</title>

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
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .breadcrumb .back-link {
            color: var(--primary);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .breadcrumb .back-link:hover {
            text-decoration: underline;
        }

        .breadcrumb .back-link i {
            font-size: 12px;
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

        .btn-warning {
            background: var(--warning);
            color: white;
            border-color: var(--warning);
        }

        .btn-warning:hover {
            background: #d97706;
            border-color: #d97706;
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
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

        /* ==================== HEADER CARD ==================== */
        .header-card {
            padding: 24px;
            margin-bottom: 24px;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.05) 0%, rgba(79, 70, 229, 0.02) 100%);
        }

        .header-card .header-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 16px;
        }

        .header-card .header-content .left {
            flex: 1;
        }

        .header-card .header-content .left .title-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .header-card .header-content .left .title-row .icon-box {
            width: 48px;
            height: 48px;
            background: rgba(79, 70, 229, 0.12);
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .header-card .header-content .left .title-row .icon-box i {
            font-size: 24px;
            color: var(--primary);
        }

        .header-card .header-content .left .title-row h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
        }

        .header-card .header-content .left .meta-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .header-card .header-content .left .meta-row .meta-item {
            font-size: 12px;
            color: var(--gray-500);
        }

        .header-card .header-content .left .meta-row .meta-item i {
            margin-right: 4px;
        }

        .header-card .header-content .left .description {
            color: var(--gray-500);
            margin-top: 8px;
            max-width: 600px;
            line-height: 1.5;
        }

        .header-card .header-content .right {
            flex-shrink: 0;
        }

        /* ==================== STATS CARDS ==================== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            padding: 20px;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
        }

        .stat-card .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-bottom: 12px;
        }

        .stat-card .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--gray-900);
            line-height: 1.2;
        }

        .stat-card .stat-label {
            font-size: 12px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-top: 2px;
        }

        .stat-card .stat-bg {
            position: absolute;
            right: -10px;
            bottom: -10px;
            font-size: 64px;
            opacity: 0.04;
            color: var(--gray-900);
        }

        /* ==================== PROGRESS ==================== */
        .progress-section {
            padding: 20px;
            margin-bottom: 20px;
        }

        .progress-section .section-header {
            margin-bottom: 16px;
        }

        .progress-section .section-header h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .progress-section .section-header p {
            font-size: 12px;
            color: var(--gray-500);
        }

        .progress-section .progress-body {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .progress-section .progress-body .progress-track {
            flex: 1;
            min-width: 200px;
        }

        .progress-section .progress-body .progress-track .progress-bar {
            height: 8px;
            background: rgba(226, 232, 240, 0.5);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-section .progress-body .progress-track .progress-bar .progress-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        .progress-section .progress-body .progress-track .progress-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
        }

        .progress-section .progress-body .progress-track .progress-labels span {
            font-size: 12px;
            color: var(--gray-500);
        }

        .progress-section .progress-body .completion-rate {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary);
            flex-shrink: 0;
        }

        /* ==================== FILTER BAR ==================== */
        .filter-card {
            padding: 20px;
            margin-bottom: 20px;
        }

        .filter-card .filter-header {
            margin-bottom: 16px;
        }

        .filter-card .filter-header h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .filter-card .filter-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .filter-card .filter-actions {
            display: flex;
            gap: 10px;
            margin-top: 16px;
            justify-content: flex-end;
        }

        /* ==================== FORM ==================== */
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 4px;
        }

        .form-label i {
            margin-right: 4px;
            color: var(--gray-500);
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

        .form-input::placeholder {
            color: var(--gray-400);
        }

        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
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

        /* ==================== AVATAR ==================== */
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
        }

        /* ==================== COMPANY CARD ==================== */
        .company-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius);
            padding: 18px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .company-card:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        }

        .company-card .card-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .company-card .card-row .company-info {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
        }

        .company-card .card-row .company-info .company-name {
            font-weight: 600;
            font-size: 15px;
            color: var(--gray-900);
        }

        .company-card .card-row .company-info .company-email {
            font-size: 11px;
            color: var(--gray-500);
        }

        .company-card .card-row .actions {
            display: flex;
            gap: 4px;
            flex-shrink: 0;
        }

        .company-card .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin: 12px 0;
            padding: 10px 0;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }

        .company-card .stats-row .stat-item .stat-label {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .company-card .stats-row .stat-item .stat-value {
            margin-top: 4px;
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-800);
        }

        .company-card .footer-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 11px;
            color: var(--gray-500);
        }

        .company-card .footer-row i {
            margin-right: 4px;
        }

        .company-card .days-warning {
            margin-top: 8px;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 11px;
        }

        .company-card .days-warning.overdue {
            background: rgba(239, 68, 68, 0.08);
            color: var(--danger);
        }

        .company-card .days-warning.soon {
            background: rgba(245, 158, 11, 0.08);
            color: var(--warning);
        }

        .company-card .notes {
            margin-top: 8px;
            padding: 6px 12px;
            background: rgba(226, 232, 240, 0.15);
            border-radius: 6px;
            font-size: 11px;
            color: var(--gray-500);
        }

        /* ==================== STATUS DOT ==================== */
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 6px;
        }

        .status-dot.active { background: var(--success); box-shadow: 0 0 6px var(--success); }
        .status-dot.inactive { background: var(--danger); }
        .status-dot.pending { background: var(--warning); }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .status-dot.overdue { background: var(--danger); animation: pulse 1s infinite; }

        /* ==================== COMPANIES GRID ==================== */
        .companies-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        /* ==================== PAGINATION ==================== */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination-container .pagination-wrap {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .page-btn {
            padding: 6px 12px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            color: var(--gray-600);
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
        }

        .page-btn:hover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.06);
            color: var(--primary);
        }

        .page-btn.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        .page-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-500);
            grid-column: 1 / -1;
        }

        .empty-state i {
            font-size: 48px;
            opacity: 0.3;
            margin-bottom: 12px;
        }

        .empty-state p {
            margin-bottom: 12px;
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
            max-width: 650px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        .modal-box.small {
            max-width: 420px;
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

        .modal-header .modal-subtitle {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 2px;
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

        .modal-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .modal-info-box {
            background: rgba(226, 232, 240, 0.12);
            padding: 12px;
            border-radius: var(--radius);
        }

        .modal-info-box .label {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .modal-info-box .value {
            margin-top: 4px;
            font-weight: 500;
            color: var(--gray-800);
        }

        .modal-warning {
            font-size: 12px;
            color: var(--warning);
            margin-top: 12px;
        }

        .modal-warning i {
            margin-right: 6px;
        }

        .modal-danger {
            font-size: 12px;
            color: var(--danger);
            margin-top: 12px;
        }

        .modal-danger i {
            margin-right: 6px;
        }

        /* ==================== SCROLLBAR ==================== */
        .scrollable {
            max-height: 50vh;
            overflow-y: auto;
        }

        .scrollable::-webkit-scrollbar {
            width: 4px;
        }

        .scrollable::-webkit-scrollbar-track {
            background: rgba(226, 232, 240, 0.2);
            border-radius: 2px;
        }

        .scrollable::-webkit-scrollbar-thumb {
            background: var(--gray-300);
            border-radius: 2px;
        }

        .scrollable::-webkit-scrollbar-thumb:hover {
            background: var(--gray-400);
        }

        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.open {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
                padding: 24px;
            }
            .logo-bg { width: 500px; height: 500px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .filter-card .filter-grid { grid-template-columns: repeat(2, 1fr); }
            .modal-grid-2 { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }

            .stats-grid { grid-template-columns: 1fr; }
            .filter-card .filter-grid { grid-template-columns: 1fr; }
            .companies-grid { grid-template-columns: 1fr; }

            .header-card .header-content {
                flex-direction: column;
                align-items: flex-start;
            }
            .header-card .header-content .right {
                align-self: flex-start;
            }

            .breadcrumb {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }

            .company-card .card-row {
                flex-direction: column;
                align-items: stretch;
                gap: 8px;
            }
            .company-card .card-row .actions {
                justify-content: flex-end;
            }
            .company-card .stats-row {
                grid-template-columns: 1fr;
                gap: 6px;
            }
        }

        @media (max-width: 480px) {
            .header-card .header-content .left .title-row h1 { font-size: 20px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .stat-card .stat-value { font-size: 22px; }
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
                <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
            </div>
            <span class="brand-text">VNext Legal</span>
            <span class="brand-badge">LLP</span>
        </div>

        <div class="sidebar-label">Main</div>
        <a href="${pageContext.request.contextPath}/super-admin/dashboard" class="nav-item">
            <i class="fas fa-chart-pie"></i> Dashboard
        </a>

        <div class="sidebar-label">Management</div>
        <a href="${pageContext.request.contextPath}/super-admin/companies" class="nav-item">
            <i class="fas fa-building"></i> Companies
            <span class="nav-badge" id="companyCount">0</span>
        </a>

        <div class="sidebar-label">Compliance</div>
        <a href="${pageContext.request.contextPath}/super-admin/compliance/templates" class="nav-item active">
            <i class="fas fa-tags"></i> Categories
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${pageContext.request.contextPath}/super-admin/notifications" class="nav-item">
            <i class="fas fa-bell"></i> Notifications
            <span class="nav-badge" id="notifCount">0</span>
        </a>

        <div class="sidebar-label">Account</div>
        <a href="${pageContext.request.contextPath}/change-password" class="nav-item">
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
            <span class="page-title">Category Details</span>
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
                        <a href="${pageContext.request.contextPath}/super-admin/notifications">View all notifications</a>
                    </div>
                </div>
            </div>

            <!-- User -->
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/super-admin/profile'">
                <div class="avatar" id="userAvatar">U</div>
                <div class="user-info">
                    <span class="user-name" id="userName">User</span>
                    <span class="user-role" id="userRole">Super Admin</span>
                </div>
            </div>
        </div>
    </header>

    <!-- ==================== MAIN CONTENT ==================== -->
    <main class="main-content">

        <!-- ==================== BREADCRUMB ==================== -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/super-admin/compliance/templates" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Compliance Categories
            </a>
            <button onclick="refreshData()" class="btn btn-ghost btn-sm">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" style="text-align:center;padding:80px;">
            <div class="spinner"></div>
            <div style="color:var(--gray-500);font-size:13px;margin-top:12px;">Loading category details...</div>
        </div>

        <!-- ==================== PAGE CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- ==================== HEADER CARD ==================== -->
            <div class="card header-card">
                <div class="header-content">
                    <div class="left">
                        <div class="title-row">
                            <div class="icon-box">
                                <i class="fas fa-folder-open"></i>
                            </div>
                            <h1 id="categoryName">—</h1>
                        </div>
                        <div class="meta-row">
                            <span id="statusBadge"></span>
                            <span class="meta-item"><i class="fas fa-calendar-alt"></i> Created: <span id="createdAt">—</span></span>
                            <span class="meta-item"><i class="fas fa-edit"></i> Updated: <span id="updatedAt">—</span></span>
                        </div>
                        <div class="description" id="categoryDesc">—</div>
                    </div>
                    <div class="right">
                        <button onclick="toggleCategoryStatus()" id="statusToggleBtn" class="btn"></button>
                    </div>
                </div>
            </div>

            <!-- ==================== STATS ==================== -->
            <div class="stats-grid">
                <div class="card stat-card" onclick="scrollToCompanies()">
                    <div class="stat-icon" style="background:rgba(79,70,229,0.12);color:var(--primary);">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="stat-value" id="statTotal">0</div>
                    <div class="stat-label">Companies Assigned</div>
                    <div class="stat-bg"><i class="fas fa-building"></i></div>
                </div>
                <div class="card stat-card" onclick="filterByAssignment('active')">
                    <div class="stat-icon" style="background:rgba(16,185,129,0.12);color:var(--success);">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-value" id="statActive" style="color:var(--success);">0</div>
                    <div class="stat-label">Active Assignments</div>
                    <div class="stat-bg"><i class="fas fa-check-circle"></i></div>
                </div>
                <div class="card stat-card" onclick="filterByConfig('true')">
                    <div class="stat-icon" style="background:rgba(79,70,229,0.12);color:var(--primary);">
                        <i class="fas fa-cog"></i>
                    </div>
                    <div class="stat-value" id="statConfigured" style="color:var(--primary);">0</div>
                    <div class="stat-label">Configured</div>
                    <div class="stat-bg"><i class="fas fa-cog"></i></div>
                </div>
                <div class="card stat-card" onclick="filterByStatus('COMPLETED')">
                    <div class="stat-icon" style="background:rgba(16,185,129,0.12);color:var(--success);">
                        <i class="fas fa-check-double"></i>
                    </div>
                    <div class="stat-value" id="statCompleted" style="color:var(--success);">0</div>
                    <div class="stat-label">Completed</div>
                    <div class="stat-bg"><i class="fas fa-check-double"></i></div>
                </div>
            </div>

            <!-- ==================== PROGRESS ==================== -->
            <div class="card progress-section">
                <div class="section-header">
                    <h3>Configuration Progress</h3>
                    <p>How many companies have configured this compliance</p>
                </div>
                <div class="progress-body">
                    <div class="progress-track">
                        <div class="progress-bar">
                            <div id="configProgressBar" class="progress-fill" style="width:0%;background:var(--primary);"></div>
                        </div>
                        <div class="progress-labels">
                            <span><span id="configuredCount">0</span> configured</span>
                            <span><span id="notConfiguredCount">0</span> pending</span>
                        </div>
                    </div>
                    <div class="completion-rate" id="completionRate">0%</div>
                </div>
            </div>

            <!-- ==================== FILTER BAR ==================== -->
            <div class="card filter-card">
                <div class="filter-header">
                    <h3><i class="fas fa-filter" style="color:var(--primary);margin-right:8px;"></i>Filter Companies</h3>
                </div>
                <div class="filter-grid">
                    <div>
                        <label class="form-label"><i class="fas fa-search"></i> Search</label>
                        <input type="text" id="searchInput" class="form-input" placeholder="Company name or email...">
                    </div>
                    <div>
                        <label class="form-label"><i class="fas fa-chart-line"></i> Compliance Status</label>
                        <select id="statusFilter" class="form-input">
                            <option value="">All Status</option>
                            <option value="PENDING">Pending</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="OVERDUE">Overdue</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label"><i class="fas fa-cog"></i> Configuration Status</label>
                        <select id="configFilter" class="form-input">
                            <option value="">All</option>
                            <option value="true">Configured</option>
                            <option value="false">Not Configured</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label"><i class="fas fa-flag"></i> Assignment Status</label>
                        <select id="assignmentFilter" class="form-input">
                            <option value="">All</option>
                            <option value="active">Active Only</option>
                            <option value="inactive">Inactive Only</option>
                        </select>
                    </div>
                </div>
                <div class="filter-actions">
                    <button onclick="resetFilters()" class="btn btn-ghost btn-sm">
                        <i class="fas fa-undo"></i> Reset All
                    </button>
                    <button onclick="exportToCSV()" class="btn btn-ghost btn-sm">
                        <i class="fas fa-download"></i> Export CSV
                    </button>
                </div>
            </div>

            <!-- ==================== COMPANIES HEADER ==================== -->
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                <div>
                    <h3 style="font-size:16px;font-weight:700;color:var(--gray-900);">
                        <i class="fas fa-building" style="color:var(--primary);margin-right:8px;"></i>Assigned Companies
                    </h3>
                    <p id="companiesCount" style="font-size:12px;color:var(--gray-500);margin-top:4px;">0 companies</p>
                </div>
                <div>
                    <select id="sortBy" class="form-input" style="width:auto;padding:6px 12px;min-width:160px;" onchange="loadCompanies()">
                        <option value="name">Sort by: Name</option>
                        <option value="date">Sort by: Assigned Date</option>
                        <option value="status">Sort by: Status</option>
                    </select>
                </div>
            </div>

            <!-- ==================== COMPANIES GRID ==================== -->
            <div id="companiesGrid" class="companies-grid"></div>

            <!-- ==================== PAGINATION ==================== -->
            <div id="pagination" class="pagination-container"></div>

        </div>

    </main>
</div>

<!-- ==================== COMPANY DETAILS MODAL ==================== -->
<div id="companyModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="modalCompanyName">Company Details</div>
                <div class="modal-subtitle" id="modalCompanyEmail">Compliance Information</div>
            </div>
            <button class="modal-close" onclick="closeCompanyModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body scrollable" id="companyModalBody"></div>
        <div class="modal-footer">
            <button onclick="closeCompanyModal()" class="btn btn-ghost">Close</button>
        </div>
    </div>
</div>

<!-- ==================== HISTORY MODAL ==================== -->
<div id="historyModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-history" style="color:var(--primary);margin-right:8px;"></i>Compliance History</div>
                <div class="modal-subtitle">Audit trail of all changes</div>
            </div>
            <button class="modal-close" onclick="closeHistoryModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body scrollable" id="historyModalBody"></div>
        <div class="modal-footer">
            <button onclick="closeHistoryModal()" class="btn btn-ghost">Close</button>
        </div>
    </div>
</div>

<!-- ==================== CONFIRM MODAL ==================== -->
<div id="confirmModal" class="modal-overlay">
    <div class="modal-box small">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="confirmTitle"><i class="fas fa-exclamation-triangle" style="color:var(--warning);margin-right:8px;"></i>Confirm Action</div>
                <div class="modal-subtitle">Please confirm before proceeding</div>
            </div>
            <button class="modal-close" onclick="closeConfirmModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p id="confirmMessage" style="margin-bottom:0;">Are you sure?</p>
            <div id="confirmWarning" class="modal-warning" style="display:none;"></div>
        </div>
        <div class="modal-footer">
            <button onclick="closeConfirmModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="executeConfirmAction()" class="btn btn-primary" id="confirmBtn">Confirm</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var CATEGORY_ID = '${categoryId}';
    var categoryData = null;
    var allCompanies = [];
    var currentPage = 0;
    var pageSize = 12;
    var pendingAction = null;

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

    function formatDateTime(d) {
        if (!d) return '—';
        return new Date(d).toLocaleString('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
    }

    function getStatusClass(s) {
        var map = {
            'ACTIVE': 'badge-active',
            'INACTIVE': 'badge-inactive',
            'DEACTIVATED': 'badge-inactive',
            'PENDING': 'badge-pending',
            'IN_PROGRESS': 'badge-info',
            'COMPLETED': 'badge-active',
            'OVERDUE': 'badge-danger',
            'EXEMPTED': 'badge-info'
        };
        return map[s] || 'badge-info';
    }

    function getStatusIcon(s) {
        var map = {
            'PENDING': 'fa-clock',
            'IN_PROGRESS': 'fa-spinner fa-pulse',
            'COMPLETED': 'fa-check-circle',
            'OVERDUE': 'fa-exclamation-triangle',
            'ACTIVE': 'fa-check-circle',
            'INACTIVE': 'fa-ban'
        };
        return map[s] || 'fa-circle';
    }

    function getStatusLabel(s) {
        var map = {
            'PENDING': 'Pending',
            'IN_PROGRESS': 'In Progress',
            'COMPLETED': 'Completed',
            'OVERDUE': 'Overdue',
            'EXEMPTED': 'Exempted',
            'ACTIVE': 'Active',
            'INACTIVE': 'Inactive'
        };
        return map[s] || s;
    }

    // ==================== SIDEBAR ====================
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('open');
    }

    // Close sidebar on outside click for mobile
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

    // ==================== LOGOUT ====================
    function handleLogout() {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('user');
        window.location.href = contextPath + '/login?logout=true';
    }

    // ==================== NOTIFICATIONS ====================
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
                document.getElementById('notifCount').textContent = data.data.length;
            } else {
                list.innerHTML = '<div class="notification-empty">' +
                    '<i class="fas fa-bell-slash"></i>' +
                    '<div>No notifications</div>' +
                    '</div>';
                document.getElementById('notifBadge').textContent = '0';
                document.getElementById('notifCount').textContent = '0';
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
        document.getElementById('notifCount').textContent = '0';
    }

    // Close notification dropdown on outside click
    document.addEventListener('click', function(e) {
        var dropdown = document.getElementById('notificationDropdown');
        var btn = document.querySelector('[onclick*="toggleNotifications"]');
        if (dropdown && btn) {
            if (dropdown.classList.contains('open') && !dropdown.contains(e.target) && !btn.contains(e.target)) {
                dropdown.classList.remove('open');
            }
        }
    });

    // ==================== LOAD CATEGORY ====================
    async function loadCategoryDetails() {
        if (!CATEGORY_ID || CATEGORY_ID === 'null' || CATEGORY_ID === '') {
            toast('Invalid category ID', 'error');
            setTimeout(function() {
                window.location.href = contextPath + '/super-admin/compliance/templates';
            }, 1500);
            return;
        }

        document.getElementById('loader').style.display = 'block';
        document.getElementById('pageContent').style.display = 'none';

        var data = await api('/api/super-admin/compliance/categories/' + CATEGORY_ID + '/details');

        if (data && data.success) {
            categoryData = data.data;
            renderCategoryHeader();
            updateStats();
            updateProgress();
            loadCompanies();
            document.getElementById('loader').style.display = 'none';
            document.getElementById('pageContent').style.display = 'block';
        } else {
            toast('Failed to load category details: ' + (data ? (data.error || data.message) : 'No response'), 'error');
            setTimeout(function() {
                window.location.href = contextPath + '/super-admin/compliance/templates';
            }, 2000);
        }
    }

    // ==================== RENDER HEADER ====================
    function renderCategoryHeader() {
        var c = categoryData;
        document.getElementById('categoryName').textContent = c.name;
        document.getElementById('categoryDesc').textContent = c.description || 'No description provided.';
        document.getElementById('createdAt').textContent = formatDate(c.createdAt);
        document.getElementById('updatedAt').textContent = formatDate(c.updatedAt);

        var statusClass = c.isActive ? 'badge-active' : 'badge-inactive';
        document.getElementById('statusBadge').innerHTML =
            '<span class="badge ' + statusClass + '"><i class="fas fa-circle" style="font-size:5px;margin-right:4px;"></i> ' +
            (c.isActive ? 'Active' : 'Inactive') + '</span>';

        var btn = document.getElementById('statusToggleBtn');
        btn.className = c.isActive ? 'btn btn-danger' : 'btn btn-success';
        btn.innerHTML = c.isActive
            ? '<i class="fas fa-ban"></i> Deactivate Category'
            : '<i class="fas fa-check"></i> Activate Category';
    }

    // ==================== STATS ====================
    function updateStats() {
        if (!categoryData) return;
        document.getElementById('statTotal').textContent = categoryData.totalCompaniesAssigned || 0;
        document.getElementById('statActive').textContent = categoryData.activeCompaniesCount || 0;
        document.getElementById('statConfigured').textContent = categoryData.configuredCompaniesCount || 0;
        document.getElementById('statCompleted').textContent = categoryData.completedCount || 0;
    }

    function updateProgress() {
        if (!categoryData) return;
        var total = categoryData.totalCompaniesAssigned || 0;
        var configured = categoryData.configuredCompaniesCount || 0;
        var pct = total > 0 ? Math.round((configured / total) * 100) : 0;
        var bar = document.getElementById('configProgressBar');
        bar.style.width = pct + '%';
        bar.style.background = pct >= 80 ? 'var(--success)' : pct >= 50 ? 'var(--warning)' : 'var(--danger)';
        document.getElementById('configuredCount').textContent = configured;
        document.getElementById('notConfiguredCount').textContent = (categoryData.pendingConfigCount || 0);
        document.getElementById('completionRate').textContent = pct + '%';
    }

    // ==================== COMPANIES ====================
    function loadCompanies() {
        if (!categoryData || !categoryData.assignments) return;

        var status = document.getElementById('statusFilter').value;
        var configured = document.getElementById('configFilter').value;
        var assignment = document.getElementById('assignmentFilter').value;
        var search = document.getElementById('searchInput').value.toLowerCase();
        var sortBy = document.getElementById('sortBy').value;

        var list = (categoryData.assignments || []).slice();

        if (status) {
            list = list.filter(function(c) { return c.complianceStatus === status; });
        }
        if (configured !== '') {
            var wantConfigured = configured === 'true';
            list = list.filter(function(c) { return c.isConfigured === wantConfigured; });
        }
        if (assignment === 'active') {
            list = list.filter(function(c) { return c.isActive !== false; });
        }
        if (assignment === 'inactive') {
            list = list.filter(function(c) { return c.isActive === false; });
        }
        if (search) {
            list = list.filter(function(c) {
                return (c.companyName || '').toLowerCase().includes(search) ||
                       (c.companyEmail || '').toLowerCase().includes(search);
            });
        }

        if (sortBy === 'name') {
            list.sort(function(a, b) { return a.companyName.localeCompare(b.companyName); });
        } else if (sortBy === 'date') {
            list.sort(function(a, b) { return new Date(b.assignedAt) - new Date(a.assignedAt); });
        } else if (sortBy === 'status') {
            list.sort(function(a, b) { return (a.complianceStatus || '').localeCompare(b.complianceStatus || ''); });
        }

        allCompanies = list;
        currentPage = 0;
        renderCompaniesGrid();
        document.getElementById('companiesCount').innerHTML =
            '<i class="fas fa-building"></i> ' + list.length + ' companies';
    }

    // ==================== RENDER COMPANIES ====================
    function renderCompaniesGrid() {
        var start = currentPage * pageSize;
        var page = allCompanies.slice(start, start + pageSize);
        var grid = document.getElementById('companiesGrid');

        if (!page.length) {
            grid.innerHTML =
                '<div class="empty-state">' +
                '<i class="fas fa-building"></i>' +
                '<p>No companies match the selected filters</p>' +
                '<button onclick="resetFilters()" class="btn btn-primary">Reset Filters</button>' +
                '</div>';
            renderPagination();
            return;
        }

        var html = '';
        for (var i = 0; i < page.length; i++) {
            var c = page[i];
            var isActive = c.isActive !== false;
            var isConfigured = c.isConfigured;
            var statusClass = getStatusClass(c.complianceStatus);
            var statusDisp = getStatusLabel(c.complianceStatus);
            var statusIcon = getStatusIcon(c.complianceStatus);

            // Days remaining warning
            var daysHtml = '';
            if (c.dueDate && c.complianceStatus !== 'COMPLETED') {
                var diff = Math.ceil((new Date(c.dueDate) - new Date()) / 86400000);
                if (diff < 0) {
                    daysHtml = '<div class="days-warning overdue"><i class="fas fa-exclamation-triangle"></i> Overdue by ' + Math.abs(diff) + ' days</div>';
                } else if (diff <= 7) {
                    daysHtml = '<div class="days-warning soon"><i class="fas fa-hourglass-half"></i> ' + diff + ' days remaining</div>';
                }
            }

            html +=
                '<div class="company-card">' +
                /* header row */
                '<div class="card-row">' +
                    '<div class="company-info">' +
                        '<div class="avatar">' + escapeHtml((c.companyName || '?')[0].toUpperCase()) + '</div>' +
                        '<div>' +
                            '<div class="company-name">' + escapeHtml(c.companyName) + '</div>' +
                            '<div class="company-email">' + escapeHtml(c.companyEmail) + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="actions">' +
                        '<button onclick="viewCompanyDetails(' + c.companyComplianceId + ')" class="btn btn-ghost btn-sm" title="View Details"><i class="fas fa-eye"></i></button>' +
                        '<button onclick="viewHistory(' + c.companyComplianceId + ')" class="btn btn-ghost btn-sm" title="View History"><i class="fas fa-history"></i></button>' +
                        '<button onclick="toggleAssignment(' + c.companyComplianceId + ', ' + isActive + ')" class="btn ' + (isActive ? 'btn-warning' : 'btn-success') + ' btn-sm" title="' + (isActive ? 'Deactivate' : 'Activate') + '"><i class="fas ' + (isActive ? 'fa-pause' : 'fa-play') + '"></i></button>' +
                        '<button onclick="removeCompany(' + c.companyId + ', \'' + escapeHtml(c.companyName) + '\')" class="btn btn-danger btn-sm" title="Remove"><i class="fas fa-trash-alt"></i></button>' +
                    '</div>' +
                '</div>' +
                /* stats row */
                '<div class="stats-row">' +
                    '<div class="stat-item">' +
                        '<div class="stat-label">Assignment</div>' +
                        '<div class="stat-value"><span class="status-dot ' + (isActive ? 'active' : 'inactive') + '"></span>' + (isActive ? 'Active' : 'Inactive') + '</div>' +
                    '</div>' +
                    '<div class="stat-item">' +
                        '<div class="stat-label">Compliance</div>' +
                        '<div class="stat-value"><i class="fas ' + statusIcon + '" style="font-size:10px;margin-right:4px;"></i>' + statusDisp + '</div>' +
                    '</div>' +
                    '<div class="stat-item">' +
                        '<div class="stat-label">Configuration</div>' +
                        '<div class="stat-value"><i class="fas ' + (isConfigured ? 'fa-check-circle' : 'fa-clock') + '" style="color:' + (isConfigured ? 'var(--success)' : 'var(--warning)') + ';font-size:10px;margin-right:4px;"></i>' + (isConfigured ? 'Configured' : 'Pending') + '</div>' +
                    '</div>' +
                '</div>' +
                /* footer row */
                '<div class="footer-row">' +
                    '<span><i class="fas fa-calendar-plus"></i> Assigned: ' + formatDate(c.assignedAt) + '</span>' +
                    (c.dueDate ? '<span><i class="fas fa-calendar-check"></i> Due: ' + formatDate(c.dueDate) + '</span>' : '<span></span>') +
                '</div>' +
                daysHtml +
                (c.notes ? '<div class="notes"><i class="fas fa-sticky-note"></i> ' + escapeHtml(c.notes) + '</div>' : '') +
                '</div>';
        }
        grid.innerHTML = html;
        renderPagination();
    }

    // ==================== PAGINATION ====================
    function renderPagination() {
        var total = Math.ceil(allCompanies.length / pageSize);
        var div = document.getElementById('pagination');
        if (total <= 1) { div.innerHTML = ''; return; }

        var html = '<div class="pagination-wrap">';
        html += '<button class="page-btn" onclick="goPage(0)" ' + (currentPage === 0 ? 'disabled' : '') + '><i class="fas fa-angle-double-left"></i></button>';
        html += '<button class="page-btn" onclick="goPage(' + (currentPage - 1) + ')" ' + (currentPage === 0 ? 'disabled' : '') + '><i class="fas fa-chevron-left"></i></button>';

        var s = Math.max(0, currentPage - 2);
        var e = Math.min(total - 1, currentPage + 2);
        for (var i = s; i <= e; i++) {
            html += '<button class="page-btn ' + (i === currentPage ? 'active' : '') + '" onclick="goPage(' + i + ')">' + (i + 1) + '</button>';
        }

        html += '<button class="page-btn" onclick="goPage(' + (currentPage + 1) + ')" ' + (currentPage >= total - 1 ? 'disabled' : '') + '><i class="fas fa-chevron-right"></i></button>';
        html += '<button class="page-btn" onclick="goPage(' + (total - 1) + ')" ' + (currentPage >= total - 1 ? 'disabled' : '') + '><i class="fas fa-angle-double-right"></i></button>';
        html += '</div>';
        div.innerHTML = html;
    }

    function goPage(p) {
        currentPage = p;
        renderCompaniesGrid();
    }

    // ==================== MODALS & ACTIONS ====================
    async function viewCompanyDetails(ccId) {
        var data = await api('/api/super-admin/compliance/compliance/' + ccId);
        if (!data || !data.success) {
            toast('Failed to load details', 'error');
            return;
        }
        var c = data.data;
        document.getElementById('modalCompanyName').textContent = c.companyName || 'Company Details';
        document.getElementById('modalCompanyEmail').textContent = (c.templateName || 'Compliance') + ' — Compliance Details';

        var html =
            '<div style="display:flex;flex-direction:column;gap:16px;">' +
            '<div class="modal-grid-2">' +
                '<div class="modal-info-box">' +
                    '<div class="label">STATUS</div>' +
                    '<div class="value"><span class="badge ' + getStatusClass(c.status) + '">' + getStatusLabel(c.status) + '</span></div>' +
                '</div>' +
                '<div class="modal-info-box">' +
                    '<div class="label">CONFIGURATION</div>' +
                    '<div class="value"><span class="badge ' + (c.configured ? 'badge-active' : 'badge-pending') + '">' + (c.configured ? 'Configured' : 'Pending') + '</span></div>' +
                '</div>' +
                '<div class="modal-info-box">' +
                    '<div class="label">ASSIGNED ON</div>' +
                    '<div class="value">' + formatDateTime(c.assignedAt) + '</div>' +
                '</div>' +
                (c.dueDate ? '<div class="modal-info-box">' +
                    '<div class="label">DUE DATE</div>' +
                    '<div class="value">' + formatDate(c.dueDate) + '</div>' +
                '</div>' : '') +
                (c.completedAt ? '<div class="modal-info-box">' +
                    '<div class="label">COMPLETED ON</div>' +
                    '<div class="value">' + formatDateTime(c.completedAt) + '</div>' +
                '</div>' : '') +
                '<div class="modal-info-box">' +
                    '<div class="label">ASSIGNED BY</div>' +
                    '<div class="value">' + (c.assignedByName || 'System') + '</div>' +
                '</div>' +
            '</div>' +
            (c.notes ? '<div><strong>Notes:</strong><br><div style="background:rgba(226,232,240,0.12);padding:10px;border-radius:6px;">' + escapeHtml(c.notes) + '</div></div>' : '') +
            '</div>';

        document.getElementById('companyModalBody').innerHTML = html;
        document.getElementById('companyModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeCompanyModal() {
        document.getElementById('companyModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function viewHistory(ccId) {
        var data = await api('/api/super-admin/compliance/compliance/' + ccId + '/history');
        if (!data || !data.success) {
            toast('Failed to load history', 'error');
            return;
        }
        var list = data.data || [];
        if (!list.length) {
            document.getElementById('historyModalBody').innerHTML = '<div class="empty-state">No history available</div>';
        } else {
            var html = '<div style="display:flex;flex-direction:column;gap:8px;">';
            for (var i = 0; i < list.length; i++) {
                var h = list[i];
                var isCompletion = h.action && (h.action.toLowerCase().includes('complete') || h.action.toLowerCase().includes('completed'));
                var borderColor = isCompletion ? 'var(--success)' : 'var(--primary)';

                html += '<div style="padding:12px;background:rgba(226,232,240,0.12);border-radius:8px;border-left:3px solid ' + borderColor + ';">' +
                    '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                        '<strong>' + escapeHtml(h.action || 'Update') + '</strong>' +
                        '<span style="font-size:10px;color:var(--gray-500);">' + formatDateTime(h.performedAt) + '</span>' +
                    '</div>' +
                    (h.previousStatus ? '<div style="font-size:12px;color:var(--gray-500);">' +
                        getStatusLabel(h.previousStatus) + ' → ' + getStatusLabel(h.newStatus) +
                    '</div>' : '') +
                    (h.remarks ? '<div style="font-size:11px;color:var(--gray-500);margin-top:6px;">📝 ' + escapeHtml(h.remarks) + '</div>' : '') +
                    '<div style="font-size:10px;color:var(--gray-500);margin-top:6px;">👤 ' + (h.performedByName || 'System') + '</div>' +
                '</div>';
            }
            html += '</div>';
            document.getElementById('historyModalBody').innerHTML = html;
        }
        document.getElementById('historyModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeHistoryModal() {
        document.getElementById('historyModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function toggleAssignment(ccId, currentActive) {
        showConfirm(
            'Toggle Assignment',
            'Are you sure you want to ' + (currentActive ? 'deactivate' : 'activate') + ' this assignment?',
            currentActive
                ? 'Deactivating will hide this compliance from the company admin until reactivated.'
                : 'Activating will make this compliance visible to the company admin again.',
            async function() {
                var data = await api('/api/super-admin/compliance/assignments/' + ccId + '/toggle-status', { method: 'PATCH' });
                if (data && data.success) {
                    toast('Assignment updated', 'success');
                    await loadCategoryDetails();
                } else {
                    toast(data ? (data.error || data.message) : 'Failed', 'error');
                }
            }
        );
    }

    async function removeCompany(companyId, companyName) {
        showConfirm(
            'Remove Company',
            'Remove "' + companyName + '" from this compliance category?',
            'This permanently deletes all configurations and employee assignments. This CANNOT be undone!',
            async function() {
                var data = await api(
                    '/api/super-admin/compliance/categories/' + CATEGORY_ID + '/companies/' + companyId,
                    { method: 'DELETE' }
                );
                if (data && data.success) {
                    toast('Company removed', 'success');
                    await loadCategoryDetails();
                } else {
                    toast(data ? (data.error || data.message) : 'Failed', 'error');
                }
            }
        );
    }

    async function toggleCategoryStatus() {
        var action = categoryData.isActive ? 'deactivate' : 'activate';
        showConfirm(
            'Toggle Category',
            'Are you sure you want to ' + action + ' "' + categoryData.name + '"?',
            categoryData.isActive
                ? 'Deactivating hides this category from all company admins.'
                : 'Activating makes this category visible to all assigned company admins.',
            async function() {
                var data = await api('/api/super-admin/compliance/templates/' + CATEGORY_ID + '/toggle-status', { method: 'PATCH' });
                if (data && data.success) {
                    toast('Category ' + action + 'd', 'success');
                    await loadCategoryDetails();
                } else {
                    toast(data ? (data.error || data.message) : 'Failed', 'error');
                }
            }
        );
    }

    // ==================== CONFIRM MODAL ====================
    function showConfirm(title, message, warning, onConfirm) {
        document.getElementById('confirmTitle').innerHTML = '<i class="fas fa-exclamation-triangle" style="color:var(--warning);margin-right:8px;"></i>' + title;
        document.getElementById('confirmMessage').textContent = message;
        var w = document.getElementById('confirmWarning');
        if (warning) {
            w.textContent = '⚠️ ' + warning;
            w.style.display = 'block';
        } else {
            w.style.display = 'none';
        }
        pendingAction = onConfirm;
        document.getElementById('confirmModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeConfirmModal() {
        pendingAction = null;
        document.getElementById('confirmModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    function executeConfirmAction() {
        if (pendingAction) {
            pendingAction();
            closeConfirmModal();
        }
    }

    // ==================== QUICK FILTERS ====================
    function scrollToCompanies() {
        document.getElementById('companiesGrid').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function filterByStatus(s) {
        document.getElementById('statusFilter').value = s;
        currentPage = 0;
        loadCompanies();
    }

    function filterByConfig(v) {
        document.getElementById('configFilter').value = v;
        currentPage = 0;
        loadCompanies();
    }

    function filterByAssignment(v) {
        document.getElementById('assignmentFilter').value = v;
        currentPage = 0;
        loadCompanies();
    }

    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('configFilter').value = '';
        document.getElementById('assignmentFilter').value = '';
        document.getElementById('sortBy').value = 'name';
        currentPage = 0;
        loadCompanies();
        toast('Filters reset', 'info');
    }

    function exportToCSV() {
        if (!allCompanies.length) {
            toast('No data to export', 'error');
            return;
        }
        var rows = [
            ['Company Name', 'Company Email', 'Assignment Status', 'Compliance Status', 'Configured', 'Assigned Date', 'Due Date', 'Notes']
        ];
        for (var i = 0; i < allCompanies.length; i++) {
            var c = allCompanies[i];
            rows.push([
                c.companyName,
                c.companyEmail,
                c.isActive !== false ? 'Active' : 'Inactive',
                getStatusLabel(c.complianceStatus),
                c.isConfigured ? 'Yes' : 'No',
                formatDate(c.assignedAt),
                c.dueDate ? formatDate(c.dueDate) : '',
                c.notes || ''
            ]);
        }
        var csv = rows.map(function(r) {
            return r.map(function(v) { return '"' + String(v).replace(/"/g, '""') + '"'; }).join(',');
        }).join('\n');
        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.setAttribute('download', 'compliance_' + (categoryData ? categoryData.name : 'category') + '_companies.csv');
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
        toast('Export complete', 'success');
    }

    function refreshData() {
        loadCategoryDetails();
        toast('Refreshed', 'info');
    }

    // ==================== CLOSE MODALS ON OVERLAY ====================
    document.getElementById('companyModal').addEventListener('click', function(e) {
        if (e.target === this) closeCompanyModal();
    });
    document.getElementById('historyModal').addEventListener('click', function(e) {
        if (e.target === this) closeHistoryModal();
    });
    document.getElementById('confirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeConfirmModal();
    });

    // ==================== LIVE FILTER LISTENERS ====================
    document.getElementById('searchInput').addEventListener('input', function() {
        currentPage = 0;
        loadCompanies();
    });
    document.getElementById('statusFilter').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
    });
    document.getElementById('configFilter').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
    });
    document.getElementById('assignmentFilter').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
    });
    document.getElementById('sortBy').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
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

        loadCategoryDetails();
        loadNotifications();
    });
</script>

</body>
</html>