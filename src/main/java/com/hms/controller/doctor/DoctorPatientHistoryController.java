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
import com.hms.dao.UserDAO;
import com.hms.model.Appointment;
import com.hms.model.User;

@WebServlet("/doctor/patient-history")
public class DoctorPatientHistoryController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("userObj");

        if (loggedInUser == null || !"doctor".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int patientId = Integer.parseInt(request.getParameter("id"));
            
            UserDAO uDao = new UserDAO();
            User patient = uDao.getUserById(patientId);
            
            if (patient == null) {
                session.setAttribute("errorMsg", "Patient not found.");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            AppointmentDAO aDao = new AppointmentDAO();
            List<Appointment> history = aDao.getAppointmentsByPatient(patientId);

            request.setAttribute("patient", patient);
            request.setAttribute("historyList", history);
            request.setAttribute("activeMenu", "appointments");

            request.getRequestDispatcher("/WEB-INF/views/doctor/patient_history.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Invalid patient ID.");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
}
