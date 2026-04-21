<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Hospital Management</title>
<!-- Bootstrap + Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>

body {
    background: #eef2f7;
}

/* ===== Top Bar ===== */
.topbar {
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 12px 24px;
}

.brand {
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 10px;
}

.brand-icon {
    background: #2b7cff;
    color: white;
    padding: 6px 10px;
    border-radius: 8px;
}

.top-links a {
    text-decoration: none;
    margin-left: 20px;
    color: #374151;
    font-weight: 500;
}

.btn-register-top {
    background: #dbeafe;
    padding: 6px 12px;
    border-radius: 8px;
}

/* ===== Login Card ===== */
.login-card {
    width: 420px;
    background: white;
    border-radius: 16px;
    padding: 34px;
    margin: 70px auto 20px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.08);
}

.icon-circle {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: #e0ecff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    color: #2b7cff;
    margin: 0 auto 12px;
}

.form-control, .form-select {
    background: #f8fafc;
    border-radius: 10px;
}

.input-group-text {
    background: #f1f5f9;
}

/* ===== Button ===== */
.btn-login {
    background: linear-gradient(135deg,#1d4ed8,#3b82f6);
    border: none;
    color: white;
    font-weight: 600;
    padding: 12px;
    border-radius: 10px;
}

.btn-login:hover {
    opacity: .92;
}

/* ===== Demo Box ===== */
.demo-box {
    background: #f1f5f9;
    border-radius: 10px;
    padding: 12px;
    font-size: 13px;
    margin-top: 15px;
}

.footer-note {
    text-align: center;
    font-size: 12px;
    color: #94a3b8;
}


</style>

<script>
function togglePass(){
    const p = document.getElementById("pass");
    p.type = p.type === "password" ? "text" : "password";
}
</script>

</head>

<body>


<!-- ================= HEADER ================= -->
<jsp:include page="header.jsp" />
<div>
<section>
<div class="topbar d-flex justify-content-between align-items-center">

<!-- ================= LOGIN ================= -->
<div class="login-card">

    <div class="icon-circle">
        <i class="fa fa-user"></i>
    </div>

    <h4 class="text-center fw-bold">Account Login</h4>
    <p class="text-center text-muted mb-4">
        Patient / Doctor / Admin Access
    </p>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger py-2 mb-3">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${errorMsg}
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success py-2 mb-3">
                <i class="fa-solid fa-circle-check me-2"></i>${successMsg}
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>

        <!-- Role -->
        <label class="form-label">Login As *</label>
        <select name="role" class="form-select mb-3" required>
            <option value="">Select Role</option>
            <option value="patient">Patient</option>
            <option value="doctor">Doctor</option>
            <option value="admin">Admin</option>
        </select>

        <!-- Email -->
        <label class="form-label">Email Address</label>
        <div class="input-group mb-3">
            <span class="input-group-text">
                <i class="fa fa-envelope"></i>
            </span>
            <input type="email" name="email"
                   class="form-control"
                   placeholder="Enter your email"
                   required>
        </div>

        <!-- Password -->
        <label class="form-label">Password</label>
        <div class="input-group mb-3">
            <span class="input-group-text">
                <i class="fa fa-lock"></i>
            </span>
            <input type="password" name="password"
                   id="pass"
                   class="form-control"
                   required>
            <span class="input-group-text" onclick="togglePass()" style="cursor:pointer">
                <i class="fa fa-eye"></i>
            </span>
        </div>

        <div class="d-flex justify-content-between mb-3">
            <div>
                <input type="checkbox"> Remember me
            </div>
            <a href="${pageContext.request.contextPath}/forgot">Forgot Password?</a>
        </div>

        <button class="btn btn-login w-100">
            Sign In
        </button>

    </form>

    <!-- ===== Demo Credentials ===== -->
    <div class="demo-box">
        <strong>Demo Credentials:</strong><br>

        Admin → admin@hms.com / admin123<br>
        Doctor → doctor@hms.com / doc123<br>
        Patient → patient@hms.com / pat123
    </div>

    <div class="text-center mt-3">
        <small>
            Don’t have an account?
            <a href="register">Register here</a>
        </small>
    </div>

</div>
</div>
</section>
</div>

</body>
</html>