package com.hms.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AdminDAO;
import com.hms.model.User;

@WebServlet("/admin/add-doctor")
public class AdminAddDoctorController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeMenu", "doctors");
        request.getRequestDispatcher("/WEB-INF/views/admin/add_doctor.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("userObj");

        if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String specialization = request.getParameter("specialization");

        User newDoc = new User();
        newDoc.setFullName(fullName);
        newDoc.setEmail(email);
        newDoc.setPassword(password);
        newDoc.setPhone(phone);

        AdminDAO dao = new AdminDAO();
        boolean success = dao.addDoctor(newDoc, specialization);

        if (success) {
            session.setAttribute("successMsg", "Doctor Added Successfully");
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
        } else {
            session.setAttribute("errorMsg", "Failed to add doctor (Email might already exist)");
            response.sendRedirect(request.getContextPath() + "/admin/add-doctor");
        }
    }
}
