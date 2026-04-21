<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Reports - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 28px; }
.form-card h5 { font-weight: 700; color: #1e293b; margin-bottom: 20px; }
.form-label { font-weight: 600; font-size: 0.88rem; color: #475569; }
.upload-zone { border: 2px dashed #cbd5e1; border-radius: 10px; padding: 30px; text-align: center; background: #f8fafc; cursor: pointer; transition: 0.2s; }
.upload-zone:hover { border-color: #3b82f6; background: #eff6ff; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 14px 18px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.file-icon { font-size: 1.4rem; color: #3b82f6; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Upload Reports</h1>
    <p class="page-subtitle">Upload test results and documents for patients</p>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <!-- Upload Form -->
    <div class="form-card">
        <h5><i class="fa-solid fa-file-arrow-up text-primary me-2"></i>Upload New Report</h5>
        <form action="${pageContext.request.contextPath}/doctor/reports" method="post" enctype="multipart/form-data">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Select Appointment</label>
                    <select name="appointmentId" class="form-select" id="apptSel" required onchange="fillPat(this)">
                        <option value="">-- Select Appointment --</option>
                        <c:forEach var="a" items="${apptList}">
                            <option value="${a.id}" data-patient="${a.patientId}">${a.patientName} - ${a.appointmentDate}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Patient ID</label>
                    <input type="number" name="patientId" id="patIdField" class="form-control" readonly required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Report Title</label>
                    <input type="text" name="reportTitle" class="form-control" placeholder="e.g. Blood Test Results" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Report File (PDF, JPG, PNG, DOCX)</label>
                    <input type="file" name="reportFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png,.docx,.doc" required>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary fw-bold px-4">
                        <i class="fa-solid fa-upload me-2"></i>Upload Report
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Reports List -->
    <div class="form-card">
        <h5><i class="fa-solid fa-folder-open text-secondary me-2"></i>Uploaded Reports</h5>
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>File</th>
                        <th>Title</th>
                        <th>Patient</th>
                        <th>Uploaded</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reportList}">
                        <tr>
                            <td><i class="fa-solid fa-file-lines file-icon"></i></td>
                            <td class="fw-bold">${r.reportTitle}</td>
                            <td>${r.patientName}</td>
                            <td class="text-muted small">${r.uploadedAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/doctor/reports?action=download&id=${r.id}" class="btn btn-sm btn-outline-primary fw-bold me-1">
                                    <i class="fa-solid fa-download me-1"></i>Download
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/reports?action=delete&id=${r.id}" class="btn btn-sm btn-outline-danger fw-bold"
                                   onclick="return confirm('Delete this report?')">
                                    <i class="fa-solid fa-trash me-1"></i>Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty reportList}">
                        <tr><td colspan="5" class="text-center text-muted p-4">No reports uploaded yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div></div>
<script>
function fillPat(sel) {
    var opt = sel.options[sel.selectedIndex];
    document.getElementById('patIdField').value = opt.getAttribute('data-patient') || '';
}
</script>
</body>
</html>
