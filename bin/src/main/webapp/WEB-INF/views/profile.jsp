<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- File: profile.jsp --%>


<%
    pageContext.setAttribute("pageTitle", "My Profile");
%>

<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="flex">
    <jsp:include page="fragments/sidebar.jsp">
        <jsp:param name="active" value="profile"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="flex-1 lg:ml-64 p-4">
        <div class="container mx-auto max-w-4xl">
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <!-- Profile Header -->
                <div class="bg-gradient-to-r from-indigo-500 to-purple-600 px-6 py-8">
                    <div class="flex items-center space-x-4">
                        <div class="w-20 h-20 bg-white rounded-full flex items-center justify-center">
                            <i class="fas fa-user-circle text-5xl text-indigo-600"></i>
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold text-white">${sessionScope.user.firstName} ${sessionScope.user.lastName}</h1>
                            <p class="text-indigo-100">${sessionScope.user.role}</p>
                        </div>
                    </div>
                </div>

                <!-- Profile Info -->
                <div class="p-6">
                    <form id="profileForm" class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">First Name</label>
                                <input type="text" id="firstName" name="firstName"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100"
                                       readonly value="${sessionScope.user.firstName}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
                                <input type="text" id="lastName" name="lastName"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100"
                                       readonly value="${sessionScope.user.lastName}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                                <input type="email" id="email" name="email"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100"
                                       readonly value="${sessionScope.user.email}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Role</label>
                                <input type="text" id="role" name="role"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100"
                                       readonly value="${sessionScope.user.role}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                                <input type="tel" id="phoneNumber" name="phoneNumber"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                                       value="${sessionScope.user.phoneNumber}">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                                <span class="inline-flex px-3 py-2 rounded-lg text-sm font-semibold ${sessionScope.user.status == 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                    ${sessionScope.user.status}
                                </span>
                            </div>
                        </div>

                        <div class="flex justify-end space-x-3 pt-4">
                            <button type="button" onclick="enableEdit()" id="editBtn"
                                    class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
                                <i class="fas fa-edit mr-2"></i>Edit Profile
                            </button>
                            <button type="submit" id="saveBtn"
                                    class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition hidden">
                                <i class="fas fa-save mr-2"></i>Save Changes
                            </button>
                            <button type="button" onclick="cancelEdit()" id="cancelBtn"
                                    class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition hidden">
                                Cancel
                            </button>
                        </div>
                    </form>

                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">Change Password</h3>
                        <button onclick="window.location.href='${pageContext.request.contextPath}/change-password'"
                                class="bg-yellow-600 text-white px-4 py-2 rounded-lg hover:bg-yellow-700 transition">
                            <i class="fas fa-key mr-2"></i>Change Password
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function enableEdit() {
    $('#firstName, #lastName, #phoneNumber').removeClass('bg-gray-100').prop('readonly', false);
    $('#editBtn').addClass('hidden');
    $('#saveBtn, #cancelBtn').removeClass('hidden');
}

function cancelEdit() {
    location.reload();
}

$('#profileForm').on('submit', function(e) {
    e.preventDefault();

    const formData = {
        firstName: $('#firstName').val(),
        lastName: $('#lastName').val(),
        phoneNumber: $('#phoneNumber').val()
    };

    $.ajax({
        url: `${contextPath}/api/users/profile`,
        type: 'PUT',
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: function(response) {
            if (response.success) {
                showToast('Profile updated successfully!', 'success');
                setTimeout(() => location.reload(), 1500);
            }
        },
        error: function(xhr) {
            showToast('Failed to update profile', 'error');
        }
    });
});
</script>

<%@ include file="fragments/footer.jsp" %>