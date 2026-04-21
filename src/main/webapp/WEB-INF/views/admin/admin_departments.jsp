<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Departments - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px; }
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 18px; }
.dept-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; transition: 0.2s; }
.dept-card:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.07); }
.dept-icon { width: 48px; height: 48px; background: linear-gradient(135deg,#6366f1,#4f46e5); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.3rem; margin-bottom: 12px; }
.dept-name { font-weight: 700; color: #1e293b; font-size: 1rem; margin-bottom: 4px; }
.dept-desc { color: #64748b; font-size: 0.85rem; margin-bottom: 10px; }
.dept-head { color: #6366f1; font-size: 0.82rem; font-weight: 600; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Department Management</h1>
    <p class="page-subtitle">Manage hospital departments and assign department heads</p>

    <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
    <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

    <!-- Add Department -->
    <div class="form-card">
        <h5><i class="fa-solid fa-building-columns text-primary me-2"></i>Add New Department</h5>
        <form action="${pageContext.request.contextPath}/admin/departments" method="post">
            <input type="hidden" name="action" value="add">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Department Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Radiology" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Head Doctor (optional)</label>
                    <select name="headDoctorId" class="form-select">
                        <option value="">-- None --</option>
                        <c:forEach var="d" items="${doctorList}">
                            <option value="${d.id}">Dr. ${d.fullName} (${d.specialization})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-secondary small">Description</label>
                    <input type="text" name="description" class="form-control" placeholder="Brief description">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary fw-bold px-4"><i class="fa-solid fa-plus me-2"></i>Add Department</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Department Cards -->
    <div class="row g-4">
        <c:forEach var="d" items="${deptList}">
            <div class="col-md-4">
                <div class="dept-card">
                    <div class="dept-icon"><i class="fa-solid fa-building-columns"></i></div>
                    <div class="dept-name">${d.name}</div>
                    <div class="dept-desc">${not empty d.description ? d.description : 'No description'}</div>
                    <c:if test="${not empty d.headDoctorName}">
                        <div class="dept-head"><i class="fa-solid fa-user-doctor me-1"></i>Head: Dr. ${d.headDoctorName}</div>
                    </c:if>
                    <div class="mt-3">
                        <form action="${pageContext.request.contextPath}/admin/departments" method="post" style="display:inline;" onsubmit="return confirm('Delete ${d.name}?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${d.id}">
                            <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash me-1"></i>Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty deptList}">
            <div class="col-12 text-center text-muted p-5">No departments added yet.</div>
        </c:if>
    </div>

</div></div>
</body>
</html>
