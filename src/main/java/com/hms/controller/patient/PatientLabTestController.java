package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.LabTestDAO;
import com.hms.model.LabTest;
import com.hms.model.User;

@WebServlet("/patient/lab-tests")
public class PatientLabTestController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        List<LabTest> tests = new LabTestDAO().getTestsByPatient(user.getId());
        request.setAttribute("testList", tests);
        request.setAttribute("activeMenu", "lab-tests");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_lab_tests.jsp").forward(request, response);
    }
}
