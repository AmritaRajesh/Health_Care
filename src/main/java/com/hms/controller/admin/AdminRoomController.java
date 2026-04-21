package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.dao.RoomDAO;
import com.hms.model.Department;
import com.hms.model.Room;
import com.hms.model.User;

@WebServlet("/admin/rooms")
public class AdminRoomController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        RoomDAO dao = new RoomDAO();
        AdminDAO adminDAO = new AdminDAO();
        List<Room> rooms = dao.getAllRooms();
        List<Department> depts = adminDAO.getAllDepartments();

        request.setAttribute("roomList", rooms);
        request.setAttribute("deptList", depts);
        request.setAttribute("roomStats", dao.getStats());
        request.setAttribute("activeMenu", "rooms");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_rooms.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        RoomDAO dao = new RoomDAO();

        if ("add".equals(action)) {
            Room r = new Room();
            r.setRoomNumber(request.getParameter("roomNumber"));
            r.setRoomType(request.getParameter("roomType"));
            r.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            String did = request.getParameter("departmentId");
            r.setDepartmentId(did != null && !did.isEmpty() ? Integer.parseInt(did) : 0);
            boolean ok = dao.addRoom(r);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Room added." : "Failed (room number may exist).");
        } else if ("delete".equals(action)) {
            boolean ok = dao.deleteRoom(Integer.parseInt(request.getParameter("id")));
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Room deleted." : "Delete failed.");
        } else if ("status".equals(action)) {
            dao.updateStatus(Integer.parseInt(request.getParameter("id")), request.getParameter("status"));
            session.setAttribute("successMsg", "Room status updated.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/rooms");
    }
}
