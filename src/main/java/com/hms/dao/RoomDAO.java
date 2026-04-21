package com.hms.dao;

import java.sql.*;
import java.util.*;
import com.hms.model.Room;
import com.hms.util.DBConnection;

public class RoomDAO {

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT r.*, d.name as dept_name FROM rooms r LEFT JOIN departments d ON r.department_id=d.id ORDER BY r.room_number";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) { list.add(mapRow(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addRoom(Room r) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO rooms(room_number,room_type,department_id,capacity) VALUES(?,?,?,?)");
            ps.setString(1, r.getRoomNumber()); ps.setString(2, r.getRoomType());
            if (r.getDepartmentId() > 0) ps.setInt(3, r.getDepartmentId()); else ps.setNull(3, Types.INTEGER);
            ps.setInt(4, r.getCapacity());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteRoom(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM rooms WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateStatus(int id, String status) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE rooms SET status=? WHERE id=?");
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Map<String, Integer> getStats() {
        Map<String, Integer> m = new HashMap<>();
        try {
            Connection con = DBConnection.getConnection();
            ResultSet rs;
            rs = con.prepareStatement("SELECT COUNT(*) FROM rooms").executeQuery();
            if (rs.next()) m.put("total", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM rooms WHERE status='available'").executeQuery();
            if (rs.next()) m.put("available", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM rooms WHERE status='full'").executeQuery();
            if (rs.next()) m.put("full", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM rooms WHERE room_type='icu'").executeQuery();
            if (rs.next()) m.put("icu", rs.getInt(1));
        } catch (Exception e) { e.printStackTrace(); }
        return m;
    }

    private Room mapRow(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setId(rs.getInt("id")); r.setRoomNumber(rs.getString("room_number"));
        r.setRoomType(rs.getString("room_type")); r.setDepartmentId(rs.getInt("department_id"));
        r.setCapacity(rs.getInt("capacity")); r.setOccupied(rs.getInt("occupied")); r.setStatus(rs.getString("status"));
        try { r.setDepartmentName(rs.getString("dept_name")); } catch (Exception ignored) {}
        return r;
    }
}
