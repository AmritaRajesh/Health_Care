<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Patients - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.content-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
.card-header-view { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
.card-title-view { font-size: 1.15rem; font-weight: 700; color: #1e293b; margin: 0; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 16px 24px; border-bottom: 1px solid #f1f5f9; border-top:none; }
.table td { padding: 16px 24px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.empty-state { padding: 50px; text-align: center; color: #94a3b8; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">Patient Records</h1>
        <p class="page-subtitle">View all registered patients across the hospital network</p>

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
                <h3 class="card-title-view">Global Patient Directory</h3>
            </div>
            
            <c:if test="${empty patientList}">
                <div class="empty-state">
                    <i class="fa-solid fa-hospital-user fs-1 mb-3"></i>
                    <h4>No Patients Registered Yet</h4>
                </div>
            </c:if>

            <c:if test="${not empty patientList}">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>System ID</th>
                                <th>Full Name</th>
                                <th>Email Address</th>
                                <th>Phone Number</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patientList}">
                                <tr>
                                    <td class="text-muted fw-bold">#PT-${p.id}</td>
                                    <td class="fw-bold text-dark">${p.fullName}</td>
                                    <td>${p.email}</td>
                                    <td>${p.phone}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/patients" method="post" style="display:inline;" onsubmit="return confirm('Remove this patient?')">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger fw-bold"><i class="fa-solid fa-trash me-1"></i>Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->
</body>
</html>
