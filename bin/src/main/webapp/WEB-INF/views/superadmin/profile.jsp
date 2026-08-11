<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "My Profile"); %>


<%-- File: superadmin/profile.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext LLP — My Profile</title>

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

        /* ==================== PROFILE HEADER ==================== */
        .profile-header {
            padding: 28px 32px;
            text-align: center;
        }

        .profile-header .profile-avatar {
            width: 96px;
            height: 96px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 36px;
            font-weight: 700;
            color: white;
            box-shadow: 0 8px 32px rgba(79, 70, 229, 0.3);
            border: 4px solid rgba(255, 255, 255, 0.4);
        }

        .profile-header .profile-name {
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .profile-header .profile-email {
            font-size: 14px;
            color: var(--gray-500);
            margin-top: 4px;
        }

        .profile-header .profile-role {
            display: inline-block;
            margin-top: 8px;
            padding: 4px 16px;
            border-radius: 20px;
            background: var(--primary-bg);
            color: var(--primary);
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
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

        .form-input.readonly {
            background: rgba(226, 232, 240, 0.2);
            cursor: default;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
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

        .btn-success {
            background: var(--success);
            color: white;
            border-color: var(--success);
        }

        .btn-success:hover {
            background: #059669;
            border-color: #059669;
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
            .grid-2 { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }

            .card { padding: 20px !important; }
            .profile-header { padding: 20px; }
            .profile-header .profile-avatar { width: 72px; height: 72px; font-size: 28px; }
            .form-actions { flex-direction: column; }
            .form-actions .btn { width: 100%; justify-content: center; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .profile-header .profile-name { font-size: 18px; }
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

                                <img style="width:100%;" src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
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
        <a href="${pageContext.request.contextPath}/super-admin/compliance/templates" class="nav-item">
            <i class="fas fa-tags"></i> Categories
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${pageContext.request.contextPath}/super-admin/notifications" class="nav-item">
            <i class="fas fa-bell"></i> Notifications
            <span class="nav-badge" id="notifCount">0</span>
        </a>

        <div class="sidebar-label">Account</div>
        <a href="${pageContext.request.contextPath}/super-admin/profile" class="nav-item active">
            <i class="fas fa-user-circle"></i> My Profile
        </a>
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
            <span class="page-title">My Profile</span>
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
            <div class="header-user">
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
            <div class="page-subtitle"><i class="fas fa-user-circle" style="margin-right:6px;"></i>Account</div>
            <h1>My Profile</h1>
        </div>

        <!-- ==================== PROFILE CARD ==================== -->
        <div style="max-width: 800px; margin: 0 auto;">

            <!-- Profile Header -->
            <div class="card profile-header">
                <div class="profile-avatar" id="profileAvatar">U</div>
                <div class="profile-name" id="profileName">Loading...</div>
                <div class="profile-email" id="profileEmail">loading@email.com</div>
                <div class="profile-role" id="profileRole">SUPER ADMIN</div>
            </div>

            <!-- Edit Profile Form -->
            <div class="card" style="padding: 28px 32px; margin-top: 20px;">
                <h3 style="font-size: 16px; font-weight: 700; color: var(--gray-900); margin-bottom: 20px;">
                    <i class="fas fa-edit" style="color: var(--primary); margin-right: 8px;"></i>Edit Profile Information
                </h3>

                <form id="profileForm" onsubmit="return false;">
                    <div class="grid-2">
                        <div>
                            <label class="form-label"><i class="fas fa-user" style="margin-right: 6px;"></i>First Name <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="firstName" class="form-input" placeholder="Enter first name" required>
                        </div>
                        <div>
                            <label class="form-label"><i class="fas fa-user" style="margin-right: 6px;"></i>Last Name <span style="color:var(--danger);">*</span></label>
                            <input type="text" id="lastName" class="form-input" placeholder="Enter last name" required>
                        </div>
                    </div>

                    <div style="margin-top: 16px;">
                        <label class="form-label"><i class="fas fa-envelope" style="margin-right: 6px;"></i>Email Address</label>
                        <input type="email" id="email" class="form-input readonly" disabled placeholder="email@company.com">
                        <div style="font-size: 11px; color: var(--gray-500); margin-top: 4px;">
                            <i class="fas fa-info-circle"></i> Email cannot be changed. Contact support if you need to update it.
                        </div>
                    </div>

                    <div style="margin-top: 16px;">
                        <label class="form-label"><i class="fas fa-phone" style="margin-right: 6px;"></i>Phone Number</label>
                        <input type="tel" id="phone" class="form-input" placeholder="Enter phone number">
                    </div>

                    <div style="margin-top: 20px; display: flex; gap: 12px;" class="form-actions">
                        <button type="button" onclick="resetForm()" class="btn btn-ghost" style="flex: 1; justify-content: center;">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                        <button type="submit" id="saveBtn" class="btn btn-primary" style="flex: 1; justify-content: center;" onclick="saveProfile()">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>

            <!-- Account Stats -->
            <div class="card" style="padding: 20px 24px; margin-top: 20px;">
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 16px;">
                    <div>
                        <div style="font-size: 10px; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Role</div>
                        <div style="font-size: 14px; font-weight: 600; color: var(--gray-800); margin-top: 2px;" id="accountRole">—</div>
                    </div>
                    <div>
                        <div style="font-size: 10px; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Status</div>
                        <div style="font-size: 14px; font-weight: 600; color: var(--gray-800); margin-top: 2px;">
                            <span class="badge badge-active"><i class="fas fa-circle" style="font-size: 5px; margin-right: 4px;"></i> Active</span>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 10px; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Member Since</div>
                        <div style="font-size: 14px; font-weight: 600; color: var(--gray-800); margin-top: 2px;" id="memberSince">—</div>
                    </div>
                    <div>
                        <div style="font-size: 10px; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px;">Last Login</div>
                        <div style="font-size: 14px; font-weight: 600; color: var(--gray-800); margin-top: 2px;" id="lastLogin">—</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card" style="padding: 20px 24px; margin-top: 20px;">
                <h4 style="font-size: 13px; font-weight: 600; color: var(--gray-700); margin-bottom: 12px;">
                    <i class="fas fa-bolt" style="color: var(--primary); margin-right: 8px;"></i>Quick Actions
                </h4>
                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/change-password" class="btn btn-ghost">
                        <i class="fas fa-key"></i> Change Password
                    </a>
                    <a href="${pageContext.request.contextPath}/super-admin/dashboard" class="btn btn-ghost">
                        <i class="fas fa-chart-pie"></i> Go to Dashboard
                    </a>
                    <button onclick="handleLogout()" class="btn btn-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
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

    // ==================== LOAD PROFILE ====================
    async function loadProfile() {
        try {
            // First try to get from localStorage
            var userStr = localStorage.getItem('user');
            var userData = null;

            if (userStr) {
                try {
                    userData = JSON.parse(userStr);
                } catch(e) {}
            }

            // If we have user data, populate the UI
            if (userData) {
                populateProfile(userData);
            }

            // Also fetch fresh data from API
            var data = await api('/api/auth/me');

            if (data && data.success) {
                var profile = data.data;
                // Update localStorage with fresh data
                localStorage.setItem('user', JSON.stringify(profile));
                populateProfile(profile);
            } else if (!userData) {
                toast('Failed to load profile data', 'error');
            }
        } catch (error) {
            console.error('Error loading profile:', error);
            toast('Error loading profile', 'error');
        }
    }

    function populateProfile(profile) {
        // Header
        document.getElementById('profileName').textContent = (profile.firstName || '') + ' ' + (profile.lastName || '');
        document.getElementById('profileEmail').textContent = profile.email || '—';
        document.getElementById('profileRole').textContent = (profile.role || 'USER').replace('_', ' ');

        var avatarInitial = (profile.firstName || 'U')[0].toUpperCase();
        document.getElementById('profileAvatar').textContent = avatarInitial;
        document.getElementById('userAvatar').textContent = avatarInitial;

        // Form fields
        document.getElementById('firstName').value = profile.firstName || '';
        document.getElementById('lastName').value = profile.lastName || '';
        document.getElementById('email').value = profile.email || '';
        document.getElementById('phone').value = profile.phone || '';

        // Account stats
        document.getElementById('accountRole').textContent = (profile.role || '—').replace('_', ' ');
        document.getElementById('memberSince').textContent = formatDate(profile.createdAt);
        document.getElementById('lastLogin').textContent = profile.lastLoginAt ? formatDateTime(profile.lastLoginAt) : '—';

        // Update header user info
        document.getElementById('userName').textContent = (profile.firstName || '') + ' ' + (profile.lastName || '');
        document.getElementById('userRole').textContent = (profile.role || '').replace('_', ' ');
    }

    // ==================== SAVE PROFILE ====================
    async function saveProfile() {
        var firstName = document.getElementById('firstName').value.trim();
        var lastName = document.getElementById('lastName').value.trim();
        var phone = document.getElementById('phone').value.trim();

        if (!firstName || !lastName) {
            toast('First name and last name are required', 'error');
            return;
        }

        var btn = document.getElementById('saveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

        var payload = {
            firstName: firstName,
            lastName: lastName,
            phone: phone || null
        };

        try {
            var data = await api('/api/auth/profile', {
                method: 'PUT',
                body: JSON.stringify(payload)
            });

            if (data && data.success) {
                // Update localStorage
                var userStr = localStorage.getItem('user');
                if (userStr) {
                    try {
                        var user = JSON.parse(userStr);
                        user.firstName = firstName;
                        user.lastName = lastName;
                        user.phone = phone;
                        localStorage.setItem('user', JSON.stringify(user));
                    } catch(e) {}
                }

                toast('Profile updated successfully!', 'success');
                loadProfile(); // Refresh the UI
            } else {
                toast(data?.error || 'Failed to update profile', 'error');
            }
        } catch (error) {
            console.error('Error saving profile:', error);
            toast('Failed to update profile', 'error');
        }

        btn.disabled = false;
        btn.innerHTML = originalText;
    }

    // ==================== RESET FORM ====================
    function resetForm() {
        var userStr = localStorage.getItem('user');
        if (userStr) {
            try {
                var user = JSON.parse(userStr);
                document.getElementById('firstName').value = user.firstName || '';
                document.getElementById('lastName').value = user.lastName || '';
                document.getElementById('phone').value = user.phone || '';
            } catch(e) {}
        }
        toast('Form reset', 'info');
    }

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        const token = localStorage.getItem('accessToken');
        if (!token) {
            window.location.href = contextPath + '/login?error=Session expired';
            return;
        }

        loadProfile();
        loadDropdownNotifications();
    });
</script>

</body>
</html>