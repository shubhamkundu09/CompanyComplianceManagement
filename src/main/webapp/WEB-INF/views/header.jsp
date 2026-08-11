<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal</title>
    <style>
        /* ===== RESET & BASE ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --gold: #c09514;
            --gold-light: #d9b42c;
            --gold-dark: #a07f10;
            --border-gold: rgba(192, 149, 20, 0.3);
            --border-gold-strong: rgba(192, 149, 20, 0.6);
            --black: #0d0d0b;
            --white: #f5f3ed;
            --gray-1: #b5b3ab;
            --gray-2: #8a887f;
            --font-body: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
            --shadow-gold: rgba(192, 149, 20, 0.55);
        }

        body {
            font-family: var(--font-body);
            background: var(--black);
            color: var(--white);
            min-height: 100vh;
            padding-top: 76px;
            /* offset for fixed nav */;
        }

        /* ===== NAVBAR ===== */
        nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 200;
            padding: 0 4%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 76px;
            border-bottom: 1px solid var(--border-gold);
            background: rgba(13, 13, 11, 0.88);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            transition: height 0.4s ease, background 0.4s ease, box-shadow 0.4s ease;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
        }

        nav.scrolled {
            height: 62px;
            background: rgba(13, 13, 11, 0.97);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.6);
        }

        /* ----- LOGO ----- */
        .logo {
            display: flex;
            align-items: center;
            flex-shrink: 0;
            height: 76px;
            transition: height 0.4s ease;
        }

        .logo img {
            height: 84px;
            width: auto;
            object-fit: contain;
            transition: height 0.4s ease;
            display: block;
        }

        nav.scrolled .logo {
            height: 62px;
        }
        nav.scrolled .logo img {
            height: 60px;
        }

        /* ----- NAV LINKS ----- */
        .nav-links {
            display: flex;
            align-items: center;
            gap: 2.2rem;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .nav-links a {
            font-family: var(--font-body);
            font-size: 0.78rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: var(--white);
            text-decoration: none;
            position: relative;
            padding-bottom: 4px;
            transition: color 0.3s ease;
            font-weight: 600;
            white-space: nowrap;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--gold);
            transition: width 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 2px;
        }

        .nav-links a:hover::after,
        .nav-links a.active::after {
            width: 100%;
        }

        .nav-links a:hover {
            color: var(--gold);
        }
        .nav-links a.active {
            color: var(--gold);
        }
        .nav-links a.active::after {
            width: 100%;
        }

        /* ----- RIGHT GROUP (CTAs + Hamburger) ----- */
        .nav-right {
            display: flex;
            align-items: center;
            gap: 0.9rem;
            flex-shrink: 0;
        }

        .nav-cta-group {
            display: flex;
            align-items: center;
            gap: 0.7rem;
        }

        .nav-cta {
            font-family: var(--font-body);
            font-size: 0.7rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 9px 20px;
            border: 1px solid var(--gold);
            color: var(--gold);
            background: transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            white-space: nowrap;
            border-radius: 30px;
            font-weight: 600;
            position: relative;
            overflow: hidden;
        }

        .nav-cta::before {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--gold);
            transform: scaleX(0);
            transform-origin: right;
            transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 30px;
            z-index: -1;
        }

        .nav-cta:hover {
            color: var(--black);
            border-color: var(--gold);
            box-shadow: 0 0 20px rgba(192, 149, 20, 0.35);
        }

        .nav-cta:hover::before {
            transform: scaleX(1);
            transform-origin: left;
        }

        .nav-cta-primary {
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
            box-shadow: 0 4px 18px rgba(192, 149, 20, 0.35);
        }

        .nav-cta-primary::before {
            background: var(--gold-light);
        }

        .nav-cta-primary:hover {
            background: var(--gold-light);
            box-shadow: 0 6px 28px rgba(192, 149, 20, 0.5);
            color: var(--black);
        }

        .nav-cta-primary:hover::before {
            transform: scaleX(0);
        }

        /* ----- HAMBURGER ----- */
        .hamburger {
            display: none;
            flex-direction: column;
            gap: 5px;
            cursor: pointer;
            padding: 6px 4px;
            background: transparent;
            border: none;
            z-index: 210;
            transition: transform 0.3s ease;
        }

        .hamburger:hover {
            transform: scale(1.05);
        }

        .hamburger span {
            display: block;
            width: 26px;
            height: 2.5px;
            background: var(--gold);
            border-radius: 4px;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            transform-origin: center;
        }

        .hamburger.active span:nth-child(1) {
            transform: translateY(7px) rotate(45deg);
        }
        .hamburger.active span:nth-child(2) {
            opacity: 0;
            transform: scaleX(0);
        }
        .hamburger.active span:nth-child(3) {
            transform: translateY(-7px) rotate(-45deg);
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .nav-links {
                gap: 1.5rem;
            }
            .nav-links a {
                font-size: 0.7rem;
                letter-spacing: 0.18em;
            }
            .nav-cta {
                font-size: 0.65rem;
                padding: 8px 16px;
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
            }
            .nav-cta-group {
                display: none;
            }
            .hamburger {
                display: flex;
            }

            nav {
                padding: 0 5%;
            }
        }

        @media (max-width: 480px) {
            nav {
                height: 64px;
                padding: 0 4%;
            }
            .logo img {
                height: 60px;
            }
            nav.scrolled .logo img {
                height: 48px;
            }
            body {
                padding-top: 64px;
            }
        }

        /* ===== SIDEBAR ===== */
        .sidebar-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.75);
            z-index: 250;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.35s ease, visibility 0.35s ease;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
        }

        .sidebar-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .sidebar-nav {
            position: fixed;
            top: 0;
            right: -100%;
            width: 88%;
            max-width: 380px;
            height: 100vh;
            background: rgba(10, 10, 10, 0.98);
            backdrop-filter: blur(32px);
            -webkit-backdrop-filter: blur(32px);
            z-index: 300;
            transition: right 0.45s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            padding: 28px 26px 36px;
            border-left: 1px solid var(--border-gold);
            box-shadow: -12px 0 48px rgba(0, 0, 0, 0.7);
        }

        .sidebar-nav.open {
            right: 0;
        }

        .sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--border-gold);
            margin-bottom: 10px;
        }

        .sidebar-header .logo {
            height: 64px;
        }
        .sidebar-header .logo img {
            height: 64px;
        }

        .close-sidebar {
            background: transparent;
            border: 1px solid var(--border-gold-strong);
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            color: var(--gold);
            font-size: 1.3rem;
            font-weight: 300;
            line-height: 1;
        }

        .close-sidebar:hover {
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
            transform: rotate(90deg);
        }

        .sidebar-links {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
            padding-top: 8px;
        }

        .sidebar-links a {
            font-family: var(--font-body);
            font-size: 0.75rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--gray-1);
            text-decoration: none;
            padding: 12px 0 10px;
            border-bottom: 1px solid rgba(192, 149, 20, 0.12);
            transition: color 0.3s ease, padding-left 0.25s ease, border-color 0.3s ease;
            font-weight: 500;
        }

        .sidebar-links a:hover {
            color: var(--gold);
            padding-left: 10px;
            border-color: var(--border-gold);
        }

        .sidebar-links a.active {
            color: var(--gold);
            padding-left: 10px;
            border-color: var(--border-gold);
        }

        .sidebar-divider {
            height: 1px;
            background: var(--border-gold);
            margin: 18px 0 16px;
            opacity: 0.5;
        }

        .sidebar-cta-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 6px;
        }

        .sidebar-cta {
            font-family: var(--font-body);
            font-size: 0.78rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 14px 0;
            text-align: center;
            border: 1px solid var(--gold);
            border-radius: 40px;
            cursor: pointer;
            text-decoration: none;
            display: block;
            transition: all 0.3s ease;
            font-weight: 600;
            background: transparent;
            color: var(--gold);
        }

        .sidebar-cta-primary {
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
        }

        .sidebar-cta-primary:hover {
            background: var(--gold-light);
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(192, 149, 20, 0.35);
            color: var(--black);
        }

        .sidebar-cta-outline:hover {
            background: rgba(192, 149, 20, 0.12);
            transform: translateY(-2px);
        }

        .sidebar-footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid var(--border-gold);
            font-size: 0.65rem;
            color: var(--gray-2);
            text-align: center;
            letter-spacing: 0.08em;
        }

        /* ===== DEMO PAGE CONTENT ===== */
        .page-content {
            max-width: 1200px;
            margin: 40px auto 60px;
            padding: 0 5%;
        }

        .page-content h1 {
            font-size: 2.8rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .page-content p {
            font-size: 1.1rem;
            color: var(--gray-1);
            max-width: 640px;
            line-height: 1.7;
        }

        .page-content .badge {
            display: inline-block;
            margin-top: 1.5rem;
            padding: 8px 20px;
            border: 1px solid var(--border-gold);
            border-radius: 40px;
            font-size: 0.7rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--gold);
        }

        @media (max-width: 600px) {
            .page-content h1 {
                font-size: 2rem;
            }
            .page-content p {
                font-size: 0.95rem;
            }
        }
    </style>
