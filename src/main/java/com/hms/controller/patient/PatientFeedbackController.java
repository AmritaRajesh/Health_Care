package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.DoctorDAO;
import com.hms.dao.FeedbackDAO;
import com.hms.model.Appointment;
import com.hms.model.Doctor;
import com.hms.model.Feedback;
import com.hms.model.User;

import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/patient/feedback")
public class PatientFeedbackController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        List<Doctor> doctors = new DoctorDAO().getAllDoctors();
        request.setAttribute("doctorList", doctors);
        request.setAttribute("activeMenu", "feedback");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_feedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Feedback f = new Feedback();
        f.setPatientId(user.getId());

        // doctor — empty string means no doctor selected
        String did = request.getParameter("doctorId");
        f.setDoctorId(did != null && !did.trim().isEmpty() ? Integer.parseInt(did) : 0);

        // rating — 0 means not rated (DAO will store NULL)
        String ratingStr = request.getParameter("rating");
        f.setRating(ratingStr != null && !ratingStr.trim().isEmpty() ? Integer.parseInt(ratingStr) : 0);

        f.setSubject(request.getParameter("subject"));
        f.setMessage(request.getParameter("message"));
        f.setType("complaint".equals(request.getParameter("type")) ? "complaint" : "feedback");

        boolean ok = new FeedbackDAO().addFeedback(f);
        session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Thank you for your feedback!" : "Failed to submit.");
        response.sendRedirect(request.getContextPath() + "/patient/feedback");
    }
}
