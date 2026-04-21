package com.hms.controller.doctor;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.NotificationDAO;
import com.hms.dao.ReportDAO;
import com.hms.model.Appointment;
import com.hms.model.Report;
import com.hms.model.User;

@WebServlet("/doctor/reports")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB
public class DoctorReportController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // Download file
        if ("download".equals(action)) {
            int reportId = Integer.parseInt(request.getParameter("id"));
            ReportDAO dao = new ReportDAO();
            Report r = dao.getReportById(reportId);
            if (r != null && r.getDoctorId() == user.getId()) {
                File file = new File(r.getFilePath());
                if (file.exists()) {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + r.getFileName() + "\"");
                    try (FileInputStream fis = new FileInputStream(file);
                         OutputStream os = response.getOutputStream()) {
                        byte[] buf = new byte[4096];
                        int len;
                        while ((len = fis.read(buf)) != -1) os.write(buf, 0, len);
                    }
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/doctor/reports");
            return;
        }

        // Delete
        if ("delete".equals(action)) {
            int reportId = Integer.parseInt(request.getParameter("id"));
            ReportDAO dao = new ReportDAO();
            Report r = dao.getReportById(reportId);
            if (r != null && r.getDoctorId() == user.getId()) {
                new File(r.getFilePath()).delete();
                dao.deleteReport(reportId, user.getId());
                session.setAttribute("successMsg", "Report deleted.");
            }
            response.sendRedirect(request.getContextPath() + "/doctor/reports");
            return;
        }

        ReportDAO dao = new ReportDAO();
        List<Report> list = dao.getReportsByDoctor(user.getId());

        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> appts = apptDao.getAppointmentsByDoctor(user.getId());

        request.setAttribute("reportList", list);
        request.setAttribute("apptList", appts);
        request.setAttribute("activeMenu", "reports");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_reports.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String reportTitle = request.getParameter("reportTitle");

            Part filePart = request.getPart("reportFile");
            String originalFileName = filePart.getSubmittedFileName();

            if (originalFileName == null || originalFileName.isEmpty()) {
                session.setAttribute("errorMsg", "Please select a file.");
                response.sendRedirect(request.getContextPath() + "/doctor/reports");
                return;
            }

            // Save to uploads/reports/
            String uploadDir = getServletContext().getRealPath("/") + "uploads" + File.separator + "reports";
            new File(uploadDir).mkdirs();

            String savedFileName = System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
            String filePath = uploadDir + File.separator + savedFileName;

            try (InputStream is = filePart.getInputStream();
                 FileOutputStream fos = new FileOutputStream(filePath)) {
                byte[] buf = new byte[4096];
                int len;
                while ((len = is.read(buf)) != -1) fos.write(buf, 0, len);
            }

            Report r = new Report();
            r.setDoctorId(user.getId());
            r.setPatientId(patientId);
            r.setAppointmentId(appointmentId);
            r.setReportTitle(reportTitle);
            r.setFileName(originalFileName);
            r.setFilePath(filePath);

            ReportDAO dao = new ReportDAO();
            boolean success = dao.addReport(r);

            if (success) {
                new NotificationDAO().addNotification(patientId,
                    "Dr. " + user.getFullName() + " has uploaded a new report: " + reportTitle);
                session.setAttribute("successMsg", "Report uploaded successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to save report.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Upload failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/doctor/reports");
    }
}
