<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Billing - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.stat-card { background: white; border-radius: 12px; padding: 20px 22px; border: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
.stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; color: white; }
.form-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px; }
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 18px; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; padding: 13px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 13px 18px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
.s-unpaid { background: #fef2f2; color: #dc2626; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.s-paid { background: #ecfdf5; color: #059669; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Billing & Payments</h1>
    <p class="page-subtitle">Generate bills and track payment transactions</p>

    <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
    <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div><div class="text-muted small fw-bold text-uppercase">Total Revenue</div><div class="fw-bold fs-4 text-success">₹<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div></div>
                <div class="stat-icon" style="background:#059669;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div><div class="text-muted small fw-bold text-uppercase">Pending Dues</div><div class="fw-bold fs-4 text-danger">₹<fmt:formatNumber value="${totalDue}" pattern="#,##0.00"/></div></div>
                <div class="stat-icon" style="background:#ef4444;"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div><div class="text-muted small fw-bold text-uppercase">Total Bills</div><div class="fw-bold fs-4">${billList.size()}</div></div>
                <div class="stat-icon" style="background:#6366f1;"><i class="fa-solid fa-receipt"></i></div>
            </div>
        </div>
    </div>

    <!-- Generate Bill Form -->
    <div class="form-card">
        <h5><i class="fa-solid fa-plus-circle text-primary me-2"></i>Generate New Bill</h5>
        <form action="${pageContext.request.contextPath}/admin/billing" method="post">
            <input type="hidden" name="action" value="add">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Patient</label>
                    <select name="patientId" class="form-select" id="patientSelect" required>
                        <option value="">-- Auto-filled from appointment --</option>
                        <c:forEach var="p" items="${patientList}">
                            <option value="${p.id}">${p.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Appointment</label>
                    <select name="appointmentId" class="form-select" id="apptSel" onchange="fillDoctor(this)" required>
                        <option value="">-- Select Appointment --</option>
                        <c:forEach var="a" items="${apptList}">
                            <option value="${a.id}" data-doctor="${a.doctorId}" data-patient="${a.patientId}">${a.patientName} - ${a.appointmentDate}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Doctor ID</label>
                    <input type="number" name="doctorId" id="doctorIdField" class="form-control" readonly required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold text-secondary small">Description</label>
                    <input type="text" name="description" class="form-control" placeholder="e.g. Consultation Fee" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold text-secondary small">Amount (₹)</label>
                    <input type="number" name="amount" class="form-control" step="0.01" min="1" required>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary fw-bold w-100"><i class="fa-solid fa-file-invoice me-2"></i>Generate Bill</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Bills Table -->
    <div class="form-card">
        <h5><i class="fa-solid fa-list text-secondary me-2"></i>All Bills</h5>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead><tr><th>#</th><th>Patient</th><th>Doctor</th><th>Description</th><th>Amount</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
                <tbody>
                    <c:forEach var="b" items="${billList}" varStatus="s">
                        <tr>
                            <td class="text-muted">${s.count}</td>
                            <td class="fw-bold">${b.patientName}</td>
                            <td>Dr. ${b.doctorName}</td>
                            <td>${b.description}</td>
                            <td class="fw-bold">₹<fmt:formatNumber value="${b.amount}" pattern="#,##0.00"/></td>
                            <td><span class="s-${b.status}">${b.status}</span></td>
                            <td class="text-muted small">${b.createdAt}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/billing" method="post" style="display:inline;" onsubmit="return confirm('Delete this bill?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${b.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty billList}"><tr><td colspan="8" class="text-center text-muted p-4">No bills yet.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
<script>
function fillDoctor(sel) {
    var opt = sel.options[sel.selectedIndex];
    document.getElementById('doctorIdField').value = opt.getAttribute('data-doctor') || '';
    var patId = opt.getAttribute('data-patient') || '';
    var patSel = document.getElementById('patientSelect');
    if (patSel && patId) {
        for (var i = 0; i < patSel.options.length; i++) {
            if (patSel.options[i].value == patId) { patSel.selectedIndex = i; break; }
        }
    }
}
</script>
</body>
</html>
