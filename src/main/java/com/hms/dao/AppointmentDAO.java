package com.hms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.hms.model.Appointment;
import com.hms.util.DBConnection;

public class AppointmentDAO {

    public List<Appointment> getAppointmentsByDoctor(int doctorUserId) {
        List<Appointment> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT a.*, u.full_name as patient_name FROM appointments a INNER JOIN users u ON a.patient_id = u.id WHERE a.doctor_id=? ORDER BY a.appointment_date DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, doctorUserId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setId(rs.getInt("id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(rs.getInt("doctor_id"));
                ap.setAppointmentDate(rs.getString("appointment_date"));
                ap.setTimeSlot(rs.getString("time_slot"));
                ap.setReason(rs.getString("reason"));
                ap.setStatus(rs.getString("status"));
                ap.setPatientName(rs.getString("patient_name"));
                list.add(ap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getUpcomingAppointmentsByDoctor(int doctorUserId) {
        List<Appointment> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT a.*, u.full_name as patient_name FROM appointments a INNER JOIN users u ON a.patient_id = u.id WHERE a.doctor_id=? AND a.status='approved' AND a.appointment_date >= CURDATE() ORDER BY a.appointment_date ASC LIMIT 5";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, doctorUserId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setId(rs.getInt("id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(rs.getInt("doctor_id"));
                ap.setAppointmentDate(rs.getString("appointment_date"));
                ap.setTimeSlot(rs.getString("time_slot"));
                ap.setReason(rs.getString("reason"));
                ap.setStatus(rs.getString("status"));
                ap.setPatientName(rs.getString("patient_name"));
                list.add(ap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateAppointmentStatus(int appointmentId, String status) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "UPDATE appointments SET status=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, appointmentId);

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public Appointment getAppointmentById(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM appointments WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment ap = new Appointment();
                ap.setId(rs.getInt("id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(rs.getInt("doctor_id"));
                ap.setAppointmentDate(rs.getString("appointment_date"));
                ap.setTimeSlot(rs.getString("time_slot"));
                ap.setReason(rs.getString("reason"));
                ap.setStatus(rs.getString("status"));
                return ap;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean addAppointment(Appointment ap) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO appointments(patient_id, doctor_id, appointment_date, time_slot, reason, status) VALUES(?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, ap.getPatientId());
            ps.setInt(2, ap.getDoctorId());
            ps.setString(3, ap.getAppointmentDate());
            ps.setString(4, ap.getTimeSlot());
            ps.setString(5, ap.getReason());
            ps.setString(6, ap.getStatus());
            if (ps.executeUpdate() == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public List<Appointment> getAppointmentsByPatient(int patientUserId) {
        List<Appointment> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT a.*, d.specialization, u.full_name as doctor_name FROM appointments a INNER JOIN doctors d ON a.doctor_id = d.user_id INNER JOIN users u ON d.user_id = u.id WHERE a.patient_id=? ORDER BY a.appointment_date DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, patientUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setId(rs.getInt("id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(rs.getInt("doctor_id"));
                ap.setAppointmentDate(rs.getString("appointment_date"));
                ap.setTimeSlot(rs.getString("time_slot"));
                ap.setReason(rs.getString("reason"));
                ap.setStatus(rs.getString("status"));
                ap.setDoctorName(rs.getString("doctor_name") + " (" + rs.getString("specialization") + ")");
                list.add(ap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
