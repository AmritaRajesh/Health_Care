<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Rooms & Beds - Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.stat-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:18px 22px;display:flex;justify-content:space-between;align-items:center;}
.stat-icon{width:42px;height:42px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:white;}
.form-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:24px;margin-bottom:24px;}
.room-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:18px;transition:.2s;}
.room-card:hover{box-shadow:0 4px 12px rgba(0,0,0,.08);}
.type-general{background:#eff6ff;color:#2563eb;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.type-private{background:#f0fdf4;color:#16a34a;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.type-icu{background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.type-emergency{background:#fff7ed;color:#ea580c;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-available{background:#ecfdf5;color:#059669;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-full{background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-maintenance{background:#f1f5f9;color:#64748b;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Room & Bed Management</h1>
<p class="page-subtitle">Monitor and manage hospital rooms and bed availability</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
<c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

<div class="row g-3 mb-4">
  <div class="col-md-3"><div class="stat-card"><div><div class="text-muted small fw-bold text-uppercase">Total Rooms</div><div class="fw-bold fs-4">${roomStats.total}</div></div><div class="stat-icon" style="background:#6366f1;"><i class="fa-solid fa-bed"></i></div></div></div>
  <div class="col-md-3"><div class="stat-card"><div><div class="text-muted small fw-bold text-uppercase">Available</div><div class="fw-bold fs-4 text-success">${roomStats.available}</div></div><div class="stat-icon" style="background:#10b981;"><i class="fa-solid fa-check"></i></div></div></div>
  <div class="col-md-3"><div class="stat-card"><div><div class="text-muted small fw-bold text-uppercase">Full</div><div class="fw-bold fs-4 text-danger">${roomStats.full}</div></div><div class="stat-icon" style="background:#ef4444;"><i class="fa-solid fa-xmark"></i></div></div></div>
  <div class="col-md-3"><div class="stat-card"><div><div class="text-muted small fw-bold text-uppercase">ICU Rooms</div><div class="fw-bold fs-4">${roomStats.icu}</div></div><div class="stat-icon" style="background:#f59e0b;"><i class="fa-solid fa-heart-pulse"></i></div></div></div>
</div>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-plus-circle text-primary me-2"></i>Add New Room</h5>
  <form action="${pageContext.request.contextPath}/admin/rooms" method="post">
    <input type="hidden" name="action" value="add">
    <div class="row g-3">
      <div class="col-md-3"><label class="form-label fw-bold text-secondary small">Room Number</label><input type="text" name="roomNumber" class="form-control" placeholder="e.g. 301" required></div>
      <div class="col-md-3"><label class="form-label fw-bold text-secondary small">Type</label>
        <select name="roomType" class="form-select" required>
          <option value="general">General</option><option value="private">Private</option>
          <option value="icu">ICU</option><option value="emergency">Emergency</option>
        </select></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Capacity</label><input type="number" name="capacity" class="form-control" value="1" min="1" required></div>
      <div class="col-md-2"><label class="form-label fw-bold text-secondary small">Department</label>
        <select name="departmentId" class="form-select">
          <option value="">-- None --</option>
          <c:forEach var="d" items="${deptList}"><option value="${d.id}">${d.name}</option></c:forEach>
        </select></div>
      <div class="col-md-2 d-flex align-items-end"><button type="submit" class="btn btn-primary fw-bold w-100"><i class="fa-solid fa-plus me-1"></i>Add</button></div>
    </div>
  </form>
</div>

<div class="row g-3">
  <c:forEach var="r" items="${roomList}">
    <div class="col-md-4 col-lg-3">
      <div class="room-card">
        <div class="d-flex justify-content-between align-items-start mb-2">
          <div class="fw-bold text-dark fs-5"><i class="fa-solid fa-bed me-2 text-primary"></i>${r.roomNumber}</div>
          <span class="st-${r.status}">${r.status}</span>
        </div>
        <div class="mb-1"><span class="type-${r.roomType}">${r.roomType}</span></div>
        <div class="text-muted small mb-1"><i class="fa-solid fa-users me-1"></i>Capacity: ${r.capacity} | Occupied: ${r.occupied}</div>
        <c:if test="${not empty r.departmentName}"><div class="text-muted small mb-2"><i class="fa-solid fa-building-columns me-1"></i>${r.departmentName}</div></c:if>
        <div class="d-flex gap-1 mt-2">
          <form action="${pageContext.request.contextPath}/admin/rooms" method="post" style="display:inline;">
            <input type="hidden" name="action" value="status"><input type="hidden" name="id" value="${r.id}">
            <c:if test="${r.status eq 'available'}"><input type="hidden" name="status" value="full"><button type="submit" class="btn btn-sm btn-outline-warning fw-bold">Mark Full</button></c:if>
            <c:if test="${r.status eq 'full'}"><input type="hidden" name="status" value="available"><button type="submit" class="btn btn-sm btn-outline-success fw-bold">Mark Free</button></c:if>
            <c:if test="${r.status eq 'maintenance'}"><input type="hidden" name="status" value="available"><button type="submit" class="btn btn-sm btn-outline-success fw-bold">Activate</button></c:if>
          </form>
          <form action="${pageContext.request.contextPath}/admin/rooms" method="post" style="display:inline;" onsubmit="return confirm('Delete room ${r.roomNumber}?')">
            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${r.id}">
            <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash"></i></button>
          </form>
        </div>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty roomList}"><div class="col-12 text-center text-muted p-5">No rooms added yet.</div></c:if>
</div>
</div></div></body></html>
