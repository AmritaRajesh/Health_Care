<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Emergency - Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:24px;margin-bottom:24px;}
.table th{color:#64748b;font-size:.78rem;font-weight:700;text-transform:uppercase;padding:13px 18px;border-top:none;border-bottom:1px solid #f1f5f9;}
.table td{padding:13px 18px;vertical-align:middle;border-bottom:1px solid #f1f5f9;}
.sev-critical{background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:700;}
.sev-high{background:#fff7ed;color:#ea580c;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:700;}
.sev-medium{background:#fffbeb;color:#d97706;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:700;}
.sev-low{background:#f0fdf4;color:#16a34a;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:700;}
.st-open{background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-in_progress{background:#fffbeb;color:#d97706;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-resolved{background:#ecfdf5;color:#059669;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title"><i class="fa-solid fa-truck-medical text-danger me-2"></i>Emergency Cases</h1>
<p class="page-subtitle">Log and manage emergency patient cases</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
<c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-plus-circle text-danger me-2"></i>Log New Emergency</h5>
  <form action="${pageContext.request.contextPath}/admin/emergency" method="post">
    <input type="hidden" name="action" value="add">
    <div class="row g-3">
      <div class="col-md-3"><label class="form-label fw-bold text-secondary small">Patient Name</label><input type="text" name="patientName" class="form-control" required></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Contact</label><input type="text" name="contact" class="form-control"></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Severity</label>
        <select name="severity" class="form-select" required>
          <option value="critical">🔴 Critical</option><option value="high">🟠 High</option>
          <option value="medium">🟡 Medium</option><option value="low">🟢 Low</option>
        </select></div>
      <div class="col-md-3"><label class="form-label fw-bold text-secondary small">Assign Doctor</label>
        <select name="assignedDoctorId" class="form-select">
          <option value="">-- None --</option>
          <c:forEach var="d" items="${doctorList}"><option value="${d.id}">Dr. ${d.fullName}</option></c:forEach>
        </select></div>
      <div class="col-md-2 d-flex align-items-end"><button type="submit" class="btn btn-danger fw-bold w-100"><i class="fa-solid fa-plus me-1"></i>Log</button></div>
      <div class="col-12"><label class="form-label fw-bold text-secondary small">Description</label><textarea name="description" class="form-control" rows="2" required></textarea></div>
    </div>
  </form>
</div>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3">All Emergency Cases (${caseList.size()})</h5>
  <div class="table-responsive">
    <table class="table mb-0">
      <thead><tr><th>Patient</th><th>Contact</th><th>Description</th><th>Severity</th><th>Doctor</th><th>Status</th><th>Time</th><th>Action</th></tr></thead>
      <tbody>
        <c:forEach var="c" items="${caseList}">
          <tr>
            <td class="fw-bold">${c.patientName}</td>
            <td>${c.contact}</td>
            <td class="text-muted" style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${c.description}</td>
            <td><span class="sev-${c.severity}">${c.severity}</span></td>
            <td>${not empty c.assignedDoctorName ? 'Dr. '.concat(c.assignedDoctorName) : '—'}</td>
            <td><span class="st-${c.status}">${c.status}</span></td>
            <td class="text-muted small">${c.createdAt}</td>
            <td>
              <c:if test="${c.status ne 'resolved'}">
                <form action="${pageContext.request.contextPath}/admin/emergency" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="status"><input type="hidden" name="id" value="${c.id}">
                  <c:if test="${c.status eq 'open'}"><input type="hidden" name="status" value="in_progress"><button type="submit" class="btn btn-sm btn-warning fw-bold">In Progress</button></c:if>
                  <c:if test="${c.status eq 'in_progress'}"><input type="hidden" name="status" value="resolved"><button type="submit" class="btn btn-sm btn-success fw-bold">Resolve</button></c:if>
                </form>
              </c:if>
              <c:if test="${c.status eq 'resolved'}"><span class="text-muted small">✓ Resolved</span></c:if>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty caseList}"><tr><td colspan="8" class="text-center text-muted p-4">No emergency cases.</td></tr></c:if>
      </tbody>
    </table>
  </div>
</div>
</div></div></body></html>
