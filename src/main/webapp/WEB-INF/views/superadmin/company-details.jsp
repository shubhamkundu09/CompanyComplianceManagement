<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- File: superadmin/company-details.jsp --%>

<%
    String originalUri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (originalUri == null) originalUri = request.getRequestURI();
    String companyId = null;
    String[] parts = originalUri.split("/");
    if (parts.length > 0) {
        String last = parts[parts.length - 1];
        if (last.contains("?")) last = last.substring(0, last.indexOf("?"));
        try { Long.parseLong(last); companyId = last; } catch (NumberFormatException e) { companyId = null; }
    }
    if (companyId == null || companyId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/super-admin/companies");
        return;
    }
    pageContext.setAttribute("companyId", companyId);
    pageContext.setAttribute("pageTitle", "Company Details");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Company Details</title>

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
            font-size: 12px;
            color: var(--gray-500);
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
            font-size: 9px;
            color: var(--gray-400);
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

        .card-title {
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }

        .card-title i {
            margin-right: 6px;
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
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
        }

        .avatar-sm {
            width: 38px;
            height: 38px;
            font-size: 14px;
        }

        /* ==================== PROGRESS BAR ==================== */
        .progress-bar {
            height: 4px;
            background: rgba(226, 232, 240, 0.5);
            border-radius: 2px;
            overflow: hidden;
            width: 100%;
        }

        .progress-bar .progress-fill {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s ease;
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

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .col-2 {
            grid-column: span 2;
        }

        /* ==================== INFO ROW ==================== */
        .info-row {
            display: flex;
            flex-direction: column;
            gap: 2px;
            padding: 6px 0;
        }

        .info-row .lbl {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .info-row .val {
            font-size: 13px;
            color: var(--gray-800);
            font-weight: 500;
            word-break: break-all;
        }

        .info-row .val a {
            color: var(--primary);
            text-decoration: none;
        }

        .info-row .val a:hover {
            text-decoration: underline;
        }

        /* ==================== DETAILS GRID ==================== */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 320px;
            gap: 20px;
        }

        /* ==================== SUB-COMPLIANCE LIST ==================== */
        .sub-list-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 4px 0;
            font-size: 11px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.3);
        }

        .sub-list-item:last-child {
            border-bottom: none;
        }

        .sub-badge-tiny {
            font-size: 8px;
            padding: 1px 6px;
            border-radius: 10px;
            font-weight: 500;
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
            max-width: 650px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        .modal-box.wide {
            max-width: 860px;
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

        .modal-footer .flex-left {
            flex: 1;
        }

        .modal-section-title {
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }

        .modal-section-title i {
            margin-right: 6px;
        }

        /* ==================== TABLE ==================== */
        .table-wrapper {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead th {
            padding: 10px 16px;
            text-align: left;
            font-size: 11px;
            font-weight: 600;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            background: rgba(255, 255, 255, 0.3);
        }

        .data-table tbody td {
            padding: 12px 16px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.3);
            font-size: 13px;
            color: var(--gray-700);
        }

        .data-table tbody tr:hover {
            background: rgba(79, 70, 229, 0.04);
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .data-table a {
            color: var(--gray-800);
            text-decoration: none;
            font-weight: 500;
        }

        .data-table a:hover {
            color: var(--primary);
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 40px;
            opacity: 0.3;
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

        .spinner-sm {
            width: 24px;
            height: 24px;
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

        /* ==================== DOCUMENT ITEM ==================== */
        .doc-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 12px;
            background: rgba(226, 232, 240, 0.15);
            border-radius: var(--radius);
            margin-bottom: 6px;
        }

        .doc-item:last-child {
            margin-bottom: 0;
        }

        .doc-item .doc-info {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            min-width: 0;
        }

        .doc-item .doc-info i {
            font-size: 14px;
            flex-shrink: 0;
        }

        .doc-item .doc-info .doc-name {
            font-size: 12px;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .doc-item .doc-info .doc-meta {
            font-size: 10px;
            color: var(--gray-500);
        }

        .doc-item .doc-actions {
            display: flex;
            gap: 4px;
            flex-shrink: 0;
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
            .details-grid {
                grid-template-columns: 1fr 1fr !important;
            }
            .grid-2 { grid-template-columns: 1fr; }
            .col-2 { grid-column: span 1; }
            .modal-box { max-width: 100%; margin: 10px; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .details-grid {
                grid-template-columns: 1fr !important;
            }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
            .data-table thead th, .data-table tbody td { padding: 8px 10px; font-size: 12px; }
            .doc-item { flex-wrap: wrap; gap: 6px; }
            .doc-item .doc-actions { width: 100%; justify-content: flex-end; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
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
        <a href="${baseUrl}/super-admin/companies" class="nav-item active">
            <i class="fas fa-building"></i> Companies
        </a>

        <div class="sidebar-label">Compliance</div>
        <a href="${baseUrl}/super-admin/compliance/templates" class="nav-item">
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
            <span class="page-title">Company Details</span>
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
            <a href="${baseUrl}/super-admin/companies">Companies</a>
            <i class="fas fa-chevron-right sep"></i>
            <span id="breadcrumbName">Loading…</span>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" style="display:flex;align-items:center;justify-content:center;padding:80px 0;">
            <div style="text-align:center;">
                <div class="spinner"></div>
                <div style="color:var(--gray-500);font-size:13px;margin-top:12px;">Loading company details…</div>
            </div>
        </div>

        <!-- ==================== PAGE CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- Page Header -->
            <div style="margin-bottom:24px;display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px;">
                <div style="display:flex;align-items:center;gap:14px;">
                    <div class="avatar" id="compAvatar">?</div>
                    <div>
                        <h1 style="font-size:22px;font-weight:700;color:var(--gray-900);" id="compName">—</h1>
                        <div style="font-size:13px;color:var(--gray-500);" id="compEmail">—</div>
                    </div>
                    <span id="compStatusBadge" class="badge" style="margin-left:8px;"></span>
                </div>
                <div style="display:flex;gap:8px;flex-wrap:wrap;">
                    <button onclick="openEditModal()" class="btn btn-primary"><i class="fas fa-edit"></i> Edit</button>
                    <button onclick="openExtendModal()" class="btn btn-ghost"><i class="fas fa-calendar-plus"></i> Extend Sub</button>
                    <button onclick="toggleCompanyStatus()" class="btn btn-ghost" id="statusToggleBtn"></button>
                </div>
            </div>

            <!-- ==================== DETAILS GRID ==================== -->
            <div class="details-grid">

                <!-- Col 1: Company Info -->
                <div>
                    <div class="card" style="padding:20px;">
                        <div class="card-title"><i class="fas fa-building"></i>Company Information</div>
                        <div id="compInfoGrid" style="display:grid;gap:4px;"></div>
                    </div>

                    <div class="card" style="padding:20px;margin-top:20px;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;padding-bottom:8px;border-bottom:1px solid rgba(226,232,240,0.5);">
                            <div class="card-title" style="margin-bottom:0;padding-bottom:0;border-bottom:none;">
                                <i class="fas fa-paperclip"></i>Documents
                            </div>
                            <label for="detailDocUpload" class="btn btn-ghost" style="padding:4px 10px;font-size:11px;cursor:pointer;margin:0;">
                                <i class="fas fa-plus"></i> Upload
                            </label>
                            <input type="file" id="detailDocUpload" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png" style="display:none;" onchange="uploadCompanyDocs(this)">
                        </div>
                        <div id="companyDocumentsList">
                            <div style="color:var(--gray-500);font-size:13px;text-align:center;padding:20px;">Loading documents...</div>
                        </div>
                    </div>
                </div>

                <!-- Col 2: Admin + Address -->
                <div style="display:flex;flex-direction:column;gap:20px;">
                    <div class="card" style="padding:20px;">
                        <div class="card-title"><i class="fas fa-user-shield"></i>Company Admin</div>
                        <div id="adminInfoGrid" style="display:grid;gap:4px;"></div>
                    </div>
                    <div class="card" style="padding:20px;">
                        <div class="card-title"><i class="fas fa-map-marker-alt"></i>Address</div>
                        <div id="addressInfoGrid" style="display:grid;gap:4px;"></div>
                    </div>
                </div>

                <!-- Col 3: Status Panel -->
                <div style="display:flex;flex-direction:column;gap:20px;">
                    <div class="card" style="padding:20px;">
                        <div class="card-title"><i class="fas fa-chart-line"></i>Status &amp; Limits</div>
                        <div id="statusPanel"></div>
                        <div style="margin-top:12px;display:flex;flex-direction:column;gap:8px;" id="actionBtns"></div>
                    </div>

                    <div class="card" style="padding:20px;">
                        <div class="card-title"><i class="fas fa-calendar-alt"></i>Subscription</div>
                        <div id="subscriptionPanel"></div>
                    </div>
                </div>
            </div>

            <!-- ==================== COMPLIANCE CATEGORIES SECTION ==================== -->
            <div class="card" style="margin-top:20px;padding:20px;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;padding-bottom:12px;border-bottom:1px solid rgba(226,232,240,0.5);flex-wrap:wrap;gap:10px;">
                    <div>
                        <div style="font-size:11px;font-weight:700;color:var(--primary);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:4px;">
                            <i class="fas fa-tags" style="margin-right:6px;"></i>Compliance Management
                        </div>
                        <h3 style="font-size:16px;font-weight:700;color:var(--gray-900);">Assigned Compliance Categories</h3>
                        <p style="font-size:12px;color:var(--gray-500);margin-top:2px;">Manage which compliance categories this company has access to</p>
                    </div>
                    <button onclick="openAssignComplianceModal()" class="btn btn-primary" id="assignComplianceBtn">
                        <i class="fas fa-plus-circle"></i> Assign Category
                    </button>
                </div>

                <!-- Filter Bar -->
                <div style="display:flex;gap:12px;margin-bottom:16px;flex-wrap:wrap;">
                    <div style="flex:1;min-width:180px;">
                        <input type="text" id="complianceSearch" class="form-input" placeholder="Search categories..." onkeyup="filterComplianceList()">
                    </div>
                    <div style="min-width:140px;">
                        <select id="complianceStatusFilter" class="form-input" onchange="filterComplianceList()">
                            <option value="all">All Status</option>
                            <option value="active">Active Only</option>
                            <option value="inactive">Inactive Only</option>
                        </select>
                    </div>
                    <button onclick="refreshComplianceList()" class="btn btn-ghost">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>

                <!-- Compliance Loader -->
                <div id="complianceLoader" style="text-align:center;padding:40px;display:none;">
                    <div class="spinner" style="margin:0 auto 12px;"></div>
                    <div style="color:var(--gray-500);">Loading assigned categories...</div>
                </div>

                <!-- Compliance Table -->
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Category Name</th>
                                <th>Sub-Compliances</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Configuration</th>
                                <th>Assigned Date</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="complianceTableBody">
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state" style="padding:40px;">
                                        <i class="fas fa-folder-open" style="font-size:36px;opacity:0.3;"></i>
                                        <p style="margin-top:10px;">No compliance categories assigned yet</p>
                                        <button onclick="openAssignComplianceModal()" class="btn btn-primary" style="margin-top:12px;">
                                            <i class="fas fa-plus"></i> Assign First Category
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /pageContent -->

    </main>
</div>

<!-- ==================== EDIT MODAL ==================== -->
<div id="editModal" class="modal-overlay">
    <div class="modal-box wide">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-edit" style="color:var(--primary);margin-right:8px;"></i>Edit Company</div>
                <div class="modal-subtitle">Update company information and admin details</div>
            </div>
            <button class="modal-close" onclick="closeEditModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div style="margin-bottom:16px;font-size:13px;font-weight:600;color:var(--primary);">
                <i class="fas fa-building"></i> Company Information
            </div>
            <div class="grid-2">
                <div>
                    <label class="form-label">Company Name <span style="color:var(--danger);">*</span></label>
                    <input id="e_name" class="form-input" type="text">
                </div>
                <div>
                    <label class="form-label">Company Email <span style="color:var(--danger);">*</span></label>
                    <input id="e_email" class="form-input" type="email">
                </div>
                <div>
                    <label class="form-label">Phone</label>
                    <input id="e_phone" class="form-input" type="text">
                </div>
                <div>
                    <label class="form-label">Website</label>
                    <input id="e_website" class="form-input" type="text">
                </div>
                <div>
                    <label class="form-label">GST Number</label>
                    <input id="e_gst" class="form-input" style="text-transform:uppercase;">
                </div>
                <div>
                    <label class="form-label">PAN Number</label>
                    <input id="e_pan" class="form-input" style="text-transform:uppercase;">
                </div>
                <div class="col-2">
                    <label class="form-label">Address</label>
                    <textarea id="e_address" class="form-input" rows="2"></textarea>
                </div>
                <div>
                    <label class="form-label">City</label>
                    <input id="e_city" class="form-input">
                </div>
                <div>
                    <label class="form-label">State</label>
                    <input id="e_state" class="form-input">
                </div>
                <div>
                    <label class="form-label">Country</label>
                    <input id="e_country" class="form-input">
                </div>
                <div>
                    <label class="form-label">Postal Code</label>
                    <input id="e_postal" class="form-input">
                </div>
                <div>
                    <label class="form-label">Tax ID</label>
                    <input id="e_taxid" class="form-input">
                </div>
                <div class="col-2">
                    <label class="form-label">Description</label>
                    <textarea id="e_desc" class="form-input" rows="2"></textarea>
                </div>
            </div>

            <div style="margin:20px 0 16px 0;font-size:13px;font-weight:600;color:var(--primary);border-top:1px solid rgba(226,232,240,0.5);padding-top:20px;">
                <i class="fas fa-user-shield"></i> Company Admin Details (Readonly - NO CHANGE)
            </div>
            <div class="grid-2">
                <div>
                    <label class="form-label">Admin First Name <span style="color:var(--danger);">*</span></label>
                    <input id="e_adminFirst" class="form-input" type="text">
                </div>
                <div>
                    <label class="form-label">Admin Last Name <span style="color:var(--danger);">*</span></label>
                    <input id="e_adminLast" class="form-input" type="text">
                </div>
                <div class="col-2">
                    <label class="form-label">Admin Email <span style="color:var(--danger);">*</span></label>
                    <input id="e_adminEmail" class="form-input" type="email">
                </div>
                <div class="col-2">
                    <label class="form-label">Admin Phone</label>
                    <input id="e_adminPhone" class="form-input" type="text">
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeEditModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="submitEdit()" class="btn btn-primary" id="editSubmitBtn">
                <i class="fas fa-save"></i> Save Changes
            </button>
        </div>
    </div>
</div>

<!-- ==================== EXTEND SUBSCRIPTION MODAL ==================== -->
<div id="extendModal" class="modal-overlay">
    <div class="modal-box" style="max-width:440px;">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-calendar-plus" style="color:var(--primary);margin-right:8px;"></i>Extend Subscription</div>
                <div class="modal-subtitle">Add months to the current subscription</div>
            </div>
            <button class="modal-close" onclick="closeExtendModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <label class="form-label">Number of Months to Add</label>
            <input id="extMonths" class="form-input" type="number" min="1" max="60" value="12" style="font-size:18px;text-align:center;padding:12px;">
            <div style="font-size:12px;color:var(--gray-500);margin-top:8px;text-align:center;">New end date will be calculated from current end date</div>
        </div>
        <div class="modal-footer">
            <button onclick="closeExtendModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="submitExtend()" class="btn btn-primary"><i class="fas fa-calendar-plus"></i> Extend</button>
        </div>
    </div>
</div>

<!-- ==================== EMPLOYEE LIMIT MODAL ==================== -->
<div id="limitModal" class="modal-overlay">
    <div class="modal-box" style="max-width:400px;">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-users" style="color:var(--primary);margin-right:8px;"></i>Update Employee Limit</div>
                <div class="modal-subtitle">Set the maximum number of employees</div>
            </div>
            <button class="modal-close" onclick="closeLimitModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <label class="form-label">New Employee Limit</label>
            <input id="newLimit" class="form-input" type="number" min="1" style="font-size:18px;text-align:center;padding:12px;">
            <div id="limitNote" style="font-size:12px;color:var(--gray-500);margin-top:6px;text-align:center;"></div>
        </div>
        <div class="modal-footer">
            <button onclick="closeLimitModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="submitLimit()" class="btn btn-primary"><i class="fas fa-users"></i> Update</button>
        </div>
    </div>
</div>

<!-- ==================== ASSIGN COMPLIANCE MODAL ==================== -->
<div id="assignComplianceModal" class="modal-overlay">
    <div class="modal-box wide">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Assign Compliance Category</div>
                <div class="modal-subtitle">Select categories to assign to <span id="assignCompanyName">this company</span></div>
            </div>
            <button class="modal-close" onclick="closeAssignComplianceModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div style="display:flex;gap:10px;margin-bottom:16px;">
                <div style="flex:1;">
                    <input type="text" id="assignSearchInput" class="form-input" placeholder="Search categories..." onkeyup="filterAssignableList()">
                </div>
                <div style="min-width:140px;">
                    <select id="assignStatusFilter" class="form-input" onchange="filterAssignableList()">
                        <option value="all">All Status</option>
                        <option value="active">Active Only</option>
                    </select>
                </div>
            </div>
            <div id="assignCategoriesList" style="display:flex;flex-direction:column;gap:8px;max-height:300px;overflow-y:auto;">
                <div style="text-align:center;padding:40px;">
                    <div class="spinner" style="margin:0 auto 12px;"></div>
                    Loading categories...
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <div class="flex-left">
                <span id="selectedCategoriesCount" style="font-size:12px;color:var(--primary);">0 selected</span>
            </div>
            <button onclick="closeAssignComplianceModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveComplianceAssignments()" class="btn btn-primary" id="saveAssignBtn">
                <i class="fas fa-save"></i> Assign Selected
            </button>
        </div>
    </div>
</div>

<!-- ==================== CONFIRM REMOVE MODAL ==================== -->
<div id="confirmRemoveModal" class="modal-overlay">
    <div class="modal-box" style="max-width:450px;">
        <div class="modal-header">
            <div>
                <div class="modal-title" style="color:var(--danger);"><i class="fas fa-exclamation-triangle" style="margin-right:8px;"></i>Remove Category</div>
                <div class="modal-subtitle">This action cannot be undone</div>
            </div>
            <button class="modal-close" onclick="closeConfirmRemoveModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to remove <strong id="removeCategoryName"></strong> from this company?</p>
            <div id="removeWarning" style="background:rgba(239,68,68,0.08);border-left:3px solid var(--danger);padding:12px;margin-top:12px;border-radius:6px;display:none;">
                <i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i>
                <span style="font-size:12px;color:var(--danger);margin-left:6px;">Warning: This will also delete all configurations and employee assignments for this compliance!</span>
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeConfirmRemoveModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmRemoveCompliance()" class="btn btn-danger">Remove Category</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var CID = '<%= companyId %>';
    var companyData = null;
    var assignedCompliances = [];
    var pendingRemoveId = null;
    var allAssignableCategories = [];
    var selectedAssignableIds = new Set();

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

    // ==================== INFO ROW HELPER ====================
    function infoRow(label, value) {
        return '<div class="info-row"><span class="lbl">' + label + '</span><span class="val">' + (value || '<span style="color:var(--gray-400);">—</span>') + '</span></div>';
    }

    // ==================== LOAD COMPANY ====================
    async function loadCompany() {
        var data = await api('/api/super-admin/companies/' + CID);
        if (!data || !data.success) {
            toast('Company not found', 'error');
            setTimeout(function() { window.location.href = contextPath + '/super-admin/companies'; }, 2000);
            return;
        }
        companyData = data.data;
        renderAll();
        loadCompanyDocuments();
        loadAssignedCompliances();
        document.getElementById('loader').style.display = 'none';
        document.getElementById('pageContent').style.display = 'block';
    }

    function renderAll() {
        var c = companyData;
        var isActive = c.status === 'ACTIVE';
        var admin = c.companyAdmin;

        // Header
        document.getElementById('breadcrumbName').textContent = c.name;
        document.getElementById('compName').textContent = c.name;
        document.getElementById('compEmail').textContent = c.email;
        document.getElementById('compAvatar').textContent = (c.name || '?')[0].toUpperCase();

        var badge = document.getElementById('compStatusBadge');
        badge.className = 'badge ' + (isActive ? 'badge-active' : 'badge-inactive');
        badge.innerHTML = '<i class="fas fa-circle" style="font-size:5px;margin-right:4px;"></i>' + c.status;

        var toggleBtn = document.getElementById('statusToggleBtn');
        toggleBtn.className = 'btn ' + (isActive ? 'btn-danger' : 'btn-success');
        toggleBtn.innerHTML = isActive ? '<i class="fas fa-ban"></i> Deactivate' : '<i class="fas fa-check"></i> Activate';

        // Company Info
        document.getElementById('compInfoGrid').innerHTML =
            infoRow('Company Name', escapeHtml(c.name)) +
            infoRow('Email', escapeHtml(c.email)) +
            infoRow('Phone', c.phone) +
            infoRow('Website', c.website ? '<a href="' + escapeHtml(c.website) + '" target="_blank">' + escapeHtml(c.website) + '</a>' : null) +
            infoRow('GST Number', c.gstNumber) +
            infoRow('PAN Number', c.panNumber) +
            infoRow('Tax ID', c.taxId) +
            infoRow('Reg Number', c.registrationNumber) +
            infoRow('Description', c.description ? '<span style="font-size:12px;line-height:1.5;">' + escapeHtml(c.description) + '</span>' : null);

        // Admin Info
        document.getElementById('adminInfoGrid').innerHTML = admin ?
            '<div style="display:flex;align-items:center;gap:10px;margin-bottom:10px;">' +
            '<div class="avatar avatar-sm">' + ((admin.firstName || '?')[0]) + '</div>' +
            '<div><div style="font-weight:600;">' + escapeHtml((admin.firstName || '') + ' ' + (admin.lastName || '')) + '</div>' +
            '<span class="badge ' + (admin.status === 'ACTIVE' ? 'badge-active' : 'badge-inactive') + '" style="font-size:10px;">' + (admin.status || '—') + '</span></div>' +
            '</div>' +
            infoRow('Email', escapeHtml(admin.email)) +
            infoRow('Phone', admin.phoneNumber) +
            infoRow('Member Since', formatDate(admin.createdAt)) :
            '<div style="color:var(--gray-500);font-size:13px;padding:8px 0;">No admin assigned</div>';

        // Address
        document.getElementById('addressInfoGrid').innerHTML =
            infoRow('Address', c.address) +
            infoRow('City', c.city) +
            infoRow('State', c.state) +
            infoRow('Country', c.country) +
            infoRow('Postal Code', c.postalCode);

        // Status Panel
        var pct = c.employeeLimit ? Math.round((c.currentEmployeeCount / c.employeeLimit) * 100) : 0;
        var barColor = pct > 80 ? '#ef4444' : pct > 60 ? '#f59e0b' : '#22c55e';
        document.getElementById('statusPanel').innerHTML =
            '<div style="display:flex;flex-direction:column;gap:10px;">' +
            '<div style="display:flex;justify-content:space-between;align-items:center;">' +
            '<span style="font-size:12px;color:var(--gray-500);">Company Status</span>' +
            '<span class="badge ' + (isActive ? 'badge-active' : 'badge-inactive') + '">' + c.status + '</span>' +
            '</div>' +
            '<div style="display:flex;justify-content:space-between;align-items:center;">' +
            '<span style="font-size:12px;color:var(--gray-500);">Documents</span>' +
            '<span class="badge ' + (c.documentsVerified ? 'badge-active' : 'badge-pending') + '">' + (c.documentsVerified ? '✓ Verified' : '⏳ Pending') + '</span>' +
            '</div>' +
            '<div style="margin-top:4px;">' +
            '<div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:6px;">' +
            '<span style="color:var(--gray-500);">Employee Usage</span>' +
            '<span style="color:' + barColor + ';font-weight:600;">' + c.currentEmployeeCount + ' / ' + c.employeeLimit + '</span>' +
            '</div>' +
            '<div class="progress-bar"><div class="progress-fill" style="width:' + pct + '%;background:' + barColor + ';"></div></div>' +
            '<div style="font-size:10px;color:var(--gray-500);margin-top:4px;">' + (c.employeeLimit - c.currentEmployeeCount) + ' slots available</div>' +
            '</div>' +
            '</div>';

        document.getElementById('actionBtns').innerHTML =
            '<button onclick="openLimitModal()" class="btn btn-ghost" style="width:100%;justify-content:center;font-size:12px;">' +
            '<i class="fas fa-users"></i> Update Employee Limit</button>' +
            (!c.documentsVerified ?
                '<button onclick="verifyDocs()" class="btn btn-ghost" style="width:100%;justify-content:center;font-size:12px;border-color:var(--warning);color:var(--warning);">' +
                '<i class="fas fa-check-double"></i> Verify Documents</button>' :
                '<button disabled class="btn btn-ghost" style="width:100%;justify-content:center;font-size:12px;opacity:.5;cursor:not-allowed;">' +
                '<i class="fas fa-check-circle" style="color:var(--success);"></i> Documents Verified</button>');

        // Subscription
        var subExp = c.subscriptionEndDate && new Date(c.subscriptionEndDate) < new Date();
        var daysLeft = c.subscriptionEndDate ? Math.ceil((new Date(c.subscriptionEndDate) - new Date()) / 86400000) : null;
        var daysColor = daysLeft === null ? '#64748b' : daysLeft > 30 ? '#22c55e' : daysLeft > 7 ? '#f59e0b' : '#ef4444';
        document.getElementById('subscriptionPanel').innerHTML =
            '<div style="display:flex;flex-direction:column;gap:10px;">' +
            '<div style="display:flex;justify-content:space-between;"><span style="font-size:12px;color:var(--gray-500);">Start Date</span><span style="font-size:12px;font-weight:500;">' + formatDate(c.subscriptionStartDate) + '</span></div>' +
            '<div style="display:flex;justify-content:space-between;"><span style="font-size:12px;color:var(--gray-500);">End Date</span><span style="font-size:12px;font-weight:500;">' + formatDate(c.subscriptionEndDate) + '</span></div>' +
            (daysLeft !== null ? '<div style="display:flex;justify-content:space-between;"><span style="font-size:12px;color:var(--gray-500);">Days Remaining</span><span style="font-size:13px;font-weight:700;color:' + daysColor + ';">' + daysLeft + ' days</span></div>' : '') +
            '<div style="display:flex;justify-content:space-between;"><span style="font-size:12px;color:var(--gray-500);">Status</span>' +
            '<span class="badge ' + (subExp ? 'badge-inactive' : 'badge-active') + '">' + (subExp ? 'Expired' : 'Active') + '</span></div>' +
            '</div>';
    }

    // ==================== DOCUMENTS ====================
    async function loadCompanyDocuments() {
        var data = await api('/api/super-admin/companies/' + CID + '/documents');
        var container = document.getElementById('companyDocumentsList');
        if (!data || !data.success || !data.data.length) {
            container.innerHTML = '<div class="empty-state" style="padding:16px;"><i class="fas fa-file-alt" style="font-size:24px;opacity:0.3;"></i><br>No documents uploaded</div>';
            return;
        }
        var html = '';
        for (var i = 0; i < data.data.length; i++) {
            var d = data.data[i];
            var kb = d.fileSize ? (d.fileSize / 1024).toFixed(0) + ' KB' : '';
            var icon = d.fileType && d.fileType.includes('pdf') ? 'fa-file-pdf' :
                       d.fileType && d.fileType.includes('image') ? 'fa-file-image' : 'fa-file-alt';
            var iconColor = d.fileType && d.fileType.includes('pdf') ? '#ef4444' :
                            d.fileType && d.fileType.includes('image') ? '#10b981' : '#6366f1';
            html += '<div class="doc-item">' +
                '<div class="doc-info">' +
                '<i class="fas ' + icon + '" style="color:' + iconColor + ';"></i>' +
                '<div style="min-width:0;">' +
                '<div class="doc-name">' + escapeHtml(d.fileName) + '</div>' +
                '<div class="doc-meta">' + kb + ' · ' + formatDate(d.uploadedAt) + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="doc-actions">' +
                '<a href="' + contextPath + d.fileUrl + '" target="_blank" class="btn btn-ghost" style="padding:4px 8px;" title="Download">' +
                '<i class="fas fa-download" style="font-size:11px;"></i>' +
                '</a>' +
                '<button onclick="deleteDoc(' + d.id + ')" class="btn btn-danger" style="padding:4px 8px;" title="Delete">' +
                '<i class="fas fa-trash" style="font-size:11px;"></i>' +
                '</button>' +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    async function uploadCompanyDocs(input) {
        if (!input.files.length) return;
        var formData = new FormData();
        for (var i = 0; i < input.files.length; i++) {
            formData.append('files', input.files[i]);
        }
        var token = localStorage.getItem('accessToken');
        toast('Uploading...', 'info', 2000);
        try {
            var resp = await fetch(contextPath + '/api/super-admin/companies/' + CID + '/documents', {
                method: 'POST',
                headers: { 'Authorization': 'Bearer ' + token },
                body: formData
            });
            var data = await resp.json();
            if (data && data.success) {
                toast('Documents uploaded', 'success');
                loadCompanyDocuments();
            } else {
                toast(data.error || 'Upload failed', 'error');
            }
        } catch (e) {
            toast('Upload failed', 'error');
        }
        input.value = '';
    }

    async function deleteDoc(docId) {
        if (!confirm('Delete this document?')) return;
        var data = await api('/api/super-admin/companies/' + CID + '/documents/' + docId, { method: 'DELETE' });
        if (data && data.success) {
            toast('Deleted', 'success');
            loadCompanyDocuments();
        } else {
            toast('Delete failed', 'error');
        }
    }

    // ==================== ACTIONS ====================
    async function toggleCompanyStatus() {
        var c = companyData;
        var newStatus = c.status === 'ACTIVE' ? 'DEACTIVATED' : 'ACTIVE';
        if (!confirm('Are you sure you want to ' + (newStatus === 'ACTIVE' ? 'activate' : 'deactivate') + ' this company?')) return;
        var data = await api('/api/super-admin/companies/' + CID + '/status?status=' + newStatus, { method: 'PATCH' });
        if (data && data.success) { toast('Status updated to ' + newStatus, 'success'); loadCompany(); }
        else toast((data && data.error) || 'Failed', 'error');
    }

    async function verifyDocs() {
        if (!confirm('Verify documents for this company?')) return;
        var data = await api('/api/super-admin/companies/' + CID + '/verify-documents', { method: 'POST' });
        if (data && data.success) { toast('Documents verified!', 'success'); loadCompany(); }
        else toast((data && data.error) || 'Failed', 'error');
    }

    // ==================== EDIT MODAL ====================
   function openEditModal() {
       var c = companyData;
       var admin = c.companyAdmin || {};
       document.getElementById('e_name').value = c.name || '';
       document.getElementById('e_email').value = c.email || '';
       document.getElementById('e_phone').value = c.phone || '';
       document.getElementById('e_website').value = c.website || '';
       document.getElementById('e_gst').value = c.gstNumber || '';
       document.getElementById('e_pan').value = c.panNumber || '';
       document.getElementById('e_address').value = c.address || '';
       document.getElementById('e_city').value = c.city || '';
       document.getElementById('e_state').value = c.state || '';
       document.getElementById('e_country').value = c.country || '';
       document.getElementById('e_postal').value = c.postalCode || '';
       document.getElementById('e_taxid').value = c.taxId || '';
       document.getElementById('e_desc').value = c.description || '';
       document.getElementById('e_adminFirst').value = admin.firstName || '';
       document.getElementById('e_adminLast').value = admin.lastName || '';
       document.getElementById('e_adminEmail').value = admin.email || '';
       document.getElementById('e_adminPhone').value = admin.phoneNumber || '';
       document.getElementById('editModal').style.display = 'flex';
       document.body.style.overflow = 'hidden';
   }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function submitEdit() {
        var btn = document.getElementById('editSubmitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving…';

        var payload = {
            name: document.getElementById('e_name').value.trim(),
            email: document.getElementById('e_email').value.trim(),
            phone: document.getElementById('e_phone').value.trim() || null,
            website: document.getElementById('e_website').value.trim() || null,
            gstNumber: document.getElementById('e_gst').value.trim().toUpperCase() || null,
            panNumber: document.getElementById('e_pan').value.trim().toUpperCase() || null,
            address: document.getElementById('e_address').value.trim() || null,
            city: document.getElementById('e_city').value.trim() || null,
            state: document.getElementById('e_state').value.trim() || null,
            country: document.getElementById('e_country').value.trim() || null,
            postalCode: document.getElementById('e_postal').value.trim() || null,
            taxId: document.getElementById('e_taxid').value.trim() || null,
            description: document.getElementById('e_desc').value.trim() || null,
            adminFirstName: document.getElementById('e_adminFirst').value.trim(),
            adminLastName: document.getElementById('e_adminLast').value.trim(),
            adminEmail: document.getElementById('e_adminEmail').value.trim(),
            adminPhone: document.getElementById('e_adminPhone').value.trim() || null
        };

        if (!payload.adminFirstName || !payload.adminLastName || !payload.adminEmail) {
            toast('Admin first name, last name and email are required', 'error');
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-save"></i> Save Changes';
            return;
        }

        var data = await api('/api/super-admin/companies/' + CID, { method: 'PUT', body: JSON.stringify(payload) });
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-save"></i> Save Changes';

        if (data && data.success) {
            toast('Company updated!', 'success');
            closeEditModal();
            loadCompany();
        } else {
            toast((data && (data.error || data.message)) || 'Failed to update', 'error');
        }
    }

    // ==================== EXTEND MODAL ====================
    function openExtendModal() {
        document.getElementById('extendModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeExtendModal() {
        document.getElementById('extendModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function submitExtend() {
        var months = parseInt(document.getElementById('extMonths').value);
        if (!months || months < 1 || months > 60) {
            toast('Enter between 1–60 months', 'error');
            return;
        }
        var data = await api('/api/super-admin/companies/' + CID + '/extend-subscription?months=' + months, { method: 'POST' });
        if (data && data.success) {
            toast('Subscription extended by ' + months + ' months', 'success');
            closeExtendModal();
            loadCompany();
        } else {
            toast((data && data.error) || 'Failed', 'error');
        }
    }

    // ==================== LIMIT MODAL ====================
    function openLimitModal() {
        document.getElementById('newLimit').value = companyData.employeeLimit || 100;
        document.getElementById('limitNote').textContent = 'Current employees: ' + companyData.currentEmployeeCount;
        document.getElementById('limitModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeLimitModal() {
        document.getElementById('limitModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function submitLimit() {
        var newLimit = parseInt(document.getElementById('newLimit').value);
        if (!newLimit || newLimit < 1) {
            toast('Enter a valid limit', 'error');
            return;
        }
        if (newLimit < companyData.currentEmployeeCount) {
            toast('Limit cannot be less than current employee count (' + companyData.currentEmployeeCount + ')', 'error');
            return;
        }
        var data = await api('/api/super-admin/companies/' + CID + '/employee-limit?employeeLimit=' + newLimit, { method: 'PUT' });
        if (data && data.success) {
            toast('Employee limit updated to ' + newLimit, 'success');
            closeLimitModal();
            loadCompany();
        } else {
            toast((data && data.error) || 'Failed', 'error');
        }
    }

    // ==================== COMPLIANCE MANAGEMENT ====================
   async function loadAssignedCompliances() {
       var container = document.getElementById('complianceTableBody');
       var loader = document.getElementById('complianceLoader');

       loader.style.display = 'block';
       container.innerHTML = '';

       // Use a fresh API call without cache
       var data = await api('/api/super-admin/compliance/assignments?page=0&size=100&companyId=' + CID + '&_=' + Date.now());

       if (data && data.success) {
           var allAssignments = data.data.content || [];
           var groupedByTemplate = {};
           for (var i = 0; i < allAssignments.length; i++) {
               var a = allAssignments[i];
               var templateId = a.templateId;

               if (!groupedByTemplate[templateId]) {
                   groupedByTemplate[templateId] = {
                       templateId: templateId,
                       templateName: a.templateName || 'Unknown Category',
                       description: a.category || '',
                       isActive: a.isActive,
                       configured: a.configured,
                       assignedAt: a.assignedAt,
                       status: a.status || 'PENDING',
                       subCompliances: [],
                       companyComplianceId: a.id
                   };
               }

               if (a.isParent) {
                   groupedByTemplate[templateId].companyComplianceId = a.id;
                   groupedByTemplate[templateId].templateName = a.templateName || groupedByTemplate[templateId].templateName;
                   groupedByTemplate[templateId].isActive = a.isActive;
                   groupedByTemplate[templateId].configured = a.configured;
                   groupedByTemplate[templateId].assignedAt = a.assignedAt;
                   groupedByTemplate[templateId].status = a.status || groupedByTemplate[templateId].status;
               }

               if (a.subTemplateName) {
                   groupedByTemplate[templateId].subCompliances.push({
                       id: a.id,
                       name: a.subTemplateName,
                       status: a.status || 'PENDING',
                       configured: a.configured,
                       dueDate: a.dueDate
                   });
               }
           }

           assignedCompliances = Object.values(groupedByTemplate);
           renderAssignedCompliances();
       } else {
           container.innerHTML = '<tr><td colspan="7"><div class="empty-state">Failed to load assigned compliances</div></td></tr>';
       }

       loader.style.display = 'none';
   }

    function renderAssignedCompliances() {
        var container = document.getElementById('complianceTableBody');
        var searchTerm = document.getElementById('complianceSearch').value.toLowerCase();
        var statusFilter = document.getElementById('complianceStatusFilter').value;

        var filtered = assignedCompliances.filter(function(c) {
            if (searchTerm && !c.templateName.toLowerCase().includes(searchTerm)) return false;
            if (statusFilter === 'active' && c.isActive !== true) return false;
            if (statusFilter === 'inactive' && c.isActive !== false) return false;
            return true;
        });

        if (!filtered.length) {
            container.innerHTML = '<tr><td colspan="7"><div class="empty-state" style="padding:40px;">' +
                '<i class="fas fa-folder-open" style="font-size:36px;opacity:0.3;"></i>' +
                '<p style="margin-top:10px;">No compliance categories assigned</p>' +
                '<button onclick="openAssignComplianceModal()" class="btn btn-primary" style="margin-top:12px;">' +
                '<i class="fas fa-plus"></i> Assign First Category</button>' +
                '</div></td></tr>';
            return;
        }

        var html = '';
        for (var i = 0; i < filtered.length; i++) {
            var c = filtered[i];
            var isActive = c.isActive !== false;
            var isConfigured = c.configured === true;
            var subCount = c.subCompliances ? c.subCompliances.length : 0;
            var configuredSubs = c.subCompliances ? c.subCompliances.filter(function(s) { return s.configured === true; }).length : 0;

            var subListHtml = '';
            if (subCount > 0) {
                subListHtml = '<div style="font-size:11px;margin-top:4px;">';
                var displaySubs = c.subCompliances.slice(0, 2);
                for (var j = 0; j < displaySubs.length; j++) {
                    var s = displaySubs[j];
                    var sStatus = s.status || 'PENDING';
                    var sStatusClass = sStatus === 'COMPLETED' ? 'badge-active' :
                                       (sStatus === 'OVERDUE' ? 'badge-inactive' : 'badge-pending');
                    subListHtml += '<div class="sub-list-item">' +
                        '<span><i class="fas fa-file-alt" style="color:var(--primary);font-size:9px;margin-right:4px;"></i>' +
                        escapeHtml(s.name) + '</span>' +
                        '<span class="badge ' + sStatusClass + ' sub-badge-tiny">' + sStatus.replace('_', ' ') + '</span>' +
                        '</div>';
                }
                if (subCount > 2) {
                    subListHtml += '<div style="color:var(--gray-500);font-size:10px;margin-top:2px;">+ ' + (subCount - 2) + ' more</div>';
                }
                subListHtml += '</div>';
            } else {
                subListHtml = '<span style="color:var(--gray-500);font-size:11px;">No sub-compliances</span>';
            }

            var overallStatus = c.status || 'PENDING';
            var statusBadgeClass = overallStatus === 'COMPLETED' ? 'badge-active' :
                                   (overallStatus === 'OVERDUE' ? 'badge-inactive' : 'badge-pending');

            var configDisplay = '';
            if (subCount > 0) {
                if (configuredSubs === subCount) {
                    configDisplay = '<span class="badge badge-active">All Configured</span>';
                } else if (configuredSubs > 0) {
                    configDisplay = '<span class="badge badge-pending" style="background:rgba(245,158,11,0.15);color:var(--warning);">Partially Configured</span>';
                } else {
                    configDisplay = '<span class="badge badge-pending">Pending</span>';
                }
            } else {
                configDisplay = isConfigured ?
                    '<span class="badge badge-active">Configured</span>' :
                    '<span class="badge badge-pending">Pending</span>';
            }

            html += '<tr>' +
                '<td><div style="display:flex;align-items:center;gap:8px;">' +
                '<i class="fas fa-folder-open" style="color:var(--primary);"></i>' +
                '<a href="' + contextPath + '/super-admin/compliance/templates/' + c.templateId + '">' +
                escapeHtml(c.templateName) + '</a>' +
                '</div></td>' +
                '<td><div style="display:flex;flex-direction:column;">' +
                '<span style="font-size:12px;font-weight:600;color:var(--primary-light);">' + subCount + ' sub(s)</span>' +
                subListHtml +
                '</div></td>' +
                '<td style="font-size:12px;color:var(--gray-500);">' + (escapeHtml(c.description) || '—') + '</td>' +
                '<td><span class="badge ' + (isActive ? 'badge-active' : 'badge-inactive') + '">' +
                (isActive ? 'Active' : 'Inactive') + '</span></td>' +
                '<td>' + configDisplay + '</td>' +
                '<td style="font-size:12px;color:var(--gray-500);">' + formatDate(c.assignedAt) + '</td>' +
                '<td style="text-align:center;">' +
                '<button onclick="toggleAssignmentStatus(' + c.companyComplianceId + ', ' + isActive + ')" class="btn ' + (isActive ? 'btn-warning' : 'btn-success') + '" style="padding:6px 10px;" title="' + (isActive ? 'Deactivate' : 'Activate') + '">' +
                '<i class="fas ' + (isActive ? 'fa-pause' : 'fa-play') + '"></i>' +
                '</button>' +
                '<button onclick="openRemoveComplianceModal(' + c.companyComplianceId + ', \'' + escapeHtml(c.templateName) + '\', ' + isConfigured + ')" class="btn btn-danger" style="padding:6px 10px;margin-left:4px;" title="Remove">' +
                '<i class="fas fa-trash-alt"></i>' +
                '</button>' +
                '</td>' +
                '</tr>';
        }
        container.innerHTML = html;
    }

    function filterComplianceList() {
        renderAssignedCompliances();
    }

    function refreshComplianceList() {
        loadAssignedCompliances();
        toast('Compliance list refreshed', 'info');
    }

    async function toggleAssignmentStatus(assignmentId, currentActive) {
        var action = currentActive ? 'deactivate' : 'activate';
        if (!confirm('Are you sure you want to ' + action + ' this compliance for this company?')) return;

        var data = await api('/api/super-admin/compliance/assignments/' + assignmentId + '/toggle-status', { method: 'PATCH' });

        if (data && data.success) {
            toast('Compliance ' + action + 'd successfully', 'success');
            loadAssignedCompliances();
        } else {
            toast(data?.error || 'Failed to ' + action + ' compliance', 'error');
        }
    }

    function openRemoveComplianceModal(assignmentId, categoryName, isConfigured) {
        pendingRemoveId = assignmentId;
        document.getElementById('removeCategoryName').textContent = categoryName;

        var warningDiv = document.getElementById('removeWarning');
        warningDiv.style.display = 'block'; // Always show warning for permanent delete
        warningDiv.innerHTML = '<i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i>' +
            '<span style="font-size:12px;color:var(--danger);margin-left:6px;">' +
            '⚠️ WARNING: This will PERMANENTLY DELETE all configurations, employee assignments, documents, and history for this compliance from this company. This action CANNOT be undone!' +
            '</span>';

        document.getElementById('confirmRemoveModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    async function confirmRemoveCompliance() {
        if (!pendingRemoveId) return;

        // Find the templateId and companyId from the pending remove
        var assignment = assignedCompliances.find(function(c) { return c.companyComplianceId === pendingRemoveId; });
        if (!assignment) {
            toast('Assignment not found', 'error');
            return;
        }

        var templateId = assignment.templateId;
        var companyId = parseInt(CID);

        var btn = document.querySelector('#confirmRemoveModal .btn-danger');
        var originalText = btn ? btn.innerHTML : '';
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Removing...';
        }

        var data = await api('/api/super-admin/compliance/companies/' + companyId + '/templates/' + templateId, {
            method: 'DELETE'
        });

        if (btn) {
            btn.disabled = false;
            btn.innerHTML = originalText;
        }

        if (data && data.success) {
            toast('Category permanently removed from company', 'success');
            closeConfirmRemoveModal();
            loadAssignedCompliances();
            loadCompany();
        } else {
            toast((data && data.error) || 'Failed to remove category', 'error');
        }
    }

    function closeConfirmRemoveModal() {
        pendingRemoveId = null;
        document.getElementById('confirmRemoveModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    // ==================== ASSIGN COMPLIANCE MODAL ====================
    async function openAssignComplianceModal() {
        document.getElementById('assignCompanyName').textContent = companyData?.name || 'this company';
        document.getElementById('assignComplianceModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        await loadAssignableCategories();
    }

    function closeAssignComplianceModal() {
        document.getElementById('assignComplianceModal').style.display = 'none';
        document.body.style.overflow = '';
        selectedAssignableIds.clear();
        document.getElementById('assignSearchInput').value = '';
        document.getElementById('assignStatusFilter').value = 'all';
    }

    async function loadAssignableCategories() {
        var container = document.getElementById('assignCategoriesList');
        container.innerHTML = '<div style="text-align:center;padding:40px;"><div class="spinner" style="margin:0 auto 12px;"></div>Loading categories...</div>';

        var templatesData = await api('/api/super-admin/compliance/templates?page=0&size=100');

        if (!templatesData || !templatesData.success) {
            container.innerHTML = '<div class="empty-state">Failed to load categories</div>';
            return;
        }

        var allTemplates = templatesData.data.content || [];

        var assignedIds = new Set();
        for (var i = 0; i < assignedCompliances.length; i++) {
            assignedIds.add(assignedCompliances[i].templateId);
        }

        allAssignableCategories = allTemplates.filter(function(t) {
            return !assignedIds.has(t.id);
        });

        renderAssignableList();
    }

    function renderAssignableList() {
        var container = document.getElementById('assignCategoriesList');
        var searchTerm = document.getElementById('assignSearchInput').value.toLowerCase();
        var statusFilter = document.getElementById('assignStatusFilter').value;

        var filtered = allAssignableCategories.filter(function(c) {
            if (searchTerm && !c.name.toLowerCase().includes(searchTerm)) return false;
            if (statusFilter === 'active' && c.isActive !== true) return false;
            return true;
        });

        if (!filtered.length) {
            container.innerHTML = '<div class="empty-state" style="padding:40px;">' +
                '<i class="fas fa-folder-open" style="font-size:36px;opacity:0.3;"></i>' +
                '<p style="margin-top:10px;">No categories available to assign</p>' +
                '</div>';
            document.getElementById('selectedCategoriesCount').textContent = '0 selected';
            return;
        }

        var html = '';
        for (var i = 0; i < filtered.length; i++) {
            var cat = filtered[i];
            var isChecked = selectedAssignableIds.has(cat.id);

            html += '<label style="display:flex;align-items:center;gap:12px;padding:10px 12px;background:' +
                (isChecked ? 'rgba(79,70,229,0.08)' : 'rgba(226,232,240,0.15)') + ';border:1px solid ' +
                (isChecked ? 'var(--primary)' : 'rgba(226,232,240,0.3)') + ';border-radius:8px;cursor:pointer;transition:all 0.2s;">' +
                '<input type="checkbox" value="' + cat.id + '" onchange="toggleAssignableCategory(' + cat.id + ', this.checked)" ' + (isChecked ? 'checked' : '') + ' style="width:16px;height:16px;accent-color:var(--primary);">' +
                '<div style="flex:1;">' +
                '<div style="font-weight:600;font-size:14px;">' + escapeHtml(cat.name) + '</div>' +
                (cat.description ? '<div style="font-size:11px;color:var(--gray-500);margin-top:2px;">' + escapeHtml(cat.description) + '</div>' : '') +
                '</div>' +
                '<span class="badge ' + (cat.isActive ? 'badge-active' : 'badge-inactive') + '">' + (cat.isActive ? 'Active' : 'Inactive') + '</span>' +
                '</label>';
        }
        container.innerHTML = html;
        document.getElementById('selectedCategoriesCount').textContent = selectedAssignableIds.size + ' selected';
    }

    function toggleAssignableCategory(categoryId, checked) {
        if (checked) {
            selectedAssignableIds.add(categoryId);
        } else {
            selectedAssignableIds.delete(categoryId);
        }
        renderAssignableList();
    }

    function filterAssignableList() {
        renderAssignableList();
    }


    async function saveComplianceAssignments() {
        if (selectedAssignableIds.size === 0) {
            toast('Please select at least one category to assign', 'error');
            return;
        }

        var btn = document.getElementById('saveAssignBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assigning...';

        var successCount = 0;
        var errorCount = 0;

        for (var catId of selectedAssignableIds) {
            // Use the new endpoint for single company assignment
            var url = '/api/super-admin/compliance/assign-to-company?templateId=' + catId + '&companyId=' + CID;

            try {
                var response = await fetch(contextPath + url, {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + localStorage.getItem('accessToken'),
                        'Content-Type': 'application/json'
                    }
                });
                var data = await response.json();

                if (data && data.success) {
                    successCount++;
                    toast('Assigned: ' + catId, 'success', 1000);
                } else {
                    errorCount++;
                    console.error('Failed to assign:', data);
                }
            } catch (error) {
                errorCount++;
                console.error('Error assigning:', error);
            }
        }

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (successCount > 0) {
            toast('Assigned ' + successCount + ' category(ies) successfully' + (errorCount > 0 ? ' (' + errorCount + ' failed)' : ''), 'success');
            closeAssignComplianceModal();
            loadAssignedCompliances();
        } else {
            toast('Failed to assign categories. Check console for errors.', 'error');
        }
    }



    // ==================== CLOSE MODALS ON OVERLAY CLICK ====================
    var modalIds = ['editModal', 'extendModal', 'limitModal', 'assignComplianceModal', 'confirmRemoveModal'];
    for (var i = 0; i < modalIds.length; i++) {
        var modal = document.getElementById(modalIds[i]);
        if (modal) {
            modal.addEventListener('click', function(e) {
                if (e.target === this) {
                    this.style.display = 'none';
                    document.body.style.overflow = '';
                }
            });
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

        loadCompany();
        loadNotifications();
    });
</script>

</body>
</html>