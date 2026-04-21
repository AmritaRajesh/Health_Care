<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Appointment - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card { background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; padding:30px; max-width: 800px; }
.form-label { font-size: 0.9rem; font-weight: 600; color: #475569; margin-bottom: 8px; }
.form-control, .form-select { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 15px; color: #334155; }
.form-control:focus, .form-select:focus { background: white; border-color: #2b7cff; box-shadow: 0 0 0 3px rgba(43,124,255,0.1); }
.submit-btn { background: #10b981; color: white; border: none; padding: 14px; border-radius: 8px; font-weight: 600; width: 100%; font-size: 1rem; margin-top: 10px; transition: 0.2s; }
.submit-btn:hover { background: #059669; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

        <h1 class="page-title">Book a New Appointment</h1>
        <p class="page-subtitle">Schedule a visit with our specialized doctors</p>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/patient/book-appointment" method="post">
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label">Select Doctor & Specialization</label>
                        <select class="form-select" name="doctorId" required>
                            <option value="">-- Choose a Doctor --</option>
                            <c:forEach var="doc" items="${doctorList}">
                                <option value="${doc.id}">Dr. ${doc.fullName} (${doc.specialization})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Preferred Date</label>
                        <input type="date" name="appointmentDate" id="appointmentDate" class="form-control" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label">Time Slot</label>
                        <select class="form-select" name="timeSlot" required>
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="10:00 AM">10:00 AM</option>
                            <option value="11:00 AM">11:00 AM</option>
                            <option value="12:00 PM">12:00 PM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="03:00 PM">03:00 PM</option>
                            <option value="04:00 PM">04:00 PM</option>
                        </select>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Reason for Visit</label>
                        <textarea class="form-control" name="reason" rows="4" placeholder="Briefly describe your symptoms or reason for visiting..." required></textarea>
                    </div>

                    <div class="col-md-12">
                        <button type="submit" class="submit-btn">
                            <i class="fa-regular fa-calendar-check me-2"></i> Confirm Booking Request
                        </button>
                        <div class="text-center text-muted mt-3" style="font-size: 0.85rem;">
                            Your request will be marked as "Pending" until approved by the doctor.
                        </div>
                    </div>
                </div>
            </form>
        </div>

    </div> <!-- Close main-content -->
</div> <!-- Close dashboard-container -->

<script>
// Set today as the minimum selectable date — no past dates allowed
(function() {
    var today = new Date();
    var yyyy = today.getFullYear();
    var mm   = String(today.getMonth() + 1).padStart(2, '0');
    var dd   = String(today.getDate()).padStart(2, '0');
    var minDate = yyyy + '-' + mm + '-' + dd;
    document.getElementById('appointmentDate').setAttribute('min', minDate);
    document.getElementById('appointmentDate').setAttribute('value', minDate);
})();
</script>
</body>
</html>
