<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Feedback - Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.fb-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:18px;margin-bottom:14px;transition:.2s;}
.fb-card:hover{box-shadow:0 4px 12px rgba(0,0,0,.07);}
.type-feedback{background:#eff6ff;color:#2563eb;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.type-complaint{background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-open{background:#fffbeb;color:#d97706;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-reviewed{background:#eff6ff;color:#2563eb;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.st-closed{background:#ecfdf5;color:#059669;padding:3px 10px;border-radius:20px;font-size:.78rem;font-weight:600;}
.stars{color:#f59e0b;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Feedback & Complaints</h1>
<p class="page-subtitle">Review patient feedback and manage complaints</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>

<c:forEach var="f" items="${feedbackList}">
  <div class="fb-card">
    <div class="d-flex justify-content-between align-items-start mb-2">
      <div>
        <span class="fw-bold text-dark">${f.patientName}</span>
        <c:if test="${not empty f.doctorName}"><span class="text-muted ms-2">→ Dr. ${f.doctorName}</span></c:if>
        <span class="ms-2 type-${f.type}">${f.type}</span>
      </div>
      <div class="d-flex align-items-center gap-2">
        <span class="st-${f.status}">${f.status}</span>
        <span class="text-muted small">${f.createdAt}</span>
      </div>
    </div>
    <c:if test="${f.rating > 0}">
      <div class="stars mb-1">
        <c:forEach begin="1" end="${f.rating}"><i class="fa-solid fa-star"></i></c:forEach>
        <c:forEach begin="${f.rating+1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
        <span class="text-muted small ms-1">(${f.rating}/5)</span>
      </div>
    </c:if>
    <c:if test="${not empty f.subject}"><div class="fw-semibold text-dark mb-1">${f.subject}</div></c:if>
    <div class="text-muted">${f.message}</div>
    <c:if test="${f.status ne 'closed'}">
      <div class="mt-2 d-flex gap-2">
        <c:if test="${f.status eq 'open'}">
          <form action="${pageContext.request.contextPath}/admin/feedback" method="post" style="display:inline;">
            <input type="hidden" name="id" value="${f.id}"><input type="hidden" name="status" value="reviewed">
            <button type="submit" class="btn btn-sm btn-outline-primary fw-bold">Mark Reviewed</button>
          </form>
        </c:if>
        <form action="${pageContext.request.contextPath}/admin/feedback" method="post" style="display:inline;">
          <input type="hidden" name="id" value="${f.id}"><input type="hidden" name="status" value="closed">
          <button type="submit" class="btn btn-sm btn-outline-success fw-bold">Close</button>
        </form>
      </div>
    </c:if>
  </div>
</c:forEach>
<c:if test="${empty feedbackList}">
  <div class="text-center text-muted p-5 bg-white rounded border"><i class="fa-regular fa-comment-dots fs-1 mb-3"></i><h5>No feedback yet.</h5></div>
</c:if>
</div></div></body></html>
