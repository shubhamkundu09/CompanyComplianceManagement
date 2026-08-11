<%-- File: superadmin/dashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% pageContext.setAttribute("pageTitle", "Dashboard"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>VNext Legal LLP — Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

        html {
            -webkit-text-size-adjust: 100%;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
            overflow-x: hidden;
            -webkit-tap-highlight-color: transparent;
        }

        body.no-scroll {
            overflow: hidden;
        }

        img { max-width: 100%; }

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
            max-width: 82vw;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(226, 232, 240, 0.6);
            padding: 24px 16px;
            padding-top: calc(24px + env(safe-area-inset-top));
            padding-bottom: calc(24px + env(safe-area-inset-bottom));
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            height: 100dvh;
            overflow-y: auto;
            -webkit-overflow-scrolling: touch;
            overscroll-behavior: contain;
            z-index: 50;
            transition: transform 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .sidebar-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.45);
            z-index: 45;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .sidebar-overlay.open {
            display: block;
            opacity: 1;
            visibility: visible;
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
            height: calc(64px + env(safe-area-inset-top));
            padding-top: env(safe-area-inset-top);
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            z-index: 40;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-left: 32px;
            padding-right: 32px;
            transition: left 0.3s ease;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
            min-width: 0;
            flex: 1 1 auto;
        }

        .header-left .menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray-600);
            cursor: pointer;
            padding: 8px;
            margin: -8px;
            flex-shrink: 0;
            line-height: 1;
        }

        .header-left .page-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--gray-900);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            min-width: 0;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-shrink: 0;
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
            margin-top: calc(64px + env(safe-area-inset-top));
            padding: 32px 40px;
            padding-bottom: calc(32px + env(safe-area-inset-bottom));
            flex: 1;
            min-width: 0;
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

        /* ==================== STATS ==================== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            transition: all 0.3s;
            cursor: pointer;
        }

        .stat-card:hover {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
            border-color: var(--primary-light);
        }

        .stat-card .stat-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .stat-card .stat-label {
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-500);
        }

        .stat-card .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .stat-card .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: var(--gray-900);
            margin-top: 8px;
            letter-spacing: -0.5px;
        }

        .stat-card .stat-sub {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 4px;
        }

        .stat-icon.blue { color: var(--primary); }
        .stat-icon.green { color: var(--success); }
        .stat-icon.red { color: var(--danger); }
        .stat-icon.yellow { color: var(--warning); }

        /* ==================== QUICK STATS ==================== */
        .quick-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .quick-stat {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: var(--radius);
            padding: 16px 20px;
            text-align: center;
        }

        .quick-stat .qs-label {
            font-size: 12px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .quick-stat .qs-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--gray-900);
            margin-top: 4px;
        }

        /* ==================== TABS ==================== */
        .tabs-container {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .tabs {
            display: flex;
            gap: 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            background: rgba(255, 255, 255, 0.3);
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none;
            padding: 0 8px;
        }

        .tabs::-webkit-scrollbar {
            display: none;
        }

        .tab-btn {
            padding: 14px 20px;
            border: none;
            background: transparent;
            color: var(--gray-500);
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 2px solid transparent;
            white-space: nowrap;
            display: flex;
            align-items: center;
            gap: 6px;
            font-family: 'Inter', sans-serif;
        }

        .tab-btn:hover {
            color: var(--gray-700);
            background: rgba(255, 255, 255, 0.2);
        }

        .tab-btn.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
            background: rgba(255, 255, 255, 0.4);
        }

        .tab-content {
            padding: 24px;
        }

        .tab-pane {
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .tab-pane.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ==================== CHARTS ==================== */
        .charts-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }

        .chart-box {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: var(--radius);
            padding: 20px;
        }

        .chart-box h4 {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 12px;
        }

        .chart-box .chart-container {
            height: 200px;
            position: relative;
        }

        /* ==================== TABLE ==================== */
        .table-wrapper {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
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

        /* ==================== ACTIVITY ==================== */
        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 12px 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.3);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 14px;
        }

        .activity-icon.overdue { background: var(--danger-bg); color: var(--danger); }
        .activity-icon.completed { background: var(--success-bg); color: var(--success); }
        .activity-icon.pending { background: var(--warning-bg); color: var(--warning); }
        .activity-icon.assigned { background: var(--primary-bg); color: var(--primary); }

        .activity-content {
            flex: 1;
        }

        .activity-content .activity-title {
            font-size: 13px;
            font-weight: 500;
            color: var(--gray-800);
        }

        .activity-content .activity-meta {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        .activity-time {
            font-size: 11px;
            color: var(--gray-400);
            white-space: nowrap;
        }

        /* ==================== FORM INPUT ==================== */
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
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .charts-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar {
                transform: translateX(-100%);
                box-shadow: none;
            }
            .sidebar.open {
                transform: translateX(0);
                box-shadow: 0 0 40px rgba(0, 0, 0, 0.15);
            }
            .main-content {
                margin-left: 0;
                padding: 24px;
            }
            .logo-bg { width: 500px; height: 500px; }
        }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .quick-stats { grid-template-columns: 1fr; gap: 10px; }
            .header { padding-left: 16px; padding-right: 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .header-user { padding: 4px; gap: 0; }
            .tabs { padding: 0 4px; }
            .tab-btn {
                padding: 12px 14px;
                font-size: 12.5px;
                min-height: 44px;
            }
            .tab-content { padding: 16px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .charts-grid { gap: 16px; }
            .chart-box { padding: 14px; }
            .chart-box .chart-container { height: 220px; }

            /* Prevent iOS Safari auto-zoom on inputs (needs >=16px font) */
            .form-input { font-size: 16px; }

            /* Full-width search fields even though inline style sets a fixed px width */
            .tab-content input.form-input { width: 100% !important; }

            /* Notification dropdown becomes a fixed sheet anchored to the viewport
               so it can never overflow off the right edge of a narrow screen */
            .notification-dropdown {
                position: fixed;
                top: calc(64px + env(safe-area-inset-top) + 8px);
                left: 12px;
                right: 12px;
                width: auto;
                max-height: 72vh;
            }

            /* ---- Card-style tables: each row becomes a stacked card ---- */
            .data-table thead { display: none; }
            .data-table, .data-table tbody, .data-table tr, .data-table td {
                display: block;
                width: 100%;
            }
            .data-table tbody tr {
                margin-bottom: 12px;
                background: rgba(255, 255, 255, 0.6);
                border: 1px solid rgba(226, 232, 240, 0.6);
                border-radius: var(--radius);
                padding: 4px 14px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
            }
            .data-table tbody tr:last-child { margin-bottom: 0; }
            .data-table tbody tr:hover { background: rgba(255, 255, 255, 0.75); }
            .data-table tbody td {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
                padding: 10px 0;
                border-bottom: 1px solid rgba(226, 232, 240, 0.4);
                text-align: right;
            }
            .data-table tbody td:last-child { border-bottom: none; }
            .data-table tbody td::before {
                content: attr(data-label);
                flex-shrink: 0;
                font-size: 10.5px;
                font-weight: 700;
                color: var(--gray-400);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                text-align: left;
            }
            /* First column acts as the card's title row: no label, full width, bold */
            .data-table tbody td:first-child {
                padding: 12px 0 10px 0;
                font-size: 14.5px;
            }
            .data-table tbody td:first-child::before { content: none; }
            .data-table tbody td:first-child > div {
                width: 100%;
            }
            /* Let a button fill the row width for easy tapping */
            .data-table tbody td:has(.btn) {
                display: block;
                text-align: left;
                padding-top: 6px;
            }
            .data-table tbody td:has(.btn)::before {
                display: block;
                margin-bottom: 6px;
            }
            .data-table tbody td .btn {
                width: 100%;
                justify-content: center;
                min-height: 40px;
            }
            /* Empty-state / colspan rows shouldn't be forced into the card layout */
            .data-table tbody tr:has(td[colspan]) {
                background: transparent;
                border: none;
                box-shadow: none;
                padding: 0;
            }
            .data-table tbody td[colspan] {
                display: block;
                text-align: center;
                padding: 0;
            }
            .data-table tbody td[colspan]::before { content: none; }
        }

        @media (max-width: 640px) {
            .stats-grid { grid-template-columns: 1fr; gap: 10px; }
        }

        @media (max-width: 480px) {
            .main-content { padding: 12px; }
            .stat-card { padding: 14px 16px; }
            .stat-card .stat-value { font-size: 22px; margin-top: 4px; }
            .stat-card .stat-icon { width: 38px; height: 38px; font-size: 15px; }
            .header { padding-left: 12px; padding-right: 12px; }
            .header-left { gap: 10px; }
            .header-right { gap: 8px; }
            .header-btn { width: 38px; height: 38px; }
            .header-left .page-title { font-size: 15px; }
            .quick-stat { padding: 12px 14px; }
            .quick-stat .qs-value { font-size: 20px; }
            .tab-content { padding: 12px; }
            .tab-btn { padding: 11px 12px; font-size: 12px; gap: 5px; }
            .notification-dropdown { left: 8px; right: 8px; top: calc(64px + env(safe-area-inset-top) + 6px); }
            .notification-header { padding: 14px 16px; }
            .notification-item { padding: 12px 16px; }
            #toast-container { left: 12px; right: 12px; bottom: calc(16px + env(safe-area-inset-bottom)); }
            .toast { min-width: 0; width: 100%; }
        }

        @media (max-width: 360px) {
            .stat-card .stat-value { font-size: 20px; }
            .tab-btn .tab-label { display: none; }
            .tab-btn { padding: 11px 14px; }
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

<!-- ==================== SIDEBAR OVERLAY (mobile) ==================== -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

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
        <a href="${baseUrl}/super-admin/dashboard" class="nav-item active">
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
            <span class="page-title" id="pageTitle">Dashboard</span>
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
        <!-- ==================== STATS ==================== -->
        <div class="stats-grid">
            <div class="stat-card" onclick="switchTab('companies')">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Total Companies</div>
                        <div class="stat-value" id="statTotal">—</div>
                        <div class="stat-sub">Active: <span id="statActive">—</span></div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-building"></i></div>
                </div>
            </div>

            <div class="stat-card" onclick="switchTab('categories')">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Compliance Categories</div>
                        <div class="stat-value" id="statCategories" style="color: var(--primary);">—</div>
                        <div class="stat-sub">Configured: <span id="statConfigured">—</span></div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-tags"></i></div>
                </div>
            </div>

            <div class="stat-card" onclick="switchTab('overdue')">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Overdue Compliances</div>
                        <div class="stat-value" id="statOverdue" style="color: var(--danger);">—</div>
                        <div class="stat-sub">Need immediate attention</div>
                    </div>
                    <div class="stat-icon red"><i class="fas fa-exclamation-triangle"></i></div>
                </div>
            </div>

            <div class="stat-card" onclick="switchTab('completed')">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Completed</div>
                        <div class="stat-value" id="statCompleted" style="color: var(--success);">—</div>
                        <div class="stat-sub">All compliances completed</div>
                    </div>
                    <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                </div>
            </div>
        </div>

        <!-- ==================== QUICK STATS ==================== -->
        <div class="quick-stats">
            <div class="quick-stat">
                <div class="qs-label">Avg Completion Rate</div>
                <div class="qs-value" id="avgCompletion" style="color: var(--primary);">—</div>
            </div>
            <div class="quick-stat">
                <div class="qs-label">Total Assignments</div>
                <div class="qs-value" id="totalAssignments" style="color: var(--warning);">—</div>
            </div>
            <div class="quick-stat">
                <div class="qs-label">Pending Actions</div>
                <div class="qs-value" id="pendingActions" style="color: var(--danger);">—</div>
            </div>
        </div>

        <!-- ==================== TABS ==================== -->
        <div class="tabs-container">
            <div class="tabs">
                <button class="tab-btn active" data-tab="overview" onclick="switchTab('overview')">
                    <i class="fas fa-chart-simple"></i> <span class="tab-label">Overview</span>
                </button>
                <button class="tab-btn" data-tab="companies" onclick="switchTab('companies')">
                    <i class="fas fa-building"></i> <span class="tab-label">Companies</span>
                </button>
                <button class="tab-btn" data-tab="categories" onclick="switchTab('categories')">
                    <i class="fas fa-tags"></i> <span class="tab-label">Categories</span>
                </button>
                <button class="tab-btn" data-tab="overdue" onclick="switchTab('overdue')">
                    <i class="fas fa-exclamation-triangle" style="color: var(--danger);"></i> <span class="tab-label">Overdue</span>
                </button>
                <button class="tab-btn" data-tab="completed" onclick="switchTab('completed')">
                    <i class="fas fa-check-circle" style="color: var(--success);"></i> <span class="tab-label">Completed</span>
                </button>
                <button class="tab-btn" data-tab="pending" onclick="switchTab('pending')">
                    <i class="fas fa-clock" style="color: var(--warning);"></i> <span class="tab-label">Pending</span>
                </button>
            </div>

            <div class="tab-content">
                <!-- Overview Tab -->
                <div id="tab-overview" class="tab-pane active">
                    <div class="charts-grid">
                        <div class="chart-box">
                            <h4><i class="fas fa-building" style="color: var(--primary);"></i> Company Status</h4>
                            <div class="chart-container">
                                <canvas id="statusChart"></canvas>
                            </div>
                            <div id="chartLegend" style="display:flex;justify-content:center;gap:20px;margin-top:12px;flex-wrap:wrap;"></div>
                        </div>
                        <div class="chart-box">
                            <h4><i class="fas fa-chart-line" style="color: var(--primary);"></i> Company Registrations</h4>
                            <div class="chart-container">
                                <canvas id="growthChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div style="margin-top: 24px;">
                        <h4 style="font-size: 14px; font-weight: 600; color: var(--gray-700); margin-bottom: 12px;">
                            <i class="fas fa-clock" style="color: var(--primary);"></i> Recent Activity
                        </h4>
                        <div id="recentActivity" style="background:rgba(255,255,255,0.3);backdrop-filter:blur(8px);border-radius:var(--radius);padding:4px 16px;border:1px solid rgba(255,255,255,0.3);">
                            <div style="text-align:center;padding:20px;">
                                <div class="spinner"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Companies Tab -->
                <div id="tab-companies" class="tab-pane">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                        <h4 style="font-size:16px;font-weight:600;color:var(--gray-900);">
                            <i class="fas fa-building" style="color:var(--primary);"></i> All Companies
                        </h4>
                        <div style="display:flex;gap:10px;flex-wrap:wrap;">
                            <input type="text" id="companySearch" class="form-input" placeholder="Search companies..." onkeyup="filterCompanies()" style="width:220px;">
                        </div>
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Employees</th>
                                    <th>Compliance</th>
                                    <th>Joined</th>
                                </tr>
                            </thead>
                            <tbody id="companiesTableBody">
                                <tr><td colspan="6" style="text-align:center;padding:40px;"><div class="spinner"></div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Categories Tab -->
                <div id="tab-categories" class="tab-pane">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                        <h4 style="font-size:16px;font-weight:600;color:var(--gray-900);">
                            <i class="fas fa-tags" style="color:var(--primary);"></i> Compliance Categories
                        </h4>
                        <input type="text" id="categorySearch" class="form-input" placeholder="Search categories..." onkeyup="filterCategories()" style="width:220px;">
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Companies</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="categoriesTableBody">
                                <tr><td colspan="5" style="text-align:center;padding:40px;"><div class="spinner"></div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Overdue Tab -->
                <div id="tab-overdue" class="tab-pane">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                        <h4 style="font-size:16px;font-weight:600;color:var(--danger);">
                            <i class="fas fa-exclamation-triangle"></i> Overdue Compliances
                        </h4>
                        <div style="display:flex;gap:10px;flex-wrap:wrap;">
                            <input type="text" id="overdueSearch" class="form-input" placeholder="Search..." onkeyup="filterOverdue()" style="width:200px;">
                            <span style="display:flex;align-items:center;padding:8px 16px;background:rgba(239,68,68,0.1);backdrop-filter:blur(4px);border-radius:8px;font-size:13px;color:var(--danger);font-weight:600;border:1px solid rgba(239,68,68,0.2);">
                                <i class="fas fa-exclamation-triangle" style="margin-right:6px;"></i> <span id="overdueTotal">0</span> overdue
                            </span>
                        </div>
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Compliance</th>
                                    <th>Sub-Compliance</th>
                                    <th>Due Date</th>
                                    <th>Overdue By</th>
                                    <th>Assigned To</th>
                                </tr>
                            </thead>
                            <tbody id="overdueTableBody">
                                <tr><td colspan="6" style="text-align:center;padding:40px;"><div class="spinner"></div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Completed Tab -->
                <div id="tab-completed" class="tab-pane">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                        <h4 style="font-size:16px;font-weight:600;color:var(--success);">
                            <i class="fas fa-check-circle"></i> Recently Completed
                        </h4>
                        <input type="text" id="completedSearch" class="form-input" placeholder="Search..." onkeyup="filterCompleted()" style="width:200px;">
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Compliance</th>
                                    <th>Sub-Compliance</th>
                                    <th>Completed By</th>
                                    <th>Completed On</th>
                                </tr>
                            </thead>
                            <tbody id="completedTableBody">
                                <tr><td colspan="5" style="text-align:center;padding:40px;"><div class="spinner"></div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pending Tab -->
                <div id="tab-pending" class="tab-pane">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                        <h4 style="font-size:16px;font-weight:600;color:var(--warning);">
                            <i class="fas fa-clock"></i> Pending Compliances
                        </h4>
                        <div style="display:flex;gap:10px;flex-wrap:wrap;">
                            <input type="text" id="pendingSearch" class="form-input" placeholder="Search..." onkeyup="filterPending()" style="width:200px;">
                            <span style="display:flex;align-items:center;padding:8px 16px;background:rgba(245,158,11,0.1);backdrop-filter:blur(4px);border-radius:8px;font-size:13px;color:var(--warning);font-weight:600;border:1px solid rgba(245,158,11,0.2);">
                                <i class="fas fa-clock" style="margin-right:6px;"></i> <span id="pendingTotal">0</span> pending
                            </span>
                        </div>
                    </div>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Compliance</th>
                                    <th>Sub-Compliance</th>
                                    <th>Due Date</th>
                                    <th>Days Left</th>
                                    <th>Assigned To</th>
                                </tr>
                            </thead>
                            <tbody id="pendingTableBody">
                                <tr><td colspan="6" style="text-align:center;padding:40px;"><div class="spinner"></div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    var contextPath = '${baseUrl}';
    var allCompanies = [];
    var allCategories = [];
    var allOverdue = [];
    var allCompleted = [];
    var allPending = [];
    var statusChartInstance = null;
    var growthChartInstance = null;

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
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('sidebarOverlay');
        var isOpen = sidebar.classList.toggle('open');
        if (overlay) overlay.classList.toggle('open', isOpen);
        document.body.classList.toggle('no-scroll', isOpen);
    }

    function closeSidebar() {
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.remove('open');
        if (overlay) overlay.classList.remove('open');
        document.body.classList.remove('no-scroll');
    }

    // ==================== TAB SWITCHING ====================
    function switchTab(tabName) {
        document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });
        var activeBtn = document.querySelector('[data-tab="' + tabName + '"]');
        if (activeBtn) activeBtn.classList.add('active');

        document.querySelectorAll('.tab-pane').forEach(function(pane) {
            pane.classList.remove('active');
        });
        var target = document.getElementById('tab-' + tabName);
        if (target) target.classList.add('active');

        // Update page title
        var titles = {
            'overview': 'Dashboard',
            'companies': 'Companies',
            'categories': 'Categories',
            'overdue': 'Overdue Compliances',
            'completed': 'Completed Compliances',
            'pending': 'Pending Compliances'
        };
        document.getElementById('pageTitle').textContent = titles[tabName] || 'Dashboard';

        if (tabName === 'companies') loadCompanies();
        else if (tabName === 'categories') loadCategories();
        else if (tabName === 'overdue') loadOverdue();
        else if (tabName === 'completed') loadCompleted();
        else if (tabName === 'pending') loadPending();
    }

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

    // ==================== LOAD DASHBOARD ====================
    async function loadDashboard() {
        try {
            await loadStats();
            await loadCompanies();
            await loadCategories();
            await loadOverdue();
            await loadCompleted();
            await loadPending();
            await loadOverview();
            await loadNotifications();

            // Update user info
            const userStr = localStorage.getItem('user');
            if (userStr) {
                try {
                    const u = JSON.parse(userStr);
                    document.getElementById('userName').textContent = u.firstName + ' ' + u.lastName;
                    document.getElementById('userAvatar').textContent = (u.firstName || 'U')[0] + (u.lastName || '')[0];
                    document.getElementById('userRole').textContent = (u.role || '').replace('_', ' ');
                } catch(e) {}
            }
        } catch(error) {
            console.error('Error loading dashboard:', error);
            toast('Failed to load dashboard data', 'error');
        }
    }

    // ==================== STATS ====================
    async function loadStats() {
        try {
            var companyData = await api('/api/super-admin/companies?page=0&size=1000');
            if (companyData && companyData.success) {
                allCompanies = companyData.data.content || [];
                var total = allCompanies.length;
                var active = allCompanies.filter(function(c) { return c.status === 'ACTIVE'; }).length;
                document.getElementById('statTotal').textContent = total;
                document.getElementById('statActive').textContent = active;
            }

            var categoryData = await api('/api/super-admin/compliance/templates?page=0&size=100');
            if (categoryData && categoryData.success) {
                var categories = categoryData.data.content || [];
                document.getElementById('statCategories').textContent = categories.length;
                var configured = categories.filter(function(c) { return c.isActive; }).length;
                document.getElementById('statConfigured').textContent = configured;
            }

            var assignData = await api('/api/super-admin/compliance/assignments?page=0&size=1000');
            if (assignData && assignData.success) {
                var assignments = assignData.data.content || [];
                var overdue = assignments.filter(function(a) { return a.status === 'OVERDUE'; });
                var completed = assignments.filter(function(a) { return a.status === 'COMPLETED'; });
                var pending = assignments.filter(function(a) { return a.status === 'PENDING'; });
                document.getElementById('statOverdue').textContent = overdue.length;
                document.getElementById('statCompleted').textContent = completed.length;
                document.getElementById('totalAssignments').textContent = assignments.length;
                document.getElementById('pendingActions').textContent = pending.length;

                var total = assignments.length;
                var completedCount = completed.length;
                var rate = total > 0 ? Math.round((completedCount / total) * 100) : 0;
                document.getElementById('avgCompletion').textContent = rate + '%';
            }
        } catch(e) {
            console.error('Error loading stats:', e);
        }
    }

    // ==================== OVERVIEW ====================
    async function loadOverview() {
        try {
            if (typeof Chart !== 'undefined') {
                var ctx = document.getElementById('statusChart');
                if (ctx) {
                    if (statusChartInstance) statusChartInstance.destroy();
                    var active = allCompanies.filter(function(c) { return c.status === 'ACTIVE'; }).length;
                    var deactivated = allCompanies.filter(function(c) { return c.status === 'DEACTIVATED'; }).length;

                    statusChartInstance = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: ['Active', 'Deactivated'],
                            datasets: [{
                                data: [active || 0, deactivated || 0],
                                backgroundColor: ['#10b981', '#ef4444'],
                                borderColor: 'rgba(255,255,255,0.5)',
                                borderWidth: 3,
                                hoverOffset: 8
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '68%',
                            plugins: {
                                legend: { display: false },
                                tooltip: { backgroundColor: 'rgba(255,255,255,0.9)', titleColor: '#1e293b', bodyColor: '#64748b', borderColor: 'rgba(226,232,240,0.5)', borderWidth: 1 }
                            }
                        }
                    });

                    var legend = document.getElementById('chartLegend');
                    if (legend) {
                        legend.innerHTML = [
                            ['Active', '#10b981', active || 0],
                            ['Deactivated', '#ef4444', deactivated || 0]
                        ].map(function(item) {
                            return '<div style="display:flex;align-items:center;gap:6px;font-size:12px;color:#64748b;">' +
                                '<span style="width:10px;height:10px;border-radius:50%;background:' + item[1] + ';display:inline-block;"></span>' +
                                item[0] + ' <strong style="color:#1e293b;">' + item[2] + '</strong></div>';
                        }).join('');
                    }
                }

                var gCtx = document.getElementById('growthChart');
                if (gCtx) {
                    if (growthChartInstance) growthChartInstance.destroy();
                    var monthCounts = {};
                    allCompanies.forEach(function(c) {
                        if (!c.createdAt) return;
                        var m = new Date(c.createdAt).toLocaleDateString('en-IN', { month: 'short', year: '2-digit' });
                        monthCounts[m] = (monthCounts[m] || 0) + 1;
                    });
                    var labels = [], vals = [];
                    for (var i = 5; i >= 0; i--) {
                        var d = new Date(); d.setMonth(d.getMonth() - i);
                        var k = d.toLocaleDateString('en-IN', { month: 'short', year: '2-digit' });
                        labels.push(d.toLocaleDateString('en-IN', { month: 'short' }));
                        vals.push(monthCounts[k] || 0);
                    }
                    growthChartInstance = new Chart(gCtx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Companies',
                                data: vals,
                                backgroundColor: 'rgba(79, 70, 229, 0.5)',
                                borderColor: '#4f46e5',
                                borderWidth: 1,
                                borderRadius: 6
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false },
                                tooltip: { backgroundColor: 'rgba(255,255,255,0.9)', titleColor: '#1e293b', bodyColor: '#64748b', borderColor: 'rgba(226,232,240,0.5)', borderWidth: 1 }
                            },
                            scales: {
                                x: { grid: { color: 'rgba(226,232,240,0.3)' }, ticks: { color: '#94a3b8', font: { size: 11 } } },
                                y: { grid: { color: 'rgba(226,232,240,0.3)' }, ticks: { color: '#94a3b8', font: { size: 11 }, stepSize: 1 }, beginAtZero: true }
                            }
                        }
                    });
                }
            }

            await loadRecentActivity();
        } catch(e) {
            console.error('Error loading overview:', e);
        }
    }

    // ==================== RECENT ACTIVITY ====================
    async function loadRecentActivity() {
        var container = document.getElementById('recentActivity');
        try {
            var data = await api('/api/super-admin/compliance/assignments?page=0&size=10&sortBy=assignedAt&sortDir=desc');
            if (data && data.success) {
                var activities = data.data.content || [];
                if (!activities.length) {
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><div>No recent activity</div></div>';
                    return;
                }
                var html = '';
                for (var i = 0; i < Math.min(activities.length, 10); i++) {
                    var a = activities[i];
                    var icon = 'pending';
                    var iconClass = 'pending';
                    var label = 'Assigned';
                    var statusBadge = 'badge-info';
                    if (a.status === 'COMPLETED') { icon = 'completed'; iconClass = 'completed'; label = 'Completed'; statusBadge = 'badge-success'; }
                    else if (a.status === 'OVERDUE') { icon = 'overdue'; iconClass = 'overdue'; label = 'Overdue'; statusBadge = 'badge-danger'; }
                    else { statusBadge = 'badge-warning'; }

                    html += '<div class="activity-item">' +
                        '<div class="activity-icon ' + iconClass + '"><i class="fas fa-' + (icon === 'pending' ? 'clock' : icon === 'completed' ? 'check' : 'exclamation-triangle') + '"></i></div>' +
                        '<div class="activity-content">' +
                        '<div class="activity-title">' + escapeHtml(a.companyName || 'Unknown') + ' — ' + escapeHtml(a.templateName || 'Compliance') +
                        (a.subTemplateName ? ' → ' + escapeHtml(a.subTemplateName) : '') +
                        ' <span class="badge ' + statusBadge + '">' + label + '</span></div>' +
                        '<div class="activity-meta">Assigned to ' + (a.assignedByName || '—') + '</div>' +
                        '</div>' +
                        '<div class="activity-time">' + formatDateTime(a.assignedAt) + '</div>' +
                        '</div>';
                }
                container.innerHTML = html;
            }
        } catch(e) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><div>Failed to load activity</div></div>';
        }
    }

    // ==================== COMPANIES ====================
    async function loadCompanies() {
        var data = await api('/api/super-admin/companies?page=0&size=1000');
        if (data && data.success) {
            allCompanies = data.data.content || [];
            filterCompanies();
        }
    }

    function filterCompanies() {
        var search = document.getElementById('companySearch').value.toLowerCase();
        var filtered = allCompanies.filter(function(c) {
            if (search && !c.companyName.toLowerCase().includes(search) && !c.email.toLowerCase().includes(search)) return false;
            return true;
        });
        renderCompanies(filtered);
    }

    function renderCompanies(companies) {
        var tbody = document.getElementById('companiesTableBody');
        if (!companies.length) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:40px;"><div class="empty-state"><i class="fas fa-building"></i><div>No companies found</div></div></td></tr>';
            return;
        }
        tbody.innerHTML = companies.map(function(c) {
            var statusBadge = c.status === 'ACTIVE' ? 'badge-success' : 'badge-danger';
            return '<tr>' +
                '<td data-label="Company"><strong>' + escapeHtml(c.name) + '</strong></td>' +  // Changed from c.companyName to c.name
                '<td data-label="Email">' + escapeHtml(c.email) + '</td>' +
                '<td data-label="Status"><span class="badge ' + statusBadge + '">' + (c.status || '—') + '</span></td>' +
                '<td data-label="Employees">' + (c.currentEmployeeCount || 0) + '</td>' +  // Changed from c.employeeCount
                '<td data-label="Compliance"><span class="badge badge-info">' + (c.complianceCount || 0) + '</span></td>' +
                '<td data-label="Joined" style="font-size:12px;color:#64748b;">' + formatDate(c.createdAt) + '</td>' +
                '</tr>';
        }).join('');
    }

    // ==================== CATEGORIES ====================
    async function loadCategories() {
        var data = await api('/api/super-admin/compliance/templates?page=0&size=100');
        if (data && data.success) {
            allCategories = data.data.content || [];
            filterCategories();
        }
    }

    function filterCategories() {
        var search = document.getElementById('categorySearch').value.toLowerCase();
        var filtered = allCategories.filter(function(c) {
            if (search && !c.name.toLowerCase().includes(search)) return false;
            return true;
        });
        renderCategories(filtered);
    }

    function renderCategories(categories) {
        var tbody = document.getElementById('categoriesTableBody');
        if (!categories.length) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:40px;"><div class="empty-state"><i class="fas fa-tags"></i><div>No categories found</div></div></td></tr>';
            return;
        }
        tbody.innerHTML = categories.map(function(c) {
            var statusBadge = c.isActive ? 'badge-success' : 'badge-danger';
            var iconClass = getComplianceIcon(c.name);
            return '<tr>' +
                '<td data-label="Category"><div style="display:flex;align-items:center;gap:8px;">' +
                '<div style="width:36px;height:36px;border-radius:50%;background:rgb(0,0,0);border:1.5px solid rgba(79,70,229,0.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
                '<i class="fas ' + iconClass + '" style="color:#e9d80f;font-size:14px;"></i>' +
                '</div>' +
                '<span style="font-weight:500;">' + escapeHtml(c.name) + '</span></div></td>' +
                '<td data-label="Description" style="font-size:12px;color:#64748b;">' + (c.description ? escapeHtml(c.description) : '—') + '</td>' +
                '<td data-label="Status"><span class="badge ' + statusBadge + '">' + (c.isActive ? 'Active' : 'Inactive') + '</span></td>' +
                '<td data-label="Companies" style="text-align:center;">' + (c.companiesCount || 0) + '</td>' +
                '<td data-label="Actions"><button onclick="window.location.href=\'' + contextPath + '/super-admin/compliance/templates/' + c.id + '\'" class="btn btn-ghost" style="padding:4px 12px;font-size:11px;"><i class="fas fa-eye"></i> View</button></td>' +
                '</tr>';
        }).join('');
    }

    // ==================== OVERDUE ====================
    async function loadOverdue() {
        var data = await api('/api/super-admin/compliance/assignments?page=0&size=200&status=OVERDUE');
        if (data && data.success) {
            allOverdue = data.data.content || [];
            document.getElementById('overdueTotal').textContent = allOverdue.length;
            filterOverdue();
        }
    }

    function filterOverdue() {
        var search = document.getElementById('overdueSearch').value.toLowerCase();
        var filtered = allOverdue.filter(function(c) {
            if (search && !c.companyName.toLowerCase().includes(search) && !c.templateName.toLowerCase().includes(search)) return false;
            return true;
        });
        renderOverdue(filtered);
    }

    function renderOverdue(overdue) {
        var tbody = document.getElementById('overdueTableBody');
        if (!overdue.length) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:40px;"><div class="empty-state"><i class="fas fa-check-circle" style="color:var(--success);font-size:36px;"></i><br>No overdue compliances! 🎉</div></td></tr>';
            return;
        }
        tbody.innerHTML = overdue.map(function(c) {
            var dueDate = c.dueDate ? new Date(c.dueDate) : null;
            var overdueDays = dueDate ? Math.ceil((new Date() - dueDate) / (1000 * 60 * 60 * 24)) : 0;
            return '<tr>' +
                '<td data-label="Company"><strong>' + escapeHtml(c.companyName) + '</strong></td>' +
                '<td data-label="Compliance">' + escapeHtml(c.templateName) + '</td>' +
                '<td data-label="Sub-Compliance">' + (c.subTemplateName ? escapeHtml(c.subTemplateName) : '—') + '</td>' +
                '<td data-label="Due Date" style="font-size:12px;">' + formatDate(c.dueDate) + '</td>' +
                '<td data-label="Overdue By"><span class="badge badge-danger">' + overdueDays + ' days</span></td>' +
                '<td data-label="Assigned To">' + (c.assignedByName || '—') + '</td>' +
                '</tr>';
        }).join('');
    }

    // ==================== COMPLETED ====================
    async function loadCompleted() {
        var data = await api('/api/super-admin/compliance/assignments?page=0&size=200&status=COMPLETED');
        if (data && data.success) {
            allCompleted = data.data.content || [];
            filterCompleted();
        }
    }

    function filterCompleted() {
        var search = document.getElementById('completedSearch').value.toLowerCase();
        var filtered = allCompleted.filter(function(c) {
            if (search && !c.companyName.toLowerCase().includes(search) && !c.templateName.toLowerCase().includes(search)) return false;
            return true;
        });
        renderCompleted(filtered);
    }

    function renderCompleted(completed) {
        var tbody = document.getElementById('completedTableBody');
        if (!completed.length) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:40px;"><div class="empty-state"><i class="fas fa-inbox"></i><div>No completed compliances yet</div></div></td></tr>';
            return;
        }
        tbody.innerHTML = completed.slice(0, 50).map(function(c) {
            return '<tr>' +
                '<td data-label="Company"><strong>' + escapeHtml(c.companyName) + '</strong></td>' +
                '<td data-label="Compliance">' + escapeHtml(c.templateName) + '</td>' +
                '<td data-label="Sub-Compliance">' + (c.subTemplateName ? escapeHtml(c.subTemplateName) : '—') + '</td>' +
                '<td data-label="Completed By">' + (c.assignedByName || 'System') + '</td>' +
                '<td data-label="Completed On" style="font-size:12px;color:#64748b;">' + formatDateTime(c.assignedAt) + '</td>' +
                '</tr>';
        }).join('');
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

    // ==================== PENDING ====================
    async function loadPending() {
        var data = await api('/api/super-admin/compliance/assignments?page=0&size=200&status=PENDING');
        if (data && data.success) {
            allPending = data.data.content || [];
            document.getElementById('pendingTotal').textContent = allPending.length;
            filterPending();
        }
    }

    function filterPending() {
        var search = document.getElementById('pendingSearch').value.toLowerCase();
        var filtered = allPending.filter(function(c) {
            if (search && !c.companyName.toLowerCase().includes(search) && !c.templateName.toLowerCase().includes(search)) return false;
            return true;
        });
        renderPending(filtered);
    }

    function renderPending(pending) {
        var tbody = document.getElementById('pendingTableBody');
        if (!pending.length) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:40px;"><div class="empty-state"><i class="fas fa-clock"></i><div>No pending compliances</div></div></td></tr>';
            return;
        }
        tbody.innerHTML = pending.map(function(c) {
            var dueDate = c.dueDate ? new Date(c.dueDate) : null;
            var daysLeft = dueDate ? Math.ceil((dueDate - new Date()) / (1000 * 60 * 60 * 24)) : 0;
            var daysClass = daysLeft < 0 ? 'badge-danger' : daysLeft < 7 ? 'badge-warning' : 'badge-success';
            var daysText = daysLeft < 0 ? 'Overdue' : daysLeft + ' days';
            return '<tr>' +
                '<td data-label="Company"><strong>' + escapeHtml(c.companyName) + '</strong></td>' +
                '<td data-label="Compliance">' + escapeHtml(c.templateName) + '</td>' +
                '<td data-label="Sub-Compliance">' + (c.subTemplateName ? escapeHtml(c.subTemplateName) : '—') + '</td>' +
                '<td data-label="Due Date" style="font-size:12px;">' + formatDate(c.dueDate) + '</td>' +
                '<td data-label="Days Left"><span class="badge ' + daysClass + '">' + daysText + '</span></td>' +
                '<td data-label="Assigned To">' + (c.assignedByName || '—') + '</td>' +
                '</tr>';
        }).join('');
    }

    // ==================== REFRESH ====================
    function refreshDashboard() {
        loadDashboard();
        toast('Dashboard refreshed', 'success');
    }

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        // Close sidebar on outside click / overlay tap for mobile
        document.addEventListener('click', function(e) {
            if (window.innerWidth <= 1024) {
                var sidebar = document.getElementById('sidebar');
                if (sidebar && sidebar.classList.contains('open')) {
                    if (!sidebar.contains(e.target) && !e.target.closest('.menu-toggle')) {
                        closeSidebar();
                    }
                }
            }
        });

        // Close sidebar automatically when a nav link is tapped on mobile
        document.querySelectorAll('.sidebar .nav-item').forEach(function(item) {
            item.addEventListener('click', function() {
                if (window.innerWidth <= 1024) closeSidebar();
            });
        });

        // Debounce search inputs
        var searchInputs = document.querySelectorAll('input[type="text"]');
        searchInputs.forEach(function(input) {
            var timeout;
            input.addEventListener('input', function() {
                clearTimeout(timeout);
                timeout = setTimeout(function() {
                    if (input.id === 'companySearch') filterCompanies();
                    else if (input.id === 'categorySearch') filterCategories();
                    else if (input.id === 'overdueSearch') filterOverdue();
                    else if (input.id === 'completedSearch') filterCompleted();
                    else if (input.id === 'pendingSearch') filterPending();
                }, 300);
            });
        });
    });

    loadDashboard();
</script>

</body>
</html>
