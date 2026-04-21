package com.hms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.hms.model.Doctor;
import com.hms.util.DBConnection;

public class DoctorDAO {

    public Doctor getDoctorByUserId(int userId) {
        Doctor doctor = null;
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT d.id as doc_id, d.specialization, u.* FROM doctors d INNER JOIN users u ON d.user_id = u.id WHERE d.user_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setId(rs.getInt("id")); // user id
                doctor.setDoctorId(rs.getInt("doc_id"));
                doctor.setFullName(rs.getString("full_name"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setPassword(rs.getString("password"));
                doctor.setRole("doctor");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctor;
    }

    public void loadDashboardStats(Doctor doctor) {
        if (doctor == null) return;
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Total Appointments
            String q1 = "SELECT COUNT(*) FROM appointments WHERE doctor_id=?";
            PreparedStatement ps1 = con.prepareStatement(q1);
            ps1.setInt(1, doctor.getId());
            ResultSet rs1 = ps1.executeQuery();
            if(rs1.next()) doctor.setTotalAppointments(rs1.getInt(1));

            // Today Appointments
            String q2 = "SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND appointment_date = CURDATE()";
            PreparedStatement ps2 = con.prepareStatement(q2);
            ps2.setInt(1, doctor.getId());
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) doctor.setTodayAppointments(rs2.getInt(1));

            // Pending Appointments
            String q3 = "SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND status='pending'";
            PreparedStatement ps3 = con.prepareStatement(q3);
            ps3.setInt(1, doctor.getId());
            ResultSet rs3 = ps3.executeQuery();
            if(rs3.next()) doctor.setPendingAppointments(rs3.getInt(1));

            // Completed Appointments
            String q4 = "SELECT COUNT(*) FROM appointments WHERE doctor_id=? AND status='completed'";
            PreparedStatement ps4 = con.prepareStatement(q4);
            ps4.setInt(1, doctor.getId());
            ResultSet rs4 = ps4.executeQuery();
            if(rs4.next()) doctor.setCompletedAppointments(rs4.getInt(1));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public java.util.List<Doctor> getAllDoctors() {
        java.util.List<Doctor> list = new java.util.ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT d.id as doc_id, d.specialization, u.* FROM doctors d INNER JOIN users u ON d.user_id = u.id ORDER BY u.full_name ASC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setDoctorId(rs.getInt("doc_id"));
                doctor.setFullName(rs.getString("full_name"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setSpecialization(rs.getString("specialization"));
                list.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
