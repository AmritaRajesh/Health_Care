package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.MedicineReminder;
import com.hms.util.DBConnection;

public class MedicineReminderDAO {

    public boolean addReminder(MedicineReminder r) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO medicine_reminders(patient_id,prescription_id,medicine_name,dosage,reminder_time,days_of_week) VALUES(?,?,?,?,?,?)");
            ps.setInt(1, r.getPatientId());
            if (r.getPrescriptionId() > 0) ps.setInt(2, r.getPrescriptionId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, r.getMedicineName()); ps.setString(4, r.getDosage());
            ps.setString(5, r.getReminderTime()); ps.setString(6, r.getDaysOfWeek());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<MedicineReminder> getRemindersByPatient(int patientId) {
        List<MedicineReminder> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM medicine_reminders WHERE patient_id=? ORDER BY reminder_time");
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean toggleActive(int id, int patientId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE medicine_reminders SET is_active = NOT is_active WHERE id=? AND patient_id=?");
            ps.setInt(1, id); ps.setInt(2, patientId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteReminder(int id, int patientId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM medicine_reminders WHERE id=? AND patient_id=?");
            ps.setInt(1, id); ps.setInt(2, patientId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private MedicineReminder mapRow(ResultSet rs) throws SQLException {
        MedicineReminder r = new MedicineReminder();
        r.setId(rs.getInt("id")); r.setPatientId(rs.getInt("patient_id")); r.setPrescriptionId(rs.getInt("prescription_id"));
        r.setMedicineName(rs.getString("medicine_name")); r.setDosage(rs.getString("dosage"));
        r.setReminderTime(rs.getString("reminder_time")); r.setDaysOfWeek(rs.getString("days_of_week"));
        r.setActive(rs.getInt("is_active") == 1); r.setCreatedAt(rs.getString("created_at"));
        return r;
    }
}
