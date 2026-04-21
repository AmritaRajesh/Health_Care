<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.hms.dao.NotificationDAO, com.hms.model.User" %>
<%
    User dashUser = (User) session.getAttribute("userObj");
    int dashUnread = dashUser != null ? new NotificationDAO().getUnreadCount(dashUser.getId()) : 0;
    request.setAttribute("dashUnread", dashUnread);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Dashboard - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.stat-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; border: 1px solid #f1f5f9; }
.stat-info .title { color: #94a3b8; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
.stat-info .value { font-size: 2rem; font-weight: 700; color: #1e293b; }
.stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: white; }
.icon-blue { background: #3b82f6; } .icon-green { background: #10b981; } .icon-orange { background: #f59e0b; } .icon-slate { background: #64748b; }
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; margin-top: 24px; }
.card-header-view { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
.card-title-view { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin: 0; }
.card-body-empty { padding: 60px 20px; text-align: center; color: #94a3b8; font-size: 1rem; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 16px 24px; border-bottom: 1px solid #f1f5f9; border-top:none; }
.table td { padding: 16px 24px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">Welcome, ${doctor.fullName}</h1>
        <p class="page-subtitle">${doctor.specialization} - Hospital</p>

        <div class="row g-4">
            <div class="col-md-2">
                <div class="stat-card">
                    <div class="stat-info">
                        <div class="title">Total Appts</div>
                        <div class="value">${doctor.totalAppointments}</div>
                    </div>
                    <div class="stat-icon icon-blue">
                        <i class="fa-regular fa-calendar-alt"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="stat-card">
                    <div class="stat-info">
                        <div class="title">Today</div>
                        <div class="value">${doctor.todayAppointments}</div>
                    </div>
                    <div class="stat-icon icon-green">
                        <i class="fa-regular fa-clock"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="stat-card">
                    <div class="stat-info">
                        <div class="title">Pending</div>
                        <div class="value">${doctor.pendingAppointments}</div>
                    </div>
                    <div class="stat-icon icon-orange">
                        <i class="fa-solid fa-users"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-info">
                        <div class="title">Completed</div>
                        <div class="value">${doctor.completedAppointments}</div>
                    </div>
                    <div class="stat-icon icon-slate">
                        <i class="fa-solid fa-check-circle"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/doctor/notifications" style="text-decoration:none;">
                <div class="stat-card">
                    <div class="stat-info">
                        <div class="title">Notifications</div>
                        <div class="value">${dashUnread}</div>
                    </div>
                    <div class="stat-icon" style="background:#8b5cf6;">
                        <i class="fa-regular fa-bell"></i>
                    </div>
                </div>
                </a>
            </div>
        </div>

        <div class="content-card">
            <div class="card-header-view">
                <h3 class="card-title-view">Upcoming Appointments</h3>
                <a href="${pageContext.request.contextPath}/doctor/appointments" class="text-primary fw-bold text-decoration-none" style="font-size:0.9rem;">View All &rarr;</a>
            </div>
            
            <c:if test="${empty upcomingList}">
                <div class="card-body-empty">
                    No upcoming appointments
                </div>
            </c:if>

            <c:if test="${not empty upcomingList}">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Reason</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${upcomingList}">
                                <tr>
                                    <td class="fw-bold">${a.patientName}</td>
                                    <td>${a.reason}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${a.appointmentDate}</div>
                                        <div class="text-muted small">${a.timeSlot}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill">approved</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

        <!-- Quick Actions -->
        <div class="content-card mt-4">
            <div class="card-header-view">
                <h3 class="card-title-view">Quick Actions</h3>
            </div>
            <div class="p-4 d-flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline-primary fw-bold">
                    <i class="fa-regular fa-calendar-check me-2"></i>View Appointments
                </a>
                <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline-success fw-bold">
                    <i class="fa-solid fa-users me-2"></i>Patient Records
                </a>
                <a href="${pageContext.request.contextPath}/doctor/prescriptions" class="btn btn-outline-info fw-bold">
                    <i class="fa-solid fa-prescription-bottle-medical me-2"></i>Add Prescription
                </a>
                <a href="${pageContext.request.contextPath}/doctor/medical-history" class="btn btn-outline-warning fw-bold">
                    <i class="fa-solid fa-file-medical me-2"></i>Medical History
                </a>
                <a href="${pageContext.request.contextPath}/doctor/reports" class="btn btn-outline-secondary fw-bold">
                    <i class="fa-solid fa-file-arrow-up me-2"></i>Upload Reports
                </a>
                <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-outline-dark fw-bold">
                    <i class="fa-regular fa-clock me-2"></i>Manage Availability
                </a>
            </div>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->

</body>
</html>
