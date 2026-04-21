package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.BillingDAO;
import com.hms.dao.NotificationDAO;
import com.hms.model.Bill;
import com.hms.model.User;

@WebServlet("/patient/billing")
public class PatientBillingController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BillingDAO dao = new BillingDAO();
        List<Bill> bills = dao.getBillsByPatient(user.getId());
        double totalDue = dao.getTotalDue(user.getId());

        request.setAttribute("billList", bills);
        request.setAttribute("totalDue", totalDue);
        request.setAttribute("activeMenu", "billing");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_billing.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int billId = Integer.parseInt(request.getParameter("billId"));
            BillingDAO dao = new BillingDAO();
            boolean success = dao.payBill(billId, user.getId());

            if (success) {
                new NotificationDAO().addNotification(user.getId(), "Payment successful for bill #" + billId + ".");
                session.setAttribute("successMsg", "Payment successful.");
            } else {
                session.setAttribute("errorMsg", "Payment failed or bill already paid.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Invalid request.");
        }

        response.sendRedirect(request.getContextPath() + "/patient/billing");
    }
}
