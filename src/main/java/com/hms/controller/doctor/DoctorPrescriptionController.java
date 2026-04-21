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
import com.hms.dao.NotificationDAO;
import com.hms.dao.PrescriptionDAO;
import com.hms.model.Appointment;
import com.hms.model.Prescription;
import com.hms.model.User;

@WebServlet("/doctor/prescriptions")
public class DoctorPrescriptionController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PrescriptionDAO dao = new PrescriptionDAO();
        List<Prescription> list = dao.getPrescriptionsByDoctor(user.getId());

        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> appts = apptDao.getAppointmentsByDoctor(user.getId());

        request.setAttribute("prescriptionList", list);
        request.setAttribute("apptList", appts);
        request.setAttribute("activeMenu", "prescriptions");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_prescriptions.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String medicines = request.getParameter("medicines");
            String dosage = request.getParameter("dosage");
            String notes = request.getParameter("notes");

            Prescription p = new Prescription();
            p.setDoctorId(user.getId());
            p.setPatientId(patientId);
            p.setAppointmentId(appointmentId);
            p.setMedicines(medicines);
            p.setDosage(dosage);
            p.setNotes(notes);

            PrescriptionDAO dao = new PrescriptionDAO();
            boolean success = dao.addPrescription(p);

            if (success) {
                // Notify patient
                new NotificationDAO().addNotification(patientId,
                    "Dr. " + user.getFullName() + " has sent you a new prescription.");
                session.setAttribute("successMsg", "Prescription added successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to add prescription.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid input.");
        }

        response.sendRedirect(request.getContextPath() + "/doctor/prescriptions");
    }
}
