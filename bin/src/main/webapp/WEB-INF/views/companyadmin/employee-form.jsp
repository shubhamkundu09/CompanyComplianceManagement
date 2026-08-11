<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: companyadmin/employee-form.jsp --%>

<%
    String employeeId = request.getParameter("id");
    boolean isEdit = employeeId != null && !employeeId.trim().isEmpty();
    pageContext.setAttribute("isEdit", isEdit);
    pageContext.setAttribute("employeeId", employeeId);
    pageContext.setAttribute("pageTitle", isEdit ? "Edit Employee" : "Add Employee");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — <%= isEdit ? "Edit Employee" : "Add Employee" %></title>

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

        /* ==================== FORM ==================== */
        .form-container {
            max-width: 720px;
            margin: 0 auto;
        }

        .form-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 28px 32px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .form-card .form-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 4px;
        }

        .form-card .form-subtitle {
            font-size: 13px;
            color: var(--gray-500);
            margin-bottom: 24px;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .col-2 {
            grid-column: span 2;
        }

        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 4px;
        }

        .form-label .required {
            color: var(--danger);
        }

        .form-input {
            padding: 10px 14px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            font-size: 14px;
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

        .form-input:disabled,
        .form-input[readonly] {
            background: rgba(226, 232, 240, 0.2);
            color: var(--gray-500);
            cursor: not-allowed;
        }

        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .form-input.error {
            border-color: var(--danger);
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .divider {
            height: 1px;
            background: rgba(226, 232, 240, 0.5);
            margin: 20px 0;
        }

        /* ==================== BUTTONS ==================== */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius);
            font-size: 14px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
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

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
            color: var(--gray-600);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
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

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 8px;
        }

        /* ==================== INFO BANNER ==================== */
        .info-banner {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-radius: var(--radius);
            background: rgba(79, 70, 229, 0.06);
            border-left: 3px solid var(--primary);
            margin-top: 20px;
        }

        .info-banner i {
            color: var(--primary);
            font-size: 18px;
            flex-shrink: 0;
        }

        .info-banner .info-text {
            font-size: 13px;
            color: var(--gray-600);
        }

        .info-banner .info-text strong {
            color: var(--gray-800);
        }

        /* ==================== LIMIT WARNING ==================== */
        .limit-warning {
            display: none;
            padding: 14px 18px;
            border-radius: var(--radius);
            margin-bottom: 20px;
            border-left: 3px solid;
        }

        .limit-warning.danger {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(239, 68, 68, 0.08);
            border-left-color: var(--danger);
        }

        .limit-warning.warning {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(245, 158, 11, 0.08);
            border-left-color: var(--warning);
        }

        .limit-warning i {
            font-size: 18px;
            flex-shrink: 0;
        }

        .limit-warning.danger i { color: var(--danger); }
        .limit-warning.warning i { color: var(--warning); }

        .limit-warning .warning-text {
            font-size: 13px;
        }

        .limit-warning.danger .warning-text { color: var(--danger); }
        .limit-warning.warning .warning-text { color: var(--warning); }

        .limit-warning .warning-text strong {
            color: var(--gray-800);
        }

        /* ==================== CAPACITY CARD ==================== */
        .capacity-card {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: var(--radius);
            padding: 16px 20px;
            margin-top: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .capacity-card .capacity-icon {
            width: 40px;
            height: 40px;
            background: rgba(79, 70, 229, 0.12);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .capacity-card .capacity-icon i {
            color: var(--primary);
            font-size: 16px;
        }

        .capacity-card .capacity-info {
            flex: 1;
            min-width: 150px;
        }

        .capacity-card .capacity-info .capacity-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--gray-700);
        }

        .capacity-card .capacity-info .capacity-detail {
            font-size: 12px;
            color: var(--gray-500);
        }

        .capacity-card .capacity-info .capacity-detail .success { color: var(--success); }
        .capacity-card .capacity-info .capacity-detail .danger { color: var(--danger); }
        .capacity-card .capacity-info .capacity-detail .warning { color: var(--warning); }

        .capacity-card .capacity-progress {
            min-width: 140px;
        }

        .capacity-card .capacity-progress .progress-label {
            font-size: 11px;
            color: var(--gray-500);
            margin-bottom: 4px;
        }

        .capacity-bar {
            height: 6px;
            background: rgba(226, 232, 240, 0.5);
            border-radius: 3px;
            overflow: hidden;
        }

        .capacity-bar .capacity-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.4s ease;
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
            .form-card { padding: 20px; }
            .grid-2 { grid-template-columns: 1fr; }
            .col-2 { grid-column: span 1; }
            .form-actions { flex-direction: column; }
            .form-actions .btn { width: 100%; justify-content: center; }
            .capacity-card { flex-direction: column; align-items: flex-start; }
            .capacity-card .capacity-progress { width: 100%; }
        }

        @media (max-width: 480px) {
            .header-left .page-title { font-size: 15px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .form-card .form-title { font-size: 18px; }
            .info-banner { flex-direction: column; align-items: flex-start; }
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
            <span class="page-title"><%= isEdit ? "Edit Employee" : "Add Employee" %></span>
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

        <div class="form-container">

            <!-- Page Header -->
            <div style="margin-bottom:24px;">
                <p style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                    <%= isEdit ? "Edit Employee" : "Add New User" %>
                </p>
                <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">
                    <%= isEdit ? "Update User Information" : "Create User Account" %>
                </h1>
                <p style="font-size:13px;color:var(--gray-500);margin-top:4px;">
                    <%= isEdit ? "Update employee details and role" : "Add a new employee to your company" %>
                </p>
            </div>

            <!-- Limit Warning Banner -->
            <div id="limitWarning" class="limit-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <span class="warning-text" id="limitWarningText"></span>
            </div>

            <!-- Form Card -->
            <div class="form-card">
                <form id="employeeForm" onsubmit="return false;">

                    <div class="grid-2">
                        <div>
                            <label class="form-label">First Name <span class="required">*</span></label>
                            <input type="text" id="firstName" class="form-input" placeholder="John" required>
                        </div>
                        <div>
                            <label class="form-label">Last Name <span class="required">*</span></label>
                            <input type="text" id="lastName" class="form-input" placeholder="Doe" required>
                        </div>

                        <div class="col-2">
                            <label class="form-label">Email Address <span class="required">*</span></label>
                            <input type="email" id="email" class="form-input" placeholder="employee@company.com" required <%= isEdit ? "readonly" : "" %>>
                            <% if (isEdit) { %>
                            <div style="font-size:11px;color:var(--gray-500);margin-top:4px;">
                                <i class="fas fa-info-circle"></i> Email cannot be changed
                            </div>
                            <% } %>
                        </div>

                        <div>
                            <label class="form-label">Phone Number</label>
                            <input type="tel" id="phone" class="form-input" placeholder="9876543210">
                        </div>
                        <div>
                            <label class="form-label">Designation</label>
                            <input type="text" id="designation" class="form-input" placeholder="e.g., Senior Engineer">
                        </div>

                        <div>
                            <label class="form-label">Department</label>
                            <select id="department" class="form-input">
                                <option value="">Select Department</option>
                                <option value="Engineering">Engineering</option>
                                <option value="Sales">Sales</option>
                                <option value="Marketing">Marketing</option>
                                <option value="HR">HR</option>
                                <option value="Finance">Finance</option>
                                <option value="Operations">Operations</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">User Role <span class="required">*</span></label>
                            <select id="role" class="form-input" required>
                                <option value="">Select Role</option>
                                <option value="EMPLOYEE">Employee</option>
                                <option value="COMPANY_ADMIN">Sub Admin</option>
                            </select>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/company-admin/employees" class="btn btn-ghost">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" id="submitBtn" class="btn btn-primary">
                            <i class="fas <%= isEdit ? "fa-save" : "fa-plus" %>"></i>
                            <%= isEdit ? "Update User" : "Create User" %>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Info Banner (for new user) -->
            <% if (!isEdit) { %>
            <div class="info-banner">
                <i class="fas fa-info-circle"></i>
                <div class="info-text">
                    A temporary password will be sent to the user's email address.
                    They will be prompted to <strong>change it on first login</strong>.
                </div>
            </div>
            <% } %>

            <!-- Capacity Card -->
            <div class="capacity-card">
                <div class="capacity-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="capacity-info">
                    <div class="capacity-label">Employee Capacity</div>
                    <div class="capacity-detail" id="capacityDetail">Loading capacity info...</div>
                </div>
                <div class="capacity-progress">
                    <div class="progress-label" id="progressLabel">Utilization: 0%</div>
                    <div class="capacity-bar">
                        <div class="capacity-fill" id="capacityFill" style="width:0%;background:var(--success);"></div>
                    </div>
                </div>
            </div>

        </div>

    </main>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var isEdit = <%= isEdit %>;
    var employeeId = '<%= employeeId %>';
    var companyInfo = null;

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

    // ==================== COMPANY CAPACITY ====================
    async function loadCompanyInfo() {
        var data = await api('/api/company-admin/company');
        if (data && data.success) {
            companyInfo = data.data;
            updateCapacityDisplay();
            if (!isEdit) {
                checkEmployeeLimit();
            }
        }
    }

    function updateCapacityDisplay() {
        if (!companyInfo) return;

        var activeCount = companyInfo.currentEmployeeCount || 0;
        var limit = companyInfo.employeeLimit || 0;
        var remaining = limit - activeCount;
        var percentage = limit > 0 ? Math.min((activeCount / limit) * 100, 100) : 0;

        var detailEl = document.getElementById('capacityDetail');
        if (remaining > 0) {
            detailEl.innerHTML = '<span class="success"><strong>' + activeCount + '</strong> active / <strong>' + limit + '</strong> total</span> &#8226; ' +
                '<span style="color:var(--gray-500);font-size:11px;">' + remaining + ' slot(s) available</span>';
        } else {
            detailEl.innerHTML = '<span class="danger"><strong>' + activeCount + '</strong> active / <strong>' + limit + '</strong> total</span> &#8226; ' +
                '<span class="danger" style="font-size:11px;">⚠️ LIMIT REACHED</span>';
        }

        var barColor = percentage >= 90 ? 'var(--danger)' : (percentage >= 70 ? 'var(--warning)' : 'var(--success)');
        document.getElementById('progressLabel').textContent = 'Utilization: ' + Math.round(percentage) + '%';
        var fill = document.getElementById('capacityFill');
        fill.style.width = percentage + '%';
        fill.style.background = barColor;
    }

    function checkEmployeeLimit() {
        if (!companyInfo) return;

        var activeCount = companyInfo.currentEmployeeCount || 0;
        var limit = companyInfo.employeeLimit || 0;
        var remaining = limit - activeCount;

        var warningEl = document.getElementById('limitWarning');
        var textEl = document.getElementById('limitWarningText');
        var submitBtn = document.getElementById('submitBtn');

        if (remaining <= 0) {
            warningEl.className = 'limit-warning danger';
            warningEl.style.display = 'flex';
            textEl.innerHTML = '<strong>Cannot add new employee!</strong> You have reached the employee limit (' + activeCount + '/' + limit + '). ' +
                'Please deactivate some employees or contact Super Admin to increase the limit.';
            submitBtn.disabled = true;
            submitBtn.title = 'Employee limit reached';
        } else if (remaining <= 2) {
            warningEl.className = 'limit-warning warning';
            warningEl.style.display = 'flex';
            textEl.innerHTML = '<strong>Warning:</strong> Only ' + remaining + ' slot(s) remaining. ' +
                'You have ' + activeCount + ' active employees out of ' + limit + '.';
            submitBtn.disabled = false;
            submitBtn.title = '';
        } else {
            warningEl.style.display = 'none';
            submitBtn.disabled = false;
            submitBtn.title = '';
        }
    }

    // ==================== LOAD EMPLOYEE DATA (EDIT MODE) ====================
    async function loadEmployeeData() {
        if (!isEdit) return;

        var data = await api('/api/company-admin/employees/' + employeeId);
        if (data && data.success) {
            var emp = data.data;
            document.getElementById('firstName').value = emp.firstName || '';
            document.getElementById('lastName').value = emp.lastName || '';
            document.getElementById('email').value = emp.email || '';
            document.getElementById('phone').value = emp.phoneNumber || '';
            document.getElementById('designation').value = emp.designation || '';
            document.getElementById('department').value = emp.department || '';
            document.getElementById('role').value = emp.role || 'EMPLOYEE';
        } else {
            toast('Failed to load user data', 'error');
        }
    }

    // ==================== FORM VALIDATION ====================
    function validateEmail(email) {
        var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    function validatePhone(phone) {
        if (!phone) return true;
        var re = /^[0-9]{10,15}$/;
        return re.test(phone);
    }

    // ==================== SUBMIT FORM ====================
    async function submitForm() {
        var firstName = document.getElementById('firstName').value.trim();
        var lastName = document.getElementById('lastName').value.trim();
        var email = document.getElementById('email').value.trim();
        var role = document.getElementById('role').value;
        var phone = document.getElementById('phone').value.trim();

        if (!firstName || !lastName || !email) {
            toast('Please fill in all required fields', 'error');
            return;
        }
        if (!validateEmail(email)) {
            toast('Please enter a valid email address', 'error');
            document.getElementById('email').classList.add('error');
            return;
        }
        if (phone && !validatePhone(phone)) {
            toast('Phone number must be 10-15 digits', 'error');
            document.getElementById('phone').classList.add('error');
            return;
        }
        if (!role) {
            toast('Please select a role', 'error');
            return;
        }

        var payload = {
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone || null,
            designation: document.getElementById('designation').value.trim() || null,
            department: document.getElementById('department').value || null,
            role: role,
            reportingManagerId: null
        };

        var btn = document.getElementById('submitBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

        var url, method;
        if (isEdit) {
            url = '/api/company-admin/employees/' + employeeId;
            method = 'PUT';
        } else {
            // Double-check limit
            if (companyInfo) {
                var activeCount = companyInfo.currentEmployeeCount || 0;
                var limit = companyInfo.employeeLimit || 0;
                if (activeCount >= limit) {
                    toast('Employee limit reached. Cannot add new employee.', 'error');
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                    return;
                }
            }

            if (role === 'COMPANY_ADMIN') {
                url = '/api/company-admin/sub-admins';
            } else {
                url = '/api/company-admin/employees';
            }
            method = 'POST';
        }

        var data = await api(url, { method: method, body: JSON.stringify(payload) });

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (data && data.success) {
            toast(isEdit ? 'User updated successfully' : 'User created successfully', 'success');
            setTimeout(function() {
                window.location.href = contextPath + '/company-admin/employees';
            }, 1500);
        } else {
            var errorMsg = data?.error || data?.message || 'Failed to save user';
            if (errorMsg.toLowerCase().includes('limit') || errorMsg.toLowerCase().includes('quota')) {
                toast('Employee limit reached. Please contact Super Admin to increase limit.', 'error');
            } else {
                toast(errorMsg, 'error');
            }
        }
    }

    // ==================== EVENT LISTENERS ====================
    document.getElementById('email').addEventListener('blur', function() {
        var email = this.value.trim();
        if (email && !validateEmail(email)) {
            this.classList.add('error');
            toast('Please enter a valid email address', 'error');
        } else {
            this.classList.remove('error');
        }
    });

    document.getElementById('phone').addEventListener('blur', function() {
        var phone = this.value.trim();
        if (phone && !validatePhone(phone)) {
            this.classList.add('error');
            toast('Phone number must be 10-15 digits', 'error');
        } else {
            this.classList.remove('error');
        }
    });

    document.getElementById('email').addEventListener('input', function() {
        this.classList.remove('error');
    });

    document.getElementById('phone').addEventListener('input', function() {
        this.classList.remove('error');
    });

    document.getElementById('employeeForm').addEventListener('submit', function(e) {
        e.preventDefault();
        submitForm();
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

        // Initialize
        async function init() {
            await loadCompanyInfo();
            if (isEdit) {
                await loadEmployeeData();
            }
        }
        init();
        loadNotifications();
    });
</script>

</body>
</html>