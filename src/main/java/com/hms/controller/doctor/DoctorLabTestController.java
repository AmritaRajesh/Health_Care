package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.LabTestDAO;
import com.hms.model.Appointment;
import com.hms.model.LabTest;
import com.hms.model.User;

@WebServlet("/doctor/lab-tests")
public class DoctorLabTestController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"doctor".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        LabTestDAO dao = new LabTestDAO();
        List<LabTest> tests = dao.getTestsByDoctor(user.getId());
        List<Appointment> appts = new AppointmentDAO().getAppointmentsByDoctor(user.getId());

        request.setAttribute("testList", tests);
        request.setAttribute("apptList", appts);
        request.setAttribute("activeMenu", "lab-tests");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_lab_tests.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"doctor".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        LabTestDAO dao = new LabTestDAO();

        if ("add".equals(action)) {
            LabTest t = new LabTest();
            t.setDoctorId(user.getId());
            t.setPatientId(Integer.parseInt(request.getParameter("patientId")));
            t.setAppointmentId(Integer.parseInt(request.getParameter("appointmentId")));
            t.setTestName(request.getParameter("testName"));
            t.setInstructions(request.getParameter("instructions"));
            boolean ok = dao.addLabTest(t);
            // Notify patient
            if (ok) new com.hms.dao.NotificationDAO().addNotification(t.getPatientId(),
                "Dr. " + user.getFullName() + " has recommended a lab test: " + t.getTestName());
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Lab test recommended." : "Failed.");
        } else if ("result".equals(action)) {
            dao.updateStatus(Integer.parseInt(request.getParameter("id")), request.getParameter("status"), request.getParameter("result"));
            session.setAttribute("successMsg", "Test result updated.");
        }
        response.sendRedirect(request.getContextPath() + "/doctor/lab-tests");
    }
}
