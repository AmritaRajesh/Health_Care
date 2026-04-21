package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.model.User;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        AdminDAO dao = new AdminDAO();
        List<User> users = dao.getAllUsers();
        request.setAttribute("userList", users);
        request.setAttribute("activeMenu", "users");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_users.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        AdminDAO dao = new AdminDAO();
        boolean ok = dao.deleteUser(id);
        session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "User removed." : "Cannot delete admin accounts.");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
