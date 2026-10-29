<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Compliance History & Overdue Analysis - Super Admin | VNext Legal LLP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --primary-light: #e0e7ff;
            --success: #10b981;
            --success-light: #d1fae5;
            --warning: #f59e0b;
            --warning-light: #fef3c7;
            --danger: #ef4444;
            --danger-light: #fee2e2;
            --info: #06b6d4;
            --info-light: #cffafe;
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
            --radius: 12px;
            --radius-lg: 16px;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
            overflow-x: hidden;
        }

        .app-wrapper { display: flex; min-height: 100vh; position: relative; }

        /* Sidebar Overlay */
        .sidebar-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
            z-index: 998;
        }
        .sidebar-overlay.open { display: block; }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: white;
            border-right: 1px solid var(--gray-200);
            padding: 24px 16px;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 999;
            overflow-y: auto;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
            display: flex;
            align-items: center;
            justify-content: center;
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
        .nav-item:hover { background: rgba(79, 70, 229, 0.08); color: var(--gray-900); }
        .nav-item.active { background: rgba(79, 70, 229, 0.12); color: var(--primary); font-weight: 600; }
        .nav-item i { width: 20px; text-align: center; font-size: 15px; }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 260px;
            right: 0;
            height: 64px;
            background: white;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            z-index: 100;
            transition: left 0.3s;
        }
        .header-left { display: flex; align-items: center; gap: 16px; }
        .menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray-600);
            cursor: pointer;
            padding: 8px;
        }
        .page-title { font-size: 18px; font-weight: 700; color: var(--gray-900); }
        .header-right { display: flex; align-items: center; gap: 16px; }
        .header-user {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: var(--radius);
            transition: background 0.2s;
        }
        .header-user:hover { background: var(--gray-100); }
        .avatar {
            width: 36px;
            height: 36px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
        }
        .user-info { display: flex; flex-direction: column; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--gray-800); }
        .user-role { font-size: 11px; color: var(--gray-500); }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 88px 32px 48px;
            flex: 1;
            width: calc(100% - 260px);
            max-width: 1600px;
        }

        /* Filter Panel */
        .filter-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            margin-bottom: 24px;
        }
        .filter-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 2fr auto;
            gap: 16px;
            align-items: end;
        }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label {
            font-size: 12px;
            font-weight: 600;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-control {
            height: 42px;
            padding: 0 14px;
            border-radius: var(--radius);
            border: 1px solid var(--gray-300);
            font-size: 14px;
            color: var(--gray-800);
            background: white;
            outline: none;
            transition: all 0.2s;
            font-family: inherit;
        }
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }

        /* Status Pills Filter */
        .status-pills {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--gray-100);
        }
        .pill-btn {
            border: 1px solid var(--gray-300);
            background: white;
            color: var(--gray-600);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .pill-btn:hover { background: var(--gray-100); color: var(--gray-900); }
        .pill-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        .pill-btn.active.pill-overdue {
            background: var(--danger);
            border-color: var(--danger);
        }
        .pill-btn.active.pill-completed {
            background: var(--success);
            border-color: var(--success);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 20px;
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary);
        }
        .stat-card.overdue::before { background: var(--danger); }
        .stat-card.completed::before { background: var(--success); }
        .stat-card.month::before { background: var(--warning); }
        .stat-card .info { display: flex; flex-direction: column; }
        .stat-card .label { font-size: 13px; font-weight: 500; color: var(--gray-500); }
        .stat-card .value { font-size: 26px; font-weight: 700; color: var(--gray-900); margin: 4px 0 2px; }
        .stat-card .sub { font-size: 12px; color: var(--gray-400); }
        .stat-card .icon-box {
            width: 48px;
            height: 48px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }
        .stat-card .icon-box.blue { background: var(--primary-light); color: var(--primary); }
        .stat-card .icon-box.red { background: var(--danger-light); color: var(--danger); }
        .stat-card .icon-box.green { background: var(--success-light); color: var(--success); }
        .stat-card .icon-box.amber { background: var(--warning-light); color: var(--warning); }

        /* 12-Month Interactive Grid */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .month-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 10px;
            margin-bottom: 24px;
        }
        .month-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius);
            padding: 12px 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }
        .month-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary);
        }
        .month-card.active {
            border-color: var(--primary);
            background: var(--primary-light);
            box-shadow: 0 0 0 2px var(--primary);
        }
        .month-card .name {
            font-size: 12px;
            font-weight: 700;
            color: var(--gray-700);
            margin-bottom: 6px;
        }
        .month-card.active .name { color: var(--primary-dark); }
        .month-card .overdue-tag {
            font-size: 11px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 12px;
            display: inline-block;
        }
        .month-card .overdue-tag.has-overdue {
            background: var(--danger);
            color: white;
            animation: pulse-badge 2s infinite;
        }
        .month-card .overdue-tag.clean {
            background: var(--gray-100);
            color: var(--gray-500);
        }
        .month-card .overdue-tag.done-only {
            background: var(--success-light);
            color: var(--success);
        }
        .month-card .total-sub {
            font-size: 10px;
            color: var(--gray-400);
            margin-top: 4px;
        }

        @keyframes pulse-badge {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }
        .table-header {
            padding: 18px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--gray-200);
        }
        .table-responsive { width: 100%; overflow-x: auto; }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 13px;
        }
        th {
            background: var(--gray-50);
            padding: 12px 18px;
            font-weight: 600;
            color: var(--gray-600);
            border-bottom: 1px solid var(--gray-200);
            white-space: nowrap;
        }
        td {
            padding: 14px 18px;
            border-bottom: 1px solid var(--gray-100);
            color: var(--gray-700);
            vertical-align: middle;
        }
        tr:hover td { background: rgba(248, 250, 252, 0.8); }

        /* Status & Frequency Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }
        .badge-danger { background: var(--danger-light); color: var(--danger); }
        .badge-success { background: var(--success-light); color: var(--success); }
        .badge-warning { background: var(--warning-light); color: var(--warning); }
        .badge-info { background: var(--info-light); color: var(--info); }
        .badge-gray { background: var(--gray-100); color: var(--gray-600); }

        .company-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: var(--gray-900);
        }
        .company-icon-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--primary-light);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .btn-log {
            background: white;
            border: 1px solid var(--gray-300);
            color: var(--gray-700);
            padding: 6px 12px;
            border-radius: var(--radius);
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-log:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        /* Pagination */
        .pagination-bar {
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top: 1px solid var(--gray-200);
            font-size: 13px;
            color: var(--gray-600);
        }
        .btn-page {
            border: 1px solid var(--gray-300);
            background: white;
            color: var(--gray-700);
            padding: 6px 14px;
            border-radius: var(--radius);
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
            margin-left: 6px;
        }
        .btn-page:hover:not(:disabled) { background: var(--gray-100); }
        .btn-page:disabled { opacity: 0.5; cursor: not-allowed; }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1050;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal.open { display: flex; }
        .modal-content {
            background: white;
            border-radius: var(--radius-xl);
            width: 100%;
            max-width: 650px;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: var(--shadow-xl);
            animation: modalIn 0.25s ease-out;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: translateY(12px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-title { font-size: 16px; font-weight: 700; color: var(--gray-900); }
        .btn-close {
            background: none;
            border: none;
            font-size: 18px;
            color: var(--gray-400);
            cursor: pointer;
            padding: 4px;
        }
        .btn-close:hover { color: var(--gray-800); }
        .modal-body { padding: 24px; }

        /* Timeline in modal */
        .timeline {
            position: relative;
            padding-left: 28px;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 6px;
            bottom: 6px;
            width: 2px;
            background: var(--gray-200);
        }
        .timeline-item {
            position: relative;
            margin-bottom: 22px;
        }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-dot {
            position: absolute;
            left: -28px;
            top: 2px;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: white;
            border: 2px solid var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: var(--primary);
        }
        .timeline-dot.danger { border-color: var(--danger); color: var(--danger); }
        .timeline-dot.success { border-color: var(--success); color: var(--success); }
        .timeline-content {
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius);
            padding: 12px 16px;
        }
        .timeline-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 4px;
        }
        .timeline-action { font-size: 13px; font-weight: 700; color: var(--gray-900); }
        .timeline-date { font-size: 11px; color: var(--gray-500); }
        .timeline-desc { font-size: 12px; color: var(--gray-600); margin-top: 4px; }

        /* Responsive */
        @media (max-width: 1200px) {
            .month-grid { grid-template-columns: repeat(6, 1fr); }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .filter-row { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .header { left: 0; }
            .main-content { margin-left: 0; width: 100%; padding: 80px 16px 32px; }
            .menu-toggle { display: block; }
            .month-grid { grid-template-columns: repeat(3, 1fr); }
            .stats-grid { grid-template-columns: 1fr; }
            .filter-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

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
        <a href="${baseUrl}/super-admin/history" class="nav-item active">
            <i class="fas fa-history"></i> Compliance History
        </a>

        <div class="sidebar-label">Push Settings</div>
        <a href="${baseUrl}/super-admin/notifications" class="nav-item">
            <i class="fas fa-mobile-alt"></i> FCM Push Settings
        </a>

        <div class="sidebar-label">Account</div>
        <a href="${baseUrl}/super-admin/profile" class="nav-item">
            <i class="fas fa-user-shield"></i> My Profile
        </a>
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
            <span class="page-title"><i class="fas fa-history" style="color: var(--primary); margin-right: 8px;"></i> Compliance History & Overdue Analysis</span>
        </div>
        <div class="header-right">
            <div class="header-user" onclick="window.location.href='${baseUrl}/super-admin/profile'">
                <div class="avatar" id="userAvatar">SA</div>
                <div class="user-info">
                    <span class="user-name" id="userName">Super Admin</span>
                    <span class="user-role">Administrator</span>
                </div>
            </div>
        </div>
    </header>

    <!-- ==================== MAIN CONTENT ==================== -->
    <main class="main-content">

        <!-- Filter Card -->
        <div class="filter-card">
            <div class="filter-row">
                <div class="form-group">
                    <label><i class="fas fa-building"></i> Company</label>
                    <select id="companySelect" class="form-control" onchange="onCompanyChange()">
                        <option value="">-- All Companies --</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Year</label>
                    <select id="yearSelect" class="form-control" onchange="onFilterChange()">
                        <option value="2024">2024</option>
                        <option value="2025">2025</option>
                        <option value="2026" selected>2026</option>
                        <option value="2027">2027</option>
                        <option value="2028">2028</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-day"></i> Month</label>
                    <select id="monthSelect" class="form-control" onchange="onFilterChange()">
                        <option value="0">All Months</option>
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
                <div class="form-group">
                    <label><i class="fas fa-search"></i> Search Compliance / Category</label>
                    <input type="text" id="searchInput" class="form-control" placeholder="Search by name, category..." onkeyup="debounceSearch()">
                </div>
                <div style="display: flex; gap: 8px;">
                    <button class="btn-log" onclick="resetFilters()" title="Reset All Filters">
                        <i class="fas fa-undo"></i> Reset
                    </button>
                </div>
            </div>

            <!-- Status Pill Filters -->
            <div class="status-pills">
                <span style="font-size: 12px; font-weight: 600; color: var(--gray-500); align-self: center; margin-right: 6px;">Status:</span>
                <button class="pill-btn active" data-status="" onclick="selectStatusFilter(this, '')">All</button>
                <button class="pill-btn pill-overdue" data-status="OVERDUE" onclick="selectStatusFilter(this, 'OVERDUE')">
                    <i class="fas fa-exclamation-circle text-danger"></i> Overdue
                </button>
                <button class="pill-btn pill-completed" data-status="COMPLETED" onclick="selectStatusFilter(this, 'COMPLETED')">
                    <i class="fas fa-check-circle text-success"></i> Completed
                </button>
                <button class="pill-btn" data-status="IN_PROGRESS" onclick="selectStatusFilter(this, 'IN_PROGRESS')">
                    <i class="fas fa-spinner"></i> In Progress
                </button>
                <button class="pill-btn" data-status="PENDING" onclick="selectStatusFilter(this, 'PENDING')">
                    <i class="fas fa-clock"></i> Pending
                </button>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="info">
                    <span class="label">Total Compliances in Year</span>
                    <span class="value" id="kpiTotal">—</span>
                    <span class="sub" id="kpiScope">Across all companies</span>
                </div>
                <div class="icon-box blue"><i class="fas fa-tasks"></i></div>
            </div>
            <div class="stat-card overdue">
                <div class="info">
                    <span class="label">Total Overdue Events</span>
                    <span class="value" id="kpiOverdue" style="color: var(--danger);">—</span>
                    <span class="sub">Items requiring urgent attention</span>
                </div>
                <div class="icon-box red"><i class="fas fa-exclamation-triangle"></i></div>
            </div>
            <div class="stat-card completed">
                <div class="info">
                    <span class="label">Resolved / Completed</span>
                    <span class="value" id="kpiCompleted" style="color: var(--success);">—</span>
                    <span class="sub">Successfully filed</span>
                </div>
                <div class="icon-box green"><i class="fas fa-check-double"></i></div>
            </div>
            <div class="stat-card month">
                <div class="info">
                    <span class="label">Most Overdue Month</span>
                    <span class="value" id="kpiMostOverdue" style="font-size: 18px; color: var(--warning); margin-top: 8px;">—</span>
                    <span class="sub">Peak overdue period</span>
                </div>
                <div class="icon-box amber"><i class="fas fa-calendar-times"></i></div>
            </div>
        </div>

        <!-- 12-Month Visual Grid -->
        <div class="section-header">
            <span class="section-title"><i class="fas fa-calendar-check" style="color: var(--primary);"></i> Month-by-Month Overdue & Compliance Health</span>
            <span style="font-size: 12px; color: var(--gray-500);">Click any month card to quickly filter table</span>
        </div>
        <div class="month-grid" id="monthCardsContainer">
            <!-- 12 months dynamically populated -->
        </div>

        <!-- Detailed History Table -->
        <div class="table-card">
            <div class="table-header">
                <div>
                    <h3 style="font-size: 15px; font-weight: 700; color: var(--gray-900);">Compliance Records</h3>
                    <p style="font-size: 12px; color: var(--gray-500); margin-top: 2px;" id="tableSubtitle">Showing compliance history and overdue records</p>
                </div>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Company</th>
                        <th>Compliance / Category</th>
                        <th>Frequency</th>
                        <th>Scheduled Due Date</th>
                        <th>Month / Period</th>
                        <th>Status</th>
                        <th>Delay / Completion Info</th>
                        <th>Audit Trail</th>
                    </tr>
                    </thead>
                    <tbody id="historyTableBody">
                    <tr><td colspan="9" style="text-align: center; padding: 32px; color: var(--gray-400);"><i class="fas fa-spinner fa-spin"></i> Loading compliance records...</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="pagination-bar">
                <span id="pageInfo">Showing 0-0 of 0 records</span>
                <div>
                    <button class="btn-page" id="btnPrev" onclick="changePage(-1)" disabled><i class="fas fa-chevron-left"></i> Prev</button>
                    <button class="btn-page" id="btnNext" onclick="changePage(1)" disabled>Next <i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- ==================== AUDIT LOG MODAL ==================== -->
<div class="modal" id="auditModal" onclick="closeModalOnOverlay(event)">
    <div class="modal-content">
        <div class="modal-header">
            <div>
                <h3 class="modal-title" id="modalComplianceTitle">Compliance Audit Trail</h3>
                <p style="font-size: 12px; color: var(--gray-500); margin-top: 2px;" id="modalCompanySubtitle"></p>
            </div>
            <button class="btn-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div class="timeline" id="modalTimeline">
                <!-- Timeline items loaded dynamically -->
            </div>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var token = localStorage.getItem('accessToken') || '';
    var currentPage = 0;
    var pageSize = 15;
    var totalPages = 0;
    var currentStatusFilter = '';
    var searchTimer = null;

    // Concurrency control tokens & abort controllers
    var recordsRequestId = 0;
    var summaryRequestId = 0;
    var recordsAbortController = null;
    var summaryAbortController = null;

    // Initialize
    document.addEventListener('DOMContentLoaded', async function() {
        var user = JSON.parse(localStorage.getItem('user') || '{}');
        if (user.fullName) {
            document.getElementById('userName').textContent = user.fullName;
            var initials = user.fullName.split(' ').map(function(n) { return n[0]; }).join('').toUpperCase();
            document.getElementById('userAvatar').textContent = initials || 'SA';
        }

        // Set default year to current year
        var nowYear = new Date().getFullYear();
        var yearSel = document.getElementById('yearSelect');
        if (yearSel) {
            for (var i = 0; i < yearSel.options.length; i++) {
                if (yearSel.options[i].value == nowYear) {
                    yearSel.selectedIndex = i;
                    break;
                }
            }
        }

        // Check URL params for companyId
        var urlParams = new URLSearchParams(window.location.search);
        var initialCompanyId = urlParams.get('companyId') || '';

        // Pre-populate companies dropdown and pre-select BEFORE firing data queries
        try {
            await loadCompaniesDropdown(initialCompanyId);
        } catch (e) {
            console.error('Failed to load companies dropdown:', e);
        }

        // Load summary and records
        loadHistorySummary();
        loadHistoryRecords();
    });

    // Helper for API calls with abort signal support
    async function apiCall(url, signal) {
        var authToken = localStorage.getItem('accessToken') || '';
        try {
            var options = {
                headers: {
                    'Authorization': 'Bearer ' + authToken,
                    'Content-Type': 'application/json'
                }
            };
            if (signal) {
                options.signal = signal;
            }
            var res = await fetch(contextPath + url, options);
            if (res.status === 401) {
                localStorage.removeItem('accessToken');
                window.location.href = contextPath + '/login?error=Session expired';
                return null;
            }
            return await res.json();
        } catch (err) {
            if (err.name === 'AbortError') {
                return null; // clean cancellation
            }
            console.error('API Error:', err);
            return null;
        }
    }

    // Load active companies into dropdown
    async function loadCompaniesDropdown(selectedId) {
        var select = document.getElementById('companySelect');
        select.innerHTML = '<option value="">-- All Companies --</option>';
        var res = await apiCall('/api/super-admin/companies?size=100');
        if (res && res.success && res.data) {
            var companies = res.data.content || res.data || [];
            companies.forEach(function(c) {
                var opt = document.createElement('option');
                opt.value = c.id;
                opt.textContent = c.name + (c.companyCode ? ' (' + c.companyCode + ')' : '');
                if (selectedId && String(c.id) === String(selectedId)) {
                    opt.selected = true;
                }
                select.appendChild(opt);
            });
            if (selectedId) {
                select.value = String(selectedId);
            }
        }
    }

    // Load Summary & 12 Month Grid
    async function loadHistorySummary() {
        if (summaryAbortController) {
            try { summaryAbortController.abort(); } catch (e) {}
        }
        summaryAbortController = new AbortController();
        var signal = summaryAbortController.signal;
        var reqId = ++summaryRequestId;

        var compId = document.getElementById('companySelect').value;
        var year = document.getElementById('yearSelect').value;

        var url = '/api/super-admin/compliance/history/summary?year=' + year;
        if (compId) url += '&companyId=' + compId;

        var res = await apiCall(url, signal);
        if (reqId !== summaryRequestId || (signal && signal.aborted)) {
            return; // Discard stale response
        }

        if (res && res.success && res.data) {
            var data = res.data;
            document.getElementById('kpiTotal').textContent = data.totalCompliances;
            document.getElementById('kpiOverdue').textContent = data.totalOverdue;
            document.getElementById('kpiCompleted').textContent = data.totalCompleted;
            document.getElementById('kpiMostOverdue').textContent = data.mostOverdueMonth || 'None';
            document.getElementById('kpiScope').textContent = data.companyName;

            renderMonthCards(data.monthlyBreakdown);
        }
    }

    // Render Month Cards
    function renderMonthCards(months) {
        var container = document.getElementById('monthCardsContainer');
        container.innerHTML = '';
        var selectedMonth = parseInt(document.getElementById('monthSelect').value) || 0;

        months.forEach(function(m) {
            var card = document.createElement('div');
            card.className = 'month-card' + (selectedMonth === m.month ? ' active' : '');
            card.onclick = function() {
                var monthSelect = document.getElementById('monthSelect');
                if (selectedMonth === m.month) {
                    monthSelect.value = '0';
                } else {
                    monthSelect.value = String(m.month);
                }
                onFilterChange();
            };

            var tagClass = 'clean';
            var tagText = 'Clear';
            if (m.overdueCount > 0) {
                tagClass = 'has-overdue';
                tagText = m.overdueCount + ' Overdue';
            } else if (m.completedCount > 0) {
                tagClass = 'done-only';
                tagText = m.completedCount + ' Done';
            }

            card.innerHTML =
                '<div class="name">' + m.monthName.substring(0, 3) + '</div>' +
                '<span class="overdue-tag ' + tagClass + '">' + tagText + '</span>' +
                '<div class="total-sub">' + m.totalCount + ' total</div>';

            container.appendChild(card);
        });
    }

    // Load Paginated Records
    async function loadHistoryRecords() {
        if (recordsAbortController) {
            try { recordsAbortController.abort(); } catch (e) {}
        }
        recordsAbortController = new AbortController();
        var signal = recordsAbortController.signal;
        var reqId = ++recordsRequestId;

        var compId = document.getElementById('companySelect').value;
        var year = document.getElementById('yearSelect').value;
        var month = document.getElementById('monthSelect').value;
        var search = document.getElementById('searchInput').value.trim();

        // Update table subtitle to reflect current scope
        var selectElem = document.getElementById('companySelect');
        var selectedText = selectElem && selectElem.selectedIndex > 0 ? selectElem.options[selectElem.selectedIndex].text : '';
        var subTitleElem = document.getElementById('tableSubtitle');
        if (subTitleElem) {
            if (compId && selectedText) {
                subTitleElem.textContent = 'Showing records for: ' + selectedText;
            } else {
                subTitleElem.textContent = 'Showing compliance history across all companies';
            }
        }

        var tbody = document.getElementById('historyTableBody');
        tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 28px; color: var(--gray-400);"><i class="fas fa-spinner fa-spin"></i> Fetching records...</td></tr>';

        var url = '/api/super-admin/compliance/history?page=' + currentPage + '&size=' + pageSize;
        if (compId) url += '&companyId=' + compId;
        if (year) url += '&year=' + year;
        if (month && month !== '0') url += '&month=' + month;
        if (currentStatusFilter) url += '&status=' + currentStatusFilter;
        if (search) url += '&search=' + encodeURIComponent(search);

        var res = await apiCall(url, signal);
        if (reqId !== recordsRequestId || (signal && signal.aborted)) {
            return; // Discard stale response
        }

        if (res && res.success && res.data) {
            var data = res.data;
            totalPages = data.totalPages || 0;
            renderTable(data.content || []);
            updatePaginationInfo(data);
        } else if (!signal.aborted) {
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 28px; color: var(--danger);"><i class="fas fa-exclamation-triangle"></i> Failed to load compliance history.</td></tr>';
        }
    }

    // Render Table
    function renderTable(list) {
        var tbody = document.getElementById('historyTableBody');
        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 36px; color: var(--gray-400);"><i class="fas fa-folder-open" style="font-size: 28px; margin-bottom: 8px; display:block;"></i>No compliance records found for the selected filters.</td></tr>';
            return;
        }

        var html = '';
        list.forEach(function(item, idx) {
            var rowNum = (currentPage * pageSize) + idx + 1;

            // Status Badge
            var statusBadge = '';
            if (item.status === 'OVERDUE') {
                statusBadge = '<span class="badge badge-danger"><i class="fas fa-exclamation-circle"></i> OVERDUE</span>';
            } else if (item.status === 'COMPLETED') {
                statusBadge = '<span class="badge badge-success"><i class="fas fa-check-circle"></i> COMPLETED</span>';
            } else if (item.status === 'IN_PROGRESS') {
                statusBadge = '<span class="badge badge-warning"><i class="fas fa-clock"></i> IN PROGRESS</span>';
            } else {
                statusBadge = '<span class="badge badge-gray"><i class="fas fa-hourglass-start"></i> ' + (item.status || 'PENDING') + '</span>';
            }

            // Delay / Completion Info
            var delayInfo = '—';
            if (item.status === 'OVERDUE' && item.daysOverdue > 0) {
                delayInfo = '<span class="badge badge-danger" style="font-weight:700;"><i class="fas fa-exclamation-triangle"></i> ' + item.daysOverdue + ' day' + (item.daysOverdue === 1 ? '' : 's') + ' overdue</span>';
            } else if (item.status === 'COMPLETED') {
                var compDate = item.completedAt ? item.completedAt.split('T')[0] : 'Completed';
                if (item.completedLate || (item.daysOverdue && item.daysOverdue > 0)) {
                    delayInfo = '<span class="badge badge-warning" style="background:#fef3c7; color:#b45309; border:1px solid #fcd34d;" title="Completed after due date"><i class="fas fa-clock"></i> ' + compDate + ' (' + item.daysOverdue + ' days late)</span>';
                } else {
                    delayInfo = '<span class="badge badge-success" title="Completed on-time"><i class="fas fa-check"></i> ' + compDate + ' (On-time)</span>';
                }
            }

            var compInitial = item.companyName ? item.companyName.charAt(0).toUpperCase() : 'C';
            var subCompHtml = item.subComplianceName ? '<div style="font-size: 11px; color: var(--gray-500);"><i class="fas fa-arrow-turn-down-right" style="font-size: 9px;"></i> ' + escapeHtml(item.subComplianceName) + '</div>' : '';

            html += '<tr>' +
                '<td><span style="color: var(--gray-400); font-weight: 500;">#' + rowNum + '</span></td>' +
                '<td>' +
                    '<div class="company-badge">' +
                        '<div class="company-icon-circle">' + compInitial + '</div>' +
                        '<span>' + escapeHtml(item.companyName) + '</span>' +
                    '</div>' +
                '</td>' +
                '<td>' +
                    '<div style="font-weight: 600; color: var(--gray-900);">' + escapeHtml(item.complianceName) + '</div>' +
                    subCompHtml +
                    '<span style="font-size: 11px; color: var(--gray-400);"><i class="fas fa-tag" style="font-size: 9px;"></i> ' + escapeHtml(item.categoryName) + '</span>' +
                '</td>' +
                '<td><span class="badge badge-info">' + (item.frequency || 'ONE_TIME') + '</span></td>' +
                '<td><span style="font-weight: 600; color: var(--gray-800);">' + (item.dueDate || '—') + '</span></td>' +
                '<td><span class="badge badge-gray">' + (item.monthName || '—') + ' ' + (item.dueYear || '') + '</span></td>' +
                '<td>' + statusBadge + '</td>' +
                '<td>' + delayInfo + '</td>' +
                '<td>' +
                    '<button class="btn-log" onclick="openAuditModal(' + item.id + ', \'' + escapeJs(item.complianceName) + '\', \'' + escapeJs(item.companyName) + '\')">' +
                        '<i class="fas fa-stream"></i> Audit Log' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });

        tbody.innerHTML = html;
    }

    // Open Audit Trail Modal
    async function openAuditModal(complianceId, title, company) {
        document.getElementById('modalComplianceTitle').textContent = title + ' - History';
        document.getElementById('modalCompanySubtitle').textContent = 'Company: ' + company;
        var timeline = document.getElementById('modalTimeline');
        timeline.innerHTML = '<div style="text-align: center; color: var(--gray-400); padding: 24px;"><i class="fas fa-spinner fa-spin"></i> Loading audit logs...</div>';

        document.getElementById('auditModal').classList.add('open');

        var res = await apiCall('/api/super-admin/compliance/history/' + complianceId + '/logs');
        if (res && res.success && res.data) {
            var logs = res.data;
            if (logs.length === 0) {
                timeline.innerHTML = '<div style="color: var(--gray-400); padding: 12px; font-size: 13px;">No explicit history records logged for this compliance yet.</div>';
                return;
            }

            var html = '';
            logs.forEach(function(l) {
                var dotClass = '';
                var dotIcon = 'fa-check';
                if (l.action && l.action.indexOf('OVERDUE') !== -1) {
                    dotClass = 'danger';
                    dotIcon = 'fa-exclamation';
                } else if (l.action && l.action.indexOf('COMPLETED') !== -1) {
                    dotClass = 'success';
                    dotIcon = 'fa-check-double';
                }

                var performedAtStr = l.performedAt ? l.performedAt.replace('T', ' ').substring(0, 19) : '—';
                var statusChange = '';
                if (l.previousStatus || l.newStatus) {
                    statusChange = '<span style="font-size: 11px; margin-left: 8px; font-weight: 500; color: var(--gray-500);">' +
                        (l.previousStatus || '—') + ' → <b>' + (l.newStatus || '—') + '</b></span>';
                }

                html += '<div class="timeline-item">' +
                    '<div class="timeline-dot ' + dotClass + '"><i class="fas ' + dotIcon + '"></i></div>' +
                    '<div class="timeline-content">' +
                        '<div class="timeline-header">' +
                            '<div><span class="timeline-action">' + escapeHtml(l.action || 'Status Updated') + '</span>' + statusChange + '</div>' +
                            '<span class="timeline-date"><i class="far fa-clock"></i> ' + performedAtStr + '</span>' +
                        '</div>' +
                        '<div style="font-size: 11px; color: var(--primary); font-weight: 600;"><i class="fas fa-user-circle"></i> ' + escapeHtml(l.performedByName || 'System') + '</div>' +
                        (l.remarks ? '<div class="timeline-desc">' + escapeHtml(l.remarks) + '</div>' : '') +
                    '</div>' +
                '</div>';
            });

            timeline.innerHTML = html;
        } else {
            timeline.innerHTML = '<div style="color: var(--danger); padding: 12px;">Failed to load audit history.</div>';
        }
    }

    function closeModal() {
        document.getElementById('auditModal').classList.remove('open');
    }

    function closeModalOnOverlay(e) {
        if (e.target.id === 'auditModal') closeModal();
    }

    // Filter Handlers
    function onCompanyChange() {
        var compId = document.getElementById('companySelect').value;
        var url = new URL(window.location.href);
        if (compId) {
            url.searchParams.set('companyId', compId);
        } else {
            url.searchParams.delete('companyId');
        }
        window.history.replaceState({}, '', url.toString());

        currentPage = 0;
        loadHistorySummary();
        loadHistoryRecords();
    }

    function onFilterChange() {
        currentPage = 0;
        loadHistorySummary();
        loadHistoryRecords();
    }

    function selectStatusFilter(btn, status) {
        document.querySelectorAll('.status-pills .pill-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        btn.classList.add('active');
        currentStatusFilter = status;
        currentPage = 0;
        loadHistoryRecords();
    }

    function debounceSearch() {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(function() {
            currentPage = 0;
            loadHistoryRecords();
        }, 300);
    }

    function resetFilters() {
        document.getElementById('companySelect').value = '';
        document.getElementById('monthSelect').value = '0';
        document.getElementById('searchInput').value = '';
        currentStatusFilter = '';

        var url = new URL(window.location.href);
        url.searchParams.delete('companyId');
        window.history.replaceState({}, '', url.toString());

        document.querySelectorAll('.status-pills .pill-btn').forEach(function(b, idx) {
            if (idx === 0) b.classList.add('active');
            else b.classList.remove('active');
        });
        currentPage = 0;
        loadHistorySummary();
        loadHistoryRecords();
    }

    // Pagination
    function updatePaginationInfo(pageData) {
        var totalElements = pageData.totalElements || 0;
        var start = totalElements === 0 ? 0 : (currentPage * pageSize) + 1;
        var end = Math.min((currentPage + 1) * pageSize, totalElements);

        document.getElementById('pageInfo').textContent = 'Showing ' + start + '–' + end + ' of ' + totalElements + ' records';
        document.getElementById('btnPrev').disabled = currentPage <= 0;
        document.getElementById('btnNext').disabled = currentPage >= totalPages - 1;
    }

    function changePage(direction) {
        var newPage = currentPage + direction;
        if (newPage >= 0 && newPage < totalPages) {
            currentPage = newPage;
            loadHistoryRecords();
        }
    }

    // Mobile Sidebar
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('open');
        overlay.classList.toggle('open');
    }

    function handleLogout() {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('user');
        window.location.href = contextPath + '/login?logout=true';
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>"']/g, function(m) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m];
        });
    }

    function escapeJs(str) {
        if (!str) return '';
        return String(str).replace(/'/g, "\\'").replace(/"/g, '\\"');
    }
</script>

</body>
</html>
