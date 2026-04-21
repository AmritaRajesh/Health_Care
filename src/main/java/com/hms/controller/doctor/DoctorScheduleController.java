package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.ScheduleDAO;
import com.hms.model.Schedule;
import com.hms.model.User;

@WebServlet("/doctor/schedule")
public class DoctorScheduleController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ScheduleDAO dao = new ScheduleDAO();
        List<Schedule> list = dao.getScheduleByDoctor(user.getId());

        request.setAttribute("scheduleList", list);
        request.setAttribute("activeMenu", "schedule");

        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_schedule.jsp").forward(request, response);
    }
}
