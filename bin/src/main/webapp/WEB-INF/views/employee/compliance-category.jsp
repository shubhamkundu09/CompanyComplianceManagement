<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Object parentIdObj=request.getAttribute("parentId"); String parentId=parentIdObj !=null ?
    String.valueOf(parentIdObj) : null; if (parentId==null || parentId.trim().isEmpty()) { String
    uri=request.getRequestURI(); String[] parts=uri.split("/"); if (parts.length> 0) {
    String last = parts[parts.length - 1];
    try {
    Long.parseLong(last);
    parentId = last;
    } catch (NumberFormatException e) {}
    }
    }

    if (parentId == null || parentId.trim().isEmpty() || "null".equals(parentId)) {
    response.sendRedirect(request.getContextPath() + "/employee/compliances");
    return;
    }

    pageContext.setAttribute("parentId", parentId);
    pageContext.setAttribute("pageTitle", "Sub-Compliances");
%>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="compliances" />
    </jsp:include>

    <div class="main-content">
        <div style="margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;">
            <a href="${pageContext.request.contextPath}/employee/compliances" style="color:#6366f1;text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
                <i class="fas fa-arrow-left" style="font-size:12px;"></i> Back to Categories
            </a>
            <button onclick="syncCompliances()" class="btn btn-ghost" style="padding:6px 12px;">
                <i class="fas fa-sync-alt"></i> Sync Now
            </button>
        </div>

        <div id="loader" style="text-align:center;padding:60px;">
            <div class="spinner" style="margin:0 auto 12px;"></div>
            <div style="color:#64748b;">Loading sub-compliances...</div>
        </div>

        <div id="pageContent" style="display:none;">
            <div class="card" style="padding:20px;margin-bottom:24px;">
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:48px;height:48px;background:rgba(99,102,241,0.15);border-radius:12px;display:flex;align-items:center;justify-content:center;">
                        <i class="fas fa-folder-open" style="font-size:24px;color:#6366f1;"></i>
                    </div>
                    <div>
                        <h1 id="categoryName" style="font-family:'Syne',sans-serif;font-size:24px;font-weight:700;margin:0;">
                            Sub-Compliances</h1>
                        <p id="categoryDesc" style="color:#64748b;margin-top:4px;">Click on any sub-compliance to view details and complete</p>
                    </div>
                </div>
            </div>

            <div class="grid-4" style="margin-bottom:24px;">
                <div class="card stat-card">
                    <div class="stat-value" id="totalCount">0</div>
                    <div class="stat-label">Total</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-value" id="completedCount" style="color:#22c55e;">0</div>
                    <div class="stat-label">Completed</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-value" id="pendingCount" style="color:#f59e0b;">0</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="card stat-card">
                    <div class="stat-value" id="overdueCount" style="color:#ef4444;">0</div>
                    <div class="stat-label">Overdue</div>
                </div>
            </div>

            <div id="subCompliancesList"></div>
        </div>
    </div>
</div>

