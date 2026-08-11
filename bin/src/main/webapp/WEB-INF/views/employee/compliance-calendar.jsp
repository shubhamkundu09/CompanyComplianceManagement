<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("pageTitle", "Compliance Calendar" ); %>

<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="page-wrapper">
    <jsp:include page="../fragments/sidebar.jsp">
        <jsp:param name="active" value="compliances" />
    </jsp:include>

    <div class="main-content" style="padding:20px;">
        <div style="margin-bottom:20px;">
            <p style="font-size:12px;color:#6366f1;font-weight:600;text-transform:uppercase;letter-spacing:.8px;margin-bottom:4px;">
                Compliance Management
            </p>
            <h1 style="font-family:'Syne',sans-serif;font-size:24px;font-weight:700;color:#e2e8f0;">
                Compliance Calendar
            </h1>
            <p style="font-size:13px;color:#64748b;margin-top:4px;">
                View all your compliance due dates and deadlines
            </p>
        </div>

        <div class="card" style="padding:16px 20px;margin-bottom:20px;">
            <div style="display:flex;gap:12px;flex-wrap:wrap;align-items:flex-end;">
                <div style="min-width:150px;">
                    <label class="form-label"><i class="fas fa-chart-line"></i> Status Filter</label>
                    <select id="statusFilter" class="form-input">
                        <option value="">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="OVERDUE">Overdue</option>
                    </select>
                </div>
                <div style="min-width:150px;">
                    <label class="form-label"><i class="fas fa-calendar-week"></i> View</label>
                    <select id="viewSelect" class="form-input" onchange="changeView()">
                        <option value="month">Month View</option>
                        <option value="week">Week View</option>
                        <option value="day">Day View</option>
                    </select>
                </div>
                <button onclick="resetFilters()" class="btn btn-ghost">
                    <i class="fas fa-undo"></i> Reset
                </button>
                <button onclick="refreshCalendar()" class="btn btn-primary">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button onclick="exportCalendarData()" class="btn btn-ghost">
                    <i class="fas fa-download"></i> Export CSV
                </button>
            </div>
        </div>

        <div style="display:flex;gap:20px;min-height:650px;">
            <div id="calendarContainer" style="flex:1;transition:all 0.4s cubic-bezier(0.4,0,0.2,1);overflow:hidden;">
                <div class="card" style="padding:20px;height:100%;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:10px;">
                        <div style="display:flex;gap:8px;">
                            <button onclick="previousMonth()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button onclick="nextMonth()" class="btn btn-ghost" style="padding:8px 12px;">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                            <button onclick="goToToday()" class="btn btn-primary" style="padding:8px 12px;">
                                <i class="fas fa-calendar-day"></i> Today
                            </button>
                        </div>
                        <h2 id="currentMonthYear" style="font-family:'Syne',sans-serif;font-size:20px;font-weight:700;margin:0;">
                            Loading...</h2>
                    </div>
                    <div id="calendarGrid" style="overflow-x:auto;">
                        <div id="calendarTable" style="width:100%;border-collapse:collapse;"></div>
                    </div>
                </div>
            </div>

            <div id="sidePanel" style="width:0;opacity:0;overflow:hidden;transition:all 0.4s cubic-bezier(0.4,0,0.2,1);background:#111318;border-radius:12px;border:1px solid #1e2130;display:none;">
                <div style="padding:20px;height:100%;display:flex;flex-direction:column;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;padding-bottom:12px;border-bottom:1px solid #1e2130;">
                        <div>
                            <div style="font-size:11px;color:#6366f1;text-transform:uppercase;letter-spacing:.8px;">Selected Date</div>
                            <div style="font-family:'Syne',sans-serif;font-size:20px;font-weight:700;" id="selectedDateTitle">—</div>
                        </div>
                        <button onclick="closeSidePanel()" class="btn btn-ghost" style="padding:6px 10px;">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div id="dayStats" style="display:flex;gap:12px;margin-bottom:20px;flex-wrap:wrap;"></div>
                    <div style="flex:1;overflow-y:auto;">
                        <div style="font-size:12px;font-weight:600;color:#64748b;margin-bottom:12px;">
                            <i class="fas fa-list"></i> Events on this day
                        </div>
                        <div id="dayEventsList" style="display:flex;flex-direction:column;gap:10px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card" style="margin-top:20px;padding:12px 20px;">
            <div style="display:flex;gap:20px;flex-wrap:wrap;align-items:center;">
                <span style="font-size:11px;color:#64748b;"><i class="fas fa-info-circle"></i> Event Types:</span>
                <span><span class="calendar-legend pending"></span> Pending</span>
                <span><span class="calendar-legend in-progress"></span> In Progress</span>
                <span><span class="calendar-legend completed"></span> Completed</span>
                <span><span class="calendar-legend overdue"></span> Overdue</span>
                <span><span class="calendar-legend today"></span> Today</span>
                <span><span class="calendar-legend selected"></span> Selected Date</span>
            </div>
        </div>
    </div>
