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
import com.hms.dao.DoctorDAO;
import com.hms.model.Doctor;
import com.hms.model.User;

@WebServlet("/admin/doctors")
public class AdminDoctorController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        DoctorDAO dDao = new DoctorDAO();
        List<Doctor> list = dDao.getAllDoctors();
        request.setAttribute("doctorList", list);
        request.setAttribute("activeMenu", "doctors");
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_doctors.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }
        int id = Integer.parseInt(request.getParameter("id"));
        AdminDAO dao = new AdminDAO();
        boolean ok = dao.deleteDoctor(id);
        session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Doctor removed." : "Failed to remove doctor.");
        response.sendRedirect(request.getContextPath() + "/admin/doctors");
    }
}
