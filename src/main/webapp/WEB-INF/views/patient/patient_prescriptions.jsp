<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Prescriptions - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.rx-card { background: white; border: 1px solid #e2e8f0; border-radius: 14px; padding: 22px; margin-bottom: 18px; transition: 0.2s; }
.rx-card:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.07); }
.rx-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
.rx-doctor { font-weight: 700; color: #1e293b; font-size: 1rem; }
.rx-date { color: #94a3b8; font-size: 0.82rem; }
.rx-section { margin-bottom: 10px; }
.rx-label { font-size: 0.78rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
.rx-value { color: #334155; font-size: 0.92rem; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 8px 12px; }
.rx-notes { color: #64748b; font-size: 0.88rem; font-style: italic; }
.btn-print { background: none; border: 1px solid #e2e8f0; color: #475569; padding: 6px 14px; border-radius: 8px; font-size: 0.82rem; font-weight: 600; cursor: pointer; transition: 0.2s; }
.btn-print:hover { background: #f1f5f9; }
.empty-state { text-align: center; padding: 60px; color: #94a3b8; background: white; border-radius: 12px; border: 1px dashed #cbd5e1; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">My Prescriptions</h1>
    <p class="page-subtitle">Medicines and dosage instructions from your doctors</p>

    <c:if test="${empty prescriptionList}">
        <div class="empty-state">
            <i class="fa-solid fa-prescription-bottle-medical fs-1 mb-3"></i>
            <h5 class="fw-bold">No Prescriptions Yet</h5>
            <p>Prescriptions from your doctors will appear here.</p>
        </div>
    </c:if>

    <c:forEach var="rx" items="${prescriptionList}">
        <div class="rx-card" id="rx-${rx.id}">
            <div class="rx-header">
                <div>
                    <div class="rx-doctor"><i class="fa-solid fa-user-doctor text-primary me-2"></i>Dr. ${rx.doctorName}</div>
                    <div class="rx-date"><i class="fa-regular fa-calendar me-1"></i>${rx.createdAt}</div>
                </div>
                <button class="btn-print" onclick="printRx('rx-${rx.id}')">
                    <i class="fa-solid fa-print me-1"></i>Print
                </button>
            </div>
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="rx-section">
                        <div class="rx-label"><i class="fa-solid fa-pills me-1"></i>Medicines</div>
                        <div class="rx-value">${rx.medicines}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="rx-section">
                        <div class="rx-label"><i class="fa-solid fa-clock me-1"></i>Dosage Instructions</div>
                        <div class="rx-value">${rx.dosage}</div>
                    </div>
                </div>
                <c:if test="${not empty rx.notes}">
                    <div class="col-12">
                        <div class="rx-label"><i class="fa-solid fa-note-sticky me-1"></i>Doctor's Notes</div>
                        <div class="rx-notes">${rx.notes}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </c:forEach>

</div></div>
<script>
function printRx(id) {
    var el = document.getElementById(id);
    var w = window.open('', '_blank');
    w.document.write('<html><head><title>Prescription</title>');
    w.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">');
    w.document.write('</head><body style="padding:30px;">' + el.innerHTML + '</body></html>');
    w.document.close();
    w.print();
}
</script>
</body>
</html>
