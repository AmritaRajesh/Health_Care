package com.hms.controller.doctor;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.ScheduleDAO;
import com.hms.model.Schedule;
import com.hms.model.User;

@WebServlet("/doctor/schedule/add")
public class DoctorAddScheduleController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String dayOfWeek = request.getParameter("dayOfWeek");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        Schedule s = new Schedule();
        s.setDoctorId(user.getId());
        s.setDayOfWeek(dayOfWeek);
        s.setStartTime(startTime);
        s.setEndTime(endTime);

        ScheduleDAO dao = new ScheduleDAO();
        boolean f = dao.addSchedule(s);

        if (f) {
            session.setAttribute("successMsg", "Schedule added successfully");
        } else {
            session.setAttribute("errorMsg", "Failed to add schedule");
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }
}
