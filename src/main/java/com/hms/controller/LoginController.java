package com.hms.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.DoctorDAO;
import com.hms.dao.UserDAO;
import com.hms.model.Doctor;
import com.hms.model.User;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, go straight to dashboard — no re-login
        HttpSession session = request.getSession(false);
        if (session != null) {
            User existing = (User) session.getAttribute("userObj");
            if (existing != null) {
                response.sendRedirect(request.getContextPath() + getDashboard(existing.getRole()));
                return;
            }
        }

        request.setAttribute("activePage", "login");
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");

        UserDAO udao = new UserDAO();
        User user = udao.login(email, password, role);

        if (user != null) {
            // Invalidate any old session first, then create a fresh one
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) oldSession.invalidate();

            HttpSession session = request.getSession(true);
            session.setAttribute("userObj", user);
            session.setMaxInactiveInterval(60 * 60); // 1 hour

            // Load doctor-specific object into session
            if ("doctor".equals(user.getRole())) {
                DoctorDAO ddao = new DoctorDAO();
                Doctor doctor = ddao.getDoctorByUserId(user.getId());
                if (doctor != null) session.setAttribute("doctorObj", doctor);
            }

            // If the filter saved a redirect URL, use it; otherwise go to dashboard
            String redirect = (String) session.getAttribute("redirectAfterLogin");
            session.removeAttribute("redirectAfterLogin");

            if (redirect != null && !redirect.isEmpty()
                    && !redirect.contains("/login")
                    && !redirect.contains("/register")) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + getDashboard(user.getRole()));
            }

        } else {
            HttpSession session = request.getSession(true);
            session.setAttribute("errorMsg", "Invalid email, password or role. Please try again.");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private String getDashboard(String role) {
        switch (role) {
            case "admin":  return "/admin/dashboard";
            case "doctor": return "/doctor/dashboard";
            default:       return "/patient/dashboard";
        }
    }
}
