package com.hms.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // wipe the entire session cleanly
        }

        // Create a fresh session just to carry the success message
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("successMsg", "You have been logged out successfully.");

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
