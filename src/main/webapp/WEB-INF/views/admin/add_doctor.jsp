<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Doctor - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; padding: 30px; max-width: 600px; }
.form-label { font-size: 0.9rem; font-weight: 600; color: #475569; margin-bottom: 8px; }
.form-control, .form-select { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 15px; color: #334155; }
.form-control:focus, .form-select:focus { background: white; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
.submit-btn { background: #6366f1; color: white; border: none; padding: 14px; border-radius: 8px; font-weight: 600; width: 100%; font-size: 1rem; margin-top: 10px; transition: 0.2s; }
.submit-btn:hover { background: #4f46e5; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="text-decoration-none text-muted fw-bold">
                <i class="fa fa-arrow-left me-1"></i> Back to Doctors
            </a>
        </div>

        <h1 class="page-title">Register New Doctor</h1>
        <p class="page-subtitle">Provision system access for a new medical professional</p>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger" style="max-width:600px;">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/add-doctor" method="post">
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-control" placeholder="e.g. John Smith" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Email Address (Login)</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label">Initial Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Specialization</label>
                        <select class="form-select" name="specialization" required>
                            <option value="">-- Select --</option>
                            <option value="Cardiologist">Cardiologist</option>
                            <option value="Dermatologist">Dermatologist</option>
                            <option value="Neurologist">Neurologist</option>
                            <option value="Pediatrician">Pediatrician</option>
                            <option value="Psychiatrist">Psychiatrist</option>
                            <option value="General Physician">General Physician</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" required>
                    </div>

                    <div class="col-md-12">
                        <button type="submit" class="submit-btn">
                            <i class="fa-solid fa-user-plus me-2"></i> Register Doctor
                        </button>
                    </div>
                </div>
            </form>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->
</body>
</html>
