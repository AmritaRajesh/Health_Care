<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Schedule - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.schedule-card {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 20px;
    transition: all 0.2s;
}
.schedule-card:hover {
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
    background: white;
}
.day-title {
    font-size: 1.1rem;
    font-weight: 700;
    color: #1e293b;
    display:flex;
    align-items:center;
    gap: 10px;
    margin-bottom: 12px;
}
.day-title i { color: #10b981; }
.time-slot {
    color: #64748b;
    font-weight: 500;
    font-size: 0.95rem;
    display:flex;
    align-items:center;
    gap: 8px;
}
.btn-delete {
    color: #ef4444; background: none; border: none; font-size: 1.1rem; padding: 4px 8px; cursor: pointer; border-radius: 4px; transition: 0.2s;
}
.btn-delete:hover { background: #fee2e2; }
.form-card {
    background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 30px;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
}
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 20px; }
.form-label { font-weight: 600; font-size: 0.9rem; color: #475569; }
.schedule-header { display: flex; justify-content: space-between; align-items: center; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">My Schedule</h1>
        <p class="page-subtitle">Manage your weekly availability schedule</p>
        
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">${successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <!-- Add Schedule Form -->
        <div class="form-card">
            <h5><i class="fa-solid fa-plus-circle text-primary me-2"></i> Add New Availability</h5>
            <form action="${pageContext.request.contextPath}/doctor/schedule/add" method="post" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Day of Week</label>
                    <select name="dayOfWeek" class="form-select" required>
                        <option value="">Select Day</option>
                        <option value="Monday">Monday</option>
                        <option value="Tuesday">Tuesday</option>
                        <option value="Wednesday">Wednesday</option>
                        <option value="Thursday">Thursday</option>
                        <option value="Friday">Friday</option>
                        <option value="Saturday">Saturday</option>
                        <option value="Sunday">Sunday</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Start Time</label>
                    <input type="time" name="startTime" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">End Time</label>
                    <input type="time" name="endTime" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Add Slot</button>
                </div>
            </form>
        </div>

        <div style="background: white; border-radius:12px; padding:30px; border:1px solid #f1f5f9;">
            <div class="row">
                <c:forEach var="s" items="${scheduleList}">
                    <div class="col-md-6 col-lg-4">
                        <div class="schedule-card">
                            <div class="schedule-header">
                                <div class="day-title mb-0">
                                    <i class="fa-regular fa-calendar-alt"></i>
                                    ${s.dayOfWeek}
                                </div>
                                <a href="${pageContext.request.contextPath}/doctor/schedule/delete?id=${s.id}" class="btn-delete" title="Delete Slot" onclick="return confirm('Are you sure you want to delete this schedule slot?');">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                            </div>
                            <div class="time-slot mt-2">
                                <i class="fa-regular fa-clock"></i>
                                ${s.startTime} - ${s.endTime}
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty scheduleList}">
                    <div class="text-center text-muted col-12 my-4">
                        <i class="fa-solid fa-calendar-xmark fs-1 text-light mb-3"></i>
                        <h5>No Schedule Created</h5>
                        <p>Use the form above to add your availability slots.</p>
                    </div>
                </c:if>
            </div>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->

</body>
</html>