<style>
    .sub-card {
        background: #111318;
        border: 1px solid #1e2130;
        border-radius: 12px;
        margin-bottom: 16px;
        padding: 18px;
        transition: all 0.2s;
        cursor: pointer;
    }
    .sub-card:hover { border-color: #6366f1; transform: translateX(4px); }
    .sub-card.completed { background: rgba(34,197,94,0.03); border-left: 3px solid #22c55e; }
    .sub-card.overdue { border-left: 3px solid #ef4444; }
    .status-dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; margin-right: 8px; }
    .status-completed { background: #22c55e; box-shadow: 0 0 6px #22c55e; }
    .status-pending { background: #f59e0b; }
    .status-overdue { background: #ef4444; animation: pulse 1s infinite; }
    .status-progress { background: #6366f1; }
    .frequency-badge { background: rgba(99,102,241,0.12); padding: 2px 8px; border-radius: 12px; font-size: 10px; color: #818cf8; }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
</style>

<script>
    var PARENT_ID = "${parentId}";
    var subCompliances = [];

    async function loadSubCompliances() {
        document.getElementById("loader").style.display = "block";
        document.getElementById("pageContent").style.display = "none";

        var data = await api("/api/employee/compliance/category/" + PARENT_ID + "/sub-compliances");

        if (data && data.success) {
            subCompliances = data.data || [];
            console.log("Loaded sub-compliances:", subCompliances);
            renderStats();
            renderSubCompliances();
            document.getElementById("loader").style.display = "none";
            document.getElementById("pageContent").style.display = "block";
        } else {
            document.getElementById("loader").innerHTML = '<div class="empty-state">Failed to load sub-compliances</div>';
            toast("Failed to load sub-compliances", "error");
        }
    }

    function renderStats() {
        var total = subCompliances.length;
        var completed = subCompliances.filter(function (s) { return s.status === "COMPLETED"; }).length;
        var pending = subCompliances.filter(function (s) { return s.status === "PENDING" || s.status === "IN_PROGRESS"; }).length;
        var overdue = subCompliances.filter(function (s) { return s.isOverdue === true && s.status !== "COMPLETED"; }).length;

        document.getElementById("totalCount").textContent = total;
        document.getElementById("completedCount").textContent = completed;
        document.getElementById("pendingCount").textContent = pending;
        document.getElementById("overdueCount").textContent = overdue;
    }

    function renderSubCompliances() {
        var container = document.getElementById("subCompliancesList");

        if (!subCompliances.length) {
            container.innerHTML = '<div class="card empty-state" style="padding:60px;">' +
                '<i class="fas fa-folder-open" style="font-size:48px;opacity:0.3;"></i>' +
                '<p style="margin-top:12px;">No sub-compliances found</p></div>';
            return;
        }

        var html = '';
        for (var i = 0; i < subCompliances.length; i++) {
            var sub = subCompliances[i];
            var isCompleted = sub.status === "COMPLETED";
            var isOverdue = sub.isOverdue === true && !isCompleted;
            var isInProgress = sub.status === "IN_PROGRESS" && !isCompleted;

            var cardClass = 'sub-card';
            if (isCompleted) cardClass += ' completed';
            if (isOverdue) cardClass += ' overdue';

            var statusDotClass = isCompleted ? "status-completed" :
                (isOverdue ? "status-overdue" :
                (isInProgress ? "status-progress" : "status-pending"));
            var statusText = isCompleted ? "Completed" :
                (isOverdue ? "Overdue" :
                (isInProgress ? "In Progress" : "Pending"));

            var daysRemaining = sub.daysRemaining;
            var dueDate = sub.dueDate;
            var daysText = "";
            var dueDateDisplay = "No due date set";

            if (dueDate) {
                dueDateDisplay = formatDate(dueDate);
                if (daysRemaining !== null && daysRemaining !== undefined && !isCompleted) {
                    daysText = daysRemaining >= 0 ? daysRemaining + " days left" : "Overdue by " + Math.abs(daysRemaining) + " days";
                }
            }

            var frequencyLabel = getFrequencyLabel(sub.frequency);
            var completedByHtml = "";
            if (isCompleted && sub.completedBy) {
                completedByHtml = '<div style="font-size:11px;color:#22c55e;margin-top:6px;">' +
                    '<i class="fas fa-user-check"></i> Completed by: ' + escapeHtml(sub.completedBy) + '</div>';
            }

            var canComplete = !isCompleted;

            html += '<div class="' + cardClass + '" onclick="viewSubCompliance(' + sub.id + ')">' +
                '<div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:10px;">' +
                '<div style="flex:1;">' +
                '<div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:8px;">' +
                '<span class="status-dot ' + statusDotClass + '"></span>' +
                '<h3 style="font-size:16px;font-weight:600;margin:0;">' + escapeHtml(sub.name) + '</h3>' +
                (frequencyLabel ? '<span class="frequency-badge"><i class="fas fa-calendar-alt"></i> ' + frequencyLabel + '</span>' : '') +
                '</div>' +
                '<div style="font-size:13px;color:#94a3b8;margin-bottom:8px;">' + (escapeHtml(sub.description) || "No description") + '</div>' +
                '<div style="display:flex;gap:16px;flex-wrap:wrap;font-size:12px;">' +
                '<div><i class="fas fa-calendar-alt"></i> Due: ' + dueDateDisplay + '</div>' +
                (daysText ? '<div><i class="fas fa-hourglass-half"></i> ' + daysText + '</div>' : '') +
                '</div>' +
                completedByHtml +
                '</div>' +
                '<div>' +
                '<span class="badge ' + (isCompleted ? 'badge-active' : (isOverdue ? 'badge-inactive' : (isInProgress ? 'badge-info' : 'badge-pending'))) + '">' + statusText + '</span>' +
                '<i class="fas fa-chevron-right" style="margin-left:12px;color:#64748b;"></i>' +
                '</div>' +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    function viewSubCompliance(assignmentId) {
        window.location.href = contextPath + '/employee/compliance/sub/' + assignmentId;
    }

    async function syncCompliances() {
        toast("Syncing sub-compliances...", "info");
        try {
            var data = await api("/api/employee/compliance/sync-category/" + PARENT_ID, { method: "POST" });
            if (data && data.success) {
                toast("Sub-compliances synced successfully!", "success");
                setTimeout(function () { loadSubCompliances(); }, 1000);
            } else {
                toast(data?.error || "Sync failed", "error");
            }
        } catch (error) {
            console.error("Sync error:", error);
            toast("Sync failed", "error");
        }
    }

    function getFrequencyLabel(freq) {
        var map = { 'MONTHLY': 'Monthly', 'QUARTERLY': 'Quarterly', 'HALF_YEARLY': 'Half Yearly', 'YEARLY': 'Yearly', 'ONE_TIME': 'One Time' };
        return map[freq] || '';
    }

    function formatDate(d) {
        if (!d) return '—';
        var date = new Date(d);
        return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getFullYear();
    }

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }

    loadSubCompliances();
</script>

<%@ include file="../fragments/footer.jsp" %>