package com.hms.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.hms.dao.PatientDAO;
import com.hms.model.Patient;

public class AddPatientServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age"));
        String disease = request.getParameter("disease");

        Patient p = new Patient();
        p.setName(name);
        p.setAge(age);
        p.setDisease(disease);

        boolean status = PatientDAO.addPatient(p);

        if (status) {
            response.sendRedirect("pages/viewPatients.jsp");
        } else {
            response.sendRedirect("pages/error.jsp");
        }
    }
}