package com.hms.controller.doctor;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.hms.dao.MessageDAO;
import com.hms.dao.UserDAO;
import com.hms.model.Message;
import com.hms.model.User;

@WebServlet("/doctor/chat")
public class DoctorChatController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"doctor".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        MessageDAO dao = new MessageDAO();
        List<Map<String, Object>> contacts = dao.getContacts(user.getId());

        String withParam = request.getParameter("with");
        if (withParam != null) {
            int otherId = Integer.parseInt(withParam);
            List<Message> conversation = dao.getConversation(user.getId(), otherId);
            User other = new UserDAO().getUserById(otherId);
            request.setAttribute("conversation", conversation);
            request.setAttribute("chatWith", other);
            request.setAttribute("chatWithId", otherId);
        }

        request.setAttribute("contacts", contacts);
        request.setAttribute("activeMenu", "chat");
        request.getRequestDispatcher("/WEB-INF/views/doctor/doctor_chat.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userObj");
        if (user == null || !"doctor".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        int receiverId = Integer.parseInt(request.getParameter("receiverId"));
        String msg = request.getParameter("message");
        if (msg != null && !msg.trim().isEmpty()) {
            new MessageDAO().sendMessage(user.getId(), receiverId, msg.trim());
        }
        response.sendRedirect(request.getContextPath() + "/doctor/chat?with=" + receiverId);
    }
}
