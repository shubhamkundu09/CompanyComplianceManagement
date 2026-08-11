<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: companyadmin/employees.jsp --%>
<% pageContext.setAttribute("pageTitle", "Employees"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Employees</title>

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

        /* ==================== FILTER BAR ==================== */
        .filter-bar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .filter-bar .filter-grid {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .filter-bar .filter-grid .filter-item {
            flex: 1;
            min-width: 160px;
        }

        .filter-bar .filter-grid .filter-item .form-input {
            width: 100%;
        }

        .filter-bar .filter-grid .filter-item.search-item {
            flex: 2;
            min-width: 200px;
        }

        .filter-bar .filter-grid .filter-item .position-relative {
            position: relative;
        }

        .filter-bar .filter-grid .filter-item .position-relative .search-icon {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 12px;
        }

        .filter-bar .filter-grid .filter-item .position-relative .form-input {
            padding-left: 32px;
        }

        /* ==================== TABLE ==================== */
        .table-container {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .table-header {
            padding: 16px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-header .table-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--gray-900);
        }

        .table-header .table-info {
            font-size: 12px;
            color: var(--gray-500);
        }

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

        /* ==================== PROGRESS BAR ==================== */
        .progress-bar {
            height: 4px;
            background: rgba(226, 232, 240, 0.5);
            border-radius: 2px;
            overflow: hidden;
            width: 80px;
        }

        .progress-bar .progress-fill {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s ease;
        }

        /* ==================== PAGINATION ==================== */
        .table-footer {
            padding: 14px 20px;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
        }

        .table-footer .pagination-info {
            font-size: 12px;
            color: var(--gray-500);
        }

        .table-footer .pagination-btns {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .page-btn {
            padding: 4px 10px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            background: rgba(255, 255, 255, 0.5);
            color: var(--gray-600);
            font-size: 12px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
        }

        .page-btn:hover {
            background: var(--gray-100);
            border-color: var(--gray-300);
        }

        .page-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
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

        .btn-ghost {
            background: transparent;
            border: 1px solid rgba(226, 232, 240, 0.6);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.5);
            border-color: var(--gray-300);
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

        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
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
            max-width: 700px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
        }

        .modal-box.small {
            max-width: 450px;
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

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: var(--gray-500);
            grid-column: 1 / -1;
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

        /* ==================== COMPLIANCE BADGES ==================== */
        .compliance-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 500;
            margin: 2px;
        }
        .compliance-completed { background: var(--success-bg); color: var(--success); }
        .compliance-in-progress { background: var(--primary-bg); color: var(--primary); }
        .compliance-pending { background: var(--warning-bg); color: var(--warning); }
        .compliance-overdue { background: var(--danger-bg); color: var(--danger); }

        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .logo-bg { width: 500px; height: 500px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .stats-grid { grid-template-columns: 1fr; }
            .filter-bar .filter-grid .filter-item { min-width: 100%; }
            .filter-bar .filter-grid .filter-item.search-item { flex: 1; min-width: 100%; }
            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .stat-card .stat-value { font-size: 24px; }
            .header-left .page-title { font-size: 15px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .data-table thead th, .data-table tbody td { padding: 8px 10px; font-size: 12px; }
            .table-footer { flex-direction: column; align-items: flex-start; }
            .table-footer .pagination-btns { width: 100%; justify-content: center; }
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
           <a href="${baseUrl}/company-admin/employees" class="nav-item active">
               <i class="fas fa-users"></i> Employees
               <span class="nav-badge" id="employeeCount">0</span>
           </a>

           <div class="sidebar-label">Compliance</div>
           <a href="${baseUrl}/company-admin/compliance/parents" class="nav-item">
               <i class="fas fa-tasks"></i> My Compliances
           </a>
           <a href="${baseUrl}/company-admin/compliance/custom/create" class="nav-item">
               <i class="fas fa-plus-circle"></i> Custom Compliance
           </a>

           <div class="sidebar-label">Communication</div>
           <a href="${baseUrl}/company-admin/notifications" class="nav-item ">
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
            <span class="page-title">Employees</span>
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
                        <a href="${baseUrl}/company-admin/notifications">View all notifications</a>
                    </div>
                </div>
            </div>

            <!-- User -->
            <div class="header-user" onclick="window.location.href='${baseUrl}/company-admin/company-details'">
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
        <div style="margin-bottom:24px;display:flex;align-items:flex-end;justify-content:space-between;flex-wrap:wrap;gap:12px;">
            <div>
                <p style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:4px;">
                    Team Management
                </p>
                <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">Employees</h1>
                <p style="font-size:13px;color:var(--gray-500);margin-top:4px;">
                    Manage your employees and track their compliance completion status
                </p>
            </div>
            <a href="${baseUrl}/company-admin/employees/add" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Employee
            </a>
        </div>

        <!-- ==================== STATS ==================== -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Total Employees</div>
                        <div class="stat-value" id="statTotal">—</div>
                        <div class="stat-sub">All employees</div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-users"></i></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Active</div>
                        <div class="stat-value" id="statActive" style="color:var(--success);">—</div>
                        <div class="stat-sub">Currently active</div>
                    </div>
                    <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Deactivated</div>
                        <div class="stat-value" id="statDeactive" style="color:var(--danger);">—</div>
                        <div class="stat-sub">Inactive accounts</div>
                    </div>
                    <div class="stat-icon red"><i class="fas fa-user-slash"></i></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Available Slots</div>
                        <div class="stat-value" id="statLimit">—</div>
                        <div class="stat-sub" id="statLimitSub">Loading...</div>
                    </div>
                    <div class="stat-icon yellow"><i class="fas fa-user-plus"></i></div>
                </div>
            </div>
        </div>

        <!-- ==================== FILTER BAR ==================== -->
        <div class="filter-bar">
            <div class="filter-grid">
                <div class="filter-item search-item">
                    <label class="form-label">Search</label>
                    <div class="position-relative">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchInput" class="form-input" placeholder="Name, email, employee code…">
                    </div>
                </div>
                <div class="filter-item">
                    <label class="form-label">Status</label>
                    <select id="statusFilter" class="form-input">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="DEACTIVE">Deactivated</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Department</label>
                    <select id="deptFilter" class="form-input">
                        <option value="">All Departments</option>
                        <option value="Engineering">Engineering</option>
                        <option value="Sales">Sales</option>
                        <option value="Marketing">Marketing</option>
                        <option value="HR">HR</option>
                        <option value="Finance">Finance</option>
                        <option value="Operations">Operations</option>
                    </select>
                </div>
                <div class="filter-item" style="display:flex;align-items:flex-end;">
                    <button onclick="resetFilters()" class="btn btn-ghost" style="width:100%;justify-content:center;">
                        <i class="fas fa-undo"></i> Reset
                    </button>
                </div>
            </div>
        </div>

        <!-- ==================== TABLE ==================== -->
        <div class="table-container">
            <div class="table-header">
                <span class="table-title"><i class="fas fa-users" style="color:var(--primary);margin-right:8px;"></i>Employee List</span>
                <span class="table-info" id="tableInfo"></span>
            </div>

            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Employee</th>
                            <th>Employee Code</th>
                            <th>Designation</th>
                            <th>Department</th>
                            <th>Compliance Status</th>
                            <th>Status</th>
                            <th>Joined</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <tr><td colspan="9"><div class="empty-state"><div class="spinner" style="margin:0 auto 8px;"></div>Loading employees…</div></td></tr>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                <span class="pagination-info" id="paginationInfo"></span>
                <div class="pagination-btns" id="paginationBtns"></div>
            </div>
        </div>

    </main>
</div>

<!-- ==================== COMPLIANCE SUMMARY MODAL ==================== -->
<div id="complianceModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="modalEmployeeName">Employee Compliance Summary</div>
                <div class="modal-subtitle" id="modalEmployeeEmail">View all assigned compliances and sub-compliances</div>
            </div>
            <button class="modal-close" onclick="closeComplianceModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body" id="complianceModalBody">
            <div style="text-align:center;padding:40px;">
                <div class="spinner"></div>
                Loading compliances...
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeComplianceModal()" class="btn btn-ghost">Close</button>
        </div>
    </div>
</div>

<!-- ==================== DELETE MODAL ==================== -->
<div id="deleteModal" class="modal-overlay">
    <div class="modal-box small">
        <div class="modal-header">
            <div>
                <div class="modal-title" style="color:var(--danger);"><i class="fas fa-exclamation-triangle" style="margin-right:8px;"></i>Delete Employee</div>
                <div class="modal-subtitle">This action cannot be undone</div>
            </div>
            <button class="modal-close" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to delete <strong id="deleteEmployeeName"></strong>?</p>
            <p style="font-size:12px;color:var(--gray-500);margin-top:8px;">This action cannot be undone.</p>
        </div>
        <div class="modal-footer">
            <button onclick="closeDeleteModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmDelete()" class="btn btn-danger">Delete</button>
        </div>
    </div>
</div>

<!-- ==================== RESET PASSWORD MODAL ==================== -->
<div id="resetModal" class="modal-overlay">
    <div class="modal-box small">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-key" style="color:var(--primary);margin-right:8px;"></i>Reset Password</div>
                <div class="modal-subtitle">Send new credentials to employee</div>
            </div>
            <button class="modal-close" onclick="closeResetModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <p>Reset password for <strong id="resetEmployeeName"></strong>?</p>
            <p style="font-size:12px;color:var(--gray-500);margin-top:8px;">New credentials will be sent to their email address.</p>
        </div>
        <div class="modal-footer">
            <button onclick="closeResetModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="confirmReset()" class="btn btn-primary">Send Reset Email</button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var currentPage = 0;
    var pageSize = 10;
    var pendingDeleteId = null;
    var pendingResetId = null;
    var currentViewEmployeeId = null;

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

    // ==================== EMPLOYEE MANAGEMENT ====================
    async function loadCompanyInfo() {
        var res = await api('/api/company-admin/company');
        if (res && res.success) {
            var activeCount = res.data.currentEmployeeCount || 0;
            var limit = res.data.employeeLimit || 0;
            var remaining = limit - activeCount;
            document.getElementById('statLimit').textContent = remaining > 0 ? remaining : 0;
            document.getElementById('statLimitSub').textContent = activeCount + ' / ' + limit + ' used';
            document.getElementById('statLimitSub').style.color = remaining > 0 ? 'var(--gray-500)' : 'var(--danger)';
        }
    }

    async function loadEmployees() {
        var search = document.getElementById('searchInput').value.trim();
        var sortBy = 'createdAt';

        var url = '/api/company-admin/employees?page=' + currentPage + '&size=' + pageSize + '&sortBy=' + sortBy + '&sortDir=desc';
        if (search) url += '&search=' + encodeURIComponent(search);

        var data = await api(url);
        if (!data || !data.success) return;

        var employees = data.data.content || [];
        var status = document.getElementById('statusFilter').value;
        var dept = document.getElementById('deptFilter').value;

        // Load compliance stats for each employee
        for (var i = 0; i < employees.length; i++) {
            var emp = employees[i];
            try {
                var complianceData = await api('/api/company-admin/compliance/employee/' + emp.id + '/compliances?page=0&size=100');
                if (complianceData && complianceData.success) {
                    var compliances = complianceData.data.content || [];
                    emp.complianceStats = calculateComplianceStats(compliances);
                } else {
                    emp.complianceStats = { total: 0, completed: 0, inProgress: 0, pending: 0, overdue: 0 };
                }
            } catch (e) {
                emp.complianceStats = { total: 0, completed: 0, inProgress: 0, pending: 0, overdue: 0 };
            }
        }

        var filtered = employees;
        if (status) filtered = filtered.filter(function(e) { return e.status === status; });
        if (dept) filtered = filtered.filter(function(e) { return e.department === dept; });

        renderTable(filtered);
        renderPagination(data.data);

        // Update stats from full page
        var active = 0, deactive = 0;
        employees.forEach(function(e) {
            if (e.status === 'ACTIVE') active++;
            else deactive++;
        });
        document.getElementById('statTotal').textContent = data.data.totalElements;
        document.getElementById('statActive').textContent = active;
        document.getElementById('statDeactive').textContent = deactive;
        document.getElementById('employeeCount').textContent = data.data.totalElements;
        document.getElementById('tableInfo').textContent = data.data.totalElements + ' total';
    }

    function calculateComplianceStats(compliances) {
        var stats = { total: compliances.length, completed: 0, inProgress: 0, pending: 0, overdue: 0 };
        for (var i = 0; i < compliances.length; i++) {
            var c = compliances[i];
            if (c.status === 'COMPLETED') stats.completed++;
            else if (c.status === 'IN_PROGRESS') stats.inProgress++;
            else if (c.status === 'PENDING') stats.pending++;
            if (c.overdue && c.status !== 'COMPLETED') stats.overdue++;
        }
        return stats;
    }

    function renderTable(employees) {
        var tbody = document.getElementById('tableBody');
        if (!employees.length) {
            tbody.innerHTML = '<tr><td colspan="9"><div class="empty-state"><i class="fas fa-users" style="font-size:36px;opacity:0.3;"></i><br>No employees found</div></td></tr>';
            return;
        }

        var html = '';
        for (var i = 0; i < employees.length; i++) {
            var emp = employees[i];
            var fullName = emp.fullName || emp.firstName + ' ' + emp.lastName;
            var initials = ((emp.firstName || '')[0] || '') + ((emp.lastName || '')[0] || '');
            var statusClass = emp.status === 'ACTIVE' ? 'badge-active' : 'badge-inactive';
            var actionBtnClass = emp.status === 'ACTIVE' ? 'btn-danger' : 'btn-success';
            var actionIcon = emp.status === 'ACTIVE' ? 'fa-ban' : 'fa-check';
            var actionTitle = emp.status === 'ACTIVE' ? 'Deactivate' : 'Activate';

            var stats = emp.complianceStats || { total: 0, completed: 0, inProgress: 0, pending: 0, overdue: 0 };
            var overallClass = stats.completed === stats.total && stats.total > 0 ? 'compliance-completed' :
                              (stats.overdue > 0 ? 'compliance-overdue' :
                              (stats.inProgress > 0 ? 'compliance-in-progress' : 'compliance-pending'));
            var overallIcon = stats.completed === stats.total && stats.total > 0 ? 'fa-check-circle' :
                             (stats.overdue > 0 ? 'fa-exclamation-triangle' :
                             (stats.inProgress > 0 ? 'fa-spinner fa-pulse' : 'fa-clock'));

            var complianceText = stats.total > 0 ? stats.completed + '/' + stats.total + ' completed' : 'No compliances';

            html += '<tr>' +
                '<td style="color:var(--gray-500);font-size:12px;">' + (currentPage * pageSize + i + 1) + '</td>' +
                '<td>' +
                    '<div style="display:flex;align-items:center;gap:10px;">' +
                        '<div class="avatar" style="width:34px;height:34px;font-size:12px;">' + escapeHtml(initials || '?') + '</div>' +
                        '<div>' +
                            '<div style="font-weight:600;font-size:13px;">' + escapeHtml(fullName) + '</div>' +
                            '<div style="font-size:11px;color:var(--gray-500);">' + escapeHtml(emp.email) + '</div>' +
                        '</div>' +
                    '</div>' +
                '</td>' +
                '<td style="font-size:12px;"><span style="background:rgba(226,232,240,0.3);padding:3px 8px;border-radius:12px;font-family:monospace;">' + escapeHtml(emp.employeeCode || '—') + '</span></td>' +
                '<td style="font-size:13px;">' + escapeHtml(emp.designation || '—') + '</td>' +
                '<td style="font-size:12px;color:var(--gray-500);">' + escapeHtml(emp.department || '—') + '</td>' +
                '<td>' +
                    '<button onclick="viewEmployeeCompliances(' + emp.id + ', \'' + escapeHtml(fullName) + '\', \'' + escapeHtml(emp.email) + '\')" class="btn btn-ghost" style="padding:4px 10px;font-size:11px;" title="View Compliances">' +
                        '<i class="fas ' + overallIcon + '" style="margin-right:4px;color:' + (overallClass === 'compliance-completed' ? 'var(--success)' : overallClass === 'compliance-overdue' ? 'var(--danger)' : 'var(--warning)') + ';"></i> ' +
                        complianceText +
                    '</button>' +
                '</td>' +
                '<td><span class="badge ' + statusClass + '"><i class="fas fa-circle" style="font-size:5px;"></i> ' + emp.status + '</span></td>' +
                '<td style="font-size:12px;color:var(--gray-500);">' + formatDate(emp.createdAt) + '</td>' +
                '<td style="text-align:center;">' +
                    '<div style="display:flex;gap:4px;justify-content:center;">' +
                        '<a href="' + contextPath + '/company-admin/employees/' + emp.id + '" class="btn btn-ghost" style="padding:5px 8px;" title="View">' +
                            '<i class="fas fa-eye" style="font-size:12px;"></i>' +
                        '</a>' +
                        '<button onclick="toggleEmployeeStatus(' + emp.id + ', \'' + emp.status + '\')" class="btn ' + actionBtnClass + '" style="padding:5px 8px;" title="' + actionTitle + '">' +
                            '<i class="fas ' + actionIcon + '" style="font-size:12px;"></i>' +
                        '</button>' +
                        '<button onclick="openResetModal(' + emp.id + ', \'' + escapeHtml(fullName) + '\')" class="btn btn-ghost" style="padding:5px 8px;" title="Reset Password">' +
                            '<i class="fas fa-key" style="font-size:12px;"></i>' +
                        '</button>' +
                        '<button onclick="openDeleteModal(' + emp.id + ', \'' + escapeHtml(fullName) + '\')" class="btn btn-danger" style="padding:5px 8px;" title="Delete">' +
                            '<i class="fas fa-trash" style="font-size:12px;"></i>' +
                        '</button>' +
                    '</div>' +
                '</td>' +
            '</tr>';
        }
        tbody.innerHTML = html;
    }

    function renderPagination(pageData) {
        var totalPages = pageData.totalPages;
        var cur = pageData.number;
        document.getElementById('paginationInfo').textContent = 'Showing page ' + (cur + 1) + ' of ' + totalPages + ' (' + pageData.totalElements + ' records)';

        var div = document.getElementById('paginationBtns');
        div.innerHTML = '';
        if (cur > 0) {
            div.innerHTML += '<button class="page-btn" onclick="goPage(' + (cur - 1) + ')"><i class="fas fa-chevron-left" style="font-size:10px;"></i></button>';
        }

        var start = Math.max(0, cur - 2);
        var end = Math.min(totalPages - 1, cur + 2);
        for (var i = start; i <= end; i++) {
            div.innerHTML += '<button class="page-btn ' + (i === cur ? 'active' : '') + '" onclick="goPage(' + i + ')">' + (i + 1) + '</button>';
        }

        if (cur < totalPages - 1) {
            div.innerHTML += '<button class="page-btn" onclick="goPage(' + (cur + 1) + ')"><i class="fas fa-chevron-right" style="font-size:10px;"></i></button>';
        }
    }

    function goPage(page) { currentPage = page; loadEmployees(); }

    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('deptFilter').value = '';
        currentPage = 0;
        loadEmployees();
    }

    async function toggleEmployeeStatus(id, currentStatus) {
        var newStatus = currentStatus === 'ACTIVE' ? 'DEACTIVE' : 'ACTIVE';
        var action = newStatus === 'ACTIVE' ? 'activate' : 'deactivate';

        if (!confirm('Are you sure you want to ' + action + ' this employee?')) return;

        var data = await api('/api/company-admin/employees/' + id + '/status?status=' + newStatus, { method: 'PATCH' });

        if (data && data.success) {
            toast('Employee ' + action + 'd successfully', 'success');
            loadEmployees();
            loadCompanyInfo();
        } else {
            toast((data && data.error) || 'Failed to update status', 'error');
        }
    }

    function openDeleteModal(id, name) {
        pendingDeleteId = id;
        document.getElementById('deleteEmployeeName').textContent = name;
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
        var data = await api('/api/company-admin/employees/' + pendingDeleteId, { method: 'DELETE' });
        if (data && data.success) {
            toast('Employee deleted successfully', 'success');
            closeDeleteModal();
            loadEmployees();
            loadCompanyInfo();
        } else {
            toast((data && data.error) || 'Failed to delete', 'error');
        }
    }

    function openResetModal(id, name) {
        pendingResetId = id;
        document.getElementById('resetEmployeeName').textContent = name;
        document.getElementById('resetModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeResetModal() {
        pendingResetId = null;
        document.getElementById('resetModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function confirmReset() {
        if (!pendingResetId) return;
        var data = await api('/api/company-admin/employees/' + pendingResetId + '/reset-password', { method: 'POST' });
        if (data && data.success) {
            toast('Password reset email sent', 'success');
            closeResetModal();
        } else {
            toast((data && data.error) || 'Failed to reset password', 'error');
        }
    }

    // ==================== COMPLIANCE MODAL ====================
    async function viewEmployeeCompliances(employeeId, employeeName, employeeEmail) {
        currentViewEmployeeId = employeeId;
        document.getElementById('modalEmployeeName').textContent = employeeName;
        document.getElementById('modalEmployeeEmail').textContent = employeeEmail;
        document.getElementById('complianceModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';

        var modalBody = document.getElementById('complianceModalBody');
        modalBody.innerHTML = '<div style="text-align:center;padding:40px;"><div class="spinner"></div>Loading compliances...</div>';

        try {
            var data = await api('/api/company-admin/compliance/employee/' + employeeId + '/compliances?page=0&size=100');
            if (data && data.success) {
                var compliances = data.data.content || [];
                renderComplianceModalContent(compliances);
            } else {
                modalBody.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><br>Failed to load compliances</div>';
            }
        } catch (e) {
            modalBody.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><br>Error loading compliances</div>';
        }
    }

    function renderComplianceModalContent(compliances) {
        var modalBody = document.getElementById('complianceModalBody');

        if (!compliances.length) {
            modalBody.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><br>No compliances assigned to this employee</div>';
            return;
        }

        // Group by parent compliance
        var grouped = {};
        for (var i = 0; i < compliances.length; i++) {
            var c = compliances[i];
            var parentId = c.companyComplianceId || c.parentId || 'unknown';
            if (!grouped[parentId]) {
                grouped[parentId] = {
                    name: c.complianceName || 'Compliance',
                    companyComplianceId: parentId,
                    subCompliances: []
                };
            }
            grouped[parentId].subCompliances.push(c);
        }

        var html = '<div style="display:flex;flex-direction:column;gap:16px;">';

        for (var parentId in grouped) {
            var group = grouped[parentId];
            var subs = group.subCompliances;
            var completed = subs.filter(function(s) { return s.status === 'COMPLETED'; }).length;
            var total = subs.length;
            var pct = total > 0 ? Math.round((completed / total) * 100) : 0;
            var overallStatus = completed === total ? 'COMPLETED' :
                               (subs.some(function(s) { return s.overdue && s.status !== 'COMPLETED'; }) ? 'OVERDUE' :
                               (subs.some(function(s) { return s.status === 'IN_PROGRESS'; }) ? 'IN_PROGRESS' : 'PENDING'));

            var statusClass = overallStatus === 'COMPLETED' ? 'compliance-completed' :
                             (overallStatus === 'OVERDUE' ? 'compliance-overdue' :
                             (overallStatus === 'IN_PROGRESS' ? 'compliance-in-progress' : 'compliance-pending'));

            var overallIcon = overallStatus === 'COMPLETED' ? 'fa-check-circle' :
                             (overallStatus === 'OVERDUE' ? 'fa-exclamation-triangle' :
                             (overallStatus === 'IN_PROGRESS' ? 'fa-spinner fa-pulse' : 'fa-clock'));

            html += '<div style="background:rgba(255,255,255,0.5);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,0.3);border-radius:var(--radius);padding:16px;">' +
                '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">' +
                    '<div>' +
                        '<div style="font-weight:700;font-size:15px;color:var(--gray-800);">' + escapeHtml(group.name) + '</div>' +
                        '<div style="font-size:11px;color:var(--gray-500);">' + total + ' sub-compliance(s)</div>' +
                    '</div>' +
                    '<span class="compliance-badge ' + statusClass + '">' +
                        '<i class="fas ' + overallIcon + '"></i> ' +
                        (overallStatus === 'COMPLETED' ? 'Completed' :
                         (overallStatus === 'OVERDUE' ? 'Overdue' :
                         (overallStatus === 'IN_PROGRESS' ? 'In Progress' : 'Pending'))) +
                    '</span>' +
                '</div>' +
                '<div style="height:4px;background:rgba(226,232,240,0.5);border-radius:2px;overflow:hidden;margin-bottom:12px;">' +
                    '<div style="height:100%;width:' + pct + '%;background:var(--primary);border-radius:2px;transition:width 0.3s;"></div>' +
                '</div>' +
                '<div style="display:flex;flex-direction:column;gap:8px;">';

            for (var j = 0; j < subs.length; j++) {
                var s = subs[j];
                var subStatusClass = s.status === 'COMPLETED' ? 'compliance-completed' :
                                    (s.status === 'OVERDUE' ? 'compliance-overdue' :
                                    (s.status === 'IN_PROGRESS' ? 'compliance-in-progress' : 'compliance-pending'));
                var subIcon = s.status === 'COMPLETED' ? 'fa-check-circle' :
                             (s.status === 'OVERDUE' ? 'fa-exclamation-triangle' :
                             (s.status === 'IN_PROGRESS' ? 'fa-spinner fa-pulse' : 'fa-clock'));

                var dueDateText = s.dueDate ? formatDate(s.dueDate) : 'No due date';
                var dueDateWarning = '';
                if (s.dueDate && s.status !== 'COMPLETED') {
                    var diff = s.daysRemaining;
                    if (diff < 0) dueDateWarning = '<span style="color:var(--danger);font-size:10px;"> (Overdue)</span>';
                    else if (diff <= 7) dueDateWarning = '<span style="color:var(--warning);font-size:10px;"> (' + diff + ' days left)</span>';
                }

                html += '<div style="display:flex;justify-content:space-between;align-items:center;padding:8px 12px;background:rgba(226,232,240,0.08);border-radius:8px;border-left:3px solid ' +
                    (s.status === 'COMPLETED' ? 'var(--success)' : s.status === 'OVERDUE' ? 'var(--danger)' : 'var(--primary)') + ';">' +
                    '<div>' +
                        '<div style="font-weight:500;font-size:13px;color:var(--gray-800);">' + escapeHtml(s.complianceName || s.subTemplateName || 'Sub-Compliance') + '</div>' +
                        '<div style="font-size:10px;color:var(--gray-500);margin-top:2px;">Due: ' + dueDateText + dueDateWarning + '</div>' +
                    '</div>' +
                    '<span class="compliance-badge ' + subStatusClass + '" style="font-size:9px;padding:2px 8px;">' +
                        '<i class="fas ' + subIcon + '"></i> ' + (s.status === 'COMPLETED' ? 'Completed' :
                            (s.status === 'OVERDUE' ? 'Overdue' :
                            (s.status === 'IN_PROGRESS' ? 'In Progress' : 'Pending'))) +
                    '</span>' +
                '</div>';
            }

            html += '</div></div>';
        }

        html += '</div>';
        modalBody.innerHTML = html;
    }

    function closeComplianceModal() {
        document.getElementById('complianceModal').style.display = 'none';
        document.body.style.overflow = '';
        currentViewEmployeeId = null;
    }

    // ==================== CLOSE MODALS ON OVERLAY ====================
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeDeleteModal();
    });

    document.getElementById('resetModal').addEventListener('click', function(e) {
        if (e.target === this) closeResetModal();
    });

    document.getElementById('complianceModal').addEventListener('click', function(e) {
        if (e.target === this) closeComplianceModal();
    });

    // ==================== EVENT LISTENERS ====================
    document.getElementById('searchInput').addEventListener('input', function() {
        currentPage = 0;
        loadEmployees();
    });

    document.getElementById('statusFilter').addEventListener('change', function() {
        currentPage = 0;
        loadEmployees();
    });

    document.getElementById('deptFilter').addEventListener('change', function() {
        currentPage = 0;
        loadEmployees();
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

        loadCompanyInfo();
        loadEmployees();
        loadNotifications();
    });
</script>

</body>
</html>