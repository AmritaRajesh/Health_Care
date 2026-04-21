<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Medicine Reminders - Patient</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:24px;margin-bottom:24px;}
.reminder-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:18px;margin-bottom:12px;display:flex;align-items:center;gap:16px;transition:.2s;}
.reminder-card:hover{box-shadow:0 4px 12px rgba(0,0,0,.07);}
.reminder-card.inactive{opacity:.5;}
.time-badge{background:#eff6ff;color:#2563eb;padding:8px 14px;border-radius:10px;font-weight:700;font-size:1rem;white-space:nowrap;}
.med-name{font-weight:700;color:#1e293b;font-size:.95rem;}
.med-info{color:#64748b;font-size:.82rem;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Medicine Reminders</h1>
<p class="page-subtitle">Set reminders for your medicines and never miss a dose</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
<c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-bell-concierge text-primary me-2"></i>Add New Reminder</h5>
  <form action="${pageContext.request.contextPath}/patient/reminders" method="post">
    <input type="hidden" name="action" value="add">
    <div class="row g-3">
      <div class="col-md-4"><label class="form-label fw-bold text-secondary small">Medicine Name</label><input type="text" name="medicineName" class="form-control" placeholder="e.g. Paracetamol 500mg" required></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Dosage</label><input type="text" name="dosage" class="form-control" placeholder="e.g. 1 tablet"></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Reminder Time</label><input type="time" name="reminderTime" class="form-control" required></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Frequency</label>
        <select name="daysOfWeek" class="form-select">
          <option value="Daily">Daily</option>
          <option value="Mon,Wed,Fri">Mon, Wed, Fri</option>
          <option value="Tue,Thu,Sat">Tue, Thu, Sat</option>
          <option value="Weekdays">Weekdays</option>
          <option value="Weekends">Weekends</option>
        </select></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Prescription</label>
        <select name="prescriptionId" class="form-select">
          <option value="">-- None --</option>
          <c:forEach var="rx" items="${prescriptionList}"><option value="${rx.id}">Dr. ${rx.doctorName} - ${rx.createdAt}</option></c:forEach>
        </select></div>
      <div class="col-12"><button type="submit" class="btn btn-primary fw-bold px-4"><i class="fa-solid fa-plus me-2"></i>Set Reminder</button></div>
    </div>
  </form>
</div>

<c:if test="${empty reminderList}">
  <div class="text-center text-muted p-5 bg-white rounded border"><i class="fa-solid fa-bell-slash fs-1 mb-3"></i><h5>No reminders set.</h5><p>Add a reminder above to get started.</p></div>
</c:if>

<c:forEach var="r" items="${reminderList}">
  <div class="reminder-card ${r.active ? '' : 'inactive'}">
    <div class="time-badge"><i class="fa-regular fa-clock me-1"></i>${r.reminderTime}</div>
    <div class="flex-grow-1">
      <div class="med-name"><i class="fa-solid fa-pills me-2 text-primary"></i>${r.medicineName}</div>
      <div class="med-info">
        <c:if test="${not empty r.dosage}">${r.dosage} &nbsp;|&nbsp;</c:if>
        <i class="fa-regular fa-calendar me-1"></i>${r.daysOfWeek}
        &nbsp;|&nbsp; <span class="${r.active ? 'text-success' : 'text-muted'} fw-bold">${r.active ? '🟢 Active' : '⚪ Paused'}</span>
      </div>
    </div>
    <div class="d-flex gap-2">
      <form action="${pageContext.request.contextPath}/patient/reminders" method="post" style="display:inline;">
        <input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="${r.id}">
        <button type="submit" class="btn btn-sm btn-outline-secondary fw-bold" title="${r.active ? 'Pause' : 'Activate'}">
          <i class="fa-solid fa-${r.active ? 'pause' : 'play'}"></i>
        </button>
      </form>
      <form action="${pageContext.request.contextPath}/patient/reminders" method="post" style="display:inline;" onsubmit="return confirm('Delete this reminder?')">
        <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${r.id}">
        <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash"></i></button>
      </form>
    </div>
  </div>
</c:forEach>
</div></div></body></html>
