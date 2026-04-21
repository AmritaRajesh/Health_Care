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

@WebServlet("/patient/appointments")
public class PatientApptController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> list = dao.getAppointmentsByPatient(user.getId());

        request.setAttribute("apptList", list);
        request.setAttribute("activeMenu", "appointments");

        request.getRequestDispatcher("/WEB-INF/views/patient/patient_appointments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.updateAppointmentStatus(id, "rejected");
            if (success) {
                session.setAttribute("successMsg", "Appointment cancelled.");
            } else {
                session.setAttribute("errorMsg", "Could not cancel appointment.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid request.");
        }
        response.sendRedirect(request.getContextPath() + "/patient/appointments");
    }
}
