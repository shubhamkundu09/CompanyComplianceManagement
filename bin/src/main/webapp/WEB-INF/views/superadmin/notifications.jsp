<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "Manage Notifications"); %>

<%-- File: superadmin/notifications.jsp --%>
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

        .btn-sm {
            padding: 4px 10px;
            font-size: 11px;
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

        /* ==================== NOTIFICATION LIST ==================== */
        .notification-list-item {
            padding: 16px 20px;
            margin-bottom: 12px;
            border-left: 4px solid var(--primary);
            transition: all 0.2s;
        }

        .notification-list-item:hover {
            background: rgba(255, 255, 255, 0.9);
            border-color: var(--primary-light);
            transform: translateX(4px);
        }

        .notification-list-item .item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
        }

        .notification-list-item .item-header .item-left {
            flex: 1;
            min-width: 0;
        }

        .notification-list-item .item-header .item-left .title {
            font-weight: 600;
            font-size: 15px;
            color: var(--gray-900);
        }

        .notification-list-item .item-header .item-left .message {
            color: var(--gray-500);
            margin-top: 4px;
            line-height: 1.5;
        }

        .notification-list-item .item-header .item-left .meta {
            font-size: 11px;
            color: var(--gray-500);
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .notification-list-item .item-header .item-left .meta .type-badge {
            font-size: 9px;
            padding: 2px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .notification-list-item .item-header .item-left .meta .type-badge.general {
            background: var(--primary-bg);
            color: var(--primary);
        }

        .notification-list-item .item-header .item-left .meta .type-badge.important {
            background: var(--warning-bg);
            color: var(--warning);
        }

        .notification-list-item .item-header .item-left .meta .type-badge.urgent {
            background: var(--danger-bg);
            color: var(--danger);
        }

        .notification-list-item .item-header .actions {
            display: flex;
            gap: 4px;
            flex-shrink: 0;
        }

        /* ==================== EMPTY STATE ==================== */
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
            max-width: 500px;
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

            .page-header { flex-direction: column; align-items: flex-start; }
            .page-header .btn { align-self: stretch; justify-content: center; }

            .notification-list-item .item-header {
                flex-direction: column;
            }
            .notification-list-item .item-header .actions {
                width: 100%;
                justify-content: flex-end;
            }

            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .page-header h1 { font-size: 20px; }
            .notification-dropdown { width: 280px; right: -80px; }
            .notification-list-item .item-header .item-left .meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
            }
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
        <a href="${pageContext.request.contextPath}/super-admin/notifications" class="nav-item active">
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
            <span class="page-title">Notifications</span>
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
            <div>
                <div class="page-subtitle"><i class="fas fa-bell" style="margin-right:6px;"></i>Communication</div>
                <h1>Notifications</h1>
                <div class="page-description">Create and manage notifications for all users</div>
            </div>
            <button onclick="openCreateModal()" class="btn btn-primary">
                <i class="fas fa-plus"></i> Create Notification
            </button>
        </div>

        <!-- ==================== NOTIFICATIONS LIST ==================== -->
        <div id="notificationsList">
            <div style="text-align:center;padding:60px;">
                <div class="spinner"></div>
                <div style="color:var(--gray-500);font-size:13px;margin-top:12px;">Loading notifications...</div>
            </div>
        </div>

    </main>
</div>

<!-- ==================== CREATE MODAL ==================== -->
<div id="createModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Create Notification</div>
                <div class="modal-subtitle">Send a notification to all users</div>
            </div>
            <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="notificationForm" onsubmit="return false;">
                <div style="margin-bottom:16px;">
                    <label class="form-label">Title <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="title" class="form-input" placeholder="Enter notification title" required>
                </div>
                <div style="margin-bottom:16px;">
                    <label class="form-label">Message <span style="color:var(--danger);">*</span></label>
                    <textarea id="message" class="form-input" rows="4" placeholder="Enter notification message" required></textarea>
                </div>
                <div>
                    <label class="form-label">Type</label>
                    <select id="type" class="form-input">
                        <option value="GENERAL">General</option>
                        <option value="IMPORTANT">Important</option>
                        <option value="URGENT">Urgent</option>
                    </select>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="createNotification()" class="btn btn-primary" id="saveBtn">
                <i class="fas fa-paper-plane"></i> Send Notification
            </button>
        </div>
    </div>
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
        var map = {
            'GENERAL': 'general',
            'IMPORTANT': 'important',
            'URGENT': 'urgent'
        };
        return map[type] || 'general';
    }

    function getTypeColor(type) {
        var map = {
            'GENERAL': 'var(--primary)',
            'IMPORTANT': 'var(--warning)',
            'URGENT': 'var(--danger)'
        };
        return map[type] || 'var(--primary)';
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

    // ==================== NOTIFICATIONS DROPDOWN ====================
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
                var count = 0;
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
                    count++;
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

    // ==================== LOAD NOTIFICATIONS ====================
    async function loadNotifications() {
        var data = await api('/api/notifications/active');
        var container = document.getElementById('notificationsList');

        if (data && data.success && data.data && data.data.length > 0) {
            var html = '';
            for (var i = 0; i < data.data.length; i++) {
                var n = data.data[i];
                var typeColor = getTypeColor(n.notificationType);
                var badgeClass = getTypeBadgeClass(n.notificationType);
                var typeLabel = n.notificationType || 'GENERAL';

                html += '<div class="card notification-list-item" style="border-left-color:' + typeColor + ';">' +
                    '<div class="item-header">' +
                    '<div class="item-left">' +
                    '<div class="title">' + escapeHtml(n.title) + '</div>' +
                    '<div class="message">' + escapeHtml(n.message) + '</div>' +
                    '<div class="meta">' +
                    '<span class="type-badge ' + badgeClass + '">' + typeLabel + '</span>' +
                    '<span><i class="far fa-clock"></i> ' + formatTimeAgo(n.createdAt) + '</span>' +
                    '</div>' +
                    '</div>' +
                    '<div class="actions">' +
                    '<button onclick="deleteNotification(' + n.id + ')" class="btn btn-danger btn-sm" title="Delete">' +
                    '<i class="fas fa-trash-alt"></i></button>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
            }
            container.innerHTML = html;
        } else {
            container.innerHTML = '<div class="empty-state">' +
                '<i class="fas fa-bell-slash"></i>' +
                '<h3>No Notifications</h3>' +
                '<p>Create your first notification to keep users informed.</p>' +
                '<button onclick="openCreateModal()" class="btn btn-primary">' +
                '<i class="fas fa-plus"></i> Create Notification' +
                '</button>' +
                '</div>';
        }
    }

    // ==================== LOAD NOTIFICATION COUNT ====================
    async function loadNotificationCount() {
        try {
            var data = await api('/api/notifications/active');
            if (data && data.success && data.data) {
                var count = data.data.length;
                document.getElementById('notifBadge').textContent = count;
                document.getElementById('notifCount').textContent = count;
            }
        } catch(e) {
            console.log('Error loading notification count:', e);
        }
    }

    // ==================== CREATE NOTIFICATION ====================
    function openCreateModal() {
        document.getElementById('createModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        document.getElementById('title').value = '';
        document.getElementById('message').value = '';
        document.getElementById('type').value = 'GENERAL';
        document.getElementById('title').focus();
    }

    function closeModal() {
        document.getElementById('createModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function createNotification() {
        var title = document.getElementById('title').value.trim();
        var message = document.getElementById('message').value.trim();
        var type = document.getElementById('type').value;

        if (!title || !message) {
            toast('Please fill in all required fields', 'error');
            return;
        }

        var btn = document.getElementById('saveBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

        var data = await api('/api/notifications/admin/create?title=' + encodeURIComponent(title) +
                            '&message=' + encodeURIComponent(message) + '&notificationType=' + type, {
            method: 'POST'
        });

        btn.disabled = false;
        btn.innerHTML = originalText;

        if (data && data.success) {
            toast('Notification sent successfully!', 'success');
            closeModal();
            await loadNotifications();
            await loadNotificationCount();
        } else {
            toast(data?.error || 'Failed to create notification', 'error');
        }
    }

    // ==================== DELETE NOTIFICATION ====================
    async function deleteNotification(id) {
        if (!confirm('Are you sure you want to delete this notification?')) return;

        var data = await api('/api/notifications/admin/' + id, { method: 'DELETE' });

        if (data && data.success) {
            toast('Notification deleted successfully', 'success');
            await loadNotifications();
            await loadNotificationCount();
        } else {
            toast(data?.error || 'Failed to delete notification', 'error');
        }
    }

    // ==================== CLOSE MODAL ON OVERLAY CLICK ====================
    document.getElementById('createModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
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

        loadNotifications();
        loadNotificationCount();
    });
</script>

</body>
</html>