</div>

<style>
    .calendar-table { width:100%; border-collapse:collapse; background:#111318; border-radius:12px; overflow:hidden; }
    .calendar-table th { padding:12px; text-align:center; color:#64748b; font-weight:600; font-size:12px; text-transform:uppercase; letter-spacing:.5px; background:#1e2333; border:1px solid #1e2130; }
    .calendar-table td { border:1px solid #1e2130; vertical-align:top; height:100px; width:14.28%; transition:background .2s; cursor:pointer; }
    .calendar-table td:hover { background:rgba(99,102,241,.05); }
    .calendar-table td.selected-date { background:rgba(99,102,241,.15); border:2px solid #6366f1; box-shadow:inset 0 0 0 1px #6366f1; }
    .calendar-date-cell { padding:8px; height:100%; display:flex; flex-direction:column; }
    .calendar-date-number { font-size:14px; font-weight:600; color:#e2e8f0; margin-bottom:6px; display:inline-flex; align-items:center; justify-content:center; width:28px; height:28px; border-radius:50%; }
    .calendar-date-number.today { background:#6366f1; color:white; }
    .calendar-date-number.selected { background:#818cf8; color:white; box-shadow:0 0 0 2px #6366f1; }
    .calendar-date-number.other-month { color:#374151; }
    .calendar-event-item { font-size:10px; padding:2px 4px; margin-bottom:2px; border-radius:4px; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; transition:all .2s; }
    .calendar-event-item:hover { transform:scale(1.02); filter:brightness(1.1); }
    .calendar-event-pending { background:rgba(245,158,11,.2); color:#f59e0b; border-left:2px solid #f59e0b; }
    .calendar-event-in_progress { background:rgba(99,102,241,.2); color:#818cf8; border-left:2px solid #6366f1; }
    .calendar-event-completed { background:rgba(34,197,94,.2); color:#22c55e; border-left:2px solid #22c55e; }
    .calendar-event-overdue { background:rgba(239,68,68,.2); color:#ef4444; border-left:2px solid #ef4444; animation:pulse 2s infinite; }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.7} }
    .calendar-legend { display:inline-block; width:12px; height:12px; border-radius:3px; margin-right:4px; }
    .calendar-legend.pending { background:#f59e0b; }
    .calendar-legend.in-progress { background:#6366f1; }
    .calendar-legend.completed { background:#22c55e; }
    .calendar-legend.overdue { background:#ef4444; }
    .calendar-legend.today { background:#6366f1; width:8px; height:8px; border-radius:50%; }
    .calendar-legend.selected { background:#818cf8; width:12px; height:12px; border-radius:3px; }
    .event-item { background:#1e2333; border-radius:10px; padding:12px; transition:all .2s; cursor:pointer; border-left:3px solid; }
    .event-item:hover { transform:translateX(4px); background:#252a3d; }
    .event-item.pending { border-left-color:#f59e0b; }
    .event-item.in_progress { border-left-color:#6366f1; }
    .event-item.completed { border-left-color:#22c55e; }
    .event-item.overdue { border-left-color:#ef4444; }
    .day-stat-badge { background:#1e2333; border-radius:8px; padding:8px 12px; text-align:center; flex:1; }
    .day-stat-badge .count { font-size:20px; font-weight:700; font-family:'Syne',sans-serif; }
    .calendar-container-shrink { flex:0.8 !important; }
    .side-panel-open { width:360px !important; opacity:1 !important; display:block !important; margin-left:20px !important; }
    @media (max-width:768px) { .calendar-table td { height:60px; } .calendar-event-item { font-size:8px; white-space:normal; } .side-panel-open { width:280px !important; } }
</style>

<script>
    var currentDate = new Date();
    var currentView = 'month';
    var allEventsData = [];
    var currentSelectedDate = null;
    var selectedDateStr = null;
    var isSidePanelOpen = false;

    document.addEventListener('DOMContentLoaded', function () {
        var today = new Date();
        currentDate = new Date(today.getFullYear(), today.getMonth(), 1);
        loadEventsAndRender();
    });

    function formatDateForAPI(date) {
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    async function loadEventsAndRender() {
        var startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        var endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

        var status = document.getElementById('statusFilter').value;
        var start = formatDateForAPI(startDate);
        var end = formatDateForAPI(endDate);

        var url = '/api/employee/compliance/my?page=0&size=100';
        var data = await api(url);

        if (data && data.success) {
            var compliances = data.data.content || [];

            allEventsData = compliances.map(function (c) {
                return {
                    id: c.id,
                    title: c.complianceName,
                    startDate: c.dueDate,
                    endDate: c.dueDate,
                    status: c.status,
                    category: c.category,
                    description: c.description,
                    isOverdue: c.overdue && c.status !== 'COMPLETED',
                    daysRemaining: c.daysRemaining,
                    periodInfo: c.periodInfo
                };
            }).filter(function (e) {
                return e.startDate && e.startDate >= start && e.startDate <= end;
            });

            if (status) {
                allEventsData = allEventsData.filter(function (e) { return e.status === status; });
            }

            renderCalendar();
        }
    }

    function renderCalendar() {
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth();

        var monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        document.getElementById('currentMonthYear').textContent = monthNames[month] + ' ' + year;

        var firstDay = new Date(year, month, 1);
        var startDayOfWeek = firstDay.getDay();
        var daysInMonth = new Date(year, month + 1, 0).getDate();

        var prevMonthDate = new Date(year, month, 0);
        var prevMonthDays = prevMonthDate.getDate();
        var prevMonthYear = prevMonthDate.getFullYear();
        var prevMonth = prevMonthDate.getMonth();

        var calendarHtml = '<table class="calendar-table">';
        calendarHtml += '<thead><tr>';
        var weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        for (var i = 0; i < weekDays.length; i++) { calendarHtml += '<th>' + weekDays[i] + '</th>'; }
        calendarHtml += '</tr></thead><tbody><tr>';

        var dayCount = 1;
        var nextMonthDayCount = 1;

        for (var i = 0; i < 42; i++) {
            var cellDate = null;
            var isCurrentMonth = false;
            var displayDay = null;
            var cellYear = year;
            var cellMonth = month;

            if (i < startDayOfWeek) {
                displayDay = prevMonthDays - (startDayOfWeek - i) + 1;
                cellYear = prevMonthYear;
                cellMonth = prevMonth;
                cellDate = new Date(cellYear, cellMonth, displayDay);
                isCurrentMonth = false;
            } else if (dayCount <= daysInMonth) {
                displayDay = dayCount;
                cellDate = new Date(year, month, displayDay);
                isCurrentMonth = true;
                dayCount++;
            } else {
                displayDay = nextMonthDayCount;
                var nextMonthDate = new Date(year, month + 1, displayDay);
                cellYear = nextMonthDate.getFullYear();
                cellMonth = nextMonthDate.getMonth();
                cellDate = new Date(cellYear, cellMonth, displayDay);
                isCurrentMonth = false;
                nextMonthDayCount++;
            }

            var dateStr = cellYear + '-' + String(cellMonth + 1).padStart(2, '0') + '-' + String(displayDay).padStart(2, '0');
            var isToday = isTodayDate(cellYear, cellMonth, displayDay);
            var isSelected = (selectedDateStr === dateStr);

            var eventsOnDate = allEventsData.filter(function (e) { return e.startDate === dateStr; });

            var cellClass = '';
            if (!isCurrentMonth) cellClass += ' other-month';
            if (isSelected) cellClass += ' selected-date';

            calendarHtml += '<td class="' + cellClass + '" data-date="' + dateStr + '" data-year="' + cellYear + '" data-month="' + cellMonth + '" data-day="' + displayDay + '">';
            calendarHtml += '<div class="calendar-date-cell">';

            var dateNumberClass = 'calendar-date-number';
            if (isToday) dateNumberClass += ' today';
            if (isSelected) dateNumberClass += ' selected';
            if (!isCurrentMonth) dateNumberClass += ' other-month';

            calendarHtml += '<div class="' + dateNumberClass + '">' + displayDay + '</div>';

            for (var e = 0; e < Math.min(eventsOnDate.length, 3); e++) {
                var event = eventsOnDate[e];
                var eventClass = getEventClassForCalendar(event.status);
                calendarHtml += '<div class="calendar-event-item ' + eventClass + '" data-event-id="' + event.id + '" data-event-title="' + escapeHtml(event.title) + '">';
                calendarHtml += '<i class="fas fa-circle" style="font-size:6px;margin-right:4px;"></i> ' + escapeHtml(event.title);
                calendarHtml += '</div>';
            }
            if (eventsOnDate.length > 3) {
                calendarHtml += '<div style="font-size:9px;color:#64748b;margin-top:2px;">+' + (eventsOnDate.length - 3) + ' more...</div>';
            }

            calendarHtml += '</div></td>';
            if ((i + 1) % 7 === 0 && i < 41) { calendarHtml += '</tr><tr>'; }
        }

        calendarHtml += '</tr></tbody></table>';
        document.getElementById('calendarTable').innerHTML = calendarHtml;
        attachCalendarClickEvents();
    }

    function attachCalendarClickEvents() {
        var cells = document.querySelectorAll('.calendar-table td');
        for (var i = 0; i < cells.length; i++) {
            cells[i].removeEventListener('click', handleCellClick);
            cells[i].addEventListener('click', handleCellClick);
        }
        var events = document.querySelectorAll('.calendar-event-item');
        for (var i = 0; i < events.length; i++) {
            events[i].removeEventListener('click', handleEventClick);
            events[i].addEventListener('click', handleEventClick);
        }
    }

    function handleCellClick(e) {
        if (e.target.classList.contains('calendar-event-item')) { return; }
        e.stopPropagation();
        var dateStr = this.getAttribute('data-date');
        var year = parseInt(this.getAttribute('data-year'));
        var month = parseInt(this.getAttribute('data-month'));
        var day = parseInt(this.getAttribute('data-day'));
        if (dateStr && !isNaN(year) && !isNaN(month) && !isNaN(day)) {
            selectDate(dateStr, year, month, day);
        }
    }

    function handleEventClick(e) {
        e.stopPropagation();
        var eventId = this.getAttribute('data-event-id');
        if (eventId) {
            window.location.href = contextPath + '/employee/compliance/' + eventId;
        }
    }

    function selectDate(dateStr, year, month, day) {
        selectedDateStr = dateStr;
        currentSelectedDate = new Date(year, month, day);
        var displayDate = new Date(year, month, day);
        var formattedDate = displayDate.toLocaleDateString('en-IN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
        document.getElementById('selectedDateTitle').textContent = formattedDate;

        var dayEvents = allEventsData.filter(function (event) { return event.startDate === dateStr; });
        updateDayStats(dayEvents);
        renderDayEvents(dayEvents);
        openSidePanel();
        renderCalendar();
    }

    function isTodayDate(year, month, day) {
        var today = new Date();
        return year === today.getFullYear() && month === today.getMonth() && day === today.getDate();
    }

    function getEventClassForCalendar(status) {
        switch (status) {
            case 'PENDING': return 'calendar-event-pending';
            case 'IN_PROGRESS': return 'calendar-event-in_progress';
            case 'COMPLETED': return 'calendar-event-completed';
            case 'OVERDUE': return 'calendar-event-overdue';
            default: return 'calendar-event-pending';
        }
    }

    function updateDayStats(events) {
        var total = events.length;
        var pending = events.filter(function (e) { return e.status === 'PENDING'; }).length;
        var inProgress = events.filter(function (e) { return e.status === 'IN_PROGRESS'; }).length;
        var completed = events.filter(function (e) { return e.status === 'COMPLETED'; }).length;
        var overdue = events.filter(function (e) { return e.status === 'OVERDUE'; }).length;

        var statsHtml = `
            <div class="day-stat-badge"><div class="count" style="color:#818cf8;">${total}</div><div style="font-size:10px;">Total</div></div>
            <div class="day-stat-badge"><div class="count" style="color:#f59e0b;">${pending}</div><div style="font-size:10px;">Pending</div></div>
            <div class="day-stat-badge"><div class="count" style="color:#818cf8;">${inProgress}</div><div style="font-size:10px;">In Progress</div></div>
            <div class="day-stat-badge"><div class="count" style="color:#22c55e;">${completed}</div><div style="font-size:10px;">Completed</div></div>
            <div class="day-stat-badge"><div class="count" style="color:#ef4444;">${overdue}</div><div style="font-size:10px;">Overdue</div></div>
        `;
        document.getElementById('dayStats').innerHTML = statsHtml;
    }

    function renderDayEvents(events) {
        var container = document.getElementById('dayEventsList');
        if (!events.length) {
            container.innerHTML = '<div class="empty-state" style="padding:40px;">' +
                '<i class="fas fa-calendar-day" style="font-size:36px;opacity:0.3;"></i>' +
                '<p style="margin-top:10px;">No events on this day</p></div>';
            return;
        }
        var html = '';
        for (var i = 0; i < events.length; i++) {
            var e = events[i];
            var statusClass = getEventClassForCalendar(e.status).replace('calendar-event-', '');
            var badgeClass = e.status === 'PENDING' ? 'badge-pending' : e.status === 'COMPLETED' ? 'badge-active' : 'badge-info';
            var statusDisplay = getStatusDisplay(e.status);

            html += '<div class="event-item ' + statusClass + '" onclick="window.location.href=\'' + contextPath + '/employee/compliance/' + e.id + '\'">' +
                '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:8px;">' +
                '<strong style="font-size:14px;">' + escapeHtml(e.title) + '</strong>' +
                '<span class="badge ' + badgeClass + '" style="font-size:10px;">' + statusDisplay + '</span>' +
                '</div>' +
                (e.description ? '<div style="font-size:12px;color:#94a3b8;margin-bottom:8px;">' + escapeHtml(e.description) + '</div>' : '') +
                '<div style="font-size:11px;color:#64748b;">' +
                '<i class="fas fa-tag"></i> ' + escapeHtml(e.category) + '<br>' +
                (e.periodInfo ? '<i class="fas fa-calendar-week"></i> ' + escapeHtml(e.periodInfo) : '') +
                '</div>' +
                '</div>';
        }
        container.innerHTML = html;
    }

    function getStatusDisplay(status) {
        var display = { 'PENDING': 'Pending', 'IN_PROGRESS': 'In Progress', 'COMPLETED': 'Completed', 'OVERDUE': 'Overdue' };
        return display[status] || status;
    }

    function openSidePanel() {
        var container = document.getElementById('calendarContainer');
        var panel = document.getElementById('sidePanel');
        container.classList.add('calendar-container-shrink');
        panel.classList.add('side-panel-open');
        isSidePanelOpen = true;
    }

    function closeSidePanel() {
        var container = document.getElementById('calendarContainer');
        var panel = document.getElementById('sidePanel');
        container.classList.remove('calendar-container-shrink');
        panel.classList.remove('side-panel-open');
        isSidePanelOpen = false;
        selectedDateStr = null;
        currentSelectedDate = null;
        renderCalendar();
    }

    function previousMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
        selectedDateStr = null;
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
    }

    function nextMonth() {
        currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
        selectedDateStr = null;
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
    }

    function goToToday() {
        var today = new Date();
        currentDate = new Date(today.getFullYear(), today.getMonth(), 1);
        selectedDateStr = null;
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
        setTimeout(function () {
            var todayStr = formatDateForAPI(today);
            selectDate(todayStr, today.getFullYear(), today.getMonth(), today.getDate());
        }, 100);
    }

    function changeView() {
        currentView = document.getElementById('viewSelect').value;
        if (currentView === 'month') { loadEventsAndRender(); }
        else if (currentView === 'week') { toast('Week view coming soon!', 'info'); }
        else if (currentView === 'day') { toast('Day view coming soon!', 'info'); }
    }

    function refreshCalendar() {
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
        toast('Calendar refreshed', 'info');
    }

    function resetFilters() {
        document.getElementById('statusFilter').value = '';
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
        toast('Filters reset', 'info');
    }

    function exportCalendarData() {
        if (!allEventsData.length) { toast('No data to export', 'error'); return; }
        var rows = [['Date', 'Compliance Name', 'Category', 'Status', 'Description', 'Period']];
        for (var i = 0; i < allEventsData.length; i++) {
            var e = allEventsData[i];
            rows.push([e.startDate, e.title, e.category, getStatusDisplay(e.status), e.description || '—', e.periodInfo || '—']);
        }
        var csv = rows.map(function (row) { return row.map(function (cell) { return '"' + String(cell).replace(/"/g, '""') + '"'; }).join(','); }).join('\n');
        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement('a');
        var url = URL.createObjectURL(blob);
        link.href = url;
        link.setAttribute('download', 'my_compliance_calendar.csv');
        document.body.appendChild(link); link.click(); document.body.removeChild(link);
        URL.revokeObjectURL(url);
        toast('Export complete', 'success');
    }

    function escapeHtml(str) { if (!str) return ''; return String(str).replace(/[&<>]/g, function (m) { if (m === '&') return '&amp;'; if (m === '<') return '&lt;'; if (m === '>') return '&gt;'; return m; }); }

    document.getElementById('statusFilter').addEventListener('change', function () {
        loadEventsAndRender();
        if (isSidePanelOpen) closeSidePanel();
    });

    document.addEventListener('click', function (e) {
        var panel = document.getElementById('sidePanel');
        var calendarContainer = document.getElementById('calendarContainer');
        if (isSidePanelOpen && panel && !panel.contains(e.target) && calendarContainer && !calendarContainer.contains(e.target)) {
            closeSidePanel();
        }
    });
</script>

<%@ include file="../fragments/footer.jsp" %>