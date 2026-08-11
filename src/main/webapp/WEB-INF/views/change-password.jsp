<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Determine which dashboard to redirect to based on user role
    String redirectUrl = "/super-admin/dashboard";
    pageContext.setAttribute("redirectUrl", redirectUrl);
    pageContext.setAttribute("pageTitle", "Change Password");
%>
<%-- File: change-password.jsp --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext LLP — Change Password</title>

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

        /* ==================== PAGE HEADER ==================== */
        .page-header {
            margin-bottom: 24px;
        }

        .page-header .page-subtitle {
            font-size: 12px;
            font-weight: 600;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 4px;
        }

        .page-header h1 {
            font-size: 24px;
            font-weight: 700;
            color: var(--gray-900);
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

        /* ==================== FORM ==================== */
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 4px;
        }

        .form-label i {
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

        .form-input:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
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

        /* ==================== PASSWORD REQUIREMENTS ==================== */
        .req-list {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            font-size: 11px;
        }

        .req-list .req-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .req-list .req-item i {
            font-size: 5px;
        }

        .req-list .req-item.met {
            color: var(--success);
        }

        .req-list .req-item.unmet {
            color: var(--gray-500);
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
            .req-list { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }

            .card { padding: 20px !important; }
            .form-group { flex-direction: column; }
            .form-group .btn { width: 100%; justify-content: center; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .req-list { grid-template-columns: 1fr; }
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
        <a href="${baseUrl}/super-admin/compliance/templates" class="nav-item">
            <i class="fas fa-tags"></i> Categories
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${baseUrl}/super-admin/notifications" class="nav-item">
            <i class="fas fa-bell"></i> Notifications

        </a>

        <div class="sidebar-label">Account</div>
        <a href="${baseUrl}/change-password" class="nav-item active">
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
            <span class="page-title">Change Password</span>
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

        <!-- ==================== PAGE HEADER ==================== -->
        <div class="page-header">
            <div class="page-subtitle"><i class="fas fa-shield-alt" style="margin-right:6px;"></i>Security</div>
            <h1>Change Password</h1>
        </div>

        <!-- ==================== PASSWORD CHANGE CARD ==================== -->
        <div style="max-width:560px;margin:0 auto;">
            <div class="card" style="padding:28px 32px;">
                <div style="text-align:center;margin-bottom:24px;">
                    <div style="width:64px;height:64px;background:rgba(79,70,229,0.12);border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:16px;">
                        <i class="fas fa-lock" style="font-size:28px;color:var(--primary);"></i>
                    </div>
                    <h2 style="font-size:18px;font-weight:700;color:var(--gray-900);margin-bottom:6px;">Secure Your Account</h2>
                    <p style="font-size:13px;color:var(--gray-500);">Create a strong and unique password</p>
                </div>

                <form id="changePasswordForm" onsubmit="return false;">
                    <!-- Current Password -->
                    <div style="margin-bottom:20px;">
                        <label class="form-label">
                            <i class="fas fa-key" style="margin-right:6px;font-size:11px;"></i>Current Password
                        </label>
                        <div style="position:relative;">
                            <input type="password" id="currentPassword" class="form-input" style="padding-right:40px;" placeholder="Enter your current password" required>
                            <button type="button" onclick="togglePassword('currentPassword')" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-500);cursor:pointer;padding:4px;">
                                <i class="fas fa-eye" style="font-size:12px;"></i>
                            </button>
                        </div>
                        <div id="currentError" style="font-size:11px;color:var(--danger);margin-top:4px;display:none;"></div>
                    </div>

                    <!-- New Password -->
                    <div style="margin-bottom:20px;">
                        <label class="form-label">
                            <i class="fas fa-lock" style="margin-right:6px;font-size:11px;"></i>New Password
                        </label>
                        <div style="position:relative;">
                            <input type="password" id="newPassword" class="form-input" style="padding-right:40px;" placeholder="Enter new password" required>
                            <button type="button" onclick="togglePassword('newPassword')" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-500);cursor:pointer;padding:4px;">
                                <i class="fas fa-eye" style="font-size:12px;"></i>
                            </button>
                        </div>
                        <div id="newError" style="font-size:11px;color:var(--danger);margin-top:4px;display:none;"></div>
                    </div>

                    <!-- Confirm Password -->
                    <div style="margin-bottom:24px;">
                        <label class="form-label">
                            <i class="fas fa-check-circle" style="margin-right:6px;font-size:11px;"></i>Confirm New Password
                        </label>
                        <div style="position:relative;">
                            <input type="password" id="confirmPassword" class="form-input" style="padding-right:40px;" placeholder="Confirm your new password" required>
                            <button type="button" onclick="togglePassword('confirmPassword')" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-500);cursor:pointer;padding:4px;">
                                <i class="fas fa-eye" style="font-size:12px;"></i>
                            </button>
                        </div>
                        <div id="confirmError" style="font-size:11px;color:var(--danger);margin-top:4px;display:none;"></div>
                    </div>

                    <!-- Password Requirements -->
                    <div style="background:rgba(226,232,240,0.12);border-radius:var(--radius);padding:14px;margin-bottom:24px;">
                        <div style="font-size:11px;font-weight:600;color:var(--primary);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">
                            <i class="fas fa-shield-alt" style="margin-right:6px;"></i>Password Requirements
                        </div>
                        <div class="req-list">
                            <div id="reqLength" class="req-item unmet"><i class="fas fa-circle"></i> At least 8 characters</div>
                            <div id="reqUpper" class="req-item unmet"><i class="fas fa-circle"></i> Uppercase letter (A-Z)</div>
                            <div id="reqLower" class="req-item unmet"><i class="fas fa-circle"></i> Lowercase letter (a-z)</div>
                            <div id="reqNumber" class="req-item unmet"><i class="fas fa-circle"></i> Number (0-9)</div>
                            <div id="reqSpecial" class="req-item unmet"><i class="fas fa-circle"></i> Special character (@#$%^&+=)</div>
                            <div id="reqNoSpace" class="req-item unmet"><i class="fas fa-circle"></i> No spaces allowed</div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div style="display:flex;gap:12px;">
                        <button type="button" onclick="cancelChange()" class="btn btn-ghost" style="flex:1;justify-content:center;">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" id="submitBtn" class="btn btn-primary" style="flex:1;justify-content:center;" onclick="submitPasswordChange()">
                            <i class="fas fa-save"></i> Update Password
                        </button>
                    </div>
                </form>
            </div>

            <!-- Security Tips -->
            <div class="card" style="margin-top:20px;padding:18px 24px;">
                <div style="display:flex;align-items:flex-start;gap:12px;">
                    <i class="fas fa-shield-alt" style="font-size:24px;color:var(--success);flex-shrink:0;margin-top:2px;"></i>
                    <div>
                        <div style="font-size:13px;font-weight:600;color:var(--gray-800);margin-bottom:4px;">Security Tips</div>
                        <div style="font-size:11px;color:var(--gray-500);line-height:1.6;">
                            • Never share your password with anyone<br>
                            • Use a unique password for each account<br>
                            • Enable two-factor authentication if available
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    var contextPath = '${baseUrl}';

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
            loadDropdownNotifications();
        }
    }

    async function loadDropdownNotifications() {
        try {
            var data = await api('/api/notifications/active');
            var list = document.getElementById('notificationList');
            if (!list) return;

            if (data && data.success && data.data && data.data.length > 0) {
                var html = '';
                for (var i = 0; i < Math.min(data.data.length, 10); i++) {
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
                if (data.data.length > 10) {
                    html += '<div style="padding:12px 20px;text-align:center;color:var(--gray-500);font-size:12px;">+ ' + (data.data.length - 10) + ' more</div>';
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

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;';
            if (m === '<') return '&lt;';
            if (m === '>') return '&gt;';
            return m;
        });
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

    // ==================== PASSWORD FUNCTIONS ====================

    // Determine API endpoint based on user role
    function getChangePasswordEndpoint() {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const role = user.role;

        if (role === 'SUPER_ADMIN') {
            return '/api/super-admin/change-password';
        } else if (role === 'COMPANY_ADMIN') {
            return '/api/company-admin/change-password';
        } else if (role === 'EMPLOYEE') {
            return '/api/employee/change-password';
        }
        return '/api/auth/change-password';
    }

    // Toggle password visibility
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const type = field.type === 'password' ? 'text' : 'password';
        field.type = type;
    }

    // Validate password strength
    function validatePasswordStrength(password) {
        const checks = {
            length: password.length >= 8,
            upper: /[A-Z]/.test(password),
            lower: /[a-z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[@#$%^&+=]/.test(password),
            noSpace: !/\s/.test(password)
        };

        // Update UI
        const items = ['reqLength', 'reqUpper', 'reqLower', 'reqNumber', 'reqSpecial', 'reqNoSpace'];
        const keys = ['length', 'upper', 'lower', 'number', 'special', 'noSpace'];

        for (var i = 0; i < items.length; i++) {
            const el = document.getElementById(items[i]);
            if (checks[keys[i]]) {
                el.className = 'req-item met';
                el.innerHTML = '<i class="fas fa-check-circle"></i> ' + el.textContent.trim();
            } else {
                el.className = 'req-item unmet';
                el.innerHTML = '<i class="fas fa-circle"></i> ' + el.textContent.trim();
            }
        }

        return checks.length && checks.upper && checks.lower && checks.number && checks.special && checks.noSpace;
    }

    // Validate form
    function validateForm() {
        const currentPwd = document.getElementById('currentPassword').value;
        const newPwd = document.getElementById('newPassword').value;
        const confirmPwd = document.getElementById('confirmPassword').value;
        let isValid = true;

        // Clear previous errors
        document.getElementById('currentError').style.display = 'none';
        document.getElementById('newError').style.display = 'none';
        document.getElementById('confirmError').style.display = 'none';

        // Validate current password
        if (!currentPwd) {
            document.getElementById('currentError').innerHTML = 'Current password is required';
            document.getElementById('currentError').style.display = 'block';
            isValid = false;
        }

        // Validate new password
        if (!newPwd) {
            document.getElementById('newError').innerHTML = 'New password is required';
            document.getElementById('newError').style.display = 'block';
            isValid = false;
        } else if (!validatePasswordStrength(newPwd)) {
            document.getElementById('newError').innerHTML = 'Password does not meet requirements';
            document.getElementById('newError').style.display = 'block';
            isValid = false;
        }

        // Validate confirm password
        if (!confirmPwd) {
            document.getElementById('confirmError').innerHTML = 'Please confirm your new password';
            document.getElementById('confirmError').style.display = 'block';
            isValid = false;
        } else if (newPwd !== confirmPwd) {
            document.getElementById('confirmError').innerHTML = 'Passwords do not match';
            document.getElementById('confirmError').style.display = 'block';
            isValid = false;
        }

        // Check if new password is same as current
        if (isValid && currentPwd === newPwd) {
            document.getElementById('newError').innerHTML = 'New password cannot be the same as current password';
            document.getElementById('newError').style.display = 'block';
            isValid = false;
        }

        return isValid;
    }

    // Submit password change
    async function submitPasswordChange() {
        if (!validateForm()) {
            return;
        }

        const btn = document.getElementById('submitBtn');
        const originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';

        const payload = {
            currentPassword: document.getElementById('currentPassword').value,
            newPassword: document.getElementById('newPassword').value,
            confirmPassword: document.getElementById('confirmPassword').value
        };

        const endpoint = getChangePasswordEndpoint();

        try {
            const response = await api(endpoint, {
                method: 'PUT',
                body: JSON.stringify(payload)
            });

            if (response && response.success) {
                toast('Password changed successfully! Please login again.', 'success', 3000);

                // Clear form
                document.getElementById('currentPassword').value = '';
                document.getElementById('newPassword').value = '';
                document.getElementById('confirmPassword').value = '';

                // Reset requirements
                validatePasswordStrength('');

                // Logout after 2 seconds
                setTimeout(() => {
                    localStorage.removeItem('accessToken');
                    localStorage.removeItem('user');
                    window.location.href = contextPath + '/login?message=Password changed successfully. Please login again.';
                }, 2000);
            } else {
                const errorMsg = response?.error || response?.message || 'Failed to change password';
                toast(errorMsg, 'error');
                btn.disabled = false;
                btn.innerHTML = originalText;
            }
        } catch (error) {
            console.error('Password change error:', error);
            toast('An error occurred. Please try again.', 'error');
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    }

    // Cancel button - redirect back to dashboard
    function cancelChange() {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const role = user.role;

        if (role === 'SUPER_ADMIN') {
            window.location.href = contextPath + '/super-admin/dashboard';
        } else if (role === 'COMPANY_ADMIN') {
            window.location.href = contextPath + '/company-admin/dashboard';
        } else {
            window.location.href = contextPath + '/employee/dashboard';
        }
    }

    // ==================== EVENT LISTENERS ====================

    // Real-time password validation
    document.getElementById('newPassword').addEventListener('input', function() {
        validatePasswordStrength(this.value);
    });

    // Enter key submission
    document.getElementById('changePasswordForm').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            submitPasswordChange();
        }
    });

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        const token = localStorage.getItem('accessToken');
        if (!token) {
            window.location.href = contextPath + '/login?error=Session expired';
        }

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

        // Pre-fill requirements check with empty string
        validatePasswordStrength('');

        // Load notifications count
        loadDropdownNotifications();
    });
</script>

</body>
</html>