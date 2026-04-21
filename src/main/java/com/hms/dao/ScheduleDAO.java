package com.hms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.hms.model.Schedule;
import com.hms.util.DBConnection;

public class ScheduleDAO {

    public List<Schedule> getScheduleByDoctor(int doctorUserId) {
        List<Schedule> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM schedules WHERE doctor_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, doctorUserId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setId(rs.getInt("id"));
                s.setDoctorId(rs.getInt("doctor_id"));
                s.setDayOfWeek(rs.getString("day_of_week"));
                s.setStartTime(rs.getString("start_time"));
                s.setEndTime(rs.getString("end_time"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addSchedule(Schedule s) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO schedules(doctor_id, day_of_week, start_time, end_time) VALUES(?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, s.getDoctorId());
            ps.setString(2, s.getDayOfWeek());
            ps.setString(3, s.getStartTime());
            ps.setString(4, s.getEndTime());

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public boolean deleteSchedule(int id, int doctorId) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            String query = "DELETE FROM schedules WHERE id=? AND doctor_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, id);
            ps.setInt(2, doctorId);

            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }
}
