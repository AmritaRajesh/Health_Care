<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Ratings & Feedback - Doctor</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.rating-card{background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border-radius:14px;padding:30px;margin-bottom:24px;text-align:center;}
.rating-big{font-size:3rem;font-weight:700;margin:10px 0;}
.stars{color:#fbbf24;font-size:1.5rem;}
.fb-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:18px;margin-bottom:14px;}
.fb-stars{color:#f59e0b;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Patient Ratings & Feedback</h1>
<p class="page-subtitle">See what patients are saying about you</p>

<div class="rating-card">
  <div class="text-white-50 text-uppercase small fw-bold">Your Average Rating</div>
  <div class="rating-big"><fmt:formatNumber value="${avgRating}" pattern="#.#"/></div>
  <div class="stars">
    <c:set var="r" value="${avgRating}"/>
    <c:forEach begin="1" end="5" var="i">
      <i class="fa-${i <= r ? 'solid' : 'regular'} fa-star"></i>
    </c:forEach>
  </div>
  <div class="text-white-50 small mt-2">${feedbackList.size()} reviews</div>
</div>

<c:forEach var="f" items="${feedbackList}">
  <div class="fb-card">
    <div class="d-flex justify-content-between align-items-start mb-2">
      <div class="fw-bold text-dark">${f.patientName}</div>
      <div class="text-muted small">${f.createdAt}</div>
    </div>
    <c:if test="${f.rating > 0}">
      <div class="fb-stars mb-2">
        <c:forEach begin="1" end="${f.rating}"><i class="fa-solid fa-star"></i></c:forEach>
        <c:forEach begin="${f.rating+1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
        <span class="text-muted small ms-1">(${f.rating}/5)</span>
      </div>
    </c:if>
    <c:if test="${not empty f.subject}"><div class="fw-semibold text-dark mb-1">${f.subject}</div></c:if>
    <div class="text-muted">${f.message}</div>
  </div>
</c:forEach>
<c:if test="${empty feedbackList}">
  <div class="text-center text-muted p-5 bg-white rounded border"><i class="fa-regular fa-star fs-1 mb-3"></i><h5>No feedback yet.</h5></div>
</c:if>
</div></div></body></html>
