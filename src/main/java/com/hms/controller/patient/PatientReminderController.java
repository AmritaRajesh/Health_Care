package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.MedicineReminderDAO;
import com.hms.dao.PrescriptionDAO;
import com.hms.model.MedicineReminder;
import com.hms.model.Prescription;
import com.hms.model.User;

@WebServlet("/patient/reminders")
public class PatientReminderController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        MedicineReminderDAO dao = new MedicineReminderDAO();
        List<MedicineReminder> reminders = dao.getRemindersByPatient(user.getId());
        List<Prescription> prescriptions = new PrescriptionDAO().getPrescriptionsByPatient(user.getId());

        request.setAttribute("reminderList", reminders);
        request.setAttribute("prescriptionList", prescriptions);
        request.setAttribute("activeMenu", "reminders");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_reminders.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        MedicineReminderDAO dao = new MedicineReminderDAO();

        if ("add".equals(action)) {
            MedicineReminder r = new MedicineReminder();
            r.setPatientId(user.getId());
            String pid = request.getParameter("prescriptionId");
            r.setPrescriptionId(pid != null && !pid.isEmpty() ? Integer.parseInt(pid) : 0);
            r.setMedicineName(request.getParameter("medicineName"));
            r.setDosage(request.getParameter("dosage"));
            r.setReminderTime(request.getParameter("reminderTime"));
            r.setDaysOfWeek(request.getParameter("daysOfWeek"));
            boolean ok = dao.addReminder(r);
            session.setAttribute(ok ? "successMsg" : "errorMsg", ok ? "Reminder set!" : "Failed to set reminder.");
        } else if ("toggle".equals(action)) {
            dao.toggleActive(Integer.parseInt(request.getParameter("id")), user.getId());
        } else if ("delete".equals(action)) {
            dao.deleteReminder(Integer.parseInt(request.getParameter("id")), user.getId());
            session.setAttribute("successMsg", "Reminder deleted.");
        }
        response.sendRedirect(request.getContextPath() + "/patient/reminders");
    }
}
