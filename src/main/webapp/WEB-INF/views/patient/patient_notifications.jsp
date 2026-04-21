<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notifications - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.notif-item { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px 20px; margin-bottom: 12px; display: flex; align-items: flex-start; gap: 14px; }
.notif-item.unread { border-left: 4px solid #3b82f6; background: #eff6ff; }
.notif-icon { width: 40px; height: 40px; border-radius: 50%; background: #dbeafe; display: flex; align-items: center; justify-content: center; color: #2563eb; font-size: 1rem; flex-shrink: 0; }
.notif-msg { color: #1e293b; font-size: 0.95rem; }
.notif-time { color: #94a3b8; font-size: 0.8rem; margin-top: 4px; }
.empty-state { text-align: center; padding: 60px; color: #94a3b8; background: white; border-radius: 12px; border: 1px dashed #cbd5e1; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Notifications</h1>
    <p class="page-subtitle">Updates on your appointments, prescriptions, and reports</p>

    <c:if test="${empty notificationList}">
        <div class="empty-state">
            <i class="fa-regular fa-bell-slash fs-1 mb-3"></i>
            <h5 class="fw-bold">No Notifications</h5>
            <p>You're all caught up. New alerts will appear here.</p>
        </div>
    </c:if>

    <c:forEach var="n" items="${notificationList}">
        <div class="notif-item ${n.read ? '' : 'unread'}">
            <div class="notif-icon"><i class="fa-regular fa-bell"></i></div>
            <div>
                <div class="notif-msg">${n.message}</div>
                <div class="notif-time"><i class="fa-regular fa-clock me-1"></i>${n.createdAt}</div>
            </div>
            <c:if test="${!n.read}">
                <span class="ms-auto badge bg-primary rounded-pill" style="font-size:0.7rem;">New</span>
            </c:if>
        </div>
    </c:forEach>

</div></div>
</body>
</html>
