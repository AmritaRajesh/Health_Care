<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Appointments - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
.card-header-view { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.card-title-view { font-size: 1.15rem; font-weight: 700; color: #1e293b; margin: 0; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 16px 24px; border-bottom: 1px solid #f1f5f9; border-top:none; }
.table td { padding: 16px 24px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.badge-status { padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; text-transform:capitalize; }
.s-pending { background: #fffbeb; color: #d97706; }
.s-approved { background: #ecfdf5; color: #059669; }
.s-completed { background: #eff6ff; color: #2563eb; }
.s-rejected { background: #fef2f2; color: #dc2626; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">Appointment Oversight</h1>
        <p class="page-subtitle">Hospital-wide schedule monitor</p>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">${successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="content-card">
            <div class="card-header-view">
                <h3 class="card-title-view">All Recorded Appointments</h3>
            </div>
            
            <div class="table-responsive">
                <table class="table mb-0">
                    <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Attending Doctor</th>
                            <th>Date & Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${apptList}">
                            <tr>
                                <td class="fw-bold text-dark">${a.patientName}</td>
                                <td class="fw-bold" style="color:#6366f1;">Dr. ${a.doctorName}</td>
                                <td>
                                    <div class="fw-bold text-dark">${a.appointmentDate}</div>
                                    <div class="text-muted small">${a.timeSlot}</div>
                                </td>
                                <td><span class="badge-status s-${a.status}">${a.status}</span></td>
                                <td>
                                    <c:if test="${a.status eq 'pending'}">
                                        <form action="${pageContext.request.contextPath}/admin/appointments" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <input type="hidden" name="status" value="approved">
                                            <button type="submit" class="btn btn-sm btn-outline-success fw-bold me-1"><i class="fa-solid fa-check me-1"></i>Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/appointments" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <input type="hidden" name="status" value="rejected">
                                            <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-xmark me-1"></i>Cancel</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${a.status ne 'pending'}">
                                        <span class="text-muted small">—</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->
</body>
</html>
