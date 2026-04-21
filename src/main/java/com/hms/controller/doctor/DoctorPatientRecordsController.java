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

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/doctor/patients")
public class DoctorPatientRecordsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO apptDao = new AppointmentDAO();
        UserDAO userDao = new UserDAO();
        List<Appointment> allAppts = apptDao.getAppointmentsByDoctor(user.getId());

        // Build unique patient list
        Map<Integer, User> patientMap = new LinkedHashMap<>();
        for (Appointment a : allAppts) {
            if (!patientMap.containsKey(a.getPatientId())) {
                User patient = userDao.getUserById(a.getPatientId());
                if (patient != null) patientMap.put(a.getPatientId(), patient);
            }
        }

        request.setAttribute("patientList", new ArrayList<>(patientMap.values()));
        request.setAttribute("activeMenu", "patients");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_patients.jsp").forward(request, response);
    }
}
