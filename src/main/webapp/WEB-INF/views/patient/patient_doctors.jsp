<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Search - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.search-bar { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px 24px; margin-bottom: 28px; display: flex; gap: 12px; align-items: center; }
.search-bar input { flex: 1; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 16px; background: #f8fafc; color: #334155; outline: none; font-size: 0.95rem; }
.search-bar input:focus { border-color: #3b82f6; background: white; }
.search-bar button { background: #3b82f6; color: white; border: none; padding: 10px 22px; border-radius: 8px; font-weight: 600; cursor: pointer; }
.search-bar button:hover { background: #2563eb; }
.doctor-card { background: white; border: 1px solid #e2e8f0; border-radius: 14px; padding: 24px; transition: 0.2s; height: 100%; }
.doctor-card:hover { box-shadow: 0 8px 20px rgba(0,0,0,0.08); transform: translateY(-3px); }
.doc-avatar { width: 64px; height: 64px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; font-weight: 700; margin-bottom: 14px; }
.doc-name { font-weight: 700; color: #1e293b; font-size: 1.05rem; margin-bottom: 4px; }
.spec-badge { background: #eff6ff; color: #2563eb; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; display: inline-block; margin-bottom: 12px; }
.doc-info { color: #64748b; font-size: 0.85rem; margin-bottom: 6px; }
.btn-book-doc { background: #10b981; color: white; border: none; padding: 9px 18px; border-radius: 8px; font-weight: 600; font-size: 0.88rem; text-decoration: none; display: inline-block; margin-top: 10px; }
.btn-book-doc:hover { background: #059669; color: white; }
.result-count { color: #64748b; font-size: 0.9rem; margin-bottom: 20px; }
.empty-state { text-align: center; padding: 60px; color: #94a3b8; background: white; border-radius: 12px; border: 1px dashed #cbd5e1; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Doctor Search</h1>
    <p class="page-subtitle">Find doctors by name or specialization</p>

    <form method="get" action="${pageContext.request.contextPath}/patient/doctors" class="search-bar">
        <i class="fa-solid fa-magnifying-glass text-muted"></i>
        <input type="text" name="q" value="${searchQuery}" placeholder="Search by doctor name or specialization (e.g. Cardiology)...">
        <button type="submit"><i class="fa-solid fa-search me-1"></i>Search</button>
        <c:if test="${not empty searchQuery}">
            <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-outline-secondary btn-sm fw-bold">Clear</a>
        </c:if>
    </form>

    <c:if test="${not empty searchQuery}">
        <p class="result-count">
            <i class="fa-solid fa-filter me-1"></i>
            Showing results for "<strong>${searchQuery}</strong>" — ${doctorList.size()} found
        </p>
    </c:if>

    <c:if test="${empty doctorList}">
        <div class="empty-state">
            <i class="fa-solid fa-user-doctor fs-1 mb-3"></i>
            <h5 class="fw-bold">No Doctors Found</h5>
            <p>Try a different search term.</p>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="doc" items="${doctorList}">
            <div class="col-md-6 col-lg-4">
                <div class="doctor-card">
                    <div class="doc-avatar">${doc.fullName.substring(0,1).toUpperCase()}</div>
                    <div class="doc-name">Dr. ${doc.fullName}</div>
                    <span class="spec-badge"><i class="fa-solid fa-stethoscope me-1"></i>${doc.specialization}</span>
                    <div class="doc-info"><i class="fa-solid fa-envelope me-2"></i>${doc.email}</div>
                    <div class="doc-info"><i class="fa-solid fa-phone me-2"></i>${doc.phone}</div>
                    <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn-book-doc">
                        <i class="fa-regular fa-calendar-plus me-1"></i>Book Appointment
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

</div></div>
</body>
</html>