</head>
<body>

    <!-- ===== NAVBAR ===== -->
    <nav id="navbar">
        <!-- Logo -->
        <div class="logo">
            <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext Legal">
        </div>

        <!-- Nav Links -->
        <ul class="nav-links">
            <li><a href="home">Home</a></li>
            <li><a href="about">About</a></li>
            <li><a href="service">Services</a></li>
            <li><a href="team">Our Team</a></li>
            <li><a href="contact">Contact</a></li>
        </ul>

        <!-- Right side: CTAs + Hamburger -->
        <div class="nav-right">
            <div class="nav-cta-group">
                <!-- 🔽 DOWNLOAD PDF BUTTON (main navbar) -->
                <a href="${baseUrl}/vnextimages/companyfiles/brochure.pdf" class="nav-cta nav-cta-primary" download>Download Brochure</a>
                <a href="login" class="nav-cta">Login</a>
            </div>
            <button class="hamburger" id="hamburgerBtn" aria-label="Toggle menu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </nav>

    <!-- ===== SIDEBAR OVERLAY ===== -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- ===== SIDEBAR ===== -->
    <div class="sidebar-nav" id="sidebarNav">
        <div class="sidebar-header">
            <div class="logo">
                <img src="${baseUrl}/vnextimages/companyfiles/logo.png" alt="VNext Legal">
            </div>
            <button class="close-sidebar" id="closeSidebarBtn" aria-label="Close menu">✕</button>
        </div>

        <div class="sidebar-links">
            <a href="home">Home</a>
            <a href="about">About</a>
            <a href="service">Services</a>
            <a href="team">Our Team</a>
            <a href="contact">Contact</a>
        </div>

        <div class="sidebar-divider"></div>

        <div class="sidebar-cta-group">
            <!-- 🔽 DOWNLOAD PDF BUTTON (sidebar) -->
            <a href="brochure.pdf" class="sidebar-cta sidebar-cta-primary" download>Download Brochure</a>
            <a href="login" class="sidebar-cta sidebar-cta-outline">Login</a>
        </div>

        <div class="sidebar-footer">
            &copy; 2026 VNext Legal &mdash; All rights reserved.
        </div>
    </div>



    <!-- ===== SCRIPTS ===== -->
    <script>
        (function() {
            'use strict';

            // ---- DOM refs ----
            const nav = document.getElementById('navbar');
            const hamburger = document.getElementById('hamburgerBtn');
            const sidebar = document.getElementById('sidebarNav');
            const overlay = document.getElementById('sidebarOverlay');
            const closeBtn = document.getElementById('closeSidebarBtn');

            // ---- Navbar scroll effect ----
            let ticking = false;
            function handleScroll() {
                if (!ticking) {
                    window.requestAnimationFrame(function() {
                        if (nav) {
                            const shouldScrolled = window.scrollY > 60;
                            nav.classList.toggle('scrolled', shouldScrolled);
                        }
                        ticking = false;
                    });
                    ticking = true;
                }
            }
            window.addEventListener('scroll', handleScroll, { passive: true });
            // initial check
            if (nav && window.scrollY > 60) nav.classList.add('scrolled');

            // ---- Sidebar controls ----
            function openSidebar() {
                sidebar.classList.add('open');
                overlay.classList.add('active');
                document.body.style.overflow = 'hidden';
                if (hamburger) hamburger.classList.add('active');
            }

            function closeSidebar() {
                sidebar.classList.remove('open');
                overlay.classList.remove('active');
                document.body.style.overflow = '';
                if (hamburger) hamburger.classList.remove('active');
            }

            // Open: hamburger click
            if (hamburger) {
                hamburger.addEventListener('click', function(e) {
                    e.stopPropagation();
                    if (sidebar.classList.contains('open')) {
                        closeSidebar();
                    } else {
                        openSidebar();
                    }
                });
            }

            // Close: close button
            if (closeBtn) {
                closeBtn.addEventListener('click', closeSidebar);
            }

            // Close: overlay click
            if (overlay) {
                overlay.addEventListener('click', closeSidebar);
            }

            // Close: Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && sidebar.classList.contains('open')) {
                    closeSidebar();
                }
            });

            // Close: any sidebar link or CTA click
            document.querySelectorAll('.sidebar-links a, .sidebar-cta').forEach(function(link) {
                link.addEventListener('click', closeSidebar);
            });

            // ---- Active link highlight ----
            function setActiveLink() {
                const currentPath = window.location.pathname;
                const cleanCurrent = currentPath.split('/').filter(Boolean).pop() || 'home';

                document.querySelectorAll('.nav-links a, .sidebar-links a').forEach(function(link) {
                    const href = link.getAttribute('href');
                    if (!href) return;
                    const cleanHref = href.split('/').filter(Boolean).pop() || 'home';
                    link.classList.toggle('active', cleanHref === cleanCurrent);
                });
            }
            setActiveLink();

            // ---- Resize: close sidebar on wide screens ----
            let resizeTimer;
            window.addEventListener('resize', function() {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function() {
                    if (window.innerWidth > 900 && sidebar.classList.contains('open')) {
                        closeSidebar();
                    }
                }, 150);
            });

        })();
    </script>

</body>
</html>