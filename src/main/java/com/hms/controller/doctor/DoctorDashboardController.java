package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.DoctorDAO;
import com.hms.model.Appointment;
import com.hms.model.Doctor;
import com.hms.model.User;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DoctorDAO dao = new DoctorDAO();
        Doctor doctor = dao.getDoctorByUserId(user.getId());
        dao.loadDashboardStats(doctor);
        
        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> upcoming = apptDao.getUpcomingAppointmentsByDoctor(user.getId());

        request.setAttribute("doctor", doctor);
        request.setAttribute("upcomingList", upcoming);
        request.setAttribute("activeMenu", "dashboard");

        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_dashboard.jsp").forward(request, response);
    }
}
