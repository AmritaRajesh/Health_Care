<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Management - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.content-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; padding: 13px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 13px 18px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
.role-doctor { background: #ede9fe; color: #6d28d9; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.role-patient { background: #ecfdf5; color: #059669; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.role-admin { background: #fef2f2; color: #dc2626; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.avatar { width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.85rem; }
.search-bar { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 9px 14px; display: flex; align-items: center; gap: 8px; margin-bottom: 20px; max-width: 400px; }
.search-bar input { border: none; background: transparent; outline: none; color: #334155; width: 100%; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">User Management</h1>
    <p class="page-subtitle">Manage all system users — doctors, patients, and admins</p>

    <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
    <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

    <div class="content-card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold text-dark mb-0">All Users (${userList.size()})</h5>
            <div class="search-bar">
                <i class="fa-solid fa-search text-muted"></i>
                <input type="text" id="searchInput" placeholder="Search by name or email..." onkeyup="filterTable()">
            </div>
        </div>
        <div class="table-responsive">
            <table class="table mb-0" id="userTable">
                <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Action</th></tr></thead>
                <tbody>
                    <c:forEach var="u" items="${userList}" varStatus="s">
                        <tr>
                            <td class="text-muted">${s.count}</td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar" style="background:${u.role eq 'admin' ? '#ef4444' : u.role eq 'doctor' ? '#6366f1' : '#10b981'}">
                                        ${u.fullName.substring(0,1).toUpperCase()}
                                    </div>
                                    <span class="fw-bold text-dark">${u.fullName}</span>
                                </div>
                            </td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
                            <td><span class="role-${u.role}">${u.role}</span></td>
                            <td>
                                <c:if test="${u.role ne 'admin'}">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;" onsubmit="return confirm('Remove ${u.fullName}? All their data will be deleted.')">
                                        <input type="hidden" name="id" value="${u.id}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash me-1"></i>Remove</button>
                                    </form>
                                </c:if>
                                <c:if test="${u.role eq 'admin'}">
                                    <span class="text-muted small"><i class="fa-solid fa-shield-halved me-1"></i>Protected</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty userList}"><tr><td colspan="6" class="text-center text-muted p-4">No users found.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
<script>
function filterTable() {
    var q = document.getElementById('searchInput').value.toLowerCase();
    var rows = document.querySelectorAll('#userTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
