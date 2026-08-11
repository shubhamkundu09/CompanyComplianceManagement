<%-- File: superadmin/companies.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<% pageContext.setAttribute("pageTitle", "Companies"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Companies</title>

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
            align-items: flex-end;
            justify-content: space-between;
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

        /* ==================== AVATAR ==================== */
        .avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 12px;
            flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
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
            max-width: 860px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-xl);
            animation: modalSlideIn 0.3s ease;
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

        /* ==================== DROP ZONE ==================== */
        .drop-zone {
            border: 2px dashed rgba(226, 232, 240, 0.6);
            border-radius: var(--radius);
            padding: 24px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s;
        }

        .drop-zone:hover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.04);
        }

        .drop-zone i {
            font-size: 28px;
            color: var(--primary);
            margin-bottom: 8px;
        }

        .drop-zone .drop-title {
            font-size: 13px;
            font-weight: 500;
        }

        .drop-zone .drop-sub {
            font-size: 11px;
            color: var(--gray-500);
            margin-top: 4px;
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
            .col-2 { grid-column: span 1; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .filter-bar .filter-grid .filter-item { min-width: 100%; }
            .filter-bar .filter-grid .filter-item.search-item { flex: 1; min-width: 100%; }
            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .table-header { flex-direction: column; gap: 8px; align-items: flex-start; }
            .table-footer { flex-direction: column; align-items: flex-start; }
            .table-footer .pagination-btns { width: 100%; justify-content: center; }
            .data-table thead th, .data-table tbody td { padding: 8px 10px; font-size: 12px; }
            .notification-dropdown { width: 280px; right: -80px; }
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
        <a href="${pageContext.request.contextPath}/super-admin/companies" class="nav-item active">
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
            <span class="page-title">Companies</span>
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
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/super-admin/profile'">
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
                <div class="page-subtitle"><i class="fas fa-building" style="margin-right:6px;"></i>Management</div>
                <h1>Companies</h1>
            </div>
            <button onclick="openAddModal()" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Company
            </button>
        </div>

        <!-- ==================== FILTER BAR ==================== -->
        <div class="filter-bar">
            <div class="filter-grid">
                <div class="filter-item search-item">
                    <label class="form-label">Search</label>
                    <div class="position-relative">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchInput" class="form-input" placeholder="Company name or email…">
                    </div>
                </div>
                <div class="filter-item">
                    <label class="form-label">Status</label>
                    <select id="statusFilter" class="form-input">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="DEACTIVATED">Deactivated</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Sort By</label>
                    <select id="sortBy" class="form-input">
                        <option value="createdAt">Date Created</option>
                        <option value="name">Name</option>
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
                <span class="table-title"><i class="fas fa-building" style="color:var(--primary);margin-right:8px;"></i>All Companies</span>
                <span class="table-info" id="tableInfo"></span>
            </div>

            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Company</th>
                            <th>Contact</th>
                            <th>Status</th>
                            <th>Employees</th>
                            <th>Subscription</th>
                            <th>Created</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <tr><td colspan="8"><div class="empty-state"><div class="spinner" style="margin:0 auto 8px;"></div>Loading companies…</div></td></tr>
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

<!-- ==================== ADD COMPANY MODAL ==================== -->
<div id="addModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add New Company</div>
                <div class="modal-subtitle">Fill in company and admin details</div>
            </div>
            <button class="modal-close" onclick="closeAddModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <!-- Company Information -->
            <div style="margin-bottom:20px;">
                <div class="modal-section-title">
                    <i class="fas fa-building"></i>Company Information
                </div>
                <div class="grid-2">
                    <div>
                        <label class="form-label">Company Name <span style="color:var(--danger);">*</span></label>
                        <input type="text" id="add_name" class="form-input" placeholder="Acme Corp">
                    </div>
                    <div>
                        <label class="form-label">Company Email <span style="color:var(--danger);">*</span></label>
                        <input type="email" id="add_email" class="form-input" placeholder="contact@company.com">
                    </div>
                    <div>
                        <label class="form-label">Phone</label>
                        <input type="text" id="add_phone" class="form-input" placeholder="9876543210">
                    </div>
                    <div>
                        <label class="form-label">Website</label>
                        <input type="text" id="add_website" class="form-input" placeholder="https://company.com">
                    </div>
                    <div>
                        <label class="form-label">GST Number</label>
                        <input type="text" id="add_gst" class="form-input" placeholder="22AAAAA0000A1Z5" style="text-transform:uppercase;">
                    </div>
                    <div>
                        <label class="form-label">PAN Number</label>
                        <input type="text" id="add_pan" class="form-input" placeholder="ABCDE1234F" style="text-transform:uppercase;">
                    </div>
                    <div class="col-2">
                        <label class="form-label">Address</label>
                        <textarea id="add_address" class="form-input" rows="2" placeholder="Street, Area…"></textarea>
                    </div>
                    <div>
                        <label class="form-label">City</label>
                        <input type="text" id="add_city" class="form-input" placeholder="Mumbai">
                    </div>
                    <div>
                        <label class="form-label">State</label>
                        <input type="text" id="add_state" class="form-input" placeholder="Maharashtra">
                    </div>
                    <div>
                        <label class="form-label">Country</label>
                        <input type="text" id="add_country" class="form-input" placeholder="India">
                    </div>
                    <div>
                        <label class="form-label">Postal Code</label>
                        <input type="text" id="add_postal" class="form-input" placeholder="400001">
                    </div>
                    <div>
                        <label class="form-label">User Limit</label>
                        <input type="number" id="add_limit" class="form-input" value="100" min="1">
                    </div>
                    <div class="col-2">
                        <label class="form-label">Description</label>
                        <textarea id="add_desc" class="form-input" rows="2" placeholder="Brief description…"></textarea>
                    </div>
                </div>
            </div>

            <!-- Document Upload -->
            <div style="margin-bottom:20px;">
                <div class="modal-section-title">
                    <i class="fas fa-paperclip"></i>Company Documents (Optional)
                </div>
                <div class="drop-zone" onclick="document.getElementById('docFiles').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <div class="drop-title">Click to select files</div>
                    <div class="drop-sub">PDF, Word, Excel, Images — max 10 MB each</div>
                </div>
                <input type="file" id="docFiles" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png" style="display:none;" onchange="previewFiles(this)">
                <div id="filePreviewList" style="margin-top:12px;display:flex;flex-direction:column;gap:6px;"></div>
            </div>

            <!-- Admin Account -->
            <div>
                <div class="modal-section-title">
                    <i class="fas fa-user-shield"></i>Company Admin Account
                </div>
                <div class="grid-2">
                    <div>
                        <label class="form-label">First Name <span style="color:var(--danger);">*</span></label>
                        <input type="text" id="add_adminFirst" class="form-input" placeholder="John">
                    </div>
                    <div>
                        <label class="form-label">Last Name <span style="color:var(--danger);">*</span></label>
                        <input type="text" id="add_adminLast" class="form-input" placeholder="Doe">
                    </div>
                    <div class="col-2">
                        <label class="form-label">Admin Email <span style="color:var(--danger);">*</span></label>
                        <input type="email" id="add_adminEmail" class="form-input" placeholder="admin@company.com">
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeAddModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="submitAddCompany()" class="btn btn-primary" id="addSubmitBtn">
                <i class="fas fa-plus"></i> Create Company
            </button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var currentPage = 0;
    var pageSize = 10;
    var pendingFiles = [];

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

    // ==================== COMPANIES ====================
    async function loadCompanies() {
        document.getElementById('tableBody').innerHTML = '<tr><td colspan="8"><div class="empty-state"><div class="spinner"></div>Loading...</div></td></tr>';

        var status = document.getElementById('statusFilter').value;
        var sortBy = document.getElementById('sortBy').value;
        var search = document.getElementById('searchInput').value.trim();

        var url = '/api/super-admin/companies?page=' + currentPage + '&size=' + pageSize + '&sortBy=' + sortBy + '&sortDir=desc';
        if (status) url += '&status=' + status;
        if (search) url += '&search=' + encodeURIComponent(search);

        var data = await api(url);
        if (!data || !data.success) { return; }

        document.getElementById('tableInfo').textContent = data.data.totalElements + ' total';
        document.getElementById('companyCount').textContent = data.data.totalElements;
        renderTable(data.data.content || []);
        renderPagination(data.data);
    }

    function renderTable(companies) {
        var tbody = document.getElementById('tableBody');
        if (!companies.length) {
            tbody.innerHTML = '<tr><td colspan="8"><div class="empty-state"><i class="fas fa-building" style="font-size:36px;opacity:0.3;"></i><br>No companies found</div></td></tr>';
            return;
        }

        var html = '';
        for (var i = 0; i < companies.length; i++) {
            var c = companies[i];
            var isActive = c.status === 'ACTIVE';
            var subExp = c.subscriptionEndDate && new Date(c.subscriptionEndDate) < new Date();
            var pct = c.employeeLimit ? Math.round((c.currentEmployeeCount / c.employeeLimit) * 100) : 0;
            var barColor = pct > 80 ? '#ef4444' : pct > 60 ? '#f59e0b' : '#22c55e';
            var daysLeft = c.subscriptionEndDate ? Math.ceil((new Date(c.subscriptionEndDate) - new Date()) / 86400000) : null;
            var daysColor = daysLeft === null ? '#64748b' : daysLeft > 30 ? '#22c55e' : daysLeft > 7 ? '#f59e0b' : '#ef4444';

            html += '<tr>' +
                '<td style="color:var(--gray-500);font-size:12px;">' + (currentPage * pageSize + i + 1) + '</td>' +
                '<td>' +
                    '<div style="display:flex;align-items:center;gap:10px;">' +
                        '<div class="avatar">' + escapeHtml((c.name || '?')[0]) + '</div>' +
                        '<div>' +
                            '<div style="font-weight:600;font-size:13px;">' + escapeHtml(c.name) + '</div>' +
                            '<div style="font-size:11px;color:var(--gray-500);">' + (c.gstNumber ? 'GST: ' + escapeHtml(c.gstNumber) : c.registrationNumber || '—') + '</div>' +
                        '</div>' +
                    '</div>' +
                '</td>' +
                '<td>' +
                    '<div style="font-size:12px;">' + escapeHtml(c.email) + '</div>' +
                    '<div style="font-size:11px;color:var(--gray-500);">' + (c.phone || '—') + '</div>' +
                '</td>' +
                '<td><span class="badge ' + (isActive ? 'badge-active' : 'badge-inactive') + '"><i class="fas fa-circle" style="font-size:5px;margin-right:4px;"></i>' + (c.status || '—') + '</span></td>' +
                '<td>' +
                    '<div style="font-size:12px;margin-bottom:4px;">' + c.currentEmployeeCount + ' / ' + c.employeeLimit + '</div>' +
                    '<div class="progress-bar"><div class="progress-fill" style="width:' + pct + '%;background:' + barColor + ';"></div></div>' +
                '</td>' +
                '<td>' +
                    '<span class="badge ' + (subExp ? 'badge-inactive' : 'badge-active') + '">' + (subExp ? 'Expired' : 'Active') + '</span>' +
                    (daysLeft !== null ? '<div style="font-size:10px;color:' + daysColor + ';margin-top:3px;">' + daysLeft + ' days left</div>' : '') +
                '</td>' +
                '<td style="font-size:12px;color:var(--gray-500);">' + formatDate(c.createdAt) + '</td>' +
                '<td style="text-align:center;">' +
                    '<div style="display:flex;gap:4px;justify-content:center;">' +
                        '<button onclick="viewCompany(' + c.id + ')" class="btn btn-ghost" style="padding:5px 8px;" title="View"><i class="fas fa-eye" style="font-size:12px;"></i></button>' +
                        '<button onclick="toggleStatus(' + c.id + ',\'' + c.status + '\')" class="btn ' + (isActive ? 'btn-danger' : 'btn-success') + '" style="padding:5px 8px;" title="' + (isActive ? 'Deactivate' : 'Activate') + '">' +
                            '<i class="fas ' + (isActive ? 'fa-ban' : 'fa-check') + '" style="font-size:12px;"></i>' +
                        '</button>' +
                        '<button onclick="deleteCompany(' + c.id + ',\'' + escapeHtml(c.name) + '\')" class="btn btn-danger" style="padding:5px 8px;" title="Delete">' +
                            '<i class="fas fa-trash" style="font-size:12px;"></i>' +
                        '</button>' +
                    '</div>' +
                '</td>' +
            '</tr>';
        }
        tbody.innerHTML = html;
    }

    function renderPagination(pageData) {
        var total = pageData.totalPages;
        var cur = pageData.number;
        document.getElementById('paginationInfo').textContent = 'Showing page ' + (cur + 1) + ' of ' + total + ' (' + pageData.totalElements + ' records)';
        var div = document.getElementById('paginationBtns');
        div.innerHTML = '';

        if (cur > 0) {
            div.innerHTML += '<button class="page-btn" onclick="goPage(' + (cur - 1) + ')"><i class="fas fa-chevron-left" style="font-size:10px;"></i></button>';
        }

        var start = Math.max(0, cur - 2);
        var end = Math.min(total - 1, cur + 2);
        for (var i = start; i <= end; i++) {
            div.innerHTML += '<button class="page-btn ' + (i === cur ? 'active' : '') + '" onclick="goPage(' + i + ')">' + (i + 1) + '</button>';
        }

        if (cur < total - 1) {
            div.innerHTML += '<button class="page-btn" onclick="goPage(' + (cur + 1) + ')"><i class="fas fa-chevron-right" style="font-size:10px;"></i></button>';
        }
    }

    function goPage(p) {
        currentPage = p;
        loadCompanies();
    }

    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('sortBy').value = 'createdAt';
        currentPage = 0;
        loadCompanies();
    }

    function viewCompany(id) {
        window.location.href = contextPath + '/super-admin/companies/' + id + '?id=' + id;
    }

    async function toggleStatus(id, current) {
        var newStatus = current === 'ACTIVE' ? 'DEACTIVATED' : 'ACTIVE';
        var action = newStatus === 'ACTIVE' ? 'activate' : 'deactivate';
        if (!confirm('Are you sure you want to ' + action + ' this company?')) return;

        var data = await api('/api/super-admin/companies/' + id + '/status?status=' + newStatus, { method: 'PATCH' });
        if (data && data.success) {
            toast('Company ' + action + 'd successfully', 'success');
            loadCompanies();
        } else {
            toast((data && data.error) || 'Failed to update status', 'error');
        }
    }

    async function deleteCompany(id, name) {
        if (!confirm('Delete "' + name + '"? This cannot be undone.')) return;

        var data = await api('/api/super-admin/companies/' + id, { method: 'DELETE' });
        if (data && data.success) {
            toast('Company deleted', 'success');
            loadCompanies();
        } else {
            toast((data && data.error) || 'Failed to delete', 'error');
        }
    }

    // ==================== ADD COMPANY MODAL ====================
    function openAddModal() {
        document.getElementById('addModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
        document.body.style.overflow = '';
        clearAddForm();
    }

    function clearAddForm() {
        var ids = ['add_name', 'add_email', 'add_phone', 'add_website', 'add_gst', 'add_pan', 'add_address', 'add_city', 'add_state', 'add_country', 'add_postal', 'add_desc', 'add_adminFirst', 'add_adminLast', 'add_adminEmail'];
        for (var i = 0; i < ids.length; i++) {
            var el = document.getElementById(ids[i]);
            if (el) el.value = '';
        }
        var lim = document.getElementById('add_limit');
        if (lim) lim.value = '100';
        pendingFiles = [];
        document.getElementById('filePreviewList').innerHTML = '';
        document.getElementById('docFiles').value = '';
    }

    function previewFiles(input) {
        pendingFiles = Array.from(input.files);
        var list = document.getElementById('filePreviewList');
        list.innerHTML = '';
        pendingFiles.forEach(function(f, i) {
            var kb = (f.size / 1024).toFixed(0);
            list.innerHTML += '<div style="display:flex;align-items:center;gap:8px;padding:8px;background:rgba(226,232,240,0.3);border-radius:6px;font-size:12px;">' +
                '<i class="fas fa-file-alt" style="color:var(--primary);"></i>' +
                '<span style="flex:1;">' + escapeHtml(f.name) + '</span>' +
                '<span style="color:var(--gray-500);">' + kb + ' KB</span>' +
                '<button onclick="removeFile(' + i + ')" type="button" style="background:none;border:none;color:var(--danger);cursor:pointer;">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>';
        });
    }

    function removeFile(index) {
        pendingFiles.splice(index, 1);
        var list = document.getElementById('filePreviewList');
        list.innerHTML = '';
        pendingFiles.forEach(function(f, i) {
            var kb = (f.size / 1024).toFixed(0);
            list.innerHTML += '<div style="display:flex;align-items:center;gap:8px;padding:8px;background:rgba(226,232,240,0.3);border-radius:6px;font-size:12px;">' +
                '<i class="fas fa-file-alt" style="color:var(--primary);"></i>' +
                '<span style="flex:1;">' + escapeHtml(f.name) + '</span>' +
                '<span style="color:var(--gray-500);">' + kb + ' KB</span>' +
                '<button onclick="removeFile(' + i + ')" type="button" style="background:none;border:none;color:var(--danger);cursor:pointer;">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>';
        });
    }

    async function submitAddCompany() {
        var name = document.getElementById('add_name').value.trim();
        var email = document.getElementById('add_email').value.trim();
        var adminFirst = document.getElementById('add_adminFirst').value.trim();
        var adminLast = document.getElementById('add_adminLast').value.trim();
        var adminEmail = document.getElementById('add_adminEmail').value.trim();

        if (!name || !email || !adminFirst || !adminLast || !adminEmail) {
            toast('Please fill in all required fields', 'error');
            return;
        }

        var btn = document.getElementById('addSubmitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating…';

        var payload = {
            name: name,
            email: email,
            phone: document.getElementById('add_phone').value.trim() || null,
            website: document.getElementById('add_website').value.trim() || null,
            gstNumber: document.getElementById('add_gst').value.trim().toUpperCase() || null,
            panNumber: document.getElementById('add_pan').value.trim().toUpperCase() || null,
            address: document.getElementById('add_address').value.trim() || null,
            city: document.getElementById('add_city').value.trim() || null,
            state: document.getElementById('add_state').value.trim() || null,
            country: document.getElementById('add_country').value.trim() || null,
            postalCode: document.getElementById('add_postal').value.trim() || null,
            employeeLimit: parseInt(document.getElementById('add_limit').value) || 100,
            description: document.getElementById('add_desc').value.trim() || null,
            adminFirstName: adminFirst,
            adminLastName: adminLast,
            adminEmail: adminEmail
        };

        var data = await api('/api/super-admin/companies', {
            method: 'POST',
            body: JSON.stringify(payload)
        });

        if (data && data.success) {
            var companyId = data.data.id;

            if (pendingFiles.length > 0) {
                var formData = new FormData();
                for (var i = 0; i < pendingFiles.length; i++) {
                    formData.append('files', pendingFiles[i]);
                }
                var token = localStorage.getItem('accessToken');
                try {
                    await fetch(contextPath + '/api/super-admin/companies/' + companyId + '/documents', {
                        method: 'POST',
                        headers: { 'Authorization': 'Bearer ' + token },
                        body: formData
                    });
                } catch (e) {
                    console.error('Document upload failed:', e);
                }
                pendingFiles = [];
            }

            toast('Company created! Credentials sent to admin email.', 'success');
            closeAddModal();
            loadCompanies();
        } else {
            toast((data && (data.error || data.message)) || 'Failed to create company', 'error');
        }

        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-plus"></i> Create Company';
    }

    // ==================== CLOSE MODAL ON OVERLAY CLICK ====================
    document.getElementById('addModal').addEventListener('click', function(e) {
        if (e.target === this) closeAddModal();
    });

    // ==================== EVENT LISTENERS ====================
    document.getElementById('searchInput').addEventListener('input', function() {
        currentPage = 0;
        loadCompanies();
    });

    document.getElementById('statusFilter').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
    });

    document.getElementById('sortBy').addEventListener('change', function() {
        currentPage = 0;
        loadCompanies();
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

        loadCompanies();
        loadNotifications();
    });
</script>

</body>
</html>