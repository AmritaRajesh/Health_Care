package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.ReportDAO;
import com.hms.model.Appointment;
import com.hms.model.Report;
import com.hms.model.User;

@WebServlet("/patient/medical-records")
public class PatientMedicalRecordsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("download".equals(action)) {
            int reportId = Integer.parseInt(request.getParameter("id"));
            ReportDAO dao = new ReportDAO();
            Report r = dao.getReportById(reportId);
            if (r != null && r.getPatientId() == user.getId()) {
                java.io.File file = new java.io.File(r.getFilePath());
                if (file.exists()) {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + r.getFileName() + "\"");
                    try (java.io.FileInputStream fis = new java.io.FileInputStream(file);
                         java.io.OutputStream os = response.getOutputStream()) {
                        byte[] buf = new byte[4096]; int len;
                        while ((len = fis.read(buf)) != -1) os.write(buf, 0, len);
                    }
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/patient/medical-records");
            return;
        }

        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> history = apptDao.getAppointmentsByPatient(user.getId());

        ReportDAO reportDao = new ReportDAO();
        List<Report> reports = reportDao.getReportsByPatient(user.getId());

        request.setAttribute("historyList", history);
        request.setAttribute("reportList", reports);
        request.setAttribute("activeMenu", "medical_records");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_medical_records.jsp").forward(request, response);
    }
}
