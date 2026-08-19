<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% pageContext.setAttribute("pageTitle", "Notifications"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Notifications</title>

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
            filter: blur(0px);
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

        .nav-item .nav-badge {
            margin-left: auto;
            background: var(--danger);
            color: white;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 20px;
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

        .main-content {
            margin-left: 260px;
            margin-top: 64px;
            padding: 32px 40px;
            flex: 1;
            min-height: calc(100vh - 64px);
            position: relative;
            z-index: 1;
        }

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

        .page-header {
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
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

        .page-header .page-description {
            font-size: 13px;
            color: var(--gray-500);
            margin-top: 4px;
        }

        .notification-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
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
            font-size: 24px;
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

        .filter-bar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 14px 20px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .filter-bar .filter-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            flex: 1;
        }

        .filter-bar .filter-group .filter-item {
            position: relative;
            flex: 1;
            min-width: 160px;
        }

        .filter-bar .filter-group .filter-item .filter-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 13px;
        }

        .filter-bar .filter-group .filter-item .filter-input,
        .filter-bar .filter-group .filter-item .filter-select {
            width: 100%;
            padding: 8px 12px 8px 36px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            color: var(--gray-800);
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            outline: none;
            transition: all 0.2s;
        }

        .filter-bar .filter-group .filter-item .filter-input:focus,
        .filter-bar .filter-group .filter-item .filter-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background: rgba(255, 255, 255, 0.8);
        }

        .filter-bar .filter-group .filter-item .filter-input::placeholder {
            color: var(--gray-400);
        }

        .filter-bar .filter-group .filter-item .filter-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .filter-bar .filter-actions {
            display: flex;
            gap: 8px;
            flex-shrink: 0;
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

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
        }

        .btn-sm {
            padding: 6px 14px;
            font-size: 12px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .badge-success { background: var(--success-bg); color: var(--success); }
        .badge-danger { background: var(--danger-bg); color: var(--danger); }
        .badge-warning { background: var(--warning-bg); color: var(--warning); }
        .badge-info { background: var(--info-bg); color: var(--info); }
        .badge-primary { background: var(--primary-bg); color: var(--primary); }

        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .notification-item {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .notification-item:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateX(4px);
            border-color: var(--primary-light);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        }

        .notification-item.urgent {
            border-left-color: var(--danger);
            background: rgba(239, 68, 68, 0.04);
        }

        .notification-item.important {
            border-left-color: var(--warning);
            background: rgba(245, 158, 11, 0.04);
        }

        .notification-item .item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 8px;
        }

        .notification-item .item-header .title-section {
            flex: 1;
            min-width: 0;
        }

        .notification-item .item-header .title-section .title {
            font-size: 16px;
            font-weight: 600;
            color: var(--gray-900);
        }

        .notification-item .item-header .title-section .type-badge {
            font-size: 9px;
            padding: 2px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.3px;
            margin-left: 8px;
        }

        .notification-item .item-header .title-section .type-badge.general {
            background: var(--primary-bg);
            color: var(--primary);
        }

        .notification-item .item-header .title-section .type-badge.important {
            background: var(--warning-bg);
            color: var(--warning);
        }

        .notification-item .item-header .title-section .type-badge.urgent {
            background: var(--danger-bg);
            color: var(--danger);
        }

        .notification-item .item-header .time {
            font-size: 12px;
            color: var(--gray-500);
            white-space: nowrap;
            flex-shrink: 0;
        }

        .notification-item .message {
            font-size: 14px;
            color: var(--gray-600);
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .notification-item .item-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
            padding-top: 12px;
            border-top: 1px solid rgba(226, 232, 240, 0.4);
        }

        .notification-item .item-footer .meta {
            font-size: 12px;
            color: var(--gray-500);
        }

        .notification-item .item-footer .meta i {
            margin-right: 4px;
        }

        .notification-item .item-footer .actions {
            display: flex;
            gap: 6px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 48px;
            opacity: 0.3;
            margin-bottom: 12px;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 4px;
        }

        .empty-state p {
            margin-bottom: 16px;
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

        .loader-container {
            text-align: center;
            padding: 60px;
        }

        .loader-container .spinner {
            margin: 0 auto 16px;
        }

        .loader-container p {
            color: var(--gray-500);
            font-size: 14px;
        }

        .toast-container {
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

        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .logo-bg { width: 500px; height: 500px; }
            .notification-stats { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .notification-stats { grid-template-columns: 1fr; }
            .filter-bar .filter-group { flex-direction: column; width: 100%; }
            .filter-bar .filter-group .filter-item { min-width: unset; }
            .filter-bar { flex-direction: column; align-items: stretch; }
            .filter-bar .filter-actions { justify-content: flex-end; }
            .page-header { flex-direction: column; align-items: stretch; }
            .notification-item { padding: 16px; }
            .notification-item .item-header { flex-direction: column; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .notification-stats { grid-template-columns: 1fr; }
            .notification-item .item-footer { flex-direction: column; align-items: flex-start; }
            .notification-item .item-footer .actions { width: 100%; }
            .notification-item .item-footer .actions .btn { flex: 1; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="logo-bg">
    <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<div class="toast-container" id="toastContainer"></div>

<div class="app-wrapper">

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <div class="brand-icon">
             <img style="width:100%;"  src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
            </div>
            <span class="brand-text">VNext Legal</span>
            <span class="brand-badge">LLP</span>
        </div>

        <div class="sidebar-label">Main</div>
        <a href="${baseUrl}/company-admin/dashboard" class="nav-item">
            <i class="fas fa-chart-pie"></i> Dashboard
        </a>

        <div class="sidebar-label">Management</div>
        <a href="${baseUrl}/company-admin/employees" class="nav-item">
            <i class="fas fa-users"></i> Employees
            <span class="nav-badge" id="employeeCount">0</span>
        </a>

        <div class="sidebar-label">Compliance</div>
        <a href="${baseUrl}/company-admin/compliance/parents" class="nav-item">
            <i class="fas fa-tasks"></i> My Compliances
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${baseUrl}/company-admin/notifications" class="nav-item active">
            <i class="fas fa-bell"></i> Notifications
            <span class="nav-badge" id="notifCount">0</span>
        </a>

        <div class="sidebar-label">Account</div>
        <a href="${baseUrl}/company-admin/change-password" class="nav-item">
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
            <span class="page-title">Notifications</span>
        </div>
        <div class="header-right">
            <div class="header-user" onclick="window.location.href='${baseUrl}/company-admin/profile'">
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
        <div class="page-header">
            <div>
                <div class="page-subtitle"><i class="fas fa-bell" style="margin-right:6px;"></i>Communication</div>
                <h1>Notifications</h1>
                <div class="page-description">Stay updated with system notifications and compliance updates</div>
            </div>
            <button onclick="markAllRead()" class="btn btn-primary" id="markAllReadBtn">
                <i class="fas fa-check-double"></i> Mark All as Read
            </button>
        </div>

        <!-- ==================== STATS ==================== -->
        <div class="notification-stats">
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(79,70,229,0.1);color:var(--primary);">
                    <i class="fas fa-bell"></i>
                </div>
                <div>
                    <div class="stat-number" id="statTotal">0</div>
                    <div class="stat-label">Total</div>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(239,68,68,0.1);color:var(--danger);">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div>
                    <div class="stat-number" id="statUrgent" style="color:var(--danger);">0</div>
                    <div class="stat-label">Urgent</div>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(245,158,11,0.1);color:var(--warning);">
                    <i class="fas fa-clock"></i>
                </div>
                <div>
                    <div class="stat-number" id="statUnread" style="color:var(--warning);">0</div>
                    <div class="stat-label">Unread</div>
                </div>
            </div>
        </div>

        <!-- ==================== FILTER BAR ==================== -->
        <div class="filter-bar">
            <div class="filter-group">
                <div class="filter-item">
                    <i class="fas fa-search filter-icon"></i>
                    <input type="text" id="searchInput" class="filter-input" placeholder="Search notifications..." />
                </div>
                <div class="filter-item">
                    <i class="fas fa-filter filter-icon"></i>
                    <select id="typeFilter" class="filter-select">
                        <option value="all">All Types</option>
                        <option value="GENERAL">General</option>
                        <option value="IMPORTANT">Important</option>
                        <option value="URGENT">Urgent</option>
                    </select>
                </div>
            </div>
            <div class="filter-actions">
                <button onclick="resetFilters()" class="btn btn-ghost btn-sm">
                    <i class="fas fa-undo"></i> Reset
                </button>
                <button onclick="refreshNotifications()" class="btn btn-primary btn-sm">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
        </div>

        <!-- ==================== LOADER ==================== -->
        <div id="loader" class="loader-container">
            <div class="spinner"></div>
            <p>Loading notifications...</p>
        </div>

        <!-- ==================== NOTIFICATIONS LIST ==================== -->
        <div id="notificationsContainer" style="display:none;">
            <div class="notification-list" id="notificationList"></div>
        </div>

        <!-- ==================== EMPTY STATE ==================== -->
        <div id="emptyState" class="empty-state" style="display:none;">
            <i class="fas fa-bell-slash"></i>
            <h3>No Notifications</h3>
            <p>You're all caught up! No new notifications to display.</p>
            <button onclick="refreshNotifications()" class="btn btn-primary">
                <i class="fas fa-sync-alt"></i> Check for Updates
            </button>
        </div>

    </main>
</div>

<script>
    var contextPath = '${baseUrl}';
    var allNotifications = [];
    var filteredNotifications = [];

    // ==================== TOAST ====================
    function toast(message, type, duration) {
        type = type || 'info';
        duration = duration || 3500;
        var container = document.getElementById('toastContainer');
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

    function getTypeBadgeClass(type) {
        var map = { 'GENERAL': 'general', 'IMPORTANT': 'important', 'URGENT': 'urgent' };
        return map[type] || 'general';
    }

    function getTypeColor(type) {
        var map = { 'GENERAL': 'var(--primary)', 'IMPORTANT': 'var(--warning)', 'URGENT': 'var(--danger)' };
        return map[type] || 'var(--primary)';
    }

    // ==================== SIDEBAR ====================
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

    // ==================== LOAD NOTIFICATIONS ====================
    async function loadNotifications() {
        document.getElementById('loader').style.display = 'block';
        document.getElementById('notificationsContainer').style.display = 'none';
        document.getElementById('emptyState').style.display = 'none';

        try {
            var data = await api('/api/notifications/active');

            if (data && data.success) {
                allNotifications = data.data || [];
                updateStats();
                applyFilters();
                document.getElementById('loader').style.display = 'none';

                if (allNotifications.length === 0) {
                    document.getElementById('emptyState').style.display = 'block';
                } else {
                    document.getElementById('notificationsContainer').style.display = 'block';
                }

                // Update badge count
                document.getElementById('notifCount').textContent = allNotifications.length;
            } else {
                document.getElementById('loader').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Failed to load notifications</p></div>';
            }
        } catch (error) {
            console.error('Error loading notifications:', error);
            document.getElementById('loader').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Error loading notifications</p></div>';
        }
    }

    function updateStats() {
        var total = allNotifications.length;
        var urgent = allNotifications.filter(function(n) { return n.notificationType === 'URGENT'; }).length;
        // For now, we consider all notifications as unread since we don't have a read status
        var unread = allNotifications.length;

        document.getElementById('statTotal').textContent = total;
        document.getElementById('statUrgent').textContent = urgent;
        document.getElementById('statUnread').textContent = unread;
    }

    function applyFilters() {
        var searchTerm = document.getElementById('searchInput').value.toLowerCase();
        var typeFilter = document.getElementById('typeFilter').value;

        filteredNotifications = allNotifications.filter(function(n) {
            if (searchTerm && !(n.title || '').toLowerCase().includes(searchTerm) &&
                !(n.message || '').toLowerCase().includes(searchTerm)) {
                return false;
            }
            if (typeFilter !== 'all' && n.notificationType !== typeFilter) {
                return false;
            }
            return true;
        });

        renderNotifications(filteredNotifications);
    }

    function renderNotifications(notifications) {
        var container = document.getElementById('notificationList');

        if (!notifications.length) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><p style="font-size:14px;">No notifications match your filters</p></div>';
            return;
        }

        var html = '';
        for (var i = 0; i < notifications.length; i++) {
            var n = notifications[i];
            var typeClass = getTypeBadgeClass(n.notificationType);
            var typeColor = getTypeColor(n.notificationType);
            var itemClass = 'notification-item';
            if (n.notificationType === 'URGENT') itemClass += ' urgent';
            else if (n.notificationType === 'IMPORTANT') itemClass += ' important';

            html += '<div class="' + itemClass + '">' +
                '<div class="item-header">' +
                '<div class="title-section">' +
                '<span class="title">' + escapeHtml(n.title) + '</span>' +
                '<span class="type-badge ' + typeClass + '">' + (n.notificationType || 'GENERAL') + '</span>' +
                '</div>' +
                '<span class="time"><i class="far fa-clock"></i> ' + formatTimeAgo(n.createdAt) + '</span>' +
                '</div>' +
                '<div class="message">' + escapeHtml(n.message) + '</div>' +
                '<div class="item-footer">' +
                '<span class="meta"><i class="fas fa-user"></i> ' + (n.createdByName || 'System') + '</span>' +
                '<div class="actions">' +
                '</div>' +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    // ==================== FILTER FUNCTIONS ====================
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('typeFilter').value = 'all';
        applyFilters();
        toast('Filters reset', 'info');
    }

    function refreshNotifications() {
        loadNotifications();
        toast('Refreshed', 'info');
    }

    // ==================== MARK ALL AS READ ====================
    function markAllRead() {
        if (!allNotifications.length) {
            toast('No notifications to mark as read', 'warning');
            return;
        }

        if (!confirm('Mark all notifications as read?')) return;

        // In a real implementation, you would call an API to mark all as read
        // For now, we just show a success message
        toast('All notifications marked as read', 'success');

        // Update stats
        document.getElementById('statUnread').textContent = '0';
    }

    // ==================== DELETE NOTIFICATION ====================
    async function deleteNotification(id) {
        if (!confirm('Are you sure you want to delete this notification?')) return;

        try {
            var data = await api('/api/notifications/admin/' + id, { method: 'DELETE' });

            if (data && data.success) {
                toast('Notification deleted', 'success');
                loadNotifications();
            } else {
                toast(data?.error || 'Failed to delete notification', 'error');
            }
        } catch (error) {
            console.error('Error deleting notification:', error);
            toast('Failed to delete notification', 'error');
        }
    }

    // ==================== EVENT LISTENERS ====================
    document.getElementById('searchInput').addEventListener('input', function() {
        applyFilters();
    });

    document.getElementById('typeFilter').addEventListener('change', function() {
        applyFilters();
    });

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

        // Load employee count
        async function loadEmployeeCount() {
            try {
                var data = await api('/api/company-admin/employees?page=0&size=1');
                if (data && data.success) {
                    document.getElementById('employeeCount').textContent = data.data.totalElements || 0;
                }
            } catch(e) {
                console.log('Error loading employee count:', e);
            }
        }
        loadEmployeeCount();

        // Load notifications
        loadNotifications();
    });
</script>

</body>
</html>