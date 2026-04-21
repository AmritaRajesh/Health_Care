package com.hms.controller.patient;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.UserDAO;
import com.hms.model.User;

@WebServlet("/patient/profile")
public class PatientProfileController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("patient", user);
        request.setAttribute("activeMenu", "profile");

        request.getRequestDispatcher("/WEB-INF/views/patient/patient_profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login"); //login
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            
            boolean success = dao.updateProfile(user.getId(), fullName, phone);
            if (success) {
                user.setFullName(fullName);
                user.setPhone(phone);
                session.setAttribute("userObj", user);
                session.setAttribute("successMsg", "Profile Updated Successfully");
            } else {
                session.setAttribute("errorMsg", "Profile Update Failed");
            }
            response.sendRedirect(request.getContextPath() + "/patient/profile");
            
        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("errorMsg", "New passwords do not match.");
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            boolean checkOld = dao.checkOldPassword(user.getId(), oldPassword);
            if (checkOld) {
                boolean success = dao.changePassword(user.getId(), newPassword);
                if (success) {
                    session.setAttribute("successMsg", "Password Changed Successfully");
                } else {
                    session.setAttribute("errorMsg", "Password Change Failed");
                }
            } else {
                session.setAttribute("errorMsg", "Old password is incorrect");
            }
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        }
    }
}
