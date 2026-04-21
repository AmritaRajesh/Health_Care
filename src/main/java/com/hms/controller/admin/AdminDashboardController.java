package com.hms.controller.admin;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AdminDAO;
import com.hms.model.User;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AdminDAO dao = new AdminDAO();
        Map<String, Integer> stats = dao.getSystemStats();
        java.util.List<com.hms.model.Appointment> recentAppts = dao.getAllAppointments().stream().limit(5).toList();

        request.setAttribute("stats", stats);
        request.setAttribute("recentAppts", recentAppts);
        request.setAttribute("activeMenu", "dashboard");

        request.getRequestDispatcher("/WEB-INF/views/admin/admin_dashboard.jsp").forward(request, response);
    }
}
