<%-- File: auth/login.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VNext Legal LLP · Sign in</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f2f6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .login-container {
            width: 100%;
            max-width: 1280px;
            min-height: 700px;
            background: #ffffff;
            border-radius: 48px;
            box-shadow:
                0 60px 120px -40px rgba(0, 0, 0, 0.18),
                0 20px 40px -20px rgba(0, 0, 0, 0.06);
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            overflow: hidden;
            position: relative;
        }
        /* -------- LEFT PANEL : BRAND / HERO -------- */
        .hero-panel {
            background: linear-gradient(165deg, #0a1628 0%, #1a2a45 50%, #1f3452 100%);
            padding: 3.5rem 3.2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        .hero-panel::before {
            content: '';
            position: absolute;
            top: -30%;
            right: -20%;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(79, 140, 255, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .hero-panel::after {
            content: '';
            position: absolute;
            bottom: -10%;
            left: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(100, 180, 255, 0.06) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .hero-top {
            display: flex;
            align-items: center;
            gap: 0.9rem;
            position: relative;
            z-index: 2;
        }
        .hero-top img {
            height: 52px;
            width: auto;
            object-fit: contain;

        }
        .hero-top .brand-name {
            font-size: 1.8rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #ffffff;
            line-height: 1;
        }
        .hero-top .brand-badge {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(4px);
            padding: 0.2rem 1rem;
            border-radius: 40px;
            font-size: 0.65rem;
            font-weight: 600;
            letter-spacing: 0.06em;
            color: #9bb9e6;
            border: 1px solid rgba(255,255,255,0.06);
            text-transform: uppercase;
        }
        .hero-content {
            position: relative;
            z-index: 2;
            margin: 1.5rem 0 2rem 0;
        }
        .hero-content .tagline {
            font-size: 2.6rem;
            font-weight: 700;
            line-height: 1.15;
            color: #ffffff;
            letter-spacing: -0.03em;
            margin-bottom: 1.2rem;
        }
        .hero-content .tagline span {
            color: #7bb3ff;
        }
        .hero-content .description {
            font-size: 1rem;
            line-height: 1.7;
            color: #b3cbeb;
            max-width: 85%;
            font-weight: 400;
            opacity: 0.9;
        }
        .hero-features {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 1.2rem;
            position: relative;
            z-index: 2;
        }
        .hero-features .feature {
            display: flex;
            align-items: center;
            gap: 1rem;
            color: #d0e1fa;
            font-size: 0.92rem;
            font-weight: 400;
        }
        .hero-features .feature .icon-wrap {
            width: 2.2rem;
            height: 2.2rem;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7bb3ff;
            font-size: 1rem;
            border: 1px solid rgba(255,255,255,0.04);
            flex-shrink: 0;
        }
        .hero-footer {
            position: relative;
            z-index: 2;
            border-top: 1px solid rgba(255,255,255,0.06);
            padding-top: 1.8rem;
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: #7a96c2;
        }
        .hero-footer a {
            color: #b3cbeb;
            text-decoration: none;
            transition: 0.2s;
            font-weight: 400;
        }
        .hero-footer a:hover {
            color: #ffffff;
        }
        .hero-footer .social-icons {
            display: flex;
            gap: 1.2rem;
        }
        .hero-footer .social-icons a {
            color: #6a88b4;
            font-size: 0.95rem;
            transition: 0.2s;
        }
        .hero-footer .social-icons a:hover {
            color: #ffffff;
        }

        /* -------- RIGHT PANEL : LOGIN -------- */
        .login-panel {
            padding: 3.5rem 3.2rem;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .login-panel .login-header {
            margin-bottom: 2.5rem;
        }
        .login-panel .login-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #0a1628;
            letter-spacing: -0.02em;
        }
        .login-panel .login-header p {
            color: #64748b;
            font-size: 0.95rem;
            margin-top: 0.4rem;
            font-weight: 400;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
            letter-spacing: 0.01em;
        }
        .form-group label i {
            margin-right: 0.5rem;
            color: #94a3b8;
            font-weight: 400;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 0.95rem;
            pointer-events: none;
        }
        .input-wrapper input {
            width: 100%;
            padding: 0.9rem 1rem 0.9rem 3rem;
            border: 1.5px solid #e9edf4;
            border-radius: 16px;
            background: #fafcff;
            font-size: 0.95rem;
            color: #0a1628;
            transition: all 0.25s ease;
            font-weight: 400;
        }
        .input-wrapper input::placeholder {
            color: #b2c0d4;
            font-weight: 400;
        }
        .input-wrapper input:focus {
            outline: none;
            border-color: #1a2a45;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(26, 42, 69, 0.06);
        }
        .input-wrapper .toggle-pw {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: #94a3b8;
            cursor: pointer;
            padding: 0.3rem;
            transition: 0.2s;
            font-size: 1rem;
        }
        .input-wrapper .toggle-pw:hover {
            color: #1e293b;
        }
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0.25rem 0 2rem 0;
        }
        .form-options .remember {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 0.85rem;
            color: #475569;
            font-weight: 400;
            cursor: pointer;
        }
        .form-options .remember input[type="checkbox"] {
            width: 1.05rem;
            height: 1.05rem;
            accent-color: #0a1628;
            border-radius: 6px;
            border: 1.5px solid #cbd5e1;
            cursor: pointer;
        }
        .form-options .forgot-link {
            font-size: 0.85rem;
            font-weight: 500;
            color: #0a1628;
            text-decoration: none;
            transition: 0.2s;
        }
        .form-options .forgot-link:hover {
            color: #3b5b8a;
            text-decoration: underline;
        }
        .btn-login {
            background: #0a1628;
            color: white;
            border: none;
            border-radius: 40px;
            padding: 1rem 1.5rem;
            font-weight: 600;
            font-size: 0.95rem;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.7rem;
            transition: all 0.25s ease;
            cursor: pointer;
            letter-spacing: 0.01em;
        }
        .btn-login:hover {
            background: #1a2a45;
            transform: translateY(-1px);
            box-shadow: 0 12px 28px -12px rgba(10, 22, 40, 0.35);
        }
        .btn-login:disabled {
            opacity: 0.6;
            pointer-events: none;
            transform: none;
        }
        .alert-box {
            padding: 0.9rem 1.2rem;
            border-radius: 16px;
            font-size: 0.9rem;
            margin-bottom: 1.2rem;
            display: none;
            animation: slideDown 0.3s ease;
            font-weight: 500;
        }
        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }
        .alert-success {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
        }
        @keyframes slideDown {
            0% { opacity: 0; transform: translateY(-8px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .demo-hint {
            margin-top: 2.2rem;
            padding-top: 1.8rem;
            border-top: 1px solid #f1f4f9;
            text-align: center;
        }
        .demo-hint .demo-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #94a3b8;
            font-weight: 600;
        }
        .demo-hint .credentials {
            display: flex;
            justify-content: center;
            gap: 0.6rem;
            flex-wrap: wrap;
            margin-top: 0.5rem;
        }
        .demo-hint .credentials .cred {
            background: #f1f5f9;
            padding: 0.25rem 1rem;
            border-radius: 40px;
            font-size: 0.75rem;
            font-weight: 500;
            color: #1e293b;
            font-family: 'Inter', monospace;
            letter-spacing: 0.01em;
        }
        .demo-hint .credentials .sep {
            color: #cbd5e1;
            font-weight: 300;
        }
        .demo-hint .role-badge {
            display: inline-block;
            background: #e9edf4;
            padding: 0.15rem 0.8rem;
            border-radius: 40px;
            font-size: 0.6rem;
            font-weight: 600;
            color: #475569;
            margin-left: 0.3rem;
            letter-spacing: 0.03em;
            text-transform: uppercase;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .login-container {
                grid-template-columns: 1fr;
                min-height: auto;
                border-radius: 32px;
            }
            .hero-panel {
                padding: 2.5rem 2rem;
                order: 1;
            }
            .login-panel {
                padding: 2.5rem 2rem;
                order: 2;
            }
            .hero-content .tagline {
                font-size: 2rem;
            }
            .hero-content .description {
                max-width: 100%;
            }
        }
        @media (max-width: 480px) {
            .hero-panel { padding: 2rem 1.5rem; }
            .login-panel { padding: 2rem 1.5rem; }
            .hero-content .tagline { font-size: 1.6rem; }
            .login-panel .login-header h2 { font-size: 1.6rem; }
        }
    </style>
</head>
<body>

<div class="login-container">

    <!-- ====== LEFT PANEL : BRAND & COMPANY INFO ====== -->
    <div class="hero-panel">
        <div>
            <div class="hero-top">

                <img src="${pageContext.request.contextPath}/css/logo.png" alt="VNext LLP" class="logo-img" onerror="this.style.display='none'">
                <span class="brand-name">VNext Legal</span>
                <span class="brand-badge">LLP</span>
            </div>
            <div class="hero-content">
                <div class="tagline">
                    Transform your<br><span>business operations</span>
                </div>
                <p class="description">
                    Enterprise-grade platform built for modern teams.
                    Secure, scalable, and designed to accelerate your growth.
                </p>
                <div class="hero-features">
                    <div class="feature">
                        <span class="icon-wrap"><i class="fas fa-shield-alt"></i></span>
                        <span>Bank-grade security & end-to-end encryption</span>
                    </div>
                    <div class="feature">
                        <span class="icon-wrap"><i class="fas fa-bolt"></i></span>
                        <span>Real-time collaboration & instant insights</span>
                    </div>
                    <div class="feature">
                        <span class="icon-wrap"><i class="fas fa-users"></i></span>
                        <span>Role-based access for teams of any size</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="hero-footer">
            <span>© 2026 VNext Legal LLP. All rights reserved.</span>
            <div class="social-icons">
                <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" aria-label="GitHub"><i class="fab fa-github"></i></a>
            </div>
        </div>
    </div>

    <!-- ====== RIGHT PANEL : LOGIN ====== -->
    <div class="login-panel">
        <div class="login-header">
            <h2>Welcome back</h2>
            <p>Sign in to access your dashboard and projects.</p>
        </div>

        <!-- Alert messages -->
        <div id="errorMessage" class="alert-box alert-error"></div>
        <div id="successMessage" class="alert-box alert-success"></div>

        <form id="loginForm" autocomplete="off">
            <!-- Email -->
            <div class="form-group">
                <label for="email"><i class="far fa-envelope"></i> Email address</label>
                <div class="input-wrapper">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email"
                           placeholder="you@company.com" required>
                </div>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label for="password"><i class="fas fa-lock"></i> Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password" required>
                    <button type="button" id="togglePassword" class="toggle-pw" aria-label="Toggle password visibility">
                        <i class="far fa-eye"></i>
                    </button>
                </div>
            </div>

            <!-- Options -->
            <div class="form-options">
                <label class="remember">
                    <input type="checkbox" checked>
                    <span>Keep me signed in</span>
                </label>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <!-- Submit -->
            <button type="submit" id="loginBtn" class="btn-login">
                <i class="fas fa-arrow-right-to-bracket"></i> Sign in
            </button>
        </form>


        <div class="demo-hint">
            <div class="demo-label">— VNext Legal LLP —</div>

        </div>
    </div>
</div>

<script>
    (function() {
        const contextPath = '${pageContext.request.contextPath}';

        // DOM refs
        const form = document.getElementById('loginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const toggleBtn = document.getElementById('togglePassword');
        const loginBtn = document.getElementById('loginBtn');
        const errorDiv = document.getElementById('errorMessage');
        const successDiv = document.getElementById('successMessage');

        // Toggle password visibility
        toggleBtn.addEventListener('click', function() {
            const type = passwordInput.type === 'password' ? 'text' : 'password';
            passwordInput.type = type;
            const icon = this.querySelector('i');
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        });

        // Alert helpers
        function hideAlerts() {
            errorDiv.style.display = 'none';
            successDiv.style.display = 'none';
            errorDiv.textContent = '';
            successDiv.textContent = '';
        }

        function showError(msg) {
            hideAlerts();
            errorDiv.textContent = msg;
            errorDiv.style.display = 'block';
            clearTimeout(window._errTimer);
            window._errTimer = setTimeout(() => { errorDiv.style.display = 'none'; }, 6000);
        }

        function showSuccess(msg) {
            hideAlerts();
            successDiv.textContent = msg;
            successDiv.style.display = 'block';
            clearTimeout(window._sucTimer);
            window._sucTimer = setTimeout(() => { successDiv.style.display = 'none'; }, 5000);
        }

        function resetButton() {
            loginBtn.disabled = false;
            loginBtn.innerHTML = '<i class="fas fa-arrow-right-to-bracket"></i> Sign in';
        }

        function setLoading() {
            loginBtn.disabled = true;
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing in…';
        }

        // Submit handler
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            const email = emailInput.value.trim();
            const password = passwordInput.value.trim();

            if (!email || !password) {
                showError('Please fill in both email and password.');
                return;
            }

            setLoading();
            hideAlerts();

            try {
                const response = await fetch(contextPath + '/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email, password })
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    localStorage.setItem('accessToken', data.data.accessToken);
                    localStorage.setItem('user', JSON.stringify(data.data.user));
                    document.cookie = "accessToken=" + data.data.accessToken + "; path=/";

                    showSuccess('Signed in successfully. Redirecting…');

                    setTimeout(() => {
                        const role = data.data.user.role;
                        let target = contextPath + '/super-admin/dashboard';
                        if (role === 'COMPANY_ADMIN') target = contextPath + '/company-admin/dashboard';
                        else if (role === 'EMPLOYEE') target = contextPath + '/employee/dashboard';
                        window.location.href = target;
                    }, 1000);
                } else {
                    showError(data.message || data.error || 'Invalid credentials. Please try again.');
                    resetButton();
                }
            } catch (error) {
                console.error('Login error:', error);
                showError('Network error. Please check your connection.');
                resetButton();
            }
        });
    })();
</script>

</body>
</html>