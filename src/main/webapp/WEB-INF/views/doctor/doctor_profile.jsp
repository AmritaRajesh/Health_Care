<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Profile - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.profile-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 25px; height: 100%; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
.card-header-title { font-size: 1.15rem; font-weight: 700; color: #1e293b; margin-bottom: 25px; }
.form-label { font-size: 0.85rem; font-weight: 600; color: #64748b; margin-bottom: 8px; }
.form-control { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 15px; color: #334155; }
.form-control:focus { background: white; border-color: #2b7cff; box-shadow: 0 0 0 3px rgba(43,124,255,0.1); }
.input-group-text { background: transparent; border-right: none; color: #94a3b8; }
.input-group .form-control { border-left: none; padding-left: 0; }
.btn-update { background: #10b981; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: 600; width: 100%; transition: all 0.2s; }
.btn-update:hover { background: #059669; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">Doctor Profile</h1>
        <p class="page-subtitle">Manage your account settings and password</p>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">${successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="row g-4 mt-2">
            <!-- Profile Info Form -->
            <div class="col-md-6">
                <div class="profile-card">
                    <h3 class="card-header-title">Profile Information</h3>
                    <form action="${pageContext.request.contextPath}/doctor/profile" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        
                        <div class="mb-4">
                            <label class="form-label">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-user"></i></span>
                                <input type="text" name="fullName" class="form-control" value="${doctor.fullName}" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                                <input type="email" class="form-control" value="${doctor.email}" readonly style="background:#f1f5f9; cursor:not-allowed;">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Phone</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                <input type="text" name="phone" class="form-control" value="${doctor.phone}" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Specialization</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-suitcase-medical"></i></span>
                                <input type="text" class="form-control" value="${doctor.specialization}" readonly style="background:#f1f5f9; cursor:not-allowed;">
                            </div>
                        </div>

                        <button type="submit" class="btn-update mt-2">
                            <i class="fa-solid fa-floppy-disk me-2"></i> Update Profile
                        </button>
                    </form>
                </div>
            </div>

            <!-- Password Change Form -->
            <div class="col-md-6">
                <div class="profile-card">
                    <h3 class="card-header-title">Change Password</h3>
                    <form action="${pageContext.request.contextPath}/doctor/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        
                        <div class="mb-4">
                            <label class="form-label">Current Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" name="oldPassword" class="form-control" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock-open"></i></span>
                                <input type="password" name="newPassword" class="form-control" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Confirm New Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock-open"></i></span>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-update mt-2">
                            <i class="fa-solid fa-key me-2"></i> Change Password
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->

</body>
</html>
