package com.hms.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AdminDAO;
import com.hms.model.Bill;
import com.hms.model.Appointment;
import com.hms.model.User;

@WebServlet("/admin/billing")
public class AdminBillingController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        AdminDAO dao = new AdminDAO();
        List<Bill> bills = dao.getAllBills();
        List<Appointment> appts = dao.getAllAppointments();
        List<User> patients = dao.getAllPatients();

        double totalRevenue = bills.stream().filter(b -> "paid".equals(b.getStatus())).mapToDouble(Bill::getAmount).sum();
        double totalDue = bills.stream().filter(b -> "unpaid".equals(b.getStatus())).mapToDouble(Bill::getAmount).sum();

        request.setAttribute("billList", bills);
        request.setAttribute("apptList", appts);
        request.setAttribute("patientList", patients);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalDue", totalDue);
        request.setAttribute("activeMenu", "billing");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin_billing.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        AdminDAO dao = new AdminDAO();

        if ("add".equals(action)) {
            try {
                Bill b = new Bill();
                b.setPatientId(Integer.parseInt(request.getParameter("patientId")));
                b.setDoctorId(Integer.parseInt(request.getParameter("doctorId")));
                b.setAppointmentId(Integer.parseInt(request.getParameter("appointmentId")));
                b.setDescription(request.getParameter("description"));
                b.setAmount(Double.parseDouble(request.getParameter("amount")));
                boolean ok = dao.addBill(b);
                session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Bill generated." : "Failed to generate bill.");
            } catch (Exception e) { session.setAttribute("errorMsg", "Invalid input."); }
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = dao.deleteBill(id);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Bill deleted." : "Delete failed.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/billing");
    }
}
