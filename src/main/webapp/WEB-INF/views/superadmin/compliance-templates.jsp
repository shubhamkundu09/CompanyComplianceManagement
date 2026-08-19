<%-- File: superadmin/compliance-templates.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "Compliance Categories"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Compliance Categories</title>

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
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 16px;
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
            font-size: 14px;
            color: var(--gray-500);
            margin-top: 4px;
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
            padding: 6px 14px;
            font-size: 12px;
        }

        .btn-lg {
            padding: 12px 24px;
            font-size: 14px;
        }

        .btn-icon {
            padding: 8px 10px;
            min-width: 36px;
            justify-content: center;
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

        /* ==================== BADGES ==================== */
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

        .badge-active { background: var(--success-bg); color: var(--success); }
        .badge-inactive { background: var(--danger-bg); color: var(--danger); }
        .badge-pending { background: var(--warning-bg); color: var(--warning); }

        .badge-configured {
            background: rgba(79, 70, 229, 0.12);
            color: var(--primary-light);
        }
        .badge-pending-config {
            background: rgba(245, 158, 11, 0.15);
            color: var(--warning);
        }
        .badge-has-subs {
            background: rgba(16, 185, 129, 0.15);
            color: var(--success);
        }
        .badge-no-subs {
            background: rgba(239, 68, 68, 0.12);
            color: var(--danger);
        }

        /* ==================== INFO BANNER ==================== */
        .info-banner {
            background: rgba(79, 70, 229, 0.06);
            border: 1px solid rgba(79, 70, 229, 0.12);
            border-radius: var(--radius);
            padding: 14px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .info-banner .banner-icon {
            width: 36px;
            height: 36px;
            background: rgba(79, 70, 229, 0.12);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .info-banner .banner-icon i {
            color: var(--primary);
            font-size: 16px;
        }

        .info-banner .banner-content {
            font-size: 13px;
            color: var(--gray-500);
            line-height: 1.5;
        }

        .info-banner .banner-content strong {
            color: var(--gray-800);
        }

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
            margin-top: 2px;
        }

        /* ==================== FILTER BAR ==================== */
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

        /* ==================== TEMPLATES GRID ==================== */
        .templates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .template-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .template-card:hover {
            background: rgba(255, 255, 255, 0.9);
            border-color: var(--primary-light);
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        }

        .template-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gray-200);
            transition: background 0.3s;
        }

        .template-card.active::before {
            background: var(--success);
        }

        .template-card.inactive::before {
            background: var(--danger);
        }

        .template-card.configured::before {
            background: var(--primary);
        }

        .template-card .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
        }

        .template-card .card-header .card-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .template-card .card-header .card-title .icon {
            width: 46px;
            height: 46px;
            min-width: 46px;
            border-radius: 50%;
            background: rgb(0 0 0);
            border: 1.5px solid rgba(79, 70, 229, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .template-card .card-header .card-title .icon i {
            color: #e9d80f;
            font-size: 18px;
        }

        .template-card .card-header .card-title h3 {
            font-size: 16px;
            font-weight: 600;
            color: var(--gray-900);
            margin: 0;
        }

        .template-card .card-header .card-badges {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .template-card .card-body {
            margin-bottom: 14px;
        }

        .template-card .card-body .description {
            font-size: 13px;
            color: var(--gray-500);
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .template-card .card-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            padding: 12px 0;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            margin-bottom: 14px;
        }

        .template-card .card-stats .stat-item {
            text-align: center;
        }

        .template-card .card-stats .stat-item .number {
            font-size: 18px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .template-card .card-stats .stat-item .number.active-color { color: var(--success); }
        .template-card .card-stats .stat-item .number.pending-color { color: var(--warning); }
        .template-card .card-stats .stat-item .number.configured-color { color: var(--primary); }

        .template-card .card-stats .stat-item .label {
            font-size: 9px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-top: 2px;
        }

        .template-card .card-footer {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .template-card .card-footer .btn {
            flex: 1;
            justify-content: center;
            font-size: 12px;
            padding: 8px 12px;
            min-width: 60px;
        }

        .template-card .card-footer .btn-icon {
            flex: 0 0 auto;
            padding: 8px 12px;
        }

        /* ==================== LOADER ==================== */
        .loader-container {
            text-align: center;
            padding: 60px;
            display: none;
        }

        .loader-container .spinner {
            margin: 0 auto 16px;
        }

        .loader-container p {
            color: var(--gray-500);
            font-size: 14px;
        }

        /* ==================== EMPTY STATE ==================== */
        .empty-state-container {
            text-align: center;
            padding: 60px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
        }

        .empty-state-container i {
            font-size: 48px;
            color: var(--gray-400);
            opacity: 0.3;
            margin-bottom: 16px;
        }

        .empty-state-container h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 8px;
        }

        .empty-state-container p {
            color: var(--gray-500);
            margin-bottom: 20px;
        }

        /* ==================== PAGINATION ==================== */
        .pagination-container {
            display: flex;
            justify-content: center;
            gap: 6px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .pagination-container .page-btn {
            padding: 8px 14px;
            border-radius: var(--radius);
            border: 1px solid rgba(226, 232, 240, 0.6);
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            color: var(--gray-600);
            cursor: pointer;
            transition: all 0.2s;
            font-size: 13px;
            font-family: 'Inter', sans-serif;
        }

        .pagination-container .page-btn:hover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.06);
            color: var(--primary);
        }

        .pagination-container .page-btn.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        .pagination-container .page-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
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
            max-width: 550px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        .modal-box.wide {
            max-width: 700px;
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

        .delete-warning {
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

        .delete-danger {
            font-size: 12px;
            color: var(--warning);
            margin-top: 12px;
        }

        .delete-danger i {
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
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .templates-grid {
                grid-template-columns: 1fr;
            }

            .filter-bar .filter-group {
                flex-direction: column;
                width: 100%;
            }

            .filter-bar .filter-group .filter-item {
                min-width: unset;
            }

            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-bar .filter-actions {
                justify-content: flex-end;
            }

            .page-header {
                flex-direction: column;
                align-items: stretch;
            }

            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
            .template-card .card-footer { flex-direction: column; }
            .template-card .card-footer .btn { flex: none; width: 100%; }
            .template-card .card-stats { grid-template-columns: repeat(3, 1fr); }
            .notification-dropdown { width: 280px; right: -80px; }
        }


        .badge-editable {
                    background: #e0e7ff;
                    color: #4f46e5;
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
            <span class="page-title">Compliance Categories</span>
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

        <!-- ==================== PAGE HEADER ==================== -->
        <div class="page-header">
            <div>
                <div class="page-subtitle"><i class="fas fa-tags" style="margin-right:6px;"></i>Compliance Management</div>
                <h1>Compliance Categories</h1>
                <div class="page-description">Create and manage compliance categories. Configure them to auto-assign to all active companies.</div>
            </div>
            <button onclick="openAddModal()" class="btn btn-primary btn-lg">
                <i class="fas fa-plus"></i> Create Category
            </button>
        </div>

        <!-- ==================== INFO BANNER ==================== -->
        <div class="info-banner">
            <div class="banner-icon">
                <i class="fas fa-info-circle"></i>
            </div>
            <div class="banner-content">
                <strong>How it works:</strong> Create compliance categories → Add sub-compliances (optional) →
                <strong>Configure</strong> (sub-compliances if exist, otherwise parent) →
                <strong>Auto-assigned</strong> to all active companies
            </div>
        </div>

        <!-- ==================== STATS ==================== -->
        <div class="stats-grid">
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(79,70,229,0.1);color:var(--primary);">
                    <i class="fas fa-tags"></i>
                </div>
                <div>
                    <div class="stat-number" id="statTotal">0</div>
                    <div class="stat-label">Total Categories</div>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(16,185,129,0.1);color:var(--success);">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div>
                    <div class="stat-number" id="statActive" style="color:var(--success);">0</div>
                    <div class="stat-label">Active</div>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(79,70,229,0.1);color:var(--primary);">
                    <i class="fas fa-check-double"></i>
                </div>
                <div>
                    <div class="stat-number" id="statConfigured" style="color:var(--primary);">0</div>
                    <div class="stat-label">Configured</div>
                </div>
            </div>
            <div class="stat-card-mini">
                <div class="stat-icon" style="background:rgba(245,158,11,0.1);color:var(--warning);">
                    <i class="fas fa-clock"></i>
                </div>
                <div>
                    <div class="stat-number" id="statPending" style="color:var(--warning);">0</div>
                    <div class="stat-label">Pending Config</div>
                </div>
            </div>
        </div>

        <!-- ==================== FILTER BAR ==================== -->
        <div class="filter-bar">
            <div class="filter-group">
                <div class="filter-item">
                    <i class="fas fa-search filter-icon"></i>
                    <input type="text" id="searchInput" class="filter-input" placeholder="Search categories...">
                </div>
                <div class="filter-item">
                    <i class="fas fa-filter filter-icon"></i>
                    <select id="statusFilter" class="filter-select">
                        <option value="all">All Status</option>
                        <option value="true">Active Only</option>
                        <option value="false">Inactive Only</option>
                    </select>
                </div>
                <div class="filter-item">
                    <i class="fas fa-cog filter-icon"></i>
                    <select id="configFilter" class="filter-select">
                        <option value="all">All Configurations</option>
                        <option value="configured">Configured Only</option>
                        <option value="pending">Pending Only</option>
                    </select>
                </div>
            </div>
            <div class="filter-actions">
                <button onclick="resetFilters()" class="btn btn-ghost btn-sm">
                    <i class="fas fa-undo"></i> Reset
                </button>
                <button onclick="refreshList()" class="btn btn-primary btn-sm">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
        </div>

        <!-- ==================== TEMPLATES GRID ==================== -->
        <div id="loader" class="loader-container" style="display:none;">
            <div class="spinner"></div>
            <p>Loading compliance categories...</p>
        </div>

        <div id="templatesGrid" class="templates-grid" style="display:none;"></div>

        <div id="emptyState" class="empty-state-container" style="display:none;">
            <i class="fas fa-folder-open"></i>
            <h3>No Compliance Categories Found</h3>
            <p>Create your first compliance category to get started.</p>
            <button onclick="openAddModal()" class="btn btn-primary">
                <i class="fas fa-plus"></i> Create Category
            </button>
        </div>

        <!-- ==================== PAGINATION ==================== -->
        <div id="pagination" class="pagination-container" style="display:none;"></div>

    </main>
</div>

<!-- ==================== ADD/EDIT MODAL ==================== -->
<div id="templateModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="modalTitle"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Create Category</div>
                <div class="modal-subtitle" id="modalSubtitle">Add a new compliance category</div>
            </div>
            <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="templateForm" onsubmit="return false;">
                <input type="hidden" id="templateId">
                <div style="margin-bottom:20px;">
                    <label class="form-label">Category Name <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="name" class="form-input" placeholder="e.g., Labour, Tax, GST, Billing" required>
                </div>
                <div style="margin-bottom:20px;">
                    <label class="form-label">Description</label>
                    <textarea id="description" class="form-input" rows="3" placeholder="Describe what this compliance category covers..."></textarea>
                </div>
                <!-- ===== NEW: Priority Field ===== -->
                <div style="margin-bottom:16px;">
                    <label class="form-label">
                        <i class="fas fa-sort-numeric-down" style="margin-right:6px;"></i>
                        Priority
                        <span style="font-size:11px;color:var(--gray-500);font-weight:400;margin-left:6px;">
                            (Lower number = Higher priority, appears first)
                        </span>
                    </label>
                    <input type="number" id="priority" class="form-input" value="0" min="0" step="1">
                </div>
                <!-- ===== Compliance Type Selection ===== -->
                <div style="margin-bottom:16px;">
                    <label class="form-label">
                        <i class="fas fa-layer-group" style="margin-right:6px;"></i>
                        Compliance Type <span style="color:var(--danger);">*</span>
                        <span id="typeLockNote" style="font-size:11px;color:var(--danger);font-weight:600;margin-left:8px;display:none;">(Locked - Type cannot be changed after creation)</span>
                    </label>
                    <div style="display:flex;flex-direction:column;gap:10px;background:var(--gray-50);padding:14px;border-radius:var(--radius);border:1px solid var(--gray-200);">
                        <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;">
                            <input type="radio" name="complianceTypeRadio" id="typeNonEditable" value="false" checked style="margin-top:3px;accent-color:var(--primary);">
                            <div>
                                <strong style="font-size:13px;color:var(--gray-900);"><i class="fas fa-lock" style="color:var(--primary);margin-right:4px;"></i> Non-Editable Compliance (Admin Managed)</strong>
                                <p style="font-size:12px;color:var(--gray-500);margin-top:2px;">SuperAdmin creates, configures, and manages all sub-compliances centrally for all companies.</p>
                            </div>
                        </label>
                        <hr style="border:0;border-top:1px solid var(--gray-200);margin:2px 0;">
                        <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;">
                            <input type="radio" name="complianceTypeRadio" id="typeEditable" value="true" style="margin-top:3px;accent-color:var(--warning);">
                            <div>
                                <strong style="font-size:13px;color:var(--gray-900);"><i class="fas fa-edit" style="color:var(--warning);margin-right:4px;"></i> Editable Compliance (Company Managed)</strong>
                                <p style="font-size:12px;color:var(--gray-500);margin-top:2px;">SuperAdmin creates the category, but companies add, configure, and manage their own sub-compliances.</p>
                            </div>
                        </label>
                    </div>
                </div>
                <div class="modal-info-box" id="modalInfoBox">
                    <i class="fas fa-info-circle"></i> Non-Editable Compliance allows SuperAdmin to create, configure, and manage all sub-compliances centrally.
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveTemplate()" class="btn btn-primary" id="saveBtn">
                <i class="fas fa-save"></i> Save Category
            </button>
        </div>
    </div>
</div>

<!-- ==================== DELETE MODAL ==================== -->
<div id="deleteModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" style="color:var(--danger);"><i class="fas fa-exclamation-triangle" style="margin-right:8px;"></i>Delete Category</div>
                <div class="modal-subtitle">This action cannot be undone</div>
            </div>
            <button class="modal-close" onclick="closeDeleteModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to permanently delete <strong id="deleteCategoryName"></strong>?</p>
            <div id="deleteWarning" class="delete-warning" style="display:none;">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="deleteWarningText"></span>
            </div>
            <div class="delete-danger"><i class="fas fa-skull-crosswalk"></i> This action CANNOT be undone!</div>
        </div>
        <div class="modal-footer">
            <button onclick="closeDeleteModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmDelete()" class="btn btn-danger" id="deleteBtn">
                <i class="fas fa-trash-alt"></i> Permanently Delete
            </button>
        </div>
    </div>
</div>

<!-- ==================== HISTORY MODAL (reuses subComplianceModal) ==================== -->
<div id="subComplianceModal" class="modal-overlay">
    <div class="modal-box wide">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="subModalTitle">Compliance History</div>
                <div class="modal-subtitle" id="subModalSubtitle">View all activity and configuration history</div>
            </div>
            <button class="modal-close" onclick="closeSubModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="subModalBody">
            <div style="text-align:center;padding:40px;">
                <div class="spinner"></div>
                Loading...
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeSubModal()" class="btn btn-ghost">Close</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var currentPage = 0;
    var pageSize = 10;
    var editingId = null;
    var pendingDeleteId = null;
    var allTemplates = [];

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

    // ==================== LOAD TEMPLATES ====================
    async function loadTemplates() {
        var loader = document.getElementById('loader');
        var grid = document.getElementById('templatesGrid');
        var empty = document.getElementById('emptyState');
        var pagination = document.getElementById('pagination');

        loader.style.display = 'block';
        grid.style.display = 'none';
        empty.style.display = 'none';
        pagination.style.display = 'none';

        var search = document.getElementById('searchInput').value.trim();
        var statusFilter = document.getElementById('statusFilter').value;
        var configFilter = document.getElementById('configFilter').value;

        var url = '/api/super-admin/compliance/templates?page=' + currentPage + '&size=' + pageSize;
        var data = await api(url);

        if (data && data.success) {
            var pageData = data.data;
            var templates = pageData.content || [];

            // Apply filters
            var filtered = templates.filter(function(t) {
                if (statusFilter !== 'all') {
                    var isActive = t.isActive === true;
                    var wantActive = statusFilter === 'true';
                    if (isActive !== wantActive) return false;
                }
                if (configFilter === 'configured' && !t.configured) return false;
                if (configFilter === 'pending' && t.configured) return false;
                if (search && !t.name.toLowerCase().includes(search.toLowerCase())) return false;
                return true;
            });

            updateStats(filtered);

            if (filtered.length === 0) {
                loader.style.display = 'none';
                empty.style.display = 'block';
                grid.style.display = 'none';
                pagination.style.display = 'none';
                return;
            }

            renderTemplates(filtered);
            renderPagination(pageData.totalPages, pageData.number, pageData.totalElements);

            loader.style.display = 'none';
            grid.style.display = 'grid';
            pagination.style.display = 'flex';
        } else {
            loader.innerHTML = '<div class="empty-state-container">Failed to load categories</div>';
        }
    }

    async function enrichTemplateData(template) {
        try {
            var subData = await api(
                "/api/super-admin/compliance/sub-templates?parentId=" + template.id,
            );
            if (subData && subData.success) {
                template.subCompliances = subData.data || [];
                template.hasSubCompliances = template.subCompliances.length > 0;
                template.subCount = template.subCompliances.length;

                var anyConfigured = false;
                var allConfigured = template.subCompliances.length > 0;

                for (var i = 0; i < template.subCompliances.length; i++) {
                    var sub = template.subCompliances[i];
                    try {
                        var configData = await api(
                            "/api/super-admin/compliance/sub-templates/" +
                                sub.id +
                                "/config",
                        );
                        if (configData && configData.success && configData.data) {
                            sub.isConfigured = true;
                            anyConfigured = true;
                        } else {
                            sub.isConfigured = false;
                            allConfigured = false;
                        }
                    } catch (e) {
                        sub.isConfigured = false;
                        allConfigured = false;
                    }
                }

                if (template.hasSubCompliances) {
                    template.isConfigured = anyConfigured;
                    template.allConfigured = allConfigured;
                } else {
                    // Check parent config when NO sub-compliances exist
                    try {
                        var configData = await api(
                            "/api/super-admin/compliance/config?templateId=" +
                                template.id,
                        );
                        if (configData && configData.success && configData.data) {
                            template.isConfigured = true;
                            template.allConfigured = true;
                            console.log("Template " + template.id + " has parent config:", configData.data);
                        } else {
                            template.isConfigured = false;
                            template.allConfigured = false;
                            console.log("Template " + template.id + " has NO parent config");
                        }
                    } catch (e) {
                        console.error("Error checking parent config for template " + template.id + ":", e);
                        template.isConfigured = false;
                        template.allConfigured = false;
                    }
                }
            } else {
                // When sub-templates API fails, still check parent config
                template.subCompliances = [];
                template.hasSubCompliances = false;
                template.subCount = 0;

                try {
                    var configData = await api(
                        "/api/super-admin/compliance/config?templateId=" +
                            template.id,
                    );
                    if (configData && configData.success && configData.data) {
                        template.isConfigured = true;
                        template.allConfigured = true;
                    } else {
                        template.isConfigured = false;
                        template.allConfigured = false;
                    }
                } catch (e) {
                    template.isConfigured = false;
                    template.allConfigured = false;
                }
            }
        } catch (e) {
            template.subCompliances = [];
            template.hasSubCompliances = false;
            template.subCount = 0;
            template.isConfigured = false;
            template.allConfigured = false;
        }

        // ================================================================
        // FIX: Get assigned companies count - count distinct companies
        // ================================================================
        try {
            // Get all assignments for this template
            var assignData = await api(
                "/api/super-admin/compliance/assignments?page=0&size=1000&templateId=" +
                    template.id,
            );
            if (assignData && assignData.success) {
                var assignments = assignData.data.content || [];

                // Count distinct companies (by companyId)
                var uniqueCompanies = new Set();
                for (var i = 0; i < assignments.length; i++) {
                    if (assignments[i].companyId) {
                        uniqueCompanies.add(assignments[i].companyId);
                    }
                }
                template.assignedCompaniesCount = uniqueCompanies.size;
                console.log("Template " + template.id + " assigned to " + uniqueCompanies.size + " companies");
            } else {
                template.assignedCompaniesCount = 0;
            }
        } catch (e) {
            console.error("Error getting assigned companies for template " + template.id + ":", e);
            template.assignedCompaniesCount = 0;
        }
    }

    function applyFilters(templates, statusFilter, configFilter, search) {
        return templates.filter(function(t) {
            if (statusFilter !== 'all') {
                var isActive = t.isActive === true;
                var wantActive = statusFilter === 'true';
                if (isActive !== wantActive) return false;
            }
            if (configFilter === 'configured' && !t.configured) return false;
            if (configFilter === 'pending' && t.configured) return false;
            if (search && !t.name.toLowerCase().includes(search.toLowerCase())) return false;
            return true;
        });
    }

    function updateStats(templates) {
        var total = templates.length;
        var active = templates.filter(function(t) { return t.isActive; }).length;
        var configured = templates.filter(function(t) { return t.configured; }).length;
        var pending = total - configured;

        document.getElementById('statTotal').textContent = total;
        document.getElementById('statActive').textContent = active;
        document.getElementById('statConfigured').textContent = configured;
        document.getElementById('statPending').textContent = pending;
    }

    // ==================== RENDER TEMPLATES ====================

    function renderTemplates(templates) {
        var grid = document.getElementById('templatesGrid');
        if (!templates || templates.length === 0) {
            grid.innerHTML = '<div class="empty-state-container">No categories found</div>';
            return;
        }

        var html = '';
        for (var i = 0; i < templates.length; i++) {
            html += buildTemplateCard(templates[i]);
        }
        grid.innerHTML = html;
    }


      function buildTemplateCard(t) {
          var isActive = t.isActive === true;
          var isConfigured = t.configured === true;
          var subCount = t.subTemplateCount || 0;
          var assignedCount = t.assignedCompaniesCount || 0;

          var cardClass = "template-card";
          if (isActive) cardClass += " active";
          else cardClass += " inactive";
          if (isConfigured) cardClass += " configured";

          var statusBadge = isActive
              ? '<span class="badge badge-active"><i class="fas fa-circle" style="font-size:5px;margin-right:3px;"></i> Active</span>'
              : '<span class="badge badge-inactive"><i class="fas fa-circle" style="font-size:5px;margin-right:3px;"></i> Inactive</span>';

          var configBadge = isConfigured
              ? '<span class="badge badge-configured"><i class="fas fa-check"></i> Configured</span>'
              : '<span class="badge badge-pending-config"><i class="fas fa-clock"></i> Pending</span>';

          var subBadge = subCount > 0
              ? '<span class="badge badge-has-subs"><i class="fas fa-sitemap"></i> ' + subCount + ' sub(s)</span>'
              : '<span class="badge badge-no-subs"><i class="fas fa-minus"></i> No subs</span>';

          var assignedBadge = assignedCount > 0
              ? '<span class="badge badge-info"><i class="fas fa-building"></i> ' + assignedCount + ' company(ies)</span>'
              : '<span class="badge badge-info" style="opacity:0.5;"><i class="fas fa-building"></i> 0 companies</span>';

          var priorityBadge = '<span class="badge badge-info" style="background:rgba(79,70,229,0.1);color:var(--primary);border:1px solid rgba(79,70,229,0.2);"><i class="fas fa-sort-numeric-down"></i> Priority: ' + (t.priority || 0) + '</span>';

          var viewUrl = contextPath + '/super-admin/compliance/templates/' + t.id;

          // Get the icon based on the template name
          var iconClass = getComplianceIcon(t.name);

          var isEditable = t.editableForCompanies === true;
          var typeBadge = isEditable
              ? '<span class="badge badge-warning" style="background:rgba(245,158,11,0.12);color:#d97706;border:1px solid rgba(245,158,11,0.3);"><i class="fas fa-edit"></i> Editable Category</span>'
              : '<span class="badge badge-primary" style="background:rgba(79,70,229,0.12);color:var(--primary);border:1px solid rgba(79,70,229,0.3);"><i class="fas fa-lock"></i> Non-Editable Category</span>';

          return (
              '<div class="' + cardClass + '">' +
              '<div class="card-header">' +
              '<div class="card-title">' +
              '<div class="icon"><i class="fas ' + iconClass + '"></i></div>' +
              '<h3>' + escapeHtml(t.name) + '</h3>' +
              '</div>' +
              '<div class="card-badges">' +
              typeBadge +
              statusBadge +
              configBadge +
              subBadge +
              assignedBadge +
              priorityBadge +
              '</div>' +
              '</div>' +
              '<div class="card-body">' +
              '<div class="description">' + (escapeHtml(t.description) || 'No description provided.') + '</div>' +
              '</div>' +
              '<div class="card-stats">' +
              '<div class="stat-item"><div class="number configured-color">' + assignedCount + '</div><div class="label">Assigned Companies</div></div>' +
              '<div class="stat-item"><div class="number ' + (isConfigured ? 'active-color' : 'pending-color') + '">' + (isConfigured ? '✓' : '⏳') + '</div><div class="label">' + (isConfigured ? 'Configured' : 'Pending') + '</div></div>' +
              '<div class="stat-item"><div class="number ' + (subCount > 0 ? 'active-color' : 'pending-color') + '">' + subCount + '</div><div class="label">Sub-Compliances</div></div>' +
              '</div>' +
              '<div class="card-footer">' +
              '<a href="' + viewUrl + '" class="btn btn-primary" title="Manage Sub-Compliances"><i class="fas fa-layer-group"></i> Manage</a>' +
              '<button onclick="viewComplianceHistory(' + t.id + ')" class="btn btn-ghost btn-icon" title="View History"><i class="fas fa-history"></i></button>' +
              '<button onclick="editTemplate(' + t.id + ')" class="btn btn-ghost btn-icon" title="Edit Category"><i class="fas fa-edit"></i></button>' +
              '<button onclick="toggleStatus(' + t.id + ',' + isActive + ')" class="btn ' + (isActive ? 'btn-warning' : 'btn-success') + ' btn-icon" title="' + (isActive ? 'Deactivate' : 'Activate') + '"><i class="fas ' + (isActive ? 'fa-pause-circle' : 'fa-play-circle') + '"></i></button>' +
              '<button onclick="openDeleteModal(' + t.id + ',\'' + escapeHtml(t.name) + '\',' + assignedCount + ')" class="btn btn-danger btn-icon" title="Delete"><i class="fas fa-trash"></i></button>' +
              '</div>' +
              '</div>'
          );
      }

       function editPriority(templateId, currentPriority) {
           var newPriority = prompt('Enter priority number (lower number = higher priority, appears first):', currentPriority);
           if (newPriority !== null && newPriority !== '') {
               var priorityNum = parseInt(newPriority);
               if (!isNaN(priorityNum) && priorityNum >= 0) {
                   updatePriority(templateId, priorityNum);
               } else {
                   toast('Please enter a valid number (0 or higher)', 'error');
               }
           }
       }

      async function updatePriority(templateId, priority) {
          try {
              var data = await api('/api/super-admin/compliance/templates/' + templateId + '/priority?priority=' + priority, {
                  method: 'PATCH'
              });
              if (data && data.success) {
                  toast('Priority updated successfully to ' + priority, 'success');
                  loadTemplates();
              } else {
                  toast(data?.error || 'Failed to update priority', 'error');
              }
          } catch (error) {
              console.error('Error updating priority:', error);
              toast('Failed to update priority', 'error');
          }
      }

    // ==================== PAGINATION ====================
   function renderPagination(totalPages, currentPageNum, totalElements) {
       var container = document.getElementById('pagination');
       if (totalPages <= 1) {
           container.style.display = 'none';
           return;
       }

       var html = '';
       html += '<button class="page-btn" onclick="goPage(0)" ' + (currentPageNum === 0 ? 'disabled' : '') + '><i class="fas fa-angle-double-left"></i></button>';
       html += '<button class="page-btn" onclick="goPage(' + (currentPageNum - 1) + ')" ' + (currentPageNum === 0 ? 'disabled' : '') + '><i class="fas fa-chevron-left"></i></button>';

       var start = Math.max(0, currentPageNum - 2);
       var end = Math.min(totalPages - 1, currentPageNum + 2);
       for (var i = start; i <= end; i++) {
           html += '<button class="page-btn ' + (i === currentPageNum ? 'active' : '') + '" onclick="goPage(' + i + ')">' + (i + 1) + '</button>';
       }

       html += '<button class="page-btn" onclick="goPage(' + (currentPageNum + 1) + ')" ' + (currentPageNum >= totalPages - 1 ? 'disabled' : '') + '><i class="fas fa-chevron-right"></i></button>';
       html += '<button class="page-btn" onclick="goPage(' + (totalPages - 1) + ')" ' + (currentPageNum >= totalPages - 1 ? 'disabled' : '') + '><i class="fas fa-angle-double-right"></i></button>';

       html += '<span style="margin-left:12px;font-size:12px;color:var(--gray-500);">' + (currentPageNum * pageSize + 1) + ' - ' + Math.min((currentPageNum + 1) * pageSize, totalElements) + ' of ' + totalElements + '</span>';

       container.innerHTML = html;
       container.style.display = 'flex';
   }

    function goPage(page) {
        currentPage = page;
        loadTemplates();
        document.getElementById('templatesGrid').scrollIntoView({ behavior: 'smooth' });
    }

    // ==================== CRUD OPERATIONS ====================

    function openAddModal() {
        editingId = null;
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Create Category';
        document.getElementById('modalSubtitle').textContent = 'Add a new compliance category';
        document.getElementById('templateForm').reset();
        document.getElementById('typeNonEditable').checked = true;
        document.getElementById('typeNonEditable').disabled = false;
        document.getElementById('typeEditable').disabled = false;
        document.getElementById('typeLockNote').style.display = 'none';
        document.getElementById('templateModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('templateModal').style.display = 'none';
        document.body.style.overflow = '';
    }

   async function editTemplate(id) {
       editingId = id;
       var data = await api('/api/super-admin/compliance/templates/' + id);
       if (data && data.success) {
           var t = data.data;
           document.getElementById('name').value = t.name;
           document.getElementById('description').value = t.description || '';
           if (t.editableForCompanies === true) {
               document.getElementById('typeEditable').checked = true;
           } else {
               document.getElementById('typeNonEditable').checked = true;
           }
           document.getElementById('typeNonEditable').disabled = true;
           document.getElementById('typeEditable').disabled = true;
           document.getElementById('typeLockNote').style.display = 'inline';
           document.getElementById('priority').value = t.priority || 0;
           document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit" style="color:var(--primary);margin-right:8px;"></i>Edit Category';
           document.getElementById('modalSubtitle').textContent = 'Update compliance category details';
           document.getElementById('templateModal').style.display = 'flex';
           document.body.style.overflow = 'hidden';
       } else {
           toast('Failed to load category details', 'error');
       }
   }

     async function saveTemplate() {
         var name = document.getElementById('name').value.trim();
         var description = document.getElementById('description').value;
         var priority = parseInt(document.getElementById('priority').value) || 0;

         if (!name) {
             toast('Please enter category name', 'error');
             return;
         }

         var isEditable = document.getElementById('typeEditable').checked;

         var payload = {
                     name: name,
                     description: description,
                     priority: priority,
                     editableForCompanies: isEditable
                 };

         var btn = document.getElementById('saveBtn');
         var originalText = btn.innerHTML;

         btn.disabled = true;
         btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

         var url, method;
         if (editingId) {
             // ===== FIX: Use the correct PUT endpoint =====
             url = '/api/super-admin/compliance/templates/' + editingId;
             method = 'PUT';
         } else {
             url = '/api/super-admin/compliance/templates';
             method = 'POST';
         }

         var data = await api(url, {
             method: method,
             body: JSON.stringify(payload)
         });

         btn.disabled = false;
         btn.innerHTML = originalText;

         if (data && data.success) {
             toast(editingId ? 'Category updated successfully' : 'Category created successfully', 'success');
             closeModal();
             currentPage = 0;
             loadTemplates();
         } else {
             toast(data?.error || 'Operation failed', 'error');
         }
     }

    async function toggleStatus(id, currentStatus) {
        var action = currentStatus ? 'deactivate' : 'activate';
        if (!confirm('Are you sure you want to ' + action + ' this category?')) return;

        var data = await api('/api/super-admin/compliance/templates/' + id + '/toggle-status', { method: 'PATCH' });

        if (data && data.success) {
            toast('Category ' + action + 'd successfully', 'success');
            currentPage = 0;
            loadTemplates();
        } else {
            toast(data?.error || 'Failed to ' + action + ' category', 'error');
        }
    }

    function openDeleteModal(id, name, assignedCount) {
        pendingDeleteId = id;
        document.getElementById('deleteCategoryName').textContent = name;

        var warning = document.getElementById('deleteWarning');
        var warningText = document.getElementById('deleteWarningText');

        if (assignedCount > 0) {
            warning.style.display = 'flex';
            warningText.textContent = 'This category is assigned to ' + assignedCount + ' company(ies). Deleting will also remove all assignments, configurations, documents, and history!';
        } else {
            warning.style.display = 'none';
        }

        document.getElementById('deleteModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteModal() {
        pendingDeleteId = null;
        document.getElementById('deleteModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function confirmDelete() {
        if (!pendingDeleteId) return;

        var btn = document.getElementById('deleteBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';

        var data = await api('/api/super-admin/compliance/templates/' + pendingDeleteId, { method: 'DELETE' });

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (data && data.success) {
            toast('Category permanently deleted', 'success');
            closeDeleteModal();
            currentPage = 0;
            loadTemplates();
        } else {
            toast(data?.error || 'Failed to delete category', 'error');
        }
    }

  async function viewComplianceHistory(templateId) {
      var modal = document.getElementById('subComplianceModal');
      var body = document.getElementById('subModalBody');
      var title = document.getElementById('subModalTitle');
      var subtitle = document.getElementById('subModalSubtitle');

      var template = allTemplates.find(function(t) { return t.id === templateId; });
      title.textContent = template ? template.name + ' - History' : 'Compliance History';
      subtitle.textContent = 'View all activity and configuration history for this compliance category';

      body.innerHTML = '<div style="text-align:center;padding:40px;"><div class="spinner"></div>Loading history...</div>';
      modal.style.display = 'flex';
      document.body.style.overflow = 'hidden';

      try {
          var data = await api('/api/super-admin/compliance/templates/' + templateId + '/history');

          if (data && data.success) {
              var historyEntries = data.data || [];

              if (historyEntries.length === 0) {
                  body.innerHTML = '<div class="empty-state-container" style="padding:40px;">' +
                      '<i class="fas fa-history" style="font-size:36px;opacity:0.3;"></i>' +
                      '<p style="margin-top:12px;">No history available for this compliance category</p>' +
                      '<p style="font-size:12px;color:var(--gray-500);margin-top:4px;">History will be recorded when this compliance is created, configured, or assigned to companies</p>' +
                      '</div>';
                  return;
              }

              var html = '<div style="display:flex;flex-direction:column;gap:10px;">';

              for (var i = 0; i < Math.min(historyEntries.length, 50); i++) {
                  var h = historyEntries[i];
                  var isCreation = h.action && (h.action.includes('Created') || h.action.includes('created'));
                  var isConfig = h.action && (h.action.includes('Configured') || h.action.includes('configured'));
                  var isCompletion = h.action && (h.action.includes('Completed') || h.action.includes('completed'));
                  var isAssignment = h.action && (h.action.includes('Assign') || h.action.includes('assign'));

                  var borderColor = 'var(--primary)';
                  if (isCreation) borderColor = 'var(--success)';
                  else if (isConfig) borderColor = 'var(--info)';
                  else if (isCompletion) borderColor = 'var(--success)';
                  else if (isAssignment) borderColor = 'var(--warning)';

                  var icon = 'fa-clock';
                  if (isCreation) icon = 'fa-plus-circle';
                  else if (isConfig) icon = 'fa-cog';
                  else if (isCompletion) icon = 'fa-check-circle';
                  else if (isAssignment) icon = 'fa-user-plus';

                  html += '<div style="padding:12px 16px;background:rgba(226,232,240,0.15);border-radius:8px;border-left:3px solid ' + borderColor + ';">' +
                      '<div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:8px;">' +
                      '<div>' +
                      (h.companyName ? '<div style="font-size:11px;color:var(--gray-500);margin-bottom:4px;">🏢 ' + escapeHtml(h.companyName) + '</div>' : '') +
                      '<div style="font-size:13px;font-weight:500;color:var(--gray-800);">' +
                      '<i class="fas ' + icon + '" style="color:' + borderColor + ';margin-right:6px;"></i>' +
                      escapeHtml(h.action) +
                      '</div>' +
                      (h.remarks ? '<div style="font-size:12px;color:var(--gray-500);margin-top:4px;">📝 ' + escapeHtml(h.remarks) + '</div>' : '') +
                      (h.previousStatus && h.newStatus ? '<div style="font-size:11px;color:var(--gray-500);margin-top:4px;">Status: ' +
                          getStatusLabel(h.previousStatus) + ' → ' + getStatusLabel(h.newStatus) + '</div>' : '') +
                      '</div>' +
                      '<div style="text-align:right;flex-shrink:0;">' +
                      '<div style="font-size:11px;color:var(--gray-500);">' + formatDateTime(h.performedAt) + '</div>' +
                      '<div style="font-size:10px;color:var(--gray-500);">👤 ' + (h.performedByName || 'System') + '</div>' +
                      '</div>' +
                      '</div>' +
                      '</div>';
              }

              if (historyEntries.length > 50) {
                  html += '<div style="text-align:center;padding:12px;color:var(--gray-500);font-size:12px;">Showing 50 of ' + historyEntries.length + ' entries</div>';
              }

              html += '</div>';
              body.innerHTML = html;

          } else {
              body.innerHTML = '<div class="empty-state-container">Failed to load history</div>';
          }
      } catch (error) {
          console.error('Error loading history:', error);
          body.innerHTML = '<div class="empty-state-container">Error loading history</div>';
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

    function closeSubModal() {
        document.getElementById('subComplianceModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    // ==================== FILTERS ====================
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = 'all';
        document.getElementById('configFilter').value = 'all';
        currentPage = 0;
        loadTemplates();
        toast('Filters reset', 'info');
    }

    function refreshList() {
        currentPage = 0;
        loadTemplates();
        toast('List refreshed', 'info');
    }

    // ==================== EVENT LISTENERS ====================
    document.getElementById('searchInput').addEventListener('input', function() {
        currentPage = 0;
        loadTemplates();
    });

    document.getElementById('statusFilter').addEventListener('change', function() {
        currentPage = 0;
        loadTemplates();
    });

    document.getElementById('configFilter').addEventListener('change', function() {
        currentPage = 0;
        loadTemplates();
    });

    // Close modals on overlay click
    var modalIds = ['templateModal', 'deleteModal', 'subComplianceModal'];
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

        loadTemplates();
        loadNotifications();
    });
</script>

</body>
</html>