package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Feedback;
import com.hms.util.DBConnection;

public class FeedbackDAO {

    public boolean addFeedback(Feedback f) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO feedback(patient_id,doctor_id,rating,subject,message,type) VALUES(?,?,?,?,?,?)");
            ps.setInt(1, f.getPatientId());
            // doctor_id — null if not selected
            if (f.getDoctorId() > 0) ps.setInt(2, f.getDoctorId()); else ps.setNull(2, Types.INTEGER);
            // rating — null if 0 (avoids CHECK constraint violation)
            if (f.getRating() > 0) ps.setInt(3, f.getRating()); else ps.setNull(3, Types.INTEGER);
            // subject — null if empty
            String subj = f.getSubject();
            if (subj != null && !subj.trim().isEmpty()) ps.setString(4, subj.trim()); else ps.setNull(4, Types.VARCHAR);
            ps.setString(5, f.getMessage());
            ps.setString(6, f.getType() != null ? f.getType() : "feedback");
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT f.*, u1.full_name as patient_name, u2.full_name as doctor_name " +
                       "FROM feedback f JOIN users u1 ON f.patient_id=u1.id LEFT JOIN users u2 ON f.doctor_id=u2.id ORDER BY f.created_at DESC";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Feedback> getFeedbackByDoctor(int doctorId) {
        List<Feedback> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT f.*, u.full_name as patient_name FROM feedback f JOIN users u ON f.patient_id=u.id WHERE f.doctor_id=? ORDER BY f.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public double getAverageRating(int doctorId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT AVG(rating) FROM feedback WHERE doctor_id=? AND rating > 0");
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean updateStatus(int id, String status) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE feedback SET status=? WHERE id=?");
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("id"));
        f.setPatientId(rs.getInt("patient_id"));
        f.setDoctorId(rs.getInt("doctor_id"));
        // rating can be NULL — getInt returns 0 for NULL which is fine
        f.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : 0);
        f.setSubject(rs.getString("subject"));
        f.setMessage(rs.getString("message"));
        f.setType(rs.getString("type"));
        f.setStatus(rs.getString("status"));
        f.setCreatedAt(rs.getString("created_at"));
        try { f.setPatientName(rs.getString("patient_name")); } catch (Exception ignored) {}
        try { f.setDoctorName(rs.getString("doctor_name")); } catch (Exception ignored) {}
        return f;
    }
}
