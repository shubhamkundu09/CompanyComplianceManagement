<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% pageContext.setAttribute("pageTitle", "Compliance Calendar"); %>
<%-- File: companyadmin/compliance-calender.jsp --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Compliance Calendar</title>

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

        /* ==================== BREADCRUMB ==================== */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--gray-500);
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb .sep {
            color: var(--gray-400);
        }

        .breadcrumb .current {
            color: var(--gray-800);
            font-weight: 500;
        }

        /* ==================== STATS ==================== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 12px;
            margin-bottom: 24px;
        }

        .stat-box {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius);
            padding: 14px 16px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }

        .stat-box:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .stat-box .number {
            font-size: 22px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .stat-box .label {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 2px;
        }

        .stat-box .number.total { color: var(--primary); }
        .stat-box .number.completed { color: var(--success); }
        .stat-box .number.pending { color: var(--warning); }
        .stat-box .number.overdue { color: var(--danger); }
        .stat-box .number.in-progress { color: var(--info); }
        .stat-box .number.custom { color: var(--primary-light); }

        /* ==================== CALENDAR ==================== */
        .calendar-wrapper {
            display: flex;
            gap: 24px;
        }

        .calendar-main {
            flex: 1;
            min-width: 0;
        }

        .calendar-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .calendar-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .calendar-nav .nav-left {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .calendar-nav .nav-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .calendar-grid {
            overflow-x: auto;
        }

        .calendar-table {
            width: 100%;
            border-collapse: collapse;
        }

        .calendar-table th {
            padding: 10px 12px;
            text-align: center;
            font-size: 11px;
            font-weight: 600;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: rgba(226, 232, 240, 0.3);
            border: 1px solid rgba(226, 232, 240, 0.3);
        }

        .calendar-table td {
            border: 1px solid rgba(226, 232, 240, 0.3);
            vertical-align: top;
            height: 90px;
            width: 14.28%;
            transition: background 0.2s;
            cursor: pointer;
            position: relative;
        }

        .calendar-table td:hover {
            background: rgba(79, 70, 229, 0.04);
        }

        .calendar-table td.other-month {
            opacity: 0.3;
        }

        .calendar-table td.today-date {
            background: rgba(79, 70, 229, 0.04);
        }

        .calendar-table td.today-date .calendar-date-number {
            background: var(--primary);
            color: white;
        }

        .calendar-date-cell {
            padding: 6px 8px;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .calendar-date-number {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-800);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            margin-bottom: 4px;
        }

        .calendar-date-number.other-month {
            color: var(--gray-400);
        }

        .calendar-event-item {
            font-size: 9px;
            padding: 2px 6px;
            margin-bottom: 2px;
            border-radius: 3px;
            cursor: pointer;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: all 0.2s;
            border-left: 2px solid;
        }

        .calendar-event-item:hover {
            transform: scale(1.02);
            filter: brightness(1.05);
        }

        .calendar-event-item .event-dot {
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            margin-right: 4px;
        }

        .calendar-event-item.status-pending {
            background: rgba(245, 158, 11, 0.12);
            color: var(--warning);
            border-left-color: var(--warning);
        }

        .calendar-event-item.status-in_progress {
            background: rgba(79, 70, 229, 0.12);
            color: var(--primary);
            border-left-color: var(--primary);
        }

        .calendar-event-item.status-completed {
            background: rgba(16, 185, 129, 0.12);
            color: var(--success);
            border-left-color: var(--success);
        }

        .calendar-event-item.status-overdue {
            background: rgba(239, 68, 68, 0.12);
            color: var(--danger);
            border-left-color: var(--danger);
        }

        .event-more {
            font-size: 9px;
            color: var(--gray-500);
            padding: 2px 4px;
            cursor: pointer;
        }

        /* ==================== SIDE PANEL ==================== */
        .side-panel {
            width: 380px;
            flex-shrink: 0;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            max-height: 600px;
            overflow-y: auto;
            display: none;
            position: sticky;
            top: 80px;
        }

        .side-panel.open {
            display: block;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .side-panel .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }

        .side-panel .panel-header .panel-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .side-panel .panel-header .panel-sub {
            font-size: 12px;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-top: 2px;
        }

        .side-panel .panel-header .panel-close {
            background: none;
            border: none;
            color: var(--gray-400);
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            transition: color 0.2s;
        }

        .side-panel .panel-header .panel-close:hover {
            color: var(--gray-800);
        }

        .day-stats {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 8px;
            margin-bottom: 16px;
        }

        .day-stat-badge {
            background: rgba(226, 232, 240, 0.12);
            border-radius: var(--radius);
            padding: 8px 10px;
            text-align: center;
        }

        .day-stat-badge .count {
            font-size: 18px;
            font-weight: 700;
        }

        .day-stat-badge .label {
            font-size: 9px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .day-events-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            max-height: 300px;
            overflow-y: auto;
        }

        .day-events-list .list-title {
            font-size: 12px;
            font-weight: 600;
            color: var(--gray-500);
            margin-bottom: 4px;
        }

        .event-item {
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            border-radius: var(--radius);
            padding: 12px 14px;
            transition: all 0.2s;
            cursor: pointer;
            border-left: 3px solid;
        }

        .event-item:hover {
            transform: translateX(4px);
            background: rgba(255, 255, 255, 0.8);
        }

        .event-item.status-pending { border-left-color: var(--warning); }
        .event-item.status-in_progress { border-left-color: var(--primary); }
        .event-item.status-completed { border-left-color: var(--success); }
        .event-item.status-overdue { border-left-color: var(--danger); }

        .event-item .event-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 4px;
            gap: 10px;
        }

        .event-item .event-top .event-name {
            font-weight: 600;
            font-size: 13px;
            color: var(--gray-800);
        }

        .event-item .event-meta {
            font-size: 11px;
            color: var(--gray-500);
        }

        .event-item .event-meta i {
            margin-right: 4px;
            font-size: 10px;
        }

        .event-item .event-actions {
            display: flex;
            gap: 6px;
            margin-top: 8px;
            flex-wrap: wrap;
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

        .btn-sm {
            padding: 5px 12px;
            font-size: 12px;
        }

        .btn-block {
            width: 100%;
            justify-content: center;
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

        /* ==================== LEGEND ==================== */
        .legend {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(8px);
            border-radius: var(--radius);
            margin-top: 16px;
            border: 1px solid rgba(226, 232, 240, 0.3);
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: var(--gray-600);
        }

        .legend-item .dot {
            width: 10px;
            height: 10px;
            border-radius: 3px;
            flex-shrink: 0;
        }

        .legend-item .dot.pending { background: var(--warning); }
        .legend-item .dot.in-progress { background: var(--primary); }
        .legend-item .dot.completed { background: var(--success); }
        .legend-item .dot.overdue { background: var(--danger); }
        .legend-item .dot.today { width: 8px; height: 8px; border-radius: 50%; background: var(--primary); }

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
            max-width: 600px;
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
            flex-wrap: wrap;
        }

        .modal-footer .btn {
            flex: 0 1 auto;
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

        .form-group {
            margin-bottom: 16px;
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
            animation: slideInToast 0.3s ease;
            box-shadow: var(--shadow-lg);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        @keyframes slideInToast {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .toast-success { color: var(--success); }
        .toast-error { color: var(--danger); }
        .toast-info { color: var(--primary); }
        .toast-warning { color: var(--warning); }

        /* ==================== EMPTY STATE ==================== */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-500);
        }

        .empty-state i {
            font-size: 36px;
            opacity: 0.3;
            display: block;
            margin-bottom: 10px;
        }

        .empty-state p {
            font-size: 14px;
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

        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 1200px) {
            .stats-row { grid-template-columns: repeat(3, 1fr); }
            .calendar-wrapper { flex-direction: column; }
            .side-panel {
                width: 100%;
                position: static;
                max-height: none;
            }
        }

        @media (max-width: 1024px) {
            .header { left: 0; }
            .header-left .menu-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .logo-bg { width: 500px; height: 500px; }
        }

        @media (max-width: 768px) {
            .stats-row { grid-template-columns: repeat(3, 1fr); }
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .calendar-table td { height: 60px; }
            .calendar-event-item { font-size: 8px; white-space: normal; }
            .calendar-nav .nav-title { font-size: 16px; }
            .day-stats { grid-template-columns: 1fr 1fr 1fr; }
            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }

        @media (max-width: 480px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .calendar-nav { flex-direction: column; align-items: stretch; }
            .calendar-nav .nav-left { justify-content: center; }
            .calendar-nav .nav-title { text-align: center; font-size: 18px; }
            .calendar-table th { font-size: 9px; padding: 6px; }
            .calendar-table td { height: 50px; }
            .calendar-date-number { font-size: 12px; width: 22px; height: 22px; }
            .calendar-event-item { font-size: 7px; padding: 1px 4px; }
            .side-panel { padding: 16px; }
            .day-stats { grid-template-columns: 1fr 1fr 1fr; }
            .day-stat-badge .count { font-size: 14px; }
            .legend { gap: 10px; }
            .legend-item { font-size: 10px; }
        }
    </style>
</head>
<body>

<div class="logo-bg">
    <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<div id="toast-container"></div>

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
        <a href="${baseUrl}/company-admin/dashboard" class="nav-item">
            <i class="fas fa-chart-pie"></i> Dashboard
        </a>

        <div class="sidebar-label">Management</div>
        <a href="${baseUrl}/company-admin/employees" class="nav-item">
            <i class="fas fa-users"></i> Employees
        </a>

        <div class="sidebar-label">Compliance</div>
        <a href="${baseUrl}/company-admin/compliance/parents" class="nav-item active">
            <i class="fas fa-tasks"></i> My Compliances
        </a>
        <a href="${baseUrl}/company-admin/compliance/custom/create" class="nav-item">
            <i class="fas fa-plus-circle"></i> Custom Compliance
        </a>

        <div class="sidebar-label">Communication</div>
        <a href="${baseUrl}/company-admin/notifications" class="nav-item">
            <i class="fas fa-bell"></i> Notifications
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
            <span class="page-title">Compliance Calendar</span>
        </div>
        <div class="header-right">
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

        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${baseUrl}/company-admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <a href="${baseUrl}/company-admin/compliance/parents">My Compliances</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current">Compliance Calendar</span>
        </div>

        <!-- Page Header -->
        <div style="margin-bottom:24px;">
            <div style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                <i class="fas fa-calendar-alt" style="margin-right:6px;"></i> Compliance Management
            </div>
            <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">Compliance Calendar</h1>
            <p style="font-size:13px;color:var(--gray-500);margin-top:4px;">
                View all compliance due dates, track progress, and manage deadlines
            </p>
        </div>

        <!-- Stats Row -->
        <div class="stats-row" id="statsRow">
            <div class="stat-box" onclick="filterByStatus('all')">
                <div class="number total" id="statTotal">0</div>
                <div class="label">Total</div>
            </div>
            <div class="stat-box" onclick="filterByStatus('COMPLETED')">
                <div class="number completed" id="statCompleted">0</div>
                <div class="label">Completed</div>
            </div>
            <div class="stat-box" onclick="filterByStatus('PENDING')">
                <div class="number pending" id="statPending">0</div>
                <div class="label">Pending</div>
            </div>
            <div class="stat-box" onclick="filterByStatus('IN_PROGRESS')">
                <div class="number in-progress" id="statInProgress">0</div>
                <div class="label">In Progress</div>
            </div>
            <div class="stat-box" onclick="filterByStatus('OVERDUE')">
                <div class="number overdue" id="statOverdue">0</div>
                <div class="label">Overdue</div>
            </div>
            <div class="stat-box" onclick="openCustomModal()">
                <div class="number custom">+</div>
                <div class="label">Add Custom</div>
            </div>
        </div>

        <!-- Calendar Wrapper -->
        <div class="calendar-wrapper">

            <!-- Calendar Main -->
            <div class="calendar-main">
                <div class="calendar-card">
                    <!-- Navigation -->
                    <div class="calendar-nav">
                        <div class="nav-left">
                            <button onclick="previousMonth()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button onclick="nextMonth()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                            <button onclick="goToToday()" class="btn btn-primary" style="padding:8px 12px;">
                                <i class="fas fa-calendar-day"></i> Today
                            </button>
                        </div>
                        <div class="nav-title" id="currentMonthYear">Loading...</div>
                        <div>
                            <button onclick="refreshCalendar()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                            <button onclick="exportCalendar()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-download"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Calendar Grid -->
                    <div class="calendar-grid" id="calendarGrid">
                        <div id="calendarTable"></div>
                    </div>

                    <!-- Legend -->
                    <div class="legend">
                        <span class="legend-item"><span class="dot pending"></span> Pending</span>
                        <span class="legend-item"><span class="dot in-progress"></span> In Progress</span>
                        <span class="legend-item"><span class="dot completed"></span> Completed</span>
                        <span class="legend-item"><span class="dot overdue"></span> Overdue</span>
                        <span class="legend-item"><span class="dot today"></span> Today</span>
                    </div>
                </div>
            </div>

            <!-- Side Panel -->
            <div class="side-panel" id="sidePanel">
                <div class="panel-header">
                    <div>
                        <div class="panel-sub"><i class="fas fa-calendar-day"></i> Selected Date</div>
                        <div class="panel-title" id="selectedDateTitle">—</div>
                    </div>
                    <button onclick="closeSidePanel()" class="panel-close">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="day-stats" id="dayStats"></div>

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                    <div style="font-size:12px;font-weight:600;color:var(--gray-500);">
                        <i class="fas fa-list"></i> Events on this day
                    </div>
                    <button onclick="openCustomModal()" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Add Event
                    </button>
                </div>

                <div class="day-events-list" id="dayEventsList"></div>
            </div>

        </div>

    </main>
</div>

<!-- ==================== CREATE/EDIT MODAL ==================== -->
<div id="eventModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="eventModalTitle">
                    <i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Add Compliance Event
                </div>
                <div class="modal-subtitle" id="eventModalSubtitle">Create a new compliance event</div>
            </div>
            <button class="modal-close" onclick="closeEventModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="eventForm" onsubmit="return false;">
                <input type="hidden" id="eventId">
                <input type="hidden" id="eventDate">

                <div class="form-group">
                    <label class="form-label">Event Title <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="eventTitle" class="form-input" placeholder="Enter event title" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea id="eventDescription" class="form-input" rows="3" placeholder="Event description..."></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select id="eventCategory" class="form-input">
                        <option value="">Select Category</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Employee</label>
                    <select id="eventEmployee" class="form-input">
                        <option value="">Select Employee</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select id="eventStatus" class="form-input">
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="OVERDUE">Overdue</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Due Date</label>
                    <input type="date" id="eventDueDate" class="form-input">
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeEventModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="saveEvent()" class="btn btn-primary" id="eventSaveBtn">
                <i class="fas fa-save"></i> Save Event
            </button>
        </div>
    </div>
</div>

<!-- ==================== VIEW EVENT MODAL ==================== -->
<div id="viewEventModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title" id="viewEventTitle">Event Details</div>
                <div class="modal-subtitle" id="viewEventSubtitle">Compliance information</div>
            </div>
            <button class="modal-close" onclick="closeViewEventModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="viewEventBody"></div>
        <div class="modal-footer">
            <button onclick="closeViewEventModal()" class="btn btn-ghost">Close</button>
            <button onclick="editEventFromView()" class="btn btn-primary" id="editFromViewBtn">
                <i class="fas fa-edit"></i> Edit
            </button>
            <button onclick="deleteEventFromView()" class="btn btn-danger" id="deleteFromViewBtn">
                <i class="fas fa-trash"></i> Delete
            </button>
        </div>
    </div>
</div>
<script>
    var contextPath = '${baseUrl}';
    var currentDate = new Date();
    var allEvents = [];
    var selectedDateStr = null;
    var viewingEventId = null;
    var editingEventId = null;
    var employees = [];
    var categories = [];
    var isInitialLoad = true;

    // ==================== TOAST ====================
    function toast(message, type, duration) {
        type = type || 'info';
        duration = duration || 3500;
        var container = document.getElementById('toast-container');
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

    function formatDateForAPI(date) {
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    function formatDisplayDate(dateStr) {
        if (!dateStr) return '—';
        try {
            var date = new Date(dateStr);
            return date.toLocaleDateString('en-IN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch(e) {
            return dateStr;
        }
    }

    function getStatusDisplay(status) {
        var display = {
            'PENDING': 'Pending',
            'IN_PROGRESS': 'In Progress',
            'COMPLETED': 'Completed',
            'OVERDUE': 'Overdue'
        };
        return display[status] || status;
    }

    function getStatusClass(status) {
        var map = {
            'PENDING': 'status-pending',
            'IN_PROGRESS': 'status-in_progress',
            'COMPLETED': 'status-completed',
            'OVERDUE': 'status-overdue'
        };
        return map[status] || 'status-pending';
    }

    function getBadgeClass(status) {
        var map = {
            'PENDING': 'badge-warning',
            'IN_PROGRESS': 'badge-info',
            'COMPLETED': 'badge-success',
            'OVERDUE': 'badge-danger'
        };
        return map[status] || 'badge-warning';
    }

    function getDaysRemaining(dueDate) {
        if (!dueDate) return null;
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueDate);
        due.setHours(0, 0, 0, 0);
        return Math.ceil((due - today) / (1000 * 60 * 60 * 24));
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
        return 'fa-tasks';
    }

    function getFrequencyLabel(freq) {
        var map = {
            'MONTHLY': 'Monthly',
            'QUARTERLY': 'Quarterly',
            'HALF_YEARLY': 'Half Yearly',
            'YEARLY': 'Yearly',
            'ONE_TIME': 'One Time'
        };
        return map[freq] || freq || '—';
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

    // ==================== LOAD DATA ====================
    async function loadEmployees() {
        try {
            var data = await api('/api/company-admin/employees?page=0&size=1000');
            if (data && data.success) {
                employees = data.data.content || [];
                var select = document.getElementById('eventEmployee');
                select.innerHTML = '<option value="">Select Employee</option>';
                for (var i = 0; i < employees.length; i++) {
                    var emp = employees[i];
                    var fullName = emp.fullName || emp.firstName + ' ' + emp.lastName;
                    select.innerHTML += '<option value="' + emp.id + '">' + escapeHtml(fullName) + '</option>';
                }
            }
        } catch(e) {
            console.error('Error loading employees:', e);
        }
    }

    async function loadCategories() {
        try {
            var data = await api('/api/company-admin/compliance/assigned');
            if (data && data.success) {
                var allCompliances = data.data || [];
                var uniqueCategories = [];
                var seen = new Set();

                for (var i = 0; i < allCompliances.length; i++) {
                    var item = allCompliances[i];
                    if (!seen.has(item.templateId)) {
                        seen.add(item.templateId);
                        uniqueCategories.push({
                            id: item.templateId,
                            name: item.templateName
                        });
                    }
                }

                categories = uniqueCategories;
                var select = document.getElementById('eventCategory');
                select.innerHTML = '<option value="">Select Category</option>';
                for (var i = 0; i < categories.length; i++) {
                    select.innerHTML += '<option value="' + categories[i].id + '">' + escapeHtml(categories[i].name) + '</option>';
                }
            }
        } catch(e) {
            console.error('Error loading categories:', e);
        }
    }

    // ==================== LOAD EVENTS FROM ASSIGNED COMPLIANCES ====================
    async function loadEvents() {
        try {
            var data = await api('/api/company-admin/compliance/assigned');

            if (data && data.success) {
                var compliances = data.data || [];

                allEvents = [];
                var today = new Date();
                today.setHours(0, 0, 0, 0);

                for (var i = 0; i < compliances.length; i++) {
                    var c = compliances[i];

                    var status = c.status || 'PENDING';
                    if (c.effectiveDueDate) {
                        var due = new Date(c.effectiveDueDate);
                        due.setHours(0, 0, 0, 0);
                        if (due < today && status !== 'COMPLETED') {
                            status = 'OVERDUE';
                        }
                    }

                    var event = {
                        id: c.id || i,
                        title: c.subTemplateName || c.templateName || 'Compliance',
                        description: c.description || 'No description',
                        category: c.templateName || 'Compliance',
                        categoryId: c.templateId,
                        status: status,
                        startDate: c.effectiveDueDate || c.dueDate,
                        endDate: c.effectiveDueDate || c.dueDate,
                        assignedTo: null,
                        employeeId: null,
                        isSubCompliance: c.subTemplateId !== null && c.subTemplateId !== undefined,
                        parentTemplateId: c.templateId,
                        templateId: c.templateId,
                        subTemplateName: c.subTemplateName,
                        templateName: c.templateName,
                        frequency: c.frequency,
                        configured: c.configured,
                        companyId: c.companyId,
                        companyName: c.companyName,
                        isSuperAdminConfig: c.isSuperAdminConfig,
                        priority: c.priority || 0
                    };

                    allEvents.push(event);
                }

                try {
                    var assignData = await api('/api/company-admin/compliance/assignments?page=0&size=1000');
                    if (assignData && assignData.success) {
                        var assignments = assignData.data.content || [];
                        for (var j = 0; j < assignments.length; j++) {
                            var a = assignments[j];
                            if (a.employeeName) {
                                for (var k = 0; k < allEvents.length; k++) {
                                    if (allEvents[k].id === a.configId ||
                                        (allEvents[k].subTemplateName && allEvents[k].subTemplateName === a.complianceName)) {
                                        allEvents[k].assignedTo = a.employeeName;
                                        allEvents[k].employeeId = a.employeeId;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                } catch(e) {
                    console.log('Could not load employee assignments:', e);
                }

                updateStats();
                renderCalendar();

                if (isInitialLoad) {
                    isInitialLoad = false;
                    var todayStr = formatDateForAPI(today);
                    var todayEvents = allEvents.filter(function(e) {
                        return e.startDate === todayStr;
                    });
                    if (todayEvents.length > 0) {
                        setTimeout(function() {
                            selectDate(todayStr);
                        }, 300);
                    }
                }
            } else {
                toast('Failed to load compliances', 'error');
            }
        } catch(e) {
            console.error('Error loading events:', e);
            toast('Failed to load events', 'error');
        }
    }

    // ==================== UPDATE STATS ====================
    function updateStats() {
        var total = allEvents.length;
        var completed = allEvents.filter(function(e) { return e.status === 'COMPLETED'; }).length;
        var pending = allEvents.filter(function(e) { return e.status === 'PENDING'; }).length;
        var inProgress = allEvents.filter(function(e) { return e.status === 'IN_PROGRESS'; }).length;
        var overdue = allEvents.filter(function(e) { return e.status === 'OVERDUE'; }).length;

        document.getElementById('statTotal').textContent = total;
        document.getElementById('statCompleted').textContent = completed;
        document.getElementById('statPending').textContent = pending;
        document.getElementById('statInProgress').textContent = inProgress;
        document.getElementById('statOverdue').textContent = overdue;
    }

    // ==================== FILTER ====================
    function filterByStatus(status) {
        if (status === 'all') {
            renderCalendar();
            if (selectedDateStr) {
                selectDate(selectedDateStr);
            }
            return;
        }

        var cells = document.querySelectorAll('.calendar-table td');
        for (var i = 0; i < cells.length; i++) {
            var cell = cells[i];
            var dateStr = cell.getAttribute('data-date');
            if (dateStr) {
                var eventsOnDate = allEvents.filter(function(e) {
                    return e.startDate === dateStr && e.status === status;
                });
                if (eventsOnDate.length > 0) {
                    cell.style.backgroundColor = 'rgba(79,70,229,0.06)';
                    cell.style.border = '2px solid var(--primary)';
                } else {
                    cell.style.backgroundColor = '';
                    cell.style.border = '';
                }
            }
        }

        toast('Showing ' + getStatusDisplay(status) + ' events', 'info');
    }

    // ==================== RENDER CALENDAR ====================
    function renderCalendar() {
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth();

        var monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        document.getElementById('currentMonthYear').textContent = monthNames[month] + ' ' + year;

        var firstDay = new Date(year, month, 1);
        var startDayOfWeek = firstDay.getDay();
        var daysInMonth = new Date(year, month + 1, 0).getDate();

        var prevMonthDate = new Date(year, month, 0);
        var prevMonthDays = prevMonthDate.getDate();

        var today = new Date();
        var todayStr = formatDateForAPI(today);

        var html = '<table class="calendar-table"><thead><tr>';
        var weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        for (var i = 0; i < weekDays.length; i++) {
            html += '<th>' + weekDays[i] + '</th>';
        }
        html += '</tr></thead><tbody><tr>';

        var dayCount = 1;
        var nextMonthDayCount = 1;

        for (var i = 0; i < 42; i++) {
            var cellDate = null;
            var isCurrentMonth = false;
            var displayDay = null;
            var cellYear = year;
            var cellMonth = month;

            if (i < startDayOfWeek) {
                displayDay = prevMonthDays - (startDayOfWeek - i) + 1;
                var prevDate = new Date(year, month - 1, displayDay);
                cellYear = prevDate.getFullYear();
                cellMonth = prevDate.getMonth();
                cellDate = new Date(cellYear, cellMonth, displayDay);
                isCurrentMonth = false;
            } else if (dayCount <= daysInMonth) {
                displayDay = dayCount;
                cellDate = new Date(year, month, displayDay);
                isCurrentMonth = true;
                dayCount++;
            } else {
                displayDay = nextMonthDayCount;
                var nextDate = new Date(year, month + 1, displayDay);
                cellYear = nextDate.getFullYear();
                cellMonth = nextDate.getMonth();
                cellDate = new Date(cellYear, cellMonth, displayDay);
                isCurrentMonth = false;
                nextMonthDayCount++;
            }

            var dateStr = cellYear + '-' + String(cellMonth + 1).padStart(2, '0') + '-' + String(displayDay).padStart(2, '0');
            var isToday = (dateStr === todayStr);
            var isSelected = (selectedDateStr === dateStr);

            var eventsOnDate = allEvents.filter(function(e) {
                return e.startDate === dateStr;
            });

            var cellClass = '';
            if (!isCurrentMonth) cellClass += ' other-month';
            if (isToday) cellClass += ' today-date';

            html += '<td class="' + cellClass + '" data-date="' + dateStr + '" onclick="selectDate(\'' + dateStr + '\')">';
            html += '<div class="calendar-date-cell">';

            var dateNumberClass = 'calendar-date-number';
            if (!isCurrentMonth) dateNumberClass += ' other-month';

            html += '<div class="' + dateNumberClass + '">' + displayDay + '</div>';

            var displayEvents = eventsOnDate.slice(0, 3);
            for (var e = 0; e < displayEvents.length; e++) {
                var event = displayEvents[e];
                var statusClass = getStatusClass(event.status);
                var eventTitle = event.title || 'Compliance';
                if (event.isSubCompliance) {
                    eventTitle = '↳ ' + eventTitle;
                }
                html += '<div class="calendar-event-item ' + statusClass + '" onclick="event.stopPropagation();viewEvent(' + event.id + ')">' +
                    escapeHtml(eventTitle.length > 20 ? eventTitle.substring(0, 18) + '...' : eventTitle) +
                    '</div>';
            }

            if (eventsOnDate.length > 3) {
                html += '<div class="event-more" onclick="event.stopPropagation();selectDate(\'' + dateStr + '\')">+' + (eventsOnDate.length - 3) + ' more</div>';
            }

            html += '</div></td>';

            if ((i + 1) % 7 === 0 && i < 41) {
                html += '</tr><tr>';
            }
        }

        html += '</tr></tbody></table>';
        document.getElementById('calendarTable').innerHTML = html;
    }

    // ==================== SIDE PANEL ====================
    function selectDate(dateStr) {
        selectedDateStr = dateStr;

        var dateParts = dateStr.split('-');
        var displayDate = new Date(parseInt(dateParts[0]), parseInt(dateParts[1]) - 1, parseInt(dateParts[2]));
        var formattedDate = displayDate.toLocaleDateString('en-IN', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('selectedDateTitle').textContent = formattedDate;

        var dayEvents = allEvents.filter(function(event) {
            return event.startDate === dateStr;
        });

        updateDayStats(dayEvents);
        renderDayEvents(dayEvents);
        openSidePanel();

        renderCalendar();
    }

    function updateDayStats(events) {
        var total = events.length;
        var pending = events.filter(function(e) { return e.status === 'PENDING'; }).length;
        var completed = events.filter(function(e) { return e.status === 'COMPLETED'; }).length;
        var overdue = events.filter(function(e) { return e.status === 'OVERDUE'; }).length;
        var inProgress = events.filter(function(e) { return e.status === 'IN_PROGRESS'; }).length;

        var statsHtml =
            '<div class="day-stat-badge"><div class="count" style="color:var(--primary-light);">' + total + '</div><div class="label">Total</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--warning);">' + pending + '</div><div class="label">Pending</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--info);">' + inProgress + '</div><div class="label">In Progress</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--success);">' + completed + '</div><div class="label">Completed</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--danger);">' + overdue + '</div><div class="label">Overdue</div></div>';

        document.getElementById('dayStats').innerHTML = statsHtml;
    }

    function renderDayEvents(events) {
        var container = document.getElementById('dayEventsList');

        if (!events.length) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-calendar-day"></i><p>No events on this day</p></div>';
            return;
        }

        events.sort(function(a, b) {
            if (a.status === 'OVERDUE' && b.status !== 'OVERDUE') return -1;
            if (b.status === 'OVERDUE' && a.status !== 'OVERDUE') return 1;
            var priorityA = a.priority || 0;
            var priorityB = b.priority || 0;
            if (priorityA !== priorityB) return priorityA - priorityB;
            return a.title.localeCompare(b.title);
        });

        var html = '';
        for (var i = 0; i < events.length; i++) {
            var e = events[i];
            var statusClass = getStatusClass(e.status);
            var badgeClass = getBadgeClass(e.status);
            var daysRemaining = getDaysRemaining(e.startDate);
            var daysText = '';
            if (e.status !== 'COMPLETED' && daysRemaining !== null) {
                if (daysRemaining < 0) {
                    daysText = '<span style="color:var(--danger);font-weight:600;">Overdue by ' + Math.abs(daysRemaining) + ' days</span>';
                } else if (daysRemaining <= 3) {
                    daysText = '<span style="color:var(--warning);font-weight:600;">Due in ' + daysRemaining + ' days</span>';
                } else {
                    daysText = '<span>Due in ' + daysRemaining + ' days</span>';
                }
            } else if (e.status === 'COMPLETED') {
                daysText = '<span style="color:var(--success);">Completed</span>';
            }

            var icon = getComplianceIcon(e.category);
            var subLabel = e.isSubCompliance ? ' <span style="font-size:9px;color:var(--gray-400);">(Sub)</span>' : '';

            html += '<div class="event-item ' + statusClass + '" onclick="viewEvent(' + e.id + ')">' +
                '<div class="event-top">' +
                '<span class="event-name">' +
                '<i class="fas ' + icon + '" style="color:#e9d80f;font-size:11px;margin-right:4px;"></i>' +
                escapeHtml(e.title) + subLabel +
                '</span>' +
                '<span class="badge ' + badgeClass + '">' + getStatusDisplay(e.status) + '</span>' +
                '</div>' +
                (e.description && e.description !== 'No description' ? '<div style="font-size:12px;color:var(--gray-500);margin-bottom:6px;">' + escapeHtml(e.description) + '</div>' : '') +
                '<div class="event-meta">' +
                '<i class="fas fa-tag"></i> ' + escapeHtml(e.category || 'Uncategorized') +
                (e.frequency ? ' | <i class="fas fa-redo"></i> ' + getFrequencyLabel(e.frequency) : '') +
                (e.assignedTo ? ' | <i class="fas fa-user"></i> ' + escapeHtml(e.assignedTo) : '') +
                '</div>' +
                (daysText ? '<div class="event-meta" style="margin-top:4px;">' + daysText + '</div>' : '') +
                '<div class="event-actions">' +
                '<button onclick="event.stopPropagation();viewEvent(' + e.id + ')" class="btn btn-ghost btn-sm"><i class="fas fa-eye"></i> View</button>' +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    function openSidePanel() {
        document.getElementById('sidePanel').classList.add('open');
    }

    function closeSidePanel() {
        document.getElementById('sidePanel').classList.remove('open');
        selectedDateStr = null;
        renderCalendar();
    }

    // ==================== VIEW EVENT (NO EDIT/DELETE) ====================
    function viewEvent(eventId) {
        var event = allEvents.find(function(e) { return e.id === eventId; });
        if (!event) {
            toast('Event not found', 'error');
            return;
        }

        viewingEventId = eventId;
        document.getElementById('viewEventTitle').textContent = event.title || 'Event Details';
        document.getElementById('viewEventSubtitle').textContent = (event.isSubCompliance ? 'Sub-Compliance' : 'Compliance') + ' Information';

        var icon = getComplianceIcon(event.category || '');
        var statusClass = getBadgeClass(event.status);
        var daysRemaining = getDaysRemaining(event.startDate);
        var daysText = '';
        if (event.status !== 'COMPLETED' && daysRemaining !== null) {
            daysText = daysRemaining < 0 ? 'Overdue by ' + Math.abs(daysRemaining) + ' days' : daysRemaining + ' days remaining';
        } else if (event.status === 'COMPLETED') {
            daysText = 'Completed';
        }

        var html =
            '<div style="display:flex;flex-direction:column;gap:16px;">' +
            '<div style="display:flex;align-items:center;gap:12px;">' +
            '<div style="width:48px;height:48px;border-radius:50%;background:rgb(0,0,0);border:1.5px solid rgba(79,70,229,0.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
            '<i class="fas ' + icon + '" style="color:#e9d80f;font-size:20px;"></i>' +
            '</div>' +
            '<div>' +
            '<div style="font-weight:700;font-size:16px;color:var(--gray-900);">' + escapeHtml(event.title) + '</div>' +
            '<div style="font-size:12px;color:var(--gray-500);">' + escapeHtml(event.category || 'Uncategorized') +
            (event.isSubCompliance ? ' <span style="color:var(--primary);font-weight:500;">(Sub-Compliance)</span>' : '') +
            '</div>' +
            '</div>' +
            '</div>' +

            '<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">' +
            '<div style="background:rgba(226,232,240,0.12);padding:10px 14px;border-radius:8px;">' +
            '<div style="font-size:9px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.3px;">Status</div>' +
            '<div style="margin-top:4px;"><span class="badge ' + statusClass + '">' + getStatusDisplay(event.status) + '</span></div>' +
            '</div>' +
            '<div style="background:rgba(226,232,240,0.12);padding:10px 14px;border-radius:8px;">' +
            '<div style="font-size:9px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.3px;">Due Date</div>' +
            '<div style="margin-top:4px;font-weight:600;color:var(--gray-800);">' + formatDisplayDate(event.startDate) + '</div>' +
            '</div>' +
            (event.frequency ? '<div style="background:rgba(226,232,240,0.12);padding:10px 14px;border-radius:8px;">' +
                '<div style="font-size:9px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.3px;">Frequency</div>' +
                '<div style="margin-top:4px;font-weight:500;color:var(--gray-800);">' + getFrequencyLabel(event.frequency) + '</div>' +
                '</div>' : '') +
            (event.assignedTo ? '<div style="background:rgba(226,232,240,0.12);padding:10px 14px;border-radius:8px;">' +
                '<div style="font-size:9px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.3px;">Assigned To</div>' +
                '<div style="margin-top:4px;font-weight:500;color:var(--gray-800);">' + escapeHtml(event.assignedTo) + '</div>' +
                '</div>' : '') +
            (event.isSuperAdminConfig !== undefined ? '<div style="background:rgba(226,232,240,0.12);padding:10px 14px;border-radius:8px;">' +
                '<div style="font-size:9px;color:var(--gray-500);text-transform:uppercase;letter-spacing:0.3px;">Type</div>' +
                '<div style="margin-top:4px;font-weight:500;color:var(--gray-800);">' + (event.isSuperAdminConfig ? 'SuperAdmin Created' : 'Custom') + '</div>' +
                '</div>' : '') +
            '</div>' +

            (event.description && event.description !== 'No description' ? '<div style="background:rgba(226,232,240,0.08);padding:12px 14px;border-radius:8px;">' +
                '<div style="font-size:11px;color:var(--gray-500);margin-bottom:4px;">Description</div>' +
                '<div style="font-size:13px;color:var(--gray-700);line-height:1.5;">' + escapeHtml(event.description) + '</div>' +
                '</div>' : '') +

            (event.isSubCompliance && event.templateName ? '<div style="font-size:12px;color:var(--gray-500);">' +
                '<i class="fas fa-folder-open"></i> Parent: ' + escapeHtml(event.templateName) +
                '</div>' : '') +

            '<div style="font-size:12px;color:var(--gray-500);">' +
            '<i class="far fa-clock"></i> ' + daysText +
            '</div>' +

            // View Full Compliance Details link
            (event.templateId ? '<div style="margin-top:8px;padding-top:12px;border-top:1px solid rgba(226,232,240,0.3);">' +
                '<a href="' + contextPath + '/company-admin/compliance/parent/' + event.templateId + '" class="btn btn-primary btn-block" style="text-align:center;width:100%;">' +
                '<i class="fas fa-arrow-right"></i> View Full Compliance Details' +
                '</a>' +
                '</div>' : '') +

            '</div>';

        document.getElementById('viewEventBody').innerHTML = html;

        // Hide edit and delete buttons
        document.getElementById('editFromViewBtn').style.display = 'none';
        document.getElementById('deleteFromViewBtn').style.display = 'none';

        document.getElementById('viewEventModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeViewEventModal() {
        document.getElementById('viewEventModal').style.display = 'none';
        document.body.style.overflow = '';
        viewingEventId = null;
    }

    // ==================== NAVIGATION ====================
    function previousMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
        selectedDateStr = null;
        closeSidePanel();
        loadEvents();
    }

    function nextMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
        selectedDateStr = null;
        closeSidePanel();
        loadEvents();
    }

    function goToToday() {
        var today = new Date();
        currentDate = new Date(today.getFullYear(), today.getMonth(), 1);
        selectedDateStr = null;
        closeSidePanel();
        loadEvents();
        setTimeout(function() {
            var todayStr = formatDateForAPI(today);
            selectDate(todayStr);
        }, 300);
    }

    function refreshCalendar() {
        loadEvents();
        toast('Calendar refreshed', 'info');
    }

    // ==================== EXPORT ====================
    function exportCalendar() {
        if (!allEvents.length) {
            toast('No data to export', 'error');
            return;
        }

        var rows = [['Date', 'Event Title', 'Category', 'Status', 'Frequency', 'Type', 'Assigned To', 'Description']];
        for (var i = 0; i < allEvents.length; i++) {
            var e = allEvents[i];
            rows.push([
                e.startDate || '',
                e.title || '',
                e.category || '—',
                getStatusDisplay(e.status),
                getFrequencyLabel(e.frequency),
                e.isSubCompliance ? 'Sub-Compliance' : 'Compliance',
                e.assignedTo || '—',
                e.description || '—'
            ]);
        }

        var csv = rows.map(function(row) {
            return row.map(function(cell) {
                return '"' + String(cell).replace(/"/g, '""') + '"';
            }).join(',');
        }).join('\n');

        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement('a');
        var url = URL.createObjectURL(blob);
        link.href = url;
        link.setAttribute('download', 'compliance_calendar_export.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
        toast('Export complete', 'success');
    }

    // ==================== OPEN CUSTOM COMPLIANCE ====================
    function openCustomModal() {
        // Redirect to the custom compliance creation page
        window.location.href = contextPath + '/company-admin/compliance/custom/create';
    }

    // ==================== MODAL OVERLAY CLOSE ====================
    document.getElementById('eventModal').addEventListener('click', function(e) {
        if (e.target === this) closeEventModal();
    });

    document.getElementById('viewEventModal').addEventListener('click', function(e) {
        if (e.target === this) closeViewEventModal();
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

        Promise.all([loadEmployees(), loadCategories()]).then(function() {
            var today = new Date();
            currentDate = new Date(today.getFullYear(), today.getMonth(), 1);
            loadEvents();
        }).catch(function(error) {
            console.error('Error loading data:', error);
            toast('Failed to load calendar data', 'error');
        });
    });
</script>
</body>
</html>