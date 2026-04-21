package com.hms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.hms.model.User;
import com.hms.util.DBConnection;

public class UserDAO {

    public User login(String email, String password, String role) {
        User user = null;
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM users WHERE email=? AND password=? AND role=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone"),
                    rs.getString("role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateProfile(int userId, String fullName, String phone) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "UPDATE users SET full_name=?, phone=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, userId);

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public boolean checkOldPassword(int userId, String oldPassword) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM users WHERE id=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setString(2, oldPassword);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public boolean changePassword(int userId, String newPassword) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "UPDATE users SET password=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public boolean registerUser(User u) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO users(full_name, email, password, phone, role) VALUES(?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getRole());

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public User getUserById(int id) {
        User u = null;
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM users WHERE id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new User(rs.getInt("id"), rs.getString("full_name"), rs.getString("email"),
                    rs.getString("password"), rs.getString("phone"), rs.getString("role"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    public User getUserByEmail(String email) {
        User u = null;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new User(rs.getInt("id"), rs.getString("full_name"), rs.getString("email"),
                    rs.getString("password"), rs.getString("phone"), rs.getString("role"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }
}
