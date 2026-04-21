package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.NotificationDAO;
import com.hms.model.Notification;
import com.hms.model.User;

@WebServlet("/patient/notifications")
public class PatientNotificationController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NotificationDAO dao = new NotificationDAO();
        List<Notification> list = dao.getNotificationsByUser(user.getId());
        dao.markAllRead(user.getId());

        request.setAttribute("notificationList", list);
        request.setAttribute("activeMenu", "notifications");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_notifications.jsp").forward(request, response);
    }
}
