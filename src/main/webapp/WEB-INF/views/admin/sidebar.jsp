<%@ page import="com.hms.model.User" %>
<%@ page import="com.hms.dao.EmergencyDAO" %>
<%
    User loggedInUser = (User) session.getAttribute("userObj");
%>
<style>
body { background-color: #f8fafc; margin: 0; font-family: 'Inter', system-ui, -apple-system, sans-serif; }
.dash-navbar { background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.05); padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; }
.brand-logo { font-weight: 700; font-size: 1.25rem; color: #1a1f36; display: flex; align-items: center; gap: 8px; text-decoration: none; }
.brand-icon { background: #6366f1; color: white; padding: 6px 10px; border-radius: 8px; font-size: 1rem; }
.nav-links { display: flex; gap: 30px; align-items: center; }
.nav-links a { color: #475569; text-decoration: none; font-weight: 500; font-size: 0.95rem; }
.nav-links a:hover { color: #6366f1; }
.user-profile-nav { display: flex; align-items: center; gap: 15px; border-left: 1px solid #e2e8f0; padding-left: 20px; }
.role-badge { background: #e0e7ff; color: #4f46e5; padding: 3px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }
.dashboard-container { display: flex; min-height: calc(100vh - 65px); }
.sidebar { width: 260px; background: white; border-right: 1px solid #e2e8f0; padding: 24px 16px; flex-shrink: 0; overflow-y: auto; }
.sidebar-title { font-size: 0.7rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px; padding-left: 12px; }
.sidebar-menu { list-style: none; padding: 0; margin: 0 0 20px 0; }
.sidebar-menu li { margin-bottom: 4px; }
.sidebar-menu a { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; color: #475569; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; }
.sidebar-menu a:hover, .sidebar-menu a.active { background: #6366f1; color: white; }
.main-content { flex: 1; padding: 40px; background: #f8fafc; }
.page-title { font-size: 1.75rem; font-weight: 700; color: #1e293b; margin-bottom: 6px; }
.page-subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 30px; }
</style>

<nav class="dash-navbar">
    <a href="${pageContext.request.contextPath}/" class="brand-logo">
        <div class="brand-icon"><i class="fa-solid fa-h"></i>+</div>
        Hospital Admin
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <div class="user-profile-nav">
            <span class="d-flex align-items-center gap-2 text-dark fw-bold">
                <i class="fa-solid fa-user-shield fs-4 text-secondary"></i>
                <%= (loggedInUser != null) ? loggedInUser.getFullName() : "Administrator" %>
                <span class="role-badge">admin</span>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="text-danger fw-bold text-decoration-none">
                <i class="fa fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="dashboard-container">
<div class="sidebar">
    <div class="sidebar-title">Main</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="${activeMenu eq 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> Dashboard
            </a>
        </li>
    </ul>

    <div class="sidebar-title">Hospital</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="${activeMenu eq 'doctors' ? 'active' : ''}">
                <i class="fa-solid fa-user-doctor"></i> Manage Doctors
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/patients" class="${activeMenu eq 'patients' ? 'active' : ''}">
                <i class="fa-solid fa-hospital-user"></i> Manage Patients
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/appointments" class="${activeMenu eq 'appointments' ? 'active' : ''}">
                <i class="fa-regular fa-calendar-check"></i> Appointments
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/departments" class="${activeMenu eq 'departments' ? 'active' : ''}">
                <i class="fa-solid fa-building-columns"></i> Departments
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/staff" class="${activeMenu eq 'staff' ? 'active' : ''}">
                <i class="fa-solid fa-people-group"></i> Staff
            </a>
        </li>
    </ul>

    <div class="sidebar-title">Finance & Reports</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/billing" class="${activeMenu eq 'billing' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice-dollar"></i> Billing
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/analytics" class="${activeMenu eq 'analytics' ? 'active' : ''}">
                <i class="fa-solid fa-chart-line"></i> Analytics
            </a>
        </li>
    </ul>

    <div class="sidebar-title">Operations</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/rooms" class="${activeMenu eq 'rooms' ? 'active' : ''}">
                <i class="fa-solid fa-bed"></i> Rooms & Beds
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/emergency" class="${activeMenu eq 'emergency' ? 'active' : ''}">
                <i class="fa-solid fa-truck-medical"></i> Emergency
                <% int ec = new com.hms.dao.EmergencyDAO().getOpenCount(); if(ec>0){ %><span style="background:#ef4444;color:white;border-radius:50%;font-size:0.65rem;font-weight:700;padding:2px 6px;margin-left:auto;"><%= ec %></span><% } %>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/feedback" class="${activeMenu eq 'feedback' ? 'active' : ''}">
                <i class="fa-regular fa-comment-dots"></i> Feedback
            </a>
        </li>
    </ul>

    <div class="sidebar-title">System</div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/users" class="${activeMenu eq 'users' ? 'active' : ''}">
                <i class="fa-solid fa-users-gear"></i> User Management
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/profile" class="${activeMenu eq 'profile' ? 'active' : ''}">
                <i class="fa-solid fa-gear"></i> Settings
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
