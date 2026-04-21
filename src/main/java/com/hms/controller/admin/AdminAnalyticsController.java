package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.model.User;

@WebServlet("/admin/analytics")
public class AdminAnalyticsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        AdminDAO dao = new AdminDAO();
        Map<String, Integer> stats = dao.getSystemStats();
        List<Map<String, Object>> monthly = dao.getMonthlyAppointments();
        List<Map<String, Object>> performance = dao.getDoctorPerformance();

        request.setAttribute("stats", stats);
        request.setAttribute("monthlyData", monthly);
        request.setAttribute("performanceData", performance);
        request.setAttribute("activeMenu", "analytics");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_analytics.jsp").forward(request, response);
    }
}
