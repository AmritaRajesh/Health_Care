package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.FeedbackDAO;
import com.hms.model.Feedback;
import com.hms.model.User;

@WebServlet("/doctor/feedback")
public class DoctorFeedbackController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"doctor".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        FeedbackDAO dao = new FeedbackDAO();
        List<Feedback> list = dao.getFeedbackByDoctor(user.getId());
        double avgRating = dao.getAverageRating(user.getId());

        request.setAttribute("feedbackList", list);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("activeMenu", "feedback");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_feedback.jsp").forward(request, response);
    }
}
