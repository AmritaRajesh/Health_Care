package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.dao.DoctorDAO;
import com.hms.model.Department;
import com.hms.model.Doctor;
import com.hms.model.User;

@WebServlet("/admin/departments")
public class AdminDepartmentController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        AdminDAO dao = new AdminDAO();
        List<Department> depts = dao.getAllDepartments();
        List<Doctor> doctors = new DoctorDAO().getAllDoctors();

        request.setAttribute("deptList", depts);
        request.setAttribute("doctorList", doctors);
        request.setAttribute("activeMenu", "departments");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_departments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        AdminDAO dao = new AdminDAO();

        if ("add".equals(action)) {
            Department d = new Department();
            d.setName(request.getParameter("name"));
            d.setDescription(request.getParameter("description"));
            String hid = request.getParameter("headDoctorId");
            d.setHeadDoctorId(hid != null && !hid.isEmpty() ? Integer.parseInt(hid) : 0);
            boolean ok = dao.addDepartment(d);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Department added." : "Failed (name may already exist).");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = dao.deleteDepartment(id);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Department deleted." : "Delete failed.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
