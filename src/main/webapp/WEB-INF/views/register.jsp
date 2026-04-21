<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Registration</title>

<!-- Bootstrap + Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>

body {
    background: #e9eef5;
}

/* ===== Top Header ===== */
.topbar {
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 12px 24px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 700;
}

.brand-icon {
    background: #2b7cff;
    color: white;
    padding: 6px 10px;
    border-radius: 8px;
}

.top-links a {
    text-decoration: none;
    color: #374151;
    margin-left: 20px;
    font-weight: 500;
}

.btn-register-top {
    background: #2b7cff;
    color: white !important;
    padding: 6px 14px;
    border-radius: 8px;
}

/* ===== Card ===== */
.register-card {
    max-width: 820px;
    margin: 50px auto;
    background: white;
    border-radius: 18px;
    padding: 36px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.08);
}

/* ===== Icon Circle ===== */
.icon-circle {
    width: 64px;
    height: 64px;
    background: #2b7cff;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    margin: 0 auto 15px;
}

/* ===== Form ===== */
.form-label {
    font-weight: 600;
    font-size: 14px;
}

.form-control,
.form-select {
    background: #f8fafc;
    border-radius: 10px;
}

.input-group-text {
    background: #f1f5f9;
}

/* ===== Button ===== */
.btn-register {
    background: #2b7cff;
    border: none;
    color: white;
    font-weight: 600;
    padding: 12px;
    border-radius: 10px;
}

.btn-register:hover {
    background: #1f63d8;
}

</style>
</head>

<body>

<!-- ================= HEADER ================= -->
<jsp:include page="header.jsp" />
<div class="topbar d-flex justify-content-between align-items-center">

<!-- ================= REGISTER CARD ================= -->
<div class="register-card">

    <div class="icon-circle">
        <i class="fa fa-user-plus"></i>
    </div>

    <h3 class="text-center fw-bold">Patient Registration</h3>
    <p class="text-center text-muted mb-4">
        Create your account to book appointments
    </p>

    <c:if test="${not empty succMsg}">
        <p class="text-center text-success fs-5">${succMsg}</p>
        <c:remove var="succMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <p class="text-center text-danger fs-5">${errorMsg}</p>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <form action="patientRegister" method="post">

        <div class="row g-3">

            <!-- Full Name -->
            <div class="col-md-6">
                <label class="form-label">Full Name *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-user"></i></span>
                    <input type="text" name="name" class="form-control"
                           placeholder="John Doe" required>
                </div>
            </div>

            <!-- Email -->
            <div class="col-md-6">
                <label class="form-label">Email Address *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-envelope"></i></span>
                    <input type="email" name="email" class="form-control"
                           placeholder="john@example.com" required>
                </div>
            </div>

            <!-- Phone -->
            <div class="col-md-6">
                <label class="form-label">Phone Number *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-phone"></i></span>
                    <input type="text" name="phone" class="form-control"
                           placeholder="+1 (555) 123-4567" required>
                </div>
            </div>

            <!-- Age -->
            <div class="col-md-6">
                <label class="form-label">Age *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                    <input type="number" name="age" class="form-control"
                           placeholder="25" required>
                </div>
            </div>

            <!-- Gender -->
            <div class="col-md-6">
                <label class="form-label">Gender *</label>
                <select name="gender" class="form-select" required>
                    <option value="">Select Gender</option>
                    <option>Male</option>
                    <option>Female</option>
                    <option>Other</option>
                </select>
            </div>

            <!-- Blood Group -->
            <div class="col-md-6">
                <label class="form-label">Blood Group *</label>
                <select name="blood" class="form-select" required>
                    <option value="">Select Blood Group</option>
                    <option>O+</option><option>A+</option><option>B+</option>
                    <option>AB+</option><option>O-</option><option>A-</option>
                    <option>B-</option><option>AB-</option>
                </select>
            </div>

            <!-- Address -->
            <div class="col-12">
                <label class="form-label">Address *</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fa fa-location-dot"></i>
                    </span>
                    <input type="text" name="address"
                           class="form-control"
                           placeholder="123 Main St, New York, NY"
                           required>
                </div>
            </div>

            <!-- Password -->
            <div class="col-md-6">
                <label class="form-label">Password *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-lock"></i></span>
                    <input type="password" name="password"
                           class="form-control" required>
                </div>
            </div>

            <!-- Confirm -->
            <div class="col-md-6">
                <label class="form-label">Confirm Password *</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa fa-lock"></i></span>
                    <input type="password" name="confirmPassword"
                           class="form-control" required>
                </div>
            </div>

        </div>

        <!-- Terms -->
        <div class="form-check mt-3">
            <input class="form-check-input" type="checkbox" required>
            <label class="form-check-label">
                I agree to the
                <a href="#">Terms and Conditions</a>
                and
                <a href="#">Privacy Policy</a>
            </label>
        </div>

        <!-- Submit -->
        <button class="btn btn-register w-100 mt-4">
            Register
        </button>

        <div class="text-center mt-3">
            <small>
                Already have an account?
                <a href="login">Sign In</a>
            </small>
        </div>

    </form>
</div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>