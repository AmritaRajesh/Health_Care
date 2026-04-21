package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.PrescriptionDAO;
import com.hms.model.Prescription;
import com.hms.model.User;

@WebServlet("/patient/prescriptions")
public class PatientPrescriptionController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PrescriptionDAO dao = new PrescriptionDAO();
        List<Prescription> list = dao.getPrescriptionsByPatient(user.getId());

        request.setAttribute("prescriptionList", list);
        request.setAttribute("activeMenu", "prescriptions");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_prescriptions.jsp").forward(request, response);
    }
}
