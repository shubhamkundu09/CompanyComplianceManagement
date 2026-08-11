<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <% pageContext.setAttribute("pageTitle", "Dashboard" );
%> <%-- File: companyadmin/dashboard.jsp --%>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VNext Legal LLP — Company Admin Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
    />
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
        --shadow-md:
          0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg:
          0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        --shadow-xl:
          0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
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
        font-family:
          "Inter",
          -apple-system,
          BlinkMacSystemFont,
          sans-serif;
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
        background: linear-gradient(
          135deg,
          var(--primary),
          var(--primary-light)
        );
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
        from {
          opacity: 0;
          transform: translateY(-10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
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
      .notification-item .notif-dot.urgent {
        background: var(--danger);
      }
      .notification-item .notif-dot.important {
        background: var(--warning);
      }
      .notification-item .notif-dot.general {
        background: var(--primary);
      }
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
      .main-content {
        margin-left: 260px;
        margin-top: 64px;
        padding: 32px 40px;
        flex: 1;
        min-height: calc(100vh - 64px);
        position: relative;
        z-index: 1;
      }
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
      .stat-icon.blue {
        color: var(--primary);
      }
      .stat-icon.green {
        color: var(--success);
      }
      .stat-icon.red {
        color: var(--danger);
      }
      .stat-icon.yellow {
        color: var(--warning);
      }
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
        padding: 0 8px;
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
        font-family: "Inter", sans-serif;
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
        from {
          opacity: 0;
          transform: translateY(8px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
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
      .badge-success {
        background: var(--success-bg);
        color: var(--success);
      }
      .badge-danger {
        background: var(--danger-bg);
        color: var(--danger);
      }
      .badge-warning {
        background: var(--warning-bg);
        color: var(--warning);
      }
      .badge-info {
        background: var(--info-bg);
        color: var(--info);
      }
      .badge-primary {
        background: var(--primary-bg);
        color: var(--primary);
      }

      /* ==================== COMPLIANCE CARDS (VNext Dark Style) ==================== */
      .compliance-card {
        background: linear-gradient(160deg, #1b2a4a 0%, #0d1d36 100%);
        border: 1px solid rgba(212, 175, 55, 0.18);
        border-radius: var(--radius-lg);
        padding: 0;
        overflow: hidden;
        position: relative;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.25);
      }

      .compliance-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(
          90deg,
          transparent,
          #d4af37,
          #f5d76e,
          #d4af37,
          transparent
        );
        z-index: 1;
      }

      .compliance-card:hover {
        transform: translateY(-4px);
        border-color: rgba(212, 175, 55, 0.45);
        box-shadow:
          0 16px 48px rgba(0, 0, 0, 0.35),
          0 0 0 1px rgba(212, 175, 55, 0.12);
      }

      .vnext-card-body {
        padding: 20px 20px 14px;
      }

      .vnext-card-top {
        display: flex;
        align-items: flex-start;
        gap: 14px;
        margin-bottom: 12px;
      }

      .vnext-card-icon {
        width: 46px;
        height: 46px;
        min-width: 46px;
        border-radius: 50%;
        background: rgba(212, 175, 55, 0.12);
        border: 1.5px solid rgba(212, 175, 55, 0.35);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #d4af37;
        font-size: 18px;
        flex-shrink: 0;
      }

      .vnext-card-title-block {
        flex: 1;
        min-width: 0;
      }

      .vnext-card-title {
        font-size: 13px;
        font-weight: 700;
        color: #f1f5f9;
        text-transform: uppercase;
        letter-spacing: 0.4px;
        line-height: 1.3;
        margin-bottom: 7px;
      }

      .vnext-card-badges {
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
        align-items: center;
      }

      .vnext-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 3px 9px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 600;
        letter-spacing: 0.2px;
      }

      .vnext-badge-completed {
        background: rgba(16, 185, 129, 0.15);
        color: #10b981;
        border: 1px solid rgba(16, 185, 129, 0.25);
      }
      .vnext-badge-overdue {
        background: rgba(239, 68, 68, 0.15);
        color: #ef4444;
        border: 1px solid rgba(239, 68, 68, 0.25);
      }
      .vnext-badge-warning {
        background: rgba(245, 158, 11, 0.15);
        color: #f59e0b;
        border: 1px solid rgba(245, 158, 11, 0.25);
      }
      .vnext-badge-info {
        background: rgba(59, 130, 246, 0.15);
        color: #60a5fa;
        border: 1px solid rgba(59, 130, 246, 0.25);
      }
      .vnext-badge-custom {
        background: rgba(212, 175, 55, 0.1);
        color: #d4af37;
        border: 1px solid rgba(212, 175, 55, 0.2);
      }

      .vnext-card-meta {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        padding: 10px 0;
        margin-bottom: 10px;
        border-top: 1px solid rgba(255, 255, 255, 0.07);
        border-bottom: 1px solid rgba(255, 255, 255, 0.07);
      }

      .vnext-meta-item {
        font-size: 11px;
        color: rgba(255, 255, 255, 0.42);
        display: flex;
        align-items: center;
        gap: 4px;
      }

      .vnext-meta-item i {
        color: #d4af37;
        opacity: 0.7;
        font-size: 10px;
      }

      .vnext-sub-list {
        display: flex;
        flex-direction: column;
        gap: 0;
      }

      .vnext-sub-list-title {
        font-size: 10px;
        font-weight: 600;
        color: rgba(212, 175, 55, 0.75);
        text-transform: uppercase;
        letter-spacing: 0.6px;
        margin-bottom: 6px;
      }

      .vnext-sub-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 7px 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
      }
      .vnext-sub-item:last-child {
        border-bottom: none;
      }

      .vnext-sub-bullet {
        width: 5px;
        height: 5px;
        min-width: 5px;
        border-radius: 50%;
        background: #d4af37;
        opacity: 0.65;
        flex-shrink: 0;
      }

      .vnext-sub-name {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.78);
        flex: 1;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .vnext-sub-right {
        display: flex;
        align-items: center;
        gap: 6px;
        flex-shrink: 0;
      }

      .vnext-due-label {
        font-size: 10px;
        color: rgba(255, 255, 255, 0.35);
        white-space: nowrap;
      }

      .vnext-no-sub-due {
        padding: 8px 0;
        font-size: 12px;
        color: rgba(255, 255, 255, 0.5);
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .vnext-more-subs {
        font-size: 11px;
        color: rgba(212, 175, 55, 0.55);
        padding: 6px 0 0;
        text-align: center;
      }

      /* ==================== BLINKERS ==================== */
      .vnext-blinker {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        flex-shrink: 0;
      }

      .blinker-overdue {
        background: #ef4444;
        box-shadow: 0 0 8px rgba(239, 68, 68, 0.9);
        animation: blink-overdue 0.55s ease-in-out infinite;
      }
      .blinker-danger {
        background: #ef4444;
        box-shadow: 0 0 12px rgba(239, 68, 68, 0.8);
        animation: blink-danger 0.38s ease-in-out infinite;
      }
      .blinker-warning {
        background: #f59e0b;
        box-shadow: 0 0 8px rgba(245, 158, 11, 0.7);
        animation: blink-warning 0.9s ease-in-out infinite;
      }
      .blinker-ok {
        background: #10b981;
        box-shadow: 0 0 5px rgba(16, 185, 129, 0.45);
      }

      @keyframes blink-overdue {
        0%,
        100% {
          opacity: 1;
          transform: scale(1.1);
        }
        50% {
          opacity: 0.15;
          transform: scale(0.75);
        }
      }
      @keyframes blink-danger {
        0%,
        100% {
          opacity: 1;
          transform: scale(1.2);
        }
        50% {
          opacity: 0.05;
          transform: scale(0.65);
        }
      }
      @keyframes blink-warning {
        0%,
        100% {
          opacity: 1;
          transform: scale(1);
        }
        50% {
          opacity: 0.3;
          transform: scale(0.82);
        }
      }

      .vnext-card-footer {
        display: flex;
        gap: 8px;
        padding: 12px 20px 16px;
        border-top: 1px solid rgba(255, 255, 255, 0.07);
        background: rgba(0, 0, 0, 0.18);
      }

      .vnext-btn {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
        padding: 7px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 500;
        font-family: "Inter", sans-serif;
        cursor: pointer;
        border: none;
        transition: all 0.2s;
        text-decoration: none;
      }

      .vnext-btn-gold {
        background: rgba(212, 175, 55, 0.18);
        color: #d4af37;
        border: 1px solid rgba(212, 175, 55, 0.35);
      }
      .vnext-btn-gold:hover {
        background: rgba(212, 175, 55, 0.32);
        box-shadow: 0 4px 12px rgba(212, 175, 55, 0.18);
      }

      .vnext-btn-ghost {
        background: rgba(255, 255, 255, 0.06);
        color: rgba(255, 255, 255, 0.58);
        border: 1px solid rgba(255, 255, 255, 0.1);
      }
      .vnext-btn-ghost:hover {
        background: rgba(255, 255, 255, 0.13);
        color: rgba(255, 255, 255, 0.9);
      }

      .filter-bar {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        padding: 12px 0;
        border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        margin-bottom: 16px;
      }
      .filter-bar .form-input {
        padding: 8px 12px;
        border: 1px solid rgba(226, 232, 240, 0.6);
        border-radius: var(--radius);
        font-size: 13px;
        font-family: "Inter", sans-serif;
        background: rgba(255, 255, 255, 0.5);
        backdrop-filter: blur(4px);
        color: var(--gray-800);
        transition: all 0.2s;
        outline: none;
      }
      .filter-bar .form-input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        background: rgba(255, 255, 255, 0.8);
      }
      .filter-bar .form-input::placeholder {
        color: var(--gray-400);
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
        font-family: "Inter", sans-serif;
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
      .btn-ghost {
        background: transparent;
        border: 1px solid rgba(226, 232, 240, 0.6);
      }
      .btn-ghost:hover {
        background: rgba(255, 255, 255, 0.5);
        border-color: var(--gray-300);
      }
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
        to {
          transform: rotate(360deg);
        }
      }
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
        from {
          opacity: 0;
          transform: translateX(20px);
        }
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }
      .toast-success {
        color: var(--success);
      }
      .toast-error {
        color: var(--danger);
      }
      .toast-info {
        color: var(--primary);
      }
      .toast-warning {
        color: var(--warning);
      }
      .compliance-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
        gap: 20px;
        margin-top: 16px;
      }
      @media (max-width: 1024px) {
        .header {
          left: 0;
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
          margin-left: 0;
          padding: 24px;
        }
        .logo-bg {
          width: 500px;
          height: 500px;
        }
        .stats-grid {
          grid-template-columns: repeat(2, 1fr);
        }
      }
      @media (max-width: 768px) {
        .stats-grid {
          grid-template-columns: 1fr;
        }
        .header {
          padding: 0 16px;
        }
        .main-content {
          padding: 16px;
        }
        .header-user .user-info {
          display: none;
        }
        .notification-dropdown {
          width: 320px;
          right: -60px;
        }
        .logo-bg {
          width: 300px;
          height: 300px;
          opacity: 0.06;
        }
        .compliance-grid {
          grid-template-columns: 1fr;
        }
        .filter-bar .form-input {
          width: 100%;
        }
      }
      @media (max-width: 480px) {
        .stat-card .stat-value {
          font-size: 24px;
        }
        .header-left .page-title {
          font-size: 15px;
        }
        .notification-dropdown {
          width: 280px;
          right: -80px;
        }
      }

      /* ==================== COMPLIANCE CARDS (Updated to match website design) ==================== */
      .compliance-card {
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.4);
        border-radius: var(--radius-lg);
        padding: 0;
        overflow: hidden;
        position: relative;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
      }

      .compliance-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(
          90deg,
          transparent,
          var(--primary),
          var(--primary-light),
          var(--primary),
          transparent
        );
        z-index: 1;
      }

      .compliance-card:hover {
        background: rgba(255, 255, 255, 0.9);
        transform: translateY(-4px);
        border-color: var(--primary-light);
        box-shadow:
          0 8px 32px rgba(0, 0, 0, 0.08),
          0 0 0 1px rgba(79, 70, 229, 0.12);
      }

      .vnext-card-body {
        padding: 20px 20px 14px;
      }

      .vnext-card-top {
        display: flex;
        align-items: flex-start;
        gap: 14px;
        margin-bottom: 12px;
      }

      .vnext-card-icon {
        width: 46px;
        height: 46px;
        min-width: 46px;
        border-radius: 50%;
        background: rgb(0 0 0);
        border: 1.5px solid rgba(79, 70, 229, 0.2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #e9d80f;
        font-size: 18px;
        flex-shrink: 0;
      }

      .vnext-card-title-block {
        flex: 1;
        min-width: 0;
      }

      .vnext-card-title {
        font-size: 14px;
        font-weight: 900;
        color: var(--gray-900);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        line-height: 1.3;
        margin-bottom: 7px;
      }

      .vnext-card-badges {
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
        align-items: center;
      }

      .vnext-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 3px 9px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 600;
        letter-spacing: 0.2px;
      }

      .vnext-badge-completed {
        background: var(--success-bg);
        color: var(--success);
        border: 1px solid rgba(16, 185, 129, 0.2);
      }
      .vnext-badge-overdue {
        background: var(--danger-bg);
        color: var(--danger);
        border: 1px solid rgba(239, 68, 68, 0.2);
      }
      .vnext-badge-warning {
        background: var(--warning-bg);
        color: var(--warning);
        border: 1px solid rgba(245, 158, 11, 0.2);
      }
      .vnext-badge-info {
        background: var(--info-bg);
        color: var(--info);
        border: 1px solid rgba(59, 130, 246, 0.2);
      }
      .vnext-badge-custom {
        background: var(--primary-bg);
        color: var(--primary);
        border: 1px solid rgba(79, 70, 229, 0.2);
      }

      .vnext-card-meta {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        padding: 10px 0;
        margin-bottom: 10px;
        border-top: 1px solid rgba(226, 232, 240, 0.5);
        border-bottom: 1px solid rgba(226, 232, 240, 0.5);
      }

      .vnext-meta-item {
        font-size: 11px;
        color: var(--gray-500);
        display: flex;
        align-items: center;
        gap: 4px;
      }

      .vnext-meta-item i {
        color: var(--primary);
        opacity: 0.7;
        font-size: 10px;
      }

      .vnext-sub-list {
        display: flex;
        flex-direction: column;
        gap: 0;
      }

      .vnext-sub-list-title {
        font-size: 10px;
        font-weight: 600;
        color: black;
        text-transform: uppercase;
        letter-spacing: 0.6px;
        margin-bottom: 6px;
      }

      .vnext-sub-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 7px 0;
        border-bottom: 1px solid rgba(226, 232, 240, 0.3);
      }
      .vnext-sub-item:last-child {
        border-bottom: none;
      }

      .vnext-sub-bullet {
        width: 5px;
        height: 5px;
        min-width: 5px;
        border-radius: 50%;
        background: var(--primary);
        opacity: 0.5;
        flex-shrink: 0;
      }

      .vnext-sub-name {
        font-size: 12px;
        color: var(--gray-700);
        flex: 1;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .vnext-sub-right {
        display: flex;
        align-items: center;
        gap: 6px;
        flex-shrink: 0;
      }

      .vnext-due-label {
        font-size: 10px;
        color: var(--gray-400);
        white-space: nowrap;
      }

      .vnext-no-sub-due {
        padding: 8px 0;
        font-size: 12px;
        color: var(--gray-500);
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .vnext-no-sub-due i {
        color: var(--primary);
      }

      .vnext-more-subs {
        font-size: 11px;
        color: var(--gray-400);
        padding: 6px 0 0;
        text-align: center;
      }

      /* ==================== BLINKERS ==================== */
      .vnext-blinker {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        flex-shrink: 0;
      }

      .blinker-overdue {
        background: var(--danger);
        box-shadow: 0 0 8px rgba(239, 68, 68, 0.9);
        animation: blink-overdue 0.55s ease-in-out infinite;
      }
      .blinker-danger {
        background: var(--danger);
        box-shadow: 0 0 12px rgba(239, 68, 68, 0.8);
        animation: blink-danger 0.38s ease-in-out infinite;
      }
      .blinker-warning {
        background: var(--warning);
        box-shadow: 0 0 8px rgba(245, 158, 11, 0.7);
        animation: blink-warning 0.9s ease-in-out infinite;
      }
      .blinker-ok {
        background: var(--success);
        box-shadow: 0 0 5px rgba(16, 185, 129, 0.45);
      }

      @keyframes blink-overdue {
        0%,
        100% {
          opacity: 1;
          transform: scale(1.1);
        }
        50% {
          opacity: 0.15;
          transform: scale(0.75);
        }
      }
      @keyframes blink-danger {
        0%,
        100% {
          opacity: 1;
          transform: scale(1.2);
        }
        50% {
          opacity: 0.05;
          transform: scale(0.65);
        }
      }
      @keyframes blink-warning {
        0%,
        100% {
          opacity: 1;
          transform: scale(1);
        }
        50% {
          opacity: 0.3;
          transform: scale(0.82);
        }
      }

      .vnext-card-footer {
        display: flex;
        gap: 8px;
        padding: 12px 20px 16px;
        border-top: 1px solid rgba(226, 232, 240, 0.5);
        background: rgba(248, 250, 252, 0.5);
      }

      .vnext-btn {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
        padding: 7px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 500;
        font-family: "Inter", sans-serif;
        cursor: pointer;
        border: none;
        transition: all 0.2s;
        text-decoration: none;
      }

      .vnext-btn-gold {
        background: var(--primary-bg);
        color: var(--primary);
        border: 1px solid rgba(79, 70, 229, 0.25);
      }
      .vnext-btn-gold:hover {
        background: rgba(79, 70, 229, 0.15);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15);
      }

      .vnext-btn-ghost {
        background: rgba(255, 255, 255, 0.5);
        color: var(--gray-500);
        border: 1px solid rgba(226, 232, 240, 0.5);
      }
      .vnext-btn-ghost:hover {
        background: var(--gray-100);
        color: var(--gray-700);
        border-color: var(--gray-300);
      }



      /* ===========================================================
         VNEXT - PREMIUM COMPLIANCE STATUS BEACON
         Pure CSS | No Images | No SVG
      =========================================================== */

      /* ===========================================================
         BASE BEACON
      =========================================================== */

      .vnext-blinker{
          position:relative;
          display:inline-block;
          width:25px;
          height:14px;
          flex-shrink:0;
          overflow:hidden;
          border-radius:9px 9px 4px 4px;

          border:1px solid rgba(255,255,255,.18);

          box-shadow:
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);

          transform:translateZ(0);
      }

      /* Glass Reflection */

      .vnext-blinker::before{
          content:"";
          position:absolute;
          top:1px;
          left:2px;
          right:2px;
          height:42%;
          border-radius:50%;

          background:linear-gradient(
              to bottom,
              rgba(255,255,255,.95),
              rgba(255,255,255,.25),
              transparent
          );

          pointer-events:none;
      }

      /* Rotating Light Sweep */

      .vnext-blinker::after{
          content:"";
          position:absolute;
          top:-60%;
          left:-90%;

          width:45%;
          height:220%;

          background:linear-gradient(
              to right,
              transparent,
              rgba(255,255,255,.98),
              rgba(255,255,255,.35),
              transparent
          );

          transform:rotate(25deg);

          pointer-events:none;
      }


      /* ===========================================================
         🔴 OVERDUE / DANGER
      =========================================================== */

      .blinker-overdue,
      .blinker-danger{

          background:

              radial-gradient(circle at 50% 18%,
                  rgba(255,255,255,.95),
                  rgba(255,255,255,.35),
                  transparent 28%),

              radial-gradient(circle at center,
                  #ffb3b3 0%,
                  #ff7a7a 22%,
                  #ef4444 45%,
                  #dc2626 70%,
                  #991b1b 100%);

          box-shadow:
              0 0 4px #ef4444,
              0 0 10px #ef4444,
              0 0 18px rgba(239,68,68,.95),
              0 0 30px rgba(239,68,68,.55),
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);
      }

      .blinker-overdue::after,
      .blinker-danger::after{
          animation:
              beaconSweep .28s linear infinite,
              beaconGlow .28s linear infinite;
      }


      /* ===========================================================
         🟠 DUE TODAY / NEXT 1–3 DAYS
      =========================================================== */

      .blinker-warning{

          background:

              radial-gradient(circle at 50% 18%,
                  rgba(255,255,255,.95),
                  rgba(255,255,255,.35),
                  transparent 28%),

              radial-gradient(circle at center,
                  #ffe0bf 0%,
                  #ffb86b 22%,
                  #f97316 45%,
                  #ea580c 70%,
                  #9a3412 100%);

          box-shadow:
              0 0 4px #f97316,
              0 0 10px #f97316,
              0 0 18px rgba(249,115,22,.9),
              0 0 28px rgba(249,115,22,.45),
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);
      }

      .blinker-warning::after{
          animation:
              beaconSweep .45s linear infinite,
              beaconGlow .45s linear infinite;
      }


      /* ===========================================================
         🟡 UPCOMING
      =========================================================== */

      .blinker-upcoming{

          background:

              radial-gradient(circle at 50% 18%,
                  rgba(255,255,255,.95),
                  rgba(255,255,255,.35),
                  transparent 28%),

              radial-gradient(circle at center,
                  #fff7bf 0%,
                  #ffe86d 22%,
                  #fbbf24 45%,
                  #f59e0b 70%,
                  #a16207 100%);

          box-shadow:
              0 0 4px #fbbf24,
              0 0 10px #fbbf24,
              0 0 16px rgba(251,191,36,.85),
              0 0 24px rgba(251,191,36,.35),
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);
      }

      .blinker-upcoming::after{
          animation:
              beaconSweep .65s linear infinite,
              beaconGlow .65s linear infinite;
      }


      /* ===========================================================
         🔵 IN PROGRESS
      =========================================================== */

      .blinker-progress{

          background:

              radial-gradient(circle at 50% 18%,
                  rgba(255,255,255,.95),
                  rgba(255,255,255,.35),
                  transparent 28%),

              radial-gradient(circle at center,
                  #bfe7ff 0%,
                  #73c7ff 22%,
                  #3b82f6 45%,
                  #2563eb 70%,
                  #1e3a8a 100%);

          box-shadow:
              0 0 4px #3b82f6,
              0 0 10px #3b82f6,
              0 0 18px rgba(59,130,246,.9),
              0 0 28px rgba(59,130,246,.45),
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);
      }

      .blinker-progress::after{
          animation:
              beaconSweep .55s linear infinite,
              beaconGlow .55s linear infinite;
      }


      /* ===========================================================
         🟢 COMPLETED
      =========================================================== */

      .blinker-ok{

          background:

              radial-gradient(circle at 50% 18%,
                  rgba(255,255,255,.95),
                  rgba(255,255,255,.35),
                  transparent 28%),

              radial-gradient(circle at center,
                  #c9ffe0 0%,
                  #74f5b4 25%,
                  #10b981 50%,
                  #059669 75%,
                  #065f46 100%);

          box-shadow:
              0 0 6px rgba(16,185,129,.65),
              0 0 14px rgba(16,185,129,.30),
              inset 0 2px 2px rgba(255,255,255,.45),
              inset 0 -2px 4px rgba(0,0,0,.35);
      }

      .blinker-ok::after{
          display:none;
      }


      /* ===========================================================
         ANIMATIONS
      =========================================================== */

      @keyframes beaconSweep{

          0%{
              left:-90%;
          }

          100%{
              left:140%;
          }

      }

      @keyframes beaconGlow{

          0%,100%{
              opacity:.35;
          }

          50%{
              opacity:1;
          }

      }





    </style>
  </head>
  <body>
    <div class="logo-bg">
      <img
        src="${baseUrl}/vnextimages/companyfiles/logo.png"
        alt="VNext LLP"
        onerror="this.style.display = 'none'"
      />
    </div>

    <div id="toast-container"></div>

    <div class="app-wrapper">
      <aside class="sidebar" id="sidebar">
              <div class="sidebar-brand">
                  <div class="brand-icon">
                   <img style="width:100%;"  src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext LLP" onerror="this.style.display='none'">
                  </div>
                  <span class="brand-text">VNext Legal</span>
                  <span class="brand-badge">LLP</span>
              </div>

              <div class="sidebar-label">Main</div>
              <a href="${baseUrl}/company-admin/dashboard" class="nav-item active">
                  <i class="fas fa-chart-pie"></i> Dashboard
              </a>

              <div class="sidebar-label">Management</div>
              <a href="${baseUrl}/company-admin/employees" class="nav-item">
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
              <a href="${baseUrl}/company-admin/notifications" class="nav-item">
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

      <header class="header">
        <div class="header-left">
          <button class="menu-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
          </button>
          <span class="page-title">Dashboard</span>
        </div>
        <div class="header-right">
          <div style="position: relative">
            <button
              class="header-btn"
              onclick="toggleNotifications()"
              title="Notifications"
            >
              <i class="fas fa-bell"></i>
              <span class="badge-count" id="notifBadge">0</span>
            </button>
            <div class="notification-dropdown" id="notificationDropdown">
              <div class="notification-header">
                <h4>
                  <i
                    class="fas fa-bell"
                    style="color: var(--primary); margin-right: 8px"
                  ></i>
                  Notifications
                </h4>
                <span class="mark-all" onclick="markAllRead()"
                  >Mark all as read</span
                >
              </div>
              <div id="notificationList">
                <div class="notification-empty">
                  <i class="fas fa-spinner fa-spin"></i>
                  <div style="margin-top: 8px">Loading...</div>
                </div>
              </div>
              <div class="notification-footer">
                <a
                  href="${baseUrl}/company-admin/notifications"
                  >View all notifications</a
                >
              </div>
            </div>
          </div>
          <div
            class="header-user"
            onclick="
              window.location.href =
                '${baseUrl}/company-admin/company-details'
            "
          >
            <div class="avatar" id="userAvatar">U</div>
            <div class="user-info">
              <span class="user-name" id="userName">User</span>
              <span class="user-role" id="userRole">Company Admin</span>
            </div>
          </div>
        </div>
      </header>

      <main class="main-content">
        <div style="margin-bottom: 24px">
          <p
            style="
              font-size: 12px;
              color: var(--primary);
              font-weight: 600;
              text-transform: uppercase;
              letter-spacing: 0.8px;
              margin-bottom: 4px;
            "
          >
            Welcome back,
          </p>
          <h1
            style="font-size: 28px; font-weight: 700; color: var(--gray-900)"
            id="welcomeName"
          >
            Company Admin
          </h1>
          <p style="font-size: 13px; color: var(--gray-500); margin-top: 6px">
            Here's your compliance overview and quick actions.
          </p>
        </div>

        <div class="stats-grid">
          <div class="stat-card" onclick="switchTab('categories')">
            <div class="stat-top">
              <div>
                <div class="stat-label">Total Categories</div>
                <div class="stat-value" id="statCategories">—</div>
                <div class="stat-sub">
                  Assigned by <span id="statSuperAdminCount">—</span> SuperAdmin
                </div>
              </div>
              <div class="stat-icon blue">
                <i class="fas fa-folder-open"></i>
              </div>
            </div>
          </div>
          <div class="stat-card" onclick="switchTab('subs')">
            <div class="stat-top">
              <div>
                <div class="stat-label">Sub-Compliances</div>
                <div class="stat-value" id="statSubs">—</div>
                <div class="stat-sub">Total sub-tasks</div>
              </div>
              <div class="stat-icon blue"><i class="fas fa-tasks"></i></div>
            </div>
          </div>
          <div class="stat-card" onclick="switchTab('completed')">
            <div class="stat-top">
              <div>
                <div class="stat-label">Completed</div>
                <div
                  class="stat-value"
                  id="statCompleted"
                  style="color: var(--success)"
                >
                  —
                </div>
                <div class="stat-sub">All compliances completed</div>
              </div>
              <div class="stat-icon green">
                <i class="fas fa-check-circle"></i>
              </div>
            </div>
          </div>
          <div class="stat-card" onclick="switchTab('overdue')">
            <div class="stat-top">
              <div>
                <div class="stat-label">Overdue</div>
                <div
                  class="stat-value"
                  id="statOverdue"
                  style="color: var(--danger)"
                >
                  —
                </div>
                <div class="stat-sub">Need immediate attention</div>
              </div>
              <div class="stat-icon red">
                <i class="fas fa-exclamation-triangle"></i>
              </div>
            </div>
          </div>
        </div>

        <div class="tabs-container">
          <div class="tabs">
            <button
              class="tab-btn active"
              data-tab="all"
              onclick="switchTab('all')"
            >
              <i class="fas fa-th"></i> All Categories
            </button>
            <button
              class="tab-btn"
              data-tab="overdue"
              onclick="switchTab('overdue')"
            >
              <i
                class="fas fa-exclamation-triangle"
                style="color: var(--danger)"
              ></i>
              Overdue
            </button>
            <button
              class="tab-btn"
              data-tab="pending"
              onclick="switchTab('pending')"
            >
              <i class="fas fa-clock" style="color: var(--warning)"></i> Pending
            </button>
            <button
              class="tab-btn"
              data-tab="completed"
              onclick="switchTab('completed')"
            >
              <i class="fas fa-check-circle" style="color: var(--success)"></i>
              Completed
            </button>
            <button
              class="tab-btn"
              data-tab="categories"
              onclick="switchTab('categories')"
            >
              <i class="fas fa-folder-open"></i> Categories
            </button>
            <button class="tab-btn" data-tab="subs" onclick="switchTab('subs')">
              <i class="fas fa-tasks"></i> Sub-Compliances
            </button>
          </div>
          <div class="tab-content">
            <div id="tab-all" class="tab-pane active">
              <div class="filter-bar">
                <input
                  type="text"
                  id="complianceSearch"
                  class="form-input"
                  placeholder="Search categories..."
                  onkeyup="filterComplianceCards()"
                  style="flex: 2; min-width: 180px"
                />
                <select
                  id="complianceStatusFilter"
                  class="form-input"
                  onchange="filterComplianceCards()"
                  style="min-width: 140px"
                >
                  <option value="all">All Status</option>
                  <option value="PENDING">Pending</option>
                  <option value="IN_PROGRESS">In Progress</option>
                  <option value="COMPLETED">Completed</option>
                  <option value="OVERDUE">Overdue</option>
                </select>
                <button
                  onclick="refreshComplianceCards()"
                  class="btn btn-ghost"
                >
                  <i class="fas fa-sync-alt"></i> Refresh
                </button>
              </div>
              <div
                id="complianceLoader"
                style="text-align: center; padding: 40px; display: none"
              >
                <div class="spinner" style="margin: 0 auto 12px"></div>
                <div style="color: var(--gray-500)">
                  Loading compliance categories...
                </div>
              </div>
              <div id="complianceCardsGrid" class="compliance-grid">
                <div class="empty-state">
                  <div class="spinner" style="margin: 0 auto 12px"></div>
                  Loading...
                </div>
              </div>
              <div
                id="complianceEmptyState"
                class="empty-state"
                style="display: none"
              >
                <i class="fas fa-folder-open"></i>
                <p style="font-size: 15px">
                  No compliance categories assigned yet
                </p>
                <p
                  style="
                    font-size: 12px;
                    color: var(--gray-500);
                    margin-top: 6px;
                  "
                >
                  SuperAdmin will assign categories, or you can create your own
                  custom compliances.
                </p>
                <a
                  href="${baseUrl}/company-admin/compliance/custom/create"
                  class="btn btn-primary"
                  style="margin-top: 12px"
                  ><i class="fas fa-plus"></i> Create Custom Compliance</a
                >
              </div>
            </div>
            <div id="tab-overdue" class="tab-pane">
              <div id="overdueGrid" class="compliance-grid">
                <div class="empty-state">
                  <i class="fas fa-spinner fa-spin"></i> Loading...
                </div>
              </div>
            </div>
            <div id="tab-pending" class="tab-pane">
              <div id="pendingGrid" class="compliance-grid">
                <div class="empty-state">
                  <i class="fas fa-spinner fa-spin"></i> Loading...
                </div>
              </div>
            </div>
            <div id="tab-completed" class="tab-pane">
              <div id="completedGrid" class="compliance-grid">
                <div class="empty-state">
                  <i class="fas fa-spinner fa-spin"></i> Loading...
                </div>
              </div>
            </div>
            <div id="tab-categories" class="tab-pane">
              <div id="categoriesGrid" class="compliance-grid">
                <div class="empty-state">
                  <i class="fas fa-spinner fa-spin"></i> Loading...
                </div>
              </div>
            </div>
            <div id="tab-subs" class="tab-pane">
              <div id="subsGrid" class="compliance-grid">
                <div class="empty-state">
                  <i class="fas fa-spinner fa-spin"></i> Loading...
                </div>
              </div>
            </div>
          </div>
        </div>

        <div style="margin-top: 20px">
          <div class="glass-card" style="padding: 20px">
            <div
              style="
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 12px;
              "
            >
              <i
                class="fas fa-bolt"
                style="color: var(--primary); font-size: 16px"
              ></i>
              <span
                style="
                  font-weight: 600;
                  font-size: 15px;
                  color: var(--gray-800);
                "
                >Quick Actions</span
              >
            </div>
            <div style="display: flex; gap: 12px; flex-wrap: wrap">
              <a
                href="${baseUrl}/company-admin/employees/add"
                class="btn btn-primary"
                ><i class="fas fa-user-plus"></i> Add Employee</a
              >
              <a
                href="${baseUrl}/company-admin/compliance/parents"
                class="btn btn-ghost"
                ><i class="fas fa-tasks"></i> View All Compliances</a
              >
              <button onclick="refreshDashboard()" class="btn btn-ghost">
                <i class="fas fa-sync-alt"></i> Refresh
              </button>
              <a
                href="${baseUrl}/company-admin/change-password"
                class="btn btn-ghost"
                ><i class="fas fa-key"></i> Change Password</a
              >
            </div>
          </div>
        </div>
      </main>
    </div>

    <script>
      var contextPath = "${baseUrl}";
      var allCompliances = [];
      var groupedCompliances = [];
      var filteredCompliances = [];

      function toast(message, type = "info", duration = 3500) {
        const container = document.getElementById("toast-container");
        const icons = {
          success: "fa-check-circle",
          error: "fa-exclamation-circle",
          info: "fa-info-circle",
          warning: "fa-exclamation-triangle",
        };
        const el = document.createElement("div");
        el.className = "toast toast-" + type;
        el.innerHTML =
          '<i class="fas ' + icons[type] + '"></i><span>' + message + "</span>";
        container.appendChild(el);
        setTimeout(() => {
          el.style.opacity = "0";
          el.style.transform = "translateX(20px)";
          el.style.transition = "all .3s";
          setTimeout(() => el.remove(), 300);
        }, duration);
      }

      async function api(url, options = {}) {
        const token = localStorage.getItem("accessToken");
        if (!token) {
          window.location.href = contextPath + "/login?error=Session expired";
          return null;
        }
        const defaults = {
          headers: {
            Authorization: "Bearer " + token,
            "Content-Type": "application/json",
          },
        };
        const merged = {
          ...defaults,
          ...options,
          headers: { ...defaults.headers, ...(options.headers || {}) },
        };
        try {
          const response = await fetch(contextPath + url, merged);
          if (response.status === 401) {
            localStorage.removeItem("accessToken");
            localStorage.removeItem("user");
            window.location.href = contextPath + "/login?error=Session expired";
            return null;
          }
          return response.json();
        } catch (error) {
          console.error("API Error:", error);
          return null;
        }
      }

      function escapeHtml(str) {
        if (!str) return "";
        return String(str).replace(/[&<>]/g, function (m) {
          if (m === "&") return "&amp;";
          if (m === "<") return "&lt;";
          if (m === ">") return "&gt;";
          return m;
        });
      }

      function formatDate(d) {
        if (!d) return "—";
        var date = new Date(d);
        return (
          date.getDate().toString().padStart(2, "0") +
          "-" +
          (date.getMonth() + 1).toString().padStart(2, "0") +
          "-" +
          date.getFullYear()
        );
      }

      function getDaysRemaining(dueDate) {
        if (!dueDate) return null;
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueDate);
        due.setHours(0, 0, 0, 0);
        return Math.ceil((due - today) / (1000 * 60 * 60 * 24));
      }

      function getStatusInfo(status) {
        var map = {
          PENDING: { label: "Pending", cls: "badge-warning", icon: "fa-clock" },
          IN_PROGRESS: {
            label: "In Progress",
            cls: "badge-info",
            icon: "fa-spinner",
          },
          COMPLETED: {
            label: "Completed",
            cls: "badge-success",
            icon: "fa-check-circle",
          },
          OVERDUE: {
            label: "Overdue",
            cls: "badge-danger",
            icon: "fa-exclamation-triangle",
          },
        };
        return (
          map[status] || {
            label: status || "Pending",
            cls: "badge-warning",
            icon: "fa-circle",
          }
        );
      }

      function getFrequencyLabel(freq) {
        var map = {
          MONTHLY: "Monthly",
          QUARTERLY: "Quarterly",
          HALF_YEARLY: "Half Yearly",
          YEARLY: "Yearly",
          ONE_TIME: "One Time",
        };
        return map[freq] || freq || "—";
      }

      // ==================== VNEXT CARD HELPERS ====================
      function getBlinkerClass(dueDate, currentStatus) {
              if (currentStatus === "COMPLETED") return "blinker-ok";
              if (!dueDate) return "";
              var days = getDaysRemaining(dueDate);
              if (days === null || isNaN(days)) return "";
              if (days < 0) return "blinker-overdue";
              if (days <= 1) return "blinker-danger";
              if (days <= 3) return "blinker-warning";
              return "";
            }

            function getCardBlinkerFromSubs(subCompliances) {
              if (!subCompliances || subCompliances.length === 0) return "";
              var rank = { "blinker-danger": 3, "blinker-overdue": 2, "blinker-warning": 1 };
              var best = "";
              var bestRank = 0;
              for (var i = 0; i < subCompliances.length; i++) {
                var s = subCompliances[i];
                var cls = getBlinkerClass(s.dueDate, s.status);
                if (cls && rank[cls] && rank[cls] > bestRank) {
                  bestRank = rank[cls];
                  best = cls;
                }
              }
              return best;
            }

      function getVNextBadgeClass(status) {
        var map = {
          COMPLETED: "vnext-badge-completed",
          OVERDUE: "vnext-badge-overdue",
          IN_PROGRESS: "vnext-badge-info",
          PENDING: "vnext-badge-warning",
        };
        return map[status] || "vnext-badge-warning";
      }

      function getStatusIconClass(status) {
        var map = {
          COMPLETED: "fa-check-circle",
          OVERDUE: "fa-exclamation-triangle",
          IN_PROGRESS: "fa-spinner",
          PENDING: "fa-clock",
        };
        return map[status] || "fa-circle";
      }

      function getComplianceIcon(name) {
        if (!name) return "fa-tasks";
        var n = name.toLowerCase();
        if (n.includes("gst") || n.includes("indirect tax"))
          return "fa-file-invoice-dollar";
        if (
          n.includes("direct tax") ||
          n.includes("income tax") ||
          n.includes("tds")
        )
          return "fa-calculator";
        if (
          n.includes("pf") ||
          n.includes("provident") ||
          n.includes("esic") ||
          n.includes("labour")
        )
          return "fa-users";
        if (
          n.includes("company") ||
          n.includes("corporate") ||
          n.includes("mca") ||
          n.includes("roc")
        )
          return "fa-building";
        if (
          n.includes("environment") ||
          n.includes("pollution") ||
          n.includes("pcb")
        )
          return "fa-leaf";
        if (
          n.includes("licence") ||
          n.includes("license") ||
          n.includes("permit") ||
          n.includes("shop")
        )
          return "fa-id-card";
        if (
          n.includes("audit") ||
          n.includes("account") ||
          n.includes("balance")
        )
          return "fa-balance-scale";
        if (
          n.includes("return") ||
          n.includes("filing") ||
          n.includes("annual")
        )
          return "fa-file-alt";
        if (
          n.includes("legal") ||
          n.includes("court") ||
          n.includes("contract")
        )
          return "fa-gavel";
        if (n.includes("insurance") || n.includes("policy"))
          return "fa-shield-alt";
        if (n.includes("fssai") || n.includes("food")) return "fa-utensils";
        if (n.includes("fire") || n.includes("safety"))
          return "fa-fire-extinguisher";
        if (n.includes("electricity") || n.includes("power")) return "fa-bolt";
        return "fa-tasks";
      }

      function buildVNextCard(c, clickFn, assignUrl, viewUrl) {
                var statusBadgeClass = getVNextBadgeClass(c.status);
                var statusIcon = getStatusIconClass(c.status);
                var cardIcon = getComplianceIcon(c.templateName || c.name || "");
                var statusLabel = getStatusInfo(c.status).label;
                var subCount = c.subCompliances ? c.subCompliances.length : 0;
                var isConfigured = c.isConfigured || false;
                var priority = c.priority || 0;
                var cardBlinkerCls = subCount > 0
                    ? getCardBlinkerFromSubs(c.subCompliances)
                    : getBlinkerClass(c.dueDate, c.status);

                var subListHtml = "";
                if (subCount > 0) {
                    subListHtml =
                        '<div class="vnext-sub-list"><div class="vnext-sub-list-title"><i class="fas fa-list" style="margin-right:4px;"></i>Sub-Compliances</div>';
                    var displaySubs = c.subCompliances.slice(0, 5);
                    for (var j = 0; j < displaySubs.length; j++) {
                        var s = displaySubs[j];
                        var bCls = getBlinkerClass(s.dueDate, s.status);
                        var sBadge = getVNextBadgeClass(s.status);
                        var sLabel = getStatusInfo(s.status).label;
                        var sDue = s.dueDate ? formatDate(s.dueDate) : "—";
                        var days = s.dueDate ? getDaysRemaining(s.dueDate) : null;
                        var daysLabel = "";
                        if (days !== null && !isNaN(days) && s.status !== "COMPLETED") {
                            daysLabel = days < 0 ? " (OD)" : " (" + days + "d)";
                        }
                        subListHtml +=
                            '<div class="vnext-sub-item">' +
                            '<span class="vnext-sub-bullet"></span>' +
                            '<span class="vnext-sub-name" title="' +
                            escapeHtml(s.name) +
                            '">' +
                            escapeHtml(s.name) +
                            "</span>" +
                            '<div class="vnext-sub-right">' +
                            '<span class="vnext-due-label">' +
                            sDue +
                            daysLabel +
                            "</span>" +
                            (bCls ? '<span class="vnext-blinker ' + bCls + '"></span>' : "") +
                            '<span class="vnext-badge ' +
                            sBadge +
                            '" style="font-size:9px;padding:2px 6px;">' +
                            sLabel +
                            "</span>" +
                            "</div></div>";
                    }
                    if (subCount > 5) {
                        subListHtml +=
                            '<div class="vnext-more-subs"><i class="fas fa-ellipsis-h"></i> +' +
                            (subCount - 5) +
                            " more</div>";
                    }
                    subListHtml += "</div>";
                } else if (c.dueDate) {
                    var bCls = getBlinkerClass(c.dueDate, c.status);
                    var days = getDaysRemaining(c.dueDate);
                    var daysLabel = "";
                    if (days !== null && !isNaN(days) && c.status !== "COMPLETED") {
                        daysLabel =
                            days < 0
                                ? " (Overdue)"
                                : " (" + days + " day" + (days === 1 ? "" : "s") + ")";
                    }
                    subListHtml =
                        '<div class="vnext-no-sub-due">' +
                        '<i class="fas fa-calendar-alt" style="color:#d4af37;"></i>' +
                        "<span>Due: " +
                        formatDate(c.dueDate) +
                        daysLabel +
                        "</span>" +
                        (bCls ? '<span class="vnext-blinker ' + bCls + '"></span>' : "") +
                        "</div>";
                }

                var priorityBadge = '<span class="vnext-badge" style="background:rgba(79,70,229,0.1);color:var(--primary);border:1px solid rgba(79,70,229,0.2);font-size:9px;padding:1px 8px;">' +
                    '<i class="fas fa-sort-numeric-down"></i> Priority: ' + priority +
                    '</span>';

                return (
                              '<div class="compliance-card" style="position:relative;" onclick="' +
                              clickFn +
                              '">' +
                              (cardBlinkerCls
                                  ? '<span class="vnext-blinker ' + cardBlinkerCls + '" style="position:absolute;top:10px;right:10px;z-index:2;"></span>'
                                  : "") +
                              '<div class="vnext-card-body">' +
                              '<div class="vnext-card-top">' +
                              '<div class="vnext-card-icon">' +
                              '<i class="fas ' + cardIcon + '"></i>' +
                              '</div>' +
                              '<div class="vnext-card-title-block">' +
                    '<div class="vnext-card-title">' +
                    escapeHtml(c.templateName || c.name || "Compliance") +
                    "</div>" +
                    '<div class="vnext-card-badges">' +
                    '<span class="vnext-badge ' +
                    statusBadgeClass +
                    '"><i class="fas ' +
                    statusIcon +
                    '"></i> ' +
                    statusLabel +
                    "</span>" +
                    '<span class="vnext-badge vnext-badge-custom"><i class="fas ' +
                    (c.isSuperAdmin ? "fa-user-shield" : "fa-user-tie") +
                    '"></i> ' +
                    (c.isSuperAdmin ? "Admin" : "Custom") +
                    "</span>" +
                    priorityBadge +
                    "</div>" +
                    "</div>" +
                    "</div>" +
                    '<div class="vnext-card-meta">' +
                    (c.frequency
                        ? '<span class="vnext-meta-item"><i class="fas fa-redo"></i>' +
                        getFrequencyLabel(c.frequency) +
                        "</span>"
                        : "") +
                    '<span class="vnext-meta-item"><i class="fas fa-sitemap"></i>' +
                    subCount +
                    " sub(s)</span>" +
                    '<span class="vnext-meta-item"><i class="fas ' +
                    (isConfigured ? "fa-check-circle" : "fa-clock") +
                    '"></i>' +
                    (isConfigured ? "Configured" : "Pending setup") +
                    "</span>" +
                    "</div>" +
                    subListHtml +
                    "</div>" +
                    '<div class="vnext-card-footer">' +

                    (viewUrl
                        ? '<button class="vnext-btn vnext-btn-ghost" onclick="event.stopPropagation();window.location.href=\'' +
                        viewUrl +
                        "'\">" +
                        '<i class="fas fa-eye"></i> View</button>'
                        : "") +
                    "</div>" +
                    "</div>"
                );
            }

      function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("open");
      }

      document.addEventListener("click", function (e) {
        if (window.innerWidth <= 1024) {
          var sidebar = document.getElementById("sidebar");
          if (sidebar && sidebar.classList.contains("open")) {
            if (
              !sidebar.contains(e.target) &&
              !e.target.closest(".menu-toggle")
            )
              sidebar.classList.remove("open");
          }
        }
      });

      function handleLogout() {
        localStorage.removeItem("accessToken");
        localStorage.removeItem("user");
        window.location.href = contextPath + "/login?logout=true";
      }

      function toggleNotifications() {
        var dropdown = document.getElementById("notificationDropdown");
        dropdown.classList.toggle("open");
        if (dropdown.classList.contains("open")) loadNotifications();
      }

      async function loadNotifications() {
        try {
          var data = await api("/api/notifications/active");
          var list = document.getElementById("notificationList");
          if (!list) return;
          if (data && data.success && data.data && data.data.length > 0) {
            var html = "";
            for (var i = 0; i < data.data.length; i++) {
              var n = data.data[i];
              var dotClass =
                n.notificationType === "URGENT"
                  ? "urgent"
                  : n.notificationType === "IMPORTANT"
                    ? "important"
                    : "general";
              html +=
                '<div class="notification-item"><div class="notif-title"><span class="notif-dot ' +
                dotClass +
                '"></span>' +
                escapeHtml(n.title) +
                "</div>" +
                '<div class="notif-message">' +
                escapeHtml(n.message) +
                "</div>" +
                '<div class="notif-time"><i class="far fa-clock"></i> ' +
                formatTimeAgo(n.createdAt) +
                "</div></div>";
            }
            list.innerHTML = html;
            document.getElementById("notifBadge").textContent =
              data.data.length;
          } else {
            list.innerHTML =
              '<div class="notification-empty"><i class="fas fa-bell-slash"></i><div>No notifications</div></div>';
            document.getElementById("notifBadge").textContent = "0";
          }
        } catch (e) {
          console.log("Notification error:", e);
        }
      }

      function formatTimeAgo(dateStr) {
        if (!dateStr) return "Just now";
        try {
          var date = new Date(dateStr);
          var now = new Date();
          var diff = Math.floor((now - date) / 1000);
          if (diff < 60) return diff + "s ago";
          if (diff < 3600) return Math.floor(diff / 60) + "m ago";
          if (diff < 86400) return Math.floor(diff / 3600) + "h ago";
          if (diff < 2592000) return Math.floor(diff / 86400) + "d ago";
          return date.toLocaleDateString("en-IN", {
            day: "2-digit",
            month: "short",
            year: "numeric",
          });
        } catch (e) {
          return "Just now";
        }
      }

      function markAllRead() {
        toast("All notifications marked as read", "success");
        var list = document.getElementById("notificationList");
        if (list)
          list.innerHTML =
            '<div class="notification-empty"><i class="fas fa-check-circle" style="color:var(--success);"></i><div>All caught up!</div></div>';
        document.getElementById("notifBadge").textContent = "0";
      }

      document.addEventListener("click", function (e) {
        var dropdown = document.getElementById("notificationDropdown");
        var btn = document.querySelector('[onclick*="toggleNotifications"]');
        if (dropdown && btn) {
          if (
            dropdown.classList.contains("open") &&
            !dropdown.contains(e.target) &&
            !btn.contains(e.target)
          )
            dropdown.classList.remove("open");
        }
      });

      function switchTab(tabName) {
        document.querySelectorAll(".tab-btn").forEach(function (btn) {
          btn.classList.toggle("active", btn.dataset.tab === tabName);
        });
        document.querySelectorAll(".tab-pane").forEach(function (pane) {
          pane.classList.remove("active");
        });
        var target = document.getElementById("tab-" + tabName);
        if (target) target.classList.add("active");
        if (tabName === "all") renderComplianceCards("all");
        else if (tabName === "overdue") renderComplianceCards("overdue");
        else if (tabName === "pending") renderComplianceCards("pending");
        else if (tabName === "completed") renderComplianceCards("completed");
        else if (tabName === "categories") renderComplianceCards("categories");
        else if (tabName === "subs") renderComplianceCards("subs");
      }

      async function loadDashboard() {
        try {
          const userStr = localStorage.getItem("user");
          if (userStr) {
            try {
              const u = JSON.parse(userStr);
              document.getElementById("userName").textContent =
                u.firstName + " " + u.lastName;
              document.getElementById("userAvatar").textContent =
                (u.firstName || "U")[0] + (u.lastName || "")[0];
              document.getElementById("userRole").textContent = (
                u.role || ""
              ).replace("_", " ");
              document.getElementById("welcomeName").textContent =
                (u.firstName || "Company") + " " + (u.lastName || "Admin");
            } catch (e) {}
          }
          await loadCompliances();
          await loadNotifications();
        } catch (error) {
          console.error("Error loading dashboard:", error);
          toast("Failed to load dashboard data", "error");
        }
      }




      async function loadCompliances() {
          document.getElementById("complianceLoader").style.display = "block";
          document.getElementById("complianceCardsGrid").style.display = "none";
          document.getElementById("complianceEmptyState").style.display = "none";
          try {
              var data = await api("/api/company-admin/compliance/assigned");
              if (data && data.success) {
                  allCompliances = data.data || [];
                  var grouped = {};
                  var today = new Date();
                  today.setHours(0, 0, 0, 0); // start of day for comparison

                  for (var i = 0; i < allCompliances.length; i++) {
                      var item = allCompliances[i];
                      var templateId = item.templateId;
                      if (!templateId) continue;

                      if (!grouped[templateId]) {
                          grouped[templateId] = {
                              templateId: templateId,
                              templateName: item.templateName || "Unknown",
                              isSuperAdmin: item.isSuperAdminConfig !== false,
                              isCustom: item.isSuperAdminConfig === false,
                              subCompliances: [],
                              companyId: item.companyId,
                              companyName: item.companyName,
                              status: "PENDING",
                              isConfigured: false,
                              dueDate: null,
                              frequency: null,
                              description: null,
                              priority: item.priority || 0,
                          };
                      }

                      if (item.subTemplateId !== null && item.subTemplateId !== undefined) {
                          // Determine effective status (check due date for OVERDUE)
                          var subStatus = item.status || "PENDING";
                          if (item.dueDate) {
                              var due = new Date(item.dueDate);
                              due.setHours(0, 0, 0, 0);
                              if (due < today && subStatus !== "COMPLETED") {
                                  subStatus = "OVERDUE";
                              }
                          }
                          grouped[templateId].subCompliances.push({
                              id: item.id,
                              subTemplateId: item.subTemplateId,
                              name: item.subTemplateName || "Sub-Compliance",
                              status: subStatus,
                              dueDate: item.dueDate,
                              frequency: item.frequency,
                              isConfigured: item.configured !== false,
                              companyComplianceId: item.companyComplianceId || item.id,
                          });
                      } else {
                          grouped[templateId].isConfigured = item.configured !== false;
                          grouped[templateId].status = item.status || "PENDING";
                          grouped[templateId].dueDate = item.dueDate;
                          grouped[templateId].frequency = item.frequency;
                          grouped[templateId].description = item.description;
                          grouped[templateId].priority = item.priority || 0;
                      }
                  }

                  groupedCompliances = Object.values(grouped);

                  // Sort by priority
                  groupedCompliances.sort(function(a, b) {
                      var priorityA = a.priority || 0;
                      var priorityB = b.priority || 0;
                      if (priorityA !== priorityB) return priorityA - priorityB;
                      return (a.templateName || "").localeCompare(b.templateName || "");
                  });

                  // Compute overall status per group using the effective sub-statuses
                  for (var i = 0; i < groupedCompliances.length; i++) {
                      var group = groupedCompliances[i];
                      if (group.subCompliances.length > 0) {
                          var statuses = group.subCompliances.map(function(s) {
                              return s.status || "PENDING";
                          });
                          var hasOverdue = statuses.some(function(s) { return s === "OVERDUE"; });
                          var allCompleted = statuses.every(function(s) { return s === "COMPLETED"; });
                          var anyInProgress = statuses.some(function(s) { return s === "IN_PROGRESS"; });
                          if (allCompleted) group.status = "COMPLETED";
                          else if (hasOverdue) group.status = "OVERDUE";
                          else if (anyInProgress) group.status = "IN_PROGRESS";
                          else group.status = "PENDING";
                          group.isConfigured = group.subCompliances.some(function(s) {
                              return s.isConfigured === true;
                          });
                      }
                  }

                  updateStats();
                  filterComplianceCards();
                  document.getElementById("complianceLoader").style.display = "none";
                  document.getElementById("complianceCardsGrid").style.display = "grid";
                  if (groupedCompliances.length === 0) {
                      document.getElementById("complianceEmptyState").style.display = "block";
                  }
              } else {
                  document.getElementById("complianceLoader").style.display = "none";
                  document.getElementById("complianceEmptyState").style.display = "block";
              }
          } catch (error) {
              console.error("Error loading compliances:", error);
              document.getElementById("complianceLoader").style.display = "none";
              document.getElementById("complianceEmptyState").style.display = "block";
          }
      }







      function updateStats() {
        var totalCategories = groupedCompliances.length,
          totalSubs = 0,
          completed = 0,
          overdue = 0,
          superAdminCount = 0;
        for (var i = 0; i < groupedCompliances.length; i++) {
          var group = groupedCompliances[i];
          totalSubs += group.subCompliances.length;
          if (group.status === "COMPLETED") completed++;
          else if (group.status === "OVERDUE") overdue++;
          if (group.isSuperAdmin) superAdminCount++;
        }
        document.getElementById("statCategories").textContent = totalCategories;
        document.getElementById("statSubs").textContent = totalSubs;
        document.getElementById("statCompleted").textContent = completed;
        document.getElementById("statOverdue").textContent = overdue;
        document.getElementById("statSuperAdminCount").textContent =
          superAdminCount;
      }

      function filterComplianceCards() {
        var searchTerm = document
          .getElementById("complianceSearch")
          .value.toLowerCase();
        var statusFilter = document.getElementById(
          "complianceStatusFilter",
        ).value;
        filteredCompliances = groupedCompliances.filter(function (c) {
          if (searchTerm && !c.templateName.toLowerCase().includes(searchTerm))
            return false;
          if (statusFilter !== "all") {
            var status = (c.status || "PENDING").toLowerCase();
            if (status !== statusFilter) return false;
          }
          return true;
        });
        renderComplianceCards("all");
      }

      // ==================== RENDER COMPLIANCE CARDS ====================
      function renderComplianceCards(mode) {
        var gridId = "complianceCardsGrid";
        var data = filteredCompliances;

        if (mode === "overdue") {
          gridId = "overdueGrid";
          data = groupedCompliances.filter(function (c) {
            return c.status === "OVERDUE";
          });
        } else if (mode === "pending") {
          gridId = "pendingGrid";
          data = groupedCompliances.filter(function (c) {
            return c.status === "PENDING" || c.status === "IN_PROGRESS";
          });
        } else if (mode === "completed") {
          gridId = "completedGrid";
          data = groupedCompliances.filter(function (c) {
            return c.status === "COMPLETED";
          });
        } else if (mode === "categories") {
          gridId = "categoriesGrid";
          data = groupedCompliances;
        } else if (mode === "subs") {
          gridId = "subsGrid";
          var allSubs = [];
          for (var i = 0; i < groupedCompliances.length; i++) {
            var group = groupedCompliances[i];
            for (var j = 0; j < group.subCompliances.length; j++) {
              var s = group.subCompliances[j];
              allSubs.push({
                id: s.id,
                name: s.name,
                status: s.status,
                dueDate: s.dueDate,
                frequency: s.frequency,
                isConfigured: s.isConfigured,
                parentName: group.templateName,
                parentId: group.templateId,
                isSuperAdmin: group.isSuperAdmin,
              });
            }
          }
          data = allSubs;
          renderSubCompliances(gridId, data);
          return;
        }

        var grid = document.getElementById(gridId);
        if (!grid) return;

        if (!data || data.length === 0) {
          grid.innerHTML =
            '<div class="empty-state"><i class="fas fa-inbox"></i><div>No items found</div></div>';
          return;
        }

        var html = "";
        for (var i = 0; i < data.length; i++) {
          var c = data[i];
          var clickFn = "openCompliance(" + c.templateId + ")";
          var assignUrl =
            contextPath + "/company-admin/compliance/assign?id=" + c.templateId;
          var viewUrl =
            contextPath + "/company-admin/compliance/parent/" + c.templateId;
          html += buildVNextCard(c, clickFn, assignUrl, viewUrl);
        }
        grid.innerHTML = html;
      }

      // ==================== RENDER SUB-COMPLIANCES ====================
      function renderSubCompliances(gridId, data) {
        var grid = document.getElementById(gridId);
        if (!grid) return;
        if (!data || data.length === 0) {
          grid.innerHTML =
            '<div class="empty-state"><i class="fas fa-inbox"></i><div>No sub-compliances found</div></div>';
          return;
        }

        var html = "";
        for (var i = 0; i < data.length; i++) {
          var s = data[i];
          var bCls = getBlinkerClass(s.dueDate, s.status);
          var sBadge = getVNextBadgeClass(s.status);
          var sIcon = getStatusIconClass(s.status);
          var sLabel = getStatusInfo(s.status).label;
          var cardIcon = getComplianceIcon(s.name || "");
          var days = s.dueDate ? getDaysRemaining(s.dueDate) : null;
          var daysLabel = "";
          if (days !== null && !isNaN(days) && s.status !== "COMPLETED") {
            daysLabel = days < 0 ? " (Overdue)" : " (" + days + "d)";
          }

          html +=
            '<div class="compliance-card" onclick="openSubCompliance(' +
            s.id +
            ')">' +
            '<div class="vnext-card-body">' +
            '<div class="vnext-card-top">' +
            '<div class="vnext-card-icon"><i class="fas ' +
            cardIcon +
            '"></i></div>' +
            '<div class="vnext-card-title-block">' +
            '<div class="vnext-card-title">' +
            escapeHtml(s.name) +
            "</div>" +
            '<div style="font-size:11px;color:rgba(212,175,55,0.65);margin-bottom:6px;">' +
            escapeHtml(s.parentName) +
            "</div>" +
            '<div class="vnext-card-badges">' +
            '<span class="vnext-badge ' +
            sBadge +
            '"><i class="fas ' +
            sIcon +
            '"></i> ' +
            sLabel +
            "</span>" +
            '<span class="vnext-badge vnext-badge-custom"><i class="fas ' +
            (s.isSuperAdmin ? "fa-user-shield" : "fa-user-tie") +
            '"></i> ' +
            (s.isSuperAdmin ? "Admin" : "Custom") +
            "</span>" +
            "</div>" +
            "</div>" +
            "</div>" +
            '<div class="vnext-card-meta">' +
            (s.frequency
              ? '<span class="vnext-meta-item"><i class="fas fa-redo"></i>' +
                getFrequencyLabel(s.frequency) +
                "</span>"
              : "") +
            '<span class="vnext-meta-item"><i class="fas ' +
            (s.isConfigured ? "fa-check-circle" : "fa-clock") +
            '"></i>' +
            (s.isConfigured ? "Configured" : "Pending") +
            "</span>" +
            "</div>" +
            (s.dueDate
              ? '<div class="vnext-no-sub-due"><i class="fas fa-calendar-alt" style="color:#d4af37;"></i><span>Due: ' +
                formatDate(s.dueDate) +
                daysLabel +
                "</span>" +
                (bCls
                  ? '<span class="vnext-blinker ' + bCls + '"></span>'
                  : "") +
                "</div>"
              : "") +
            "</div>" +
            '<div class="vnext-card-footer">' +
            '<button class="vnext-btn vnext-btn-ghost" style="flex:1;" onclick="event.stopPropagation();window.location.href=\'' +
            contextPath +
            "/company-admin/compliance/sub/" +
            s.id +
            "'\">" +
            '<i class="fas fa-eye"></i> View Details</button>' +
            "</div>" +
            "</div>";
        }
        grid.innerHTML = html;
      }

      function openCompliance(templateId) {
        window.location.href =
          contextPath + "/company-admin/compliance/parent/" + templateId;
      }
      function openSubCompliance(subId) {
        window.location.href =
          contextPath + "/company-admin/compliance/sub/" + subId;
      }
      function refreshComplianceCards() {
        loadCompliances();
        toast("Compliances refreshed", "info");
      }
      function refreshDashboard() {
        loadDashboard();
        toast("Dashboard refreshed", "info");
      }

      document.addEventListener("DOMContentLoaded", function () {
        loadDashboard();
        var searchInput = document.getElementById("complianceSearch");
        if (searchInput) {
          var timeout;
          searchInput.addEventListener("input", function () {
            clearTimeout(timeout);
            timeout = setTimeout(filterComplianceCards, 300);
          });
        }
      });
    </script>
  </body>
</html>
