// Global AJAX setup
$.ajaxSetup({
    beforeSend: function(xhr) {
        const token = localStorage.getItem('accessToken');
        if (token) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + token);
        }
    },
    error: function(xhr, status, error) {
        if (xhr.status === 401) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('user');
            window.location.href = '/login';
        }
    }
});

// Format date
function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Show loading state
function showLoading(elementId) {
    $(`#${elementId}`).html(`
        <div class="flex justify-center items-center py-8">
            <div class="spinner"></div>
        </div>
    `);
}

// Show toast notification
function showToast(message, type = 'success') {
    const toast = $(`
        <div class="fixed bottom-4 right-4 z-50 fade-in">
            <div class="bg-${type === 'success' ? 'green' : 'red'}-500 text-white px-6 py-3 rounded-lg shadow-lg">
                <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'} mr-2"></i>
                ${message}
            </div>
        </div>
    `);
    $('body').append(toast);
    setTimeout(() => toast.fadeOut(() => toast.remove()), 3000);
}

// Confirm dialog
function confirmAction(message, callback) {
    if (confirm(message)) {
        callback();
    }
}

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR'
    }).format(amount);
}

// Get user from session
function getCurrentUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
}

// Check if user has role
function hasRole(role) {
    const user = getCurrentUser();
    return user && user.role === role;
}

// Logout function
function logout() {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('user');
    window.location.href = '/login';
}