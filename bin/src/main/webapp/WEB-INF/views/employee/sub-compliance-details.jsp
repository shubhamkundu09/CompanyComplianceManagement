<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% Object subIdObj=request.getAttribute("subComplianceId"); String subComplianceId=subIdObj !=null ?
    String.valueOf(subIdObj) : null; if (subComplianceId==null || subComplianceId.trim().isEmpty()) { String
    uri=request.getRequestURI(); String[] parts=uri.split("/"); if (parts.length> 0) {
    String last = parts[parts.length - 1];
    try {
    Long.parseLong(last);
    subComplianceId = last;
    } catch (NumberFormatException e) {}
    }
    }

    if (subComplianceId == null || subComplianceId.trim().isEmpty() || "null".equals(subComplianceId)) {
    response.sendRedirect(request.getContextPath() + "/employee/compliances");
    return;
    }

    pageContext.setAttribute("subComplianceId", subComplianceId);
    pageContext.setAttribute("pageTitle", "Sub-Compliance Details");
%>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="compliances" />
    </jsp:include>

    <div class="main-content">
        <div style="margin-bottom:20px;">
            <a href="javascript:history.back()" style="color:#6366f1;text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
                <i class="fas fa-arrow-left" style="font-size:12px;"></i> Back
            </a>
        </div>

        <div id="loader" style="text-align:center;padding:60px;">
            <div class="spinner" style="margin:0 auto 12px;"></div>
            <div style="color:#64748b;">Loading sub-compliance details...</div>
        </div>

        <div id="pageContent" style="display:none;">
            <div style="margin-bottom:20px;font-size:12px;color:#64748b;">
                <a href="${pageContext.request.contextPath}/employee/compliances" style="color:#6366f1;">Categories</a>
                <i class="fas fa-chevron-right" style="font-size:10px;margin:0 6px;"></i>
                <span id="parentNameLink">—</span>
                <i class="fas fa-chevron-right" style="font-size:10px;margin:0 6px;"></i>
                <span id="subNameBreadcrumb">—</span>
            </div>

            <div class="card" style="padding:24px;margin-bottom:24px;">
                <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;">
                    <div>
                        <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;">
                            <div style="width:56px;height:56px;background:rgba(99,102,241,0.15);border-radius:14px;display:flex;align-items:center;justify-content:center;">
                                <i class="fas fa-file-alt" style="font-size:28px;color:#6366f1;"></i>
                            </div>
                            <div>
                                <h1 id="subName" style="font-family:'Syne',sans-serif;font-size:24px;font-weight:700;margin:0;">—</h1>
                                <div style="margin-top:8px;">
                                    <span id="statusBadge"></span>
                                    <span id="frequencyBadge" style="margin-left:8px;"></span>
                                    <span id="periodBadge" style="margin-left:8px;"></span>
                                </div>
                            </div>
                        </div>
                        <p id="subDescription" style="color:#94a3b8;margin-top:8px;max-width:600px;line-height:1.6;">—</p>
                    </div>
                    <div id="dueDateCard" style="text-align:right;"></div>
                </div>
            </div>

            <div id="completionMessageCard" class="card" style="margin-bottom:20px;padding:16px;display:none;">
                <div style="display:flex;align-items:center;gap:10px;">
                    <i class="fas fa-lock" style="color:#f59e0b;font-size:18px;"></i>
                    <span id="completionMessageText" style="font-size:13px;"></span>
                </div>
            </div>

            <div class="grid-2" style="gap:20px;">
                <div>
                    <div class="card" style="padding:20px;margin-bottom:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;">
                            <i class="fas fa-info-circle"></i> Compliance Information
                        </h3>
                        <div id="infoGrid" style="display:flex;flex-direction:column;gap:12px;"></div>
                    </div>

                    <div class="card" style="padding:20px;margin-bottom:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;">
                            <i class="fas fa-list-ol"></i> Instructions
                        </h3>
                        <div id="instructions" style="color:#94a3b8;font-size:14px;line-height:1.7;white-space:pre-line;"></div>
                        <div id="externalLinkDiv" style="margin-top:16px;display:none;">
                            <a href="#" id="externalLink" target="_blank" class="btn btn-primary" style="width:100%;justify-content:center;">
                                <i class="fas fa-external-link-alt"></i> Go to External Portal
                            </a>
                        </div>
                    </div>

                    <div class="card" style="padding:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;">
                            <i class="fas fa-history"></i> Activity History
                        </h3>
                        <div id="historyList" style="max-height:300px;overflow-y:auto;"></div>
                    </div>
                </div>

                <div>
                    <div id="completedInfoDiv" class="card" style="padding:20px;margin-bottom:20px;display:none;">
                        <h3 style="font-size:14px;font-weight:700;color:#22c55e;margin-bottom:16px;">
                            <i class="fas fa-check-circle"></i> Completion Details
                        </h3>
                        <div id="completedInfo"></div>
                    </div>

                    <div id="submissionFormDiv" class="card" style="padding:20px;margin-bottom:20px;display:none;">
                        <h3 style="font-size:14px;font-weight:700;color:#22c55e;margin-bottom:16px;">
                            <i class="fas fa-upload"></i> Mark as Completed
                        </h3>
                        <div style="background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;padding:12px;margin-bottom:16px;border-radius:6px;">
                            <i class="fas fa-info-circle" style="color:#f59e0b;"></i>
                            <span style="font-size:12px;">Once you mark this as completed, other employees will see it as completed and cannot modify it.</span>
                        </div>
                        <div id="recurringInfo" style="background:rgba(34,197,94,0.1);border-left:3px solid #22c55e;padding:12px;margin-bottom:16px;border-radius:6px;display:none;">
                            <i class="fas fa-redo" style="color:#22c55e;"></i>
                            <span style="font-size:12px;">This is a recurring compliance. After completion, the next period will be automatically created.</span>
                        </div>
                        <form id="submissionForm" onsubmit="return false;">
                            <div style="margin-bottom:16px;">
                                <label class="form-label">Submission Reference Number <span style="color:#ef4444;">*</span></label>
                                <input type="text" id="submissionReference" class="form-input" placeholder="e.g., ARN number, Receipt number, Application ID">
                                <div style="font-size:11px;color:#64748b;margin-top:4px;">Enter the reference number from the submission portal</div>
                            </div>
                            <div style="margin-bottom:16px;">
                                <label class="form-label">Upload Document (Optional)</label>
                                <input type="file" id="submissionDocument" class="form-input" accept=".pdf,.jpg,.png,.doc,.docx">
                                <div style="font-size:11px;color:#64748b;margin-top:4px;">Max 10MB. Supported: PDF, JPG, PNG, DOC, DOCX</div>
                            </div>
                            <button type="submit" id="submitBtn" class="btn btn-primary" style="width:100%;">
                                <i class="fas fa-check-circle"></i> Mark as Completed
                            </button>
                        </form>
                    </div>

                    <div class="card" style="padding:20px;">
                        <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;">
                            <i class="fas fa-file-alt"></i> Documents
                        </h3>
                        <div id="documentsList" style="max-height:300px;overflow-y:auto;">
                            <div class="empty-state" style="padding:20px;">No documents uploaded</div>
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
    .doc-item { display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; background: #1e2333; border-radius: 6px; margin-bottom: 6px; }
    .due-danger { color: #ef4444; font-weight: 600; }
    .due-warning { color: #f59e0b; }
</style>

<script>
    var SUB_COMPLIANCE_ID = "${subComplianceId}";
    var subData = null;

    async function loadSubComplianceDetails() {
        var data = await api("/api/employee/compliance/sub-compliance/" + SUB_COMPLIANCE_ID);

        if (data && data.success) {
            subData = data.data;
            renderDetails();
            document.getElementById("loader").style.display = "none";
            document.getElementById("pageContent").style.display = "block";
        } else {
            toast("Failed to load sub-compliance details", "error");
            setTimeout(function () { window.location.href = contextPath + "/employee/compliances"; }, 2000);
        }
    }

    function renderDetails() {
        var s = subData;
        var isCompleted = s.status === "COMPLETED";
        var isOverdue = s.isOverdue && !isCompleted;

        document.getElementById("subName").textContent = s.name;
        document.getElementById("subNameBreadcrumb").textContent = s.name;
        document.getElementById("parentNameLink").textContent = s.parentName || "Compliance";
        document.getElementById("subDescription").textContent = s.description || "No description provided";

        var statusClass = isCompleted ? "badge-active" : (isOverdue ? "badge-inactive" : "badge-pending");
        var statusText = isCompleted ? "Completed" : (isOverdue ? "Overdue" : "Pending");
        document.getElementById("statusBadge").innerHTML = '<span class="badge ' + statusClass + '" style="font-size:13px;padding:5px 12px;">' + statusText + '</span>';

        var frequencyLabel = getFrequencyLabel(s.frequency);
        if (frequencyLabel) {
            document.getElementById("frequencyBadge").innerHTML = '<span class="badge badge-info">' + frequencyLabel + '</span>';
        }

        if (s.periodInfo) {
            document.getElementById("periodBadge").innerHTML = '<span class="badge badge-info"><i class="fas fa-calendar-week"></i> ' + s.periodInfo + '</span>';
        }

        var dueDateClass = "";
        var daysText = "";
        if (s.daysRemaining !== undefined && !isCompleted) {
            if (s.daysRemaining < 0) {
                dueDateClass = "due-danger";
                daysText = "Overdue by " + Math.abs(s.daysRemaining) + " days";
            } else if (s.daysRemaining <= 7) {
                dueDateClass = "due-warning";
                daysText = s.daysRemaining + " days remaining";
            } else {
                daysText = s.daysRemaining + " days remaining";
            }
        }
        document.getElementById("dueDateCard").innerHTML =
            '<div style="background:#1e2333;padding:12px 16px;border-radius:10px;">' +
            '<div style="font-size:11px;color:#64748b;">Due Date</div>' +
            '<div class="' + dueDateClass + '" style="font-size:18px;font-weight:700;">' + formatDate(s.dueDate) + '</div>' +
            (daysText ? '<div style="font-size:11px;margin-top:4px;">' + daysText + '</div>' : '') +
            '</div>';

        var infoHtml = '';
        if (s.documentRequired) {
            infoHtml += '<div class="info-row"><span class="info-label">Required Documents</span><span class="info-value">' + escapeHtml(s.documentRequired) + '</span></div>';
        }
        if (s.reminderDaysBefore) {
            infoHtml += '<div class="info-row"><span class="info-label">Reminder</span><span class="info-value">' + s.reminderDaysBefore + ' days before due date</span></div>';
        }
        document.getElementById("infoGrid").innerHTML = infoHtml;

        document.getElementById("instructions").innerHTML = s.instructions ? escapeHtml(s.instructions).replace(/\n/g, "<br>") : "No specific instructions provided.";

        if (s.externalLink) {
            document.getElementById("externalLinkDiv").style.display = "block";
            document.getElementById("externalLink").href = s.externalLink;
        }

        if (isCompleted) {
            document.getElementById("submissionFormDiv").style.display = "none";
            document.getElementById("completedInfoDiv").style.display = "block";

            var completedHtml = '<div class="info-row"><span class="info-label">Completed By</span><span class="info-value"><i class="fas fa-user-check" style="color:#22c55e;"></i> ' +
                (s.completedByEmployeeName || 'Employee') + '</span></div>' +
                '<div class="info-row"><span class="info-label">Completed On</span><span class="info-value">' + formatDateTime(s.completedAt) + '</span></div>';
            if (s.submissionReference) {
                completedHtml += '<div class="info-row"><span class="info-label">Reference Number</span><span class="info-value" style="font-family:monospace;">' + escapeHtml(s.submissionReference) + '</span></div>';
            }
            if (s.submissionDocumentUrl) {
                completedHtml += '<div class="info-row"><span class="info-label">Submitted Document</span><span class="info-value"><a href="' + s.submissionDocumentUrl + '" target="_blank" class="btn btn-ghost" style="padding:2px 8px;">View Document</a></span></div>';
            }
            document.getElementById("completedInfo").innerHTML = completedHtml;
        } else if (s.canComplete !== false) {
            document.getElementById("submissionFormDiv").style.display = "block";
            document.getElementById("completedInfoDiv").style.display = "none";

            if (s.frequency && s.frequency !== "ONE_TIME") {
                document.getElementById("recurringInfo").style.display = "block";
            }
        } else {
            document.getElementById("submissionFormDiv").style.display = "none";
            document.getElementById("completedInfoDiv").style.display = "block";
            document.getElementById("completedInfo").innerHTML = '<div class="empty-state">This compliance has been locked and cannot be modified.</div>';
            if (s.completionMessage) {
                document.getElementById("completionMessageCard").style.display = "block";
                document.getElementById("completionMessageText").textContent = s.completionMessage;
            }
        }

        renderDocuments(s.documents);
        renderHistory(s.history);
    }

    function renderDocuments(documents) {
        var container = document.getElementById("documentsList");
        if (!documents || !documents.length) {
            container.innerHTML = '<div class="empty-state" style="padding:20px;">No documents uploaded</div>';
            return;
        }
        var html = '';
        for (var i = 0; i < documents.length; i++) {
            var doc = documents[i];
            var kb = doc.fileSize ? (doc.fileSize / 1024).toFixed(0) + " KB" : "";
            html += '<div class="doc-item">' +
                '<div><i class="fas fa-file-pdf" style="color:#ef4444;"></i> ' + escapeHtml(doc.documentName) +
                (doc.remarks ? '<br><span style="font-size:10px;color:#64748b;">' + escapeHtml(doc.remarks) + '</span>' : '') +
                (kb ? '<br><span style="font-size:10px;color:#64748b;">' + kb + '</span>' : '') +
                '</div>' +
                '<a href="' + doc.documentUrl + '" target="_blank" class="btn btn-ghost" style="padding:4px 8px;">View <i class="fas fa-external-link-alt"></i></a>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    function renderHistory(history) {
        var container = document.getElementById("historyList");
        if (!history || !history.length) {
            container.innerHTML = '<div class="empty-state" style="padding:20px;">No history available</div>';
            return;
        }
        var html = '';
        for (var i = 0; i < history.length; i++) {
            var h = history[i];
            var isCompletion = h.action === "Compliance Completed";
            html += '<div class="history-item">' +
                '<div style="display:flex;justify-content:space-between;margin-bottom:4px;">' +
                '<strong style="font-size:12px;' + (isCompletion ? 'color:#22c55e;' : '') + '">' +
                (isCompletion ? '✓ ' : '') + escapeHtml(h.action || "Update") + '</strong>' +
                '<span style="font-size:10px;color:#64748b;">' + formatDateTime(h.performedAt) + '</span>' +
                '</div>' +
                (h.previousStatus ? '<div style="font-size:11px;color:#64748b;">Status: ' + h.previousStatus + ' → ' + h.newStatus + '</div>' : '') +
                (h.remarks ? '<div style="font-size:11px;margin-top:4px;">📝 ' + escapeHtml(h.remarks) + '</div>' : '') +
                '<div style="font-size:10px;color:#64748b;margin-top:4px;">👤 ' + (h.performedByName || 'System') + '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    async function submitCompletion() {
        var submissionReference = document.getElementById("submissionReference").value.trim();
        var documentFile = document.getElementById("submissionDocument").files[0];

        if (!submissionReference && !documentFile) {
            toast("Please provide at least a reference number or document", "error");
            return;
        }

        if (!confirm("Are you sure you want to mark this compliance as completed?\n\nOnce completed, other employees will see it as completed and cannot modify it.")) {
            return;
        }

        var btn = document.getElementById("submitBtn");
        var originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';

        var formData = new FormData();
        formData.append("submissionReference", submissionReference);
        if (documentFile) formData.append("document", documentFile);

        var token = localStorage.getItem("accessToken");
        try {
            var response = await fetch(contextPath + "/api/employee/compliance/" + SUB_COMPLIANCE_ID + "/complete", {
                method: "POST",
                headers: { "Authorization": "Bearer " + token },
                body: formData
            });
            var data = await response.json();

            if (data && data.success) {
                toast("Compliance completed successfully!", "success");
                setTimeout(function () { window.location.reload(); }, 1500);
            } else {
                toast(data?.error || "Submission failed", "error");
                btn.disabled = false;
                btn.innerHTML = originalText;
            }
        } catch (error) {
            console.error("Submission error:", error);
            toast("Submission failed. Please try again.", "error");
            btn.disabled = false;
            btn.innerHTML = originalText;
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

    function formatDateTime(d) {
        if (!d) return '—';
        var date = new Date(d);
        return date.getDate().toString().padStart(2, '0') + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
            date.getFullYear() + ' ' + date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0');
    }

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }

    document.getElementById("submissionForm").addEventListener("submit", function (e) {
        e.preventDefault();
        submitCompletion();
    });

    loadSubComplianceDetails();
</script>

<%@ include file="../fragments/footer.jsp" %>