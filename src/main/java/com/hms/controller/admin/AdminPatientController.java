package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AdminDAO;
import com.hms.model.User;

@WebServlet("/admin/patients")
public class AdminPatientController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        AdminDAO dao = new AdminDAO();
        List<User> list = dao.getAllPatients();
        request.setAttribute("patientList", list);
        request.setAttribute("activeMenu", "patients");
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_patients.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        int id = Integer.parseInt(request.getParameter("id"));
        AdminDAO dao = new AdminDAO();
        boolean ok = dao.deletePatient(id);
        session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Patient removed." : "Failed to remove patient.");
        response.sendRedirect(request.getContextPath() + "/admin/patients");
    }
}
