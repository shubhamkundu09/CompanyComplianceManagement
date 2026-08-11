<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "My Compliances" ); %>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="compliances" />
    </jsp:include>

    <div class="main-content">
        <div style="margin-bottom:24px;">
            <p style="font-size:12px;color:#6366f1;font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                Compliance Management</p>
            <h1 style="font-family:'Syne',sans-serif;font-size:24px;font-weight:700;color:#e2e8f0;">
                My Compliance Categories</h1>
            <p style="font-size:13px;color:#64748b;margin-top:4px;">Click on any category to view and complete your sub-compliances</p>
        </div>

        <div id="loader" style="text-align:center;padding:60px;">
            <div class="spinner" style="margin:0 auto 12px;"></div>
            <div style="color:#64748b;">Loading your compliance categories...</div>
        </div>

        <div id="categoriesGrid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(380px,1fr));gap:20px;"></div>

        <div id="emptyState" style="display:none;" class="card">
            <div class="empty-state" style="padding:60px;">
                <i class="fas fa-folder-open" style="font-size:48px;opacity:0.3;"></i>
                <p style="margin-top:12px;">No compliance categories assigned yet</p>
            </div>
        </div>
    </div>
</div>

<style>
    .category-card {
        background: #111318;
        border: 1px solid #1e2130;
        border-radius: 12px;
        padding: 20px;
        transition: all .25s ease;
        cursor: pointer;
    }
    .category-card:hover {
        border-color: #6366f1;
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0,0,0,.3);
    }
</style>

<script>
    var categories = [];

    async function loadCategories() {
        var data = await api("/api/employee/compliance/my-categories");
        if (data && data.success) {
            categories = data.data || [];
            renderCategories();
            document.getElementById("loader").style.display = "none";
        } else {
            document.getElementById("loader").innerHTML = '<div class="empty-state">Failed to load categories</div>';
        }
    }

    function renderCategories() {
        var grid = document.getElementById("categoriesGrid");
        if (!categories.length) {
            grid.style.display = "none";
            document.getElementById("emptyState").style.display = "block";
            return;
        }
        grid.style.display = "grid";
        document.getElementById("emptyState").style.display = "none";

        var html = '';
        for (var i = 0; i < categories.length; i++) {
            var cat = categories[i];
            var total = cat.totalSubCompliances || 0;
            var completed = cat.completedSubCompliances || 0;
            var pct = total > 0 ? Math.round((completed / total) * 100) : 0;

            var statusClass = cat.overallStatus === "COMPLETED" ? "badge-active" :
                (cat.overallStatus === "OVERDUE" ? "badge-inactive" : "badge-info");

            html += '<div class="category-card" onclick="window.location.href=\'' + contextPath + '/employee/compliance/category/' + cat.companyComplianceId + '\'">' +
                '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:12px;">' +
                '<div><h3 style="font-size:16px;font-weight:700;margin-bottom:4px;">' + escapeHtml(cat.templateName) + '</h3>' +
                '<span class="badge badge-info" style="font-size:10px;">' + total + ' sub-compliances</span></div>' +
                '<span class="badge ' + statusClass + '">' + (cat.overallStatus === "COMPLETED" ? "Completed" : cat.overallStatus === "OVERDUE" ? "Overdue" : "In Progress") + '</span>' +
                '</div>' +
                '<div style="margin:12px 0;"><div class="progress-bar" style="height:6px;"><div class="progress-fill" style="width:' + pct + '%;background:#6366f1;"></div></div>' +
                '<div style="display:flex;justify-content:space-between;margin-top:6px;font-size:11px;">' +
                '<span>' + completed + '/' + total + ' completed</span><span>' + pct + '%</span></div></div>' +
                '<div style="display:flex;justify-content:space-between;font-size:11px;padding-top:8px;border-top:1px solid #1e2130;">' +
                (cat.nextDueDate ? '<span><i class="fas fa-calendar-alt"></i> Next Due: ' + formatDate(cat.nextDueDate) + '</span>' : '<span></span>') +
                '<span><i class="fas fa-arrow-right"></i> View Details</span></div></div>';
        }
        grid.innerHTML = html;
    }

    function formatDate(d) {
        if (!d) return '—';
        var date = new Date(d);
        return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getFullYear();
    }

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }

    loadCategories();
</script>

<%@ include file="../fragments/footer.jsp" %>