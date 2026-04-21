package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.FeedbackDAO;
import com.hms.model.Feedback;
import com.hms.model.User;

@WebServlet("/admin/feedback")
public class AdminFeedbackController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        FeedbackDAO dao = new FeedbackDAO();
        List<Feedback> list = dao.getAllFeedback();
        request.setAttribute("feedbackList", list);
        request.setAttribute("activeMenu", "feedback");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_feedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        new FeedbackDAO().updateStatus(id, status);
        session.setAttribute("successMsg", "Feedback status updated.");
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }
}
