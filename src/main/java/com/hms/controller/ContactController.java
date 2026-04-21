package com.hms.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/contact")
public class ContactController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "contact");
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real app you'd email or save this. For now just show success.
        HttpSession session = request.getSession();
        session.setAttribute("successMsg", "Thank you! Your message has been received. We'll get back to you soon.");
        response.sendRedirect(request.getContextPath() + "/contact");
    }
}
