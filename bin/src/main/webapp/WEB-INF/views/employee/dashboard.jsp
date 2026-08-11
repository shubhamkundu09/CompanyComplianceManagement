<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "Employee Dashboard" ); %>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <div class="main-content">
        <!-- Welcome Section -->
        <div style="margin-bottom:28px;display:flex;justify-content:space-between;align-items:flex-end;flex-wrap:wrap;">
            <div>
                <p style="font-size:12px;color:#6366f1;font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                    Welcome back,</p>
                <h1 style="font-family:'Syne',sans-serif;font-size:28px;font-weight:700;color:#e2e8f0;"
                    id="welcomeName">Employee</h1>
                <p style="font-size:13px;color:#64748b;margin-top:6px;">Here's your compliance summary and upcoming tasks</p>
            </div>
            <div style="text-align:right;">
                <div id="currentDateTime" style="font-size:14px;font-weight:600;color:#818cf8;"></div>
                <div style="font-size:11px;color:#64748b;">Last login: <span id="lastLogin">—</span></div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid-4" style="margin-bottom:24px;">
            <div class="card stat-card">
                <div class="stat-icon" style="background:rgba(99,102,241,.12);color:#818cf8;">
                    <i class="fas fa-folder-open"></i>
                </div>
                <div class="stat-value" id="totalCategories">0</div>
                <div class="stat-label">Categories</div>
                <div class="stat-bg"><i class="fas fa-folder-open"></i></div>
            </div>
            <div class="card stat-card">
                <div class="stat-icon" style="background:rgba(99,102,241,.12);color:#818cf8;">
                    <i class="fas fa-tasks"></i>
                </div>
                <div class="stat-value" id="totalSubCompliances">0</div>
                <div class="stat-label">Sub-Compliances</div>
                <div class="stat-bg"><i class="fas fa-tasks"></i></div>
            </div>
            <div class="card stat-card">
                <div class="stat-icon" style="background:rgba(34,197,94,.12);color:#22c55e;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-value" id="completedCount">0</div>
                <div class="stat-label">Completed</div>
                <div class="stat-bg"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="card stat-card">
                <div class="stat-icon" style="background:rgba(239,68,68,.12);color:#ef4444;">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-value" id="overdueCount">0</div>
                <div class="stat-label">Overdue</div>
                <div class="stat-bg"><i class="fas fa-exclamation-triangle"></i></div>
            </div>
        </div>

        <!-- Performance Row -->
        <div class="grid-2" style="gap:20px;margin-bottom:24px;">
            <div class="card" style="padding:20px;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                    <div>
                        <h3 style="font-size:14px;font-weight:700;">Overall Completion Rate</h3>
                        <p style="font-size:11px;color:#64748b;">Progress across all compliances</p>
                    </div>
                    <div id="completionRate" style="font-size:32px;font-weight:700;color:#22c55e;">0%</div>
                </div>
                <div class="progress-bar" style="height:10px;border-radius:5px;">
                    <div id="completionBar" class="progress-fill" style="width:0%;background:#22c55e;"></div>
                </div>
                <div style="display:flex;justify-content:space-between;margin-top:8px;">
                    <span style="font-size:12px;"><span id="completedSubs">0</span> completed</span>
                    <span style="font-size:12px;"><span id="pendingSubs">0</span> pending</span>
                </div>
            </div>

            <div class="card" style="padding:20px;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                    <h3 style="font-size:14px;font-weight:700;"><i class="fas fa-star" style="color:#f59e0b;"></i> Achievement Badges</h3>
                    <button onclick="showAchievements()" style="font-size:11px;color:#6366f1;background:none;border:none;cursor:pointer;">View All</button>
                </div>
                <div id="achievements" style="display:flex;gap:15px;flex-wrap:wrap;"></div>
            </div>
        </div>

        <!-- Upcoming Deadlines -->
        <div class="card" style="margin-bottom:24px;">
            <div class="section-header" style="padding:16px 20px 0 20px;">
                <div class="section-title">
                    <i class="fas fa-calendar-alt" style="margin-right:8px;color:#6366f1;"></i>
                    Upcoming Deadlines
                </div>
                <a href="${pageContext.request.contextPath}/employee/compliance-calendar" style="font-size:11px;color:#6366f1;">Calendar →</a>
            </div>
            <div id="upcomingDeadlines" style="padding:0 20px 20px 20px;">
                <div style="text-align:center;padding:30px;">
                    <div class="spinner" style="margin:0 auto;"></div>
                </div>
            </div>
        </div>

        <!-- My Compliance Categories -->
        <div class="card">
            <div class="section-header" style="padding:18px 20px 0 20px;">
                <div class="section-title">
                    <i class="fas fa-folder-open" style="margin-right:8px;color:#6366f1;"></i> My Compliance Categories
                </div>
                <a href="${pageContext.request.contextPath}/employee/compliances" style="font-size:12px;color:#6366f1;">
                    View All <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div id="categoriesGrid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(350px,1fr));gap:16px;padding:20px;">
                <div style="text-align:center;padding:30px;grid-column:1/-1;">
                    <div class="spinner" style="margin:0 auto;"></div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div style="margin-top:20px;">
            <div class="card">
                <div class="section-header" style="padding:18px 20px 0 20px;">
                    <div class="section-title">
                        <i class="fas fa-bolt" style="margin-right:8px;color:#6366f1;"></i> Quick Actions
                    </div>
                </div>
                <div style="padding:0 20px 20px 20px;">
                    <div style="display:flex;gap:12px;flex-wrap:wrap;">
                        <button onclick="window.location.href='${pageContext.request.contextPath}/employee/compliances'" class="btn btn-primary">
                            <i class="fas fa-tasks"></i> View All Compliances
                        </button>
                        <button onclick="window.location.href='${pageContext.request.contextPath}/employee/compliance-calendar'" class="btn btn-ghost">
                            <i class="fas fa-calendar-alt"></i> Calendar View
                        </button>
                        <button onclick="window.location.href='${pageContext.request.contextPath}/employee/profile'" class="btn btn-ghost">
                            <i class="fas fa-user"></i> My Profile
                        </button>
                        <a href="${pageContext.request.contextPath}/change-password" class="btn btn-ghost">
                            <i class="fas fa-key"></i> Change Password
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .category-card {
        background: #111318;
        border: 1px solid #1e2130;
        border-radius: 12px;
        padding: 16px;
        transition: all .25s ease;
        cursor: pointer;
    }
    .category-card:hover {
        border-color: #6366f1;
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0,0,0,.3);
    }
    .deadline-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #1e2130;
    }
    .deadline-item:last-child { border-bottom: none; }
    .deadline-urgent { color: #ef4444; font-weight: 600; }
    .deadline-warning { color: #f59e0b; }
    .deadline-normal { color: #22c55e; }
    .achievement-icon { transition: all .3s; }
    .achievement.earned { opacity: 1; }
    .achievement.earned .achievement-icon {
        background: rgba(34,197,94,.2) !important;
        box-shadow: 0 0 10px rgba(34,197,94,.3);
    }
</style>

<script>
    var allSubCompliances = [];
    var groupedCategories = [];

    async function loadDashboard() {
        try {
            var profileRes = await api("/api/employee/profile");
            if (profileRes && profileRes.success) {
                var emp = profileRes.data;
                document.getElementById("welcomeName").textContent = (emp.firstName || "") + " " + (emp.lastName || "");
                document.getElementById("lastLogin").textContent = formatDateTime(emp.lastLoginAt) || "First login";
            }
            updateDateTime();
            await loadAllCompliances();
            await loadCategories();
            await loadUpcomingDeadlines();
            await loadAchievements();
        } catch (error) {
            console.error("Error loading dashboard:", error);
            toast("Failed to load dashboard data", "error");
        }
    }

    function updateDateTime() {
        var now = new Date();
        document.getElementById("currentDateTime").innerHTML = now.toLocaleDateString('en-IN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
    }

    async function loadAllCompliances() {
        var data = await api("/api/employee/compliance/my?page=0&size=100");
        if (data && data.success) {
            allSubCompliances = data.data.content || [];
            updateStats();
        }
    }

    function updateStats() {
        var totalSubs = allSubCompliances.length;
        var completed = allSubCompliances.filter(function (s) { return s.status === "COMPLETED"; }).length;
        var overdue = allSubCompliances.filter(function (s) { return s.overdue && s.status !== "COMPLETED"; }).length;
        var pending = totalSubs - completed;
        var completionRate = totalSubs > 0 ? Math.round((completed / totalSubs) * 100) : 0;

        document.getElementById("totalSubCompliances").textContent = totalSubs;
        document.getElementById("completedCount").textContent = completed;
        document.getElementById("overdueCount").textContent = overdue;
        document.getElementById("completedSubs").textContent = completed;
        document.getElementById("pendingSubs").textContent = pending;
        document.getElementById("completionRate").textContent = completionRate + "%";

        var barColor = completionRate >= 70 ? "#22c55e" : (completionRate >= 30 ? "#f59e0b" : "#ef4444");
        document.getElementById("completionBar").style.width = completionRate + "%";
        document.getElementById("completionBar").style.background = barColor;
        document.getElementById("totalCategories").textContent = groupedCategories.length;
    }

    async function loadCategories() {
        var data = await api("/api/employee/compliance/my-categories");
        if (data && data.success) {
            groupedCategories = data.data || [];
            renderCategories();
            updateStats();
        }
    }

    function renderCategories() {
        var grid = document.getElementById("categoriesGrid");
        if (!groupedCategories.length) {
            grid.innerHTML = '<div style="text-align:center;padding:40px;grid-column:1/-1;">' +
                '<i class="fas fa-folder-open" style="font-size:48px;opacity:0.3;"></i>' +
                '<p style="margin-top:12px;">No compliance categories assigned yet</p></div>';
            return;
        }
        var html = '';
        for (var i = 0; i < Math.min(groupedCategories.length, 6); i++) {
            var cat = groupedCategories[i];
            var total = cat.totalSubCompliances || 0;
            var completed = cat.completedSubCompliances || 0;
            var pct = total > 0 ? Math.round((completed / total) * 100) : 0;
            var statusClass = cat.overallStatus === "COMPLETED" ? "badge-active" :
                (cat.overallStatus === "OVERDUE" ? "badge-inactive" : "badge-info");

            html += '<div class="category-card" onclick="window.location.href=\'' + contextPath + '/employee/compliance/category/' + cat.companyComplianceId + '\'">' +
                '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:12px;">' +
                '<div><h4 style="font-size:15px;font-weight:700;margin-bottom:4px;">' + escapeHtml(cat.templateName) + '</h4>' +
                '<span class="badge badge-info" style="font-size:10px;">' + (cat.totalSubCompliances || 0) + ' sub-compliances</span></div>' +
                '<span class="badge ' + statusClass + '">' + (cat.overallStatus === "COMPLETED" ? "Completed" : cat.overallStatus === "OVERDUE" ? "Overdue" : "In Progress") + '</span>' +
                '</div>' +
                '<div style="margin:12px 0;"><div class="progress-bar" style="height:6px;"><div class="progress-fill" style="width:' + pct + '%;background:#6366f1;"></div></div>' +
                '<div style="display:flex;justify-content:space-between;margin-top:6px;font-size:11px;">' +
                '<span>' + completed + '/' + total + ' completed</span><span>' + pct + '%</span></div></div>' +
                '<div style="display:flex;justify-content:space-between;font-size:11px;padding-top:8px;border-top:1px solid #1e2130;">' +
                (cat.nextDueDate ? '<span><i class="fas fa-calendar-alt"></i> Next Due: ' + formatDate(cat.nextDueDate) + '</span>' : '<span></span>') +
                '<span><i class="fas fa-arrow-right"></i></span></div></div>';
        }
        if (groupedCategories.length > 6) {
            html += '<div style="text-align:center;padding:20px;grid-column:1/-1;">' +
                '<a href="' + contextPath + '/employee/compliances" class="btn btn-ghost">View all ' + groupedCategories.length + ' categories →</a></div>';
        }
        grid.innerHTML = html;
    }

    async function loadUpcomingDeadlines() {
        var data = await api("/api/employee/compliance/my?page=0&size=20");
        var container = document.getElementById("upcomingDeadlines");
        if (data && data.success) {
            var allSubs = data.data.content || [];
            var today = new Date();
            var upcoming = allSubs.filter(function (s) { return s.status !== "COMPLETED" && s.dueDate; })
                .sort(function (a, b) { return new Date(a.dueDate) - new Date(b.dueDate); }).slice(0, 5);
            if (!upcoming.length) {
                container.innerHTML = '<div style="text-align:center;padding:30px;">' +
                    '<i class="fas fa-check-circle" style="font-size:36px;color:#22c55e;"></i>' +
                    '<p style="margin-top:8px;">No pending deadlines! 🎉</p></div>';
                return;
            }
            var html = '';
            for (var i = 0; i < upcoming.length; i++) {
                var s = upcoming[i];
                var dueDate = new Date(s.dueDate);
                var diffDays = Math.ceil((dueDate - today) / (1000 * 60 * 60 * 24));
                var dateClass = diffDays < 0 ? "deadline-urgent" : (diffDays <= 7 ? "deadline-warning" : "deadline-normal");
                var daysText = diffDays < 0 ? "Overdue" : diffDays + " days left";

                html += '<div class="deadline-item" onclick="window.location.href=\'' + contextPath + '/employee/compliance/category/' + s.companyComplianceId + '\'">' +
                    '<div><div style="font-weight:600;font-size:13px;">' + escapeHtml(s.complianceName) + '</div>' +
                    '<div style="font-size:11px;color:#64748b;">' + escapeHtml(s.category) + '</div></div>' +
                    '<div class="text-right"><div class="' + dateClass + '" style="font-size:12px;font-weight:500;">' + daysText + '</div>' +
                    '<div style="font-size:10px;color:#64748b;">' + formatDate(s.dueDate) + '</div></div></div>';
            }
            container.innerHTML = html;
        } else {
            container.innerHTML = '<div style="text-align:center;padding:30px;">Unable to load deadlines</div>';
        }
    }

    async function loadAchievements() {
        var data = await api("/api/employee/compliance/my?page=0&size=100");
        var container = document.getElementById("achievements");
        if (data && data.success) {
            var allSubs = data.data.content || [];
            var totalCompleted = allSubs.filter(function (s) { return s.status === "COMPLETED"; }).length;
            var hasFirstComplete = totalCompleted > 0;

            var html = '';
            html += '<div class="achievement ' + (hasFirstComplete ? 'earned' : '') + '" style="text-align:center;cursor:pointer;" onclick="toast(\'' +
                (hasFirstComplete ? '✓ You earned "First Completion" badge!' : 'Complete your first compliance to earn this badge') + '\', \'info\')">' +
                '<div class="achievement-icon" style="width:50px;height:50px;background:' + (hasFirstComplete ? 'rgba(34,197,94,.2)' : 'rgba(99,102,241,.1)') + ';border-radius:50%;display:flex;align-items:center;justify-content:center;">' +
                '<i class="fas fa-check-circle" style="font-size:24px;color:' + (hasFirstComplete ? '#22c55e' : '#6366f1') + ';"></i></div>' +
                '<div style="font-size:10px;margin-top:4px;">First Completion</div></div>';

            var hasFiveComplete = totalCompleted >= 5;
            html += '<div class="achievement ' + (hasFiveComplete ? 'earned' : '') + '" style="text-align:center;cursor:pointer;" onclick="toast(\'' +
                (hasFiveComplete ? '✓ You earned "5 Completions" badge!' : 'Complete 5 compliances to earn this badge (' + totalCompleted + '/5)') + '\', \'info\')">' +
                '<div class="achievement-icon" style="width:50px;height:50px;background:' + (hasFiveComplete ? 'rgba(34,197,94,.2)' : 'rgba(99,102,241,.1)') + ';border-radius:50%;display:flex;align-items:center;justify-content:center;">' +
                '<i class="fas fa-star" style="font-size:24px;color:' + (hasFiveComplete ? '#f59e0b' : '#6366f1') + ';"></i></div>' +
                '<div style="font-size:10px;margin-top:4px;">5 Completions</div></div>';

            var pct = allSubs.length > 0 ? (totalCompleted / allSubs.length) * 100 : 0;
            var hasPerfectWeek = pct >= 80;
            html += '<div class="achievement ' + (hasPerfectWeek ? 'earned' : '') + '" style="text-align:center;cursor:pointer;" onclick="toast(\'' +
                (hasPerfectWeek ? '✓ You earned "Perfect Week" badge!' : 'Complete 80% of your compliances to earn this badge (' + Math.round(pct) + '%)') + '\', \'info\')">' +
                '<div class="achievement-icon" style="width:50px;height:50px;background:' + (hasPerfectWeek ? 'rgba(34,197,94,.2)' : 'rgba(99,102,241,.1)') + ';border-radius:50%;display:flex;align-items:center;justify-content:center;">' +
                '<i class="fas fa-trophy" style="font-size:24px;color:' + (hasPerfectWeek ? '#f59e0b' : '#6366f1') + ';"></i></div>' +
                '<div style="font-size:10px;margin-top:4px;">Perfect Week</div></div>';

            container.innerHTML = html;
        }
    }

    function showAchievements() {
        toast("🎖️ Achievement badges track your progress! Keep completing compliances to earn more badges.", "info", 4000);
    }

    function formatDate(d) {
        if (!d) return '—';
        var date = new Date(d);
        return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getFullYear();
    }

    function formatDateTime(d) {
        if (!d) return '—';
        var date = new Date(d);
        return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
            date.getFullYear() + ' ' + date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0');
    }

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }
    function refreshDashboard() { loadDashboard(); toast("Dashboard refreshed", "info"); }

    setInterval(updateDateTime, 60000);
    loadDashboard();
</script>

<%@ include file="../fragments/footer.jsp" %>