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

        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            -webkit-text-size-adjust: 100%;
            overflow-x: hidden;
            max-width: 100%;
            width: 100%;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
            overflow-x: hidden;
            max-width: 100%;
            width: 100%;
            -webkit-tap-highlight-color: transparent;
        }

        img {
            max-width: 100%;
            height: auto;
        }

        /* ==================== LOGO BACKGROUND ==================== */
        .logo-bg {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: min(450px, 80vw);
            height: min(800px, 80vh);
            opacity: 0.30;
            pointer-events: none;
            z-index: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .logo-bg img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        /* ==================== APP LAYOUT ==================== */
        .app-wrapper {
            display: block;
            min-height: 100vh;
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 100%;
            overflow-x: hidden;
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
            padding: 32px 36px;
            width: calc(100% - 260px);
            max-width: calc(100% - 260px);
            min-width: 0;
            min-height: calc(100vh - 64px);
            position: relative;
            z-index: 1;
            overflow-x: hidden;
            box-sizing: border-box;
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
            max-width: 100%;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
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
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 16px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
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
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        /* ==================== FCM METRICS GRID & CARDS ==================== */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 24px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .metric-card {
            background: #ffffff;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            box-shadow: var(--shadow-sm);
            transition: all 0.25s ease;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
            overflow: hidden;
        }

        .metric-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }

        .metric-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .metric-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--gray-500);
        }

        .metric-icon-box {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .metric-icon-primary { background: var(--primary-bg); color: var(--primary); }
        .metric-icon-success { background: var(--success-bg); color: var(--success); }
        .metric-icon-info { background: var(--info-bg); color: var(--info); }
        .metric-icon-warning { background: var(--warning-bg); color: var(--warning); }
        .metric-icon-danger { background: var(--danger-bg); color: var(--danger); }

        .metric-value-row {
            display: flex;
            align-items: baseline;
            gap: 8px;
            margin-bottom: 6px;
            flex-wrap: wrap;
        }

        .metric-value {
            font-size: 24px;
            font-weight: 800;
            color: var(--gray-900);
            letter-spacing: -0.5px;
            line-height: 1.2;
        }

        .metric-subtext {
            font-size: 12px;
            color: var(--gray-600);
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }

        .metric-footer {
            margin-top: 14px;
            padding-top: 10px;
            border-top: 1px solid var(--gray-100);
            font-size: 11px;
            color: var(--gray-500);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 6px;
        }

        /* Pulsing & Status Badges */
        .badge-pulse {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            background: #ede9fe;
            color: #6d28d9;
            border: 1px solid #ddd6fe;
        }

        .badge-pulse::before {
            content: '';
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #7c3aed;
            box-shadow: 0 0 0 0 rgba(124, 58, 237, 0.7);
            animation: pulseDot 1.8s infinite;
        }

        @keyframes pulseDot {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(124, 58, 237, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 7px rgba(124, 58, 237, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(124, 58, 237, 0); }
        }

        .badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        .bg-success-light { background: var(--success-bg); color: #047857; }
        .bg-danger-light { background: var(--danger-bg); color: #b91c1c; }
        .bg-info-light { background: var(--info-bg); color: #1d4ed8; }
        .bg-warning-light { background: var(--warning-bg); color: #b45309; }
        .bg-gray-light { background: var(--gray-100); color: var(--gray-700); }

        /* ==================== SLOTS TIMELINE ==================== */
        .slots-timeline-container {
            background: #ffffff;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 22px 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
            box-sizing: border-box;
        }

        .slots-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 10px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .slots-timeline {
            display: flex;
            gap: 14px;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            padding: 6px 2px 14px;
            scrollbar-width: thin;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .slot-card {
            flex: 0 0 170px;
            border: 1.5px solid var(--gray-200);
            border-radius: 12px;
            padding: 14px;
            background: var(--gray-50);
            transition: all 0.2s;
            position: relative;
        }

        .slot-card.completed {
            background: #f0fdf4;
            border-color: #86efac;
        }

        .slot-card.next {
            background: #f5f3ff;
            border-color: #a78bfa;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.15);
        }

        .slot-card.pending {
            opacity: 0.85;
            background: #ffffff;
            border-style: dashed;
        }

        .slot-card-num {
            font-size: 11px;
            font-weight: 700;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .slot-card-time {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 6px;
        }

        .slot-card-status {
            font-size: 11px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* ==================== AUDIT TABLE ==================== */
        .audit-card {
            background: #ffffff;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 28px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
            box-sizing: border-box;
        }

        .audit-table-wrapper {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            margin-top: 16px;
            border: 1px solid var(--gray-200);
            border-radius: 10px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .audit-table {
            width: 100%;
            min-width: 760px;
            border-collapse: collapse;
            font-size: 13px;
            text-align: left;
        }

        .audit-table th {
            background: var(--gray-50);
            color: var(--gray-600);
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 16px;
            border-bottom: 1px solid var(--gray-200);
            white-space: nowrap;
        }

        .audit-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--gray-100);
            color: var(--gray-700);
            vertical-align: middle;
        }

        .audit-table tr:last-child td {
            border-bottom: none;
        }

        .audit-table tr:hover td {
            background: rgba(248, 250, 252, 0.8);
        }

        .log-title {
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 2px;
            max-width: 320px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .log-body {
            font-size: 12px;
            color: var(--gray-500);
            max-width: 320px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
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

        /* ==================== SIDEBAR BACKDROP ==================== */
        .sidebar-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            z-index: 45;
            transition: opacity 0.3s ease;
        }

        .sidebar-backdrop.active {
            display: block;
        }

        /* ==================== PAGE HEADER ACTIONS ==================== */
        .page-header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            max-width: 100%;
        }

        /* ==================== SCHEDULE CONFIG CARD & GRID ==================== */
        .schedule-card {
            background: #fff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow-sm);
            padding: 24px;
            margin-bottom: 28px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow: hidden;
            box-sizing: border-box;
        }

        .schedule-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr)) auto;
            gap: 16px;
            align-items: end;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .schedule-form-grid .form-submit-col {
            min-width: 180px;
        }

        /* ==================== DEVICE FLEET MODAL & TABLE ==================== */
        .modal-box.modal-lg {
            max-width: 940px;
            width: 100%;
        }

        .device-table-wrapper {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border: 1px solid var(--gray-200);
            border-radius: 10px;
            max-height: 480px;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .device-table {
            width: 100%;
            min-width: 720px;
            border-collapse: collapse;
            font-size: 13px;
            text-align: left;
        }

        .device-table th {
            background: var(--gray-50);
            color: var(--gray-600);
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 14px;
            border-bottom: 1px solid var(--gray-200);
            white-space: nowrap;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        .device-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--gray-100);
            color: var(--gray-700);
            vertical-align: middle;
        }

        .device-table tr:hover td {
            background: rgba(248, 250, 252, 0.85);
        }

        .mobile-scroll-hint {
            display: none;
            font-size: 11px;
            color: var(--gray-500);
            padding: 6px 10px;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: 6px;
            margin-top: 8px;
            align-items: center;
            gap: 6px;
        }

        /* ==================== RESPONSIVE BREAKPOINTS ==================== */
        @media (max-width: 1560px) {
            .metrics-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 1280px) {
            .schedule-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
            }
            .schedule-form-grid .form-submit-col {
                grid-column: span 2;
                min-width: 0;
            }
        }

        @media (max-width: 1200px) {
            .page-header {
                flex-direction: column;
                align-items: stretch;
                gap: 16px;
            }
            .page-header-actions {
                width: 100%;
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }
        }

        @media (max-width: 1024px) {
            .header {
                left: 0;
                padding: 0 16px;
                width: 100%;
                max-width: 100%;
            }
            .header-left .menu-toggle {
                display: flex;
            }
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.open {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
                padding: 24px 16px;
            }
            .logo-bg {
                display: none;
            }
            .metrics-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
            }
        }

        @media (max-width: 768px) {
            .header-user .user-info {
                display: none;
            }
            .notification-dropdown {
                width: min(340px, calc(100vw - 24px));
                right: 0;
            }
            .mobile-scroll-hint {
                display: flex;
            }
            .page-header-actions {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 8px;
                width: 100%;
            }
            .page-header-actions .btn {
                width: 100%;
                justify-content: center;
                text-align: center;
                padding: 10px 8px;
                font-size: 12px;
                white-space: normal;
            }
            .modal-overlay {
                padding: 10px;
            }
            .modal-box {
                max-width: 100%;
                margin: 0;
                max-height: 94vh;
                border-radius: var(--radius-lg);
            }
            .modal-body {
                padding: 14px;
            }
            .modal-header {
                padding: 14px;
            }
            .modal-footer {
                padding: 12px 14px;
                flex-wrap: wrap;
                gap: 8px;
            }
            .modal-footer .btn {
                flex: 1;
                justify-content: center;
            }
        }

        @media (max-width: 640px) {
            .main-content {
                padding: 16px 10px;
            }
            .page-header h1 {
                font-size: 20px;
            }
            .metrics-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            .metric-card {
                padding: 16px 14px;
            }
            .audit-card {
                padding: 16px 12px;
            }
            .slots-timeline-container {
                padding: 16px 12px;
            }
            .schedule-card {
                padding: 16px 14px !important;
            }
            .schedule-form-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            .schedule-form-grid .form-submit-col {
                grid-column: span 1;
            }
            .audit-header-row {
                flex-direction: column !important;
                align-items: stretch !important;
                gap: 12px !important;
            }
            .audit-filter-controls {
                width: 100% !important;
            }
            .audit-filter-controls .search-input-wrapper {
                flex: 1;
                width: 100% !important;
            }
            .slot-card {
                flex: 0 0 145px;
                padding: 12px;
            }
            #toast-container {
                bottom: 12px;
                right: 12px;
                left: 12px;
            }
            .toast {
                min-width: unset;
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .page-header h1 {
                font-size: 18px;
            }
            .page-subtitle {
                font-size: 11px;
            }
            .header-left .page-title {
                font-size: 14px;
            }
            .page-header-actions {
                grid-template-columns: 1fr;
            }
            .metric-value {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>

<!-- ==================== SIDEBAR BACKDROP ==================== -->
<div class="sidebar-backdrop" id="sidebarBackdrop" onclick="toggleSidebar()"></div>

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

        <div class="sidebar-label">Push Settings</div>
        <a href="${baseUrl}/super-admin/notifications" class="nav-item active">
            <i class="fas fa-mobile-alt"></i> FCM Push Settings
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
            <span class="page-title">FCM Push Settings</span>
        </div>
        <div class="header-right">

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

        <!-- Page Header -->
        <div class="page-header">
            <div>
                <div class="page-subtitle"><i class="fas fa-satellite-dish" style="margin-right:6px;"></i>Firebase Cloud Messaging Telemetry</div>
                <h1>FCM Push Notification Hub</h1>
                <div class="page-description">Real-time FCM delivery metrics, physical phone drawer dispatch schedules, and automated alert logs</div>
            </div>
            <div class="page-header-actions">
                <button class="btn btn-ghost" onclick="refreshDashboardMetrics()" id="refreshBtn" title="Refresh Telemetry">
                    <i class="fas fa-sync-alt" id="refreshSpinner"></i> Refresh Data
                </button>
                <button class="btn btn-ghost" onclick="openDeviceFleetModal()" title="View and manage registered physical devices">
                    <i class="fas fa-mobile-screen"></i> Manage Fleet (<span id="btnDeviceCount">0</span>)
                </button>
                <button class="btn btn-warning" onclick="triggerDueRemindersNow()" id="btnTriggerNow" style="font-weight:600;background:#f59e0b;border-color:#d97706;color:#ffffff;" title="Instantly evaluate and send due/overdue compliance reminders to all companies and mobile devices right now">
                    <i class="fas fa-bell"></i> Trigger Reminders Now
                </button>
                <button class="btn btn-primary" onclick="openTestPushModal()">
                    <i class="fas fa-paper-plane"></i> Send Test FCM Push
                </button>
                <button class="btn btn-danger" onclick="openLogoutAllModal()" id="btnForceLogoutAll" style="font-weight:600;" title="Instantly revoke all device tokens in DB, push force logout to all phones, and log out SuperAdmin">
                    <i class="fas fa-power-off"></i> Force Logout All Devices
                </button>
            </div>
        </div>

        <!-- Architectural Notification Banner -->
        <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;padding:14px 18px;margin-bottom:24px;color:#1e40af;font-size:13px;line-height:1.5;display:flex;align-items:flex-start;gap:12px;width:100%;max-width:100%;min-width:0;box-sizing:border-box;word-break:break-word;overflow-wrap:anywhere;">
            <i class="fas fa-info-circle" style="font-size:18px;color:#2563eb;margin-top:2px;flex-shrink:0;"></i>
            <div style="flex:1;min-width:0;">
                <strong style="font-weight:700;color:#1e3a8a;">Backend Push Delivery Architecture:</strong>
                This system controls real <strong>Firebase Cloud Messaging (FCM)</strong> push alerts delivered directly to the physical <strong>Android &amp; iOS phone notification drawers/lock screens</strong> for upcoming compliance due dates.
                <br><span style="color:#1d4ed8;font-weight:500;">✓ Dispatches multicast FCM push batches to user physical devices at configured daily slots.</span>
                <br><span style="color:#059669;font-weight:600;">✓ In-app announcements have been retired — all notifications are delivered straight to device notification drawers.</span>
            </div>
        </div>

        <!-- Top KPI Metrics Grid (5 Cards) -->
        <div class="metrics-grid">
            <!-- Card 1: Next Scheduled Push Run -->
            <div class="metric-card">
                <div class="metric-top">
                    <span class="metric-label">Next Scheduled Run</span>
                    <div class="metric-icon-box metric-icon-primary">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div>
                    <div class="metric-value-row">
                        <div class="metric-value" id="metricNextRun" style="font-size:20px;">Loading...</div>
                    </div>
                    <div class="metric-subtext">
                        <span id="metricCountdown" class="badge-pulse">Calculating...</span>
                    </div>
                </div>
                <div class="metric-footer">
                    <span>Cadence: <strong id="metricIntervalDesc" style="color:var(--gray-700);">--</strong></span>
                    <span id="metricStatusIndicator" class="badge-pill bg-success-light"><i class="fas fa-circle" style="font-size:7px;"></i> Active</span>
                </div>
            </div>

            <!-- Card 2: Today's Delivery Stats -->
            <div class="metric-card">
                <div class="metric-top">
                    <span class="metric-label">Today's Deliveries</span>
                    <div class="metric-icon-box metric-icon-success">
                        <i class="fas fa-paper-plane"></i>
                    </div>
                </div>
                <div>
                    <div class="metric-value-row">
                        <div class="metric-value" id="metricTodaySuccess">0</div>
                        <span style="font-size:13px;color:var(--gray-500);font-weight:500;">Delivered</span>
                    </div>
                    <div class="metric-subtext">
                        <span id="metricTodayRate" class="badge-pill bg-success-light">100% Rate</span>
                        <span style="color:var(--gray-500);font-size:12px;">(<span id="metricTodayPushes">0</span> batches)</span>
                    </div>
                </div>
                <div class="metric-footer">
                    <span>Failures: <strong id="metricTodayFailures" style="color:var(--danger);">0</strong></span>
                    <span>Recipients: <strong id="metricTodayRecipients" style="color:var(--gray-800);">0</strong></span>
                </div>
            </div>

            <!-- Card 3: Weekly Delivery Stats -->
            <div class="metric-card">
                <div class="metric-top">
                    <span class="metric-label">7-Day Weekly Deliveries</span>
                    <div class="metric-icon-box metric-icon-info">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
                <div>
                    <div class="metric-value-row">
                        <div class="metric-value" id="metricWeekSuccess">0</div>
                        <span style="font-size:13px;color:var(--gray-500);font-weight:500;">Delivered</span>
                    </div>
                    <div class="metric-subtext">
                        <span id="metricWeekRate" class="badge-pill bg-info-light">100% Rate</span>
                        <span style="color:var(--gray-500);font-size:12px;">(<span id="metricWeekPushes">0</span> batches)</span>
                    </div>
                </div>
                <div class="metric-footer">
                    <span>Failures: <strong id="metricWeekFailures" style="color:var(--danger);">0</strong></span>
                    <span>Recipients: <strong id="metricWeekRecipients" style="color:var(--gray-800);">0</strong></span>
                </div>
            </div>

            <!-- Card 4: Registered Device Fleet -->
            <div class="metric-card">
                <div class="metric-top">
                    <span class="metric-label">Device Token Fleet</span>
                    <div class="metric-icon-box metric-icon-warning">
                        <i class="fas fa-mobile-screen-button"></i>
                    </div>
                </div>
                <div>
                    <div class="metric-value-row">
                        <div class="metric-value" id="metricTotalDevices">0</div>
                        <span style="font-size:13px;color:var(--gray-500);font-weight:500;">Physical Devices</span>
                    </div>
                    <div class="metric-subtext">
                        <span class="badge-pill bg-success-light"><i class="fab fa-android"></i> <span id="metricAndroidCount">0</span> Android</span>
                        <span class="badge-pill bg-gray-light"><i class="fab fa-apple"></i> <span id="metricIosCount">0</span> iOS</span>
                    </div>
                </div>
                <div class="metric-footer" style="flex-direction:column;align-items:stretch;gap:10px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <span>Active App Users:</span>
                        <strong id="metricActiveUsers" style="color:var(--primary);font-weight:700;">0</strong>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px;">
                        <button class="btn btn-ghost btn-sm" onclick="openDeviceFleetModal()" style="justify-content:center;padding:6px 8px;font-size:11px;">
                            <i class="fas fa-list-check"></i> Manage Fleet
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="openLogoutAllModal()" style="justify-content:center;padding:6px 8px;font-size:11px;">
                            <i class="fas fa-power-off"></i> Logout All
                        </button>
                    </div>
                </div>
            </div>

            <!-- Card 5: All-Time Stats -->
            <div class="metric-card">
                <div class="metric-top">
                    <span class="metric-label">All-Time FCM Pushes</span>
                    <div class="metric-icon-box" style="background:#f1f5f9;color:var(--gray-700);">
                        <i class="fas fa-shield-halved"></i>
                    </div>
                </div>
                <div>
                    <div class="metric-value-row">
                        <div class="metric-value" id="metricTotalSuccess">0</div>
                        <span style="font-size:13px;color:var(--gray-500);font-weight:500;">Delivered</span>
                    </div>
                    <div class="metric-subtext">
                        <span class="badge-pill bg-info-light"><i class="fas fa-check-double"></i> Multicast Verified</span>
                    </div>
                </div>
                <div class="metric-footer">
                    <span>All-Time Failures: <strong id="metricTotalFailures" style="color:var(--danger);">0</strong></span>
                    <span>Health: <strong style="color:var(--success);">Optimal</strong></span>
                </div>
            </div>
        </div>

        <!-- Daily Slot Progression Timeline Card -->
        <div class="slots-timeline-container">
            <div class="slots-header">
                <div>
                    <h3 style="font-size:16px;font-weight:700;color:var(--gray-900);display:flex;align-items:center;gap:8px;">
                        <i class="fas fa-calendar-day" style="color:var(--primary);"></i>
                        Today's Daily Delivery Slot Progression
                    </h3>
                    <p style="font-size:12px;color:var(--gray-500);margin-top:2px;">Visual sequence of automated FCM push batches scheduled across today's active window (Asia/Kolkata)</p>
                </div>
                <div>
                    <span id="slotsProgressBadge" class="badge-pill bg-info-light" style="font-size:12px;padding:5px 12px;">
                        <i class="fas fa-tasks"></i> 0 / 3 Slots Executed Today
                    </span>
                </div>
            </div>

            <div class="slots-timeline" id="slotsTimelineList">
                <div style="padding:20px;text-align:center;color:var(--gray-500);width:100%;">
                    <i class="fas fa-spinner fa-spin"></i> Calculating daily slots...
                </div>
            </div>
            <div class="mobile-scroll-hint">
                <i class="fas fa-arrows-left-right"></i> Scroll timeline horizontally to view all today's slots
            </div>
        </div>

        <!-- Schedule Settings Form Card -->
        <div class="card schedule-card" style="background:#fff;border-radius:var(--radius-lg);border:1px solid var(--gray-200);box-shadow:var(--shadow-sm);margin-bottom:28px;">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;margin-bottom:20px;border-bottom:1px solid var(--gray-100);padding-bottom:16px;">
                <div>
                    <div style="display:flex;align-items:center;gap:10px;">
                        <div style="width:38px;height:38px;border-radius:10px;background:var(--primary-bg);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:18px;">
                            <i class="fas fa-sliders"></i>
                        </div>
                        <div>
                            <h2 style="font-size:17px;font-weight:700;color:var(--gray-900);">Compliance Due-Reminder Push Schedule Settings</h2>
                            <p style="font-size:13px;color:var(--gray-500);margin-top:2px;">Target Event: <strong>COMPLIANCE_DUE_SOON</strong> (FCM Push to Assigned Employees &amp; Company Admins)</p>
                        </div>
                    </div>
                </div>
                <div style="display:flex;align-items:center;gap:12px;">
                    <span id="scheduleStatusBadge" class="badge-pill bg-success-light" style="padding:6px 14px;border-radius:20px;font-size:12px;font-weight:600;">
                        <i class="fas fa-circle" style="font-size:8px;margin-right:6px;"></i>Active
                    </span>
                </div>
            </div>

            <form id="scheduleConfigForm" onsubmit="saveScheduleConfig(event)" class="schedule-form-grid">
                <div>
                    <label class="form-label" style="font-weight:600;font-size:13px;margin-bottom:6px;display:block;">FCM Push Status</label>
                    <select id="scheduleEnabled" class="form-input" style="width:100%;height:42px;border-radius:8px;border:1px solid var(--gray-300);padding:0 12px;font-size:14px;">
                        <option value="true">Enabled (Active)</option>
                        <option value="false">Disabled (Paused)</option>
                    </select>
                </div>

                <div>
                    <label class="form-label" style="font-weight:600;font-size:13px;margin-bottom:6px;display:block;">FCM Frequency (Per Day)</label>
                    <select id="scheduleTimesPerDay" class="form-input" style="width:100%;height:42px;border-radius:8px;border:1px solid var(--gray-300);padding:0 12px;font-size:14px;" onchange="updateIntervalPreview()">
                        <option value="1">1 time/day</option>
                        <option value="2">2 times/day</option>
                        <option value="3" selected>3 times/day (Default)</option>
                        <option value="5">5 times/day</option>
                        <option value="10">10 times/day</option>
                        <option value="15">15 times/day</option>
                        <option value="20">20 times/day (Max)</option>
                    </select>
                </div>

                <div>
                    <label class="form-label" style="font-weight:600;font-size:13px;margin-bottom:6px;display:block;">Window Start Hour (IST)</label>
                    <select id="scheduleStartHour" class="form-input" style="width:100%;height:42px;border-radius:8px;border:1px solid var(--gray-300);padding:0 12px;font-size:14px;" onchange="updateIntervalPreview()">
                    </select>
                </div>

                <div>
                    <label class="form-label" style="font-weight:600;font-size:13px;margin-bottom:6px;display:block;">Window End Hour (IST)</label>
                    <select id="scheduleEndHour" class="form-input" style="width:100%;height:42px;border-radius:8px;border:1px solid var(--gray-300);padding:0 12px;font-size:14px;" onchange="updateIntervalPreview()">
                    </select>
                </div>

                <div class="form-submit-col">
                    <button type="submit" class="btn btn-primary" id="saveScheduleBtn" style="width:100%;height:42px;display:flex;align-items:center;justify-content:center;gap:8px;font-weight:600;">
                        <i class="fas fa-save"></i> Save FCM Frequency
                    </button>
                </div>
            </form>

            <div style="margin-top:16px;background:var(--gray-50);border-radius:8px;padding:12px 16px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;font-size:13px;color:var(--gray-600);">
                <div id="intervalPreviewText">
                    <i class="fas fa-info-circle" style="color:var(--primary);margin-right:6px;"></i>
                    Calculating FCM distribution slots...
                </div>
                <div style="display:flex;gap:18px;align-items:center;flex-wrap:wrap;">
                    <span><strong style="color:var(--gray-800);">FCM Sends Today:</strong> <span id="sentTodayDisplay" style="color:var(--primary);font-weight:600;">0</span></span>
                    <span><strong style="color:var(--gray-800);">Last Slot Delivered:</strong> <span id="lastSentDisplay" style="color:var(--gray-700);">Never</span></span>
                </div>
            </div>
        </div>

        <!-- Recent Push Delivery Audit Logs Card -->
        <div class="audit-card">
            <div class="audit-header-row" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;margin-bottom:16px;">
                <div>
                    <h3 style="font-size:16px;font-weight:700;color:var(--gray-900);display:flex;align-items:center;gap:8px;">
                        <i class="fas fa-clipboard-list" style="color:var(--primary);"></i>
                        Recent FCM Push Delivery Audit Logs
                    </h3>
                    <p style="font-size:12px;color:var(--gray-500);margin-top:2px;">Real-time audit log of outgoing multicast push notifications, recipient counts, and delivery confirmations</p>
                </div>
                <div class="audit-filter-controls" style="display:flex;gap:10px;align-items:center;">
                    <div class="search-input-wrapper" style="position:relative;width:240px;">
                        <input type="text" id="logSearchInput" class="form-input" placeholder="Search logs (title, status)..." oninput="filterAuditLogs()" style="height:36px;padding-left:32px;font-size:12px;">
                        <i class="fas fa-search" style="position:absolute;left:10px;top:11px;color:var(--gray-400);font-size:12px;"></i>
                    </div>
                    <button class="btn btn-ghost btn-sm" onclick="loadDashboardMetrics()" title="Refresh Logs">
                        <i class="fas fa-redo"></i>
                    </button>
                </div>
            </div>

            <div class="audit-table-wrapper">
                <table class="audit-table">
                    <thead>
                        <tr>
                            <th>Timestamp (IST)</th>
                            <th>Event Type</th>
                            <th>Notification Content</th>
                            <th style="text-align:center;">Recipients</th>
                            <th style="text-align:center;">Result (✓ / ✗)</th>
                            <th style="text-align:center;">Status</th>
                            <th style="text-align:center;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="auditLogTableBody">
                        <tr>
                            <td colspan="7" style="text-align:center;padding:36px;color:var(--gray-500);">
                                <i class="fas fa-spinner fa-spin" style="font-size:24px;margin-bottom:8px;display:block;"></i>
                                Loading push delivery telemetry...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="mobile-scroll-hint">
                <i class="fas fa-arrows-left-right"></i> Swipe table horizontally to view all columns
            </div>
        </div>

    </main>
</div>

<!-- ==================== TEST PUSH MODAL ==================== -->
<div class="modal-overlay" id="testPushModal">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-paper-plane" style="color:var(--primary);margin-right:8px;"></i>Dispatch Test FCM Push</div>
                <div class="modal-subtitle">Send an instant test push alert to verify phone drawer notifications</div>
            </div>
            <button class="modal-close" onclick="closeTestPushModal()">&times;</button>
        </div>
        <form onsubmit="submitTestPush(event)">
            <div class="modal-body">
                <div style="background:var(--primary-bg);border:1px solid #c7d2fe;border-radius:8px;padding:12px;margin-bottom:16px;color:var(--primary-dark);font-size:12px;">
                    <i class="fas fa-info-circle" style="margin-right:6px;"></i>
                    This test will be delivered directly to the physical <strong>Android &amp; iOS devices</strong> registered to your SuperAdmin account.
                </div>

                <div style="margin-bottom:14px;">
                    <label class="form-label">Target Audience</label>
                    <select id="testPushTarget" class="form-select">
                        <option value="ALL" selected>👥 All Users & Registered Devices (Broadcast to Company Admins & Employees)</option>
                        <option value="COMPANY_ADMIN">🏢 Company Admins Only</option>
                        <option value="EMPLOYEE">👷 Employees Only</option>
                        <option value="SUPER_ADMIN">🛡️ SuperAdmin Only (Self Test)</option>
                    </select>
                </div>

                <div style="margin-bottom:14px;">
                    <label class="form-label">Notification Title</label>
                    <input type="text" id="testPushTitle" class="form-input" value="FCM Push Delivery Test" required maxlength="100">
                </div>

                <div style="margin-bottom:14px;">
                    <label class="form-label">Notification Body Message</label>
                    <textarea id="testPushBody" class="form-input" rows="3" required maxlength="300">Test push notification dispatched directly from SuperAdmin FCM Settings dashboard to verify physical device connectivity.</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeTestPushModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="submitTestPushBtn">
                    <i class="fas fa-paper-plane"></i> Send Test Push
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ==================== LOG DETAILS MODAL ==================== -->
<div class="modal-overlay" id="logDetailsModal">
    <div class="modal-box" style="max-width:560px;">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-circle-info" style="color:var(--primary);margin-right:8px;"></i>Push Delivery Log Details</div>
                <div class="modal-subtitle" id="logModalTraceId">Trace ID: --</div>
            </div>
            <button class="modal-close" onclick="closeLogDetailsModal()">&times;</button>
        </div>
        <div class="modal-body" id="logModalContent" style="font-size:13px;line-height:1.6;">
            <!-- Rendered by JS -->
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary" onclick="closeLogDetailsModal()">Close</button>
        </div>
    </div>
</div>

<!-- ==================== DEVICE FLEET MODAL ==================== -->
<div class="modal-overlay" id="deviceFleetModal">
    <div class="modal-box modal-lg">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-mobile-screen" style="color:var(--primary);margin-right:8px;"></i>Registered Device Token Fleet (<span id="fleetModalCount">0</span>)</div>
                <div class="modal-subtitle">All active mobile &amp; web devices authorized in database for FCM push delivery</div>
            </div>
            <button class="modal-close" onclick="closeDeviceFleetModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;margin-bottom:14px;">
                <div style="flex:1;min-width:220px;position:relative;">
                    <input type="text" id="deviceSearchInput" class="form-input" placeholder="Search devices by user, company, platform..." oninput="filterDeviceList()" style="height:38px;padding-left:34px;font-size:13px;">
                    <i class="fas fa-search" style="position:absolute;left:12px;top:12px;color:var(--gray-400);font-size:13px;"></i>
                </div>
                <div style="display:flex;gap:8px;flex-wrap:wrap;">
                    <button class="btn btn-ghost btn-sm" onclick="loadRegisteredDevices()" title="Refresh device list">
                        <i class="fas fa-sync-alt" id="deviceRefreshSpinner"></i> Refresh List
                    </button>
                    <button class="btn btn-danger btn-sm" onclick="openLogoutAllModal()" title="Revoke all device tokens system-wide">
                        <i class="fas fa-power-off"></i> Logout All Devices
                    </button>
                </div>
            </div>

            <div class="device-table-wrapper">
                <table class="device-table">
                    <thead>
                        <tr>
                            <th>User &amp; Role</th>
                            <th>Company</th>
                            <th>Platform &amp; Model</th>
                            <th>App Ver</th>
                            <th>Last Active</th>
                            <th>Masked Token</th>
                            <th style="text-align:center;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="deviceTableBody">
                        <tr>
                            <td colspan="7" style="text-align:center;padding:36px;color:var(--gray-500);">
                                <i class="fas fa-spinner fa-spin" style="font-size:24px;margin-bottom:8px;display:block;"></i>
                                Loading registered device fleet...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="mobile-scroll-hint">
                <i class="fas fa-arrows-left-right"></i> Scroll table horizontally to view all device columns
            </div>
        </div>
        <div class="modal-footer" style="display:flex;justify-content:space-between;align-items:center;">
            <div style="font-size:12px;color:var(--gray-500);">
                Total Devices: <strong id="fleetFooterCount" style="color:var(--gray-800);">0</strong>
            </div>
            <button type="button" class="btn btn-ghost" onclick="closeDeviceFleetModal()">Close</button>
        </div>
    </div>
</div>

<!-- ==================== FORCE LOGOUT ALL MODAL ==================== -->
<div class="modal-overlay" id="logoutAllModal">
    <div class="modal-box" style="max-width:520px;border:2px solid rgba(239,68,68,0.35);">
        <div class="modal-header" style="background:#fef2f2;border-bottom:1px solid #fee2e2;">
            <div>
                <div class="modal-title" style="color:#b91c1c;display:flex;align-items:center;gap:8px;">
                    <i class="fas fa-triangle-exclamation" style="font-size:20px;color:#dc2626;"></i>
                    Emergency Force Logout All Devices
                </div>
                <div class="modal-subtitle" style="color:#991b1b;">Immediate system-wide token revocation &amp; session termination</div>
            </div>
            <button class="modal-close" onclick="closeLogoutAllModal()">&times;</button>
        </div>
        <div class="modal-body" style="font-size:13px;line-height:1.6;color:var(--gray-700);">
            <div style="background:#fff1f2;border:1px solid #fecdd3;border-radius:10px;padding:14px;margin-bottom:16px;">
                <p style="font-weight:700;color:#9f1239;margin-bottom:8px;">
                    <i class="fas fa-skull-crossbones" style="margin-right:6px;"></i> CRITICAL SYSTEM ACTION:
                </p>
                <p style="color:#881337;font-size:12.5px;margin-bottom:8px;">
                    You are about to execute an immediate <strong>system-wide force logout</strong>. This operation will:
                </p>
                <ul style="padding-left:20px;font-size:12px;color:#9f1239;line-height:1.7;">
                    <li><strong>Send FCM Force Logout Push:</strong> Dispatches a high-priority <code>FORCE_LOGOUT</code> signal to all physical mobile devices.</li>
                    <li><strong>Purge All DB Tokens:</strong> Wipes all registered device tokens (<span id="logoutAllDeviceCount" style="font-weight:700;">0</span> devices) from the database immediately.</li>
                    <li><strong>Log Out SuperAdmin:</strong> Your active SuperAdmin web browser session will be immediately terminated.</li>
                    <li><strong>Affect All Users:</strong> Every Company Admin, Employee, and Super Admin will be logged out and required to re-authenticate.</li>
                </ul>
            </div>

            <p style="font-size:12px;color:var(--gray-600);margin-bottom:6px;">
                Are you sure you want to proceed with logging out every device and user immediately?
            </p>
        </div>
        <div class="modal-footer" style="background:var(--gray-50);display:flex;justify-content:flex-end;gap:10px;">
            <button type="button" class="btn btn-ghost" onclick="closeLogoutAllModal()">Cancel</button>
            <button type="button" class="btn btn-danger" id="btnConfirmLogoutAll" onclick="executeForceLogoutAll()" style="font-weight:600;">
                <i class="fas fa-power-off"></i> Yes, Logout Everyone Immediately
            </button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${baseUrl}';
    var cachedDashboardData = null;
    var rawLogs = [];
    var rawDevices = [];

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
                localStorage.clear();
                sessionStorage.clear();
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

    // ==================== SIDEBAR & HEADER ====================
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        if (sidebar) {
            sidebar.classList.toggle('open');
            if (backdrop) {
                backdrop.classList.toggle('active', sidebar.classList.contains('open'));
            }
        }
    }

    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 1024) {
            var sidebar = document.getElementById('sidebar');
            var backdrop = document.getElementById('sidebarBackdrop');
            if (sidebar && sidebar.classList.contains('open')) {
                if (!sidebar.contains(e.target) && !e.target.closest('.menu-toggle')) {
                    sidebar.classList.remove('open');
                    if (backdrop) backdrop.classList.remove('active');
                }
            }
        }
    });

    function handleLogout() {
        localStorage.clear();
        sessionStorage.clear();
        window.location.href = contextPath + '/login?logout=true';
    }

    function toggleNotifications() {
        var dropdown = document.getElementById('notificationDropdown');
        dropdown.classList.toggle('open');
        if (dropdown.classList.contains('open') && cachedDashboardData && cachedDashboardData.recentLogs) {
            renderHeaderNotifList(cachedDashboardData.recentLogs);
        }
    }

    function renderHeaderNotifList(logs) {
        var list = document.getElementById('notificationList');
        if (!list) return;
        if (logs && logs.length > 0) {
            var html = '';
            for (var i = 0; i < Math.min(logs.length, 5); i++) {
                var log = logs[i];
                var statusTag = (log.failureCount && log.failureCount > 0)
                    ? '<span style="font-size:10px;padding:2px 6px;border-radius:4px;background:rgba(239,68,68,0.1);color:#ef4444;font-weight:600;">' + (log.successCount || 0) + ' sent, ' + log.failureCount + ' failed</span>'
                    : '<span style="font-size:10px;padding:2px 6px;border-radius:4px;background:rgba(16,185,129,0.1);color:#10b981;font-weight:600;">' + (log.successCount || log.recipientCount || 0) + ' delivered</span>';

                html += '<div class="notification-item" style="padding:10px 14px;border-bottom:1px solid rgba(226,232,240,0.6);">' +
                    '<div class="notif-title" style="display:flex;align-items:center;justify-content:space-between;font-weight:600;font-size:13px;color:var(--gray-800);">' +
                    '<span><i class="fas fa-paper-plane" style="color:var(--primary);margin-right:6px;font-size:11px;"></i>' + escapeHtml(log.title || 'Push Alert') + '</span>' +
                    statusTag +
                    '</div>' +
                    '<div class="notif-message" style="font-size:12px;color:var(--gray-500);margin-top:3px;line-height:1.4;">' + escapeHtml(log.body || '') + '</div>' +
                    '<div class="notif-time" style="font-size:11px;color:var(--gray-400);margin-top:4px;"><i class="far fa-clock"></i> ' + (log.timeAgo || 'Recently') + ' &bull; ' + (log.recipientCount || 0) + ' targets</div>' +
                    '</div>';
            }
            list.innerHTML = html;
        } else {
            list.innerHTML = '<div class="notification-empty" style="text-align:center;padding:24px 16px;">' +
                '<i class="fas fa-check-circle" style="color:var(--success);font-size:24px;"></i>' +
                '<div style="margin-top:8px;font-weight:600;color:var(--gray-700);">FCM Push Active</div>' +
                '<div style="font-size:11px;color:var(--gray-400);margin-top:2px;">Dispatched to device drawers</div>' +
                '</div>';
        }
    }

    function markAllRead() {
        toast('All notifications marked as read', 'success');
        var list = document.getElementById('notificationList');
        if (list) {
            list.innerHTML = '<div class="notification-empty"><i class="fas fa-check-circle" style="color:var(--success);"></i><div>All caught up!</div></div>';
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

    // ==================== HOUR OPTIONS ====================
    function initHourOptions() {
        const startSel = document.getElementById('scheduleStartHour');
        const endSel = document.getElementById('scheduleEndHour');
        if (!startSel || !endSel) return;
        startSel.innerHTML = '';
        endSel.innerHTML = '';

        for (let h = 0; h < 24; h++) {
            const label = (h < 10 ? '0' + h : h) + ':00' + (h < 12 ? ' AM' : ' PM');
            const optStart = document.createElement('option');
            optStart.value = h;
            optStart.textContent = label;
            if (h === 8) optStart.selected = true;
            startSel.appendChild(optStart);

            const optEnd = document.createElement('option');
            optEnd.value = h;
            optEnd.textContent = label;
            if (h === 20) optEnd.selected = true;
            endSel.appendChild(optEnd);
        }
    }

    function updateIntervalPreview() {
        const times = parseInt(document.getElementById('scheduleTimesPerDay').value) || 3;
        const start = parseInt(document.getElementById('scheduleStartHour').value) || 8;
        const end = parseInt(document.getElementById('scheduleEndHour').value) || 20;

        const previewEl = document.getElementById('intervalPreviewText');
        if (!previewEl) return;

        if (start >= end) {
            previewEl.innerHTML = 
                '<i class="fas fa-exclamation-triangle" style="color:var(--danger);margin-right:6px;"></i>' +
                '<span style="color:var(--danger);font-weight:600;">Invalid: Start hour must be earlier than End hour.</span>';
            return;
        }

        const totalMinutes = (end - start) * 60;
        let intervalDesc = '';
        if (times <= 1) {
            intervalDesc = '1 send daily at ' + (start < 10 ? '0' + start : start) + ':00 IST';
        } else {
            const interval = Math.round(totalMinutes / (times - 1));
            intervalDesc = times + ' sends evenly distributed every ~' + interval + ' minutes between ' +
                (start < 10 ? '0' + start : start) + ':00 and ' + (end < 10 ? '0' + end : end) + ':00 IST';
        }

        previewEl.innerHTML = 
            '<i class="fas fa-check-circle" style="color:var(--success);margin-right:6px;"></i>' +
            '<span>' + intervalDesc + '</span>';
    }

    // ==================== DASHBOARD METRICS & TELEMETRY ====================
    async function loadDashboardMetrics() {
        try {
            const res = await api('/api/super-admin/notification-schedule/metrics');
            if (!res || !res.success || !res.data) {
                console.error('Failed to load metrics:', res);
                return;
            }

            const d = res.data;
            cachedDashboardData = d;

            // 1. Next Run & Cadence
            document.getElementById('metricNextRun').textContent = d.nextRunFormatted || 'Not Scheduled';
            document.getElementById('metricCountdown').textContent = d.timeRemaining || 'Calculated';
            document.getElementById('metricIntervalDesc').textContent = d.intervalFormatted || '--';

            const statusIndicator = document.getElementById('metricStatusIndicator');
            const isEnabled = d.schedule && d.schedule.enabled;
            if (isEnabled) {
                statusIndicator.className = 'badge-pill bg-success-light';
                statusIndicator.innerHTML = '<i class="fas fa-circle" style="font-size:7px;"></i> Active';
            } else {
                statusIndicator.className = 'badge-pill bg-warning-light';
                statusIndicator.innerHTML = '<i class="fas fa-pause-circle" style="font-size:9px;"></i> Paused';
            }

            document.getElementById('metricTodaySuccess').textContent = Number(d.todaySuccessCount || 0).toLocaleString();
            document.getElementById('metricTodayPushes').textContent = Number(d.todayPushesCount || 0).toLocaleString();
            const notifBadge = document.getElementById('notifBadge');
            if (notifBadge) {
                notifBadge.textContent = d.todayPushesCount !== undefined ? d.todayPushesCount : (d.recentLogs ? d.recentLogs.length : 0);
            }
            document.getElementById('metricTodayFailures').textContent = Number(d.todayFailureCount || 0).toLocaleString();
            document.getElementById('metricTodayRecipients').textContent = Number(d.todayRecipientsCount || 0).toLocaleString();
            
            const todayRate = d.todaySuccessRate !== null ? d.todaySuccessRate : 100;
            const todayRateBadge = document.getElementById('metricTodayRate');
            todayRateBadge.textContent = todayRate + '% Rate';
            todayRateBadge.className = todayRate >= 95 ? 'badge-pill bg-success-light' : (todayRate >= 80 ? 'badge-pill bg-warning-light' : 'badge-pill bg-danger-light');

            // 3. Weekly Delivery Stats
            document.getElementById('metricWeekSuccess').textContent = Number(d.weekSuccessCount || 0).toLocaleString();
            document.getElementById('metricWeekPushes').textContent = Number(d.weekPushesCount || 0).toLocaleString();
            document.getElementById('metricWeekFailures').textContent = Number(d.weekFailureCount || 0).toLocaleString();
            document.getElementById('metricWeekRecipients').textContent = Number(d.weekRecipientsCount || 0).toLocaleString();

            const weekRate = d.weekSuccessRate !== null ? d.weekSuccessRate : 100;
            const weekRateBadge = document.getElementById('metricWeekRate');
            weekRateBadge.textContent = weekRate + '% Rate';
            weekRateBadge.className = weekRate >= 95 ? 'badge-pill bg-info-light' : (weekRate >= 80 ? 'badge-pill bg-warning-light' : 'badge-pill bg-danger-light');

            // 4. Devices Fleet
            const devCount = Number(d.totalRegisteredDevices || 0);
            document.getElementById('metricTotalDevices').textContent = devCount.toLocaleString();
            const btnDevCount = document.getElementById('btnDeviceCount');
            if (btnDevCount) btnDevCount.textContent = devCount;
            const logoutDevCount = document.getElementById('logoutAllDeviceCount');
            if (logoutDevCount) logoutDevCount.textContent = devCount;
            const fleetModalCount = document.getElementById('fleetModalCount');
            if (fleetModalCount) fleetModalCount.textContent = devCount;
            const fleetFooterCount = document.getElementById('fleetFooterCount');
            if (fleetFooterCount) fleetFooterCount.textContent = devCount;
            document.getElementById('metricAndroidCount').textContent = Number(d.androidDevicesCount || 0).toLocaleString();
            document.getElementById('metricIosCount').textContent = Number(d.iosDevicesCount || 0).toLocaleString();
            document.getElementById('metricActiveUsers').textContent = Number(d.activeUsersWithDevices || 0).toLocaleString();

            // 5. All-Time Stats
            document.getElementById('metricTotalSuccess').textContent = Number(d.totalSuccessCount || 0).toLocaleString();
            document.getElementById('metricTotalFailures').textContent = Number(d.totalFailureCount || 0).toLocaleString();

            // 6. Schedule Form Values
            if (d.schedule) {
                const cfg = d.schedule;
                document.getElementById('scheduleEnabled').value = cfg.enabled ? 'true' : 'false';
                document.getElementById('scheduleTimesPerDay').value = cfg.timesPerDay || 3;
                if (cfg.startHour !== undefined && cfg.startHour !== null) {
                    document.getElementById('scheduleStartHour').value = cfg.startHour;
                }
                if (cfg.endHour !== undefined && cfg.endHour !== null) {
                    document.getElementById('scheduleEndHour').value = cfg.endHour;
                }

                const scheduleBadge = document.getElementById('scheduleStatusBadge');
                if (scheduleBadge) {
                    if (cfg.enabled) {
                        scheduleBadge.className = 'badge-pill bg-success-light';
                        scheduleBadge.innerHTML = '<i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> Active';
                    } else {
                        scheduleBadge.className = 'badge-pill bg-warning-light';
                        scheduleBadge.innerHTML = '<i class="fas fa-pause-circle" style="margin-right:4px;"></i> Paused';
                    }
                }

                const sentDisplay = document.getElementById('sentTodayDisplay');
                if (sentDisplay) sentDisplay.textContent = (cfg.sentTodayCount || 0) + ' / ' + (cfg.timesPerDay || 3);

                const lastSentDisplay = document.getElementById('lastSentDisplay');
                if (lastSentDisplay) {
                    lastSentDisplay.textContent = cfg.lastSentAt ? new Date(cfg.lastSentAt).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) : 'None today';
                }
            }

            // 7. Render Daily Slot Progression Timeline
            renderDailySlots(d.dailySlots, d.schedule ? d.schedule.sentTodayCount : 0, d.schedule ? d.schedule.timesPerDay : 3);

            // 8. Render Audit Logs Table
            rawLogs = d.recentLogs || [];
            renderAuditLogs(rawLogs);

            updateIntervalPreview();

        } catch (e) {
            console.error('Error in loadDashboardMetrics:', e);
        }
    }

    async function refreshDashboardMetrics() {
        const spinner = document.getElementById('refreshSpinner');
        if (spinner) spinner.classList.add('fa-spin');
        await loadDashboardMetrics();
        setTimeout(() => {
            if (spinner) spinner.classList.remove('fa-spin');
            toast('FCM telemetry updated to latest live state', 'info', 2000);
        }, 500);
    }

    // ==================== RENDER SLOTS TIMELINE ====================
    function renderDailySlots(slots, sentCount, totalTimes) {
        const container = document.getElementById('slotsTimelineList');
        const badge = document.getElementById('slotsProgressBadge');
        if (!container) return;

        if (badge) {
            const actualSentCount = slots ? slots.filter(s => s.status === 'SENT' || s.status === 'COMPLETED').length : (sentCount || 0);
            const missedCount = slots ? slots.filter(s => s.status === 'MISSED').length : 0;
            let badgeText = '<i class="fas fa-tasks" style="margin-right:4px;"></i> ' + actualSentCount + ' / ' + (totalTimes || 3) + ' Slots Sent Today';
            if (missedCount > 0) {
                badgeText += ' &nbsp;<span style="color:#d97706;font-size:11px;">(' + missedCount + ' missed)</span>';
            }
            badge.innerHTML = badgeText;
        }

        if (!slots || slots.length === 0) {
            container.innerHTML = '<div style="padding:16px;color:var(--gray-500);font-size:13px;">No active daily slots configured.</div>';
            return;
        }

        let html = '';
        slots.forEach(slot => {
            let cardClass = 'slot-card pending';
            let icon = '<i class="far fa-clock" style="color:var(--gray-400);"></i>';
            let statusText = '<span style="color:var(--gray-500);">Pending</span>';

            if (slot.status === 'SENT' || slot.status === 'COMPLETED') {
                cardClass = 'slot-card completed';
                icon = '<i class="fas fa-check-circle" style="color:var(--success);"></i>';
                statusText = '<span style="color:#047857;">Sent</span>';
            } else if (slot.status === 'MISSED') {
                cardClass = 'slot-card';
                icon = '<i class="fas fa-exclamation-triangle" style="color:#d97706;"></i>';
                statusText = '<span style="color:#d97706;">Missed</span>';
            } else if (slot.status === 'NEXT' || slot.isNext) {
                cardClass = 'slot-card next';
                icon = '<i class="fas fa-bolt" style="color:var(--primary);"></i>';
                statusText = '<span style="color:var(--primary);font-weight:700;">Next Up</span>';
            }

            html += '<div class="' + cardClass + '">' +
                '<div class="slot-card-num">' +
                    '<span>Slot #' + slot.slotNumber + '</span>' +
                    icon +
                '</div>' +
                '<div class="slot-card-time">' + escapeHtml(slot.timeFormatted) + '</div>' +
                '<div class="slot-card-status">' + statusText + '</div>' +
            '</div>';
        });

        container.innerHTML = html;
    }

    // ==================== RENDER AUDIT LOGS TABLE ====================
    function renderAuditLogs(logs) {
        const tbody = document.getElementById('auditLogTableBody');
        if (!tbody) return;

        if (!logs || logs.length === 0) {
            tbody.innerHTML = '<tr>' +
                '<td colspan="7" style="text-align:center;padding:40px 20px;color:var(--gray-500);">' +
                    '<i class="fas fa-inbox" style="font-size:32px;color:var(--gray-300);display:block;margin-bottom:8px;"></i>' +
                    '<strong style="color:var(--gray-700);">No push deliveries recorded yet</strong>' +
                    '<div style="font-size:12px;margin-top:4px;">Dispatches from scheduled compliance checks or manual test pushes will appear here in real-time.</div>' +
                '</td>' +
            '</tr>';
            return;
        }

        let html = '';
        logs.forEach((log, index) => {
            // Status Badge
            let statusBadge = '<span class="badge-pill bg-gray-light">Unknown</span>';
            if (log.status === 'SUCCESS') {
                statusBadge = '<span class="badge-pill bg-success-light"><i class="fas fa-check"></i> Delivered</span>';
            } else if (log.status === 'PARTIAL') {
                statusBadge = '<span class="badge-pill bg-warning-light"><i class="fas fa-triangle-exclamation"></i> Partial</span>';
            } else if (log.status === 'FAILED') {
                statusBadge = '<span class="badge-pill bg-danger-light"><i class="fas fa-times"></i> Failed</span>';
            } else if (log.status === 'NO_DEVICES') {
                statusBadge = '<span class="badge-pill bg-gray-light"><i class="fas fa-mobile-screen-button"></i> No Devices</span>';
            }

            // Event Badge
            let eventBadge = '<span class="badge-pill bg-info-light">' + escapeHtml(log.notificationType || 'PUSH') + '</span>';
            if (log.notificationType === 'COMPLIANCE_DUE_SOON') {
                eventBadge = '<span class="badge-pill" style="background:#eff6ff;color:#2563eb;border:1px solid #bfdbfe;">COMPLIANCE DUE</span>';
            } else if (log.notificationType === 'SYSTEM_ANNOUNCEMENT') {
                eventBadge = '<span class="badge-pill" style="background:#faf5ff;color:#7c3aed;border:1px solid #e9d5ff;">TEST / BROADCAST</span>';
            }

            // Result counts
            let resultPill = '<span style="font-size:12px;font-weight:600;color:var(--success);">✓ ' + (log.successCount || 0) + '</span>';
            if ((log.failureCount || 0) > 0) {
                resultPill += ' <span style="font-size:12px;font-weight:600;color:var(--danger);margin-left:6px;">✗ ' + log.failureCount + '</span>';
            }

            html += '<tr>' +
                '<td>' +
                    '<div style="font-weight:600;color:var(--gray-900);">' + escapeHtml(log.sentAtFormatted || '-') + '</div>' +
                    '<div style="font-size:11px;color:var(--gray-400);">' + escapeHtml(log.timeAgo || '') + '</div>' +
                '</td>' +
                '<td>' + eventBadge + '</td>' +
                '<td>' +
                    '<div class="log-title" title="' + escapeHtml(log.title) + '">' + escapeHtml(log.title) + '</div>' +
                    '<div class="log-body" title="' + escapeHtml(log.body) + '">' + escapeHtml(log.body) + '</div>' +
                '</td>' +
                '<td style="text-align:center;font-weight:600;color:var(--gray-800);">' + (log.recipientCount || 0) + '</td>' +
                '<td style="text-align:center;">' + resultPill + '</td>' +
                '<td style="text-align:center;">' + statusBadge + '</td>' +
                '<td style="text-align:center;">' +
                    '<button class="btn btn-ghost btn-sm" onclick="openLogDetails(' + index + ')" title="Inspect payload & telemetry">' +
                        '<i class="fas fa-eye"></i> Details' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });

        tbody.innerHTML = html;
    }

    function filterAuditLogs() {
        const q = (document.getElementById('logSearchInput').value || '').trim().toLowerCase();
        if (!q) {
            renderAuditLogs(rawLogs);
            return;
        }

        const filtered = rawLogs.filter(l => {
            return (l.title && l.title.toLowerCase().includes(q)) ||
                   (l.body && l.body.toLowerCase().includes(q)) ||
                   (l.notificationType && l.notificationType.toLowerCase().includes(q)) ||
                   (l.status && l.status.toLowerCase().includes(q)) ||
                   (l.traceId && l.traceId.toLowerCase().includes(q));
        });

        renderAuditLogs(filtered);
    }

    // ==================== LOG DETAILS MODAL ====================
    function openLogDetails(index) {
        const log = rawLogs[index];
        if (!log) return;

        document.getElementById('logModalTraceId').textContent = 'Trace ID: ' + (log.traceId || 'N/A');

        let errorSection = '';
        if (log.errorMessage) {
            errorSection = '<div style="margin-top:14px;background:#fef2f2;border:1px solid #fecaca;padding:10px 14px;border-radius:8px;color:#991b1b;">' +
                '<strong style="display:block;font-size:11px;text-transform:uppercase;margin-bottom:4px;"><i class="fas fa-exclamation-triangle"></i> Firebase Error Detail:</strong>' +
                '<code style="font-size:12px;word-break:break-all;">' + escapeHtml(log.errorMessage) + '</code>' +
            '</div>';
        }

        const html = '<div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:14px;background:var(--gray-50);padding:14px;border-radius:10px;border:1px solid var(--gray-200);">' +
            '<div><span style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;">Dispatch Timestamp</span><div style="font-weight:600;color:var(--gray-900);">' + escapeHtml(log.sentAtFormatted) + ' (' + escapeHtml(log.timeAgo) + ')</div></div>' +
            '<div><span style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;">Event Type</span><div><span class="badge-pill bg-info-light">' + escapeHtml(log.notificationType) + '</span></div></div>' +
            '<div><span style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;">Recipient Devices</span><div style="font-weight:700;font-size:15px;color:var(--gray-900);">' + log.recipientCount + ' target devices</div></div>' +
            '<div><span style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;">Multicast Outcome</span><div><span style="color:var(--success);font-weight:700;">✓ ' + log.successCount + '</span> &nbsp;|&nbsp; <span style="color:var(--danger);font-weight:700;">✗ ' + log.failureCount + '</span></div></div>' +
        '</div>' +
        '<div style="margin-bottom:12px;">' +
            '<label style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;display:block;margin-bottom:2px;">Notification Title</label>' +
            '<div style="background:#fff;border:1px solid var(--gray-200);padding:8px 12px;border-radius:6px;font-weight:600;color:var(--gray-900);">' + escapeHtml(log.title) + '</div>' +
        '</div>' +
        '<div>' +
            '<label style="font-size:11px;color:var(--gray-500);text-transform:uppercase;font-weight:600;display:block;margin-bottom:2px;">Notification Body Payload</label>' +
            '<div style="background:#fff;border:1px solid var(--gray-200);padding:10px 12px;border-radius:6px;color:var(--gray-700);white-space:pre-wrap;">' + escapeHtml(log.body) + '</div>' +
        '</div>' +
        errorSection;

        document.getElementById('logModalContent').innerHTML = html;
        document.getElementById('logDetailsModal').style.display = 'flex';
    }

    function closeLogDetailsModal() {
        document.getElementById('logDetailsModal').style.display = 'none';
    }

    // ==================== TEST PUSH MODAL ====================
    function openTestPushModal() {
        document.getElementById('testPushModal').style.display = 'flex';
    }

    function closeTestPushModal() {
        document.getElementById('testPushModal').style.display = 'none';
    }

    async function submitTestPush(e) {
        if (e) e.preventDefault();

        const title = document.getElementById('testPushTitle').value.trim();
        const body = document.getElementById('testPushBody').value.trim();
        const target = document.getElementById('testPushTarget') ? document.getElementById('testPushTarget').value : 'ALL';
        const btn = document.getElementById('submitTestPushBtn');
        const origText = btn.innerHTML;

        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Dispatched...';

        try {
            const url = '/api/super-admin/notification-schedule/test-push?title=' + encodeURIComponent(title) +
                        '&body=' + encodeURIComponent(body) +
                        '&targetRole=' + encodeURIComponent(target);
            const res = await api(url, { method: 'POST' });

            if (res && res.success) {
                toast('Test FCM push dispatched! Check your phone drawer.', 'success', 5000);
                closeTestPushModal();
                await loadDashboardMetrics();
            } else {
                toast((res && (res.message || res.error)) || 'Failed to dispatch test push', 'error');
            }
        } catch (err) {
            toast('Network error dispatching test push', 'error');
        } finally {
            btn.disabled = false;
            btn.innerHTML = origText;
        }
    }

    // ==================== TRIGGER DUE REMINDERS MANUALLY ====================
    async function triggerDueRemindersNow() {
        const btn = document.getElementById('btnTriggerNow');
        const origText = btn ? btn.innerHTML : '';
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Triggering...';
        }

        try {
            const res = await api('/api/super-admin/notification-schedule/trigger-reminders-now', { method: 'POST' });
            if (res && res.success) {
                toast(res.message || 'Due/overdue reminders evaluated & dispatched to devices!', 'success', 5000);
                await loadDashboardMetrics();
            } else {
                toast((res && (res.message || res.error)) || 'Failed to trigger reminders', 'error');
            }
        } catch (err) {
            toast('Network error triggering reminders', 'error');
        } finally {
            if (btn) {
                btn.disabled = false;
                btn.innerHTML = origText;
            }
        }
    }

    // ==================== SAVE SCHEDULE CONFIG ====================
    async function saveScheduleConfig(e) {
        if (e) e.preventDefault();

        const enabled = document.getElementById('scheduleEnabled').value === 'true';
        const timesPerDay = parseInt(document.getElementById('scheduleTimesPerDay').value);
        const startHour = parseInt(document.getElementById('scheduleStartHour').value);
        const endHour = parseInt(document.getElementById('scheduleEndHour').value);

        if (startHour >= endHour) {
            toast('Start hour must be strictly before End hour', 'error');
            return;
        }

        const btn = document.getElementById('saveScheduleBtn');
        const origText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        btn.disabled = true;

        try {
            const res = await api('/api/super-admin/notification-schedule/DUE_REMINDER', {
                method: 'PUT',
                body: JSON.stringify({
                    enabled: enabled,
                    timesPerDay: timesPerDay,
                    startHour: startHour,
                    endHour: endHour
                })
            });

            if (res && res.success) {
                toast('Schedule updated! Sent ' + timesPerDay + 'x daily between ' + startHour + ':00 and ' + endHour + ':00 IST.', 'success', 4500);
                await loadDashboardMetrics();
            } else {
                toast((res && (res.message || res.error)) || 'Failed to update schedule config', 'error');
            }
        } catch (err) {
            toast('Network error saving schedule', 'error');
        } finally {
            btn.innerHTML = origText;
            btn.disabled = false;
        }
    }

    // ==================== REGISTERED DEVICE FLEET & FORCE LOGOUT ====================
    async function loadRegisteredDevices() {
        var spinner = document.getElementById('deviceRefreshSpinner');
        if (spinner) spinner.classList.add('fa-spin');
        try {
            var res = await api('/api/super-admin/devices');
            if (res && res.success && res.data) {
                rawDevices = res.data;
                renderDeviceList(rawDevices);
                var count = rawDevices.length;
                var c1 = document.getElementById('btnDeviceCount');
                if (c1) c1.textContent = count;
                var c2 = document.getElementById('fleetModalCount');
                if (c2) c2.textContent = count;
                var c3 = document.getElementById('fleetFooterCount');
                if (c3) c3.textContent = count;
                var c4 = document.getElementById('logoutAllDeviceCount');
                if (c4) c4.textContent = count;
            } else {
                console.error('Failed to load devices:', res);
            }
        } catch (e) {
            console.error('Error loading devices:', e);
        } finally {
            if (spinner) spinner.classList.remove('fa-spin');
        }
    }

    function renderDeviceList(devices) {
        var tbody = document.getElementById('deviceTableBody');
        if (!tbody) return;

        if (!devices || devices.length === 0) {
            tbody.innerHTML = '<tr>' +
                '<td colspan="7" style="text-align:center;padding:40px 20px;color:var(--gray-500);">' +
                    '<i class="fas fa-mobile-screen-button" style="font-size:32px;color:var(--gray-300);display:block;margin-bottom:8px;"></i>' +
                    '<strong style="color:var(--gray-700);">No registered devices in database</strong>' +
                    '<div style="font-size:12px;margin-top:4px;">When users log in from Android/iOS apps, their device tokens will appear here.</div>' +
                '</td>' +
            '</tr>';
            return;
        }

        var html = '';
        devices.forEach(function(d) {
            var plat = (d.platform || 'ANDROID').toUpperCase();
            var platIcon = plat === 'IOS' ? '<i class="fab fa-apple" style="color:#000;"></i>' : (plat === 'WEB' ? '<i class="fas fa-desktop" style="color:var(--primary);"></i>' : '<i class="fab fa-android" style="color:#10b981;"></i>');
            var roleBadge = '<span class="badge-pill bg-gray-light">' + escapeHtml(d.userRole || '-') + '</span>';
            if (d.userRole === 'SUPER_ADMIN') {
                roleBadge = '<span class="badge-pill" style="background:#ede9fe;color:#6d28d9;font-weight:600;">SUPER ADMIN</span>';
            } else if (d.userRole === 'COMPANY_ADMIN') {
                roleBadge = '<span class="badge-pill" style="background:#e0f2fe;color:#0284c7;font-weight:600;">COMPANY ADMIN</span>';
            } else if (d.userRole === 'EMPLOYEE') {
                roleBadge = '<span class="badge-pill" style="background:#dcfce7;color:#15803d;font-weight:600;">EMPLOYEE</span>';
            }

            html += '<tr>' +
                '<td>' +
                    '<div style="font-weight:600;color:var(--gray-900);">' + escapeHtml(d.userName || 'Unknown') + '</div>' +
                    '<div style="font-size:11px;color:var(--gray-500);">' + escapeHtml(d.userEmail || '-') + '</div>' +
                    '<div style="margin-top:3px;">' + roleBadge + '</div>' +
                '</td>' +
                '<td>' +
                    '<div style="font-weight:500;color:var(--gray-800);">' + escapeHtml(d.companyName || '-') + '</div>' +
                '</td>' +
                '<td>' +
                    '<div style="display:flex;align-items:center;gap:6px;font-weight:600;color:var(--gray-800);">' +
                        platIcon + ' <span>' + escapeHtml(d.deviceName || plat) + '</span>' +
                    '</div>' +
                    '<div style="font-size:11px;color:var(--gray-400);">' + plat + '</div>' +
                '</td>' +
                '<td><span class="badge-pill bg-gray-light" style="font-size:11px;">v' + escapeHtml(d.appVersion || '1.0.0') + '</span></td>' +
                '<td>' +
                    '<div style="font-size:12px;color:var(--gray-700);">' + escapeHtml(d.lastSeenFormatted || '-') + '</div>' +
                '</td>' +
                '<td>' +
                    '<code style="font-size:11px;background:var(--gray-100);padding:3px 6px;border-radius:4px;color:var(--gray-600);">' + escapeHtml(d.tokenMasked || '-') + '</code>' +
                '</td>' +
                '<td style="text-align:center;">' +
                    '<button class="btn btn-ghost btn-sm" onclick="revokeSingleDevice(' + d.id + ', \'' + escapeHtml(d.deviceName || 'Device') + '\', \'' + escapeHtml(d.userName || 'User') + '\')" style="color:var(--danger);border-color:#fecaca;" title="Revoke device token">' +
                        '<i class="fas fa-trash-alt"></i> Revoke' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });

        tbody.innerHTML = html;
    }

    function filterDeviceList() {
        var q = (document.getElementById('deviceSearchInput').value || '').trim().toLowerCase();
        if (!q) {
            renderDeviceList(rawDevices);
            return;
        }
        var filtered = rawDevices.filter(function(d) {
            return (d.userName && d.userName.toLowerCase().includes(q)) ||
                   (d.userEmail && d.userEmail.toLowerCase().includes(q)) ||
                   (d.companyName && d.companyName.toLowerCase().includes(q)) ||
                   (d.deviceName && d.deviceName.toLowerCase().includes(q)) ||
                   (d.platform && d.platform.toLowerCase().includes(q)) ||
                   (d.userRole && d.userRole.toLowerCase().includes(q));
        });
        renderDeviceList(filtered);
    }

    async function revokeSingleDevice(id, deviceName, userName) {
        if (!confirm('Are you sure you want to revoke the device token for ' + deviceName + ' (' + userName + ')?\nThis device will be immediately logged out.')) {
            return;
        }

        try {
            var res = await api('/api/super-admin/devices/' + id, { method: 'DELETE' });
            if (res && res.success) {
                toast('Device token revoked! Device forced to log out.', 'success');
                await loadRegisteredDevices();
                await loadDashboardMetrics();
            } else {
                toast((res && (res.message || res.error)) || 'Failed to revoke device token', 'error');
            }
        } catch (e) {
            toast('Network error revoking device token', 'error');
        }
    }

    function openDeviceFleetModal() {
        document.getElementById('deviceFleetModal').style.display = 'flex';
        loadRegisteredDevices();
    }

    function closeDeviceFleetModal() {
        document.getElementById('deviceFleetModal').style.display = 'none';
    }

    function openLogoutAllModal() {
        var count = rawDevices ? rawDevices.length : (cachedDashboardData ? cachedDashboardData.totalRegisteredDevices || 0 : 0);
        var el = document.getElementById('logoutAllDeviceCount');
        if (el) el.textContent = count;
        document.getElementById('logoutAllModal').style.display = 'flex';
    }

    function closeLogoutAllModal() {
        document.getElementById('logoutAllModal').style.display = 'none';
    }

    async function executeForceLogoutAll() {
        var btn = document.getElementById('btnConfirmLogoutAll');
        var origHtml = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Revoking All Devices &amp; Logging Out...';

        try {
            var res = await api('/api/super-admin/devices/logout-all', { method: 'POST' });
            
            toast('System-wide logout completed! All tokens purged. Logging you out now...', 'success', 4000);

            setTimeout(function() {
                localStorage.clear();
                sessionStorage.clear();
                window.location.href = contextPath + '/login?logout=true&message=' + encodeURIComponent('All devices have been force-logged out by SuperAdmin.');
            }, 1200);

        } catch (err) {
            console.error('Logout all error:', err);
            toast('Executed force logout. Logging out session...', 'info', 2000);
            setTimeout(function() {
                localStorage.clear();
                sessionStorage.clear();
                window.location.href = contextPath + '/login?logout=true';
            }, 1500);
        }
    }

    // ==================== INIT ====================
    document.addEventListener('DOMContentLoaded', function() {
        const userStr = localStorage.getItem('user');
        if (userStr) {
            try {
                const u = JSON.parse(userStr);
                document.getElementById('userName').textContent = u.firstName + ' ' + u.lastName;
                document.getElementById('userAvatar').textContent = (u.firstName || 'U')[0] + (u.lastName || '')[0];
                document.getElementById('userRole').textContent = (u.role || '').replace('_', ' ');
            } catch(e) {}
        }

        initHourOptions();
        loadDashboardMetrics();

        // Refresh live countdown badge every 15 seconds
        setInterval(() => {
            if (cachedDashboardData && cachedDashboardData.nextRunTime) {
                try {
                    const nextTime = new Date(cachedDashboardData.nextRunTime);
                    const now = new Date();
                    const diffMs = nextTime - now;
                    if (diffMs > 0) {
                        const totalMins = Math.floor(diffMs / 60000);
                        const h = Math.floor(totalMins / 60);
                        const m = totalMins % 60;
                        const remStr = (h > 0 ? h + 'h ' : '') + m + 'm remaining';
                        const el = document.getElementById('metricCountdown');
                        if (el) el.textContent = remStr;
                    } else if (diffMs > -120000) {
                        const el = document.getElementById('metricCountdown');
                        if (el) el.textContent = 'Due now';
                    } else {
                        // Slot passed, auto-refresh to advance to next slot
                        loadDashboardMetrics();
                    }
                } catch(e) {}
            }
        }, 15000);
    });
</script>

</body>
</html>