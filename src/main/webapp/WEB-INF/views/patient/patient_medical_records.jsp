<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Medical Records - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.section-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 28px; }
.section-title { font-weight: 700; color: #1e293b; font-size: 1.05rem; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid #f1f5f9; }
.timeline { position: relative; padding-left: 28px; }
.timeline::before { content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 3px; background: #e2e8f0; border-radius: 3px; }
.timeline-item { position: relative; margin-bottom: 20px; }
.timeline-item::before { content: ''; position: absolute; left: -34px; top: 4px; width: 13px; height: 13px; border-radius: 50%; background: #3b82f6; border: 3px solid #eff6ff; box-shadow: 0 0 0 3px #bfdbfe; }
.timeline-card { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; }
.badge-status { padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.s-pending { background: #fffbeb; color: #d97706; }
.s-approved { background: #ecfdf5; color: #059669; }
.s-completed { background: #eff6ff; color: #2563eb; }
.s-rejected { background: #fef2f2; color: #dc2626; }
.report-row { display: flex; align-items: center; gap: 14px; padding: 14px; border: 1px solid #e2e8f0; border-radius: 10px; margin-bottom: 10px; background: #f8fafc; }
.report-icon { font-size: 1.6rem; color: #3b82f6; }
.report-info { flex: 1; }
.report-title { font-weight: 700; color: #1e293b; font-size: 0.95rem; }
.report-meta { color: #64748b; font-size: 0.82rem; }
.empty-msg { text-align: center; color: #94a3b8; padding: 30px; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Medical Records</h1>
    <p class="page-subtitle">Your complete health history and uploaded reports</p>

    <!-- Appointment History -->
    <div class="section-card">
        <div class="section-title"><i class="fa-solid fa-calendar-check text-primary me-2"></i>Appointment History</div>
        <c:if test="${empty historyList}">
            <div class="empty-msg"><i class="fa-regular fa-folder-open fs-2 mb-2"></i><br>No appointment history yet.</div>
        </c:if>
        <div class="timeline">
            <c:forEach var="h" items="${historyList}">
                <div class="timeline-item">
                    <div class="timeline-card">
                        <div class="d-flex justify-content-between align-items-start mb-1">
                            <div class="fw-bold text-dark">${h.reason}</div>
                            <span class="badge-status s-${h.status}">${h.status}</span>
                        </div>
                        <div class="text-muted small">
                            <i class="fa-solid fa-user-doctor me-1 text-primary"></i>Dr. ${h.doctorName}
                            <span class="ms-3"><i class="fa-regular fa-calendar me-1"></i>${h.appointmentDate}</span>
                            <span class="ms-3"><i class="fa-regular fa-clock me-1"></i>${h.timeSlot}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Uploaded Reports -->
    <div class="section-card">
        <div class="section-title"><i class="fa-solid fa-file-medical text-success me-2"></i>Test Reports & Documents</div>
        <c:if test="${empty reportList}">
            <div class="empty-msg"><i class="fa-regular fa-file fs-2 mb-2"></i><br>No reports uploaded yet.</div>
        </c:if>
        <c:forEach var="r" items="${reportList}">
            <div class="report-row">
                <div class="report-icon"><i class="fa-solid fa-file-lines"></i></div>
                <div class="report-info">
                    <div class="report-title">${r.reportTitle}</div>
                    <div class="report-meta">
                        <i class="fa-solid fa-user-doctor me-1"></i>Dr. ${r.doctorName}
                        <span class="ms-3"><i class="fa-regular fa-calendar me-1"></i>${r.uploadedAt}</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/patient/medical-records?action=download&id=${r.id}" class="btn btn-sm btn-outline-primary fw-bold">
                    <i class="fa-solid fa-download me-1"></i>Download
                </a>
            </div>
        </c:forEach>
    </div>

</div></div>
</body>
</html>
