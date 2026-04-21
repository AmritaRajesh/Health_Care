<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hms.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("userObj");
%>
<style>
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 60px;
    background: white;
    color: black;
    flex-wrap: wrap;
    box-shadow: 0 1px 4px rgba(0,0,0,0.08);
    position: sticky;
    top: 0;
    z-index: 999;
}
.logo { display: flex; align-items: center; font-weight: bold; text-decoration: none; color: black; }
.logo-box { background: #0d6efd; color: white; padding: 8px 12px; border-radius: 8px; margin-right: 10px; }
.logo-text { font-size: 18px; }
.nav-links { display: flex; align-items: center; gap: 4px; }
.nav-links a { padding: 7px 14px; text-decoration: none; color: #374151; font-weight: 500; border-radius: 8px; transition: 0.2s; }
.nav-links a:hover { background: #f1f5f9; color: #0d6efd; }
.register-btn { background: #0d6efd; color: white !important; padding: 8px 16px; border-radius: 8px; }
.register-btn:hover { background: #1d4ed8 !important; }
.active-link { color: #0d6efd !important; font-weight: 700; }
.user-pill { display: flex; align-items: center; gap: 10px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 30px; padding: 6px 14px; font-size: 0.88rem; }
.user-pill .name { font-weight: 600; color: #1e293b; }
.role-tag { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; padding: 2px 8px; border-radius: 20px; }
.role-admin   { background: #e0e7ff; color: #4f46e5; }
.role-doctor  { background: #dcfce7; color: #16a34a; }
.role-patient { background: #dbeafe; color: #2563eb; }
.dash-link { background: #0d6efd; color: white !important; padding: 7px 14px; border-radius: 8px; font-weight: 600; text-decoration: none; font-size: 0.88rem; }
.dash-link:hover { background: #1d4ed8 !important; }
.logout-link { color: #ef4444 !important; font-weight: 600; }
.logout-link:hover { background: #fef2f2 !important; color: #dc2626 !important; }
</style>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-box">H+</span>
        <span class="logo-text">Hospital Management</span>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home"
           class="${activePage == 'home' ? 'active-link' : ''}">Home</a>
        <a href="${pageContext.request.contextPath}/about"
           class="${activePage == 'about' ? 'active-link' : ''}">About</a>
        <a href="${pageContext.request.contextPath}/contact"
           class="${activePage == 'contact' ? 'active-link' : ''}">Contact</a>

        <% if (loggedInUser != null) { %>
            <%-- Logged-in: show user pill + dashboard link + logout --%>
            <div class="user-pill">
                <i class="fa-regular fa-circle-user" style="font-size:1.1rem;color:#64748b;"></i>
                <span class="name"><%= loggedInUser.getFullName() %></span>
                <span class="role-tag role-<%= loggedInUser.getRole() %>"><%= loggedInUser.getRole() %></span>
            </div>

            <% if ("admin".equals(loggedInUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="dash-link">
                    <i class="fa-solid fa-gauge-high me-1"></i>Dashboard
                </a>
            <% } else if ("doctor".equals(loggedInUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/doctor/dashboard" class="dash-link">
                    <i class="fa-solid fa-gauge-high me-1"></i>Dashboard
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="dash-link">
                    <i class="fa-solid fa-gauge-high me-1"></i>Dashboard
                </a>
            <% } %>

            <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                <i class="fa-solid fa-right-from-bracket me-1"></i>Logout
            </a>

        <% } else { %>
            <%-- Guest: show Login + Register --%>
            <a href="${pageContext.request.contextPath}/login"
               class="${activePage == 'login' ? 'active-link' : ''}">Login</a>
            <a href="${pageContext.request.contextPath}/register"
               class="register-btn">Register</a>
        <% } %>
    </div>
</nav>

<%-- Font Awesome (needed on public pages that don't load Bootstrap) --%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
