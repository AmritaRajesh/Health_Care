package com.hms.controller.patient;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.MessageDAO;
import com.hms.dao.UserDAO;
import com.hms.model.Appointment;
import com.hms.model.Message;
import com.hms.model.User;

import java.util.LinkedHashMap;

@WebServlet("/patient/chat")
public class PatientChatController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        MessageDAO msgDao = new MessageDAO();
        List<Map<String, Object>> contacts = msgDao.getContacts(user.getId());

        // Also add doctors from appointments as potential contacts
        AppointmentDAO apptDao = new AppointmentDAO();
        List<Appointment> appts = apptDao.getAppointmentsByPatient(user.getId());
        Map<Integer, String> doctorMap = new LinkedHashMap<>();
        UserDAO uDao = new UserDAO();
        for (Appointment a : appts) {
            if (!doctorMap.containsKey(a.getDoctorId())) {
                User doc = uDao.getUserById(a.getDoctorId());
                if (doc != null) doctorMap.put(doc.getId(), doc.getFullName());
            }
        }

        String withParam = request.getParameter("with");
        if (withParam != null) {
            int otherId = Integer.parseInt(withParam);
            List<Message> conversation = msgDao.getConversation(user.getId(), otherId);
            User other = uDao.getUserById(otherId);
            request.setAttribute("conversation", conversation);
            request.setAttribute("chatWith", other);
            request.setAttribute("chatWithId", otherId);
        }

        request.setAttribute("contacts", contacts);
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("activeMenu", "chat");
        request.getRequestDispatcher("/WEB-INF/views/patient/patient_chat.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"patient".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        int receiverId = Integer.parseInt(request.getParameter("receiverId"));
        String msg = request.getParameter("message");
        if (msg != null && !msg.trim().isEmpty()) {
            new MessageDAO().sendMessage(user.getId(), receiverId, msg.trim());
        }
        response.sendRedirect(request.getContextPath() + "/patient/chat?with=" + receiverId);
    }
}
