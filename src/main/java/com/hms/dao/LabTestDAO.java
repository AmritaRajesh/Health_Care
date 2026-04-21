package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.LabTest;
import com.hms.util.DBConnection;

public class LabTestDAO {

    public boolean addLabTest(LabTest t) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO lab_tests(doctor_id,patient_id,appointment_id,test_name,instructions) VALUES(?,?,?,?,?)");
            ps.setInt(1, t.getDoctorId()); ps.setInt(2, t.getPatientId());
            ps.setInt(3, t.getAppointmentId()); ps.setString(4, t.getTestName()); ps.setString(5, t.getInstructions());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<LabTest> getTestsByDoctor(int doctorId) {
        List<LabTest> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT t.*, u.full_name as patient_name FROM lab_tests t JOIN users u ON t.patient_id=u.id WHERE t.doctor_id=? ORDER BY t.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<LabTest> getTestsByPatient(int patientId) {
        List<LabTest> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT t.*, u.full_name as doctor_name FROM lab_tests t JOIN users u ON t.doctor_id=u.id WHERE t.patient_id=? ORDER BY t.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LabTest t = mapRow(rs);
                t.setDoctorName(rs.getString("doctor_name"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int id, String status, String result) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE lab_tests SET status=?, result=? WHERE id=?");
            ps.setString(1, status); ps.setString(2, result); ps.setInt(3, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private LabTest mapRow(ResultSet rs) throws SQLException {
        LabTest t = new LabTest();
        t.setId(rs.getInt("id")); t.setDoctorId(rs.getInt("doctor_id")); t.setPatientId(rs.getInt("patient_id"));
        t.setAppointmentId(rs.getInt("appointment_id")); t.setTestName(rs.getString("test_name"));
        t.setInstructions(rs.getString("instructions")); t.setStatus(rs.getString("status"));
        t.setResult(rs.getString("result")); t.setCreatedAt(rs.getString("created_at"));
        try { t.setPatientName(rs.getString("patient_name")); } catch (Exception ignored) {}
        return t;
    }
}
