package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Report;
import com.hms.util.DBConnection;

public class ReportDAO {

    public boolean addReport(Report r) {
        try {
            Connection con = DBConnection.getConnection();
            String q = "INSERT INTO reports(doctor_id, patient_id, appointment_id, report_title, file_name, file_path) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, r.getDoctorId());
            ps.setInt(2, r.getPatientId());
            ps.setInt(3, r.getAppointmentId());
            ps.setString(4, r.getReportTitle());
            ps.setString(5, r.getFileName());
            ps.setString(6, r.getFilePath());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Report> getReportsByDoctor(int doctorId) {
        List<Report> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT r.*, u.full_name as patient_name FROM reports r JOIN users u ON r.patient_id=u.id WHERE r.doctor_id=? ORDER BY r.uploaded_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Report r = new Report();
                r.setId(rs.getInt("id"));
                r.setDoctorId(rs.getInt("doctor_id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setReportTitle(rs.getString("report_title"));
                r.setFileName(rs.getString("file_name"));
                r.setFilePath(rs.getString("file_path"));
                r.setUploadedAt(rs.getString("uploaded_at"));
                r.setPatientName(rs.getString("patient_name"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Report> getReportsByPatient(int patientId) {
        List<Report> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT r.*, u.full_name as doctor_name FROM reports r JOIN users u ON r.doctor_id=u.id WHERE r.patient_id=? ORDER BY r.uploaded_at DESC";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Report r = new Report();
                r.setId(rs.getInt("id"));
                r.setDoctorId(rs.getInt("doctor_id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setReportTitle(rs.getString("report_title"));
                r.setFileName(rs.getString("file_name"));
                r.setFilePath(rs.getString("file_path"));
                r.setUploadedAt(rs.getString("uploaded_at"));
                r.setDoctorName(rs.getString("doctor_name"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteReport(int id, int doctorId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM reports WHERE id=? AND doctor_id=?");
            ps.setInt(1, id);
            ps.setInt(2, doctorId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Report getReportById(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM reports WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Report r = new Report();
                r.setId(rs.getInt("id"));
                r.setDoctorId(rs.getInt("doctor_id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setFileName(rs.getString("file_name"));
                r.setFilePath(rs.getString("file_path"));
                r.setReportTitle(rs.getString("report_title"));
                return r;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
