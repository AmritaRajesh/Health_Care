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
import com.hms.dao.PrescriptionDAO;
import com.hms.dao.UserDAO;
import com.hms.model.Appointment;
import com.hms.model.Prescription;
import com.hms.model.User;

@WebServlet("/doctor/medical-history")
public class DoctorMedicalHistoryController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String patientIdParam = request.getParameter("patientId");

        if (patientIdParam != null) {
            try {
                int patientId = Integer.parseInt(patientIdParam);
                UserDAO uDao = new UserDAO();
                User patient = uDao.getUserById(patientId);

                AppointmentDAO aDao = new AppointmentDAO();
                List<Appointment> history = aDao.getAppointmentsByPatient(patientId);

                PrescriptionDAO pDao = new PrescriptionDAO();
                List<Prescription> prescriptions = pDao.getPrescriptionsByPatient(patientId);

                request.setAttribute("patient", patient);
                request.setAttribute("historyList", history);
                request.setAttribute("prescriptionList", prescriptions);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        // Load all patients this doctor has seen
        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> allAppts = apptDao.getAppointmentsByDoctor(user.getId());
        java.util.Map<Integer, User> patientMap = new java.util.LinkedHashMap<>();
        UserDAO userDao = new UserDAO();
        for (Appointment a : allAppts) {
            if (!patientMap.containsKey(a.getPatientId())) {
                User p = userDao.getUserById(a.getPatientId());
                if (p != null) patientMap.put(a.getPatientId(), p);
            }
        }

        request.setAttribute("patientList", new java.util.ArrayList<>(patientMap.values()));
        request.setAttribute("activeMenu", "medical-history");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_medical_history.jsp").forward(request, response);
    }
}
