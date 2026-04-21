package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Message;
import com.hms.util.DBConnection;

public class MessageDAO {

    public boolean sendMessage(int senderId, int receiverId, String text) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO messages(sender_id, receiver_id, message) VALUES(?,?,?)");
            ps.setInt(1, senderId); ps.setInt(2, receiverId); ps.setString(3, text);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    /** All messages between two users, oldest first */
    public List<Message> getConversation(int userId1, int userId2) {
        List<Message> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT m.*, u1.full_name as sender_name, u2.full_name as receiver_name " +
                       "FROM messages m JOIN users u1 ON m.sender_id=u1.id JOIN users u2 ON m.receiver_id=u2.id " +
                       "WHERE (m.sender_id=? AND m.receiver_id=?) OR (m.sender_id=? AND m.receiver_id=?) " +
                       "ORDER BY m.sent_at ASC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, userId1); ps.setInt(2, userId2);
            ps.setInt(3, userId2); ps.setInt(4, userId1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message m = new Message();
                m.setId(rs.getInt("id")); m.setSenderId(rs.getInt("sender_id"));
                m.setReceiverId(rs.getInt("receiver_id")); m.setMessage(rs.getString("message"));
                m.setRead(rs.getInt("is_read") == 1); m.setSentAt(rs.getString("sent_at"));
                m.setSenderName(rs.getString("sender_name")); m.setReceiverName(rs.getString("receiver_name"));
                list.add(m);
            }
            // Mark as read
            PreparedStatement upd = con.prepareStatement(
                "UPDATE messages SET is_read=1 WHERE receiver_id=? AND sender_id=?");
            upd.setInt(1, userId1); upd.setInt(2, userId2); upd.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Get list of unique contacts (people this user has chatted with) */
    public List<Map<String, Object>> getContacts(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT DISTINCT u.id, u.full_name, u.role, " +
                       "(SELECT COUNT(*) FROM messages WHERE receiver_id=? AND sender_id=u.id AND is_read=0) as unread " +
                       "FROM messages m JOIN users u ON (CASE WHEN m.sender_id=? THEN m.receiver_id ELSE m.sender_id END)=u.id " +
                       "WHERE m.sender_id=? OR m.receiver_id=? ORDER BY u.full_name";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, userId); ps.setInt(2, userId); ps.setInt(3, userId); ps.setInt(4, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id")); row.put("name", rs.getString("full_name"));
                row.put("role", rs.getString("role")); row.put("unread", rs.getInt("unread"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int userId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM messages WHERE receiver_id=? AND is_read=0");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
