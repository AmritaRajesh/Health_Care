<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin System Settings - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.profile-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 25px; height: 100%; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
.card-header-title { font-size: 1.15rem; font-weight: 700; color: #1e293b; margin-bottom: 25px; }
.form-label { font-size: 0.85rem; font-weight: 600; color: #64748b; margin-bottom: 8px; }
.form-control { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 15px; color: #334155; }
.form-control:focus { background: white; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
.input-group-text { background: transparent; border-right: none; color: #94a3b8; }
.input-group .form-control { border-left: none; padding-left: 0; }
.btn-update { background: #6366f1; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: 600; width: 100%; transition: all 0.2s; }
.btn-update:hover { background: #4f46e5; color:white; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">System Settings</h1>
        <p class="page-subtitle">Manage administrative root access</p>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">${successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="row g-4 mt-2">
            <div class="col-md-6">
                <div class="profile-card">
                    <h3 class="card-header-title">Root Credentials</h3>
                    <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        
                        <div class="mb-4">
                            <label class="form-label">Admin Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-user-shield"></i></span>
                                <input type="text" name="fullName" class="form-control" value="${adminObj.fullName}" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">System Email (Login ID)</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                                <input type="email" class="form-control" value="${adminObj.email}" readonly style="background:#f1f5f9; cursor:not-allowed;">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Emergency Phone</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                <input type="text" name="phone" class="form-control" value="${adminObj.phone}" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-update mt-2">
                            <i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
                        </button>
                    </form>
                </div>
            </div>

            <div class="col-md-6">
                <div class="profile-card">
                    <h3 class="card-header-title">Security Settings</h3>
                    <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        
                        <div class="mb-4">
                            <label class="form-label">Current Root Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" name="oldPassword" class="form-control" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock-open"></i></span>
                                <input type="password" name="newPassword" class="form-control" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Confirm New Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock-open"></i></span>
                                <input type="password" name="confirmPassword" class="form-control" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-update mt-2">
                            <i class="fa-solid fa-key me-2"></i> Update Security
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->
</body>
</html>
