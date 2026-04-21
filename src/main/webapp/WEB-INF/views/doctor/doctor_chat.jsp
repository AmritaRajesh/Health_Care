<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chat - Doctor</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.chat-container{display:flex;gap:0;height:calc(100vh - 200px);background:white;border:1px solid #e2e8f0;border-radius:12px;overflow:hidden;}
.contacts{width:280px;border-right:1px solid #e2e8f0;overflow-y:auto;}
.contact-item{padding:14px 16px;border-bottom:1px solid #f1f5f9;cursor:pointer;transition:.2s;}
.contact-item:hover,.contact-item.active{background:#eff6ff;}
.contact-name{font-weight:600;color:#1e293b;font-size:.9rem;}
.contact-role{font-size:.75rem;color:#94a3b8;}
.chat-area{flex:1;display:flex;flex-direction:column;}
.chat-header{padding:16px 20px;border-bottom:1px solid #e2e8f0;background:#f8fafc;}
.messages{flex:1;padding:20px;overflow-y:auto;background:#f8fafc;}
.msg{margin-bottom:14px;display:flex;gap:10px;}
.msg.sent{justify-content:flex-end;}
.msg-bubble{max-width:60%;padding:10px 14px;border-radius:12px;font-size:.9rem;}
.msg.received .msg-bubble{background:white;border:1px solid #e2e8f0;color:#334155;}
.msg.sent .msg-bubble{background:#3b82f6;color:white;}
.msg-time{font-size:.7rem;color:#94a3b8;margin-top:4px;}
.chat-input{padding:16px 20px;border-top:1px solid #e2e8f0;background:white;display:flex;gap:10px;}
.chat-input input{flex:1;border:1px solid #e2e8f0;border-radius:8px;padding:10px 14px;outline:none;}
.chat-input button{background:#3b82f6;color:white;border:none;padding:10px 20px;border-radius:8px;font-weight:600;}
.empty-state{text-align:center;padding:60px;color:#94a3b8;}
</style></head><body>
<jsp:include page="sidebar.jsp"/>
<h1 class="page-title">Chat with Patients</h1>
<p class="page-subtitle">Direct messaging with your patients</p>

<div class="chat-container">
  <div class="contacts">
    <div style="padding:14px 16px;border-bottom:1px solid #e2e8f0;background:#f8fafc;"><strong class="text-dark">Contacts</strong></div>
    <c:forEach var="ct" items="${contacts}">
      <a href="${pageContext.request.contextPath}/doctor/chat?with=${ct.id}" class="contact-item ${chatWithId == ct.id ? 'active' : ''}" style="text-decoration:none;display:block;">
        <div class="contact-name">${ct.name}</div>
        <div class="contact-role">${ct.role} <c:if test="${ct.unread > 0}"><span class="badge bg-danger rounded-pill" style="font-size:.65rem;">${ct.unread}</span></c:if></div>
      </a>
    </c:forEach>
    <c:if test="${empty contacts}"><div class="text-center text-muted p-4 small">No conversations yet.</div></c:if>
  </div>

  <div class="chat-area">
    <c:if test="${empty chatWith}">
      <div class="empty-state"><i class="fa-regular fa-comments fs-1 mb-3"></i><h5>Select a patient to start chatting</h5></div>
    </c:if>
    <c:if test="${not empty chatWith}">
      <div class="chat-header"><strong class="text-dark">${chatWith.fullName}</strong> <span class="text-muted small">(${chatWith.role})</span></div>
      <div class="messages" id="msgArea">
        <c:forEach var="m" items="${conversation}">
          <div class="msg ${m.senderId == userObj.id ? 'sent' : 'received'}">
            <div><div class="msg-bubble">${m.message}</div><div class="msg-time">${m.sentAt}</div></div>
          </div>
        </c:forEach>
      </div>
      <form action="${pageContext.request.contextPath}/doctor/chat" method="post" class="chat-input">
        <input type="hidden" name="receiverId" value="${chatWithId}">
        <input type="text" name="message" placeholder="Type a message..." required autofocus>
        <button type="submit"><i class="fa-solid fa-paper-plane me-1"></i>Send</button>
      </form>
    </c:if>
  </div>
</div>
</div></div>
<script>var m=document.getElementById('msgArea');if(m)m.scrollTop=m.scrollHeight;</script>
</body></html>
