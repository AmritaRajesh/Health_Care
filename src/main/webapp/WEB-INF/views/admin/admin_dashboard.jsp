<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.stat-card { background: white; border-radius: 12px; padding: 20px 22px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border: 1px solid #f1f5f9; text-decoration: none; color: inherit; transition: 0.2s; }
.stat-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); transform: translateY(-2px); }
.stat-info .title { color: #94a3b8; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
.stat-info .value { font-size: 1.8rem; font-weight: 700; color: #1e293b; }
.stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; color: white; flex-shrink: 0; }
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; margin-top: 24px; }
.card-header-view { padding: 18px 22px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
.card-title-view { font-size: 1rem; font-weight: 700; color: #1e293b; margin: 0; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 20px; border-bottom: 1px solid #f1f5f9; border-top: none; }
.table td { padding: 14px 20px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.badge-status { padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; text-transform: capitalize; }
.s-pending { background: #fffbeb; color: #d97706; } .s-approved { background: #ecfdf5; color: #059669; }
.s-completed { background: #eff6ff; color: #2563eb; } .s-rejected { background: #fef2f2; color: #dc2626; }
.quick-btn { display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 20px; background: white; border: 1px solid #e2e8f0; border-radius: 12px; text-decoration: none; color: #475569; font-weight: 600; font-size: 0.85rem; transition: 0.2s; }
.quick-btn:hover { background: #6366f1; color: white; border-color: #6366f1; }
.quick-btn i { font-size: 1.5rem; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Executive Dashboard</h1>
    <p class="page-subtitle">Hospital-wide metrics and system overview</p>

    <!-- Stat Cards Row 1 -->
    <div class="row g-3">
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="stat-card">
                <div class="stat-info"><div class="title">Total Doctors</div><div class="value">${stats.doctors != null ? stats.doctors : 0}</div></div>
                <div class="stat-icon" style="background:#6366f1;"><i class="fa-solid fa-user-doctor"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/patients" class="stat-card">
                <div class="stat-info"><div class="title">Registered Patients</div><div class="value">${stats.patients != null ? stats.patients : 0}</div></div>
                <div class="stat-icon" style="background:#10b981;"><i class="fa-solid fa-hospital-user"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/appointments" class="stat-card">
                <div class="stat-info"><div class="title">Total Appointments</div><div class="value">${stats.appointments != null ? stats.appointments : 0}</div></div>
                <div class="stat-icon" style="background:#f59e0b;"><i class="fa-regular fa-calendar-check"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/appointments" class="stat-card">
                <div class="stat-info"><div class="title">Pending Approvals</div><div class="value">${stats.pending != null ? stats.pending : 0}</div></div>
                <div class="stat-icon" style="background:#ef4444;"><i class="fa-regular fa-clock"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/departments" class="stat-card">
                <div class="stat-info"><div class="title">Departments</div><div class="value">${stats.departments != null ? stats.departments : 0}</div></div>
                <div class="stat-icon" style="background:#0ea5e9;"><i class="fa-solid fa-building-columns"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/staff" class="stat-card">
                <div class="stat-info"><div class="title">Active Staff</div><div class="value">${stats.staff != null ? stats.staff : 0}</div></div>
                <div class="stat-icon" style="background:#8b5cf6;"><i class="fa-solid fa-people-group"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/billing" class="stat-card">
                <div class="stat-info"><div class="title">Revenue Collected</div><div class="value">₹${stats.revenue != null ? stats.revenue : 0}</div></div>
                <div class="stat-icon" style="background:#059669;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/admin/billing" class="stat-card">
                <div class="stat-info"><div class="title">Pending Dues</div><div class="value">₹${stats.unpaid != null ? stats.unpaid : 0}</div></div>
                <div class="stat-icon" style="background:#dc2626;"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            </a>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="content-card mt-4">
        <div class="card-header-view"><h3 class="card-title-view">Quick Actions</h3></div>
        <div class="p-4">
            <div class="row g-3">
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/add-doctor" class="quick-btn">
                        <i class="fa-solid fa-user-plus"></i>Add Doctor
                    </a>
                </div>
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="quick-btn">
                        <i class="fa-regular fa-calendar-check"></i>Appointments
                    </a>
                </div>
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/billing" class="quick-btn">
                        <i class="fa-solid fa-file-invoice-dollar"></i>Billing
                    </a>
                </div>
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/departments" class="quick-btn">
                        <i class="fa-solid fa-building-columns"></i>Departments
                    </a>
                </div>
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/analytics" class="quick-btn">
                        <i class="fa-solid fa-chart-line"></i>Analytics
                    </a>
                </div>
                <div class="col-6 col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/users" class="quick-btn">
                        <i class="fa-solid fa-users-gear"></i>Users
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Appointments -->
    <div class="content-card">
        <div class="card-header-view">
            <h3 class="card-title-view">Recent Appointments</h3>
            <a href="${pageContext.request.contextPath}/admin/appointments" class="text-primary fw-bold text-decoration-none" style="font-size:0.85rem;">View All &rarr;</a>
        </div>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead><tr><th>Patient</th><th>Doctor</th><th>Date</th><th>Status</th></tr></thead>
                <tbody>
                    <c:forEach var="a" items="${recentAppts}">
                        <tr>
                            <td class="fw-bold">${a.patientName}</td>
                            <td style="color:#6366f1;">Dr. ${a.doctorName}</td>
                            <td>${a.appointmentDate} <span class="text-muted small">${a.timeSlot}</span></td>
                            <td><span class="badge-status s-${a.status}">${a.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentAppts}">
                        <tr><td colspan="4" class="text-center text-muted p-4">No appointments yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
</body>
</html>
