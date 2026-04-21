<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Feedback - Patient</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.form-card{background:white;border:1px solid #e2e8f0;border-radius:12px;padding:28px;max-width:700px;}
.star-rating{display:flex;gap:8px;font-size:1.8rem;margin:10px 0;}
.star-rating i{cursor:pointer;color:#cbd5e1;transition:.2s;}
.star-rating i:hover,.star-rating i.active{color:#f59e0b;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Feedback & Rating</h1>
<p class="page-subtitle">Share your experience and help us improve</p>
<c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div><c:remove var="successMsg" scope="session"/></c:if>
<c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div><c:remove var="errorMsg" scope="session"/></c:if>

<div class="form-card">
  <h5 class="fw-bold text-dark mb-3"><i class="fa-regular fa-star text-warning me-2"></i>Submit Feedback</h5>
  <form action="${pageContext.request.contextPath}/patient/feedback" method="post">
    <div class="mb-3"><label class="form-label fw-bold text-secondary">Type</label>
      <div class="d-flex gap-3">
        <label class="form-check-label"><input type="radio" name="type" value="feedback" class="form-check-input" checked> Feedback</label>
        <label class="form-check-label"><input type="radio" name="type" value="complaint" class="form-check-input"> Complaint</label>
      </div>
    </div>
    <div class="mb-3"><label class="form-label fw-bold text-secondary">Doctor (optional)</label>
      <select name="doctorId" class="form-select">
        <option value="">-- General Feedback --</option>
        <c:forEach var="d" items="${doctorList}"><option value="${d.id}">Dr. ${d.fullName} (${d.specialization})</option></c:forEach>
      </select>
    </div>
    <div class="mb-3"><label class="form-label fw-bold text-secondary">Rating (optional)</label>
      <div class="star-rating" id="starRating">
        <i class="fa-regular fa-star" data-value="1"></i>
        <i class="fa-regular fa-star" data-value="2"></i>
        <i class="fa-regular fa-star" data-value="3"></i>
        <i class="fa-regular fa-star" data-value="4"></i>
        <i class="fa-regular fa-star" data-value="5"></i>
      </div>
      <input type="hidden" name="rating" id="ratingValue" value="0">
    </div>
    <div class="mb-3"><label class="form-label fw-bold text-secondary">Subject</label><input type="text" name="subject" class="form-control" placeholder="Brief title"></div>
    <div class="mb-3"><label class="form-label fw-bold text-secondary">Message</label><textarea name="message" class="form-control" rows="4" placeholder="Share your experience..." required></textarea></div>
    <button type="submit" class="btn btn-primary fw-bold px-4"><i class="fa-solid fa-paper-plane me-2"></i>Submit</button>
  </form>
</div>
</div></div>
<script>
document.querySelectorAll('#starRating i').forEach(s=>{
  s.addEventListener('click',function(){
    var v=this.getAttribute('data-value');
    document.getElementById('ratingValue').value=v;
    document.querySelectorAll('#starRating i').forEach((st,i)=>{
      st.className=i<v?'fa-solid fa-star active':'fa-regular fa-star';
    });
  });
});
</script>
</body></html>
