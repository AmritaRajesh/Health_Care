package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AppointmentDAO;
import com.hms.model.Appointment;
import com.hms.model.User;

@WebServlet("/patient/dashboard")
public class PatientDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> list = apptDao.getAppointmentsByPatient(user.getId());
        
        int total = list.size();
        int pending = (int) list.stream().filter(a -> "pending".equals(a.getStatus())).count();
        int approved = (int) list.stream().filter(a -> "approved".equals(a.getStatus())).count();
        int completed = (int) list.stream().filter(a -> "completed".equals(a.getStatus())).count();

        request.setAttribute("totalAppts", total);
        request.setAttribute("pendingAppts", pending);
        request.setAttribute("approvedAppts", approved);
        request.setAttribute("completedAppts", completed);
        
        // Show only upcoming up to 5
        List<Appointment> upcoming = list.stream().limit(5).toList();
        request.setAttribute("upcomingList", upcoming);
        request.setAttribute("activeMenu", "dashboard");

        request.getRequestDispatcher("/WEB-INF/views/patient/patient_dashboard.jsp").forward(request, response);
    }
}
