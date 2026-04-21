<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body { background: #eef2f7; }
.card-box { width: 420px; background: white; border-radius: 16px; padding: 36px; margin: 80px auto; box-shadow: 0 15px 35px rgba(0,0,0,0.08); }
.icon-circle { width: 64px; height: 64px; border-radius: 50%; background: #fef3c7; display: flex; align-items: center; justify-content: center; font-size: 26px; color: #d97706; margin: 0 auto 16px; }
.form-control { background: #f8fafc; border-radius: 10px; }
.btn-reset { background: linear-gradient(135deg,#d97706,#f59e0b); border: none; color: white; font-weight: 600; padding: 12px; border-radius: 10px; }
</style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="card-box">
    <div class="icon-circle"><i class="fa-solid fa-key"></i></div>
    <h4 class="text-center fw-bold">Forgot Password?</h4>
    <p class="text-center text-muted mb-4">Enter your registered email to reset your password.</p>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <form action="${pageContext.request.contextPath}/forgot" method="post">
        <label class="form-label fw-semibold">Email Address</label>
        <div class="input-group mb-3">
            <span class="input-group-text"><i class="fa fa-envelope"></i></span>
            <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
        </div>
        <button type="submit" class="btn btn-reset w-100">
            <i class="fa-solid fa-paper-plane me-2"></i>Send Reset Link
        </button>
    </form>

    <div class="text-center mt-3">
        <small><a href="${pageContext.request.contextPath}/login" class="text-decoration-none">← Back to Login</a></small>
    </div>
</div>
</body>
</html>
