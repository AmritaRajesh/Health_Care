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

@WebServlet("/forgot")
public class ForgotController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/forgetpass.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user != null) {
            // In production you'd send an email. For demo, show the password.
            session.setAttribute("successMsg",
                "Account found! Your registered password is on file. Please contact admin to reset: admin@hms.com");
        } else {
            session.setAttribute("errorMsg", "No account found with that email address.");
        }
        response.sendRedirect(request.getContextPath() + "/forgot");
    }
}
