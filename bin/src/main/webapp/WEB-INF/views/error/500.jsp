<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- File: error/500.jsp --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 — VNext LLP</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body { background:#0a0c10; color:#e2e8f0; font-family:'DM Sans',sans-serif; min-height:100vh; display:flex; align-items:center; justify-content:center; margin:0; }
        .box { text-align:center; padding:48px 32px; }
        .code { font-family:'Syne',sans-serif; font-size:96px; font-weight:800; color:#1e2130; line-height:1; margin-bottom:8px; }
        .code span { color:#ef4444; }
        h2 { font-family:'Syne',sans-serif; font-size:22px; margin:0 0 12px; }
        p { color:#64748b; margin:0 0 28px; font-size:14px; }
        a { display:inline-block; background:#6366f1; color:#fff; padding:10px 24px; border-radius:8px; text-decoration:none; font-size:13px; font-weight:500; }
    </style>
</head>
<body>
    <div class="box">
        <div class="code"><span>5</span>00</div>
        <h2>Server Error</h2>
        <p>Something went wrong on our end. Please try again later.</p>
        <a href="${pageContext.request.contextPath}/login">Go to Login</a>
    </div>
</body>
</html>
