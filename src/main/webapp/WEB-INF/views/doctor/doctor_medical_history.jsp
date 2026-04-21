<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Medical History - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.patient-select-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 24px; }
.patient-header { background: linear-gradient(135deg, #1e40af, #3b82f6); color: white; border-radius: 12px; padding: 24px; margin-bottom: 24px; display: flex; align-items: center; gap: 16px; }
.patient-avatar { width: 60px; height: 60px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 700; }
.section-title { font-weight: 700; color: #1e293b; font-size: 1.05rem; margin-bottom: 16px; }
.history-card { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; margin-bottom: 12px; }
.badge-status { padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.s-pending { background: #fffbeb; color: #d97706; }
.s-approved { background: #ecfdf5; color: #059669; }
.s-completed { background: #eff6ff; color: #2563eb; }
.s-rejected { background: #fef2f2; color: #dc2626; }
.rx-card { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 16px; margin-bottom: 12px; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Medical History</h1>
    <p class="page-subtitle">View past diagnoses, appointments, and prescriptions</p>

    <!-- Patient Selector -->
    <div class="patient-select-card">
        <form method="get" action="${pageContext.request.contextPath}/doctor/medical-history" class="row g-3 align-items-end">
            <div class="col-md-8">
                <label class="form-label fw-bold text-secondary">Select Patient</label>
                <select name="patientId" class="form-select" required>
                    <option value="">-- Choose a patient --</option>
                    <c:forEach var="p" items="${patientList}">
                        <option value="${p.id}" ${param.patientId == p.id ? 'selected' : ''}>${p.fullName} (${p.email})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-primary fw-bold w-100">
                    <i class="fa-solid fa-magnifying-glass me-2"></i>View History
                </button>
            </div>
        </form>
    </div>

    <c:if test="${not empty patient}">
        <!-- Patient Header -->
        <div class="patient-header">
            <div class="patient-avatar">${patient.fullName.substring(0,1).toUpperCase()}</div>
            <div>
                <h4 class="mb-1 fw-bold">${patient.fullName}</h4>
                <p class="mb-0 opacity-75">
                    <i class="fa-solid fa-envelope me-2"></i>${patient.email}
                    <span class="ms-3"><i class="fa-solid fa-phone me-2"></i>${patient.phone}</span>
                </p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Appointment History -->
            <div class="col-md-7">
                <div class="section-title"><i class="fa-solid fa-calendar-check text-primary me-2"></i>Appointment History</div>
                <c:if test="${empty historyList}">
                    <div class="text-muted text-center p-4 bg-white rounded border">No appointment history found.</div>
                </c:if>
                <c:forEach var="h" items="${historyList}">
                    <div class="history-card">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="fw-bold text-dark">${h.reason}</div>
                            <span class="badge-status s-${h.status}">${h.status}</span>
                        </div>
                        <div class="text-muted small">
                            <i class="fa-regular fa-calendar me-1"></i>${h.appointmentDate}
                            <span class="ms-3"><i class="fa-regular fa-clock me-1"></i>${h.timeSlot}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Prescriptions -->
            <div class="col-md-5">
                <div class="section-title"><i class="fa-solid fa-prescription-bottle-medical text-success me-2"></i>Prescriptions</div>
                <c:if test="${empty prescriptionList}">
                    <div class="text-muted text-center p-4 bg-white rounded border">No prescriptions found.</div>
                </c:if>
                <c:forEach var="rx" items="${prescriptionList}">
                    <div class="rx-card">
                        <div class="fw-bold text-success mb-1"><i class="fa-solid fa-pills me-1"></i>${rx.medicines}</div>
                        <div class="text-muted small mb-1">${rx.dosage}</div>
                        <c:if test="${not empty rx.notes}">
                            <div class="text-muted small fst-italic">${rx.notes}</div>
                        </c:if>
                        <div class="text-muted small mt-1"><i class="fa-regular fa-calendar me-1"></i>${rx.createdAt}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

</div></div>
</body>
</html>
