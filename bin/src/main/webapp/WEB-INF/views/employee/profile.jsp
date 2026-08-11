<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "My Profile" ); %>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="profile" />
    </jsp:include>

    <div class="main-content">
        <div style="margin-bottom:24px;">
            <p style="font-size:12px;color:#6366f1;font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                Account
            </p>
            <h1 style="font-family:'Syne',sans-serif;font-size:24px;font-weight:700;color:#e2e8f0;">
                My Profile
            </h1>
        </div>

        <div id="loader" style="text-align:center;padding:80px;">
            <div class="spinner"></div>
        </div>

        <div id="pageContent" style="display:none;max-width:700px;margin:0 auto;">
            <div class="card" style="padding:28px 32px;">
                <div style="text-align:center;margin-bottom:24px;">
                    <div class="avatar" id="profileAvatar" style="width:80px;height:80px;font-size:32px;margin:0 auto;">?</div>
                    <h2 id="profileName" style="font-family:'Syne',sans-serif;font-size:20px;font-weight:700;margin-top:12px;">—</h2>
                    <p id="profileEmail" style="font-size:13px;color:#64748b;">—</p>
                    <span id="profileStatusBadge"></span>
                </div>

                <div class="divider"></div>

                <form id="profileForm" onsubmit="return false;">
                    <div class="grid-2">
                        <div>
                            <label class="form-label">First Name</label>
                            <input type="text" id="firstName" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Last Name</label>
                            <input type="text" id="lastName" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Employee Code</label>
                            <input type="text" id="employeeCode" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Phone Number</label>
                            <input type="tel" id="phoneNumber" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Designation</label>
                            <input type="text" id="designation" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Department</label>
                            <input type="text" id="department" class="form-input" readonly disabled>
                        </div>
                        <div class="col-2">
                            <label class="form-label">Company</label>
                            <input type="text" id="companyName" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Member Since</label>
                            <input type="text" id="createdAt" class="form-input" readonly disabled>
                        </div>
                        <div>
                            <label class="form-label">Last Login</label>
                            <input type="text" id="lastLoginAt" class="form-input" readonly disabled>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div style="display:flex;gap:12px;justify-content:center;">
                        <button type="button" onclick="enableEdit()" id="editBtn" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Profile
                        </button>
                        <button type="submit" id="saveBtn" class="btn btn-success" style="display:none;">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button type="button" onclick="cancelEdit()" id="cancelBtn" class="btn btn-ghost" style="display:none;">
                            Cancel
                        </button>
                        <a href="${pageContext.request.contextPath}/change-password" class="btn btn-ghost">
                            <i class="fas fa-key"></i> Change Password
                        </a>
                        <button onclick="refreshProfile()" class="btn btn-ghost">
                            <i class="fas fa-sync-alt"></i> Refresh
                        </button>
                    </div>
                </form>
            </div>

            <div class="card" style="margin-top:20px;padding:20px;">
                <h3 style="font-size:14px;font-weight:700;color:#6366f1;margin-bottom:16px;display:flex;align-items:center;gap:8px;">
                    <i class="fas fa-chart-line"></i> My Compliance Summary
                </h3>
                <div id="complianceSummary" class="grid-4" style="gap:12px;">
                    <div style="text-align:center;">
                        <div style="font-size:24px;font-weight:700;color:#818cf8;" id="summaryTotal">0</div>
                        <div style="font-size:11px;color:#64748b;">Total</div>
                    </div>
                    <div style="text-align:center;">
                        <div style="font-size:24px;font-weight:700;color:#22c55e;" id="summaryCompleted">0</div>
                        <div style="font-size:11px;color:#64748b;">Completed</div>
                    </div>
                    <div style="text-align:center;">
                        <div style="font-size:24px;font-weight:700;color:#f59e0b;" id="summaryPending">0</div>
                        <div style="font-size:11px;color:#64748b;">Pending</div>
                    </div>
                    <div style="text-align:center;">
                        <div style="font-size:24px;font-weight:700;color:#ef4444;" id="summaryOverdue">0</div>
                        <div style="font-size:11px;color:#64748b;">Overdue</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var employeeData = null;
    var originalData = null;

    async function loadProfile() {
        var data = await api("/api/employee/profile");
        if (data && data.success) {
            employeeData = data.data;
            originalData = { ...employeeData };
            renderProfile();
            loadComplianceSummary();
            document.getElementById("loader").style.display = "none";
            document.getElementById("pageContent").style.display = "block";
        } else {
            toast("Failed to load profile", "error");
        }
    }

    function renderProfile() {
        var p = employeeData;
        document.getElementById("profileName").textContent = (p.firstName || "") + " " + (p.lastName || "");
        document.getElementById("profileEmail").textContent = p.email;
        document.getElementById("profileAvatar").textContent = ((p.firstName || "")[0] || "") + ((p.lastName || "")[0] || "");

        var statusClass = p.status === "ACTIVE" ? "badge-active" : "badge-inactive";
        document.getElementById("profileStatusBadge").innerHTML = '<span class="badge ' + statusClass + '">' + p.status + '</span>';

        document.getElementById("firstName").value = p.firstName || "—";
        document.getElementById("lastName").value = p.lastName || "—";
        document.getElementById("employeeCode").value = p.employeeCode || "—";
        document.getElementById("phoneNumber").value = p.phoneNumber || "—";
        document.getElementById("designation").value = p.designation || "—";
        document.getElementById("department").value = p.department || "—";
        document.getElementById("companyName").value = p.companyName || "—";
        document.getElementById("createdAt").value = formatDate(p.createdAt);
        document.getElementById("lastLoginAt").value = formatDateTime(p.lastLoginAt);
    }

    async function loadComplianceSummary() {
        var data = await api("/api/employee/compliance/my?page=0&size=100");
        if (data && data.success) {
            var compliances = data.data.content || [];
            var total = compliances.length;
            var completed = 0, pending = 0, overdue = 0;
            for (var i = 0; i < compliances.length; i++) {
                if (compliances[i].status === "COMPLETED") completed++;
                else if (compliances[i].status === "PENDING" || compliances[i].status === "IN_PROGRESS") pending++;
                if (compliances[i].overdue && compliances[i].status !== "COMPLETED") overdue++;
            }
            document.getElementById("summaryTotal").textContent = total;
            document.getElementById("summaryCompleted").textContent = completed;
            document.getElementById("summaryPending").textContent = pending;
            document.getElementById("summaryOverdue").textContent = overdue;
        }
    }

    function enableEdit() {
        document.getElementById("phoneNumber").removeAttribute("readonly");
        document.getElementById("phoneNumber").disabled = false;
        document.getElementById("phoneNumber").classList.remove("bg-gray-100");

        document.getElementById("editBtn").style.display = "none";
        document.getElementById("saveBtn").style.display = "inline-flex";
        document.getElementById("cancelBtn").style.display = "inline-flex";

        toast("Edit mode enabled - you can update your phone number", "info");
    }

    function cancelEdit() {
        document.getElementById("phoneNumber").value = originalData.phoneNumber || "";
        document.getElementById("phoneNumber").setAttribute("readonly", true);
        document.getElementById("phoneNumber").disabled = true;

        document.getElementById("editBtn").style.display = "inline-flex";
        document.getElementById("saveBtn").style.display = "none";
        document.getElementById("cancelBtn").style.display = "none";

        toast("Edit cancelled", "info");
    }

    async function saveProfile() {
        var payload = {
            firstName: employeeData.firstName,
            lastName: employeeData.lastName,
            phoneNumber: document.getElementById("phoneNumber").value
        };

        var btn = document.getElementById("saveBtn");
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

        var data = await api("/api/employee/profile", {
            method: "PUT",
            body: JSON.stringify(payload)
        });

        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-save"></i> Save Changes';

        if (data && data.success) {
            toast("Profile updated successfully!", "success");
            originalData.phoneNumber = payload.phoneNumber;
            cancelEdit();
            loadProfile();
        } else {
            toast(data?.error || "Failed to update profile", "error");
        }
    }

    function formatDate(d) {
        if (!d) return "—";
        return new Date(d).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
    }

    function formatDateTime(d) {
        if (!d) return "—";
        return new Date(d).toLocaleString("en-IN", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" });
    }

    function refreshProfile() { loadProfile(); toast("Profile refreshed", "info"); }

    document.getElementById("profileForm").addEventListener("submit", function (e) {
        e.preventDefault();
        saveProfile();
    });

    loadProfile();
</script>

<%@ include file="../fragments/footer.jsp" %>