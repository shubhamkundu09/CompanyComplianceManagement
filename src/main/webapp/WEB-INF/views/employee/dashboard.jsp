<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: employee/dashboard.jsp --%>
<% pageContext.setAttribute("pageTitle", "Employee Dashboard"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — Employee Compliance Portal</title>

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
            --radius: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
        }

        /* LOGO BACKGROUND */
        .logo-bg {
            position: fixed;
            top: 50%;
            left: 54%;
            transform: translate(-50%, -50%);
            width: 500px;
            height: 900px;
            opacity: 0.35;
            pointer-events: none;
            z-index: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .logo-bg img { width: 100%; height: 100%; object-fit: contain; }

        .app-wrapper {
            display: flex;
            min-height: 100vh;
            position: relative;
            z-index: 1;
        }

        /* SIDEBAR (Company Admin Style) */
        .sidebar {
            width: 260px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(226, 232, 240, 0.8);
            padding: 24px 16px;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            overflow-y: auto;
            z-index: 50;
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 8px 20px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            margin-bottom: 20px;
        }

        .sidebar-brand .brand-icon {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            border-radius: var(--radius);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            font-weight: 800;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .sidebar-brand .brand-text {
            font-size: 18px;
            font-weight: 800;
            color: var(--gray-900);
            letter-spacing: -0.4px;
        }

        .sidebar-brand .brand-badge {
            font-size: 10px;
            font-weight: 700;
            color: var(--primary);
            background: var(--primary-bg);
            padding: 2px 8px;
            border-radius: 20px;
        }

        .sidebar-label {
            font-size: 11px;
            font-weight: 700;
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
            padding: 11px 14px;
            border-radius: var(--radius);
            color: var(--gray-600);
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            transition: all 0.2s;
            margin-bottom: 4px;
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

        /* HEADER */
        .header {
            position: fixed;
            top: 0; left: 260px; right: 0;
            height: 64px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            z-index: 40;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
        }

        .page-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--gray-900);
            letter-spacing: -0.4px;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 12px;
            background: var(--gray-100);
            padding: 6px 14px 6px 8px;
            border-radius: 40px;
        }

        .user-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 13px;
        }

        .user-name {
            font-size: 13px;
            font-weight: 700;
            color: var(--gray-900);
            line-height: 1.2;
        }

        .user-role {
            font-size: 10px;
            color: var(--primary);
            font-weight: 600;
            text-transform: uppercase;
        }

        .btn-logout-head {
            background: transparent;
            border: none;
            color: var(--gray-500);
            font-size: 14px;
            cursor: pointer;
            padding: 6px;
            margin-left: 4px;
            transition: color 0.2s;
        }

        .btn-logout-head:hover { color: var(--danger); }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 260px;
            margin-top: 64px;
            padding: 32px 40px;
            flex: 1;
            min-height: calc(100vh - 64px);
            position: relative;
            z-index: 1;
        }

        /* BREADCRUMB */
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
            font-weight: 600;
            cursor: pointer;
        }

        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb .sep { color: var(--gray-400); }
        .breadcrumb .current { color: var(--gray-800); font-weight: 700; }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            transition: all 0.25s;
        }

        .stat-card:hover {
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
            border-color: var(--primary-light);
        }

        .stat-card .stat-top { display: flex; justify-content: space-between; align-items: flex-start; }
        .stat-card .stat-label { font-size: 12px; font-weight: 700; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card .stat-icon {
            width: 44px; height: 44px; border-radius: var(--radius);
            display: flex; align-items: center; justify-content: center; font-size: 18px;
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.4);
        }
        .stat-card .stat-value { font-size: 32px; font-weight: 800; color: var(--gray-900); margin-top: 8px; letter-spacing: -0.5px; }
        .stat-icon.blue { color: var(--primary); }
        .stat-icon.green { color: var(--success); }
        .stat-icon.red { color: var(--danger); }
        .stat-icon.yellow { color: var(--warning); }

        /* HERO HEADER (FOR SUB-COMPLIANCE DETAILS VIEW) */
        .hero-header {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            overflow: hidden;
            position: relative;
            margin-bottom: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .hero-header::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, transparent, var(--primary), var(--primary-light), var(--primary), transparent);
        }

        .hero-inner {
            padding: 28px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .hero-content {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .hero-icon {
            width: 64px;
            height: 64px;
            min-width: 64px;
            background: #000;
            border: 1.5px solid rgba(79, 70, 229, 0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e9d80f;
            font-size: 26px;
            flex-shrink: 0;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
        }

        .hero-text h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--gray-900);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .hero-text .description {
            font-size: 13px;
            color: var(--gray-500);
            margin: 6px 0 12px 0;
            line-height: 1.5;
        }

        .hero-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        .badge-success { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.3); }
        .badge-danger { background: var(--danger-bg); color: var(--danger); border: 1px solid rgba(239,68,68,0.3); }
        .badge-warning { background: var(--warning-bg); color: var(--warning); border: 1px solid rgba(245,158,11,0.3); }
        .badge-info { background: var(--info-bg); color: var(--info); border: 1px solid rgba(59,130,246,0.3); }
        .badge-primary { background: var(--primary-bg); color: var(--primary); border: 1px solid rgba(79,70,229,0.3); }

        /* SECTION CARD */
        .section-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            flex-wrap: wrap;
            gap: 12px;
        }

        .section-title {
            font-size: 17px;
            font-weight: 800;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i { color: var(--primary); font-size: 16px; }

        /* FILTER BAR */
        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: white;
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: var(--radius);
            padding: 8px 14px;
            gap: 8px;
            flex: 1;
            max-width: 320px;
            transition: all 0.2s;
        }

        .search-box:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .search-box i { color: var(--gray-400); font-size: 14px; }
        .search-box input {
            background: none;
            border: none;
            color: var(--gray-800);
            font-size: 13px;
            width: 100%;
            outline: none;
            font-family: inherit;
        }

        .filter-select {
            background: white;
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: var(--radius);
            padding: 8px 14px;
            color: var(--gray-800);
            font-size: 13px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
            outline: none;
            transition: all 0.2s;
        }

        .filter-select:hover { border-color: var(--primary-light); }
        .filter-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); }

        /* COMPLIANCE PARENT CARDS GRID */
        .compliance-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 24px;
        }

        .compliance-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: var(--radius-lg);
            padding: 0;
            overflow: hidden;
            position: relative;
            transition: all 0.3s ease;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
            cursor: pointer;
        }

        .compliance-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--primary), var(--primary-light), var(--primary), transparent);
            z-index: 1;
        }

        .compliance-card:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateY(-4px);
            border-color: var(--primary-light);
            box-shadow: 0 12px 32px rgba(79, 70, 229, 0.12);
        }

        .vnext-card-body { padding: 22px 22px 16px; }

        .vnext-card-top { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 12px; }

        .vnext-card-icon {
            width: 48px; height: 48px; min-width: 48px; border-radius: 50%;
            background: #000; border: 1.5px solid rgba(79, 70, 229, 0.3);
            display: flex; align-items: center; justify-content: center;
            color: #e9d80f; font-size: 18px; flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .vnext-card-title-block { flex: 1; min-width: 0; }
        .vnext-card-title { font-size: 15px; font-weight: 800; color: var(--gray-900); text-transform: uppercase; letter-spacing: 0.4px; line-height: 1.3; margin-bottom: 8px; }

        .vnext-card-meta {
            display: flex; gap: 12px; flex-wrap: wrap; padding: 10px 0; margin-bottom: 12px;
            border-top: 1px solid rgba(226, 232, 240, 0.6); border-bottom: 1px solid rgba(226, 232, 240, 0.6);
        }

        .vnext-meta-item { font-size: 11.5px; color: var(--gray-500); display: flex; align-items: center; gap: 5px; font-weight: 600; }
        .vnext-meta-item i { color: var(--primary); font-size: 11px; }

        /* SUB-COMPLIANCE LIST BREAKDOWN IN PARENT CARD */
        .vnext-sub-list { display: flex; flex-direction: column; gap: 0; }
        .vnext-sub-list-title { font-size: 11px; font-weight: 700; color: var(--gray-900); text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 8px; }
        .vnext-sub-item { display: flex; align-items: center; gap: 10px; padding: 9px 0; border-bottom: 1px solid rgba(226, 232, 240, 0.4); }
        .vnext-sub-item:last-child { border-bottom: none; }
        .vnext-sub-bullet { width: 6px; height: 6px; min-width: 6px; border-radius: 50%; background: var(--primary); opacity: 0.6; flex-shrink: 0; }
        .vnext-sub-name { font-size: 12px; font-weight: 600; color: var(--gray-800); flex: 1; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .vnext-sub-right { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
        .vnext-due-label { font-size: 11px; color: var(--gray-500); white-space: nowrap; font-weight: 500; }
        .vnext-due-label.overdue { color: var(--danger); font-weight: 700; }
        .vnext-due-label.warning { color: var(--warning); font-weight: 700; }

        /* BLINKERS */
        .vnext-blinker { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; display: inline-block; }
        .blinker-overdue { background: var(--danger); box-shadow: 0 0 10px rgba(239,68,68,0.9); animation: blink-overdue 0.55s ease-in-out infinite; }
        .blinker-danger  { background: var(--danger); box-shadow: 0 0 12px rgba(239,68,68,0.8); animation: blink-danger 0.38s ease-in-out infinite; }
        .blinker-warning { background: var(--warning); box-shadow: 0 0 8px rgba(245,158,11,0.7); animation: blink-warning 0.9s ease-in-out infinite; }
        .blinker-ok      { background: var(--success); box-shadow: 0 0 6px rgba(16,185,129,0.5); }

        @keyframes blink-overdue { 0%,100% { opacity:1; transform:scale(1.1); } 50% { opacity:0.15; transform:scale(0.75); } }
        @keyframes blink-danger  { 0%,100% { opacity:1; transform:scale(1.2); } 50% { opacity:0.05; transform:scale(0.65); } }
        @keyframes blink-warning { 0%,100% { opacity:1; transform:scale(1);   } 50% { opacity:0.3;  transform:scale(0.82); } }

        .vnext-card-footer {
            padding: 14px 22px;
            border-top: 1px solid rgba(226, 232, 240, 0.7);
            background: rgba(248, 250, 252, 0.7);
            display: flex; gap: 10px;
        }

        /* SUB-COMPLIANCE GRID CARDS (EXACT REPLICA OF PARENT-COMPLIANCE-DETAILS.JSP) */
        .sub-grid {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .sub-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: var(--radius-lg);
            overflow: hidden;
            position: relative;
            transition: all 0.25s ease;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        }

        .sub-card::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 4px;
            background: var(--gray-300);
        }

        .sub-card:hover {
            background: rgba(255, 255, 255, 1);
            box-shadow: var(--shadow-md);
            transform: translateX(4px);
        }

        .sub-card.completed::before { background: var(--success); }
        .sub-card.overdue::before { background: var(--danger); }
        .sub-card.in-progress::before { background: var(--primary); }
        .sub-card.pending::before { background: var(--warning); }

        .sub-card-inner { padding: 20px 24px; }

        .sub-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .sub-card-title-group {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 0;
        }

        .sub-icon {
            width: 42px;
            height: 42px;
            min-width: 42px;
            border-radius: 50%;
            background: #000;
            border: 1.5px solid rgba(79, 70, 229, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e9d80f;
            font-size: 16px;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .sub-name {
            font-size: 15px;
            font-weight: 800;
            color: var(--gray-900);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .sub-name-badges {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .sub-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sub-card-meta {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 12px;
            background: rgba(248, 250, 252, 0.8);
            border: 1px solid rgba(226, 232, 240, 0.6);
            padding: 12px 16px;
            border-radius: var(--radius);
            margin-bottom: 12px;
        }

        .sub-meta-item { font-size: 12px; color: var(--gray-600); }
        .sub-meta-item strong { color: var(--gray-900); }
        .sub-meta-item.overdue-text strong { color: var(--danger); }
        .sub-meta-item.warning-text strong { color: var(--warning); }

        .sub-card-extra {
            margin-top: 12px;
            font-size: 12px;
            color: var(--gray-600);
            line-height: 1.5;
        }

        .completion-box {
            background: rgba(16, 185, 129, 0.06);
            border: 1px solid rgba(16, 185, 129, 0.25);
            border-radius: var(--radius);
            padding: 14px 18px;
            margin-top: 14px;
        }

        .completion-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--success);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .comp-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
        }

        .comp-label { font-size: 10px; color: var(--gray-500); text-transform: uppercase; font-weight: 700; }
        .comp-value { font-size: 12px; font-weight: 600; color: var(--gray-800); margin-top: 2px; }

        /* BUTTONS */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12.5px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
        }

        .btn-primary { background: var(--primary); color: white; box-shadow: 0 2px 8px rgba(79,70,229,0.25); }
        .btn-primary:hover { background: var(--primary-dark); }
        .btn-success { background: var(--success); color: white; box-shadow: 0 2px 8px rgba(16,185,129,0.25); }
        .btn-success:hover { background: #059669; }
        .btn-ghost { background: white; color: var(--gray-700); border: 1px solid var(--gray-300); }
        .btn-ghost:hover { background: var(--gray-100); color: var(--gray-900); }

        /* MODALS */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 200;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: all 0.25s ease;
        }

        .modal-overlay.active { opacity: 1; pointer-events: auto; }

        .modal-box {
            background: white;
            border-radius: var(--radius-xl);
            width: 100%;
            max-width: 540px;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            transform: scale(0.95);
            transition: all 0.25s ease;
        }

        .modal-overlay.active .modal-box { transform: scale(1); }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title { font-size: 16px; font-weight: 700; color: var(--gray-900); }
        .modal-close { background: transparent; border: none; font-size: 16px; color: var(--gray-400); cursor: pointer; }
        .modal-body { padding: 24px; }
        .modal-footer { padding: 16px 24px; background: var(--gray-50); border-top: 1px solid var(--gray-200); display: flex; justify-content: flex-end; gap: 12px; }

        .form-group { margin-bottom: 18px; }
        .form-label { display: block; font-size: 12px; font-weight: 700; color: var(--gray-700); margin-bottom: 6px; }
        .form-input { width: 100%; padding: 10px 14px; border: 1px solid var(--gray-300); border-radius: var(--radius); font-size: 13px; font-family: inherit; }
        .form-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79,70,229,0.1); }

        /* TOAST */
        #toast-container { position: fixed; bottom: 24px; right: 24px; z-index: 300; display: flex; flex-direction: column; gap: 10px; }
        .toast { padding: 12px 20px; border-radius: var(--radius); background: var(--gray-900); color: white; font-size: 13px; font-weight: 600; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: 10px; }
        .toast-success { background: #065f46; }
        .toast-error { background: #991b1b; }
        .empty-state { text-align: center; padding: 48px 24px; color: var(--gray-500); }
    </style>
</head>
<body>

<!-- LOGO BACKGROUND -->
<div class="logo-bg">
    <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="" onerror="this.style.display='none'">
</div>

<div class="app-wrapper">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-icon">V</div>
            <div>
                <div class="brand-text">VNext Legal</div>
                <div class="brand-badge">Employee Portal</div>
            </div>
        </div>

        <div class="sidebar-label">Navigation</div>
        <a onclick="showOverviewSection()" class="nav-item active" id="navItemDashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a onclick="showOverviewSection()" class="nav-item" id="navItemOverview">
            <i class="fas fa-tasks"></i> My Compliances
        </a>

        <div class="sidebar-label" style="margin-top:20px;">Account</div>
        <a onclick="openChangePasswordModal()" class="nav-item" id="navItemChangePassword" style="cursor:pointer;">
            <i class="fas fa-key"></i> Change Password
        </a>
    </aside>

    <!-- HEADER -->
    <header class="header">
        <div class="page-title" id="topHeaderTitle">Employee Compliance Portal</div>

        <div class="header-user">
            <div class="user-avatar" id="userAvatar">E</div>
            <div>
                <div class="user-name" id="userName">Employee User</div>
                <div class="user-role" id="userDepartment">Employee</div>
            </div>
            <button onclick="openChangePasswordModal()" class="btn-logout-head" title="Change Password" style="margin-right:6px;background:rgba(255,255,255,0.8);color:var(--primary);">
                <i class="fas fa-key"></i>
            </button>
            <button onclick="logout()" class="btn-logout-head" title="Logout">
                <i class="fas fa-sign-out-alt"></i>
            </button>
        </div>
    </header>

    <!-- MAIN CONTENT AREA -->
    <main class="main-content">

        <!-- ==================== VIEW 1: OVERVIEW SECTION ==================== -->
        <div id="overviewSection">
            <!-- BREADCRUMB -->
            <div class="breadcrumb">
                <span class="current">Employee Dashboard</span>
                <span class="sep">/</span>
                <span class="current">My Assigned Compliances</span>
            </div>

            <!-- STATS GRID -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-top">
                        <div>
                            <div class="stat-label">Total Assigned</div>
                            <div class="stat-value" id="statTotal">0</div>
                        </div>
                        <div class="stat-icon blue"><i class="fas fa-list-check"></i></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div>
                            <div class="stat-label">Pending</div>
                            <div class="stat-value" id="statPending" style="color:var(--warning);">0</div>
                        </div>
                        <div class="stat-icon yellow"><i class="fas fa-clock"></i></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div>
                            <div class="stat-label">Overdue</div>
                            <div class="stat-value" id="statOverdue" style="color:var(--danger);">0</div>
                        </div>
                        <div class="stat-icon red"><i class="fas fa-triangle-exclamation"></i></div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div>
                            <div class="stat-label">Completed</div>
                            <div class="stat-value" id="statCompleted" style="color:var(--success);">0</div>
                        </div>
                        <div class="stat-icon green"><i class="fas fa-circle-check"></i></div>
                    </div>
                </div>
            </div>

            <!-- SECTION CARD -->
            <div class="section-card">
                <div class="section-header">
                    <div class="section-title"><i class="fas fa-sitemap"></i> My Assigned Parent Compliances</div>
                </div>

                <!-- FILTER BAR -->
                <div class="filter-bar">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchParentInput" oninput="renderOverviewCards()" placeholder="Search assigned parent compliance...">
                    </div>

                    <select id="statusParentSelect" class="filter-select" onchange="renderOverviewCards()">
                        <option value="ALL">All Statuses</option>
                        <option value="PENDING">Pending</option>
                        <option value="OVERDUE">Overdue</option>
                        <option value="COMPLETED">Completed</option>
                    </select>
                </div>

                <!-- CARDS GRID CONTAINER -->
                <div id="parentCardsGrid" class="compliance-grid">
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <i class="fas fa-spinner fa-spin" style="font-size:24px;"></i><br><br>Loading assigned compliances...
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== VIEW 2: SUB-COMPLIANCE DETAILS SECTION ==================== -->
        <div id="parentDetailSection" style="display:none;">
            <!-- BREADCRUMB -->
            <div class="breadcrumb">
                <a onclick="showOverviewSection()"><i class="fas fa-arrow-left" style="margin-right:4px;"></i> Back to All Compliances</a>
                <span class="sep">/</span>
                <span class="current" id="breadcrumbParentTitle">Parent Compliance Details</span>
            </div>

            <!-- HERO HEADER -->
            <div class="hero-header">
                <div class="hero-inner">
                    <div class="hero-content">
                        <div class="hero-icon" id="heroParentIcon"><i class="fas fa-tasks"></i></div>
                        <div class="hero-text">
                            <h1 id="heroParentTitle">Parent Compliance Title</h1>
                            <div class="description" id="heroParentDesc">Assigned company compliance details and sub-compliances breakdown.</div>
                            <div class="hero-badges" id="heroParentBadges">
                                <!-- Badges loaded dynamically -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SUB-COMPLIANCES CARD SECTION -->
            <div class="section-card">
                <div class="section-header">
                    <div class="section-title">
                        <i class="fas fa-list-ul"></i> Sub-Compliances Breakdown
                        <span class="badge badge-primary" id="subCountBadge">0</span>
                    </div>
                </div>

                <!-- FILTER BAR -->
                <div class="filter-bar">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchSubInput" oninput="renderSubComplianceGrid()" placeholder="Search sub-compliance name...">
                    </div>

                    <select id="statusSubSelect" class="filter-select" onchange="renderSubComplianceGrid()">
                        <option value="ALL">All Sub-Compliance Statuses</option>
                        <option value="PENDING">Pending</option>
                        <option value="OVERDUE">Overdue</option>
                        <option value="COMPLETED">Completed</option>
                    </select>
                </div>

                <!-- SUB-COMPLIANCES GRID -->
                <div id="subCompliancesGrid" class="sub-grid">
                    <!-- Sub-compliance cards rendered dynamically -->
                </div>
            </div>
        </div>

    </main>
</div>

<!-- MARK COMPLETE MODAL -->
<div id="completeModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-check-circle" style="color:var(--success);margin-right:8px;"></i>Mark Sub-Compliance as Completed</div>
            </div>
            <button class="modal-close" onclick="closeCompleteModal()"><i class="fas fa-times"></i></button>
        </div>
        <form id="completeForm" onsubmit="submitMarkComplete(event)">
            <div class="modal-body">
                <input type="hidden" id="completeAssignmentId">
                <p style="font-size:13.5px;color:var(--gray-900);margin-bottom:16px;font-weight:700;" id="completeComplianceTitle">Compliance Title</p>

                <div class="form-group">
                    <label class="form-label">Filing Reference Number / SRN ID <span style="color:var(--danger);">*</span></label>
                    <input type="text" id="submissionReference" class="form-input" placeholder="e.g. SRN-984729103" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Upload Filing Proof / Receipt (Optional)</label>
                    <input type="file" id="submissionDocument" class="form-input">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" onclick="closeCompleteModal()" class="btn btn-ghost">Cancel</button>
                <button type="submit" id="btnSubmitComplete" class="btn btn-success">
                    <i class="fas fa-check"></i> Submit Completion
                </button>
            </div>
        </form>
    </div>
</div>

<!-- CHANGE PASSWORD MODAL -->
<div id="changePasswordModal" class="modal-overlay">
    <div class="modal-box" style="max-width: 480px;">
        <div class="modal-header">
            <div>
                <div class="modal-title"><i class="fas fa-key" style="color:var(--primary);margin-right:8px;"></i>Change Password</div>
                <div style="font-size:12px;color:var(--gray-500);margin-top:2px;">Update your employee account password</div>
            </div>
            <button class="modal-close" onclick="closeChangePasswordModal()"><i class="fas fa-times"></i></button>
        </div>
        <form id="changePasswordForm" onsubmit="submitChangePassword(event)">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Current Password <span style="color:var(--danger);">*</span></label>
                    <div style="position:relative;">
                        <input type="password" id="currentPassword" class="form-input" placeholder="Enter current password" required style="padding-right:38px;">
                        <button type="button" onclick="togglePassVisibility('currentPassword', this)" style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-400);cursor:pointer;">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">New Password <span style="color:var(--danger);">*</span></label>
                    <div style="position:relative;">
                        <input type="password" id="newPassword" class="form-input" placeholder="Enter new password" required oninput="checkEmployeePasswordStrength(this.value)" style="padding-right:38px;">
                        <button type="button" onclick="togglePassVisibility('newPassword', this)" style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-400);cursor:pointer;">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="pwdRequirements" style="margin-top:8px;font-size:11px;color:var(--gray-500);display:flex;flex-direction:column;gap:3px;background:rgba(241,245,249,0.7);padding:8px 12px;border-radius:8px;">
                        <div id="req-len" style="color:var(--gray-500);"><i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> At least 8 characters</div>
                        <div id="req-upper" style="color:var(--gray-500);"><i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> At least one uppercase letter (A-Z)</div>
                        <div id="req-lower" style="color:var(--gray-500);"><i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> At least one lowercase letter (a-z)</div>
                        <div id="req-num" style="color:var(--gray-500);"><i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> At least one number (0-9)</div>
                        <div id="req-special" style="color:var(--gray-500);"><i class="fas fa-circle" style="font-size:7px;margin-right:4px;"></i> At least one special character (@#$%^&+=)</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm New Password <span style="color:var(--danger);">*</span></label>
                    <div style="position:relative;">
                        <input type="password" id="confirmPassword" class="form-input" placeholder="Re-enter new password" required oninput="checkPasswordMatch()" style="padding-right:38px;">
                        <button type="button" onclick="togglePassVisibility('confirmPassword', this)" style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--gray-400);cursor:pointer;">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="pwdMatchMsg" style="margin-top:4px;font-size:11px;display:none;"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" onclick="closeChangePasswordModal()" class="btn btn-ghost">Cancel</button>
                <button type="submit" id="btnSubmitChangePassword" class="btn btn-primary">
                    <i class="fas fa-check"></i> Update Password
                </button>
            </div>
        </form>
    </div>
</div>

<div id="toast-container"></div>

<script>
    var baseUrl = '${baseUrl}';
    var allAssignments = [];
    var currentGroupTitle = null;

    function getAuthToken() {
        return localStorage.getItem('token') || localStorage.getItem('accessToken');
    }

    async function api(endpoint, options = {}) {
        const token = getAuthToken();
        const headers = options.headers || {};
        if (token) headers['Authorization'] = 'Bearer ' + token;
        if (!options.isFormData && !headers['Content-Type']) {
            headers['Content-Type'] = 'application/json';
        }

        const res = await fetch(baseUrl + endpoint, {
            ...options,
            headers
        });

        if (res.status === 401) {
            localStorage.clear();
            window.location.href = baseUrl + '/login';
            return null;
        }

        return await res.json();
    }

    function toast(msg, type = 'info') {
        const c = document.getElementById('toast-container');
        const el = document.createElement('div');
        el.className = 'toast toast-' + type;
        el.innerHTML = '<span>' + msg + '</span>';
        c.appendChild(el);
        setTimeout(() => { el.style.opacity = '0'; setTimeout(() => el.remove(), 300); }, 3500);
    }

    function logout() {
        localStorage.clear();
        window.location.href = baseUrl + '/login';
    }

    function formatDate(d) {
        if (!d) return 'N/A';
        try {
            const dt = new Date(d);
            return dt.toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric' });
        } catch(e) { return d; }
    }

    function formatDateTime(dtStr) {
        if (!dtStr) return 'N/A';
        try {
            const dt = new Date(dtStr);
            return dt.toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
        } catch(e) { return dtStr; }
    }

    function getDaysRemaining(dueDateStr) {
        if (!dueDateStr) return null;
        const due = new Date(dueDateStr);
        const today = new Date();
        today.setHours(0,0,0,0);
        due.setHours(0,0,0,0);
        const diffTime = due - today;
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function getComplianceIcon(name) {
        if (!name) return 'fa-tasks';
        var n = name.toLowerCase();
        if (n.includes('gst') || n.includes('tax') || n.includes('income')) return 'fa-calculator';
        if (n.includes('pf') || n.includes('esi') || n.includes('labor') || n.includes('payroll')) return 'fa-users-cog';
        if (n.includes('audit') || n.includes('balance') || n.includes('account')) return 'fa-chart-pie';
        if (n.includes('roc') || n.includes('company') || n.includes('mca')) return 'fa-building';
        if (n.includes('return') || n.includes('filing') || n.includes('annual')) return 'fa-file-alt';
        if (n.includes('legal') || n.includes('court') || n.includes('contract')) return 'fa-gavel';
        if (n.includes('insurance') || n.includes('policy')) return 'fa-shield-alt';
        return 'fa-tasks';
    }

    function getBlinkerClass(dueDate, status) {
        if (status === 'COMPLETED') return 'blinker-ok';
        const days = getDaysRemaining(dueDate);
        if (days !== null && days < 0) return 'blinker-danger';
        if (days !== null && days <= 7) return 'blinker-warning';
        return 'blinker-ok';
    }

    async function loadProfile() {
        const userStr = localStorage.getItem('user');
        if (userStr) {
            try {
                const u = JSON.parse(userStr);
                document.getElementById('userName').textContent = (u.firstName || '') + ' ' + (u.lastName || '');
                document.getElementById('userAvatar').textContent = (u.firstName || 'E')[0];
                document.getElementById('userDepartment').textContent = (u.department || 'Employee') + (u.designation ? ' • ' + u.designation : '');
            } catch(e) {}
        }
    }

    async function loadCompliances() {
        try {
            const res = await api('/api/employee/compliance/my?page=0&size=500');
            if (res && res.success) {
                allAssignments = (res.data && res.data.content) ? res.data.content : (Array.isArray(res.data) ? res.data : []);
                updateStats();
                renderOverviewCards();
            } else {
                document.getElementById('parentCardsGrid').innerHTML = '<div class="empty-state" style="grid-column:1/-1;">Failed to load assigned compliances</div>';
            }
        } catch(e) {
            document.getElementById('parentCardsGrid').innerHTML = '<div class="empty-state" style="grid-column:1/-1;">Error loading assigned compliances</div>';
        }
    }

    function updateStats() {
        let pending = 0, overdue = 0, completed = 0;
        const now = new Date();

        allAssignments.forEach(a => {
            if (a.completedAt || a.status === 'COMPLETED') {
                completed++;
            } else {
                const due = a.dueDate ? new Date(a.dueDate) : null;
                if (due && due < now) overdue++;
                else pending++;
            }
        });

        document.getElementById('statTotal').textContent = allAssignments.length;
        document.getElementById('statPending').textContent = pending;
        document.getElementById('statOverdue').textContent = overdue;
        document.getElementById('statCompleted').textContent = completed;
    }

    function groupAssignmentsByParent() {
        const groups = {};
        allAssignments.forEach(a => {
            const parentKey = a.category || a.complianceName || 'General Compliance';
            if (!groups[parentKey]) {
                groups[parentKey] = {
                    title: parentKey,
                    description: a.description || 'Assigned parent compliance category.',
                    frequency: a.frequency || 'YEARLY',
                    subItems: []
                };
            }
            groups[parentKey].subItems.push(a);
        });
        return Object.values(groups);
    }

    function renderOverviewCards() {
        const container = document.getElementById('parentCardsGrid');
        const grouped = groupAssignmentsByParent();
        const searchTerm = document.getElementById('searchParentInput').value.toLowerCase();
        const statusFilter = document.getElementById('statusParentSelect').value;
        const now = new Date();

        let cardHtml = '';
        let count = 0;

        grouped.forEach(group => {
            if (searchTerm && !group.title.toLowerCase().includes(searchTerm)) return;

            let filteredSubs = group.subItems.filter(item => {
                const isDone = item.completedAt || item.status === 'COMPLETED';
                const due = item.dueDate ? new Date(item.dueDate) : null;
                const isOver = !isDone && due && due < now;

                if (statusFilter === 'PENDING') return !isDone && !isOver;
                if (statusFilter === 'OVERDUE') return isOver;
                if (statusFilter === 'COMPLETED') return isDone;
                return true;
            });

            if (filteredSubs.length === 0) return;
            count++;

            let hasOverdue = filteredSubs.some(s => (!s.completedAt && s.status !== 'COMPLETED') && s.dueDate && new Date(s.dueDate) < now);
            let allCompleted = filteredSubs.every(s => s.completedAt || s.status === 'COMPLETED');
            let hasUpcoming = filteredSubs.some(s => {
                if (s.completedAt || s.status === 'COMPLETED') return false;
                const days = getDaysRemaining(s.dueDate);
                return days !== null && days >= 0 && days <= 7;
            });

            let cardBlinkerCls = 'blinker-ok';
            let cardStatusLabel = 'Pending';
            let cardBadgeCls = 'badge-info';

            if (allCompleted) {
                cardBlinkerCls = 'blinker-ok';
                cardStatusLabel = 'Completed';
                cardBadgeCls = 'badge-success';
            } else if (hasOverdue) {
                cardBlinkerCls = 'blinker-danger';
                cardStatusLabel = 'Overdue';
                cardBadgeCls = 'badge-danger';
            } else if (hasUpcoming) {
                cardBlinkerCls = 'blinker-warning';
                cardStatusLabel = 'Due Soon';
                cardBadgeCls = 'badge-warning';
            }

            const iconClass = getComplianceIcon(group.title);

            let subItemsSummaryHtml = '';
            filteredSubs.slice(0, 5).forEach(s => {
                const isDone = s.completedAt || s.status === 'COMPLETED';
                const days = getDaysRemaining(s.dueDate);
                const sBlinker = getBlinkerClass(s.dueDate, s.status);

                let daysText = '';
                let dueCls = '';
                if (!isDone && days !== null) {
                    if (days < 0) {
                        daysText = ' (OD)';
                        dueCls = 'overdue';
                    } else if (days <= 7) {
                        daysText = ' (' + days + 'd)';
                        dueCls = 'warning';
                    }
                }

                let subBadge = isDone
                    ? '<span class="badge badge-success" style="font-size:9px;">Done</span>'
                    : (days < 0 ? '<span class="badge badge-danger" style="font-size:9px;">Overdue</span>' : '<span class="badge badge-info" style="font-size:9px;">Pending</span>');

                const subTitle = s.subTemplateName || s.complianceName || 'Sub-Compliance';

                subItemsSummaryHtml += '<div class="vnext-sub-item">' +
                    '<span class="vnext-sub-bullet"></span>' +
                    '<span class="vnext-sub-name" title="' + escapeHtml(subTitle) + '">' + escapeHtml(subTitle) + '</span>' +
                    '<div class="vnext-sub-right">' +
                        '<span class="vnext-due-label ' + dueCls + '">' + formatDate(s.dueDate) + daysText + '</span>' +
                        '<span class="vnext-blinker ' + sBlinker + '"></span>' +
                        subBadge +
                    '</div>' +
                '</div>';
            });

            if (filteredSubs.length > 5) {
                subItemsSummaryHtml += '<div style="font-size:11px;color:var(--gray-500);text-align:center;padding-top:6px;"><i class="fas fa-ellipsis-h"></i> +' + (filteredSubs.length - 5) + ' more sub-compliances</div>';
            }

            cardHtml += '<div class="compliance-card" onclick="openParentDetailSection(\'' + escapeHtml(group.title) + '\')">' +
                '<span class="vnext-blinker ' + cardBlinkerCls + '" style="position:absolute;top:14px;right:14px;z-index:2;"></span>' +
                '<div class="vnext-card-body">' +
                    '<div class="vnext-card-top">' +
                        '<div class="vnext-card-icon"><i class="fas ' + iconClass + '"></i></div>' +
                        '<div class="vnext-card-title-block">' +
                            '<div class="vnext-card-title">' + escapeHtml(group.title) + '</div>' +
                            '<div class="vnext-card-badges">' +
                                '<span class="badge ' + cardBadgeCls + '">' + cardStatusLabel + '</span>' +
                                '<span class="badge badge-primary"><i class="fas fa-redo"></i> ' + escapeHtml(group.frequency) + '</span>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +

                    '<div class="vnext-card-meta">' +
                        '<span class="vnext-meta-item"><i class="fas fa-list"></i> ' + filteredSubs.length + ' Sub-Compliance(s)</span>' +
                    '</div>' +

                    '<div class="vnext-sub-list">' +
                        '<div class="vnext-sub-list-title">Sub-Compliances Summary</div>' +
                        subItemsSummaryHtml +
                    '</div>' +
                '</div>' +

                '<div class="vnext-card-footer">' +
                    '<button onclick="event.stopPropagation();openParentDetailSection(\'' + escapeHtml(group.title) + '\')" class="btn btn-ghost" style="width:100%;"><i class="fas fa-arrow-right"></i> View Sub-Compliances & Details</button>' +
                '</div>' +
            '</div>';
        });

        if (count === 0) {
            container.innerHTML = '<div class="empty-state" style="grid-column: 1 / -1;"><i class="fas fa-folder-open" style="font-size:36px;opacity:0.3;"></i><br><br>No assigned compliances found.</div>';
        } else {
            container.innerHTML = cardHtml;
        }
    }

    /* ==================== VIEW SWITCHING ==================== */
    function showOverviewSection() {
        document.getElementById('overviewSection').style.display = 'block';
        document.getElementById('parentDetailSection').style.display = 'none';
        document.getElementById('topHeaderTitle').textContent = 'Employee Compliance Portal';
        document.getElementById('navItemOverview').classList.add('active');
    }

    function openParentDetailSection(parentTitle) {
        currentGroupTitle = parentTitle;
        const groupItems = allAssignments.filter(a => (a.category === parentTitle || a.complianceName === parentTitle));
        if (!groupItems.length) return;

        document.getElementById('overviewSection').style.display = 'none';
        document.getElementById('parentDetailSection').style.display = 'block';
        document.getElementById('topHeaderTitle').textContent = parentTitle;

        // Render Hero
        const iconClass = getComplianceIcon(parentTitle);
        document.getElementById('breadcrumbParentTitle').textContent = parentTitle;
        document.getElementById('heroParentTitle').textContent = parentTitle;
        document.getElementById('heroParentIcon').innerHTML = '<i class="fas ' + iconClass + '"></i>';

        let allDone = groupItems.every(s => s.completedAt || s.status === 'COMPLETED');
        let hasOverdue = groupItems.some(s => (!s.completedAt && s.status !== 'COMPLETED') && s.dueDate && new Date(s.dueDate) < new Date());

        let statusBadge = '<span class="badge badge-info"><i class="fas fa-clock"></i> Pending</span>';
        if (allDone) statusBadge = '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Completed</span>';
        else if (hasOverdue) statusBadge = '<span class="badge badge-danger"><i class="fas fa-triangle-exclamation"></i> Overdue</span>';

        document.getElementById('heroParentBadges').innerHTML =
            statusBadge +
            '<span class="badge badge-primary"><i class="fas fa-list"></i> ' + groupItems.length + ' Sub-Compliances</span>' +
            '<span class="badge badge-primary"><i class="fas fa-redo"></i> ' + (groupItems[0].frequency || 'YEARLY') + '</span>';

        document.getElementById('subCountBadge').textContent = groupItems.length;

        renderSubComplianceGrid();
    }

    /* ==================== RENDER SUB-COMPLIANCES GRID (MATCHING PARENT-COMPLIANCE-DETAILS.JSP) ==================== */
    function renderSubComplianceGrid() {
        const container = document.getElementById('subCompliancesGrid');
        const groupItems = allAssignments.filter(a => (a.category === currentGroupTitle || a.complianceName === currentGroupTitle));
        const searchTerm = document.getElementById('searchSubInput').value.toLowerCase();
        const statusFilter = document.getElementById('statusSubSelect').value;
        const now = new Date();

        let filtered = groupItems.filter(s => {
            const subTitle = s.subTemplateName || s.complianceName || '';
            if (searchTerm && !subTitle.toLowerCase().includes(searchTerm)) return false;

            const isDone = s.completedAt || s.status === 'COMPLETED';
            const due = s.dueDate ? new Date(s.dueDate) : null;
            const isOver = !isDone && due && due < now;

            if (statusFilter === 'PENDING') return !isDone && !isOver;
            if (statusFilter === 'OVERDUE') return isOver;
            if (statusFilter === 'COMPLETED') return isDone;
            return true;
        });

        if (!filtered.length) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-folder-open" style="font-size:32px;opacity:0.3;"></i><p style="margin-top:8px;">No sub-compliances match filter</p></div>';
            return;
        }

        let html = '';
        filtered.forEach((s, i) => {
            const isDone = s.completedAt || s.status === 'COMPLETED';
            const due = s.dueDate ? new Date(s.dueDate) : null;
            const isOver = !isDone && due && due < now;
            const days = getDaysRemaining(s.dueDate);
            const blinkerCls = getBlinkerClass(s.dueDate, s.status);
            const iconClass = getComplianceIcon(s.subTemplateName || s.complianceName);
            const subTitle = s.subTemplateName || s.complianceName || ('Sub-Compliance #' + (i + 1));

            let cardStateCls = isDone ? 'completed' : (isOver ? 'overdue' : 'pending');
            let statusBadge = isDone
                ? '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Completed</span>'
                : (isOver ? '<span class="badge badge-danger"><i class="fas fa-triangle-exclamation"></i> Overdue</span>' : '<span class="badge badge-info"><i class="fas fa-clock"></i> Pending</span>');

            let daysText = '';
            let metaClass = 'sub-meta-item';
            if (!isDone && days !== null) {
                if (days < 0) {
                    daysText = ' (Overdue)';
                    metaClass += ' overdue-text';
                } else if (days <= 7) {
                    daysText = ' (' + days + ' day' + (days === 1 ? '' : 's') + ' left)';
                    if (days <= 3) metaClass += ' warning-text';
                }
            }

            let actionHtml = !isDone
                ? '<button onclick="openCompleteModal(' + s.id + ', \'' + escapeHtml(subTitle) + '\')" class="btn btn-success"><i class="fas fa-check-circle"></i> Mark as Complete</button>'
                : '<span class="badge badge-success" style="font-size:12px;padding:6px 12px;"><i class="fas fa-check-circle"></i> Verified Complete</span>';

            html += '<div class="sub-card ' + cardStateCls + '">' +
                '<div class="sub-card-inner">' +
                    '<div class="sub-card-header">' +
                        '<div class="sub-card-title-group">' +
                            '<div class="sub-icon"><i class="fas ' + iconClass + '"></i></div>' +
                            '<div class="sub-title-text">' +
                                '<div class="sub-name">' + escapeHtml(subTitle) + '</div>' +
                                '<div class="sub-name-badges">' +
                                    statusBadge +
                                    '<span class="badge badge-primary">' + escapeHtml(s.frequency || 'YEARLY') + '</span>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +

                        '<div class="sub-actions">' +
                            (blinkerCls ? '<span class="vnext-blinker ' + blinkerCls + '"></span>' : '') +
                            actionHtml +
                        '</div>' +
                    '</div>' +

                    '<div class="sub-card-meta">' +
                        '<div class="' + metaClass + '">Due Date: <strong>' + formatDate(s.dueDate) + daysText + '</strong></div>' +
                        '<div class="sub-meta-item">Reminders: <strong>10 days before</strong></div>' +
                        '<div class="sub-meta-item">Required Document: <strong>' + escapeHtml(s.documentRequired || 'Filing Receipt') + '</strong></div>' +
                    '</div>' +

                    (s.description ? '<div class="sub-card-extra"><strong>Description:</strong> ' + escapeHtml(s.description) + '</div>' : '') +
                    (s.instructions ? '<div class="sub-card-extra"><strong>Instructions:</strong> ' + escapeHtml(s.instructions) + '</div>' : '') +
                    (s.externalLink ? '<div class="sub-card-extra"><a href="' + escapeHtml(s.externalLink) + '" target="_blank" style="color:var(--primary);font-weight:700;"><i class="fas fa-external-link-alt"></i> Access External Filing Portal</a></div>' : '') +

                    (isDone ? '<div class="completion-box">' +
                        '<div class="completion-title"><i class="fas fa-check-circle"></i> Submission & Completion Details</div>' +
                        '<div class="comp-grid">' +
                            '<div class="comp-item"><div class="comp-label">Completed By</div><div class="comp-value"><strong>' + escapeHtml(s.completedByName || 'Company Admin') + '</strong>' + (s.completedByRole ? ' <span style="font-size:11px;color:var(--gray-500);">(' + escapeHtml(s.completedByRole) + ')</span>' : '') + '</div></div>' +
                            '<div class="comp-item"><div class="comp-label">Completed On</div><div class="comp-value">' + formatDateTime(s.completedAt) + '</div></div>' +
                            (s.submissionReference ? '<div class="comp-item"><div class="comp-label">Filing Reference / SRN</div><div class="comp-value" style="font-family:monospace;font-weight:600;">' + escapeHtml(s.submissionReference) + '</div></div>' : '') +
                            (s.submissionDocumentUrl ? '<div class="comp-item" style="grid-column:1/-1;"><div class="comp-label">Submitted Document</div><div class="comp-value"><a href="' + baseUrl + escapeHtml(s.submissionDocumentUrl) + '" target="_blank" class="btn btn-ghost" style="padding:4px 10px;font-size:11px;color:var(--primary);font-weight:600;"><i class="fas fa-download"></i> View / Download Document</a></div></div>' : '') +
                        '</div>' +
                        '<div style="font-size:11.5px;color:var(--gray-500);margin-top:10px;display:flex;align-items:center;gap:6px;"><i class="fas fa-lock" style="color:var(--success);"></i> <span>This compliance is completed and verified. Only Company Admin can edit completion records.</span></div>' +
                    '</div>' : '') +
                '</div>' +
            '</div>';
        });

        container.innerHTML = html;
    }

    function openCompleteModal(assignmentId, title) {
        document.getElementById('completeAssignmentId').value = assignmentId;
        document.getElementById('completeComplianceTitle').textContent = title;
        document.getElementById('submissionReference').value = '';
        document.getElementById('submissionDocument').value = '';
        document.getElementById('completeModal').classList.add('active');
    }

    function closeCompleteModal() {
        document.getElementById('completeModal').classList.remove('active');
    }

    async function submitMarkComplete(e) {
        e.preventDefault();
        const id = document.getElementById('completeAssignmentId').value;
        const ref = document.getElementById('submissionReference').value;
        const fileInput = document.getElementById('submissionDocument');

        const btn = document.getElementById('btnSubmitComplete');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';

        try {
            const formData = new FormData();
            formData.append('submissionReference', ref);
            if (fileInput.files.length > 0) {
                formData.append('document', fileInput.files[0]);
            }

            const res = await api('/api/employee/compliance/' + id + '/complete', {
                method: 'POST',
                isFormData: true,
                body: formData
            });

            if (res && res.success) {
                toast('Compliance marked as completed successfully!', 'success');
                closeCompleteModal();
                await loadCompliances();
                if (currentGroupTitle) {
                    renderSubComplianceGrid();
                }
            } else {
                toast((res && res.message) || 'Failed to complete compliance', 'error');
            }
        } catch(err) {
            toast('Error marking compliance as completed', 'error');
        } finally {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-check"></i> Submit Completion';
        }
    }

    // ==================== CHANGE PASSWORD ====================
    function openChangePasswordModal() {
        document.getElementById('currentPassword').value = '';
        document.getElementById('newPassword').value = '';
        document.getElementById('confirmPassword').value = '';
        document.getElementById('pwdMatchMsg').style.display = 'none';
        resetRequirementsColors();
        document.getElementById('changePasswordModal').classList.add('active');
    }

    function closeChangePasswordModal() {
        document.getElementById('changePasswordModal').classList.remove('active');
    }

    function togglePassVisibility(id, btn) {
        const input = document.getElementById(id);
        const icon = btn.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    function resetRequirementsColors() {
        const ids = ['req-len', 'req-upper', 'req-lower', 'req-num', 'req-special'];
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.style.color = 'var(--gray-500)';
                const icon = el.querySelector('i');
                if (icon) {
                    icon.className = 'fas fa-circle';
                    icon.style.fontSize = '7px';
                }
            }
        });
    }

    function checkEmployeePasswordStrength(pwd) {
        const checks = {
            'req-len': pwd.length >= 8,
            'req-upper': /[A-Z]/.test(pwd),
            'req-lower': /[a-z]/.test(pwd),
            'req-num': /[0-9]/.test(pwd),
            'req-special': /[@#$%^&+=]/.test(pwd)
        };

        for (const [id, met] of Object.entries(checks)) {
            const el = document.getElementById(id);
            if (el) {
                el.style.color = met ? 'var(--success)' : 'var(--gray-500)';
                const icon = el.querySelector('i');
                if (icon) {
                    icon.className = met ? 'fas fa-check-circle' : 'fas fa-circle';
                    icon.style.fontSize = met ? '10px' : '7px';
                }
            }
        }
        checkPasswordMatch();
    }

    function checkPasswordMatch() {
        const newPwd = document.getElementById('newPassword').value;
        const confPwd = document.getElementById('confirmPassword').value;
        const msg = document.getElementById('pwdMatchMsg');

        if (!confPwd) {
            msg.style.display = 'none';
            return;
        }

        msg.style.display = 'block';
        if (newPwd === confPwd) {
            msg.style.color = 'var(--success)';
            msg.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
        } else {
            msg.style.color = 'var(--danger)';
            msg.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
        }
    }

    async function submitChangePassword(e) {
        e.preventDefault();
        const currentPassword = document.getElementById('currentPassword').value.trim();
        const newPassword = document.getElementById('newPassword').value.trim();
        const confirmPassword = document.getElementById('confirmPassword').value.trim();

        if (!currentPassword || !newPassword || !confirmPassword) {
            toast('Please fill in all password fields', 'error');
            return;
        }

        if (newPassword !== confirmPassword) {
            toast('New password and confirm password do not match', 'error');
            return;
        }

        const pwdRegex = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,}$/;
        if (!pwdRegex.test(newPassword)) {
            toast('New password must contain at least 8 characters, one uppercase, one lowercase, one number, and one special character (@#$%^&+=)', 'error');
            return;
        }

        const btn = document.getElementById('btnSubmitChangePassword');
        btn.disabled = true;
        const origHtml = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';

        try {
            const res = await api('/api/employee/change-password', {
                method: 'PUT',
                body: JSON.stringify({
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    confirmPassword: confirmPassword
                })
            });

            if (res && res.success) {
                toast('Password changed successfully!', 'success');
                closeChangePasswordModal();
            } else {
                toast((res && res.message) || (res && res.error) || 'Failed to change password', 'error');
            }
        } catch(err) {
            toast('Error changing password. Please try again.', 'error');
        } finally {
            btn.disabled = false;
            btn.innerHTML = origHtml;
        }
    }

    document.getElementById('completeModal').addEventListener('click', function(e) { if (e.target === this) closeCompleteModal(); });
    document.getElementById('changePasswordModal').addEventListener('click', function(e) { if (e.target === this) closeChangePasswordModal(); });

    document.addEventListener('DOMContentLoaded', () => {
        loadProfile();
        loadCompliances();
    });
</script>
</body>
</html>