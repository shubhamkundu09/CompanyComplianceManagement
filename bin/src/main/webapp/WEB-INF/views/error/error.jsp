<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%-- File: error/error.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error — VNext LLP</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body { background:#0a0c10; color:#e2e8f0; font-family:'DM Sans',sans-serif; min-height:100vh; display:flex; align-items:center; justify-content:center; margin:0; }
        .box { text-align:center; padding:48px 32px; max-width:420px; }
        .icon { font-size:56px; margin-bottom:16px; }
        h2 { font-family:'Syne',sans-serif; font-size:22px; margin:0 0 10px; }
        p { color:#64748b; margin:0 0 24px; font-size:14px; line-height:1.6; }
        .actions { display:flex; gap:10px; justify-content:center; flex-wrap:wrap; }
        a { display:inline-block; padding:10px 20px; border-radius:8px; text-decoration:none; font-size:13px; font-weight:500; transition:background .2s; }
        .a-primary { background:#6366f1; color:#fff; }
        .a-ghost { background:transparent; color:#64748b; border:1px solid #1e2130; }
        .a-ghost:hover { border-color:#6366f1; color:#818cf8; }
    </style>
</head>
<body>
    <div class="box">
        <div class="icon">⚠️</div>
        <h2>Something Went Wrong</h2>
        <p>We encountered an unexpected error while processing your request. Please try again or contact support if the problem persists.</p>
        <div class="actions">
            <a href="javascript:history.back()" class="a-ghost">← Go Back</a>
            <a href="${pageContext.request.contextPath}/super-admin/dashboard" class="a-primary">Dashboard</a>
        </div>
    </div>
</body>
</html>
