package com.hms.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.UserDAO;
import com.hms.model.User;

@WebServlet("/patientRegister")
public class PatientRegisterController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession();

        if (password == null || !password.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "Passwords do not match");
            response.sendRedirect("register");
            return;
        }

        User u = new User();
        u.setFullName(name);
        u.setEmail(email);
        u.setPhone(phone);
        u.setPassword(password);
        u.setRole("patient");

        UserDAO dao = new UserDAO();
        boolean f = dao.registerUser(u);

        if (f) {
            session.setAttribute("succMsg", "Registered Successfully");
            response.sendRedirect("login");
        } else {
            session.setAttribute("errorMsg", "Something went wrong on server");
            response.sendRedirect("register");
        }
    }
}
