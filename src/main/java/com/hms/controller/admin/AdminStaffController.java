package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.model.Department;
import com.hms.model.Staff;
import com.hms.model.User;

@WebServlet("/admin/staff")
public class AdminStaffController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        AdminDAO dao = new AdminDAO();
        List<Staff> staffList = dao.getAllStaff();
        List<Department> depts = dao.getAllDepartments();

        request.setAttribute("staffList", staffList);
        request.setAttribute("deptList", depts);
        request.setAttribute("activeMenu", "staff");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_staff.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        AdminDAO dao = new AdminDAO();

        if ("add".equals(action)) {
            Staff s = new Staff();
            s.setFullName(request.getParameter("fullName"));
            s.setEmail(request.getParameter("email"));
            s.setPhone(request.getParameter("phone"));
            s.setRole(request.getParameter("role"));
            String did = request.getParameter("departmentId");
            s.setDepartmentId(did != null && !did.isEmpty() ? Integer.parseInt(did) : 0);
            boolean ok = dao.addStaff(s);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Staff member added." : "Failed (email may exist).");
        } else if ("delete".equals(action)) {
            boolean ok = dao.deleteStaff(Integer.parseInt(request.getParameter("id")));
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Staff removed." : "Delete failed.");
        } else if ("toggle".equals(action)) {
            dao.toggleStaffStatus(Integer.parseInt(request.getParameter("id")));
            session.setAttribute("successMsg", "Status updated.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }
}
