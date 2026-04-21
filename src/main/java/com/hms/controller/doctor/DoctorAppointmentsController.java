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
import com.hms.model.Appointment;
import com.hms.model.User;
@WebServlet("/doctor/appointments")
public class DoctorAppointmentsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> list = dao.getAppointmentsByDoctor(user.getId());

        request.setAttribute("apptList", list);
        request.setAttribute("activeMenu", "appointments");

        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_appointments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status"); // 'approved' or 'rejected'

        AppointmentDAO dao = new AppointmentDAO();
        boolean success = dao.updateAppointmentStatus(id, status);

        if (success) {
            // Notify patient — get appointment directly by id
            Appointment a = dao.getAppointmentById(id);
            if (a != null) {
                new com.hms.dao.NotificationDAO().addNotification(a.getPatientId(),
                    "Your appointment on " + a.getAppointmentDate() + " has been " + status + " by Dr. " + user.getFullName() + ".");
            }
            session.setAttribute("successMsg", "Appointment status updated to: " + status);
        } else {
            session.setAttribute("errorMsg", "Something went wrong on server");
        }

        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
    }
}
