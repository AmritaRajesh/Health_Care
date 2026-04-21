<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hms.model.User" %>
<%
    // If already logged in, send to their dashboard directly
    User u = (User) session.getAttribute("userObj");
    if (u != null) {
        String role = u.getRole();
        if ("admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("doctor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/home");
    }
%>
