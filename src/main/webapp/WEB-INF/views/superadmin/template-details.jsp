<%-- File: superadmin/template-details.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Long templateIdObj = (Long) request.getAttribute("templateId");
    String templateId = templateIdObj != null ? String.valueOf(templateIdObj) : null;

    if (templateId == null || templateId.trim().isEmpty()) {
        templateId = request.getParameter("id");
    }

    if (templateId == null || templateId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/super-admin/compliance/templates");
        return;
    }

    pageContext.setAttribute("templateId", templateId);
    pageContext.setAttribute("pageTitle", "Compliance Details");
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

        /* ==================== HERO HEADER ==================== */
        .hero-header {
            padding: 28px 32px;
            margin-bottom: 24px;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.05) 0%, rgba(79, 70, 229, 0.02) 100%);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .hero-header .hero-left {
            display: flex;
            align-items: center;
            gap: 20px;
            flex: 1;
            min-width: 0;
        }

       .hero-header .hero-left .hero-icon {
           width: 64px;
           height: 64px;
           min-width: 64px;
           border-radius: 50%;
           background: rgb(0 0 0);
           border: 1.5px solid rgba(79, 70, 229, 0.2);
           display: flex;
           align-items: center;
           justify-content: center;
           flex-shrink: 0;
       }

       .hero-header .hero-left .hero-icon i {
           color: #e9d80f;
           font-size: 28px;
       }

        .hero-header .hero-left .hero-info {
            min-width: 0;
        }

        .hero-header .hero-left .hero-info h1 {
            font-size: 26px;
            font-weight: 700;
            color: var(--gray-900);
            margin: 0;
        }

        .hero-header .hero-left .hero-info .description {
            color: var(--gray-500);
            font-size: 14px;
            margin: 4px 0 10px 0;
        }

        .hero-header .hero-left .hero-info .badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .hero-header .hero-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            flex-shrink: 0;
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

        /* ==================== STATS ==================== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card-mini {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 14px;
            transition: all 0.3s;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .stat-card-mini:hover {
            background: rgba(255, 255, 255, 0.9);
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        }

        .stat-card-mini .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .stat-card-mini .stat-number {
            font-family: 'Inter', sans-serif;
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
            line-height: 1.2;
        }

        .stat-card-mini .stat-label {
            font-size: 11px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ==================== SECTION ==================== */
        .section-card {
            padding: 20px;
            margin-bottom: 20px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            flex-wrap: wrap;
            gap: 10px;
        }

        .section-header .section-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-header .section-title i {
            color: var(--primary);
            font-size: 16px;
        }

        .section-header .section-title .badge-count {
            background: rgba(79, 70, 229, 0.12);
            color: var(--primary-light);
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 6px;
        }

        .section-header .section-actions {
            display: flex;
            gap: 8px;
        }

        /* ==================== CONFIG GRID ==================== */
        .config-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px;
        }

        .config-item {
            background: rgba(226, 232, 240, 0.12);
            padding: 12px 16px;
            border-radius: var(--radius);
        }

        .config-item .label {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .config-item .value {
            font-size: 14px;
            font-weight: 500;
            color: var(--gray-800);
            margin-top: 4px;
            word-break: break-word;
        }

        .config-item .value a {
            color: var(--primary);
            text-decoration: none;
        }

        .config-item .value a:hover {
            text-decoration: underline;
        }

        /* ==================== SUB-COMPLIANCE ==================== */
        .sub-grid {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .sub-card {
            background: rgba(226, 232, 240, 0.08);
            border: 1px solid rgba(226, 232, 240, 0.3);
            border-radius: var(--radius);
            padding: 14px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s;
            cursor: pointer;
        }

        .sub-card:hover {
            border-color: var(--primary-light);
            transform: translateX(4px);
            background: rgba(79, 70, 229, 0.04);
        }

        .sub-card .sub-left {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 0;
        }

        .sub-card .sub-left .order {
            font-size: 11px;
            color: var(--gray-500);
            font-weight: 600;
            min-width: 24px;
        }

        .sub-card .sub-left .info {
            min-width: 0;
        }

        .sub-card .sub-left .info h4 {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-800);
            margin: 0;
        }

        .sub-card .sub-left .info p {
            font-size: 12px;
            color: var(--gray-500);
            margin: 4px 0 8px 0;
            line-height: 1.5;
            white-space: pre-wrap;
            word-wrap: break-word;
            max-width: 78%;
        }

        .sub-card .sub-left .info .config-details {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 6px;
            font-size: 11px;
            color: var(--gray-500);
        }

        .sub-card .sub-left .info .config-details .due-warning { color: var(--warning); }
        .sub-card .sub-left .info .config-details .due-danger { color: var(--danger); font-weight: 600; }

        .sub-card .sub-right {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
        }

        /* ==================== COMPANIES GRID ==================== */
        .companies-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 14px;
        }

        .company-card {
            background: rgba(226, 232, 240, 0.06);
            border: 1px solid rgba(226, 232, 240, 0.3);
            border-radius: var(--radius);
            padding: 16px;
            transition: all 0.2s;
            position: relative;
        }

        .company-card:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .company-card .company-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .company-card .company-header .company-info {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .company-card .company-header .company-info .avatar {
            width: 44px;
            height: 44px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            color: white;
            flex-shrink: 0;
        }

        .company-card .company-header .company-info .avatar.blue { background: linear-gradient(135deg, var(--primary), var(--primary-light)); }
        .company-card .company-header .company-info .avatar.green { background: linear-gradient(135deg, var(--success), #4ade80); }
        .company-card .company-header .company-info .avatar.orange { background: linear-gradient(135deg, var(--warning), #fbbf24); }
        .company-card .company-header .company-info .avatar.red { background: linear-gradient(135deg, var(--danger), #f87171); }
        .company-card .company-header .company-info .avatar.purple { background: linear-gradient(135deg, #8b5cf6, #a78bfa); }

        .company-card .company-header .company-info .name {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-800);
        }

        .company-card .company-header .company-info .email {
            font-size: 11px;
            color: var(--gray-500);
        }

        .company-card .company-header .status-badge {
            font-size: 9px;
            padding: 3px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.3px;
            flex-shrink: 0;
        }

        .company-card .company-header .status-badge.completed {
            background: var(--success-bg);
            color: var(--success);
        }
        .company-card .company-header .status-badge.pending {
            background: var(--warning-bg);
            color: var(--warning);
        }
        .company-card .company-header .status-badge.overdue {
            background: var(--danger-bg);
            color: var(--danger);
            animation: pulse 1.5s infinite;
        }
        .company-card .company-header .status-badge.inprogress {
            background: var(--primary-bg);
            color: var(--primary);
        }

        .company-card .sub-list {
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px solid rgba(226, 232, 240, 0.3);
        }

        .company-card .sub-list .sub-label {
            font-size: 11px;
            color: var(--gray-500);
            margin-bottom: 8px;
        }

        .company-card .sub-list .sub-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 6px 10px;
            margin-bottom: 4px;
            background: rgba(226, 232, 240, 0.06);
            border-radius: 6px;
            border-left: 2px solid var(--primary);
            font-size: 12px;
        }

        .company-card .sub-list .sub-item .sub-name {
            font-weight: 500;
            color: var(--gray-800);
        }

        .company-card .sub-list .sub-item .sub-status {
            font-size: 10px;
            padding: 2px 8px;
            border-radius: 20px;
        }

        .company-card .sub-list .sub-item .sub-status.completed { background: var(--success-bg); color: var(--success); }
        .company-card .sub-list .sub-item .sub-status.overdue { background: var(--danger-bg); color: var(--danger); }
        .company-card .sub-list .sub-item .sub-status.pending { background: var(--warning-bg); color: var(--warning); }
        .company-card .sub-list .sub-item .sub-status.inprogress { background: var(--primary-bg); color: var(--primary); }

        .company-card .remove-btn {
            margin-top: 10px;
            text-align: right;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        /* ==================== LOADER ==================== */
        .loader-container {
            text-align: center;
            padding: 80px;
        }

        .loader-container .spinner {
            margin: 0 auto 16px;
        }

        .loader-container p {
            color: var(--gray-500);
            font-size: 14px;
        }

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

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 40px;
            color: var(--gray-500);
            grid-column: 1 / -1;
        }

        .empty-state i {
            font-size: 36px;
            opacity: 0.3;
            display: block;
            margin-bottom: 10px;
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

        .form-input::placeholder {
            color: var(--gray-400);
        }

        textarea.form-input {
            resize: vertical;
        }

        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
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

        .modal-box.wide {
            max-width: 750px;
        }

        .modal-box.small {
            max-width: 450px;
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
            flex-wrap: wrap;
        }

        .modal-footer .btn {
            flex: 0 1 auto;
        }

        .modal-info-box {
            margin-top: 16px;
            padding: 12px;
            background: rgba(79, 70, 229, 0.06);
            border-radius: var(--radius);
            font-size: 12px;
            color: var(--primary-light);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-info-box i {
            font-size: 14px;
        }

        .modal-danger-box {
            background: rgba(239, 68, 68, 0.08);
            border-left: 3px solid var(--danger);
            padding: 12px;
            margin: 12px 0;
            border-radius: 6px;
            font-size: 13px;
            color: var(--danger);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-warning-text {
            font-size: 12px;
            color: var(--warning);
            margin-top: 12px;
        }

        .modal-warning-text i {
            margin-right: 6px;
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
            .hero-header { flex-direction: column; align-items: flex-start; }
            .hero-header .hero-actions { width: 100%; }
            .hero-header .hero-actions .btn { flex: 1; justify-content: center; }
            .modal-box { max-width: 100%; margin: 10px; }
            .grid-2 { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }

            .stats-grid { grid-template-columns: 1fr 1fr; }
            .companies-grid { grid-template-columns: 1fr; }
            .config-grid { grid-template-columns: 1fr; }

            .sub-card { flex-direction: column; align-items: flex-start; gap: 10px; }
            .sub-card .sub-right { width: 100%; justify-content: flex-start; flex-wrap: wrap; }

            .hero-header .hero-left { flex-direction: column; align-items: flex-start; }
            .hero-header .hero-left .hero-info .badges { flex-wrap: wrap; }

            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .hero-header .hero-left .hero-info h1 { font-size: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
            .notification-dropdown { width: 280px; right: -80px; }
        }
    </style>
</head>
<body>

<!-- ==================== LOGO BACKGROUND ==================== -->
<div class="logo-bg">
    <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<!-- ==================== TOAST CONTAINER ==================== -->
<div id="toast-container"></div>

<!-- ==================== APP WRAPPER ==================== -->
<div class="app-wrapper">

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand">
                           <div class="brand-icon">

                               <img style="width:100%;" src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
                           </div>
                           <span class="brand-text">VNext Legal</span>
                           <span class="brand-badge">LLP</span>
        </div>

        <div class="sidebar-label">Main</div>
        <a href="${baseUrl}/super-admin/dashboard" class="nav-item">
            <i class="fas fa-chart-pie"></i> Dashboard
        </a>

        <div class="sidebar-label">Management</div>
        <a href="${baseUrl}/super-admin/companies" class="nav-item">
            <i class="fas fa-building"></i> Companies
        </a>

        <div class="sidebar-label">Compliance</div>
        <a href="${baseUrl}/super-admin/compliance/templates" class="nav-item active">
            <i class="fas fa-tags"></i> Categories
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${baseUrl}/super-admin/notifications" class="nav-item">
            <i class="fas fa-bell"></i> Notifications
        </a>

        <div class="sidebar-label">Account</div>
        <a href="${baseUrl}/change-password" class="nav-item">
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
            <span class="page-title">Compliance Details</span>
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
                        <a href="${baseUrl}/super-admin/notifications">View all notifications</a>
                    </div>
                </div>
            </div>

            <!-- User -->
            <div class="header-user" onclick="window.location.href='${baseUrl}/super-admin/profile'">
                <div class="avatar" id="userAvatar" style="width:32px;height:32px;font-size:12px;">U</div>
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
            <a href="${baseUrl}/super-admin/compliance/templates">
                <i class="fas fa-arrow-left"></i> Back to Categories
            </a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current" id="breadcrumbName">Loading...</span>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" class="loader-container">
            <div class="spinner"></div>
            <p>Loading compliance details...</p>
        </div>

        <!-- ==================== PAGE CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- ==================== HERO HEADER ==================== -->
            <div class="card hero-header">
                <div class="hero-left">
                    <div class="hero-icon">
                        <i class="fas fa-folder-open"></i>
                    </div>
                    <div class="hero-info">
                        <h1 id="templateName">—</h1>
                        <div class="description" id="templateDesc">—</div>
                        <div class="badges">
                            <span id="statusBadge"></span>
                            <span id="typeBadge"></span>
                            <span id="subCountBadge"></span>
                            <span id="configStatusBadge"></span>
                        </div>
                    </div>
                </div>
             <div class="hero-actions" id="heroActions">
                 <button onclick="openAddSubModal()" class="btn btn-primary" id="addSubBtn" style="display:none;">
                     <i class="fas fa-plus"></i> Add Sub-Compliance
                 </button>
                 <button onclick="configureParent()" class="btn btn-success" id="configureParentBtn" style="display:none;">
                     <i class="fas fa-cog"></i> Configure Parent
                 </button>
                 <button onclick="editParentConfig()" class="btn btn-primary" id="editParentConfigBtn" style="display:none;">
                     <i class="fas fa-edit"></i> Edit Configuration
                 </button>
                 <button onclick="assignToCompanies()" class="btn btn-warning" id="assignBtn" style="display:none;">
                     <i class="fas fa-users"></i> Assign to Companies
                 </button>
             </div>
            </div>

            <!-- ==================== STATS ==================== -->
            <div class="stats-grid">
                <div class="stat-card-mini">
                    <div class="stat-icon" style="background:rgba(79,70,229,0.12);color:var(--primary);">
                        <i class="fas fa-building"></i>
                    </div>
                    <div>
                        <div class="stat-number" id="assignedCompaniesCount">0</div>
                        <div class="stat-label">Assigned Companies</div>
                    </div>
                </div>
                <div class="stat-card-mini">
                    <div class="stat-icon" style="background:rgba(16,185,129,0.12);color:var(--success);">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div>
                        <div class="stat-number" id="configuredCount">0</div>
                        <div class="stat-label">Configured</div>
                    </div>
                </div>
                <div class="stat-card-mini">
                    <div class="stat-icon" style="background:rgba(245,158,11,0.12);color:var(--warning);">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <div class="stat-number" id="pendingCount">0</div>
                        <div class="stat-label">Pending Config</div>
                    </div>
                </div>
                <div class="stat-card-mini">
                    <div class="stat-icon" style="background:rgba(79,70,229,0.12);color:var(--primary);">
                        <i class="fas fa-sitemap"></i>
                    </div>
                    <div>
                        <div class="stat-number" id="subCompliancesCount">0</div>
                        <div class="stat-label">Sub-Compliances</div>
                    </div>
                </div>
            </div>

            <!-- ==================== CONFIG SECTION ==================== -->
            <div id="configSection" class="card section-card" style="display:none;">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-cog"></i> Configuration Details
                    </div>
                    <div class="section-actions">
                        <button onclick="editParentConfig()" class="btn btn-ghost btn-sm">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                    </div>
                </div>
                <div id="configDetails" class="config-grid"></div>
            </div>

            <!-- ==================== SUB-COMPLIANCES SECTION ==================== -->
            <div id="subSection" class="card section-card" style="display:none;">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-sitemap"></i> Sub-Compliances
                        <span id="subCount" class="badge-count">0</span>
                    </div>
                    <button onclick="openAddSubModal()" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Add Sub-Compliance
                    </button>
                </div>
                <div id="subGrid" class="sub-grid">
                    <div class="empty-state"><i class="fas fa-spinner fa-spin"></i> Loading sub-compliances...</div>
                </div>
            </div>

            <!-- ==================== ASSIGNED COMPANIES SECTION ==================== -->
            <div class="card section-card">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-building"></i> Assigned Companies
                        <span id="companyCount" class="badge-count">0</span>
                    </div>
                    <div class="section-actions">
                        <button onclick="refreshAssignedCompanies()" class="btn btn-ghost btn-sm">
                            <i class="fas fa-sync-alt"></i> Refresh
                        </button>
                    </div>
                </div>
                <div id="companiesGrid" class="companies-grid">
                    <div class="empty-state"><i class="fas fa-spinner fa-spin"></i> Loading companies...</div>
                </div>
            </div>

        </div>

    </main>
</div>

<!-- ==================== ADD/EDIT SUB-COMPLIANCE MODAL ==================== -->
<div id="subModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="subModalTitle"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add Sub-Compliance</div>
                <div class="modal-subtitle" id="subModalSubtitle">Create a sub-compliance under this category</div>
            </div>
            <button class="modal-close" onclick="closeSubModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="subForm" onsubmit="return false;">
                <input type="hidden" id="subId">
                <div style="margin-bottom:16px;">
                    <label class="form-label">Sub-Compliance Name <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="subName" class="form-input" placeholder="e.g., GST 1, TDS Return" required>
                </div>
                <div style="margin-bottom:16px;">
                    <label class="form-label">Description</label>
                    <textarea id="subDescription" class="form-input" rows="3" placeholder="Describe this sub-compliance..."></textarea>
                </div>
                <div>
                    <label class="form-label">Display Order</label>
                    <input type="number" id="subDisplayOrder" class="form-input" value="0" min="0">
                    <div style="font-size:11px;color:var(--gray-500);margin-top:4px;">Lower numbers appear first</div>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeSubModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveSubCompliance()" class="btn btn-primary" id="subSaveBtn">
                <i class="fas fa-save"></i> Save
            </button>
        </div>
    </div>
</div>

<!-- ==================== CONFIGURE MODAL ==================== -->
<div id="configModal" class="modal-overlay">
    <div class="modal-box wide">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="configModalTitle"><i class="fas fa-cog" style="color:var(--primary);margin-right:8px;"></i>Configure Compliance</div>
                <div class="modal-subtitle" id="configModalSubtitle">Set frequency, due date, and reminders</div>
            </div>
            <button class="modal-close" onclick="closeConfigModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="configForm" onsubmit="return false;">
                <input type="hidden" id="configTargetId">
                <input type="hidden" id="configTargetType">

                <div style="margin-bottom:16px;">
                    <label class="form-label">Frequency</label>
                   <select id="configFrequency" class="form-input">
                       <option value="">None</option>
                       <option value="ONE_TIME">One Time</option>
                       <option value="MONTHLY">Monthly</option>
                       <option value="QUARTERLY">Quarterly</option>
                       <option value="HALF_YEARLY">Half Yearly</option>
                       <option value="YEARLY">Yearly</option>
                   </select>
                </div>

                <div id="configDueDateSection" style="margin-bottom:16px;">
                    <label class="form-label">Due Date</label>
                    <input type="date" id="configDueDate" class="form-input">
                </div>

                <div id="configMonthlySection" style="display:none;margin-bottom:16px;">
                    <label class="form-label">Day of Month</label>
                    <select id="configDueDayOfMonth" class="form-input">
                        <% for(int d=1; d<=31; d++) { %>
                            <option value="<%=d%>"><%=d%></option>
                        <% } %>
                    </select>
                </div>

                <div id="configQuarterlySection" style="display:none;margin-bottom:16px;">
                    <div class="grid-2">
                        <div>
                            <label class="form-label">Quarter</label>
                            <select id="configDueQuarter" class="form-input">
                               <option value="1">Q1 (Apr-Jun)</option>
                               <option value="2">Q2 (Jul-Sep)</option>
                               <option value="3">Q3 (Oct-Dec)</option>
                               <option value="4">Q4 (Jan-Mar)</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">Day of Month</label>
                            <select id="configDueDayOfMonthQ" class="form-input">
                                <% for(int d=1; d<=31; d++) { %>
                                    <option value="<%=d%>"><%=d%></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div id="configHalfYearlySection" style="display:none;margin-bottom:16px;">
                    <div class="grid-2">
                        <div>
                            <label class="form-label">Half Year</label>
                            <select id="configDueHalf" class="form-input">
                                <option value="1">First Half (Jan-Jun)</option>
                                <option value="2">Second Half (Jul-Dec)</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">Day of Month</label>
                            <select id="configDueDayOfMonthH" class="form-input">
                                <% for(int d=1; d<=31; d++) { %>
                                    <option value="<%=d%>"><%=d%></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div id="configYearlySection" style="display:none;margin-bottom:16px;">
                    <div class="grid-2">
                        <div>
                            <label class="form-label">Month</label>
                            <select id="configDueMonth" class="form-input">
                                <option value="1">January</option>
                                <option value="2">February</option>
                                <option value="3">March</option>
                                <option value="4">April</option>
                                <option value="5">May</option>
                                <option value="6">June</option>
                                <option value="7">July</option>
                                <option value="8">August</option>
                                <option value="9">September</option>
                                <option value="10">October</option>
                                <option value="11">November</option>
                                <option value="12">December</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">Day of Month</label>
                            <select id="configDueDayOfMonthY" class="form-input">
                                <% for(int d=1; d<=31; d++) { %>
                                    <option value="<%=d%>"><%=d%></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom:16px;">
                    <label class="form-label">Reminder Days Before</label>
                    <select id="configReminderDays" class="form-input">
                        <option value="1">1 day before</option>
                        <option value="3">3 days before</option>
                        <option value="5">5 days before</option>
                        <option value="7">7 days before</option>
                        <option value="10" selected>10 days before</option>
                        <option value="14">14 days before</option>
                        <option value="21">21 days before</option>
                        <option value="30">30 days before</option>
                    </select>
                </div>

                <div style="margin-bottom:16px;">
                    <label class="form-label">Repeat Reminder Until Completed</label>
                    <select id="configRepeatReminder" class="form-input">
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>

                <div id="configIntervalSection" style="margin-bottom:16px;">
                    <label class="form-label">Repeat Interval (Days)</label>
                    <select id="configReminderIntervalDays" class="form-input">
                        <option value="1">Every day</option>
                        <option value="2">Every 2 days</option>
                        <option value="3" selected>Every 3 days</option>
                        <option value="5">Every 5 days</option>
                        <option value="7">Every week</option>
                    </select>
                </div>

                <div style="margin-bottom:16px;">
                    <label class="form-label">Instructions for Employees</label>
                    <textarea id="configInstructions" class="form-input" rows="4" placeholder="Step-by-step instructions..."></textarea>
                </div>

                <div style="margin-bottom:16px;">
                    <label class="form-label">Required Documents</label>
                    <input type="text" id="configDocumentRequired" class="form-input" placeholder="e.g., Certificate, Receipt">
                </div>

                <div style="margin-bottom:16px;">
                    <label class="form-label">External Portal Link (Optional)</label>
                    <input type="url" id="configExternalLink" class="form-input" placeholder="https://example.gov.in">
                </div>

                <div class="modal-info-box">
                    <i class="fas fa-check-circle"></i> After configuration, this compliance will be <strong>auto-assigned</strong> to all active companies.
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeConfigModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveConfig()" class="btn btn-success" id="configSaveBtn">
                <i class="fas fa-cog"></i> Configure & Auto-Assign
            </button>
        </div>
    </div>
</div>

<!-- ==================== DELETE SUB-COMPLIANCE MODAL ==================== -->
<div id="deleteSubModal" class="modal-overlay">
    <div class="modal-box small">
        <div class="modal-header">
            <div>
                <div class="modal-title" style="color:var(--danger);"><i class="fas fa-exclamation-triangle" style="margin-right:8px;"></i>Delete Sub-Compliance</div>
                <div class="modal-subtitle">This action cannot be undone</div>
            </div>
            <button class="modal-close" onclick="closeDeleteSubModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to permanently delete <strong id="deleteSubName"></strong>?</p>
            <div id="deleteSubWarning" class="modal-danger-box" style="display:none;">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="deleteSubWarningText"></span>
            </div>
            <div class="modal-warning-text">
                <i class="fas fa-skull-crosswalk"></i> This action CANNOT be undone!
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeDeleteSubModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmDeleteSub()" class="btn btn-danger">Delete Permanently</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var TEMPLATE_ID = "${templateId}";
    var templateData = null;
    var subCompliances = [];
    var assignedCompanies = [];
    var parentConfig = null;
    var pendingDeleteSubId = null;
    var editingSubId = null;

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
        if (!d) return "—";
        try {
            var date = new Date(d);
            if (isNaN(date.getTime())) return "—";
            return date.toLocaleDateString("en-IN", {
                day: "2-digit",
                month: "short",
                year: "numeric"
            });
        } catch (e) {
            return "—";
        }
    }

    function formatDateTime(d) {
        if (!d) return '—';
        try {
            var date = new Date(d);
            if (isNaN(date.getTime())) return '—';
            return date.toLocaleString('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
        } catch(e) {
            return '—';
        }
    }

   function getFrequencyLabel(freq) {
       if (!freq) return "None";
       var map = {
           "ONE_TIME": "One Time",
           "MONTHLY": "Monthly",
           "QUARTERLY": "Quarterly",
           "HALF_YEARLY": "Half Yearly",
           "YEARLY": "Yearly"
       };
       return map[freq] || freq;
   }

    function getStatusLabel(status) {
        var map = {
            'PENDING': 'Pending',
            'IN_PROGRESS': 'In Progress',
            'COMPLETED': 'Completed',
            'OVERDUE': 'Overdue',
            'EXEMPTED': 'Exempted'
        };
        return map[status] || status || '—';
    }

    function getStatusClass(status) {
        var map = {
            'PENDING': 'badge-pending',
            'IN_PROGRESS': 'badge-info',
            'COMPLETED': 'badge-active',
            'OVERDUE': 'badge-danger',
            'EXEMPTED': 'badge-info'
        };
        return map[status] || 'badge-info';
    }

    function getCompanyStatusClass(status) {
        var map = {
            'COMPLETED': 'completed',
            'PENDING': 'pending',
            'OVERDUE': 'overdue',
            'IN_PROGRESS': 'inprogress'
        };
        return map[status] || 'pending';
    }

    function getAvatarColor(name) {
        var colors = ['blue', 'green', 'orange', 'red', 'purple'];
        var index = (name || '').length % colors.length;
        return colors[index] || 'blue';
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

    // ==================== LOAD TEMPLATE DETAILS ====================
   async function loadTemplateDetails() {
       console.log('Loading template details for ID:', TEMPLATE_ID);

       try {
           var data = await api('/api/super-admin/compliance/templates/' + TEMPLATE_ID);
           console.log('Template data:', data);

           if (data && data.success) {
               templateData = data.data;

               document.getElementById('breadcrumbName').textContent = templateData.name;
               document.getElementById('templateName').textContent = templateData.name;
               document.getElementById('templateDesc').textContent = templateData.description || 'No description provided.';

               // ===== UPDATE HERO ICON =====
               var heroIcon = document.querySelector('.hero-icon i');
               if (heroIcon) {
                   var iconClass = getComplianceIcon(templateData.name);
                   heroIcon.className = 'fas ' + iconClass;
               }

               var statusClass = templateData.isActive ? 'badge-active' : 'badge-inactive';
               document.getElementById('statusBadge').innerHTML = '<span class="badge ' + statusClass + '"><i class="fas fa-circle" style="font-size:5px;margin-right:4px;"></i> ' + (templateData.isActive ? 'Active' : 'Inactive') + '</span>';

               var typeLabel = templateData.isCompanySpecific ? 'Company Specific' : 'Global';
               document.getElementById('typeBadge').innerHTML = '<span class="badge badge-info"><i class="fas fa-globe"></i> ' + typeLabel + '</span>';

               await Promise.all([
                   loadSubCompliances(),
                   loadParentConfig(),
                   loadAssignedCompanies()
               ]);

               document.getElementById('loader').style.display = 'none';
               document.getElementById('pageContent').style.display = 'block';
               console.log('Page loaded successfully');
           } else {
               toast('Failed to load template details', 'error');
           }
       } catch (error) {
           console.error('Error loading template:', error);
           toast('Error loading template details', 'error');
       }
   }

 async function loadSubCompliances() {
     console.log('Loading sub-compliances for parent:', TEMPLATE_ID);

     try {
         var data = await api('/api/super-admin/compliance/sub-templates?parentId=' + TEMPLATE_ID);
         console.log('Sub-compliances data:', data);

         if (data && data.success) {
             subCompliances = data.data || [];
             console.log('Loaded ' + subCompliances.length + ' sub-compliances');

             // Check if each sub-compliance is configured
             for (var i = 0; i < subCompliances.length; i++) {
                 // ===== Ensure displayOrder is preserved =====
                 // The API already returns displayOrder in the DTO
                 console.log('Sub-compliance:', subCompliances[i].name, 'Display Order:', subCompliances[i].displayOrder);

                 try {
                     var configData = await api('/api/super-admin/compliance/sub-templates/' + subCompliances[i].id + '/config');
                     if (configData && configData.success && configData.data) {
                         subCompliances[i].isConfigured = true;
                         subCompliances[i].configDetails = configData.data;
                     } else {
                         subCompliances[i].isConfigured = false;
                         subCompliances[i].configDetails = null;
                     }
                 } catch (e) {
                     subCompliances[i].isConfigured = false;
                     subCompliances[i].configDetails = null;
                 }
             }

             renderSubCompliances();
             updateUI();
         }
     } catch (error) {
         console.error('Error loading sub-compliances:', error);
     }
 }

    // ==================== LOAD PARENT CONFIG ====================
    async function loadParentConfig() {
        console.log('Loading parent config for template:', TEMPLATE_ID);

        try {
            var data = await api('/api/super-admin/compliance/config?templateId=' + TEMPLATE_ID);
            console.log('Parent config response:', data);

            if (data && data.success && data.data) {
                parentConfig = data.data;
                console.log('Parent config found:', parentConfig);
                renderParentConfig();
                document.getElementById('configSection').style.display = 'block';
                document.getElementById('editParentConfigBtn').style.display = 'inline-flex';
                document.getElementById('configureParentBtn').style.display = 'none';
            } else {
                parentConfig = null;
                document.getElementById('configSection').style.display = 'none';
                document.getElementById('editParentConfigBtn').style.display = 'none';
                document.getElementById('configureParentBtn').style.display = 'inline-flex';
            }
            updateUI();
        } catch (error) {
            console.error('Error loading parent config:', error);
            parentConfig = null;
            updateUI();
        }
    }


    async function assignToCompanies() {
        if (!confirm('Are you sure you want to assign this compliance to all active companies?')) return;

        try {
            var data = await api('/api/super-admin/compliance/templates/' + TEMPLATE_ID + '/assign-to-companies', {
                method: 'POST'
            });

            if (data && data.success) {
                toast('Compliance assigned to all active companies successfully!', 'success');
                await loadAssignedCompanies();
                updateUI();
            } else {
                toast(data?.error || 'Assignment failed', 'error');
            }
        } catch (error) {
            console.error('Error assigning to companies:', error);
            toast('Failed to assign to companies', 'error');
        }
    }

   // ==================== LOAD ASSIGNED COMPANIES ====================
   async function loadAssignedCompanies() {
       console.log('Loading assigned companies for template:', TEMPLATE_ID);

       try {
           var data = await api('/api/super-admin/compliance/assignments?page=0&size=100&templateId=' + TEMPLATE_ID);
           console.log('Assigned companies response:', data);

           if (data && data.success) {
               var allAssignments = data.data.content || [];

               // ===== FIX: Count unique companies =====
               var uniqueCompanyIds = new Set();
               for (var i = 0; i < allAssignments.length; i++) {
                   if (allAssignments[i].companyId) {
                       uniqueCompanyIds.add(allAssignments[i].companyId);
                   }
               }

               var uniqueCompaniesCount = uniqueCompanyIds.size;
               console.log('Unique companies count:', uniqueCompaniesCount, 'Total assignments:', allAssignments.length);

               // Store assignments for rendering
               assignedCompanies = allAssignments;

               // Update the count display
               document.getElementById("assignedCompaniesCount").textContent = uniqueCompaniesCount;
               document.getElementById("companyCount").textContent = uniqueCompaniesCount;

               renderAssignedCompanies();
               updateUI();
           }
       } catch (error) {
           console.error('Error loading assigned companies:', error);
           document.getElementById('companiesGrid').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i> Failed to load companies</div>';
       }
   }

    // ==================== UPDATE UI ====================
    function updateUI() {
        var hasSubs = subCompliances.length > 0;
        var hasConfig = parentConfig !== null;
        var hasAssignments = assignedCompanies.length > 0;
        var isEditable = templateData && templateData.editableForCompanies === true;

        var addSubBtn = document.getElementById("addSubBtn");
        var configureBtn = document.getElementById("configureParentBtn");
        var editConfigBtn = document.getElementById("editParentConfigBtn");
        var assignBtn = document.getElementById("assignBtn");
        var configSection = document.getElementById("configSection");
        var subSection = document.getElementById("subSection");

        // ---- Count unique companies (for stats) ----
        var uniqueCompanyIds = new Set();
        for (var i = 0; i < assignedCompanies.length; i++) {
            if (assignedCompanies[i].companyId) {
                uniqueCompanyIds.add(assignedCompanies[i].companyId);
            }
        }
        var uniqueCompaniesCount = uniqueCompanyIds.size;

        // ---- Update badges and counts ----
        document.getElementById("subCountBadge").innerHTML =
            '<span class="badge badge-info"><i class="fas fa-sitemap"></i> ' +
            subCompliances.length + " sub(s)</span>";
        document.getElementById("subCompliancesCount").textContent = subCompliances.length;

        // ---- Config status badge ----
        if (hasSubs) {
            var anyConfigured = subCompliances.some(function (s) { return s.isConfigured === true; });
            var allConfigured = subCompliances.every(function (s) { return s.isConfigured === true; });

            if (allConfigured && subCompliances.length > 0) {
                document.getElementById("configStatusBadge").innerHTML =
                    '<span class="badge badge-active"><i class="fas fa-check"></i> All Configured</span>';
            } else if (anyConfigured) {
                document.getElementById("configStatusBadge").innerHTML =
                    '<span class="badge badge-pending" style="background:rgba(245,158,11,0.15);color:var(--warning);"><i class="fas fa-clock"></i> Partially Configured</span>';
            } else {
                document.getElementById("configStatusBadge").innerHTML =
                    '<span class="badge badge-pending"><i class="fas fa-clock"></i> Pending Configuration</span>';
            }
        } else if (hasConfig) {
            document.getElementById("configStatusBadge").innerHTML =
                '<span class="badge badge-active"><i class="fas fa-check"></i> Configured</span>';
        } else {
            document.getElementById("configStatusBadge").innerHTML =
                '<span class="badge badge-pending"><i class="fas fa-clock"></i> Not Configured</span>';
        }

        // ---- Stats ----
        document.getElementById("assignedCompaniesCount").textContent = uniqueCompaniesCount;
        document.getElementById("companyCount").textContent = uniqueCompaniesCount;

        var configured = 0, pending = 0;
        if (uniqueCompaniesCount > 0) {
            var companyIds = Array.from(uniqueCompanyIds);
            for (var i = 0; i < companyIds.length; i++) {
                var companyAssignments = assignedCompanies.filter(function(a) {
                    return a.companyId === companyIds[i];
                });
                var hasConfigured = companyAssignments.some(function(a) {
                    return a.configured === true;
                });
                if (hasConfigured) configured++;
                else pending++;
            }
        }
        document.getElementById("configuredCount").textContent = configured;
        document.getElementById("pendingCount").textContent = pending;

        // ---- Now handle visibility based on editable flag ----
        if (isEditable) {
            // ---- Editable compliance ----
            // SuperAdmin cannot add sub‑compliances, configure, or edit config
            addSubBtn.style.display = "none";
            configureBtn.style.display = "none";
            editConfigBtn.style.display = "none";

            // Assign button: show only if not yet assigned to any company
            assignBtn.style.display = (uniqueCompaniesCount > 0) ? "none" : "inline-flex";
            if (assignBtn.style.display !== "none") {
                assignBtn.innerHTML = '<i class="fas fa-users"></i> Assign to Companies';
            }

            // Hide parent config section entirely
            configSection.style.display = "none";

            // Show sub‑section only if there are sub‑compliances (created by companies)
            subSection.style.display = hasSubs ? "block" : "none";

            // We exit early because all other logic is for non‑editable
            return;
        }

        // ---- Non‑editable compliance (original logic) ----
        if (hasSubs) {
            configureBtn.style.display = "none";
            editConfigBtn.style.display = "none";
            subSection.style.display = "block";
            configSection.style.display = "none";
            addSubBtn.style.display = "inline-flex";
        } else if (hasConfig) {
            configureBtn.style.display = "none";
            editConfigBtn.style.display = "inline-flex";
            subSection.style.display = "none";
            configSection.style.display = "block";
            addSubBtn.style.display = "inline-flex";
        } else {
            configureBtn.style.display = "inline-flex";
            editConfigBtn.style.display = "none";
            subSection.style.display = "none";
            configSection.style.display = "none";
            addSubBtn.style.display = "inline-flex";
        }

        // Assign button for non‑editable
        if (hasAssignments) {
            assignBtn.style.display = "none";
        } else if (hasSubs) {
            var anyConfiguredSub = subCompliances.some(function (s) { return s.isConfigured === true; });
            if (anyConfiguredSub) {
                assignBtn.style.display = "inline-flex";
                assignBtn.innerHTML = '<i class="fas fa-users"></i> Assign to Companies';
            } else {
                assignBtn.style.display = "none";
            }
        } else if (hasConfig) {
            assignBtn.style.display = "inline-flex";
            assignBtn.innerHTML = '<i class="fas fa-users"></i> Assign to Companies';
        } else {
            assignBtn.style.display = "none";
        }
    }





    // ==================== RENDER PARENT CONFIG ====================
   function renderParentConfig() {
       if (!parentConfig) return;

       var c = parentConfig;
       var html = "";

       html +=
           '<div class="config-item"><div class="label">Frequency</div><div class="value">' +
           getFrequencyLabel(c.frequency) +
           "</div></div>";

       // Due date display
       var dueDateDisplay = "No due date";
       if (c.frequency) {
           if (c.effectiveDueDate) {
               dueDateDisplay = formatDate(c.effectiveDueDate);
           } else if (c.customDueDate) {
               dueDateDisplay = formatDate(c.customDueDate);
           }
       }
       html +=
           '<div class="config-item"><div class="label">Due Date</div><div class="value">' +
           dueDateDisplay +
           "</div></div>";

       html +=
           '<div class="config-item"><div class="label">Reminder</div><div class="value">' +
           (c.reminderDaysBefore ? c.reminderDaysBefore + " days before" : "None") +
           "</div></div>";

       html +=
           '<div class="config-item"><div class="label">Repeat Reminder</div><div class="value">' +
           (c.repeatReminder !== false && c.repeatReminder != null ? "Yes" : "No") +
           "</div></div>";

       if (c.instructions) {
           html +=
               '<div class="config-item" style="grid-column:1/-1;"><div class="label">Instructions</div><div class="value" style="white-space:pre-line;font-size:13px;">' +
               escapeHtml(c.instructions) +
               "</div></div>";
       }
       if (c.documentRequired) {
           html +=
               '<div class="config-item"><div class="label">Required Documents</div><div class="value"><i class="fas fa-file-alt" style="color:var(--primary);"></i> ' +
               escapeHtml(c.documentRequired) +
               "</div></div>";
       }
       if (c.externalLink) {
           html +=
               '<div class="config-item"><div class="label">External Portal</div><div class="value"><a href="' +
               escapeHtml(c.externalLink) +
               '" target="_blank"><i class="fas fa-external-link-alt"></i> Open Portal</a></div></div>';
       }

       document.getElementById("configDetails").innerHTML = html;
       document.getElementById("configSection").style.display = "block";
   }

    // ==================== RENDER SUB-COMPLIANCES ====================

    // ==================== RENDER SUB-COMPLIANCES ====================
    function renderSubCompliances() {
        var container = document.getElementById("subGrid");

        if (!subCompliances.length) {
            container.innerHTML =
                '<div class="empty-state"><i class="fas fa-plus-circle"></i> No sub-compliances created yet. Click "Add Sub-Compliance" to create one.</div>';
            return;
        }

        // ===== FIX: Sort sub-compliances by display order =====
        var sortedSubs = [...subCompliances].sort(function(a, b) {
            var orderA = a.displayOrder || 0;
            var orderB = b.displayOrder || 0;
            if (orderA !== orderB) {
                return orderA - orderB;
            }
            // If same order, sort by name
            return a.name.localeCompare(b.name);
        });

        var html = "";
        for (var i = 0; i < sortedSubs.length; i++) {
            var s = sortedSubs[i];
            var isActive = s.isActive !== false;
            var isConfigured = s.isConfigured || false;
            var configDetails = s.configDetails || {};

            var statusClass = isActive ? "badge-active" : "badge-inactive";
            var statusText = isActive ? "Active" : "Inactive";
            var configClass = isConfigured ? "badge-active" : "badge-pending";
            var configText = isConfigured ? "Configured" : "Pending";

            // Build config details display
            var configHtml = "";
            if (isConfigured && configDetails) {
                var freq = getFrequencyLabel(configDetails.frequency);

                // Due date display
                var due = "No due date";
                if (configDetails.frequency) {
                    if (configDetails.effectiveDueDate) {
                        due = formatDate(configDetails.effectiveDueDate);
                    } else if (configDetails.customDueDate) {
                        due = formatDate(configDetails.customDueDate);
                    }
                }

                var reminder = (configDetails.reminderDaysBefore ? configDetails.reminderDaysBefore + " days before" : "None");

                var dueClass = "";
                if (due !== "No due date") {
                    var dueDateObj = new Date(due);
                    if (!isNaN(dueDateObj.getTime())) {
                        var diffDays = Math.ceil((dueDateObj - new Date()) / (1000 * 60 * 60 * 24));
                        if (diffDays < 0) dueClass = "due-danger";
                        else if (diffDays <= 7) dueClass = "due-warning";
                    }
                }

                configHtml =
                    '<div class="config-details">' +
                    (freq !== "None" ? '<span><i class="fas fa-redo" style="color:var(--primary);"></i> ' + freq + "</span>" : "") +
                    '<span class="' + dueClass + '"><i class="fas fa-calendar-alt" style="color:var(--primary);"></i> Due: ' + due + "</span>" +
                    (reminder !== "None" ? '<span><i class="fas fa-bell" style="color:var(--primary);"></i> Reminder: ' + reminder + "</span>" : "") +
                    "</div>";

                // ADD EXTERNAL LINK DISPLAY
                if (configDetails.externalLink) {
                    configHtml +=
                        '<div style="margin-top:6px;font-size:12px;color:var(--primary);">' +
                        '<i class="fas fa-external-link-alt"></i> <a href="' + escapeHtml(configDetails.externalLink) +
                        '" target="_blank" style="color:var(--primary);text-decoration:underline;word-break:break-all;">' +
                        escapeHtml(configDetails.externalLink) +
                        '</a>' +
                        '</div>';
                }

                if (configDetails.instructions) {
                    configHtml +=
                        '<div style="margin-top:4px;font-size:11px;color:var(--gray-500);width:78%;">' +
                        '<i class="fas fa-info-circle" style="color:var(--primary);"></i> ' +
                        escapeHtml(configDetails.instructions) +
                        "</div>";
                }
            } else {
                configHtml =
                    '<div style="margin-top:6px;font-size:11px;color:var(--warning);">' +
                    '<i class="fas fa-clock"></i> Not configured yet. Click "Configure" to set up.' +
                    "</div>";
            }

            html +=
                '<div class="sub-card">' +
                '<div class="sub-left" onclick="editSubCompliance(' + s.id + ')">' +
                '<span class="order">#' + (i + 1) + "</span>" +
                '<div class="info">' +
                "<h4>" + escapeHtml(s.name) + "</h4>" +
                '<p style="white-space:pre-wrap;word-wrap:break-word;max-width:78%;">' +
                (s.description ? escapeHtml(s.description).replace(/\n/g, "<br>") : "No description") +
                "</p>" +
                configHtml +
                "</div>" +
                "</div>" +
                '<div class="sub-right">' +
                '<span class="badge ' + statusClass + '" style="font-size:10px;">' + statusText + "</span>" +
                '<span class="badge ' + configClass + '" style="font-size:10px;">' + configText + "</span>" +
                (isConfigured ?
                    '<button onclick="editConfig(' + s.id + ')" class="btn btn-ghost btn-sm" title="Edit Configuration"><i class="fas fa-edit"></i></button>' :
                    '<button onclick="openConfigModal(' + s.id + ', \'sub\')" class="btn btn-success btn-sm" title="Configure"><i class="fas fa-cog"></i></button>') +
                '<button onclick="toggleSubStatus(' + s.id + ', ' + isActive + ')" class="btn ' + (isActive ? "btn-warning" : "btn-success") + ' btn-sm" title="Toggle Status"><i class="fas ' + (isActive ? "fa-pause" : "fa-play") + '"></i></button>' +
                '<button onclick="openDeleteSubModal(' + s.id + ", '" + escapeHtml(s.name) + "', " + isConfigured + ')" class="btn btn-danger btn-sm" title="Delete"><i class="fas fa-trash"></i></button>' +
                "</div>" +
                "</div>";
        }
        container.innerHTML = html;
    }


    // ==================== RENDER ASSIGNED COMPANIES ====================
    function renderAssignedCompanies() {
        var container = document.getElementById("companiesGrid");

        var companyMap = {};
        for (var i = 0; i < assignedCompanies.length; i++) {
            var c = assignedCompanies[i];
            var key = c.companyId;
            if (!companyMap[key]) {
                companyMap[key] = {
                    companyId: c.companyId,
                    companyName: c.companyName || "Unknown Company",
                    companyEmail: c.companyEmail || "",
                    parentAssignment: null,
                    subAssignments: []
                };
            }
            // ---- FIX: use subTemplateId ----
            if (c.subTemplateId == null) {
                companyMap[key].parentAssignment = c;
            } else {
                companyMap[key].subAssignments.push(c);
            }
        }

        var uniqueList = Object.values(companyMap);

        // Update counts
        document.getElementById("assignedCompaniesCount").textContent = uniqueList.length;
        document.getElementById("companyCount").textContent = uniqueList.length;

        var configured = 0, pending = 0;
        for (var i = 0; i < uniqueList.length; i++) {
            var hasConfiguredSub = uniqueList[i].subAssignments.some(function(a) { return a.configured === true; });
            if (hasConfiguredSub) configured++;
            else pending++;
        }
        document.getElementById("configuredCount").textContent = configured;
        document.getElementById("pendingCount").textContent = pending;

        if (!uniqueList.length) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-building"></i> No companies assigned yet.</div>';
            return;
        }

        var html = "";
        var today = new Date();
        today.setHours(0, 0, 0, 0);

        for (var i = 0; i < uniqueList.length; i++) {
            var comp = uniqueList[i];
            var companyName = comp.companyName;
            var companyEmail = comp.companyEmail;
            var avatarColor = getAvatarColor(companyName);
            var initials = companyName.charAt(0).toUpperCase();

            // Determine overall status (fallback to parent status)
            var overallStatus = "PENDING";
            var parent = comp.parentAssignment;
            if (parent) {
                overallStatus = parent.status || "PENDING";
                if (parent.dueDate && overallStatus !== "COMPLETED") {
                    var due = new Date(parent.dueDate);
                    due.setHours(0,0,0,0);
                    if (due < today) overallStatus = "OVERDUE";
                }
            }

            var subs = comp.subAssignments;
            if (subs.length > 0) {
                var allCompleted = subs.every(function(s) { return s.status === "COMPLETED"; });
                var anyOverdue = subs.some(function(s) { return s.status === "OVERDUE" && s.status !== "COMPLETED"; });
                var anyInProgress = subs.some(function(s) { return s.status === "IN_PROGRESS"; });
                if (allCompleted) overallStatus = "COMPLETED";
                else if (anyOverdue) overallStatus = "OVERDUE";
                else if (anyInProgress) overallStatus = "IN_PROGRESS";
                else overallStatus = "PENDING";
            }

            var statusClass = getCompanyStatusClass(overallStatus);
            var statusLabel = getStatusLabel(overallStatus);

            html +=
                '<div class="company-card" style="border-left:3px solid ' +
                (overallStatus === "COMPLETED" ? "var(--success)" :
                    overallStatus === "OVERDUE" ? "var(--danger)" : "var(--primary)") +
                ';">' +
                '<div class="company-header">' +
                '<div class="company-info">' +
                '<div class="avatar ' + avatarColor + '">' + initials + "</div>" +
                '<div style="min-width:0;">' +
                '<div class="name">' + escapeHtml(companyName) + "</div>" +
                '<div class="email">' + escapeHtml(companyEmail) + "</div>" +
                "</div>" +
                "</div>" +
                '<div style="display:flex;align-items:center;gap:8px;flex-shrink:0;">' +
                '<span class="status-badge ' + statusClass + '">' + statusLabel + "</span>" +
                (parent ?
                    '<button onclick="removeCompany(' + comp.companyId + ", '" + escapeHtml(companyName) + '\')" class="btn btn-danger btn-sm" style="padding:4px 10px;font-size:11px;" title="Remove company from this compliance">' +
                    '<i class="fas fa-trash-alt"></i> Remove</button>' :
                    '') +
                "</div>" +
                "</div>" +
                '<div class="sub-list">' +
                '<div class="sub-label"><i class="fas fa-sitemap" style="color:var(--primary);"></i> Sub-Compliances (' + subs.length + ")</div>";

            if (subs.length === 0) {
                html += '<div style="padding:8px 0;font-size:12px;color:var(--gray-500);">No sub‑compliances added yet.</div>';
            } else {
                subs.sort(function (a, b) { return new Date(a.dueDate) - new Date(b.dueDate); });
                for (var j = 0; j < subs.length; j++) {
                    var c = subs[j];
                    var subStatus = c.status || "PENDING";
                    var subStatusClass = getCompanyStatusClass(subStatus);
                    var subStatusLabel = getStatusLabel(subStatus);
                    var isConfigured = c.configured || false;
                    var subName = c.subTemplateName || c.templateName || "Sub-Compliance #" + (j + 1);

                    var dueDateDisplay = "No due date";
                    var dueDateClass = "";
                    if (c.dueDate && c.frequency) {
                        var dueDateObj = new Date(c.dueDate);
                        dueDateDisplay = formatDate(c.dueDate);
                        if (subStatus !== "COMPLETED" && subStatus !== "EXEMPTED") {
                            var diffDays = Math.ceil((dueDateObj - today) / (1000 * 60 * 60 * 24));
                            if (diffDays < 0) {
                                dueDateClass = "overdue";
                                dueDateDisplay += " (Overdue)";
                            } else if (diffDays <= 7) {
                                dueDateClass = "pending";
                                dueDateDisplay += " (" + diffDays + " days)";
                            }
                        }
                    } else if (c.dueDate && !c.frequency) {
                        dueDateDisplay = formatDate(c.dueDate);
                    }

                    var frequencyDisplay = c.frequency ? getFrequencyLabel(c.frequency) : "—";

                    html +=
                        '<div class="sub-item" style="border-left-color:' +
                        (subStatus === "COMPLETED" ? "var(--success)" :
                            subStatus === "OVERDUE" ? "var(--danger)" : "var(--primary)") +
                        ';">' +
                        '<div style="display:flex;flex-direction:column;gap:2px;flex:1;min-width:0;">' +
                        '<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">' +
                        '<span class="sub-name">' + escapeHtml(subName) + "</span>" +
                        '<span class="badge ' + (isConfigured ? "badge-active" : "badge-pending") +
                        '" style="font-size:9px;padding:1px 8px;">' +
                        (isConfigured ? "Configured" : "Pending") +
                        "</span>" +
                        "</div>" +
                        '<div style="display:flex;gap:12px;flex-wrap:wrap;font-size:10px;color:var(--gray-500);">' +
                        (frequencyDisplay !== "—" ? '<span><i class="fas fa-redo" style="color:var(--primary);"></i> ' + frequencyDisplay + "</span>" : "") +
                        '<span class="' + dueDateClass + '"><i class="fas fa-calendar-alt" style="color:var(--primary);"></i> Due: ' + dueDateDisplay + "</span>" +
                        "</div>" +
                        "</div>" +
                        '<span class="sub-status ' + subStatusClass +
                        '" style="font-size:9px;padding:2px 10px;flex-shrink:0;">' +
                        subStatusLabel +
                        "</span>" +
                        "</div>";
                }
            }

            html += "</div></div>";
        }

        container.innerHTML = html;
    }




    // ==================== REMOVE COMPANY ====================
   async function removeCompany(companyId, companyName) {
       if (!confirm('⚠️ Are you sure you want to remove "' + companyName + '" from this compliance category?\n\n' +
           'This permanently deletes the assignment and its configuration for this company.')) {
           return;
       }
       try {
           var result = await api('/api/super-admin/compliance/companies/' + companyId + '/templates/' + TEMPLATE_ID, {
               method: 'DELETE'
           });
           if (result && result.success) {
               toast('Removed "' + companyName + '" from this compliance category', 'success');
               await loadAssignedCompanies();
               updateUI();
           } else {
               toast(result?.error || 'Failed to remove company', 'error');
           }
       } catch (error) {
           console.error('Error removing company:', error);
           toast('Error removing company', 'error');
       }
   }

    // ==================== CONFIGURE FUNCTIONS ====================
    function configureParent() {
        // If sub-compliances exist, don't allow parent configuration
        if (subCompliances.length > 0) {
            toast("This category has sub-compliances. Please configure each sub-compliance individually.", "warning");
            return;
        }
        openConfigModal(TEMPLATE_ID, "template");
    }

    function editParentConfig() {
        openConfigModal(TEMPLATE_ID, 'template');
    }

    // ==================== CONFIG MODAL ====================
   // ==================== CONFIG MODAL ====================
   function openConfigModal(id, type) {
       document.getElementById('configTargetId').value = id;
       document.getElementById('configTargetType').value = type;

       var title = type === 'template' ? 'Configure Parent Compliance' : 'Configure Sub-Compliance';
       var subtitle = type === 'template' ? 'Set up the compliance configuration' : 'Set up this sub-compliance configuration';
       document.getElementById('configModalTitle').textContent = title;
       document.getElementById('configModalSubtitle').textContent = subtitle;

       // Reset form first
       document.getElementById('configFrequency').value = '';
       document.getElementById('configDueDate').value = '';
       document.getElementById('configInstructions').value = '';
       document.getElementById('configDocumentRequired').value = '';
       document.getElementById('configExternalLink').value = '';
       document.getElementById('configReminderDays').value = '10';
       document.getElementById('configRepeatReminder').value = 'true';
       document.getElementById('configReminderIntervalDays').value = '3';

       // ===== FIX: Load existing configuration based on type =====
       if (type === 'template') {
           // Load parent config
           if (parentConfig) {
               var c = parentConfig;
               populateConfigForm(c);
           }
       } else if (type === 'sub') {
           // ===== FIX: Load sub-compliance config =====
           console.log('Loading config for sub-compliance ID:', id);

           var sub = subCompliances.find(function(s) {
               return s.id === id;
           });

           console.log('Found sub-compliance:', sub);
           console.log('Config details:', sub ? sub.configDetails : null);

           if (sub && sub.configDetails) {
               var c = sub.configDetails;
               console.log('Populating form with config:', c);
               populateConfigForm(c);
           } else {
               // No existing config - set default values
               console.log('No existing config found, using defaults');
               document.getElementById('configFrequency').value = 'ONE_TIME';
               document.getElementById('configDueDate').value = '';
               document.getElementById('configInstructions').value = '';
               document.getElementById('configDocumentRequired').value = '';
               document.getElementById('configExternalLink').value = '';
               document.getElementById('configReminderDays').value = '10';
               document.getElementById('configRepeatReminder').value = 'true';
               document.getElementById('configReminderIntervalDays').value = '3';
               showConfigSections('ONE_TIME');
           }
       }

       document.getElementById('configModal').style.display = 'flex';
       document.body.style.overflow = 'hidden';
   }


   // ===== NEW HELPER FUNCTION: Populate config form =====
   function populateConfigForm(c) {
       console.log('Populating form with config object:', c);

       // Set frequency
       var frequency = c.frequency || '';
       document.getElementById('configFrequency').value = frequency;

       // Set reminder fields
       document.getElementById('configReminderDays').value = c.reminderDaysBefore || 10;
       document.getElementById('configRepeatReminder').value = c.repeatReminder !== false ? 'true' : 'false';
       document.getElementById('configReminderIntervalDays').value = c.reminderIntervalDays || 3;

       // Set instructions and document fields
       document.getElementById('configInstructions').value = c.instructions || '';
       document.getElementById('configDocumentRequired').value = c.documentRequired || '';
       document.getElementById('configExternalLink').value = c.externalLink || '';

       // ===== FIX: Populate frequency-specific fields =====
       if (frequency === 'ONE_TIME') {
           // Set custom due date
           if (c.customDueDate) {
               document.getElementById('configDueDate').value = c.customDueDate;
           } else if (c.dueDate) {
               document.getElementById('configDueDate').value = c.dueDate;
           }
       } else if (frequency === 'MONTHLY') {
           // Set day of month
           if (c.dueDayOfMonth) {
               document.getElementById('configDueDayOfMonth').value = c.dueDayOfMonth;
           }
       } else if (frequency === 'QUARTERLY') {
           // Set quarter and day of month
           if (c.dueQuarter) {
               document.getElementById('configDueQuarter').value = c.dueQuarter;
           }
           if (c.dueDayOfMonth) {
               document.getElementById('configDueDayOfMonthQ').value = c.dueDayOfMonth;
           }
       } else if (frequency === 'HALF_YEARLY') {
           // Set half and day of month
           if (c.dueHalf) {
               document.getElementById('configDueHalf').value = c.dueHalf;
           }
           if (c.dueDayOfMonth) {
               document.getElementById('configDueDayOfMonthH').value = c.dueDayOfMonth;
           }
       } else if (frequency === 'YEARLY') {
           // Set month and day of month
           if (c.dueMonth) {
               document.getElementById('configDueMonth').value = c.dueMonth;
           }
           if (c.dueDayOfMonth) {
               document.getElementById('configDueDayOfMonthY').value = c.dueDayOfMonth;
           }
       }

       // Show the appropriate sections based on frequency
       showConfigSections(frequency);
   }

    function closeConfigModal() {
        document.getElementById('configModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    document.getElementById('configFrequency').addEventListener('change', function() {
        showConfigSections(this.value);
    });

    document.getElementById('configRepeatReminder').addEventListener('change', function() {
        document.getElementById('configIntervalSection').style.display = this.value === 'true' ? 'block' : 'none';
    });

   function showConfigSections(frequency) {
       // Hide all due‑date sections first
       var sections = [
           "configDueDateSection",
           "configMonthlySection",
           "configQuarterlySection",
           "configHalfYearlySection",
           "configYearlySection"
       ];
       for (var i = 0; i < sections.length; i++) {
           document.getElementById(sections[i]).style.display = "none";
       }

       // Always show reminder sections (don't hide them even if frequency is empty)
       document.getElementById('configReminderDays').style.display = 'block';
       document.getElementById('configRepeatReminder').style.display = 'block';
       document.getElementById('configIntervalSection').style.display = 'block';

       // Show due‑date sections based on frequency
       if (frequency === "ONE_TIME") {
           document.getElementById("configDueDateSection").style.display = "block";
       } else if (frequency === "MONTHLY") {
           document.getElementById("configMonthlySection").style.display = "block";
       } else if (frequency === "QUARTERLY") {
           document.getElementById("configQuarterlySection").style.display = "block";
       } else if (frequency === "HALF_YEARLY") {
           document.getElementById("configHalfYearlySection").style.display = "block";
       } else if (frequency === "YEARLY") {
           document.getElementById("configYearlySection").style.display = "block";
       }
       // If frequency is empty/null, don't show any due-date section but reminder sections stay visible
   }

  async function saveConfig() {
      var targetId = parseInt(document.getElementById("configTargetId").value);
      var targetType = document.getElementById("configTargetType").value;
      var frequency = document.getElementById("configFrequency").value;

      var payload = {
          frequency: frequency || null,
          instructions: document.getElementById("configInstructions").value || null,
          documentRequired: document.getElementById("configDocumentRequired").value || null,
          externalLink: document.getElementById("configExternalLink").value || null
      };

      // Only include reminder fields if frequency is not empty
      if (frequency && frequency !== "") {
          payload.reminderDaysBefore = parseInt(document.getElementById("configReminderDays").value);
          payload.repeatReminder = document.getElementById("configRepeatReminder").value === "true";
          payload.reminderIntervalDays = parseInt(document.getElementById("configReminderIntervalDays").value);
      } else {
          payload.reminderDaysBefore = null;
          payload.repeatReminder = null;
          payload.reminderIntervalDays = null;
      }

      // Include due‑date fields only if frequency is not empty
      if (frequency === "ONE_TIME") {
          payload.customDueDate = document.getElementById("configDueDate").value || null;
      } else if (frequency === "MONTHLY") {
          payload.dueDayOfMonth = parseInt(document.getElementById("configDueDayOfMonth").value);
      } else if (frequency === "QUARTERLY") {
          payload.dueQuarter = parseInt(document.getElementById("configDueQuarter").value);
          payload.dueDayOfMonth = parseInt(document.getElementById("configDueDayOfMonthQ").value);
      } else if (frequency === "HALF_YEARLY") {
          payload.dueHalf = parseInt(document.getElementById("configDueHalf").value);
          payload.dueDayOfMonth = parseInt(document.getElementById("configDueDayOfMonthH").value);
      } else if (frequency === "YEARLY") {
          payload.dueMonth = parseInt(document.getElementById("configDueMonth").value);
          payload.dueDayOfMonth = parseInt(document.getElementById("configDueDayOfMonthY").value);
      }

      var btn = document.getElementById("configSaveBtn");
      var originalText = btn.innerHTML;
      btn.disabled = true;
      btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Configuring...';

      var url, method;
      if (targetType === "template") {
          url = "/api/super-admin/compliance/config?templateId=" + targetId;
          method = "POST";
      } else {
          url = "/api/super-admin/compliance/sub-config?subTemplateId=" + targetId;
          method = "POST";
      }

      try {
          var data = await api(url, {
              method: method,
              body: JSON.stringify(payload)
          });

          if (data && data.success) {
              toast("Compliance configured and auto-assigned to all active companies!", "success");
              closeConfigModal();
              // Refresh relevant parts (parent config, assigned companies, etc.)
              await Promise.all([loadParentConfig(),loadSubCompliances() , loadAssignedCompanies()]);
              updateUI();
          } else {
              toast(data?.error || "Configuration failed", "error");
          }
      } catch (error) {
          console.error("Error saving config:", error);
          toast("Failed to save configuration", "error");
      } finally {
          btn.disabled = false;
          btn.innerHTML = originalText;
      }
  }

    function editConfig(id) {
        openConfigModal(id, 'sub');
    }

    // ==================== SUB-COMPLIANCE CRUD ====================
    function openAddSubModal() {
        editingSubId = null;
        document.getElementById('subId').value = '';
        document.getElementById('subModalTitle').innerHTML = '<i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add Sub-Compliance';
        document.getElementById('subModalSubtitle').textContent = 'Create a sub-compliance under "' + (templateData ? templateData.name : 'this category') + '"';
        document.getElementById('subForm').reset();
        document.getElementById('subDisplayOrder').value = '0';
        document.getElementById('subModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeSubModal() {
        document.getElementById('subModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function editSubCompliance(id) {
        try {
            var data = await api('/api/super-admin/compliance/sub-templates?parentId=' + TEMPLATE_ID);
            if (data && data.success) {
                var found = data.data.find(function(s) { return s.id === id; });
                if (found) {
                    document.getElementById('subId').value = found.id;
                    document.getElementById('subName').value = found.name;
                    document.getElementById('subDescription').value = found.description || '';
                    document.getElementById('subDisplayOrder').value = found.displayOrder || 0;
                    document.getElementById('subModalTitle').innerHTML = '<i class="fas fa-edit" style="color:var(--primary);margin-right:8px;"></i>Edit Sub-Compliance';
                    document.getElementById('subModalSubtitle').textContent = 'Update sub-compliance details';
                    document.getElementById('subModal').style.display = 'flex';
                    document.body.style.overflow = 'hidden';
                }
            }
        } catch (error) {
            console.error('Error editing sub-compliance:', error);
            toast('Failed to load sub-compliance details', 'error');
        }
    }

    async function saveSubCompliance() {
        var name = document.getElementById('subName').value.trim();
        if (!name) {
            toast('Please enter a name', 'error');
            return;
        }

        var payload = {
            name: name,
            description: document.getElementById('subDescription').value || null,
            displayOrder: parseInt(document.getElementById('subDisplayOrder').value) || 0,
            parentTemplateId: parseInt(TEMPLATE_ID)
        };

        var btn = document.getElementById('subSaveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

        var url, method;
        var subId = document.getElementById('subId').value;
        if (subId) {
            url = '/api/super-admin/compliance/sub-templates/' + subId;
            method = 'PUT';
        } else {
            url = '/api/super-admin/compliance/sub-templates?parentId=' + TEMPLATE_ID;
            method = 'POST';
        }

        try {
            var data = await api(url, { method: method, body: JSON.stringify(payload) });
            console.log('Sub-compliance save response:', data);

            btn.disabled = false;
            btn.innerHTML = originalText;

            if (data && data.success) {
                toast(subId ? 'Sub-compliance updated' : 'Sub-compliance created', 'success');
                closeSubModal();
                await loadSubCompliances();
                updateUI();
            } else {
                toast(data?.error || 'Operation failed', 'error');
            }
        } catch (error) {
            console.error('Error saving sub-compliance:', error);
            btn.disabled = false;
            btn.innerHTML = originalText;
            toast('Failed to save sub-compliance', 'error');
        }
    }

    // ==================== TOGGLE SUB-COMPLIANCE STATUS ====================
    async function toggleSubStatus(id, currentStatus) {
        var action = currentStatus ? 'deactivate' : 'activate';
        if (!confirm('Are you sure you want to ' + action + ' this sub-compliance?')) return;

        try {
            var data = await api('/api/super-admin/compliance/sub-templates/' + id + '/toggle-status', { method: 'PATCH' });
            console.log('Toggle response:', data);

            if (data && data.success) {
                toast('Sub-compliance ' + action + 'd', 'success');
                await loadSubCompliances();
                updateUI();
            } else {
                toast(data?.error || 'Failed', 'error');
            }
        } catch (error) {
            console.error('Error toggling sub-status:', error);
            toast('Failed to toggle status', 'error');
        }
    }



    function getComplianceIcon(name) {
        if (!name) return 'fa-tasks';
        var n = name.toLowerCase();
        if (n.includes('gst') || n.includes('indirect tax')) return 'fa-file-invoice-dollar';
        if (n.includes('direct tax') || n.includes('income tax') || n.includes('tds')) return 'fa-calculator';
        if (n.includes('pf') || n.includes('provident') || n.includes('esic') || n.includes('labour')) return 'fa-users';
        if (n.includes('company') || n.includes('corporate') || n.includes('mca') || n.includes('roc')) return 'fa-building';
        if (n.includes('environment') || n.includes('pollution') || n.includes('pcb')) return 'fa-leaf';
        if (n.includes('licence') || n.includes('license') || n.includes('permit') || n.includes('shop')) return 'fa-id-card';
        if (n.includes('audit') || n.includes('account') || n.includes('balance')) return 'fa-balance-scale';
        if (n.includes('return') || n.includes('filing') || n.includes('annual')) return 'fa-file-alt';
        if (n.includes('legal') || n.includes('court') || n.includes('contract')) return 'fa-gavel';
        if (n.includes('insurance') || n.includes('policy')) return 'fa-shield-alt';
        if (n.includes('fssai') || n.includes('food')) return 'fa-utensils';
        if (n.includes('fire') || n.includes('safety')) return 'fa-fire-extinguisher';
        if (n.includes('electricity') || n.includes('power')) return 'fa-bolt';
        if (n.includes('labour') || n.includes('labor') || n.includes('employee')) return 'fa-briefcase';
        if (n.includes('tax') || n.includes('vat') || n.includes('gst')) return 'fa-file-invoice';
        if (n.includes('license') || n.includes('permit')) return 'fa-id-card';
        if (n.includes('compli') || n.includes('regulation')) return 'fa-check-shield';
        if (n.includes('audit') || n.includes('inspection')) return 'fa-clipboard-check';
        if (n.includes('contract') || n.includes('agreement')) return 'fa-file-signature';
        if (n.includes('insurance') || n.includes('policy')) return 'fa-shield-halved';
        if (n.includes('health') || n.includes('safety')) return 'fa-heart-pulse';
        if (n.includes('training') || n.includes('learning')) return 'fa-graduation-cap';
        if (n.includes('document') || n.includes('record')) return 'fa-folder-open';
        if (n.includes('financial') || n.includes('budget')) return 'fa-coins';
        if (n.includes('project') || n.includes('delivery')) return 'fa-project-diagram';
        if (n.includes('quality') || n.includes('iso')) return 'fa-certificate';
        if (n.includes('it') || n.includes('cyber') || n.includes('data')) return 'fa-server';
        if (n.includes('hr') || n.includes('recruitment')) return 'fa-user-tie';
        if (n.includes('procurement') || n.includes('purchase')) return 'fa-shopping-cart';
        if (n.includes('logistics') || n.includes('supply')) return 'fa-truck';
        if (n.includes('marketing') || n.includes('advertising')) return 'fa-bullhorn';
        if (n.includes('sales') || n.includes('revenue')) return 'fa-chart-line';
        if (n.includes('admin') || n.includes('administration')) return 'fa-user-cog';
        return 'fa-tasks';
    }

    // ==================== DELETE SUB-COMPLIANCE ====================
    function openDeleteSubModal(id, name, isConfigured) {
        pendingDeleteSubId = id;
        document.getElementById('deleteSubName').textContent = name;

        var warningDiv = document.getElementById('deleteSubWarning');
        var warningText = document.getElementById('deleteSubWarningText');

        if (isConfigured) {
            warningDiv.style.display = 'flex';
            warningText.textContent = 'This sub-compliance is already configured. Deleting will also remove all configurations and assignments from companies!';
        } else {
            warningDiv.style.display = 'none';
        }

        document.getElementById('deleteSubModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteSubModal() {
        pendingDeleteSubId = null;
        document.getElementById('deleteSubModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function confirmDeleteSub() {
        if (!pendingDeleteSubId) return;

        try {
            var data = await api('/api/super-admin/compliance/sub-templates/' + pendingDeleteSubId, { method: 'DELETE' });
            console.log('Delete response:', data);

            if (data && data.success) {
                toast('Sub-compliance deleted successfully', 'success');
                closeDeleteSubModal();
                await loadSubCompliances();
                updateUI();
            } else {
                toast(data?.error || 'Failed to delete', 'error');
            }
        } catch (error) {
            console.error('Error deleting sub-compliance:', error);
            toast('Failed to delete sub-compliance', 'error');
        }
    }

    // ==================== REFRESH ====================
    function refreshAssignedCompanies() {
        toast('Refreshing...', 'info');
        loadAssignedCompanies();
    }

    // ==================== CLOSE MODALS ON OVERLAY ====================
    document.getElementById('subModal').addEventListener('click', function(e) {
        if (e.target === this) closeSubModal();
    });

    document.getElementById('configModal').addEventListener('click', function(e) {
        if (e.target === this) closeConfigModal();
    });

    document.getElementById('deleteSubModal').addEventListener('click', function(e) {
        if (e.target === this) closeDeleteSubModal();
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

        loadTemplateDetails();
        loadNotifications();
    });
</script>

</body>
</html>