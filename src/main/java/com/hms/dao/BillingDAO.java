package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Bill;
import com.hms.util.DBConnection;

public class BillingDAO {

    public List<Bill> getBillsByPatient(int patientId) {
        List<Bill> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT b.*, u.full_name as doctor_name FROM bills b JOIN users u ON b.doctor_id=u.id WHERE b.patient_id=? ORDER BY b.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill b = mapRow(rs);
                b.setDoctorName(rs.getString("doctor_name"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean payBill(int billId, int patientId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE bills SET status='paid', paid_at=NOW() WHERE id=? AND patient_id=? AND status='unpaid'");
            ps.setInt(1, billId);
            ps.setInt(2, patientId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean addBill(Bill b) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO bills(patient_id, doctor_id, appointment_id, description, amount) VALUES(?,?,?,?,?)");
            ps.setInt(1, b.getPatientId());
            ps.setInt(2, b.getDoctorId());
            ps.setInt(3, b.getAppointmentId());
            ps.setString(4, b.getDescription());
            ps.setDouble(5, b.getAmount());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public double getTotalDue(int patientId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT COALESCE(SUM(amount),0) FROM bills WHERE patient_id=? AND status='unpaid'");
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Bill mapRow(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setId(rs.getInt("id"));
        b.setPatientId(rs.getInt("patient_id"));
        b.setDoctorId(rs.getInt("doctor_id"));
        b.setAppointmentId(rs.getInt("appointment_id"));
        b.setDescription(rs.getString("description"));
        b.setAmount(rs.getDouble("amount"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getString("created_at"));
        b.setPaidAt(rs.getString("paid_at"));
        return b;
    }
}
