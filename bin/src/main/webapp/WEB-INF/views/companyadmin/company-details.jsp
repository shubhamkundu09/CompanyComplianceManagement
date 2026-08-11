<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: companyadmin/company-details.jsp --%>
<% pageContext.setAttribute("pageTitle", "Company Details"); %>

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

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
        }

        /* ==================== AVATAR ==================== */
        .avatar {
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
            font-weight: 600;
            font-size: 14px;
            flex-shrink: 0;
        }

        .avatar.avatar-large {
            width: 72px;
            height: 72px;
            font-size: 28px;
        }

        /* ==================== INFO ROW ==================== */
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.4);
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-row .info-label {
            font-size: 12px;
            color: var(--gray-500);
        }

        .info-row .info-value {
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-800);
        }

        .info-row .info-value a {
            color: var(--primary);
            text-decoration: none;
        }

        .info-row .info-value a:hover {
            text-decoration: underline;
        }

        /* ==================== DETAILS GRID ==================== */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 32px;
        }

        .details-section {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: var(--radius);
            padding: 20px;
        }

        .details-section .section-title {
            font-size: 13px;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.4);
            display: flex;
            align-items: center;
            gap: 8px;
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
            .details-grid { grid-template-columns: 1fr; gap: 16px; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
        }

        @media (max-width: 480px) {
            .header-left .page-title { font-size: 15px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .details-section { padding: 14px; }
            .info-row { flex-direction: column; gap: 2px; }
            .info-row .info-value { font-size: 14px; }
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
           <a href="${pageContext.request.contextPath}/company-admin/dashboard" class="nav-item active">
               <i class="fas fa-chart-pie"></i> Dashboard
           </a>

           <div class="sidebar-label">Management</div>
           <a href="${pageContext.request.contextPath}/company-admin/employees" class="nav-item">
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

        <!-- ==================== PAGE HEADER ==================== -->
        <div style="margin-bottom:24px;">
            <p style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                Settings
            </p>
            <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">Company Details</h1>
            <p style="font-size:13px;color:var(--gray-500);margin-top:6px;">
                View and manage your company information
            </p>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" style="display:flex;align-items:center;justify-content:center;padding:80px 0;">
            <div class="spinner"></div>
        </div>

        <!-- ==================== CONTENT ==================== -->
        <div id="pageContent" style="display:none;">

            <!-- Company Header Card -->
            <div class="glass-card" style="padding:24px;margin-bottom:24px;">
                <div style="display:flex;align-items:center;gap:20px;flex-wrap:wrap;">
                    <div class="avatar avatar-large" id="compAvatar">?</div>
                    <div style="flex:1;">
                        <h2 id="compName" style="font-size:22px;font-weight:700;color:var(--gray-900);margin-bottom:4px;">—</h2>
                        <div id="compEmail" style="font-size:13px;color:var(--gray-500);">—</div>
                    </div>
                    <div id="compStatusBadge"></div>
                </div>
            </div>

            <!-- Details Grid -->
            <div class="details-grid">

                <!-- Left Column -->
                <div>

                    <!-- Company Information -->
                    <div class="details-section">
                        <div class="section-title">
                            <i class="fas fa-building"></i> Company Information
                        </div>
                        <div id="companyInfo"></div>
                    </div>

                    <!-- Contact Information -->
                    <div class="details-section" style="margin-top:16px;">
                        <div class="section-title">
                            <i class="fas fa-phone"></i> Contact Information
                        </div>
                        <div id="contactInfo"></div>
                    </div>

                    <!-- Address -->
                    <div class="details-section" style="margin-top:16px;">
                        <div class="section-title">
                            <i class="fas fa-map-marker-alt"></i> Address
                        </div>
                        <div id="addressInfo"></div>
                    </div>

                </div>

                <!-- Right Column -->
                <div>

                    <!-- Tax & Registration -->
                    <div class="details-section">
                        <div class="section-title">
                            <i class="fas fa-file-invoice"></i> Tax & Registration
                        </div>
                        <div id="taxInfo"></div>
                    </div>

                    <!-- Subscription -->
                    <div class="details-section" style="margin-top:16px;">
                        <div class="section-title">
                            <i class="fas fa-calendar-alt"></i> Subscription
                        </div>
                        <div id="subscriptionInfo"></div>
                    </div>

                    <!-- Employee Capacity -->
                    <div class="details-section" style="margin-top:16px;">
                        <div class="section-title">
                            <i class="fas fa-users"></i> Employee Capacity
                        </div>
                        <div id="employeeLimitInfo"></div>
                    </div>

                    <!-- Admin Information -->
                    <div class="details-section" style="margin-top:16px;">
                        <div class="section-title">
                            <i class="fas fa-user-shield"></i> Company Admin
                        </div>
                        <div id="adminInfo"></div>
                    </div>

                </div>

            </div>

        </div>

    </main>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';

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

    function getInitials(first, last) {
        return ((first || '')[0] || '') + ((last || '')[0] || '');
    }

    function infoRow(label, value) {
        return '<div class="info-row"><span class="info-label">' + label + '</span><span class="info-value">' + (value || '—') + '</span></div>';
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

    // ==================== LOAD COMPANY DETAILS ====================
    async function loadCompanyDetails() {
        try {
            var data = await api('/api/company-admin/company');
            if (!data || !data.success) {
                toast('Failed to load company details', 'error');
                document.getElementById('loader').style.display = 'none';
                return;
            }

            var c = data.data;
            renderCompanyDetails(c);
            document.getElementById('loader').style.display = 'none';
            document.getElementById('pageContent').style.display = 'block';
        } catch (error) {
            console.error('Error loading company:', error);
            toast('Failed to load company details', 'error');
            document.getElementById('loader').style.display = 'none';
        }
    }

    function renderCompanyDetails(c) {
        // Header
        document.getElementById('compName').textContent = c.name || '—';
        document.getElementById('compEmail').textContent = c.email || '—';
        document.getElementById('compAvatar').textContent = (c.name || '?')[0].toUpperCase();

        var statusClass = (c.status === 'ACTIVE') ? 'badge-active' : 'badge-inactive';
        var statusHtml = '<span class="badge ' + statusClass + '"><i class="fas fa-circle" style="font-size:5px;margin-right:4px;"></i> ' + (c.status || 'INACTIVE') + '</span>';
        document.getElementById('compStatusBadge').innerHTML = statusHtml;

        // Company Information
        document.getElementById('companyInfo').innerHTML =
            infoRow('Company Name', c.name) +
            infoRow('Description', c.description || '—');

        // Contact Information
        var websiteLink = c.website ? '<a href="' + c.website + '" target="_blank">' + c.website + '</a>' : '—';
        document.getElementById('contactInfo').innerHTML =
            infoRow('Email', c.email) +
            infoRow('Phone', c.phone || '—') +
            infoRow('Website', websiteLink);

        // Address
        var fullAddress = [c.address, c.city, c.state, c.country, c.postalCode].filter(function(a) { return a && a.trim(); }).join(', ');
        document.getElementById('addressInfo').innerHTML =
            infoRow('Full Address', fullAddress || '—') +
            infoRow('City', c.city || '—') +
            infoRow('State', c.state || '—') +
            infoRow('Country', c.country || '—') +
            infoRow('Postal Code', c.postalCode || '—');

        // Tax Information
        document.getElementById('taxInfo').innerHTML =
            infoRow('GST Number', c.gstNumber || '—') +
            infoRow('PAN Number', c.panNumber || '—') +
            infoRow('Tax ID', c.taxId || '—') +
            infoRow('Registration Number', c.registrationNumber || '—');

        // Subscription
        var subExpired = c.subscriptionEndDate && new Date(c.subscriptionEndDate) < new Date();
        var daysLeft = c.subscriptionEndDate ? Math.ceil((new Date(c.subscriptionEndDate) - new Date()) / 86400000) : null;
        var daysColor = '#64748b';
        if (daysLeft !== null) {
            daysColor = daysLeft > 30 ? 'var(--success)' : (daysLeft > 7 ? 'var(--warning)' : 'var(--danger)');
        }

        var subHtml = infoRow('Start Date', formatDate(c.subscriptionStartDate)) +
            infoRow('End Date', formatDate(c.subscriptionEndDate)) +
            infoRow('Status', '<span class="badge ' + (subExpired ? 'badge-inactive' : 'badge-active') + '">' + (subExpired ? 'Expired' : 'Active') + '</span>');

        if (daysLeft !== null && !subExpired) {
            subHtml += infoRow('Days Remaining', '<span style="color:' + daysColor + ';font-weight:600;">' + daysLeft + ' days</span>');
        }
        document.getElementById('subscriptionInfo').innerHTML = subHtml;

        // Employee Capacity
        var limit = c.employeeLimit || 0;
        var current = c.currentEmployeeCount || 0;
        var pct = limit > 0 ? Math.round((current / limit) * 100) : 0;
        var barColor = pct > 80 ? 'var(--danger)' : (pct > 60 ? 'var(--warning)' : 'var(--success)');

        document.getElementById('employeeLimitInfo').innerHTML =
            '<div style="margin-bottom:12px;">' +
                '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                    '<span style="font-size:12px;color:var(--gray-500);">Used / Limit</span>' +
                    '<span style="font-size:13px;font-weight:600;">' + current + ' / ' + (limit > 0 ? limit : '∞') + '</span>' +
                '</div>' +
                '<div class="progress-bar">' +
                    '<div class="progress-fill" style="width:' + Math.min(pct, 100) + '%;background:' + barColor + ';"></div>' +
                '</div>' +
                '<div style="font-size:11px;color:var(--gray-500);margin-top:4px;">' + ((limit - current) > 0 ? (limit - current) + ' slots available' : 'No slots available') + '</div>' +
            '</div>' +
            infoRow('Documents Status', '<span class="badge ' + (c.documentsVerified ? 'badge-success' : 'badge-warning') + '">' + (c.documentsVerified ? '✓ Verified' : '⏳ Pending') + '</span>');

        // Admin Information
        var admin = c.companyAdmin;
        if (admin) {
            var adminStatusClass = (admin.status === 'ACTIVE') ? 'badge-active' : 'badge-inactive';
            var adminInitials = getInitials(admin.firstName, admin.lastName) || '?';
            document.getElementById('adminInfo').innerHTML =
                '<div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;">' +
                    '<div class="avatar" style="width:40px;height:40px;font-size:14px;background:linear-gradient(135deg, var(--primary-light), var(--primary));">' + adminInitials + '</div>' +
                    '<div>' +
                        '<div style="font-weight:600;color:var(--gray-800);">' + escapeHtml(admin.firstName) + ' ' + escapeHtml(admin.lastName) + '</div>' +
                        '<div style="font-size:12px;color:var(--gray-500);">' + escapeHtml(admin.email) + '</div>' +
                    '</div>' +
                '</div>' +
                infoRow('Phone', admin.phoneNumber || '—') +
                infoRow('Status', '<span class="badge ' + adminStatusClass + '">' + (admin.status || 'INACTIVE') + '</span>') +
                infoRow('Member Since', formatDate(admin.createdAt));
        } else {
            document.getElementById('adminInfo').innerHTML = infoRow('Admin', 'No admin assigned');
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

        loadCompanyDetails();
        loadNotifications();
    });
</script>

</body>
</html>