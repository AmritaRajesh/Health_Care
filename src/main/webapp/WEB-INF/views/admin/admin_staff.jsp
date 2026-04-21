<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff Management - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px; }
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 18px; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; padding: 13px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 13px 18px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
.role-badge { background: #ede9fe; color: #6d28d9; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.s-active { background: #ecfdf5; color: #059669; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.s-inactive { background: #f1f5f9; color: #64748b; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.avatar { width: 34px; height: 34px; background: linear-gradient(135deg,#8b5cf6,#6d28d9); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.85rem; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Staff Management</h1>
    <p class="page-subtitle">Manage nurses, receptionists, and other hospital staff</p>

    <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
    <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

    <!-- Add Staff Form -->
    <div class="form-card">
        <h5><i class="fa-solid fa-user-plus text-primary me-2"></i>Add New Staff Member</h5>
        <form action="${pageContext.request.contextPath}/admin/staff" method="post">
            <input type="hidden" name="action" value="add">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold text-secondary small">Full Name</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold text-secondary small">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold text-secondary small">Phone</label>
                    <input type="text" name="phone" class="form-control">
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold text-secondary small">Role</label>
                    <select name="role" class="form-select" required>
                        <option value="">-- Select --</option>
                        <option value="Nurse">Nurse</option>
                        <option value="Receptionist">Receptionist</option>
                        <option value="Lab Technician">Lab Technician</option>
                        <option value="Pharmacist">Pharmacist</option>
                        <option value="Cleaner">Cleaner</option>
                        <option value="Security">Security</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold text-secondary small">Department</label>
                    <select name="departmentId" class="form-select">
                        <option value="">-- None --</option>
                        <c:forEach var="d" items="${deptList}">
                            <option value="${d.id}">${d.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary fw-bold px-4"><i class="fa-solid fa-plus me-2"></i>Add Staff</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Staff Table -->
    <div class="form-card">
        <h5><i class="fa-solid fa-people-group text-secondary me-2"></i>All Staff (${staffList.size()})</h5>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead><tr><th>Name</th><th>Role</th><th>Department</th><th>Email</th><th>Phone</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                    <c:forEach var="s" items="${staffList}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar">${s.fullName.substring(0,1).toUpperCase()}</div>
                                    <span class="fw-bold text-dark">${s.fullName}</span>
                                </div>
                            </td>
                            <td><span class="role-badge">${s.role}</span></td>
                            <td class="text-muted">${not empty s.departmentName ? s.departmentName : '—'}</td>
                            <td>${s.email}</td>
                            <td>${s.phone}</td>
                            <td><span class="s-${s.status}">${s.status}</span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/staff" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary fw-bold me-1" title="Toggle Status"><i class="fa-solid fa-toggle-on"></i></button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/staff" method="post" style="display:inline;" onsubmit="return confirm('Remove ${s.fullName}?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty staffList}"><tr><td colspan="7" class="text-center text-muted p-4">No staff added yet.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
</body>
</html>
