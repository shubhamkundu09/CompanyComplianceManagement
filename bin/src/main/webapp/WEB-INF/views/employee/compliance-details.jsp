<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Long complianceIdObj=(Long) request.getAttribute("complianceId"); String complianceId=complianceIdObj !=null
            ? String.valueOf(complianceIdObj) : null; if (complianceId==null || complianceId.trim().isEmpty()) { String
            uri=request.getRequestURI(); String[] parts=uri.split("/"); if (parts.length> 0) {
            String last = parts[parts.length - 1];
            try {
            Long.parseLong(last);
            complianceId = last;
            } catch (NumberFormatException e) {}
            }
            }

            if (complianceId == null || complianceId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employee/compliances");
            return;
            }

            pageContext.setAttribute("complianceId", complianceId);
            pageContext.setAttribute("pageTitle", "Compliance Details");
%>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="compliances" />
    </jsp:include>

    <div class="main-content">
        <div style="margin-bottom:20px;">
            <a href="${pageContext.request.contextPath}/employee/compliances" style="color:#6366f1;text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
                <i class="fas fa-arrow-left" style="font-size:12px;"></i> Back to My Compliances
            </a>
        </div>

        <div id="loader" style="text-align:center;padding:80px;">
            <div class="spinner" style="margin:0 auto 12px;"></div>
            <div style="color:#64748b;">Loading compliance details...</div>
        </div>

        <div id="pageContent" style="display:none;">
            <div id="periodInfoBanner" class="card" style="margin-bottom:20px;padding:12px 16px;background:linear-gradient(135deg,rgba(99,102,241,.08),rgba(99,102,241,.03));border-left:3px solid #6366f1;display:none;">
                <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
                    <i class="fas fa-calendar-alt" style="color:#6366f1;font-size:18px;"></i>
                    <div>
                        <div style="font-size:11px;color:#64748b;">Current Period</div>
                        <div style="font-size:14px;font-weight:600;" id="periodText">—</div>
                    </div>
                    <div id="recurringInfo" style="margin-left:auto;font-size:11px;color:#64748b;"></div>
                </div>
            </div>

            <div class="card" style="padding:24px;margin-bottom:20px;">
                <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;">
                    <div>
                        <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;flex-wrap:wrap;">
                            <div style="width:48px;height:48px;background:rgba(99,102,241,0.15);border-radius:12px;display:flex;align-items:center;justify-content:center;">
                                <i class="fas fa-folder-open" style="font-size:24px;color:#6366f1;"></i>
                            </div>
                            <div>
                                <h1 id="complianceName" style="font-family:'Syne',sans-serif;font-size:24px;margin:0;">—</h1>
                                <div style="margin-top:6px;">
                                    <span id="categoryBadge"></span>
                                    <span id="frequencyBadge" style="margin-left:8px;"></span>
                                </div>
                            </div>
                        </div>
                        <p id="description" style="color:#94a3b8;font-size:14px;line-height:1.6;max-width:600px;">—</p>
                    </div>
                    <div>
                        <div id="statusBadge" style="margin-bottom:8px;"></div>
                        <div id="canCompleteInfo" style="font-size:11px;color:#64748b;"></div>
                    </div>
                </div>
            </div>

            <div class="grid-2" style="gap:20px;">
                <div>
                    <div class="card" style="padding:20px;margin-bottom:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-info-circle"></i> Compliance Information
                        </h3>
                        <div id="infoTable" style="display:flex;flex-direction:column;gap:12px;"></div>
                    </div>

                    <div class="card" style="padding:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-list-ol"></i> Instructions
                        </h3>
                        <div id="instructions" style="color:#94a3b8;font-size:14px;line-height:1.7;white-space:pre-line;"></div>
                        <div id="externalLinkDiv" style="margin-top:16px;display:none;">
                            <a href="#" id="externalLink" target="_blank" class="btn btn-primary" style="width:100%;justify-content:center;">
                                <i class="fas fa-external-link-alt"></i> Go to External Portal
                            </a>
                        </div>
                    </div>
                </div>

                <div>
                    <div id="submissionFormDiv" class="card" style="padding:20px;margin-bottom:20px;display:none;">
                        <h3 style="font-size:14px;font-weight:700;color:#22c55e;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-upload"></i> Mark as Completed
                        </h3>
                        <div id="completionWarning" style="background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;padding:12px;margin-bottom:16px;border-radius:6px;">
                            <i class="fas fa-info-circle" style="color:#f59e0b;"></i>
                            <span style="font-size:12px;">Once you mark this as completed, other employees will see it as completed and cannot modify it.</span>
                        </div>
                        <div id="nextPeriodInfo" style="background:rgba(34,197,94,0.1);border-left:3px solid #22c55e;padding:12px;margin-bottom:16px;border-radius:6px;display:none;">
                            <i class="fas fa-calendar-check" style="color:#22c55e;"></i>
                            <span style="font-size:12px;" id="nextPeriodText"></span>
                        </div>
                        <form id="completionForm" onsubmit="return false;">
                            <div style="margin-bottom:16px;">
                                <label class="form-label">Submission Reference Number</label>
                                <input type="text" id="submissionReference" class="form-input" placeholder="e.g., ARN number, Receipt number, Application ID">
                            </div>
                            <div style="margin-bottom:16px;">
                                <label class="form-label">Upload Document (Optional)</label>
                                <input type="file" id="documentFile" class="form-input" accept=".pdf,.jpg,.png,.doc,.docx">
                                <div style="font-size:11px;color:#64748b;margin-top:4px;">Max file size: 10MB. Supported: PDF, JPG, PNG, DOC, DOCX</div>
                            </div>
                            <button type="submit" id="submitBtn" class="btn btn-primary" style="width:100%;">
                                <i class="fas fa-check-circle"></i> Mark as Completed
                            </button>
                        </form>
                    </div>

                    <div id="completedInfoDiv" class="card" style="padding:20px;margin-bottom:20px;display:none;">
                        <h3 style="font-size:14px;font-weight:700;color:#22c55e;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-check-circle"></i> Period Completed
                        </h3>
                        <div id="completedInfo"></div>
                        <div id="nextPeriodReady" style="margin-top:12px;padding:10px;background:rgba(99,102,241,0.1);border-radius:6px;display:none;">
                            <i class="fas fa-calendar-week"></i> Next period is ready for submission.
                        </div>
                    </div>

                    <div class="card" style="padding:20px;margin-bottom:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-file-alt"></i> Documents
                        </h3>
                        <div id="documentsList" style="max-height:200px;overflow-y:auto;">
                            <div class="empty-state" style="padding:20px;">No documents uploaded</div>
                        </div>
                    </div>

                    <div class="card" style="padding:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                            <i class="fas fa-history"></i> Activity History
                        </h3>
                        <div id="historyList" style="max-height:300px;overflow-y:auto;">
                            <div class="empty-state" style="padding:20px;">No history available</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #1e2130; }
    .info-label { font-size: 12px; color: #64748b; }
    .info-value { font-size: 13px; font-weight: 500; text-align: right; }
    .history-item { padding: 10px; border-left: 2px solid #6366f1; background: #1e2333; border-radius: 6px; margin-bottom: 8px; }
    .doc-item { display: flex; justify-content: space-between; align-items: center; padding: 8px; background: #1e2333; border-radius: 6px; margin-bottom: 6px; }
    .period-badge { background: rgba(99,102,241,0.12); color: #818cf8; padding: 4px 12px; border-radius: 20px; font-size: 11px; display: inline-block; }
    .recurring-badge { background: rgba(34,197,94,0.12); color: #22c55e; }
    .due-danger { color: #ef4444; font-weight: 600; }
</style>

<script>
    var COMPLIANCE_ID = "${complianceId}";
    var complianceData = null;

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }
    function formatDate(d) { if (!d) return '—'; var date = new Date(d); return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getFullYear(); }
    function formatDateTime(d) { if (!d) return '—'; var date = new Date(d); return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getFullYear() + ' ' + date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0'); }
    function getStatusClass(status) { var map = { 'PENDING': 'badge-pending', 'IN_PROGRESS': 'badge-info', 'COMPLETED': 'badge-active', 'OVERDUE': 'badge-inactive' }; return map[status] || 'badge-info'; }
    function getStatusLabel(status) { var map = { 'PENDING': 'Pending', 'IN_PROGRESS': 'In Progress', 'COMPLETED': 'Completed', 'OVERDUE': 'Overdue' }; return map[status] || status; }
    function getFrequencyLabel(freq) { var map = { 'MONTHLY': 'Monthly', 'QUARTERLY': 'Quarterly', 'HALF_YEARLY': 'Half Yearly', 'YEARLY': 'Yearly', 'ONE_TIME': 'One Time' }; return map[freq] || freq || '—'; }

    async function loadCompliance() {
        var data = await api("/api/employee/compliance/my?page=0&size=100");
        if (data && data.success) {
            var content = data.data.content || [];
            complianceData = content.find(function (c) { return c.id == COMPLIANCE_ID; });

            if (complianceData) {
                renderCompliance();
                await loadDocuments();
                await loadHistory();
                document.getElementById("loader").style.display = "none";
                document.getElementById("pageContent").style.display = "block";
            } else {
                toast("Compliance not found", "error");
                setTimeout(function () { window.location.href = contextPath + "/employee/compliances"; }, 1500);
            }
        } else {
            toast("Failed to load compliance", "error");
        }
    }

    function renderCompliance() {
        var c = complianceData;
        var isRecurring = c.frequency && c.frequency !== "ONE_TIME";
        var statusClass = getStatusClass(c.status);
        var statusLabel = getStatusLabel(c.status);

        document.getElementById("complianceName").textContent = c.complianceName;
        document.getElementById("categoryBadge").innerHTML = '<span class="badge badge-info">' + escapeHtml(c.category) + '</span>';
        document.getElementById("frequencyBadge").innerHTML = '<span class="period-badge ' + (isRecurring ? 'recurring-badge' : '') + '">' +
            '<i class="fas fa-' + (isRecurring ? 'sync-alt' : 'calendar') + '"></i> ' + getFrequencyLabel(c.frequency) + '</span>';
        document.getElementById("description").textContent = c.description || "No description provided.";
        document.getElementById("statusBadge").innerHTML = '<span class="badge ' + statusClass + '" style="font-size:14px;padding:6px 14px;">' +
            '<i class="fas ' + (c.status === 'COMPLETED' ? 'fa-check-circle' : (c.status === 'OVERDUE' ? 'fa-exclamation-triangle' : 'fa-clock')) + '"></i> ' +
            statusLabel + '</span>';

        if (c.periodInfo || isRecurring) {
            document.getElementById("periodInfoBanner").style.display = "block";
            document.getElementById("periodText").textContent = c.periodInfo || getFrequencyLabel(c.frequency);
            if (isRecurring) {
                document.getElementById("recurringInfo").innerHTML = '<i class="fas fa-redo"></i> Resets after each completion';
            }
        }

        var dueDateClass = c.overdue && c.status !== "COMPLETED" ? "due-danger" : "";
        var daysRemaining = c.daysRemaining;
        var daysText = "";
        if (daysRemaining !== undefined && c.status !== "COMPLETED") {
            daysText = daysRemaining >= 0 ? daysRemaining + " days left" : "Overdue by " + Math.abs(daysRemaining) + " days";
        }

        var infoHtml = '<div class="info-row"><span class="info-label">Due Date</span><span class="info-value ' + dueDateClass + '">' + formatDate(c.dueDate) + (daysText ? '<br><span style="font-size:11px;">' + daysText + '</span>' : '') + '</span></div>' +
            '<div class="info-row"><span class="info-label">Required Documents</span><span class="info-value">' + (c.documentRequired ? escapeHtml(c.documentRequired) : '—') + '</span></div>';
        document.getElementById("infoTable").innerHTML = infoHtml;

        document.getElementById("instructions").innerHTML = c.instructions ? escapeHtml(c.instructions).replace(/\n/g, "<br>") : "No specific instructions provided.";

        if (c.externalLink) {
            document.getElementById("externalLinkDiv").style.display = "block";
            document.getElementById("externalLink").href = c.externalLink;
        }

        var canComplete = c.canComplete !== false && c.status !== "COMPLETED";
        if (!canComplete && c.status !== "COMPLETED") {
            document.getElementById("canCompleteInfo").innerHTML = '<span class="badge badge-inactive"><i class="fas fa-lock"></i> Locked - Already completed by another employee</span>';
        }

        if (c.status === "COMPLETED") {
            document.getElementById("submissionFormDiv").style.display = "none";
            document.getElementById("completedInfoDiv").style.display = "block";

            var completedHtml = '<div class="info-row"><span class="info-label">Completed By</span><span class="info-value"><i class="fas fa-user-check" style="color:#22c55e;"></i> ' + (c.completedByEmployeeName || 'Employee') + '</span></div>' +
                '<div class="info-row"><span class="info-label">Completed On</span><span class="info-value">' + formatDateTime(c.completedAt) + '</span></div>';
            if (c.submissionReference) {
                completedHtml += '<div class="info-row"><span class="info-label">Reference Number</span><span class="info-value" style="font-family:monospace;">' + escapeHtml(c.submissionReference) + '</span></div>';
            }
            if (c.submissionDocumentUrl) {
                completedHtml += '<div class="info-row"><span class="info-label">Submitted Document</span><span class="info-value"><a href="' + c.submissionDocumentUrl + '" target="_blank" class="btn btn-ghost" style="padding:2px 8px;">View Document</a></span></div>';
            }
            document.getElementById("completedInfo").innerHTML = completedHtml;

            if (isRecurring) {
                document.getElementById("nextPeriodReady").style.display = "block";
            }
        } else if (canComplete) {
            document.getElementById("submissionFormDiv").style.display = "block";
            document.getElementById("completedInfoDiv").style.display = "none";

            if (isRecurring && c.periodInfo) {
                document.getElementById("nextPeriodInfo").style.display = "block";
                document.getElementById("nextPeriodText").innerHTML = "After completing " + c.periodInfo + ", the next period will be automatically created.";
            }
        } else {
            document.getElementById("submissionFormDiv").style.display = "none";
            document.getElementById("completedInfoDiv").style.display = "block";
            document.getElementById("completedInfo").innerHTML = '<div class="empty-state">This compliance has been locked and cannot be modified.</div>';
        }
    }

    async function loadDocuments() {
        document.getElementById("documentsList").innerHTML = '<div class="empty-state">No documents uploaded</div>';
    }

    async function loadHistory() {
        document.getElementById("historyList").innerHTML = '<div class="empty-state">No history available</div>';
    }

    async function submitCompletion() {
        var submissionReference = document.getElementById("submissionReference").value.trim();
        var documentFile = document.getElementById("documentFile").files[0];

        if (!submissionReference && !documentFile) {
            toast("Please provide at least a reference number or document", "error");
            return;
        }

        var periodText = complianceData.periodInfo || "this period";
        if (!confirm("Are you sure you want to mark this compliance as completed for " + periodText + "?\n\nOnce completed, other employees will see it as completed and cannot modify it.")) {
            return;
        }

        var btn = document.getElementById("submitBtn");
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';

        var formData = new FormData();
        formData.append("submissionReference", submissionReference);
        if (documentFile) formData.append("document", documentFile);

        var token = localStorage.getItem("accessToken");
        try {
            var response = await fetch(contextPath + "/api/employee/compliance/" + COMPLIANCE_ID + "/complete", {
                method: "POST",
                headers: { "Authorization": "Bearer " + token },
                body: formData
            });
            var data = await response.json();

            if (data && data.success) {
                toast("Compliance marked as completed successfully!", "success");
                setTimeout(function () { window.location.reload(); }, 1500);
            } else {
                toast(data?.error || "Submission failed", "error");
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check-circle"></i> Mark as Completed';
            }
        } catch (error) {
            console.error("Submission error:", error);
            toast("Submission failed", "error");
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-check-circle"></i> Mark as Completed';
        }
    }

    document.getElementById("completionForm").addEventListener("submit", function (e) {
        e.preventDefault();
        submitCompletion();
    });

    loadCompliance();
</script>

<%@ include file="../fragments/footer.jsp" %>