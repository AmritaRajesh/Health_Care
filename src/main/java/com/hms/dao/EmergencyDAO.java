package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.EmergencyCase;
import com.hms.util.DBConnection;

public class EmergencyDAO {

    public boolean addCase(EmergencyCase c) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO emergency_cases(patient_name,patient_id,contact,description,severity,assigned_doctor_id) VALUES(?,?,?,?,?,?)");
            ps.setString(1, c.getPatientName());
            if (c.getPatientId() > 0) ps.setInt(2, c.getPatientId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, c.getContact()); ps.setString(4, c.getDescription()); ps.setString(5, c.getSeverity());
            if (c.getAssignedDoctorId() > 0) ps.setInt(6, c.getAssignedDoctorId()); else ps.setNull(6, Types.INTEGER);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<EmergencyCase> getAllCases() {
        List<EmergencyCase> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT e.*, u.full_name as doctor_name FROM emergency_cases e LEFT JOIN users u ON e.assigned_doctor_id=u.id ORDER BY e.created_at DESC";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        try {
            Connection con = DBConnection.getConnection();
            String q = status.equals("resolved")
                ? "UPDATE emergency_cases SET status=?, resolved_at=NOW() WHERE id=?"
                : "UPDATE emergency_cases SET status=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public int getOpenCount() {
        try {
            Connection con = DBConnection.getConnection();
            ResultSet rs = con.prepareStatement("SELECT COUNT(*) FROM emergency_cases WHERE status != 'resolved'").executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private EmergencyCase mapRow(ResultSet rs) throws SQLException {
        EmergencyCase c = new EmergencyCase();
        c.setId(rs.getInt("id")); c.setPatientName(rs.getString("patient_name"));
        c.setPatientId(rs.getInt("patient_id")); c.setContact(rs.getString("contact"));
        c.setDescription(rs.getString("description")); c.setSeverity(rs.getString("severity"));
        c.setStatus(rs.getString("status")); c.setAssignedDoctorId(rs.getInt("assigned_doctor_id"));
        c.setCreatedAt(rs.getString("created_at")); c.setResolvedAt(rs.getString("resolved_at"));
        try { c.setAssignedDoctorName(rs.getString("doctor_name")); } catch (Exception ignored) {}
        return c;
    }
}
