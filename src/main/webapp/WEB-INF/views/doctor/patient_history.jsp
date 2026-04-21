<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient History - ${patient.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc; }
        
        .patient-card {
            background: linear-gradient(135deg, #1e40af, #3b82f6);
            color: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.2);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .patient-avatar {
            width: 80px; height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px; font-weight: bold;
        }
        .patient-details h2 { margin: 0 0 5px 0; font-weight: 700; }
        .patient-details p { margin: 0; opacity: 0.9; font-size: 0.95rem; display:flex; gap: 15px; }

        .timeline {
            position: relative;
            padding-left: 30px;
            margin-bottom: 50px;
        }
        .timeline::before {
            content: '';
            position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px;
            background: #e2e8f0;
            border-radius: 3px;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }
        .timeline-item::before {
            content: '';
            position: absolute; left: -36px; top: 2px;
            width: 15px; height: 15px;
            border-radius: 50%;
            background: #3b82f6;
            border: 3px solid #eff6ff;
            box-shadow: 0 0 0 3px #bfdbfe;
        }
        .timeline-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            transition: 0.3s;
        }
        .timeline-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
        .visit-date {
            font-size: 0.85rem; font-weight: 600; color: #64748b; margin-bottom: 5px; text-transform:uppercase; letter-spacing:0.5px;
        }
        .visit-reason {
            font-size: 1.15rem; font-weight: 700; color: #1e293b; margin-bottom: 10px;
        }
        .visit-meta {
            font-size: 0.9rem; color: #475569; display: flex; gap: 20px;
        }
        .visit-meta span { display: flex; align-items: center; gap: 6px; }

        .badge-status { padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .s-pending { background: #fffbeb; color: #d97706; }
        .s-approved { background: #ecfdf5; color: #059669; }
        .s-completed { background: #eff6ff; color: #2563eb; }
        .s-rejected { background: #fef2f2; color: #dc2626; }
        
        .no-data {
            text-align: center; color: #94a3b8; padding: 40px; background: white; border-radius:12px; border: 1px dashed #cbd5e1;
        }
        .btn-back { margin-bottom:20px; display:inline-block; font-weight:600; color:#475569; text-decoration:none; transition:0.2s; }
        .btn-back:hover { color:#1e293b; }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn-back">
            <i class="fa-solid fa-arrow-left me-2"></i>Back to Appointments
        </a>

        <div class="patient-card">
            <div class="patient-avatar">
                <i class="fa-regular fa-user"></i>
            </div>
            <div class="patient-details">
                <h2>${patient.fullName}</h2>
                <p>
                    <span><i class="fa-solid fa-envelope me-1"></i> ${patient.email}</span>
                    <span><i class="fa-solid fa-phone me-1"></i> ${patient.phone}</span>
                </p>
            </div>
        </div>

        <h4 class="mb-4 fw-bold text-dark"><i class="fa-solid fa-clock-rotate-left text-primary me-2"></i>Medical History</h4>

        <c:if test="${empty historyList}">
            <div class="no-data">
                <i class="fa-regular fa-folder-open fs-1 mb-3"></i>
                <h5 class="fw-bold">No Past Appointments</h5>
                <p>This patient doesn't have any recorded medical history yet.</p>
            </div>
        </c:if>

        <c:if test="${not empty historyList}">
            <div class="timeline">
                <c:forEach var="h" items="${historyList}">
                    <div class="timeline-item">
                        <div class="timeline-card">
                            <div class="visit-date">
                                <i class="fa-regular fa-calendar text-primary me-1"></i> ${h.appointmentDate} &nbsp;|&nbsp; 
                                <span class="badge-status s-${h.status}">${h.status}</span>
                            </div>
                            <div class="visit-reason">${h.reason}</div>
                            <div class="visit-meta">
                                <span><i class="fa-solid fa-user-md"></i> ${h.doctorName}</span>
                                <span><i class="fa-regular fa-clock"></i> ${h.timeSlot}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

    </div> <!-- Close main-content from sidebar -->
</div> <!-- Close dashboard-container -->

</body>
</html>
