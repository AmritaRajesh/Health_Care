package com.hms.controller.doctor;

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

@WebServlet("/doctor/profile")
public class DoctorProfileController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DoctorDAO dao = new DoctorDAO();
        Doctor doctor = dao.getDoctorByUserId(user.getId());

        request.setAttribute("doctor", doctor);
        request.setAttribute("activeMenu", "profile");

        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
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
            response.sendRedirect(request.getContextPath() + "/doctor/profile");
            
        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("errorMsg", "New passwords do not match.");
                response.sendRedirect(request.getContextPath() + "/doctor/profile");
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
            response.sendRedirect(request.getContextPath() + "/doctor/profile");
        }
    }
}
