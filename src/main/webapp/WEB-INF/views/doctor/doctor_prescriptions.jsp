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
.form-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 30px; }
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 20px; }
.form-label { font-weight: 600; font-size: 0.88rem; color: #475569; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 14px 18px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.rx-badge { background: #ecfdf5; color: #059669; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Prescriptions</h1>
    <p class="page-subtitle">Write and manage patient prescriptions</p>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <!-- Add Prescription Form -->
    <div class="form-card">
        <h5><i class="fa-solid fa-prescription-bottle-medical text-primary me-2"></i>Add New Prescription</h5>
        <form action="${pageContext.request.contextPath}/doctor/prescriptions" method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Select Appointment</label>
                    <select name="appointmentId" class="form-select" id="apptSelect" required onchange="fillPatient(this)">
                        <option value="">-- Select Appointment --</option>
                        <c:forEach var="a" items="${apptList}">
                            <c:if test="${a.status eq 'approved' or a.status eq 'completed'}">
                                <option value="${a.id}" data-patient="${a.patientId}">${a.patientName} - ${a.appointmentDate} (${a.timeSlot})</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Patient ID</label>
                    <input type="number" name="patientId" id="patientIdField" class="form-control" readonly required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Medicines</label>
                    <textarea name="medicines" class="form-control" rows="3" placeholder="e.g. Paracetamol 500mg, Amoxicillin 250mg" required></textarea>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Dosage Instructions</label>
                    <textarea name="dosage" class="form-control" rows="3" placeholder="e.g. 1 tablet twice daily after meals" required></textarea>
                </div>
                <div class="col-12">
                    <label class="form-label">Additional Notes</label>
                    <textarea name="notes" class="form-control" rows="2" placeholder="Any special instructions or follow-up notes..."></textarea>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-success fw-bold px-4">
                        <i class="fa-solid fa-paper-plane me-2"></i>Send Prescription
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Prescription List -->
    <div class="form-card">
        <h5><i class="fa-solid fa-list-ul text-secondary me-2"></i>Prescription History</h5>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Patient</th>
                        <th>Medicines</th>
                        <th>Dosage</th>
                        <th>Notes</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="rx" items="${prescriptionList}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td class="fw-bold">${rx.patientName}</td>
                            <td><span class="rx-badge"><i class="fa-solid fa-pills me-1"></i>${rx.medicines}</span></td>
                            <td>${rx.dosage}</td>
                            <td class="text-muted">${rx.notes}</td>
                            <td class="text-muted small">${rx.createdAt}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty prescriptionList}">
                        <tr><td colspan="6" class="text-center text-muted p-4">No prescriptions yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
<script>
function fillPatient(sel) {
    var opt = sel.options[sel.selectedIndex];
    document.getElementById('patientIdField').value = opt.getAttribute('data-patient') || '';
}
</script>
</body>
</html>
