package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.DoctorDAO;
import com.hms.dao.EmergencyDAO;
import com.hms.model.Doctor;
import com.hms.model.EmergencyCase;
import com.hms.model.User;

@WebServlet("/admin/emergency")
public class AdminEmergencyController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        EmergencyDAO dao = new EmergencyDAO();
        List<EmergencyCase> cases = dao.getAllCases();
        List<Doctor> doctors = new DoctorDAO().getAllDoctors();

        request.setAttribute("caseList", cases);
        request.setAttribute("doctorList", doctors);
        request.setAttribute("activeMenu", "emergency");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_emergency.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        EmergencyDAO dao = new EmergencyDAO();

        if ("add".equals(action)) {
            EmergencyCase c = new EmergencyCase();
            c.setPatientName(request.getParameter("patientName"));
            c.setContact(request.getParameter("contact"));
            c.setDescription(request.getParameter("description"));
            c.setSeverity(request.getParameter("severity"));
            String did = request.getParameter("assignedDoctorId");
            c.setAssignedDoctorId(did != null && !did.isEmpty() ? Integer.parseInt(did) : 0);
            boolean ok = dao.addCase(c);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Emergency case logged." : "Failed to log case.");
        } else if ("status".equals(action)) {
            dao.updateStatus(Integer.parseInt(request.getParameter("id")), request.getParameter("status"));
            session.setAttribute("successMsg", "Case status updated.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/emergency");
    }
}
