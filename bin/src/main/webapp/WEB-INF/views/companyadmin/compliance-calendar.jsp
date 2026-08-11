<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% pageContext.setAttribute("pageTitle", "Compliance Calendar"); %>

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

        .filter-bar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: center;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .filter-bar .form-input {
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
            flex: 1;
            min-width: 140px;
        }

        .filter-bar .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            background: rgba(255, 255, 255, 0.8);
        }

        .filter-bar .form-input::placeholder {
            color: var(--gray-400);
        }

        .filter-bar select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .calendar-container {
            display: flex;
            gap: 20px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            min-height: 600px;
        }

        .calendar-main {
            flex: 1;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            min-width: 0;
        }

        .calendar-main.shrink {
            flex: 0.5;
        }

        .calendar-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            height: 100%;
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

        .calendar-table td.selected-date {
            background: rgba(79, 70, 229, 0.08);
            border: 2px solid var(--primary);
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
            width: 0;
            opacity: 0;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            display: none;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            height: 100%;
            min-height: 500px;
            flex-shrink: 0;
        }

        .side-panel.open {
            width: 45%;
            opacity: 1;
            display: block;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .side-panel .panel-content {
            padding: 24px;
            height: 100%;
            display: flex;
            flex-direction: column;
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
            font-size: 20px;
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
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .day-stat-badge {
            background: rgba(226, 232, 240, 0.12);
            border-radius: var(--radius);
            padding: 8px 14px;
            text-align: center;
            flex: 1;
            min-width: 60px;
        }

        .day-stat-badge .count {
            font-size: 20px;
            font-weight: 700;
        }

        .day-stat-badge .label {
            font-size: 10px;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .day-events-list {
            flex: 1;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 400px;
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
            margin-bottom: 6px;
            gap: 10px;
        }

        .event-item .event-top .event-name {
            font-weight: 600;
            font-size: 14px;
            color: var(--gray-800);
        }

        .event-item .event-meta {
            font-size: 12px;
            color: var(--gray-500);
        }

        .event-item .event-meta i {
            margin-right: 4px;
            font-size: 11px;
        }

        .event-item .event-actions {
            display: flex;
            gap: 6px;
            margin-top: 8px;
            flex-wrap: wrap;
        }

        /* ==================== CREATE MODAL ==================== */
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

        .form-group {
            margin-bottom: 16px;
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
            padding: 6px 12px;
            font-size: 12px;
        }

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

        .legend-bar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 12px 20px;
            margin-top: 20px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .legend-bar .legend-items {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: center;
        }

        .legend-bar .legend-items .legend-label {
            font-size: 11px;
            color: var(--gray-500);
        }

        .legend-dot {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 3px;
            margin-right: 4px;
        }

        .legend-dot.pending { background: var(--warning); }
        .legend-dot.in-progress { background: var(--primary); }
        .legend-dot.completed { background: var(--success); }
        .legend-dot.overdue { background: var(--danger); }
        .legend-dot.today { width: 8px; height: 8px; border-radius: 50%; background: var(--primary); }

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
            .calendar-container { flex-direction: column; }
            .calendar-main.shrink { flex: 1; }
            .side-panel.open { width: 100%; }
            .filter-bar { flex-direction: column; }
            .filter-bar .form-input { width: 100%; }
        }

        @media (max-width: 768px) {
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .calendar-table td { height: 60px; }
            .calendar-event-item { font-size: 8px; white-space: normal; }
            .calendar-nav .nav-title { font-size: 16px; }
            .day-stats { gap: 6px; }
            .day-stat-badge { padding: 6px 8px; min-width: 40px; }
            .day-stat-badge .count { font-size: 16px; }
            .side-panel.open { width: 100%; }
            .side-panel .panel-content { padding: 16px; }
        }

        @media (max-width: 480px) {
            .calendar-nav { flex-direction: column; align-items: stretch; }
            .calendar-nav .nav-left { justify-content: center; }
            .calendar-nav .nav-title { text-align: center; font-size: 18px; }
            .calendar-table th { font-size: 9px; padding: 6px; }
            .calendar-table td { height: 50px; }
            .calendar-date-number { font-size: 12px; width: 22px; height: 22px; }
            .calendar-event-item { font-size: 7px; padding: 1px 4px; }
            .legend-bar .legend-items { gap: 10px; }
            .legend-bar .legend-items span { font-size: 10px; }
            .modal-box { max-width: 100%; margin: 10px; }
            .modal-body { padding: 16px; }
            .modal-header { padding: 16px; }
            .modal-footer { padding: 12px 16px; flex-wrap: wrap; }
            .modal-footer .btn { flex: 1; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="logo-bg">
    <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<div class="toast-container" id="toastContainer"></div>

<div class="app-wrapper">

    <aside class="sidebar" id="sidebar">
            <div class="sidebar-brand">
                <div class="brand-icon">
                 <img style="width:100%;"  src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
                </div>
                <span class="brand-text">VNext Legal</span>
                <span class="brand-badge">LLP</span>
            </div>

            <div class="sidebar-label">Main</div>
            <a href="${pageContext.request.contextPath}/company-admin/dashboard" class="nav-item active">
                <i class="fas fa-chart-pie"></i> Dashboard
            </a>

            <div class="sidebar-label">Management</div>
            <a href="${pageContext.request.contextPath}/company-admin/employees" class="nav-item">
                <i class="fas fa-users"></i> Employees
                <span class="nav-badge" id="employeeCount">0</span>
            </a>

            <div class="sidebar-label">Compliance</div>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/list" class="nav-item">
                <i class="fas fa-tasks"></i> My Compliances
            </a>
            <a href="${pageContext.request.contextPath}/company-admin/compliance/custom/create" class="nav-item">
                <i class="fas fa-plus-circle"></i> Custom Compliance
            </a>

            <div class="sidebar-label">Communication</div>
            <a href="${pageContext.request.contextPath}/company-admin/notifications" class="nav-item ">
                <i class="fas fa-bell"></i> Notifications
                <span class="nav-badge" id="notifCount">0</span>
            </a>

            <div class="sidebar-label">Account</div>
            <a href="${pageContext.request.contextPath}/company-admin/change-password" class="nav-item">
                <i class="fas fa-key"></i> Change Password
            </a>

            <div style="margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(226, 232, 240, 0.6);">
                <a href="#" onclick="handleLogout()" class="nav-item" style="color: var(--gray-400);">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </aside>

    <header class="header">
        <div class="header-left">
            <button class="menu-toggle" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </button>
            <span class="page-title">Compliance Calendar</span>
        </div>
        <div class="header-right">
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/company-admin/profile'">
                <div class="avatar" id="userAvatar">U</div>
                <div class="user-info">
                    <span class="user-name" id="userName">User</span>
                    <span class="user-role" id="userRole">Company Admin</span>
                </div>
            </div>
        </div>
    </header>

    <main class="main-content">

        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/company-admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <span class="sep"><i class="fas fa-chevron-right" style="font-size:9px;"></i></span>
            <span class="current">Compliance Calendar</span>
        </div>

        <div style="margin-bottom: 24px;">
            <p style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                Compliance Management
            </p>
            <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">Compliance Calendar</h1>
            <p style="font-size:13px;color:var(--gray-500);margin-top:4px;">
                View all compliance due dates and assignments. Click on any date to see details.
            </p>
        </div>

        <div class="filter-bar">
            <select id="employeeFilter" class="form-input">
                <option value="">All Employees</option>
            </select>
            <select id="statusFilter" class="form-input">
                <option value="">All Status</option>
                <option value="PENDING">Pending</option>
                <option value="IN_PROGRESS">In Progress</option>
                <option value="COMPLETED">Completed</option>
                <option value="OVERDUE">Overdue</option>
            </select>
            <select id="categoryFilter" class="form-input">
                <option value="">All Categories</option>
            </select>
            <button onclick="resetFilters()" class="btn btn-ghost">
                <i class="fas fa-undo"></i> Reset
            </button>
            <button onclick="refreshCalendar()" class="btn btn-primary">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
            <button onclick="exportCalendarData()" class="btn btn-ghost">
                <i class="fas fa-download"></i> Export
            </button>
        </div>

        <div class="calendar-container" id="calendarContainer">

            <div class="calendar-main" id="calendarMain">
                <div class="calendar-card">
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
                    </div>

                    <div class="calendar-grid" id="calendarGrid">
                        <div id="calendarTable"></div>
                    </div>
                </div>
            </div>

            <div class="side-panel" id="sidePanel">
                <div class="panel-content">
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

                    <div style="flex:1;overflow-y:auto;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                            <div style="font-size:12px;font-weight:600;color:var(--gray-500);">
                                <i class="fas fa-list"></i> Events on this day
                            </div>
                            <button onclick="openCreateModal()" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus"></i> Add Event
                            </button>
                        </div>
                        <div class="day-events-list" id="dayEventsList"></div>
                    </div>
                </div>
            </div>

        </div>

        <div class="legend-bar">
            <div class="legend-items">
                <span class="legend-label"><i class="fas fa-info-circle"></i> Event Types:</span>
                <span><span class="legend-dot pending"></span> Pending</span>
                <span><span class="legend-dot in-progress"></span> In Progress</span>
                <span><span class="legend-dot completed"></span> Completed</span>
                <span><span class="legend-dot overdue"></span> Overdue</span>
                <span><span class="legend-dot today"></span> Today</span>
            </div>
        </div>

    </main>
</div>

<!-- ==================== CREATE MODAL ==================== -->
<div id="createModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-plus-circle" style="color:var(--primary);margin-right:8px;"></i>Create Compliance Event</div>
                <div class="modal-subtitle" id="createModalSubtitle">Add a new compliance event for this date</div>
            </div>
            <button class="modal-close" onclick="closeCreateModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="createForm" onsubmit="return false;">
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
                    </select>
                </div>
                <input type="hidden" id="eventDate" />
            </form>
        </div>
        <div class="modal-footer">
            <button onclick="closeCreateModal()" class="btn btn-ghost">Cancel</button>
            <button onclick="createEvent()" class="btn btn-primary" id="createBtn">
                <i class="fas fa-save"></i> Create Event
            </button>
        </div>
    </div>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var currentDate = new Date();
    var allEventsData = [];
    var selectedDateStr = null;
    var isSidePanelOpen = false;
    var employees = [];
    var categories = [];
    var isInitialLoad = true;

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
                var select = document.getElementById('employeeFilter');
                select.innerHTML = '<option value="">All Employees</option>';
                for (var i = 0; i < employees.length; i++) {
                    var emp = employees[i];
                    var fullName = emp.fullName || emp.firstName + ' ' + emp.lastName;
                    select.innerHTML += '<option value="' + emp.id + '">' + escapeHtml(fullName) + '</option>';
                }
                // Also populate employee dropdown in create modal
                var createSelect = document.getElementById('eventEmployee');
                createSelect.innerHTML = '<option value="">Select Employee</option>';
                for (var i = 0; i < employees.length; i++) {
                    var emp = employees[i];
                    var fullName = emp.fullName || emp.firstName + ' ' + emp.lastName;
                    createSelect.innerHTML += '<option value="' + emp.id + '">' + escapeHtml(fullName) + '</option>';
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
                    if (!item.subTemplateId && !seen.has(item.templateId)) {
                        seen.add(item.templateId);
                        uniqueCategories.push({
                            id: item.templateId,
                            name: item.templateName
                        });
                    }
                }

                categories = uniqueCategories;
                var select = document.getElementById('categoryFilter');
                select.innerHTML = '<option value="">All Categories</option>';
                for (var i = 0; i < categories.length; i++) {
                    select.innerHTML += '<option value="' + categories[i].id + '">' + escapeHtml(categories[i].name) + '</option>';
                }
                // Also populate category dropdown in create modal
                var createSelect = document.getElementById('eventCategory');
                createSelect.innerHTML = '<option value="">Select Category</option>';
                for (var i = 0; i < categories.length; i++) {
                    createSelect.innerHTML += '<option value="' + categories[i].id + '">' + escapeHtml(categories[i].name) + '</option>';
                }
            }
        } catch(e) {
            console.error('Error loading categories:', e);
        }
    }

    async function loadEventsAndRender() {
        var startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        var endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

        var employeeId = document.getElementById('employeeFilter').value;
        var status = document.getElementById('statusFilter').value;
        var categoryId = document.getElementById('categoryFilter').value;

        var start = formatDateForAPI(startDate);
        var end = formatDateForAPI(endDate);

        var url = '/api/company-admin/compliance/calendar?startDate=' + start + '&endDate=' + end;
        if (employeeId) url += '&employeeId=' + employeeId;
        if (status) url += '&status=' + status;
        if (categoryId) url += '&categoryId=' + categoryId;

        try {
            var data = await api(url);
            if (data && data.success) {
                allEventsData = data.data || [];
                var totalEvents = allEventsData.length;
                document.getElementById('calendarBadge').textContent = totalEvents;
                renderCalendar();

                // Auto-select today on initial load only
                if (isInitialLoad) {
                    isInitialLoad = false;
                    var today = new Date();
                    var todayStr = formatDateForAPI(today);
                    // Check if there are events today
                    var todayEvents = allEventsData.filter(function(e) { return e.startDate === todayStr; });
                    if (todayEvents.length > 0) {
                        setTimeout(function() {
                            selectDate(todayStr, today.getFullYear(), today.getMonth(), today.getDate());
                        }, 300);
                    }
                }
            } else {
                toast('Failed to load events', 'error');
            }
        } catch(e) {
            console.error('Error loading events:', e);
            toast('Failed to load events', 'error');
        }
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

            var eventsOnDate = allEventsData.filter(function(e) {
                return e.startDate === dateStr;
            });

            var cellClass = '';
            if (!isCurrentMonth) cellClass += ' other-month';
            if (isSelected) cellClass += ' selected-date';
            if (isToday) cellClass += ' today-date';

            html += '<td class="' + cellClass + '" data-date="' + dateStr + '">';
            html += '<div class="calendar-date-cell">';

            var dateNumberClass = 'calendar-date-number';
            if (!isCurrentMonth) dateNumberClass += ' other-month';

            html += '<div class="' + dateNumberClass + '">' + displayDay + '</div>';

            var displayEvents = eventsOnDate.slice(0, 3);
            for (var e = 0; e < displayEvents.length; e++) {
                var event = displayEvents[e];
                var statusClass = getStatusClass(event.status);
                var eventTitle = event.title || 'Compliance';
                html += '<div class="calendar-event-item ' + statusClass + '" data-event-id="' + event.id + '" onclick="event.stopPropagation();viewEvent(' + event.id + ')">' +
                    escapeHtml(eventTitle.length > 20 ? eventTitle.substring(0, 18) + '...' : eventTitle) +
                    '</div>';
            }

            if (eventsOnDate.length > 3) {
                html += '<div class="event-more" onclick="event.stopPropagation();selectDate(\'' + dateStr + '\', ' + cellYear + ', ' + cellMonth + ', ' + displayDay + ')">+' + (eventsOnDate.length - 3) + ' more</div>';
            }

            html += '</div></td>';

            if ((i + 1) % 7 === 0 && i < 41) {
                html += '</tr><tr>';
            }
        }

        html += '</tr></tbody></table>';
        document.getElementById('calendarTable').innerHTML = html;

        attachCalendarEvents();
    }

    function attachCalendarEvents() {
        var cells = document.querySelectorAll('.calendar-table td');
        for (var i = 0; i < cells.length; i++) {
            var cell = cells[i];
            cell.removeEventListener('click', handleCellClick);
            cell.addEventListener('click', handleCellClick);
        }
    }

    function handleCellClick(e) {
        if (e.target.closest('.calendar-event-item') || e.target.closest('.event-more')) {
            return;
        }
        var dateStr = this.getAttribute('data-date');
        if (dateStr) {
            var parts = dateStr.split('-');
            var year = parseInt(parts[0]);
            var month = parseInt(parts[1]) - 1;
            var day = parseInt(parts[2]);
            selectDate(dateStr, year, month, day);
        }
    }

    // ==================== SIDE PANEL ====================
    function selectDate(dateStr, year, month, day) {
        selectedDateStr = dateStr;

        var displayDate = new Date(year, month, day);
        var formattedDate = displayDate.toLocaleDateString('en-IN', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('selectedDateTitle').textContent = formattedDate;

        var dayEvents = allEventsData.filter(function(event) {
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
        var inProgress = events.filter(function(e) { return e.status === 'IN_PROGRESS'; }).length;
        var completed = events.filter(function(e) { return e.status === 'COMPLETED'; }).length;
        var overdue = events.filter(function(e) { return e.status === 'OVERDUE'; }).length;

        var statsHtml =
            '<div class="day-stat-badge"><div class="count" style="color:var(--primary-light);">' + total + '</div><div class="label">Total</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--warning);">' + pending + '</div><div class="label">Pending</div></div>' +
            '<div class="day-stat-badge"><div class="count" style="color:var(--primary-light);">' + inProgress + '</div><div class="label">In Progress</div></div>' +
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

            html += '<div class="event-item ' + statusClass + '" onclick="viewEvent(' + e.id + ')">' +
                '<div class="event-top">' +
                '<span class="event-name">' + escapeHtml(e.title) + '</span>' +
                '<span class="badge ' + badgeClass + '">' + getStatusDisplay(e.status) + '</span>' +
                '</div>' +
                (e.description ? '<div style="font-size:12px;color:var(--gray-500);margin-bottom:6px;">' + escapeHtml(e.description) + '</div>' : '') +
                '<div class="event-meta">' +
                '<i class="fas fa-tag"></i> ' + escapeHtml(e.category || 'Uncategorized') +
                (e.assignedTo ? ' | <i class="fas fa-user"></i> ' + escapeHtml(e.assignedTo) : '') +
                '</div>' +
                (daysText ? '<div class="event-meta" style="margin-top:4px;">' + daysText + '</div>' : '') +
                '<div class="event-actions">' +
                '<button onclick="event.stopPropagation();window.location.href=contextPath+\'/company-admin/compliance/compliance/' + e.id + '\'" class="btn btn-ghost btn-sm"><i class="fas fa-eye"></i> View</button>' +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    function openSidePanel() {
        var main = document.getElementById('calendarMain');
        var panel = document.getElementById('sidePanel');
        main.classList.add('shrink');
        panel.classList.add('open');
        isSidePanelOpen = true;
    }

    function closeSidePanel() {
        var main = document.getElementById('calendarMain');
        var panel = document.getElementById('sidePanel');
        main.classList.remove('shrink');
        panel.classList.remove('open');
        isSidePanelOpen = false;
        selectedDateStr = null;
        renderCalendar();
    }

    function viewEvent(eventId) {
        window.location.href = contextPath + '/company-admin/compliance/compliance/' + eventId;
    }

    // ==================== NAVIGATION ====================
    function previousMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
        selectedDateStr = null;
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
    }

    function nextMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
        selectedDateStr = null;
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
    }

    function goToToday() {
        var today = new Date();
        currentDate = new Date(today.getFullYear(), today.getMonth(), 1);
        selectedDateStr = null;
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
        setTimeout(function() {
            var todayStr = formatDateForAPI(today);
            selectDate(todayStr, today.getFullYear(), today.getMonth(), today.getDate());
        }, 300);
    }

    function refreshCalendar() {
        loadEventsAndRender();
        toast('Calendar refreshed', 'info');
    }

    function resetFilters() {
        document.getElementById('employeeFilter').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('categoryFilter').value = '';
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
        toast('Filters reset', 'info');
    }

    // ==================== EXPORT ====================
    function exportCalendarData() {
        if (!allEventsData.length) {
            toast('No data to export', 'error');
            return;
        }

        var rows = [['Date', 'Event Title', 'Category', 'Status', 'Assigned To', 'Description', 'Days Remaining']];
        for (var i = 0; i < allEventsData.length; i++) {
            var e = allEventsData[i];
            var days = getDaysRemaining(e.startDate);
            var daysText = days !== null ? (days < 0 ? 'Overdue by ' + Math.abs(days) : days + ' days') : '—';
            rows.push([
                e.startDate,
                e.title,
                e.category || '—',
                getStatusDisplay(e.status),
                e.assignedTo || '—',
                e.description || '—',
                daysText
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

    // ==================== CREATE MODAL ====================
    function openCreateModal() {
        var dateTitle = document.getElementById('selectedDateTitle').textContent;
        if (dateTitle === '—') {
            toast('Please select a date first', 'warning');
            return;
        }
        document.getElementById('createModalSubtitle').textContent = 'Add a new compliance event for ' + dateTitle;
        document.getElementById('eventDate').value = selectedDateStr;
        document.getElementById('eventTitle').value = '';
        document.getElementById('eventDescription').value = '';
        document.getElementById('eventCategory').value = '';
        document.getElementById('eventEmployee').value = '';
        document.getElementById('eventStatus').value = 'PENDING';
        document.getElementById('createModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeCreateModal() {
        document.getElementById('createModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    async function createEvent() {
        var title = document.getElementById('eventTitle').value.trim();
        var description = document.getElementById('eventDescription').value.trim();
        var categoryId = document.getElementById('eventCategory').value;
        var employeeId = document.getElementById('eventEmployee').value;
        var status = document.getElementById('eventStatus').value;
        var date = document.getElementById('eventDate').value;

        if (!title) {
            toast('Please enter an event title', 'error');
            return;
        }

        if (!categoryId) {
            toast('Please select a category', 'error');
            return;
        }

        var payload = {
            title: title,
            description: description || null,
            categoryId: categoryId,
            employeeId: employeeId || null,
            status: status,
            startDate: date,
            endDate: date
        };

        var btn = document.getElementById('createBtn');
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';

        try {
            var data = await api('/api/company-admin/compliance/calendar/event', {
                method: 'POST',
                body: JSON.stringify(payload)
            });

            btn.disabled = false;
            btn.innerHTML = originalText;

            if (data && data.success) {
                toast('Event created successfully', 'success');
                closeCreateModal();
                loadEventsAndRender();
                // Re-select the current date
                if (selectedDateStr) {
                    var parts = selectedDateStr.split('-');
                    selectDate(selectedDateStr, parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
                }
            } else {
                toast(data?.error || 'Failed to create event', 'error');
            }
        } catch(e) {
            console.error('Error creating event:', e);
            btn.disabled = false;
            btn.innerHTML = originalText;
            toast('Failed to create event', 'error');
        }
    }

    // ==================== EVENT LISTENERS ====================
    document.getElementById('employeeFilter').addEventListener('change', function() {
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
    });

    document.getElementById('statusFilter').addEventListener('change', function() {
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
    });

    document.getElementById('categoryFilter').addEventListener('change', function() {
        if (isSidePanelOpen) closeSidePanel();
        loadEventsAndRender();
    });

    document.getElementById('createModal').addEventListener('click', function(e) {
        if (e.target === this) closeCreateModal();
    });

    // Close side panel when clicking outside
    document.addEventListener('click', function(e) {
        var panel = document.getElementById('sidePanel');
        var main = document.getElementById('calendarMain');
        if (isSidePanelOpen && panel && main && !panel.contains(e.target) && !main.contains(e.target)) {
            closeSidePanel();
        }
    });

    // ==================== LOAD EMPLOYEE COUNT ====================
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

        loadEmployeeCount();

        // Set current date to start of month
        var today = new Date();
        currentDate = new Date(today.getFullYear(), today.getMonth(), 1);

        // Load all data
        Promise.all([loadEmployees(), loadCategories()]).then(function() {
            loadEventsAndRender();
        }).catch(function(error) {
            console.error('Error loading data:', error);
            toast('Failed to load calendar data', 'error');
        });
    });
</script>

</body>
</html>