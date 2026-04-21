package com.hms.controller.doctor;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.ScheduleDAO;
import com.hms.model.User;

@WebServlet("/doctor/schedule/delete")
public class DoctorDeleteScheduleController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            ScheduleDAO dao = new ScheduleDAO();
            boolean f = dao.deleteSchedule(id, user.getId());

            if (f) {
                session.setAttribute("successMsg", "Schedule removed successfully");
            } else {
                session.setAttribute("errorMsg", "Failed to remove schedule");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid Request");
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }
}
