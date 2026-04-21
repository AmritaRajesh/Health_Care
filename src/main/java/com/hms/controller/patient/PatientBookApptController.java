package com.hms.controller.patient;

import java.io.IOException;
import java.time.LocalDate;
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

@WebServlet("/patient/book-appointment")
public class PatientBookApptController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DoctorDAO dao = new DoctorDAO();
        List<Doctor> doctorList = dao.getAllDoctors();

        request.setAttribute("doctorList", doctorList);
        request.setAttribute("activeMenu", "book_appointment");

        request.getRequestDispatcher("/WEB-INF/views/patient/patient_book_appointment.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String appointmentDate = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String reason = request.getParameter("reason");

        // Server-side date validation — reject past dates
        try {
            LocalDate selected = LocalDate.parse(appointmentDate);
            if (selected.isBefore(LocalDate.now())) {
                session.setAttribute("errorMsg", "Please select today or a future date.");
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
                return;
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid date format.");
            response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
            return;
        }

        Appointment ap = new Appointment();
        ap.setPatientId(user.getId());
        ap.setDoctorId(doctorId);
        ap.setAppointmentDate(appointmentDate);
        ap.setTimeSlot(timeSlot);
        ap.setReason(reason);
        ap.setStatus("pending");

        AppointmentDAO dao = new AppointmentDAO();
        boolean success = dao.addAppointment(ap);

        if (success) {
            new com.hms.dao.NotificationDAO().addNotification(doctorId,
                "New appointment request from " + user.getFullName() + " on " + appointmentDate + " at " + timeSlot + ".");
            session.setAttribute("successMsg", "Appointment booked successfully! Waiting for doctor approval.");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } else {
            session.setAttribute("errorMsg", "Failed to book appointment. Please try again.");
            response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
        }
    }
}
