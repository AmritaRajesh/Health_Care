<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Lab Tests - Patient</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.test-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:20px;margin-bottom:14px;transition:.2s;}
.test-card:hover{box-shadow:0 4px 12px rgba(0,0,0,.07);}
.st-recommended{background:#eff6ff;color:#2563eb;padding:4px 12px;border-radius:20px;font-size:.8rem;font-weight:600;}
.st-sample_collected{background:#fffbeb;color:#d97706;padding:4px 12px;border-radius:20px;font-size:.8rem;font-weight:600;}
.st-completed{background:#ecfdf5;color:#059669;padding:4px 12px;border-radius:20px;font-size:.8rem;font-weight:600;}
.result-box{background:#f0fdf4;border:1px solid #bbf7d0;border-radius:8px;padding:12px;margin-top:10px;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Lab Tests</h1>
<p class="page-subtitle">View lab tests recommended by your doctors</p>

<c:if test="${empty testList}">
  <div class="text-center text-muted p-5 bg-white rounded border"><i class="fa-solid fa-flask fs-1 mb-3"></i><h5>No lab tests yet.</h5><p>Lab tests recommended by your doctor will appear here.</p></div>
</c:if>

<c:forEach var="t" items="${testList}">
  <div class="test-card">
    <div class="d-flex justify-content-between align-items-start mb-2">
      <div>
        <div class="fw-bold text-dark fs-5"><i class="fa-solid fa-flask text-primary me-2"></i>${t.testName}</div>
        <div class="text-muted small"><i class="fa-solid fa-user-doctor me-1"></i>Dr. ${t.doctorName} &nbsp;|&nbsp; <i class="fa-regular fa-calendar me-1"></i>${t.createdAt}</div>
      </div>
      <span class="st-${t.status}">${t.status}</span>
    </div>
    <c:if test="${not empty t.instructions}">
      <div class="text-muted small"><i class="fa-solid fa-circle-info me-1 text-primary"></i><strong>Instructions:</strong> ${t.instructions}</div>
    </c:if>
    <c:if test="${t.status eq 'completed' && not empty t.result}">
      <div class="result-box"><strong class="text-success"><i class="fa-solid fa-check-circle me-1"></i>Result:</strong> ${t.result}</div>
    </c:if>
  </div>
</c:forEach>
</div></div></body></html>
