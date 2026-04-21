package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.NotificationDAO;
import com.hms.model.Notification;
import com.hms.model.User;

@WebServlet("/doctor/notifications")
public class DoctorNotificationController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NotificationDAO dao = new NotificationDAO();
        List<Notification> list = dao.getNotificationsByUser(user.getId());
        dao.markAllRead(user.getId());

        request.setAttribute("notificationList", list);
        request.setAttribute("activeMenu", "notifications");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_notifications.jsp").forward(request, response);
    }
}
