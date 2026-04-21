package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AdminDAO;
import com.hms.model.Appointment;
import com.hms.model.User;

@WebServlet("/admin/appointments")
public class AdminApptController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        AdminDAO dao = new AdminDAO();
        List<Appointment> list = dao.getAllAppointments();
        request.setAttribute("apptList", list);
        request.setAttribute("activeMenu", "appointments");
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_appointments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        AdminDAO dao = new AdminDAO();
        boolean ok = dao.updateAppointmentStatus(id, status);
        session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Appointment updated." : "Update failed.");
        response.sendRedirect(request.getContextPath() + "/admin/appointments");
    }
}
