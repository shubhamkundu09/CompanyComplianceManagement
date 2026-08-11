<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- File: companyadmin/parent-compliances.jsp --%>
<% pageContext.setAttribute("pageTitle", "My Compliances"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP — My Compliances</title>

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

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--gray-50);
            color: var(--gray-800);
            min-height: 100vh;
        }

        /* ==================== LOGO BACKGROUND ==================== */
        .logo-bg {
            position: fixed; top: 50%; left: 54%;
            transform: translate(-50%, -50%);
            width: 500px; height: 900px;
            opacity: 0.38; pointer-events: none; z-index: 0;
            display: flex; align-items: center; justify-content: center;
        }
        .logo-bg img { width: 100%; height: 100%; object-fit: contain; }

        /* ==================== LAYOUT ==================== */
        .app-wrapper { display: flex; min-height: 100vh; position: relative; z-index: 1; }

        /* ==================== SIDEBAR ==================== */
        .sidebar {
            width: 260px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(226, 232, 240, 0.6);
            padding: 24px 16px;
            position: fixed; top: 0; left: 0; height: 100vh;
            overflow-y: auto; z-index: 50;
            transition: transform 0.3s ease;
        }
        .sidebar-brand {
            display: flex; align-items: center; gap: 12px;
            padding: 0 8px 24px;
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            margin-bottom: 24px;
        }
        .sidebar-brand .brand-icon {
            width: 42px; height: 42px;

            border-radius: var(--radius);
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 18px; font-weight: 700;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }
        .sidebar-brand .brand-text { font-size: 20px; font-weight: 700; color: var(--gray-900); letter-spacing: -0.5px; }
        .sidebar-brand .brand-badge {
            font-size: 10px; font-weight: 600; color: var(--gray-500);
            background: var(--gray-100); padding: 2px 8px; border-radius: 20px; margin-left: -4px;
        }
        .sidebar-label {
            font-size: 11px; font-weight: 600; color: var(--gray-400);
            text-transform: uppercase; letter-spacing: 0.8px;
            padding: 8px 12px 6px; margin-top: 8px;
        }
        .nav-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 12px; border-radius: var(--radius);
            color: var(--gray-600); text-decoration: none;
            font-size: 14px; font-weight: 500;
            transition: all 0.2s; margin-bottom: 2px; cursor: pointer;
        }
        .nav-item:hover { background: rgba(79, 70, 229, 0.08); color: var(--gray-900); }
        .nav-item.active { background: rgba(79, 70, 229, 0.12); color: var(--primary); }
        .nav-item i { width: 20px; text-align: center; font-size: 15px; }

        /* ==================== HEADER ==================== */
        .header {
            position: fixed; top: 0; left: 260px; right: 0; height: 64px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.6);
            z-index: 40; display: flex; align-items: center;
            justify-content: space-between; padding: 0 32px;
            transition: left 0.3s ease;
        }
        .header-left { display: flex; align-items: center; gap: 16px; }
        .header-left .menu-toggle { display: none; background: none; border: none; font-size: 20px; color: var(--gray-600); cursor: pointer; padding: 4px; }
        .header-left .page-title { font-size: 18px; font-weight: 600; color: var(--gray-900); }
        .header-right { display: flex; align-items: center; gap: 16px; }
        .header-btn {
            width: 40px; height: 40px; border-radius: 50%;
            border: 1px solid rgba(226, 232, 240, 0.6);
            background: rgba(255, 255, 255, 0.5); color: var(--gray-600);
            cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; position: relative;
        }
        .header-btn:hover { background: var(--gray-100); border-color: var(--gray-300); color: var(--gray-800); }
        .header-btn .badge-count {
            position: absolute; top: -4px; right: -4px;
            background: var(--danger); color: white;
            font-size: 10px; font-weight: 700; padding: 2px 6px;
            border-radius: 20px; min-width: 18px; text-align: center; border: 2px solid white;
        }
        .header-user {
            display: flex; align-items: center; gap: 10px;
            padding: 4px 12px 4px 4px; border-radius: 40px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            background: rgba(255, 255, 255, 0.5); cursor: pointer; transition: all 0.2s;
        }
        .header-user:hover { background: var(--gray-100); border-color: var(--gray-300); }
        .header-user .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 600; font-size: 12px;
        }
        .header-user .user-info { display: flex; flex-direction: column; }
        .header-user .user-name { font-size: 13px; font-weight: 600; color: var(--gray-800); line-height: 1.2; }
        .header-user .user-role { font-size: 10px; color: var(--gray-500); text-transform: uppercase; letter-spacing: 0.3px; }

        /* ==================== NOTIFICATION DROPDOWN ==================== */
        .notification-dropdown {
            display: none; position: absolute; top: 56px; right: 0;
            width: 380px; max-height: 460px; overflow-y: auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius-lg); box-shadow: var(--shadow-xl); z-index: 60;
        }
        .notification-dropdown.open { display: block; animation: slideDown 0.25s ease; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        .notification-header { padding: 16px 20px; border-bottom: 1px solid rgba(226, 232, 240, 0.6); display: flex; justify-content: space-between; align-items: center; }
        .notification-header h4 { font-size: 14px; font-weight: 600; color: var(--gray-900); }
        .notification-header .mark-all { font-size: 12px; color: var(--primary); cursor: pointer; font-weight: 500; }
        .notification-header .mark-all:hover { text-decoration: underline; }
        .notification-item { padding: 14px 20px; border-bottom: 1px solid rgba(226, 232, 240, 0.4); transition: background 0.2s; cursor: default; }
        .notification-item:hover { background: rgba(79, 70, 229, 0.04); }
        .notification-item:last-child { border-bottom: none; }
        .notification-item .notif-title { font-size: 13px; font-weight: 500; color: var(--gray-800); }
        .notification-item .notif-message { font-size: 12px; color: var(--gray-500); margin-top: 2px; line-height: 1.4; }
        .notification-item .notif-time { font-size: 11px; color: var(--gray-400); margin-top: 4px; }
        .notification-item .notif-dot { display: inline-block; width: 6px; height: 6px; border-radius: 50%; margin-right: 8px; }
        .notification-item .notif-dot.urgent { background: var(--danger); }
        .notification-item .notif-dot.important { background: var(--warning); }
        .notification-item .notif-dot.general { background: var(--primary); }
        .notification-footer { padding: 12px 20px; border-top: 1px solid rgba(226, 232, 240, 0.6); text-align: center; }
        .notification-footer a { font-size: 12px; color: var(--primary); text-decoration: none; font-weight: 500; }
        .notification-footer a:hover { text-decoration: underline; }
        .notification-empty { text-align: center; padding: 40px 20px; color: var(--gray-500); }
        .notification-empty i { font-size: 32px; opacity: 0.3; margin-bottom: 8px; }

        /* ==================== MAIN CONTENT ==================== */
        .main-content {
            margin-left: 260px; margin-top: 64px; padding: 32px 40px;
            flex: 1; min-height: calc(100vh - 64px); position: relative; z-index: 1;
        }

        /* ==================== STATS ==================== */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 28px; }
        .stat-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg); padding: 20px 24px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04); transition: all 0.3s; cursor: default;
        }
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px); border-color: var(--primary-light);
        }
        .stat-card .stat-top { display: flex; justify-content: space-between; align-items: flex-start; }
        .stat-card .stat-label { font-size: 13px; font-weight: 500; color: var(--gray-500); }
        .stat-card .stat-icon {
            width: 44px; height: 44px; border-radius: var(--radius);
            display: flex; align-items: center; justify-content: center; font-size: 18px;
            background: rgba(255, 255, 255, 0.5); backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .stat-card .stat-value { font-size: 32px; font-weight: 700; color: var(--gray-900); margin-top: 8px; letter-spacing: -0.5px; }
        .stat-card .stat-sub { font-size: 12px; color: var(--gray-500); margin-top: 4px; }
        .stat-icon.blue { color: var(--primary); }
        .stat-icon.green { color: var(--success); }
        .stat-icon.red { color: var(--danger); }
        .stat-icon.yellow { color: var(--warning); }

        /* ==================== FILTER BAR ==================== */
        .filter-bar {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg); padding: 16px 20px;
            margin-bottom: 20px; box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }
        .filter-grid { display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; }
        .filter-item { flex: 1; min-width: 160px; }
        .filter-item.search-item { flex: 2; min-width: 200px; }
        .position-relative { position: relative; }
        .search-icon { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 12px; }
        .search-icon + .form-input { padding-left: 32px; }
        .filter-actions { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; margin-top: 12px; }

        /* ==================== INFO BANNER ==================== */
        .info-banner {
            background: rgba(79, 70, 229, 0.06);
            border-left: 3px solid var(--primary);
            border-radius: var(--radius); padding: 14px 18px;
            margin-bottom: 20px; display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
        }
        .info-banner i { color: var(--primary); font-size: 16px; flex-shrink: 0; }
        .info-banner .info-text { font-size: 12px; color: var(--gray-500); }
        .info-banner .info-text strong { color: var(--gray-800); }

        /* ==================== COMPLIANCE GRID ==================== */
        .compliance-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 20px; }

        /* ==================== VNEXT COMPLIANCE CARDS ==================== */
        .compliance-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: var(--radius-lg);
            padding: 0; overflow: hidden; position: relative;
            cursor: pointer; transition: all 0.3s ease;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
        }
        .compliance-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 2px;
            background: linear-gradient(90deg, transparent, var(--primary), var(--primary-light), var(--primary), transparent);
            z-index: 1;
        }
        .compliance-card:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateY(-4px); border-color: var(--primary-light);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(79, 70, 229, 0.12);
        }

        /* ==================== VNEXT CARD INTERNALS ==================== */
        .vnext-card-body { padding: 20px 20px 14px; }

        .vnext-card-top { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 12px; }

        .vnext-card-icon {
            width: 46px; height: 46px; min-width: 46px; border-radius: 50%;
            background: rgb(0 0 0);
            border: 1.5px solid rgba(79, 70, 229, 0.2);
            display: flex; align-items: center; justify-content: center;
            color: #e9d80f; font-size: 18px; flex-shrink: 0;
        }

        .vnext-card-title-block { flex: 1; min-width: 0; }

        .vnext-card-title {
            font-size: 14px; font-weight: 900; color: var(--gray-900);
            text-transform: uppercase; letter-spacing: 0.5px;
            line-height: 1.3; margin-bottom: 7px;
        }

        .vnext-card-badges { display: flex; gap: 6px; flex-wrap: wrap; align-items: center; }

        .vnext-badge {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 3px 9px; border-radius: 20px;
            font-size: 10px; font-weight: 600; letter-spacing: 0.2px;
        }
        .vnext-badge-completed { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.2); }
        .vnext-badge-overdue   { background: var(--danger-bg);  color: var(--danger);  border: 1px solid rgba(239,68,68,0.2); }
        .vnext-badge-warning   { background: var(--warning-bg); color: var(--warning); border: 1px solid rgba(245,158,11,0.2); }
        .vnext-badge-info      { background: var(--info-bg);    color: var(--info);    border: 1px solid rgba(59,130,246,0.2); }
        .vnext-badge-custom    { background: var(--primary-bg); color: var(--primary); border: 1px solid rgba(79,70,229,0.2); }
        .vnext-badge-success   { background: var(--success-bg); color: var(--success); border: 1px solid rgba(16,185,129,0.2); }

        .vnext-card-meta {
            display: flex; gap: 10px; flex-wrap: wrap;
            padding: 10px 0; margin-bottom: 10px;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }
        .vnext-meta-item { font-size: 11px; color: var(--gray-500); display: flex; align-items: center; gap: 4px; }
        .vnext-meta-item i { color: var(--primary); opacity: 0.7; font-size: 10px; }

        /* ==================== SUB-COMPLIANCE LIST ==================== */
        .vnext-sub-list { display: flex; flex-direction: column; gap: 0; }
        .vnext-sub-list-title {
            font-size: 10px; font-weight: 600; color: black;
            text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 6px;
        }
        .vnext-sub-item {
            display: flex; align-items: center; gap: 8px;
            padding: 7px 0; border-bottom: 1px solid rgba(226, 232, 240, 0.3);
        }
        .vnext-sub-item:last-child { border-bottom: none; }
        .vnext-sub-bullet { width: 5px; height: 5px; min-width: 5px; border-radius: 50%; background: var(--primary); opacity: 0.5; flex-shrink: 0; }
        .vnext-sub-name { font-size: 12px; color: var(--gray-700); flex: 1; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .vnext-sub-right { display: flex; align-items: center; gap: 6px; flex-shrink: 0; }
        .vnext-due-label { font-size: 10px; color: var(--gray-400); white-space: nowrap; }
        .vnext-due-label.overdue { color: var(--danger); font-weight: 600; }
        .vnext-due-label.warning { color: var(--warning); font-weight: 600; }

        .vnext-no-sub-due {
            padding: 8px 0; font-size: 12px; color: var(--gray-500);
            display: flex; align-items: center; gap: 8px;
        }
        .vnext-no-sub-due i { color: var(--primary); }
        .vnext-more-subs { font-size: 11px; color: var(--gray-400); padding: 6px 0 0; text-align: center; }

        /* ==================== BLINKERS ==================== */
        .vnext-blinker { width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0; }
        .blinker-overdue { background: var(--danger); box-shadow: 0 0 8px rgba(239,68,68,0.9); animation: blink-overdue 0.55s ease-in-out infinite; }
        .blinker-danger  { background: var(--danger); box-shadow: 0 0 12px rgba(239,68,68,0.8); animation: blink-danger 0.38s ease-in-out infinite; }
        .blinker-warning { background: var(--warning); box-shadow: 0 0 8px rgba(245,158,11,0.7); animation: blink-warning 0.9s ease-in-out infinite; }
        .blinker-ok      { background: var(--success); box-shadow: 0 0 5px rgba(16,185,129,0.45); }

        @keyframes blink-overdue { 0%,100% { opacity:1; transform:scale(1.1); } 50% { opacity:0.15; transform:scale(0.75); } }
        @keyframes blink-danger  { 0%,100% { opacity:1; transform:scale(1.2); } 50% { opacity:0.05; transform:scale(0.65); } }
        @keyframes blink-warning { 0%,100% { opacity:1; transform:scale(1);   } 50% { opacity:0.3;  transform:scale(0.82); } }

        /* ==================== CARD FOOTER ==================== */
        .vnext-card-footer {
            display: flex; gap: 8px;
            padding: 12px 20px 16px;
            border-top: 1px solid rgba(226, 232, 240, 0.5);
            background: rgba(248, 250, 252, 0.5);
        }
        .vnext-btn {
            flex: 1; display: flex; align-items: center; justify-content: center; gap: 5px;
            padding: 7px 12px; border-radius: 8px;
            font-size: 12px; font-weight: 500; font-family: 'Inter', sans-serif;
            cursor: pointer; border: none; transition: all 0.2s; text-decoration: none;
        }
        .vnext-btn-gold {
            background: var(--primary-bg); color: var(--primary);
            border: 1px solid rgba(79, 70, 229, 0.25);
        }
        .vnext-btn-gold:hover { background: rgba(79, 70, 229, 0.15); box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15); }
        .vnext-btn-ghost {
            background: rgba(255, 255, 255, 0.5); color: var(--gray-500);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
        .vnext-btn-ghost:hover { background: var(--gray-100); color: var(--gray-700); border-color: var(--gray-300); }
        .vnext-btn-success {
            background: var(--success-bg); color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.25);
        }
        .vnext-btn-success:hover { background: rgba(16, 185, 129, 0.2); box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15); }

        /* ==================== BUTTONS ==================== */
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 16px; border-radius: var(--radius);
            font-size: 13px; font-weight: 500; border: none; cursor: pointer;
            transition: all 0.2s; font-family: 'Inter', sans-serif;
            background: rgba(255, 255, 255, 0.5); backdrop-filter: blur(4px);
            border: 1px solid rgba(226, 232, 240, 0.6);
            color: var(--gray-600); text-decoration: none;
        }
        .btn:hover { background: var(--gray-100); border-color: var(--gray-300); }
        .btn-primary { background: var(--primary); color: white; border-color: var(--primary); }
        .btn-primary:hover { background: var(--primary-dark); border-color: var(--primary-dark); box-shadow: 0 4px 16px rgba(79, 70, 229, 0.3); }
        .btn-ghost { background: transparent; border: 1px solid rgba(226, 232, 240, 0.6); }
        .btn-ghost:hover { background: rgba(255, 255, 255, 0.5); border-color: var(--gray-300); }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; }

        /* ==================== FORM ==================== */
        .form-label { display: block; font-size: 12px; font-weight: 500; color: var(--gray-700); margin-bottom: 4px; }
        .form-input {
            padding: 8px 12px; border: 1px solid rgba(226, 232, 240, 0.6);
            border-radius: var(--radius); font-size: 13px; font-family: 'Inter', sans-serif;
            background: rgba(255, 255, 255, 0.5); backdrop-filter: blur(4px);
            color: var(--gray-800); transition: all 0.2s; outline: none; width: 100%;
        }
        .form-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); background: rgba(255, 255, 255, 0.8); }
        .form-input::placeholder { color: var(--gray-400); }
        select.form-input {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat; background-position: right 12px center; padding-right: 36px;
        }

        /* ==================== EMPTY / SPINNER ==================== */
        .empty-state { text-align: center; padding: 60px 24px; color: var(--gray-500); }
        .empty-state i { font-size: 48px; opacity: 0.3; display: block; margin-bottom: 12px; }
        .empty-state p { font-size: 15px; margin-top: 8px; }
        .empty-state .sub-text { font-size: 12px; color: var(--gray-500); margin-top: 4px; }
        .spinner {
            width: 36px; height: 36px;
            border: 3px solid rgba(226, 232, 240, 0.6); border-top-color: var(--primary);
            border-radius: 50%; animation: spin 0.7s linear infinite; margin: 0 auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ==================== TOAST ==================== */
        #toast-container { position: fixed; bottom: 24px; right: 24px; z-index: 999; display: flex; flex-direction: column; gap: 8px; }
        .toast {
            padding: 12px 18px; border-radius: var(--radius); font-size: 13px; font-weight: 500;
            display: flex; align-items: center; gap: 10px; min-width: 280px;
            animation: slideIn 0.3s ease; box-shadow: var(--shadow-lg);
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        @keyframes slideIn { from { opacity: 0; transform: translateX(20px); } to { opacity: 1; transform: translateX(0); } }
        .toast-success { color: var(--success); }
        .toast-error   { color: var(--danger); }
        .toast-info    { color: var(--primary); }
        .toast-warning { color: var(--warning); }

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
            .stats-grid { grid-template-columns: 1fr; }
            .header { padding: 0 16px; }
            .main-content { padding: 16px; }
            .header-user .user-info { display: none; }
            .notification-dropdown { width: 320px; right: -60px; }
            .logo-bg { width: 300px; height: 300px; opacity: 0.06; }
            .compliance-grid { grid-template-columns: 1fr; }
            .filter-item { min-width: 100%; }
            .filter-item.search-item { flex: 1; min-width: 100%; }
            .filter-actions .btn { flex: 1; justify-content: center; }
        }
        @media (max-width: 480px) {
            .stat-card .stat-value { font-size: 24px; }
            .header-left .page-title { font-size: 15px; }
            .notification-dropdown { width: 280px; right: -80px; }
        }
    </style>
</head>
<body>

<div class="logo-bg">
    <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
</div>

<div id="toast-container"></div>

<div class="app-wrapper">

    <!-- ==================== SIDEBAR ==================== -->
   <aside class="sidebar" id="sidebar">
           <div class="sidebar-brand">
               <div class="brand-icon">
                <img style="width:100%;"  src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
               </div>
               <span class="brand-text">VNext Legal</span>
               <span class="brand-badge">LLP</span>
           </div>

           <div class="sidebar-label">Main</div>
           <a href="${pageContext.request.contextPath}/company-admin/dashboard" class="nav-item">
               <i class="fas fa-chart-pie"></i> Dashboard
           </a>

           <div class="sidebar-label">Management</div>
           <a href="${pageContext.request.contextPath}/company-admin/employees" class="nav-item">
               <i class="fas fa-users"></i> Employees
               <span class="nav-badge" id="employeeCount">0</span>
           </a>

           <div class="sidebar-label">Compliance</div>
           <a href="${pageContext.request.contextPath}/company-admin/compliance/list" class="nav-item active">
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

    <!-- ==================== HEADER ==================== -->
    <header class="header">
        <div class="header-left">
            <button class="menu-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
            <span class="page-title">My Compliances</span>
        </div>
        <div class="header-right">
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
                        <div class="notification-empty"><i class="fas fa-spinner fa-spin"></i><div style="margin-top:8px;">Loading...</div></div>
                    </div>
                    <div class="notification-footer">
                        <a href="${pageContext.request.contextPath}/company-admin/notifications">View all notifications</a>
                    </div>
                </div>
            </div>
            <div class="header-user" onclick="window.location.href='${pageContext.request.contextPath}/company-admin/company-details'">
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

        <!-- Page Header -->
        <div style="margin-bottom:24px;">
            <p style="font-size:12px;color:var(--primary);font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">Compliance Management</p>
            <h1 style="font-size:24px;font-weight:700;color:var(--gray-900);">My Compliances</h1>
            <p style="font-size:13px;color:var(--gray-500);margin-top:4px;">Compliance categories assigned to your company. Configure and assign them to employees.</p>
        </div>

        <!-- Info Banner -->
        <div class="info-banner">
            <i class="fas fa-info-circle"></i>
            <div class="info-text">
                <strong>How it works:</strong>
                1. SuperAdmin creates and configures compliances. &nbsp;|&nbsp;
                2. You <strong>assign</strong> them to employees. &nbsp;|&nbsp;
                3. You can also create <strong>custom compliances</strong> for your company.
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Total Compliances</div>
                        <div class="stat-value" id="statTotal">—</div>
                        <div class="stat-sub">All categories</div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-tags"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">SuperAdmin Created</div>
                        <div class="stat-value" id="statSuperAdmin" style="color:var(--primary);">—</div>
                        <div class="stat-sub">Managed by SuperAdmin</div>
                    </div>
                    <div class="stat-icon blue"><i class="fas fa-user-shield"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Custom (Your Own)</div>
                        <div class="stat-value" id="statCustom">—</div>
                        <div class="stat-sub">Created by you</div>
                    </div>
                    <div class="stat-icon green"><i class="fas fa-user-tie"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-top">
                    <div>
                        <div class="stat-label">Configured</div>
                        <div class="stat-value" id="statConfigured">—</div>
                        <div class="stat-sub">Ready to assign</div>
                    </div>
                    <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <div class="filter-grid">
                <div class="filter-item">
                    <label class="form-label">Filter by Type</label>
                    <select id="typeFilter" class="form-input">
                        <option value="all">All Compliances</option>
                        <option value="superadmin">SuperAdmin Created</option>
                        <option value="custom">Custom (Your Own)</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Status Filter</label>
                    <select id="statusFilter" class="form-input">
                        <option value="all">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="OVERDUE">Overdue</option>
                    </select>
                </div>
                <div class="filter-item search-item">
                    <label class="form-label">Search</label>
                    <div class="position-relative">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchInput" class="form-input" placeholder="Search compliance name...">
                    </div>
                </div>
            </div>
            <div class="filter-actions">
                <button onclick="refreshList()" class="btn btn-ghost"><i class="fas fa-sync-alt"></i> Refresh</button>
                <a href="${pageContext.request.contextPath}/company-admin/compliance/custom/create?mode=new" class="btn btn-primary"><i class="fas fa-plus"></i> Create Custom</a>
                <a href="${pageContext.request.contextPath}/company-admin/compliance/calendar" class="btn btn-ghost"><i class="fas fa-calendar-alt"></i> Calendar View</a>
            </div>
        </div>

        <!-- Loader -->
        <div id="loader" style="text-align:center;padding:60px;">
            <div class="spinner" style="margin:0 auto 12px;"></div>
            <div style="color:var(--gray-500);font-size:13px;">Loading your compliance categories...</div>
        </div>

        <!-- Compliance Grid -->
        <div id="complianceGrid" class="compliance-grid" style="display:none;"></div>

        <!-- Empty State -->
        <div id="emptyState" style="display:none;">
            <div class="empty-state">
                <i class="fas fa-clipboard-list"></i>
                <p>No compliance categories assigned</p>
                <p class="sub-text">SuperAdmin will assign categories, or you can create your own custom compliances.</p>
                <a href="${pageContext.request.contextPath}/company-admin/compliance/custom/create?mode=new" class="btn btn-primary" style="margin-top:12px;">
                    <i class="fas fa-plus"></i> Create Custom Compliance
                </a>
            </div>
        </div>

    </main>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    var groupedCompliances = [];
    var filteredCompliances = [];

    // ==================== TOAST ====================
    function toast(message, type, duration) {
        type = type || 'info'; duration = duration || 3500;
        var container = document.getElementById('toast-container');
        var icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle', warning: 'fa-exclamation-triangle' };
        var el = document.createElement('div');
        el.className = 'toast toast-' + type;
        el.innerHTML = '<i class="fas ' + icons[type] + '"></i><span>' + message + '</span>';
        container.appendChild(el);
        setTimeout(function() { el.style.opacity = '0'; el.style.transform = 'translateX(20px)'; el.style.transition = 'all .3s'; setTimeout(function() { el.remove(); }, 300); }, duration);
    }

    // ==================== API ====================
    async function api(url, options) {
        options = options || {};
        var token = localStorage.getItem('accessToken');
        if (!token) { window.location.href = contextPath + '/login?error=Session expired'; return null; }
        var defaults = { headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' } };
        var merged = Object.assign({}, defaults, options, { headers: Object.assign({}, defaults.headers, options.headers || {}) });
        try {
            var response = await fetch(contextPath + url, merged);
            if (response.status === 401) { localStorage.removeItem('accessToken'); localStorage.removeItem('user'); window.location.href = contextPath + '/login?error=Session expired'; return null; }
            return response.json();
        } catch (error) { console.error('API Error:', error); return null; }
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m;
        });
    }

    function formatDate(d) {
        if (!d) return '—';
        try { var date = new Date(d); if (isNaN(date.getTime())) return '—'; return date.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' }); }
        catch(e) { return '—'; }
    }

    function getDaysRemaining(dueDate) {
        if (!dueDate) return null;
        var today = new Date(); today.setHours(0, 0, 0, 0);
        var due = new Date(dueDate); due.setHours(0, 0, 0, 0);
        return Math.ceil((due - today) / (1000 * 60 * 60 * 24));
    }

    function getStatusInfo(status) {
        var map = {
            'PENDING':     { label: 'Pending',     cls: 'badge-warning', icon: 'fa-clock' },
            'IN_PROGRESS': { label: 'In Progress',  cls: 'badge-info',    icon: 'fa-spinner' },
            'COMPLETED':   { label: 'Completed',    cls: 'badge-success', icon: 'fa-check-circle' },
            'OVERDUE':     { label: 'Overdue',      cls: 'badge-danger',  icon: 'fa-exclamation-triangle' }
        };
        return map[status] || { label: status || 'Pending', cls: 'badge-warning', icon: 'fa-circle' };
    }

    function getFrequencyLabel(freq) {
        var map = { 'MONTHLY': 'Monthly', 'QUARTERLY': 'Quarterly', 'HALF_YEARLY': 'Half Yearly', 'YEARLY': 'Yearly', 'ONE_TIME': 'One Time' };
        return map[freq] || freq || '—';
    }

    // ==================== VNEXT CARD HELPERS ====================
    function getBlinkerClass(dueDate, currentStatus) {
        if (currentStatus === 'COMPLETED') return 'blinker-ok';
        if (!dueDate) return '';
        var days = getDaysRemaining(dueDate);
        if (days === null || isNaN(days)) return '';
        if (days < 0)  return 'blinker-overdue';
        if (days <= 1) return 'blinker-danger';
        if (days <= 3) return 'blinker-warning';
        return '';
    }

    function getVNextBadgeClass(status) {
        var map = { 'COMPLETED': 'vnext-badge-completed', 'OVERDUE': 'vnext-badge-overdue', 'IN_PROGRESS': 'vnext-badge-info', 'PENDING': 'vnext-badge-warning' };
        return map[status] || 'vnext-badge-warning';
    }

    function getStatusIconClass(status) {
        var map = { 'COMPLETED': 'fa-check-circle', 'OVERDUE': 'fa-exclamation-triangle', 'IN_PROGRESS': 'fa-spinner', 'PENDING': 'fa-clock' };
        return map[status] || 'fa-circle';
    }

    function getComplianceIcon(name) {
        if (!name) return 'fa-tasks';
        var n = name.toLowerCase();
        if (n.includes('gst') || n.includes('indirect tax'))                           return 'fa-file-invoice-dollar';
        if (n.includes('direct tax') || n.includes('income tax') || n.includes('tds')) return 'fa-calculator';
        if (n.includes('pf') || n.includes('provident') || n.includes('esic') || n.includes('labour')) return 'fa-users';
        if (n.includes('company') || n.includes('corporate') || n.includes('mca') || n.includes('roc'))  return 'fa-building';
        if (n.includes('environment') || n.includes('pollution') || n.includes('pcb'))  return 'fa-leaf';
        if (n.includes('licence') || n.includes('license') || n.includes('permit') || n.includes('shop')) return 'fa-id-card';
        if (n.includes('audit') || n.includes('account') || n.includes('balance'))      return 'fa-balance-scale';
        if (n.includes('return') || n.includes('filing') || n.includes('annual'))       return 'fa-file-alt';
        if (n.includes('legal') || n.includes('court') || n.includes('contract'))       return 'fa-gavel';
        if (n.includes('insurance') || n.includes('policy'))                            return 'fa-shield-alt';
        if (n.includes('fssai') || n.includes('food'))                                  return 'fa-utensils';
        if (n.includes('fire') || n.includes('safety'))                                 return 'fa-fire-extinguisher';
        if (n.includes('electricity') || n.includes('power'))                           return 'fa-bolt';
        return 'fa-tasks';
    }

    // ==================== BUILD PARENT CARD (VNext Style) ====================
   function buildParentCard(item) {
       var isSA = item.isSuperAdmin;
       var isConfigured = item.isConfigured;
       var hasSubs = item.subCompliances && item.subCompliances.length > 0;
       var totalSubs = hasSubs ? item.subCompliances.length : 0;
       var configuredSubs = hasSubs
           ? item.subCompliances.filter(function (s) { return s.isConfigured; }).length
           : 0;
       var subCompliances = hasSubs ? item.subCompliances : [];

       // ===== GET PRIORITY =====
       var priority = item.priority || 0;

       var statusBadgeClass = getVNextBadgeClass(item.status);
       var statusIcon = getStatusIconClass(item.status);
       var statusLabel = getStatusInfo(item.status).label;
       var cardIcon = getComplianceIcon(item.templateName || item.name || "");

       var complianceId = item.templateId || item.id || item.companyComplianceId || null;
       if (!complianceId || complianceId === "null" || complianceId === "undefined") complianceId = null;
       var hasValidId = complianceId !== null;

       // Determine config badge
       var configLabel, configIcon, configBadgeClass;
       if (hasSubs) {
           if (configuredSubs > 0 && configuredSubs === totalSubs) {
               configLabel = "All Configured";
               configIcon = "fa-check-circle";
               configBadgeClass = "vnext-badge-completed";
           } else if (configuredSubs > 0) {
               configLabel = configuredSubs + "/" + totalSubs + " Configured";
               configIcon = "fa-clock";
               configBadgeClass = "vnext-badge-warning";
           } else {
               configLabel = "Not Configured";
               configIcon = "fa-clock";
               configBadgeClass = "vnext-badge-warning";
           }
       } else {
           if (isConfigured) {
               configLabel = "Configured";
               configIcon = "fa-check-circle";
               configBadgeClass = "vnext-badge-completed";
           } else {
               configLabel = "Not Configured";
               configIcon = "fa-clock";
               configBadgeClass = "vnext-badge-warning";
           }
       }

       // ===== PRIORITY BADGE =====
       var priorityBadge = '<span class="vnext-badge" style="background:rgba(79,70,229,0.1);color:var(--primary);border:1px solid rgba(79,70,229,0.2);">' +
           '<i class="fas fa-sort-numeric-down"></i> Priority: ' + priority +
           '</span>';

       // Sub-list HTML
       var subListHtml = "";
       if (hasSubs && subCompliances.length > 0) {
           subListHtml = '<div class="vnext-sub-list"><div class="vnext-sub-list-title"><i class="fas fa-list" style="margin-right:4px;"></i>Sub-Compliances</div>';
           var displaySubs = subCompliances.slice(0, 5);
           for (var j = 0; j < displaySubs.length; j++) {
               var s = displaySubs[j];
               var bCls = getBlinkerClass(s.dueDate, s.status);
               var sBadge = getVNextBadgeClass(s.status);
               var sLabel = getStatusInfo(s.status).label;
               var sDue = s.dueDate ? formatDate(s.dueDate) : "—";
               var days = s.dueDate ? getDaysRemaining(s.dueDate) : null;
               var daysLabel = "";
               var dueCls = "";
               if (days !== null && !isNaN(days) && s.status !== "COMPLETED") {
                   if (days < 0) {
                       daysLabel = " (OD)";
                       dueCls = "overdue";
                   } else if (days <= 7) {
                       daysLabel = " (" + days + "d)";
                       dueCls = days <= 3 ? "warning" : "";
                   }
               }
               subListHtml +=
                   '<div class="vnext-sub-item">' +
                   '<span class="vnext-sub-bullet"></span>' +
                   '<span class="vnext-sub-name" title="' + escapeHtml(s.name) + '">' + escapeHtml(s.name) + "</span>" +
                   '<div class="vnext-sub-right">' +
                   '<span class="vnext-due-label ' + dueCls + '">' + sDue + daysLabel + "</span>" +
                   (bCls ? '<span class="vnext-blinker ' + bCls + '"></span>' : "") +
                   '<span class="vnext-badge ' + sBadge + '" style="font-size:9px;padding:2px 6px;">' + sLabel + "</span>" +
                   "</div></div>";
           }
           if (totalSubs > 5) {
               subListHtml += '<div class="vnext-more-subs"><i class="fas fa-ellipsis-h"></i> +' + (totalSubs - 5) + " more</div>";
           }
           subListHtml += "</div>";
       } else if (item.dueDate) {
           var bCls = getBlinkerClass(item.dueDate, item.status);
           var days = getDaysRemaining(item.dueDate);
           var daysLabel = "";
           if (days !== null && !isNaN(days) && item.status !== "COMPLETED") {
               daysLabel = days < 0 ? " (Overdue)" : " (" + days + " day" + (days === 1 ? "" : "s") + ")";
           }
           subListHtml =
               '<div class="vnext-no-sub-due">' +
               '<i class="fas fa-calendar-alt"></i>' +
               "<span>Due: " + formatDate(item.dueDate) + daysLabel + "</span>" +
               (bCls ? '<span class="vnext-blinker ' + bCls + '"></span>' : "") +
               "</div>";
       }

       // Footer buttons
       var showAssign = hasSubs && configuredSubs > 0;
       var showConfigure = !isSA && hasValidId;
       var clickFn = hasValidId
           ? "window.location.href='" + contextPath + "/company-admin/compliance/parent/" + complianceId + "'"
           : "void(0)";

       var footerHtml = "";
       if (showAssign) {
           footerHtml +=
               '<a href="' + contextPath + "/company-admin/compliance/assign?id=" + complianceId + '" class="vnext-btn vnext-btn-gold" onclick="event.stopPropagation();"><i class="fas fa-users"></i> Assign</a>';
       }
       if (showConfigure) {
           footerHtml +=
               '<a href="' + contextPath + "/company-admin/compliance/configure?id=" + complianceId + '" class="vnext-btn vnext-btn-ghost" onclick="event.stopPropagation();"><i class="fas fa-cog"></i> ' +
               (isConfigured ? "Edit Config" : "Configure") +
               "</a>";
       }
       if (hasValidId) {
           footerHtml +=
               '<a href="' + contextPath + "/company-admin/compliance/parent/" + complianceId + '" class="vnext-btn vnext-btn-ghost" style="flex:0 0 auto;padding:7px 10px;" onclick="event.stopPropagation();" title="View Details"><i class="fas fa-arrow-right"></i></a>';
       }
       if (!footerHtml) {
           footerHtml =
               '<button class="vnext-btn vnext-btn-ghost" style="opacity:0.5;cursor:not-allowed;" disabled><i class="fas fa-spinner"></i> Loading...</button>';
       }
       if (!isSA && hasValidId) {
           footerHtml +=
               '<button class="vnext-btn vnext-btn-ghost" style="color:var(--danger);border-color:rgba(239,68,68,0.25);" ' +
               'onclick="event.stopPropagation();deleteCustomCompliance(' + complianceId + ", '" + escapeHtml(item.templateName || item.name) + "')\">" +
               '<i class="fas fa-trash"></i> Delete</button>';
       }

       // ===== BUILD THE CARD HTML WITH PRIORITY BADGE =====
       return (
           '<div class="compliance-card" onclick="' + clickFn + '">' +
           '<div class="vnext-card-body">' +
           '<div class="vnext-card-top">' +
           '<div class="vnext-card-icon"><i class="fas ' + cardIcon + '"></i></div>' +
           '<div class="vnext-card-title-block">' +
           '<div class="vnext-card-title">' + escapeHtml(item.templateName || item.name || "Compliance") + "</div>" +
           '<div class="vnext-card-badges">' +
           '<span class="vnext-badge ' + statusBadgeClass + '"><i class="fas ' + statusIcon + '"></i> ' + statusLabel + "</span>" +
           '<span class="vnext-badge ' + (isSA ? "vnext-badge-info" : "vnext-badge-custom") + '"><i class="fas ' + (isSA ? "fa-user-shield" : "fa-user-tie") + '"></i> ' + (isSA ? "Admin" : "Custom") + "</span>" +
           '<span class="vnext-badge ' + configBadgeClass + '"><i class="fas ' + configIcon + '"></i> ' + configLabel + "</span>" +
           priorityBadge +  // <-- PRIORITY BADGE
           "</div>" +
           "</div>" +
           "</div>" +
           '<div class="vnext-card-meta">' +
           (item.frequency ? '<span class="vnext-meta-item"><i class="fas fa-redo"></i>' + getFrequencyLabel(item.frequency) + "</span>" : "") +
           '<span class="vnext-meta-item"><i class="fas fa-sitemap"></i>' + totalSubs + " sub(s)</span>" +
           (isSA
               ? '<span class="vnext-meta-item"><i class="fas fa-lock"></i>Read-only</span>'
               : '<span class="vnext-meta-item"><i class="fas fa-unlock"></i>Editable</span>') +
           "</div>" +
           subListHtml +
           "</div>" +
           '<div class="vnext-card-footer">' + footerHtml + "</div>" +
           "</div>"
       );
   }

    // ==================== SIDEBAR / LOGOUT / NOTIFICATIONS ====================
    function toggleSidebar() { document.getElementById('sidebar').classList.toggle('open'); }

    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 1024) {
            var sidebar = document.getElementById('sidebar');
            if (sidebar && sidebar.classList.contains('open')) {
                if (!sidebar.contains(e.target) && !e.target.closest('.menu-toggle')) sidebar.classList.remove('open');
            }
        }
    });

    function handleLogout() { localStorage.removeItem('accessToken'); localStorage.removeItem('user'); window.location.href = contextPath + '/login?logout=true'; }

    function toggleNotifications() {
        var dropdown = document.getElementById('notificationDropdown');
        dropdown.classList.toggle('open');
        if (dropdown.classList.contains('open')) loadNotifications();
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
                    var dotClass = n.notificationType === 'URGENT' ? 'urgent' : n.notificationType === 'IMPORTANT' ? 'important' : 'general';
                    html += '<div class="notification-item"><div class="notif-title"><span class="notif-dot ' + dotClass + '"></span>' + escapeHtml(n.title) + '</div>' +
                        '<div class="notif-message">' + escapeHtml(n.message) + '</div>' +
                        '<div class="notif-time"><i class="far fa-clock"></i> ' + formatTimeAgo(n.createdAt) + '</div></div>';
                }
                list.innerHTML = html;
                document.getElementById('notifBadge').textContent = data.data.length;
            } else {
                list.innerHTML = '<div class="notification-empty"><i class="fas fa-bell-slash"></i><div>No notifications</div></div>';
                document.getElementById('notifBadge').textContent = '0';
            }
        } catch(e) { console.log('Notification error:', e); }
    }



    async function deleteCustomCompliance(templateId, name) {
        if (!confirm('Delete "' + name + '" permanently? This will remove all its configuration, sub-compliances, and employee assignments. This cannot be undone.')) {
            return;
        }
        try {
            var token = localStorage.getItem('accessToken');
            var response = await fetch(contextPath + '/api/company-admin/compliance/custom/templates/' + templateId, {
                method: 'DELETE',
                headers: { 'Authorization': 'Bearer ' + token }
            });
            var data = await response.json();
            if (data && data.success) {
                toast('Compliance deleted', 'success');
                loadData();
            } else {
                toast(data && data.error ? data.error : 'Delete failed', 'error');
            }
        } catch (e) {
            console.error('Delete error:', e);
            toast('Delete failed. Please try again.', 'error');
        }
    }

    function formatTimeAgo(dateStr) {
        if (!dateStr) return 'Just now';
        try {
            var date = new Date(dateStr); var now = new Date(); var diff = Math.floor((now - date) / 1000);
            if (diff < 60) return diff + 's ago';
            if (diff < 3600) return Math.floor(diff / 60) + 'm ago';
            if (diff < 86400) return Math.floor(diff / 3600) + 'h ago';
            if (diff < 2592000) return Math.floor(diff / 86400) + 'd ago';
            return date.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
        } catch(e) { return 'Just now'; }
    }

    function markAllRead() {
        toast('All notifications marked as read', 'success');
        var list = document.getElementById('notificationList');
        if (list) list.innerHTML = '<div class="notification-empty"><i class="fas fa-check-circle" style="color:var(--success);"></i><div>All caught up!</div></div>';
        document.getElementById('notifBadge').textContent = '0';
    }

    document.addEventListener('click', function(e) {
        var dropdown = document.getElementById('notificationDropdown');
        var btn = document.querySelector('[onclick*="toggleNotifications"]');
        if (dropdown && btn) {
            if (dropdown.classList.contains('open') && !dropdown.contains(e.target) && !btn.contains(e.target)) dropdown.classList.remove('open');
        }
    });

    // ==================== LOAD DATA ====================
    // ==================== LOAD DATA ====================
    async function loadData() {
        document.getElementById('loader').style.display = 'block';
        document.getElementById('complianceGrid').style.display = 'none';
        document.getElementById('emptyState').style.display = 'none';

        try {
            var assignedData = await api('/api/company-admin/compliance/assigned');
            var allAssigned = assignedData && assignedData.success ? assignedData.data || [] : [];

            var customData = await api('/api/company-admin/compliance/custom/templates');
            var customList = customData && customData.success ? customData.data || [] : [];

            var parentMap = {};

            for (var i = 0; i < allAssigned.length; i++) {
                var item = allAssigned[i];
                var templateId = item.templateId;
                if (!templateId) continue;
                var isParent = !item.subTemplateId;

                if (!parentMap[templateId]) {
                    parentMap[templateId] = {
                        templateId: templateId,
                        templateName: item.templateName || 'Unknown',
                        isSuperAdmin: item.isSuperAdminConfig !== false,
                        isCustom: item.isSuperAdminConfig === false,
                        subCompliances: [],
                        parentConfig: null,
                        status: 'PENDING',
                        isConfigured: false,
                        dueDate: null,
                        frequency: null,
                        description: null,
                        createdAt: item.createdAt,
                        companyComplianceId: item.companyComplianceId || item.id,
                        priority: item.priority || 0  // <-- ADD THIS
                    };
                }

                if (isParent) {
                    parentMap[templateId].isConfigured = item.configured !== false;
                    parentMap[templateId].status = item.status || 'PENDING';
                    parentMap[templateId].dueDate = item.dueDate;
                    parentMap[templateId].frequency = item.frequency;
                    parentMap[templateId].description = item.description;
                    parentMap[templateId].companyComplianceId = item.companyComplianceId || item.id;
                    parentMap[templateId].createdAt = item.createdAt;
                    parentMap[templateId].priority = item.priority || 0;  // <-- ADD THIS
                    parentMap[templateId].parentConfig = {
                        id: item.id,
                        status: item.status,
                        dueDate: item.dueDate,
                        frequency: item.frequency,
                        configured: item.configured
                    };
                } else {
                    parentMap[templateId].subCompliances.push({
                        id: item.id,
                        subTemplateId: item.subTemplateId,
                        name: item.subTemplateName || 'Sub-Compliance',
                        status: item.status || 'PENDING',
                        dueDate: item.dueDate,
                        frequency: item.frequency,
                        isConfigured: item.configured !== false,
                        companyComplianceId: item.companyComplianceId || item.id,
                        description: item.description,
                        instructions: item.instructions,
                        documentRequired: item.documentRequired,
                        externalLink: item.externalLink,
                        reminderDaysBefore: item.reminderDaysBefore
                    });
                }
            }

            for (var i = 0; i < customList.length; i++) {
                var custom = customList[i];
                var customId = custom.id;
                if (!customId) continue;
                if (!parentMap[customId]) {
                    parentMap[customId] = {
                        templateId: customId,
                        id: customId,
                        templateName: custom.name,
                        isSuperAdmin: false,
                        isCustom: true,
                        subCompliances: [],
                        parentConfig: null,
                        status: 'PENDING',
                        isConfigured: false,
                        dueDate: null,
                        frequency: null,
                        description: custom.description,
                        createdAt: custom.createdAt,
                        companyComplianceId: customId,
                        companyName: custom.companyName,
                        priority: custom.priority || 0  // <-- ADD THIS
                    };
                }
            }

            groupedCompliances = Object.values(parentMap);

            // ===== FIX: Sort by priority (lower number first) =====
            groupedCompliances.sort(function(a, b) {
                var priorityA = a.priority || 0;
                var priorityB = b.priority || 0;
                if (priorityA !== priorityB) {
                    return priorityA - priorityB;
                }
                return (a.templateName || "").localeCompare(b.templateName || "");
            });

            for (var i = 0; i < groupedCompliances.length; i++) {
                var group = groupedCompliances[i];
                var subs = group.subCompliances;
                if (subs && subs.length > 0) {
                    var statuses = subs.map(function(s) { return s.status || 'PENDING'; });
                    var hasOverdue   = statuses.some(function(s) { return s === 'OVERDUE'; });
                    var allCompleted = statuses.every(function(s) { return s === 'COMPLETED'; });
                    var anyInProgress = statuses.some(function(s) { return s === 'IN_PROGRESS'; });
                    if (allCompleted)    group.status = 'COMPLETED';
                    else if (hasOverdue) group.status = 'OVERDUE';
                    else if (anyInProgress) group.status = 'IN_PROGRESS';
                    else group.status = 'PENDING';
                    group.isConfigured = subs.some(function(s) { return s.isConfigured === true; });
                }
            }

            updateStats();
            applyFilters();
            document.getElementById('loader').style.display = 'none';

        } catch (error) {
            console.error('Error loading data:', error);
            document.getElementById('loader').style.display = 'none';
            document.getElementById('loader').innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle" style="color:var(--danger);"></i><p>Failed to load compliance data</p></div>';
            toast('Failed to load compliance data', 'error');
        }
    }

    // ==================== UPDATE STATS ====================
    function updateStats() {
        var total      = groupedCompliances.length;
        var sa         = groupedCompliances.filter(function(i) { return i.isSuperAdmin; }).length;
        var custom     = total - sa;
        var configured = groupedCompliances.filter(function(i) { return i.isConfigured; }).length;
        document.getElementById('statTotal').textContent = total;
        document.getElementById('statSuperAdmin').textContent = sa;
        document.getElementById('statCustom').textContent = custom;
        document.getElementById('statConfigured').textContent = configured;
    }

    // ==================== FILTERS ====================
    function applyFilters() {
        var typeFilter   = document.getElementById('typeFilter').value;
        var statusFilter = document.getElementById('statusFilter').value;
        var searchTerm   = document.getElementById('searchInput').value.toLowerCase();

        filteredCompliances = groupedCompliances.filter(function(item) {
            if (typeFilter === 'superadmin' && !item.isSuperAdmin) return false;
            if (typeFilter === 'custom' && item.isSuperAdmin) return false;
            if (statusFilter !== 'all' && (item.status || 'PENDING') !== statusFilter) return false;
            if (searchTerm && !item.templateName.toLowerCase().includes(searchTerm)) return false;
            return true;
        });

        renderGrid(filteredCompliances);
    }

    // ==================== RENDER GRID ====================
    function renderGrid(items) {
        var grid = document.getElementById('complianceGrid');
        var emptyState = document.getElementById('emptyState');

        if (!items || !items.length) {
            grid.style.display = 'none';
            emptyState.style.display = 'block';
            return;
        }

        grid.style.display = 'grid';
        emptyState.style.display = 'none';

        var html = '';
        for (var i = 0; i < items.length; i++) { html += buildParentCard(items[i]); }
        grid.innerHTML = html;
    }

    // ==================== REFRESH ====================
    function refreshList() { loadData(); toast('Refreshed', 'info'); }

    // ==================== EVENT LISTENERS ====================
    document.getElementById('typeFilter').addEventListener('change', applyFilters);
    document.getElementById('statusFilter').addEventListener('change', applyFilters);
    var searchTimeout;
    document.getElementById('searchInput').addEventListener('input', function() { clearTimeout(searchTimeout); searchTimeout = setTimeout(applyFilters, 300); });

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
        loadData();
        loadNotifications();
    });
</script>

</body>
</html>
