package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.DoctorDAO;
import com.hms.model.Doctor;
import com.hms.model.User;

@WebServlet("/patient/doctors")
public class PatientDoctorSearchController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DoctorDAO dao = new DoctorDAO();
        List<Doctor> allDoctors = dao.getAllDoctors();

        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            String q = query.trim().toLowerCase();
            allDoctors = allDoctors.stream()
                .filter(d -> d.getFullName().toLowerCase().contains(q)
                          || d.getSpecialization().toLowerCase().contains(q))
                .collect(Collectors.toList());
            request.setAttribute("searchQuery", query);
        }

        request.setAttribute("doctorList", allDoctors);
        request.setAttribute("activeMenu", "doctors");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_doctors.jsp").forward(request, response);
    }
}
