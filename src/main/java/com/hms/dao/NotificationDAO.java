package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Notification;
import com.hms.util.DBConnection;

public class NotificationDAO {

    public List<Notification> getNotificationsByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setId(rs.getInt("id"));
                n.setUserId(rs.getInt("user_id"));
                n.setMessage(rs.getString("message"));
                n.setRead(rs.getInt("is_read") == 1);
                n.setCreatedAt(rs.getString("created_at"));
                list.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int userId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public void markAllRead(int userId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE notifications SET is_read=1 WHERE user_id=?");
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void addNotification(int userId, String message) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO notifications(user_id, message) VALUES(?,?)");
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
