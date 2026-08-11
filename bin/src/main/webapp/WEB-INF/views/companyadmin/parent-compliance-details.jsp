<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- File: companyadmin/parent-compliance-details.jsp --%>
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
    pageContext.setAttribute("pageTitle", "Compliance Details");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Compliance Details</title>

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
        }
        .logo-bg img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .app-wrapper {
            display: flex;
            min-height: 100vh;
            position: relative;
            z-index: 1;
        }

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

        .main-content {
            margin-left: 260px;
            margin-top: 64px;
            padding: 32px 40px;
            flex: 1;
            min-height: calc(100vh - 64px);
            position: relative;
            z-index: 1;
        }

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
        }
        .breadcrumb .current {
            color: var(--gray-800);
            font-weight: 500;
        }

        .hero-header {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            overflow: hidden;
            position: relative;
            margin-bottom: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }
        .hero-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--primary), var(--primary-light), var(--primary), transparent);
        }
        .hero-inner {
            padding: 28px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .hero-content {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .hero-icon {
            width: 64px;
            height: 64px;
            min-width: 64px;
            background: #000;
            border: 1.5px solid rgba(79, 70, 229, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e9d80f;
            font-size: 26px;
            flex-shrink: 0;
        }
        .hero-text h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--gray-900);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .hero-text .description {
            font-size: 13px;
            color: var(--gray-500);
            margin: 6px 0 12px 0;
            line-height: 1.5;
        }
        .hero-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .hero-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

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
        .badge-locked { background: var(--primary-bg); color: var(--primary); }
        .badge-custom { background: rgba(16, 185, 129, 0.12); color: var(--success); }

        .section-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
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
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title i {
            color: var(--primary);
            font-size: 15px;
        }
        .section-badge {
            background: var(--primary-bg);
            color: var(--primary);
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 4px;
        }

        .config-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 12px;
        }
        .config-item {
            background: rgba(226, 232, 240, 0.12);
            border: 1px solid rgba(226, 232, 240, 0.3);
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
            font-weight: 600;
            color: var(--gray-800);
            margin-top: 4px;
            word-break: break-word;
        }

        .filter-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        .search-box {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            padding: 6px 12px;
            gap: 8px;
            flex: 1;
            max-width: 300px;
            transition: all 0.2s;
        }
        .search-box:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background: rgba(255, 255, 255, 0.8);
        }
        .search-box i {
            color: var(--gray-400);
            font-size: 13px;
        }
        .search-box input {
            background: none;
            border: none;
            color: var(--gray-800);
            font-size: 13px;
            width: 100%;
            outline: none;
            font-family: 'Inter', sans-serif;
        }
        .search-box input::placeholder {
            color: var(--gray-400);
        }
        .filter-select {
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            padding: 6px 12px;
            color: var(--gray-800);
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            outline: none;
            transition: all 0.2s;
        }
        .filter-select:hover {
            border-color: var(--primary-light);
        }
        .filter-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .sub-grid {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sub-card {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            overflow: hidden;
            position: relative;
            transition: all 0.25s ease;
        }
        .sub-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: var(--gray-300);
            border-radius: 0;
        }
        .sub-card:hover {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: var(--shadow-md);
            transform: translateX(3px);
        }
        .sub-card.completed::before { background: var(--success); }
        .sub-card.overdue::before { background: var(--danger); }
        .sub-card.in-progress::before { background: var(--primary); }
        .sub-card.pending::before { background: var(--warning); }

        .sub-card-inner {
            padding: 16px 20px;
        }

        .sub-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .sub-card-title-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            flex: 1;
            min-width: 0;
        }

        .sub-icon {
            width: 36px;
            height: 36px;
            min-width: 36px;
            border-radius: 50%;
            background: #000;
            border: 1.5px solid rgba(79, 70, 229, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e9d80f;
            font-size: 14px;
            flex-shrink: 0;
        }

        .sub-title-text {
            flex: 1;
            min-width: 0;
        }
        .sub-name {
            font-size: 14px;
            font-weight: 700;
            color: var(--gray-900);
            text-transform: uppercase;
            letter-spacing: 0.3px;
            line-height: 1.3;
        }
        .sub-name-badges {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 5px;
        }

        .sub-actions {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-shrink: 0;
        }

        .sub-meta-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            padding: 10px 0;
            margin-bottom: 8px;
            border-top: 1px solid rgba(226, 232, 240, 0.4);
            border-bottom: 1px solid rgba(226, 232, 240, 0.4);
        }
        .sub-meta-item {
            font-size: 11px;
            color: var(--gray-500);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .sub-meta-item i {
            color: var(--primary);
            opacity: 0.7;
            font-size: 10px;
        }
        .sub-meta-item.overdue-text {
            color: var(--danger);
            font-weight: 600;
        }
        .sub-meta-item.overdue-text i {
            color: var(--danger);
            opacity: 1;
        }
        .sub-meta-item.warning-text {
            color: var(--warning);
            font-weight: 600;
        }
        .sub-meta-item.warning-text i {
            color: var(--warning);
            opacity: 1;
        }

        .sub-description {
            font-size: 12px;
            color: var(--gray-500);
            line-height: 1.5;
            margin-bottom: 10px;
        }

        .sub-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 8px;
        }
        .sub-detail-item {
            background: rgba(226, 232, 240, 0.08);
            border-radius: 8px;
            padding: 8px 10px;
        }
        .sub-detail-label {
            font-size: 9px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-weight: 600;
        }
        .sub-detail-value {
            font-size: 12px;
            font-weight: 500;
            color: var(--gray-800);
            margin-top: 2px;
        }

        .sub-instructions {
            margin-top: 10px;
            padding: 10px 12px;
            background: rgba(79, 70, 229, 0.04);
            border-left: 2px solid var(--primary-light);
            border-radius: 6px;
            font-size: 12px;
            color: var(--gray-500);
            line-height: 1.5;
            white-space: pre-line;
        }

        .completion-box {
            margin-top: 12px;
            padding: 14px 16px;
            background: rgba(16, 185, 129, 0.05);
            border: 1px solid rgba(16, 185, 129, 0.2);
            border-radius: var(--radius);
        }
        .completion-box .completion-title {
            font-size: 10px;
            font-weight: 700;
            color: var(--success);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .completion-box .comp-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 10px;
        }
        .completion-box .comp-item .comp-label {
            font-size: 9px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        .completion-box .comp-item .comp-value {
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-800);
            margin-top: 2px;
        }

        .vnext-blinker {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            flex-shrink: 0;
            display: inline-block;
        }
        .blinker-overdue {
            background: var(--danger);
            box-shadow: 0 0 8px rgba(239, 68, 68, 0.9);
            animation: blink-overdue 0.55s ease-in-out infinite;
        }
        .blinker-danger {
            background: var(--danger);
            box-shadow: 0 0 12px rgba(239, 68, 68, 0.8);
            animation: blink-danger 0.38s ease-in-out infinite;
        }
        .blinker-warning {
            background: var(--warning);
            box-shadow: 0 0 8px rgba(245, 158, 11, 0.7);
            animation: blink-warning 0.9s ease-in-out infinite;
        }
        .blinker-ok {
            background: var(--success);
            box-shadow: 0 0 5px rgba(16, 185, 129, 0.45);
        }
        @keyframes blink-overdue {
            0%, 100% { opacity: 1; transform: scale(1.1); }
            50% { opacity: 0.15; transform: scale(0.75); }
        }
        @keyframes blink-danger {
            0%, 100% { opacity: 1; transform: scale(1.2); }
            50% { opacity: 0.05; transform: scale(0.65); }
        }
        @keyframes blink-warning {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.3; transform: scale(0.82); }
        }

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
            box-shadow: 0 4px 16px rgba(16, 185, 129, 0.3);
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
        .btn-info {
            background: var(--info);
            color: white;
            border-color: var(--info);
        }
        .btn-info:hover {
            background: #2563eb;
            border-color: #2563eb;
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
        .btn-lg {
            padding: 11px 22px;
            font-size: 14px;
        }
        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .vnext-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 9px 18px;
            border-radius: var(--radius);
            font-size: 13px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
        }
        .vnext-btn-gold {
            background: var(--primary-bg);
            color: var(--primary);
            border: 1px solid rgba(79, 70, 229, 0.25);
        }
        .vnext-btn-gold:hover {
            background: rgba(79, 70, 229, 0.15);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15);
        }
        .vnext-btn-success {
            background: var(--success-bg);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.25);
        }
        .vnext-btn-success:hover {
            background: rgba(16, 185, 129, 0.2);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15);
        }
        .vnext-btn-ghost {
            background: rgba(255, 255, 255, 0.5);
            color: var(--gray-500);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
        .vnext-btn-ghost:hover {
            background: var(--gray-100);
            color: var(--gray-700);
            border-color: var(--gray-300);
        }

        .empty-state {
            text-align: center;
            padding: 40px 24px;
            color: var(--gray-500);
        }
        .empty-state i {
            font-size: 36px;
            opacity: 0.3;
            display: block;
            margin-bottom: 10px;
        }
        .empty-state p {
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

        /* ==================== MODALS ==================== */
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
            background: rgba(255, 255, 255, 0.97);
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
        @keyframes modalSlideIn {
            from { opacity: 0; transform: translateY(20px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-shrink: 0;
            position: relative;
        }
        .modal-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--primary), var(--primary-light), var(--primary), transparent);
            border-radius: var(--radius-xl) var(--radius-xl) 0 0;
        }
        .modal-header .modal-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--gray-900);
            margin-top: 4px;
        }
        .modal-header .modal-subtitle {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 3px;
        }
        .modal-header .modal-close {
            background: none;
            border: none;
            color: var(--gray-400);
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            transition: color 0.2s;
            margin-top: 2px;
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
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-shrink: 0;
            flex-wrap: wrap;
            background: rgba(248, 250, 252, 0.5);
            border-radius: 0 0 var(--radius-xl) var(--radius-xl);
        }

        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 5px;
        }
        .form-input {
            padding: 9px 12px;
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
        .form-group {
            margin-bottom: 16px;
        }

        .modal-info-strip {
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 14px;
        }
        .strip-success {
            background: rgba(16, 185, 129, 0.08);
            border-left: 3px solid var(--success);
            color: var(--success);
        }
        .strip-primary {
            background: rgba(79, 70, 229, 0.06);
            border-left: 3px solid var(--primary);
            color: var(--primary);
        }
        .strip-warning {
            background: rgba(245, 158, 11, 0.08);
            border-left: 3px solid var(--warning);
            color: var(--warning);
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        .col-2 {
            grid-column: span 2;
        }

        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .logo-bg { width: 500px; height: 500px; }
            .grid-2 { grid-template-columns: 1fr; }
            .col-2 { grid-column: span 1; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .hero-inner { flex-direction: column; align-items: flex-start; }
            .hero-actions { width: 100%; }
            .hero-actions .btn { flex: 1; justify-content: center; }
            .config-grid { grid-template-columns: 1fr; }
            .sub-details-grid { grid-template-columns: 1fr 1fr; }
            .filter-bar { flex-direction: column; }
            .search-box { max-width: none; }
            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .hero-text h1 { font-size: 16px; }
            .sub-card-header { flex-direction: column; align-items: flex-start; }
            .sub-actions { width: 100%; }
            .notification-dropdown { width: 280px; right: -80px; }
            .completion-box .comp-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="logo-bg">
    <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<div id="toast-container"></div>

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
            <span class="page-title">Compliance Details</span>
        </div>
        <div class="header-right">
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
        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/company-admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/list">My Compliances</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current" id="breadcrumbName">Loading...</span>
        </div>

        <!-- Loader -->
        <div id="loader" style="text-align:center;padding:80px 0;">
            <div class="spinner"></div>
            <p style="color:var(--gray-500);margin-top:12px;font-size:13px;">Loading compliance details...</p>
        </div>

        <!-- Page Content -->
        <div id="pageContent" style="display:none;">

            <!-- ==================== HERO HEADER ==================== -->
            <div class="hero-header">
                <div class="hero-inner">
                    <div class="hero-content">
                        <div class="hero-icon" id="heroIconEl">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <div class="hero-text">
                            <h1 id="categoryName">—</h1>
                            <p id="categoryDesc" class="description">—</p>
                            <div class="hero-badges" id="heroBadges"></div>
                        </div>
                    </div>
                    <div class="hero-actions" id="heroActions"></div>
                </div>
            </div>

            <!-- ==================== PARENT CONFIG SECTION ==================== -->
            <div id="parentConfigSection" class="section-card" style="display:none;">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-cog"></i> Compliance Configuration
                    </div>
                    <div id="parentConfigActions"></div>
                </div>
                <div id="parentConfigDetails" class="config-grid"></div>
            </div>

            <!-- ==================== SUB-COMPLIANCES SECTION ==================== -->
            <div id="subSection" class="section-card" style="display:none;">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-sitemap"></i> Sub-Compliances
                        <span id="subCountTab" class="section-badge">0</span>
                    </div>
                    <div style="display:flex;gap:8px;flex-wrap:wrap;align-items:center;">
                        <button onclick="markAllSubsComplete()" class="btn btn-success btn-sm" id="markAllCompleteBtn" style="display:none;">
                            <i class="fas fa-check-double"></i> Mark All Complete
                        </button>
                    </div>
                </div>
                <div class="filter-bar">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchSubCompliance" placeholder="Search sub-compliances...">
                    </div>
                    <select id="statusFilterSub" class="filter-select">
                        <option value="all">All Status</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="PENDING">Pending</option>
                        <option value="OVERDUE">Overdue</option>
                    </select>
                </div>
                <div id="subCompliancesGrid" class="sub-grid">
                    <div class="empty-state">
                        <i class="fas fa-spinner fa-spin" style="opacity:0.4;"></i>
                        <p style="margin-top:8px;">Loading...</p>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- ==================== MARK COMPLETE MODAL ==================== -->
<div id="markCompleteModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title">
                    <i class="fas fa-check-circle" style="color:var(--success);margin-right:6px;"></i>Mark as Complete
                </div>
                <div class="modal-subtitle" id="markCompleteSubName">—</div>
            </div>
            <button class="modal-close" onclick="closeMarkCompleteModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div id="completionStatusInfo" style="display:none;" class="modal-info-strip strip-success">
                <i class="fas fa-check-circle"></i>
                <span>This compliance is already completed. You can update the details below.</span>
            </div>
            <div class="modal-info-strip strip-primary">
                <i class="fas fa-user-shield"></i>
                <span>You are marking this compliance as complete as <strong>Company Admin</strong>.</span>
            </div>
            <form id="markCompleteForm" onsubmit="return false;">
                <input type="hidden" id="markCompleteId" />
                <div class="form-group">
                    <label class="form-label">Submission Reference</label>
                    <input type="text" id="markCompleteReference" class="form-input" placeholder="e.g., ARN number, Receipt number" />
                </div>
                <div class="form-group">
                    <label class="form-label">Upload Document <span style="color:var(--gray-400);font-weight:400;">(Optional)</span></label>
                    <input type="file" id="markCompleteDocument" class="form-input" accept=".pdf,.jpg,.png,.doc,.docx" />
                    <div style="font-size:11px;color:var(--gray-400);margin-top:4px;">
                        <i class="fas fa-info-circle"></i> Max 10MB. Supported: PDF, JPG, PNG, DOC, DOCX
                    </div>
                </div>
                <div class="modal-info-strip strip-warning" style="margin-bottom:0;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>This will mark the compliance as completed for the company. All employees will see it as completed.</span>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeMarkCompleteModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="submitMarkComplete()" class="btn btn-success" id="markCompleteSaveBtn">
                <i class="fas fa-check-circle"></i> Mark as Complete
            </button>
        </div>
    </div>
</div>

<!-- ==================== ADD SUB-COMPLIANCE MODAL ==================== -->
<div id="subModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="subModalTitle">
                    <i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add Sub-Compliance
                </div>
                <div class="modal-subtitle" id="subModalSubtitle">Create a sub-compliance under this category</div>
            </div>
            <button class="modal-close" onclick="closeSubModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="subForm" onsubmit="return false;">
                <input type="hidden" id="subId" />
                <div class="form-group">
                    <label class="form-label">Sub-Compliance Name <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="subName" class="form-input" placeholder="e.g., GST 1, TDS Return" required />
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea id="subDescription" class="form-input" rows="3" placeholder="Describe this sub-compliance..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">Display Order</label>
                    <input type="number" id="subDisplayOrder" class="form-input" value="0" min="0" />
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
                <div class="modal-title" id="configModalTitle">
                    <i class="fas fa-cog" style="color:var(--primary);margin-right:8px;"></i>Configure Compliance
                </div>
                <div class="modal-subtitle" id="configModalSubtitle">Set frequency, due date, and reminders</div>
            </div>
            <button class="modal-close" onclick="closeConfigModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="configForm" onsubmit="return false;">
                <input type="hidden" id="configTargetId" />
                <input type="hidden" id="configTargetType" />

                <div class="form-group">
                    <label class="form-label">Frequency</label>
                    <select id="configFrequency" class="form-input">
                        <option value="ONE_TIME">One Time</option>
                        <option value="MONTHLY">Monthly</option>
                        <option value="QUARTERLY">Quarterly</option>
                        <option value="HALF_YEARLY">Half Yearly</option>
                        <option value="YEARLY">Yearly</option>
                    </select>
                </div>

                <div id="configDueDateSection" class="form-group">
                    <label class="form-label">Due Date</label>
                    <input type="date" id="configDueDate" class="form-input" />
                </div>

                <div id="configMonthlySection" style="display:none;" class="form-group">
                    <label class="form-label">Day of Month</label>
                    <select id="configDueDayOfMonth" class="form-input">
                        <% for(int d=1; d<=31; d++) { %>
                        <option value="<%=d%>"><%=d%></option>
                        <% } %>
                    </select>
                </div>

                <div id="configQuarterlySection" style="display:none;" class="form-group">
                    <div class="grid-2">
                        <div>
                            <label class="form-label">Quarter</label>
                            <select id="configDueQuarter" class="form-input">
                                <option value="1">Q1 (Jan-Mar)</option>
                                <option value="2">Q2 (Apr-Jun)</option>
                                <option value="3">Q3 (Jul-Sep)</option>
                                <option value="4">Q4 (Oct-Dec)</option>
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

                <div id="configHalfYearlySection" style="display:none;" class="form-group">
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

                <div id="configYearlySection" style="display:none;" class="form-group">
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

                <div class="form-group">
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

                <div class="form-group">
                    <label class="form-label">Repeat Reminder Until Completed</label>
                    <select id="configRepeatReminder" class="form-input">
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>

                <div id="configIntervalSection" class="form-group">
                    <label class="form-label">Repeat Interval (Days)</label>
                    <select id="configReminderIntervalDays" class="form-input">
                        <option value="1">Every day</option>
                        <option value="2">Every 2 days</option>
                        <option value="3" selected>Every 3 days</option>
                        <option value="5">Every 5 days</option>
                        <option value="7">Every week</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Instructions for Employees</label>
                    <textarea id="configInstructions" class="form-input" rows="4" placeholder="Step-by-step instructions..."></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Required Documents</label>
                    <input type="text" id="configDocumentRequired" class="form-input" placeholder="e.g., Certificate, Receipt" />
                </div>

                <div class="form-group">
                    <label class="form-label">External Portal Link (Optional)</label>
                    <input type="url" id="configExternalLink" class="form-input" placeholder="https://example.gov.in" />
                </div>

                <div class="modal-info-strip strip-primary">
                    <i class="fas fa-check-circle"></i> After configuration, this compliance will be available for employees.
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeConfigModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveConfig()" class="btn btn-success" id="configSaveBtn">
                <i class="fas fa-cog"></i> Configure & Save
            </button>
        </div>
    </div>
</div>

<!-- ==================== COMPLETION DETAILS MODAL ==================== -->
<div id="completionDetailsModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" style="color:var(--success);">
                    <i class="fas fa-check-circle" style="margin-right:6px;"></i>Completion Details
                </div>
                <div class="modal-subtitle" id="completionDetailsSubName">—</div>
            </div>
            <button class="modal-close" onclick="closeCompletionDetailsModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body" id="completionDetailsBody"></div>
        <div class="modal-footer">
            <button onclick="closeCompletionDetailsModal()" class="btn btn-ghost">Close</button>
        </div>
    </div>
</div>

<script>

    var contextPath = '${pageContext.request.contextPath}';
    var PARENT_ID = '${parentId}';
    var parentData = null;
    var allSubCompliances = [];
    var isCustomCompliance = false;
    var templateId = null;





    // ==================== TOAST ====================
    function toast(message, type, duration) {
        type = type || 'info';
        duration = duration || 3500;
        var container = document.getElementById('toast-container');
        var icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle', warning: 'fa-exclamation-triangle' };
        var el = document.createElement('div');
        el.className = 'toast toast-' + type;
        el.innerHTML = '<i class="fas ' + icons[type] + '"></i><span>' + message + '</span>';
        container.appendChild(el);
        setTimeout(function() {
            el.style.opacity = '0';
            el.style.transform = 'translateX(20px)';
            el.style.transition = 'all .3s';
            setTimeout(function() { el.remove(); }, 300);
        }, duration);
    }

    // ==================== API ====================
    async function api(url, options) {
        options = options || {};
        var token = localStorage.getItem('accessToken');
        if (!token) {
            window.location.href = contextPath + '/login?error=Session expired';
            return null;
        }
        var defaults = {
            headers: {
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            }
        };
        var merged = Object.assign({}, defaults, options, {
            headers: Object.assign({}, defaults.headers, options.headers || {})
        });
        try {
            var response = await fetch(contextPath + url, merged);
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
            var date = new Date(d);
            if (isNaN(date.getTime())) return '—';
            return date.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
        } catch(e) {
            return '—';
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

    function getStatusInfo(status) {
        var map = {
            'COMPLETED': { cls: 'badge-success', icon: 'fa-check-circle', label: 'Completed' },
            'IN_PROGRESS': { cls: 'badge-info', icon: 'fa-spinner fa-pulse', label: 'In Progress' },
            'PENDING': { cls: 'badge-warning', icon: 'fa-clock', label: 'Pending' },
            'OVERDUE': { cls: 'badge-danger', icon: 'fa-exclamation-triangle', label: 'Overdue' }
        };
        return map[status] || { cls: 'badge-warning', icon: 'fa-circle', label: status || 'Pending' };
    }

    function getFrequencyLabel(freq) {
        var map = {
            'MONTHLY': 'Monthly',
            'QUARTERLY': 'Quarterly',
            'HALF_YEARLY': 'Half Yearly',
            'YEARLY': 'Yearly',
            'ONE_TIME': 'One Time'
        };
        return map[freq] || freq || '—';
    }

    function getDaysRemaining(dueDate) {
        if (!dueDate) return null;
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueDate);
        due.setHours(0, 0, 0, 0);
        return Math.ceil((due - today) / (1000 * 60 * 60 * 24));
    }

    function getBlinkerClass(dueDate, status) {
        if (status === 'COMPLETED') return 'blinker-ok';
        if (!dueDate) return '';
        var days = getDaysRemaining(dueDate);
        if (days === null || isNaN(days)) return '';
        if (days < 0) return 'blinker-overdue';
        if (days <= 1) return 'blinker-danger';
        if (days <= 3) return 'blinker-warning';
        return '';
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
        return 'fa-tasks';
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

    // ==================== LOAD PARENT DETAILS ====================

    async function loadParentDetails() {
        if (!PARENT_ID || PARENT_ID === 'null' || PARENT_ID === '') {
            toast('Invalid parent ID', 'error');
            return;
        }

        document.getElementById('loader').style.display = 'block';
        document.getElementById('pageContent').style.display = 'none';

        try {
            var data = await api('/api/company-admin/compliance/assigned');
            if (data && data.success) {
                var allCompliances = data.data || [];
                var parentIdNum = parseInt(PARENT_ID);

                var targetEntry = allCompliances.find(function (c) {
                    return c.templateId === parentIdNum;
                });

                if (!targetEntry) {
                    targetEntry = allCompliances.find(function (c) {
                        return c.id === parentIdNum || c.companyComplianceId === parentIdNum;
                    });
                }

                if (!targetEntry) {
                    var templateEntries = allCompliances.filter(function (c) {
                        return c.templateId === parentIdNum;
                    });
                    if (templateEntries.length > 0) {
                        targetEntry = templateEntries[0];
                    }
                }

                if (!targetEntry) {
                    toast('Compliance not found', 'error');
                    document.getElementById('loader').innerHTML =
                        '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Compliance not found</p></div>';
                    return;
                }

                templateId = targetEntry.templateId;
                isCustomCompliance = targetEntry.isSuperAdminConfig === false;

                var allTemplateEntries = allCompliances.filter(function (c) {
                    return c.templateId === templateId;
                });

                var foundParentEntry = allTemplateEntries.find(function (c) {
                    return c.subTemplateId === null || c.subTemplateId === undefined;
                });

                var subCompliancesData = allTemplateEntries.filter(function (c) {
                    return c.subTemplateId !== null && c.subTemplateId !== undefined;
                });

                var subCompliances = subCompliancesData.map(function (s) {
                    return {
                        id: s.id,
                        companyComplianceId: s.companyComplianceId || s.id,
                        subTemplateId: s.subTemplateId,
                        subTemplateName: s.subTemplateName || "Sub-Compliance",
                        status: s.status || "PENDING",
                        dueDate: s.dueDate || s.effectiveDueDate,
                        frequency: s.frequency,
                        configured: s.configured === true,
                        isActive: s.isActive !== false,
                        description: s.description,
                        documentRequired: s.documentRequired,
                        externalLink: s.externalLink,
                        instructions: s.instructions,
                        reminderDaysBefore: s.reminderDaysBefore || 10,
                        completedAt: s.completedAt,
                        completedByName: s.completedByName,
                        submissionReference: s.notes,
                    };
                });

                var isParentConfigured = false;

                if (subCompliances.length > 0) {
                    isParentConfigured = subCompliances.some(function(s) {
                        return s.configured === true;
                    });
                } else {
                    if (foundParentEntry) {
                        isParentConfigured = foundParentEntry.configured === true;
                    } else {
                        isParentConfigured = targetEntry.configured === true;
                    }
                }

                // ===== FIX: Calculate overall status correctly =====
                var overallStatus = "PENDING";

                if (subCompliances.length > 0) {
                    if (subCompliances.every(function (s) {
                        return s.status === "COMPLETED";
                    })) {
                        overallStatus = "COMPLETED";
                    } else if (subCompliances.some(function (s) {
                        return s.status === "OVERDUE";
                    })) {
                        overallStatus = "OVERDUE";
                    } else if (subCompliances.some(function (s) {
                        return s.status === "IN_PROGRESS";
                    })) {
                        overallStatus = "IN_PROGRESS";
                    } else {
                        overallStatus = "PENDING";
                    }
                } else {
                    // No sub-compliances - get status from parent entry
                    if (foundParentEntry) {
                        overallStatus = foundParentEntry.status || "PENDING";
                    } else {
                        overallStatus = targetEntry.status || "PENDING";
                    }
                }

                parentData = {
                    templateName: targetEntry.templateName || "Compliance",
                    templateDescription: targetEntry.description || "",
                    isSuperAdminConfig: targetEntry.isSuperAdminConfig !== false,
                    isCustom: targetEntry.isSuperAdminConfig === false,
                    subCompliances: subCompliances,
                    totalSubCompliances: subCompliances.length,
                    configuredSubCompliances: subCompliances.filter(function (s) {
                        return s.configured === true;
                    }).length,
                    overallStatus: overallStatus,
                    isConfigured: isParentConfigured,
                    parentEntry: foundParentEntry,
                    targetEntry: targetEntry,
                    hasSubCompliances: subCompliances.length > 0,
                    parentComplianceId: foundParentEntry
                        ? foundParentEntry.companyComplianceId || foundParentEntry.id
                        : targetEntry.companyComplianceId || targetEntry.id,
                    templateId: templateId,
                };

                allSubCompliances = subCompliances;

                renderHeader();
                renderSubCompliances();

                if (parentData.hasSubCompliances) {
                    document.getElementById('parentConfigSection').style.display = 'none';
                    document.getElementById('subSection').style.display = 'block';
                    document.getElementById('subCountTab').textContent = subCompliances.length;
                    var hasPending = subCompliances.some(function (s) {
                        return s.status !== 'COMPLETED';
                    });
                    document.getElementById('markAllCompleteBtn').style.display =
                        hasPending ? 'inline-flex' : 'none';
                } else {
                    document.getElementById('parentConfigSection').style.display = 'block';
                    document.getElementById('subSection').style.display = 'none';
                    renderParentConfig();
                }

                updateAssignButton();
                document.getElementById('loader').style.display = 'none';
                document.getElementById('pageContent').style.display = 'block';
            } else {
                toast('Failed to load compliance details', 'error');
                document.getElementById('loader').style.display = 'none';
            }
        } catch (error) {
            console.error('Error loading parent details:', error);
            toast('Failed to load compliance details', 'error');
            document.getElementById('loader').style.display = 'none';
        }
    }

      // Find the calculateOverallStatus function and update it:

      function calculateOverallStatus(subs) {
          // ===== FIX: Handle case when there are no sub-compliances =====
          // When there are no sub-compliances, we need to check the parent's status directly
          if (!subs || !subs.length) {
              // If no sub-compliances, check if parent is completed
              // This will be handled by checking the parent entry's status
              // Return null to indicate we need to check parent status separately
              return null;
          }

          if (subs.every(function (s) {
              return s.status === "COMPLETED";
          })) return "COMPLETED";

          if (subs.some(function (s) {
              return s.status === "OVERDUE";
          })) return "OVERDUE";

          if (subs.some(function (s) {
              return s.status === "IN_PROGRESS";
          })) return "IN_PROGRESS";

          return "PENDING";
      }

    // ==================== RENDER HEADER ====================
      function renderHeader() {
          var p = parentData;
          var iconClass = getComplianceIcon(p.templateName);
          document.getElementById("breadcrumbName").textContent =
              p.templateName || "Compliance Details";
          document.getElementById("categoryName").textContent =
              p.templateName || "—";
          document.getElementById("categoryDesc").textContent =
              p.templateDescription || "No description provided";
          document.getElementById("heroIconEl").innerHTML =
              '<i class="fas ' + iconClass + '"></i>';

          var statusInfo = getStatusInfo(p.overallStatus);
          var typeLabel = p.isCustom ? "Custom" : "Admin Configured";
          var typeIcon = p.isCustom ? "fa-user-tie" : "fa-user-shield";
          var typeCls = p.isCustom ? "badge-custom" : "badge-primary";

          document.getElementById("heroBadges").innerHTML =
              '<span class="badge ' +
              statusInfo.cls +
              '"><i class="fas ' +
              statusInfo.icon +
              '"></i> ' +
              statusInfo.label +
              "</span>" +
              '<span class="badge ' +
              typeCls +
              '"><i class="fas ' +
              typeIcon +
              '"></i> ' +
              typeLabel +
              "</span>" +
              '<span class="badge badge-info"><i class="fas fa-list"></i> ' +
              (p.totalSubCompliances || 0) +
              " Sub-Compliances</span>" +
              (p.isConfigured
                  ? '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Configured</span>'
                  : '<span class="badge badge-warning"><i class="fas fa-clock"></i> Pending Setup</span>');

          var actionsHtml = "";

          // Show Assign button always if configured
          if (p.hasSubCompliances && p.configuredSubCompliances > 0) {
              actionsHtml +=
                  "<button onclick=\"window.location.href=contextPath+'/company-admin/compliance/parent/" +
                  PARENT_ID +
                  '/assign\'" class="vnext-btn vnext-btn-gold"><i class="fas fa-users"></i> Assign to Employees</button>';
          } else if (!p.hasSubCompliances && p.isConfigured) {
              actionsHtml +=
                  "<button onclick=\"window.location.href=contextPath+'/company-admin/compliance/assign?id=" +
                  PARENT_ID +
                  '\'" class="vnext-btn vnext-btn-gold"><i class="fas fa-users"></i> Assign to Employees</button>';
          }

          // ===== FIXED LOGIC for Custom Compliances =====
          if (p.isCustom) {
              // Case 1: No sub-compliances exist yet
              if (!p.hasSubCompliances) {
                  // If parent is configured (standalone mode) - ONLY show Edit Configuration, NO Add Sub-Compliance
                  if (p.isConfigured) {
                      actionsHtml +=
                          '<button onclick="openConfigModalForParent()" class="btn btn-primary"><i class="fas fa-edit"></i> Edit Configuration</button>';
                  } else {
                      // Parent not configured yet - show BOTH buttons
                      actionsHtml +=
                          '<button onclick="openAddSubModal()" class="btn btn-primary"><i class="fas fa-plus"></i> Add Sub-Compliance</button>';
                      actionsHtml +=
                          '<button onclick="openConfigModalForParent()" class="btn btn-success"><i class="fas fa-cog"></i> Configure Parent</button>';
                  }
              } else {
                  // Case 2: Sub-compliances exist
                  // Show ONLY Add Sub-Compliance (can add more)
                  actionsHtml +=
                      '<button onclick="openAddSubModal()" class="btn btn-primary"><i class="fas fa-plus"></i> Add Sub-Compliance</button>';

                  // Parent configuration is NOT allowed when sub-compliances exist
                  // Sub-compliances must be configured individually
              }
          } else {
              // For SuperAdmin-created compliances
              if (!p.isConfigured && !p.hasSubCompliances) {
                  actionsHtml +=
                      '<button onclick="openConfigModalForParent()" class="btn btn-success"><i class="fas fa-cog"></i> Configure</button>';
              }
          }

          document.getElementById("heroActions").innerHTML = actionsHtml;
      }

    // ==================== RENDER PARENT CONFIG ====================
   function renderParentConfig() {
       var p = parentData;
       var config = p.targetEntry || p.parentEntry;
       if (!config) {
           document.getElementById("parentConfigDetails").innerHTML =
               '<div class="empty-state">No configuration found</div>';
           return;
       }

       var isSuperAdmin = p.isSuperAdminConfig === true;
       // ===== FIX: Use overallStatus from parentData =====
       var isCompleted = p.overallStatus === "COMPLETED";
       var actionsHtml = "";

       if (isCompleted) {
           actionsHtml =
               '<span class="badge badge-success" style="font-size:12px;padding:6px 12px;"><i class="fas fa-check-circle"></i> Completed</span>' +
               ' <button onclick="openMarkCompleteModal(' +
               p.parentComplianceId +
               ", '" +
               escapeHtml(p.templateName) +
               '\')" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit Completion</button>';
       } else {
           actionsHtml =
               '<button onclick="openMarkCompleteModal(' +
               p.parentComplianceId +
               ", '" +
               escapeHtml(p.templateName) +
               '\')" class="btn btn-success btn-sm"><i class="fas fa-check-circle"></i> Mark as Complete</button>';
       }

       // For custom compliances, show Edit Config button
       if (p.isCustom) {
           actionsHtml +=
               ' <button onclick="openConfigModalForParent()" class="btn btn-ghost btn-sm"><i class="fas fa-edit"></i> Edit Config</button>';
       } else if (isSuperAdmin) {
           actionsHtml +=
               ' <span class="badge badge-locked"><i class="fas fa-lock"></i> Configured by Admin</span>';
       }

       document.getElementById("parentConfigActions").innerHTML = actionsHtml;

       var html = "";
       html +=
           '<div class="config-item"><div class="label">Frequency</div><div class="value">' +
           getFrequencyLabel(config.frequency) +
           "</div></div>";
       html +=
           '<div class="config-item"><div class="label">Due Date</div><div class="value">' +
           formatDate(config.dueDate) +
           "</div></div>";
       html +=
           '<div class="config-item"><div class="label">Reminder</div><div class="value">' +
           (config.reminderDaysBefore || 10) +
           " days before</div></div>";
       if (config.instructions) {
           html +=
               '<div class="config-item" style="grid-column:1/-1;"><div class="label">Instructions</div><div class="value" style="white-space:pre-line;font-size:13px;">' +
               escapeHtml(config.instructions) +
               "</div></div>";
       }
       if (config.documentRequired) {
           html +=
               '<div class="config-item"><div class="label">Required Documents</div><div class="value"><i class="fas fa-file-alt" style="color:var(--primary);"></i> ' +
               escapeHtml(config.documentRequired) +
               "</div></div>";
       }
       if (config.externalLink) {
           html +=
               '<div class="config-item"><div class="label">External Portal</div><div class="value"><a href="' +
               escapeHtml(config.externalLink) +
               '" target="_blank"><i class="fas fa-external-link-alt"></i> Open Portal</a></div></div>';
       }

       document.getElementById("parentConfigDetails").innerHTML = html;

       // ===== FIX: Show completion details when completed =====
       if (isCompleted) {
           // Try to get completion details from the config or parent entry
           var completionDetails = {
               completedBy: config.completedByName || "Company Admin",
               completedAt: config.completedAt || config.updatedAt,
               submissionReference: config.submissionReference || config.notes,
               submissionDocumentUrl: config.submissionDocumentUrl
           };

           var completionHtml =
               '<div class="completion-box" style="grid-column:1/-1;margin-top:4px;">' +
               '<div class="completion-title"><i class="fas fa-check-circle"></i> Completion Details</div>' +
               '<div class="comp-grid">' +
               '<div class="comp-item"><div class="comp-label">Completed By</div><div class="comp-value">' +
               escapeHtml(completionDetails.completedBy || "Company Admin") +
               "</div></div>" +
               '<div class="comp-item"><div class="comp-label">Completed On</div><div class="comp-value">' +
               formatDateTime(completionDetails.completedAt) +
               "</div></div>" +
               (completionDetails.submissionReference
                   ? '<div class="comp-item" style="grid-column:1/-1;"><div class="comp-label">Reference</div><div class="comp-value" style="font-family:monospace;">' +
                       escapeHtml(completionDetails.submissionReference) +
                       "</div></div>"
                   : "") +
               (completionDetails.submissionDocumentUrl
                   ? '<div class="comp-item" style="grid-column:1/-1;"><div class="comp-label">Document</div><div class="comp-value"><a href="' +
                       completionDetails.submissionDocumentUrl +
                       '" target="_blank" class="btn btn-ghost btn-sm"><i class="fas fa-file-alt"></i> View Document</a></div></div>'
                   : "") +
               "</div></div>";
           document.getElementById("parentConfigDetails").innerHTML += completionHtml;
       }
   }

    // ==================== RENDER SUB-COMPLIANCES ====================

      function renderSubCompliances() {
          var searchTerm = document
              .getElementById("searchSubCompliance")
              .value.toLowerCase();
          var statusFilter = document.getElementById("statusFilterSub").value;

          var filtered = allSubCompliances.filter(function (s) {
              if (
                  searchTerm &&
                  !(s.subTemplateName || "").toLowerCase().includes(searchTerm)
              ) return false;
              if (statusFilter !== "all" && s.status !== statusFilter) return false;
              return true;
          });

          var container = document.getElementById("subCompliancesGrid");
          if (!filtered.length) {
              container.innerHTML =
                  '<div class="empty-state"><i class="fas fa-folder-open"></i><p>No sub-compliances found</p></div>';
              return;
          }

          var html = "";
          for (var i = 0; i < filtered.length; i++) {
              var s = filtered[i];
              var status = s.status || "PENDING";
              var isCompleted = status === "COMPLETED";
              var isOverdue = status === "OVERDUE";
              var isInProgress = status === "IN_PROGRESS";
              var statusInfo = getStatusInfo(status);
              var cardClass =
                  "sub-card " +
                  (isCompleted
                      ? "completed"
                      : isOverdue
                          ? "overdue"
                          : isInProgress
                              ? "in-progress"
                              : "pending");
              var iconClass = getComplianceIcon(s.subTemplateName || "");
              var blinkerCls = getBlinkerClass(s.dueDate, status);
              var complianceId = s.companyComplianceId || s.id;

              var dueMetaClass = "sub-meta-item";
              var daysLabel = "";
              if (s.dueDate && !isCompleted) {
                  var days = getDaysRemaining(s.dueDate);
                  if (days !== null && !isNaN(days)) {
                      if (days < 0) {
                          daysLabel = " (Overdue)";
                          dueMetaClass += " overdue-text";
                      } else if (days <= 1) {
                          daysLabel = " (" + days + " day left)";
                          dueMetaClass += " warning-text";
                      } else if (days <= 7) {
                          daysLabel = " (" + days + " days left)";
                          if (days <= 3) dueMetaClass += " warning-text";
                      }
                  }
              }

              var isCustom = parentData && parentData.isCustom;

              // ===== FIX 1: Use 'configured' flag to determine if Complete button should be shown =====
              var isConfigured = s.configured === true;

              html +=
                  '<div class="' +
                  cardClass +
                  '">' +
                  '<div class="sub-card-inner">' +
                  '<div class="sub-card-header">' +
                  '<div class="sub-card-title-group">' +
                  '<div class="sub-icon"><i class="fas ' +
                  iconClass +
                  '"></i></div>' +
                  '<div class="sub-title-text">' +
                  '<div class="sub-name">' +
                  escapeHtml(s.subTemplateName || "Sub-Compliance #" + (i + 1)) +
                  "</div>" +
                  '<div class="sub-name-badges">' +
                  '<span class="badge ' +
                  statusInfo.cls +
                  '"><i class="fas ' +
                  statusInfo.icon +
                  '"></i> ' +
                  statusInfo.label +
                  "</span>" +
                  '<span class="badge badge-primary" style="font-size:10px;">' +
                  getFrequencyLabel(s.frequency) +
                  "</span>" +
                  '<span class="badge ' +
                  (isConfigured ? "badge-success" : "badge-warning") +
                  '" style="font-size:10px;">' +
                  (isConfigured ? "Configured" : "Pending Setup") +
                  "</span>" +
                  "</div>" +
                  "</div>" +
                  "</div>" +
                  '<div class="sub-actions">' +
                  (blinkerCls
                      ? '<span class="vnext-blinker ' +
                          blinkerCls +
                          '" style="margin-right:4px;"></span>'
                      : "") +
                  // ===== FIX 1: Only show Complete button if configured =====
                  (isConfigured
                      ? (!isCompleted
                          ? '<button onclick="event.stopPropagation();openMarkCompleteModal(' +
                              complianceId +
                              ",'" +
                              escapeHtml(s.subTemplateName) +
                              '\')" class="btn btn-success btn-sm" title="Mark as Complete"><i class="fas fa-check-circle"></i> Complete</button>'
                          : '<button onclick="event.stopPropagation();openCompletionDetailsModal(' +
                              i +
                              ')" class="btn btn-ghost btn-sm" title="View Details"><i class="fas fa-info-circle"></i> Details</button>')
                      : '<button class="btn btn-ghost btn-sm" disabled style="opacity:0.4;cursor:not-allowed;" title="Configure this sub-compliance first"><i class="fas fa-lock"></i> Not Configured</button>') +
                  // Show Configure/Edit button for custom sub-compliances
                  (isCustom
                      ? isConfigured
                          ? '<button onclick="event.stopPropagation();openConfigModalForSub(' +
                              s.subTemplateId +
                              ')" class="btn btn-ghost btn-sm" title="Edit Configuration"><i class="fas fa-edit"></i></button>'
                          : '<button onclick="event.stopPropagation();openConfigModalForSub(' +
                              s.subTemplateId +
                              ')" class="btn btn-success btn-sm" title="Configure"><i class="fas fa-cog"></i></button>'
                      : // For SuperAdmin-created, show View Config if configured
                      isConfigured
                          ? '<button onclick="event.stopPropagation();openConfigModalForSub(' +
                              s.subTemplateId +
                              ')" class="btn btn-ghost btn-sm" title="View Configuration"><i class="fas fa-eye"></i></button>'
                          : "") +
                  "</div>" +
                  "</div>" +
                  '<div class="sub-meta-row">' +
                  '<span class="' +
                  dueMetaClass +
                  '"><i class="fas fa-calendar-alt"></i>Due: ' +
                  formatDate(s.dueDate) +
                  daysLabel +
                  "</span>" +
                  '<span class="sub-meta-item"><i class="fas fa-redo"></i>' +
                  getFrequencyLabel(s.frequency) +
                  "</span>" +
                  '<span class="sub-meta-item"><i class="fas fa-bell"></i>Reminder: ' +
                  (s.reminderDaysBefore || 10) +
                  " days</span>" +
                  "</div>";

              if (s.description) {
                  html +=
                      '<div class="sub-description">' +
                      escapeHtml(s.description) +
                      "</div>";
              }

              html += '<div class="sub-details-grid">';
              if (s.documentRequired) {
                  html +=
                      '<div class="sub-detail-item"><div class="sub-detail-label">Required Docs</div><div class="sub-detail-value"><i class="fas fa-file-alt" style="color:var(--primary);font-size:11px;"></i> ' +
                      escapeHtml(s.documentRequired) +
                      "</div></div>";
              }
              if (s.externalLink) {
                  html +=
                      '<div class="sub-detail-item"><div class="sub-detail-label">Portal Link</div><div class="sub-detail-value"><a href="' +
                      escapeHtml(s.externalLink) +
                      '" target="_blank" style="color:var(--primary);"><i class="fas fa-external-link-alt"></i> Open Portal</a></div></div>';
              }
              html += "</div>";

              if (s.instructions) {
                  html +=
                      '<div class="sub-instructions"><i class="fas fa-info-circle" style="color:var(--primary);margin-right:4px;"></i>' +
                      escapeHtml(s.instructions) +
                      "</div>";
              }

              if (
                  isCompleted &&
                  (s.completedByName || s.completedAt || s.submissionReference)
              ) {
                  html +=
                      '<div class="completion-box">' +
                      '<div class="completion-title"><i class="fas fa-check-circle"></i> Completion Details</div>' +
                      '<div class="comp-grid">' +
                      (s.completedByName
                          ? '<div class="comp-item"><div class="comp-label">Completed By</div><div class="comp-value">' +
                              escapeHtml(s.completedByName) +
                              "</div></div>"
                          : '<div class="comp-item"><div class="comp-label">Completed By</div><div class="comp-value">Company Admin</div></div>') +
                      (s.completedAt
                          ? '<div class="comp-item"><div class="comp-label">Completed On</div><div class="comp-value">' +
                              formatDateTime(s.completedAt) +
                              "</div></div>"
                          : "") +
                      (s.submissionReference
                          ? '<div class="comp-item" style="grid-column:1/-1;"><div class="comp-label">Reference</div><div class="comp-value" style="font-family:monospace;font-size:12px;">' +
                              escapeHtml(s.submissionReference) +
                              "</div></div>"
                          : "") +
                      "</div></div>";
              }

              html += "</div></div>";
          }
          container.innerHTML = html;
      }



    // ==================== UPDATE ASSIGN BUTTON ====================
    function updateAssignButton() {
        // Handled in renderHeader() now
    }

    // ==================== CUSTOM COMPLIANCE MANAGEMENT FUNCTIONS ====================

    // Open Add Sub-Compliance Modal
    function openAddSubModal() {
        document.getElementById('subId').value = '';
        document.getElementById('subModalTitle').innerHTML = '<i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add Sub-Compliance';
        document.getElementById('subModalSubtitle').textContent = 'Create a sub-compliance under "' + (parentData ? parentData.templateName : 'this category') + '"';
        document.getElementById('subForm').reset();
        document.getElementById('subDisplayOrder').value = '0';
        document.getElementById('subModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeSubModal() {
        document.getElementById('subModal').style.display = 'none';
        document.body.style.overflow = '';
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
            parentTemplateId: parseInt(templateId)  // Use templateId, not PARENT_ID
        };

        var btn = document.getElementById('subSaveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

        // Use the template-based endpoint
        var data = await api('/api/company-admin/compliance/custom/template/' + templateId + '/sub-templates', {
            method: 'POST',
            body: JSON.stringify(payload)
        });

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (data && data.success) {
            toast('Sub-compliance added successfully', 'success');
            closeSubModal();
            loadParentDetails();
        } else {
            toast(data?.error || 'Failed to add sub-compliance', 'error');
        }
    }

    // Open Configure Modal for Parent
    function openConfigModalForParent() {
        document.getElementById('configTargetId').value = templateId;  // Use template ID
        document.getElementById('configTargetType').value = 'parent';

        var title = parentData && parentData.isConfigured ? 'Edit Configuration' : 'Configure Parent Compliance';
        var subtitle = 'Set up the compliance configuration';
        document.getElementById('configModalTitle').textContent = title;
        document.getElementById('configModalSubtitle').textContent = subtitle;

        // Pre-populate if config exists
        var config = parentData.targetEntry || parentData.parentEntry;
        if (config) {
            document.getElementById('configFrequency').value = config.frequency || 'ONE_TIME';
            document.getElementById('configDueDate').value = config.dueDate || '';
            document.getElementById('configInstructions').value = config.instructions || '';
            document.getElementById('configDocumentRequired').value = config.documentRequired || '';
            document.getElementById('configExternalLink').value = config.externalLink || '';
            document.getElementById('configReminderDays').value = config.reminderDaysBefore || 10;
            document.getElementById('configRepeatReminder').value = config.repeatReminder !== false ? 'true' : 'false';
            document.getElementById('configReminderIntervalDays').value = config.reminderIntervalDays || 3;
            showConfigSections(config.frequency || 'ONE_TIME');
        } else {
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

        document.getElementById('configModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    // Open Configure Modal for Sub-Compliance
    function openConfigModalForSub(subTemplateId) {
        document.getElementById('configTargetId').value = subTemplateId;
        document.getElementById('configTargetType').value = 'sub';

        var title = 'Configure Sub-Compliance';
        var subtitle = 'Set up this sub-compliance configuration';
        document.getElementById('configModalTitle').textContent = title;
        document.getElementById('configModalSubtitle').textContent = subtitle;

        // Try to load existing config
        var sub = allSubCompliances.find(function(s) { return s.subTemplateId === subTemplateId; });
        if (sub && sub.isActive) {
            document.getElementById('configFrequency').value = sub.frequency || 'ONE_TIME';
            document.getElementById('configDueDate').value = sub.dueDate || '';
            document.getElementById('configInstructions').value = sub.instructions || '';
            document.getElementById('configDocumentRequired').value = sub.documentRequired || '';
            document.getElementById('configExternalLink').value = sub.externalLink || '';
            document.getElementById('configReminderDays').value = sub.reminderDaysBefore || 10;
            showConfigSections(sub.frequency || 'ONE_TIME');
        } else {
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

        document.getElementById('configModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
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
        var sections = ['configDueDateSection', 'configMonthlySection', 'configQuarterlySection', 'configHalfYearlySection', 'configYearlySection'];
        for (var i = 0; i < sections.length; i++) {
            document.getElementById(sections[i]).style.display = 'none';
        }

        if (frequency === 'ONE_TIME') {
            document.getElementById('configDueDateSection').style.display = 'block';
        } else if (frequency === 'MONTHLY') {
            document.getElementById('configMonthlySection').style.display = 'block';
        } else if (frequency === 'QUARTERLY') {
            document.getElementById('configQuarterlySection').style.display = 'block';
        } else if (frequency === 'HALF_YEARLY') {
            document.getElementById('configHalfYearlySection').style.display = 'block';
        } else if (frequency === 'YEARLY') {
            document.getElementById('configYearlySection').style.display = 'block';
        }
    }

    async function saveConfig() {
        var targetId = parseInt(document.getElementById('configTargetId').value);
        var targetType = document.getElementById('configTargetType').value;
        var frequency = document.getElementById('configFrequency').value;

        var payload = {
            frequency: frequency,
            reminderDaysBefore: parseInt(document.getElementById('configReminderDays').value),
            repeatReminder: document.getElementById('configRepeatReminder').value === 'true',
            reminderIntervalDays: parseInt(document.getElementById('configReminderIntervalDays').value),
            instructions: document.getElementById('configInstructions').value || null,
            documentRequired: document.getElementById('configDocumentRequired').value || null,
            externalLink: document.getElementById('configExternalLink').value || null
        };

        if (frequency === 'ONE_TIME') {
            payload.customDueDate = document.getElementById('configDueDate').value || null;
        } else if (frequency === 'MONTHLY') {
            payload.dueDayOfMonth = parseInt(document.getElementById('configDueDayOfMonth').value);
        } else if (frequency === 'QUARTERLY') {
            payload.dueQuarter = parseInt(document.getElementById('configDueQuarter').value);
            payload.dueDayOfMonth = parseInt(document.getElementById('configDueDayOfMonthQ').value);
        } else if (frequency === 'HALF_YEARLY') {
            payload.dueHalf = parseInt(document.getElementById('configDueHalf').value);
            payload.dueDayOfMonth = parseInt(document.getElementById('configDueDayOfMonthH').value);
        } else if (frequency === 'YEARLY') {
            payload.dueMonth = parseInt(document.getElementById('configDueMonth').value);
            payload.dueDayOfMonth = parseInt(document.getElementById('configDueDayOfMonthY').value);
        }

        var btn = document.getElementById('configSaveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

        var url, method;
        if (targetType === 'parent') {
            // Use the template-based endpoint for parent configuration
            url = '/api/company-admin/compliance/custom/template/' + targetId + '/configure';
            method = 'POST';
        } else {
            // For sub-compliance - use the existing endpoint
            url = '/api/company-admin/compliance/sub-configure';
            method = 'POST';
            payload.subTemplateId = targetId;
        }

        var data = await api(url, {
            method: method,
            body: JSON.stringify(payload)
        });

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (data && data.success) {
            toast('Compliance configured successfully', 'success');
            closeConfigModal();
            loadParentDetails();
        } else {
            toast(data?.error || 'Failed to configure compliance', 'error');
        }
    }

    // ==================== MARK COMPLETE FUNCTIONS ====================
    async function openMarkCompleteModal(complianceId, complianceName) {
        document.getElementById("markCompleteId").value = complianceId;
        document.getElementById("markCompleteSubName").textContent =
            '"' + complianceName + '"';

        // Check if already completed - use the correct endpoint
        try {
            // Get the current status from parentData
            if (parentData && parentData.overallStatus === "COMPLETED") {
                document.getElementById("markCompleteReference").value =
                    parentData.targetEntry?.submissionReference ||
                    parentData.parentEntry?.submissionReference || "";
                document.getElementById("completionStatusInfo").style.display = "flex";
                document.getElementById("markCompleteSaveBtn").innerHTML =
                    '<i class="fas fa-edit"></i> Update';
            } else {
                document.getElementById("markCompleteReference").value = "";
                document.getElementById("completionStatusInfo").style.display = "none";
                document.getElementById("markCompleteSaveBtn").innerHTML =
                    '<i class="fas fa-check-circle"></i> Mark as Complete';
            }
        } catch(e) {
            document.getElementById("markCompleteReference").value = "";
            document.getElementById("completionStatusInfo").style.display = "none";
            document.getElementById("markCompleteSaveBtn").innerHTML =
                '<i class="fas fa-check-circle"></i> Mark as Complete';
        }

        document.getElementById("markCompleteDocument").value = "";
        document.getElementById("markCompleteModal").style.display = "flex";
        document.body.style.overflow = "hidden";
    }

    function closeMarkCompleteModal() {
        document.getElementById('markCompleteModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function submitMarkComplete() {
        var subId = document.getElementById('markCompleteId').value;
        var reference = document.getElementById('markCompleteReference').value.trim();
        var documentFile = document.getElementById('markCompleteDocument').files[0];

        if (!reference && !documentFile) {
            toast('Please provide at least a reference number or document', 'error');
            return;
        }

        if (!confirm('Are you sure you want to mark this compliance as completed?\n\nThis will be recorded as an admin action.')) return;

        var btn = document.getElementById('markCompleteSaveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';

        var formData = new FormData();
        formData.append('submissionReference', reference);
        if (documentFile) formData.append('document', documentFile);

        try {
            var token = localStorage.getItem('accessToken');
            var response = await fetch(contextPath + '/api/company-admin/compliance/' + subId + '/mark-complete', {
                method: 'POST',
                headers: { 'Authorization': 'Bearer ' + token },
                body: formData
            });
            var data = await response.json();

            if (data && data.success) {
                toast('Compliance marked as completed by Admin!', 'success');
                closeMarkCompleteModal();
                setTimeout(function() {
                    loadParentDetails();
                }, 1000);
            } else {
                toast((data && data.error) || 'Failed to mark as complete', 'error');
                btn.disabled = false;
                btn.innerHTML = originalText;
            }
        } catch (error) {
            console.error('Error marking complete:', error);
            toast('Failed to mark as complete', 'error');
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    }

    // ==================== COMPLETION DETAILS MODAL ====================
    function openCompletionDetailsModal(index) {
        var s = allSubCompliances[index];
        if (!s) return;

        document.getElementById('completionDetailsSubName').textContent = s.subTemplateName || 'Sub-Compliance';

        var html = '<div style="background:rgba(16,185,129,0.06);border:1px solid rgba(16,185,129,0.15);border-radius:10px;padding:20px;">' +
            '<div style="display:flex;align-items:center;gap:10px;margin-bottom:14px;">' +
            '<i class="fas fa-check-circle" style="color:var(--success);font-size:24px;"></i>' +
            '<span style="font-weight:700;font-size:17px;color:var(--success);">Completed Successfully</span>' +
            '</div>' +
            '<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:12px;">' +
            '<div><div style="font-size:10px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.4px;font-weight:600;">Completed By</div>' +
            '<div style="font-size:14px;font-weight:600;color:var(--gray-900);margin-top:3px;">' + escapeHtml(s.completedByName || 'Company Admin') + '</div></div>';

        if (s.completedAt) {
            html += '<div><div style="font-size:10px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.4px;font-weight:600;">Completed On</div><div style="font-size:14px;font-weight:600;color:var(--gray-900);margin-top:3px;">' + formatDateTime(s.completedAt) + '</div></div>';
        }

        if (s.submissionReference) {
            html += '<div style="grid-column:1/-1;"><div style="font-size:10px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.4px;font-weight:600;">Reference Number</div><div style="font-size:14px;font-weight:600;color:var(--gray-900);margin-top:3px;font-family:monospace;">' + escapeHtml(s.submissionReference) + '</div></div>';
        }

        html += '</div></div>';
        document.getElementById('completionDetailsBody').innerHTML = html;
        document.getElementById('completionDetailsModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeCompletionDetailsModal() {
        document.getElementById('completionDetailsModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    // ==================== FILTER FUNCTIONS ====================
    function filterSubCompliances() {
        renderSubCompliances();
    }

    function markAllSubsComplete() {
        if (!allSubCompliances.length) {
            toast('No sub-compliances to mark', 'error');
            return;
        }
        var pending = allSubCompliances.filter(function(s) { return s.status !== 'COMPLETED'; });
        if (!pending.length) {
            toast('All sub-compliances are already completed!', 'info');
            return;
        }
        if (!confirm('Are you sure you want to mark all ' + pending.length + ' pending sub-compliances as completed?')) return;
        toast('Please mark each sub-compliance individually for now.', 'info');
    }

    // ==================== MODAL OVERLAY CLOSE ====================
    document.getElementById('subModal').addEventListener('click', function(e) {
        if (e.target === this) closeSubModal();
    });

    document.getElementById('configModal').addEventListener('click', function(e) {
        if (e.target === this) closeConfigModal();
    });

    document.getElementById('markCompleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeMarkCompleteModal();
    });

    document.getElementById('completionDetailsModal').addEventListener('click', function(e) {
        if (e.target === this) closeCompletionDetailsModal();
    });

    // ==================== EVENT LISTENERS ====================
    document.getElementById('searchSubCompliance').addEventListener('input', filterSubCompliances);
    document.getElementById('statusFilterSub').addEventListener('change', filterSubCompliances);

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        var userStr = localStorage.getItem('user');
        if (userStr) {
            try {
                var u = JSON.parse(userStr);
                document.getElementById('userName').textContent = u.firstName + ' ' + u.lastName;
                document.getElementById('userAvatar').textContent = (u.firstName || 'U')[0] + (u.lastName || '')[0];
                document.getElementById('userRole').textContent = (u.role || '').replace('_', ' ');
            } catch(e) {}
        }

        loadParentDetails();
        loadNotifications();
    });
</script>

</body>
</html>