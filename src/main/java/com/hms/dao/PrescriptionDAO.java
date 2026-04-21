package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Prescription;
import com.hms.util.DBConnection;

public class PrescriptionDAO {

    public boolean addPrescription(Prescription p) {
        try {
            Connection con = DBConnection.getConnection();
            String q = "INSERT INTO prescriptions(doctor_id, patient_id, appointment_id, medicines, dosage, notes) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, p.getDoctorId());
            ps.setInt(2, p.getPatientId());
            ps.setInt(3, p.getAppointmentId());
            ps.setString(4, p.getMedicines());
            ps.setString(5, p.getDosage());
            ps.setString(6, p.getNotes());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Prescription> getPrescriptionsByDoctor(int doctorId) {
        List<Prescription> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT p.*, u.full_name as patient_name FROM prescriptions p JOIN users u ON p.patient_id=u.id WHERE p.doctor_id=? ORDER BY p.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prescription p = new Prescription();
                p.setId(rs.getInt("id"));
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setMedicines(rs.getString("medicines"));
                p.setDosage(rs.getString("dosage"));
                p.setNotes(rs.getString("notes"));
                p.setCreatedAt(rs.getString("created_at"));
                p.setPatientName(rs.getString("patient_name"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Prescription> getPrescriptionsByPatient(int patientId) {
        List<Prescription> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT p.*, u.full_name as doctor_name FROM prescriptions p JOIN users u ON p.doctor_id=u.id WHERE p.patient_id=? ORDER BY p.created_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prescription p = new Prescription();
                p.setId(rs.getInt("id"));
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setMedicines(rs.getString("medicines"));
                p.setDosage(rs.getString("dosage"));
                p.setNotes(rs.getString("notes"));
                p.setCreatedAt(rs.getString("created_at"));
                p.setDoctorName(rs.getString("doctor_name"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
