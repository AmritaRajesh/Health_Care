<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Records - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.patient-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; transition: 0.2s; }
.patient-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); transform: translateY(-2px); }
.avatar { width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.2rem; }
.patient-name { font-weight: 700; color: #1e293b; font-size: 1rem; }
.patient-info { color: #64748b; font-size: 0.85rem; }
.btn-view { background: #10b981; color: white; border: none; padding: 7px 16px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; text-decoration: none; }
.btn-view:hover { background: #059669; color: white; }
.empty-state { text-align: center; padding: 60px; color: #94a3b8; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Patient Records</h1>
    <p class="page-subtitle">All patients who have booked appointments with you</p>

    <c:if test="${empty patientList}">
        <div class="empty-state">
            <i class="fa-solid fa-users fs-1 mb-3"></i>
            <h5 class="fw-bold">No Patients Yet</h5>
            <p>Patients will appear here once they book appointments with you.</p>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="p" items="${patientList}">
            <div class="col-md-6 col-lg-4">
                <div class="patient-card">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="avatar">${p.fullName.substring(0,1).toUpperCase()}</div>
                        <div>
                            <div class="patient-name">${p.fullName}</div>
                            <div class="patient-info"><i class="fa-solid fa-envelope me-1"></i>${p.email}</div>
                        </div>
                    </div>
                    <div class="patient-info mb-3">
                        <i class="fa-solid fa-phone me-1"></i>${p.phone}
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/doctor/medical-history?patientId=${p.id}" class="btn-view">
                            <i class="fa-solid fa-file-medical me-1"></i>Medical History
                        </a>
                        <a href="${pageContext.request.contextPath}/doctor/patient-history?id=${p.id}" class="btn btn-sm btn-outline-secondary fw-bold">
                            <i class="fa-solid fa-clock-rotate-left me-1"></i>Appointments
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div></div>
</body>
</html>
