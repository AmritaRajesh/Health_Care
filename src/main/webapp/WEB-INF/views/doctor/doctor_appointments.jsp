<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Appointments - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; padding:20px; }
.search-bar { display:flex; gap:15px; margin-bottom: 25px; }
.search-input { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 15px; width: 100%; max-width: 500px; display:flex; align-items:center; gap:10px; }
.search-input input { border:none; background:transparent; outline:none; width:100%; color:#475569; }
.filter-select { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 15px; color:#475569; outline:none; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 16px 20px; border-bottom: 1px solid #f1f5f9; border-top:none; }
.table td { padding: 16px 20px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.badge-status { padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
.s-pending { background: #fffbeb; color: #d97706; }
.s-approved { background: #ecfdf5; color: #059669; }
.s-completed { background: #eff6ff; color: #2563eb; }
.s-rejected { background: #fef2f2; color: #dc2626; }
.action-btn { background:none; border:none; font-size:1.1rem; margin-right:8px; cursor:pointer; }
.btn-approve { color: #10b981; } .btn-approve:hover { color: #059669; }
.btn-reject { color: #ef4444; } .btn-reject:hover { color: #dc2626; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">My Appointments</h1>
        <p class="page-subtitle">Manage your scheduled appointments</p>
        
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">${successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="content-card">
            
            <div class="search-bar">
                <div class="search-input">
                    <i class="fa-solid fa-search text-muted"></i>
                    <input type="text" placeholder="Search by patient name...">
                </div>
                <select class="filter-select">
                    <option>All Status</option>
                    <option>Pending</option>
                    <option>Approved</option>
                    <option>Completed</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table mb-0">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Reason</th>
                            <th>Date & Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${apptList}">
                            <tr>
                                <td class="fw-bold text-dark">${a.patientName}</td>
                                <td>${a.reason}</td>
                                <td>
                                    <div class="fw-bold text-dark">${a.appointmentDate}</div>
                                    <div class="text-muted small">${a.timeSlot}</div>
                                </td>
                                <td>
                                    <span class="badge-status s-${a.status}">${a.status}</span>
                                </td>
                                <td>
                                    <c:if test="${a.status eq 'pending'}">
                                        <form action="${pageContext.request.contextPath}/doctor/appointments" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <input type="hidden" name="status" value="approved">
                                            <button type="submit" class="action-btn btn-approve" title="Approve"><i class="fa-regular fa-circle-check"></i></button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/doctor/appointments" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <input type="hidden" name="status" value="rejected">
                                            <button type="submit" class="action-btn btn-reject" title="Reject"><i class="fa-regular fa-circle-xmark"></i></button>
                                        </form>
                                    </c:if>
                                    <c:if test="${a.status eq 'approved'}">
                                        <form action="${pageContext.request.contextPath}/doctor/appointments" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <input type="hidden" name="status" value="completed">
                                            <button type="submit" class="btn btn-sm btn-outline-success fw-bold me-1" title="Mark Completed">
                                                <i class="fa-solid fa-check me-1"></i>Complete
                                            </button>
                                        </form>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/doctor/patient-history?id=${a.patientId}" class="btn btn-sm btn-outline-primary fw-bold" title="Patient History"><i class="fa-solid fa-clock-rotate-left me-1"></i>History</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty apptList}">
                            <tr><td colspan="5" class="text-center text-muted p-4">No appointments found.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->

</body>
</html>
