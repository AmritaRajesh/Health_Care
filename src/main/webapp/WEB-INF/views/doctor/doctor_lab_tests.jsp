<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Lab Tests - Doctor</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:24px;margin-bottom:24px;}
.table th{color:#64748b;font-size:.78rem;font-weight:700;text-transform:uppercase;padding:13px 18px;border-top:none;border-bottom:1px solid #f1f5f9;}
.table td{padding:13px 18px;vertical-align:middle;border-bottom:1px solid #f1f5f9;}
.st-recommended{background:#eff6ff;color:#2563eb;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-sample_collected{background:#fffbeb;color:#d97706;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-completed{background:#ecfdf5;color:#059669;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Lab Tests</h1>
<p class="page-subtitle">Recommend and track lab tests for patients</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
<c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-flask text-primary me-2"></i>Recommend New Lab Test</h5>
  <form action="${pageContext.request.contextPath}/doctor/lab-tests" method="post">
    <input type="hidden" name="action" value="add">
    <div class="row g-3">
      <div class="col-md-5"><label class="form-label fw-bold text-secondary small">Select Appointment</label>
        <select name="appointmentId" class="form-select" id="apptSel" onchange="fillPat(this)" required>
          <option value="">-- Select Appointment --</option>
          <c:forEach var="a" items="${apptList}">
            <c:if test="${a.status eq 'approved' or a.status eq 'completed'}">
              <option value="${a.id}" data-patient="${a.patientId}">${a.patientName} - ${a.appointmentDate}</option>
            </c:if>
          </c:forEach>
        </select></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Patient ID</label><input type="number" name="patientId" id="patIdField" class="form-control" readonly required></div>
      <div class="col-md-5"><label class="form-label fw-bold text-secondary small">Test Name</label><input type="text" name="testName" class="form-control" placeholder="e.g. Complete Blood Count (CBC)" required></div>
      <div class="col-12"><label class="form-label fw-bold text-secondary small">Instructions</label><textarea name="instructions" class="form-control" rows="2" placeholder="Fasting required, sample collection notes..."></textarea></div>
      <div class="col-12"><button type="submit" class="btn btn-primary fw-bold px-4"><i class="fa-solid fa-paper-plane me-2"></i>Recommend Test</button></div>
    </div>
  </form>
</div>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3">Lab Test History</h5>
  <div class="table-responsive">
    <table class="table mb-0">
      <thead><tr><th>Patient</th><th>Test Name</th><th>Instructions</th><th>Status</th><th>Result</th><th>Date</th></tr></thead>
      <tbody>
        <c:forEach var="t" items="${testList}">
          <tr>
            <td class="fw-bold">${t.patientName}</td>
            <td>${t.testName}</td>
            <td class="text-muted small">${t.instructions}</td>
            <td><span class="st-${t.status}">${t.status}</span></td>
            <td class="text-muted small">${not empty t.result ? t.result : '—'}</td>
            <td class="text-muted small">${t.createdAt}</td>
          </tr>
        </c:forEach>
        <c:if test="${empty testList}"><tr><td colspan="6" class="text-center text-muted p-4">No lab tests yet.</td></tr></c:if>
      </tbody>
    </table>
  </div>
</div>
</div></div>
<script>function fillPat(s){var o=s.options[s.selectedIndex];document.getElementById('patIdField').value=o.getAttribute('data-patient')||'';}</script>
</body></html>
