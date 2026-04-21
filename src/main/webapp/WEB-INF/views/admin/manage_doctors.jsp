<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Doctors - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
.card-header-view { padding: 18px 22px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
.card-title-view { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin: 0; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 20px; border-bottom: 1px solid #f1f5f9; border-top: none; }
.table td { padding: 14px 20px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.btn-add { background: #6366f1; color: white; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 0.88rem; }
.btn-add:hover { background: #4f46e5; color: white; }
.spec-badge { background: #ede9fe; color: #6d28d9; padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.avatar { width: 36px; height: 36px; background: linear-gradient(135deg,#6366f1,#4f46e5); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.9rem; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Manage Doctors</h1>
    <p class="page-subtitle">Add, view, and remove doctor accounts</p>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <div class="content-card">
        <div class="card-header-view">
            <h3 class="card-title-view">Registered Doctors (${doctorList.size()})</h3>
            <a href="${pageContext.request.contextPath}/admin/add-doctor" class="btn-add">
                <i class="fa-solid fa-plus me-1"></i>Add Doctor
            </a>
        </div>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr><th>Doctor</th><th>Specialization</th><th>Email</th><th>Phone</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${doctorList}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar">${d.fullName.substring(0,1).toUpperCase()}</div>
                                    <span class="fw-bold text-dark">Dr. ${d.fullName}</span>
                                </div>
                            </td>
                            <td><span class="spec-badge">${d.specialization}</span></td>
                            <td>${d.email}</td>
                            <td>${d.phone}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/doctors" method="post" style="display:inline;" onsubmit="return confirm('Delete Dr. ${d.fullName}? This cannot be undone.')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${d.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold">
                                        <i class="fa-solid fa-trash me-1"></i>Remove
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctorList}">
                        <tr><td colspan="5" class="text-center text-muted p-4">No doctors registered yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
</body>
</html>
