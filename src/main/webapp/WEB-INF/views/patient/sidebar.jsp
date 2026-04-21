<%@ page import="com.hms.model.User" %>
<%@ page import="com.hms.dao.NotificationDAO" %>
<%
    User loggedInUser = (User) session.getAttribute("userObj");
    int unreadCount = 0;
    if (loggedInUser != null) {
        unreadCount = new NotificationDAO().getUnreadCount(loggedInUser.getId());
    }
%>
<style>
body { background-color: #f8fafc; margin: 0; font-family: 'Inter', system-ui, -apple-system, sans-serif; }
.dash-navbar { background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.05); padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; }
.brand-logo { font-weight: 700; font-size: 1.25rem; color: #1a1f36; display: flex; align-items: center; gap: 8px; text-decoration: none; }
.brand-icon { background: #2b7cff; color: white; padding: 6px 10px; border-radius: 8px; font-size: 1rem; }
.nav-links { display: flex; gap: 30px; align-items: center; }
.nav-links a { color: #475569; text-decoration: none; font-weight: 500; font-size: 0.95rem; }
.nav-links a:hover { color: #2b7cff; }
.user-profile-nav { display: flex; align-items: center; gap: 15px; border-left: 1px solid #e2e8f0; padding-left: 20px; }
.role-badge { background: #e0ecff; color: #2b7cff; padding: 3px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }
.dashboard-container { display: flex; min-height: calc(100vh - 65px); }
.sidebar { width: 260px; background: white; border-right: 1px solid #e2e8f0; padding: 30px 20px; flex-shrink: 0; }
.sidebar-title { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin-bottom: 25px; padding-left: 15px; }
.sidebar-menu { list-style: none; padding: 0; margin: 0; }
.sidebar-menu li { margin-bottom: 8px; }
.sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 12px 15px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 500; transition: all 0.2s; }
.sidebar-menu a:hover, .sidebar-menu a.active { background: #3b82f6; color: white; }
.main-content { flex: 1; padding: 40px; background: #f8fafc; }
.page-title { font-size: 1.75rem; font-weight: 700; color: #1e293b; margin-bottom: 6px; }
.page-subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 30px; }
.notif-badge { background: #ef4444; color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700; padding: 2px 6px; margin-left: auto; }
</style>

<nav class="dash-navbar">
    <a href="${pageContext.request.contextPath}/" class="brand-logo">
        <div class="brand-icon"><i class="fa-solid fa-h"></i>+</div>
        Hospital Management
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
        <div class="user-profile-nav">
            <span class="d-flex align-items-center gap-2 text-dark fw-bold">
                <i class="fa-regular fa-user-circle fs-4 text-secondary"></i>
                <%= (loggedInUser != null) ? loggedInUser.getFullName() : "Guest" %>
                <span class="role-badge">patient</span>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="text-danger fw-bold text-decoration-none">
                <i class="fa fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="dashboard-container">
<div class="sidebar">
    <div class="sidebar-title">Patient Portal</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="${activeMenu eq 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-border-all"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/book-appointment" class="${activeMenu eq 'book_appointment' ? 'active' : ''}">
                <i class="fa-regular fa-calendar-plus"></i> Book Appointment
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/appointments" class="${activeMenu eq 'appointments' ? 'active' : ''}">
                <i class="fa-regular fa-calendar-check"></i> My Appointments
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/doctors" class="${activeMenu eq 'doctors' ? 'active' : ''}">
                <i class="fa-solid fa-user-doctor"></i> Doctor Search
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/medical-records" class="${activeMenu eq 'medical_records' ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> Medical Records
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/prescriptions" class="${activeMenu eq 'prescriptions' ? 'active' : ''}">
                <i class="fa-solid fa-prescription-bottle-medical"></i> Prescriptions
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/billing" class="${activeMenu eq 'billing' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice-dollar"></i> Billing
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/lab-tests" class="${activeMenu eq 'lab-tests' ? 'active' : ''}">
                <i class="fa-solid fa-flask"></i> Lab Tests
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/reminders" class="${activeMenu eq 'reminders' ? 'active' : ''}">
                <i class="fa-solid fa-bell-concierge"></i> Reminders
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/chat" class="${activeMenu eq 'chat' ? 'active' : ''}">
                <i class="fa-regular fa-comments"></i> Chat
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/feedback" class="${activeMenu eq 'feedback' ? 'active' : ''}">
                <i class="fa-regular fa-star"></i> Feedback
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/notifications" class="${activeMenu eq 'notifications' ? 'active' : ''}">
                <i class="fa-regular fa-bell"></i> Notifications
                <% if (unreadCount > 0) { %>
                    <span class="notif-badge"><%= unreadCount %></span>
                <% } %>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patient/profile" class="${activeMenu eq 'profile' ? 'active' : ''}">
                <i class="fa-regular fa-user"></i> Profile
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </li>
    </ul>
</div>

<div class="main-content">
