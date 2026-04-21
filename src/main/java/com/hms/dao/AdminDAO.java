package com.hms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hms.model.Appointment;
import com.hms.model.Bill;
import com.hms.model.Department;
import com.hms.model.Staff;
import com.hms.model.User;
import com.hms.util.DBConnection;

public class AdminDAO {

    public Map<String, Integer> getSystemStats() {
        Map<String, Integer> stats = new HashMap<>();
        try {
            Connection con = DBConnection.getConnection();
            ResultSet rs;
            rs = con.prepareStatement("SELECT COUNT(*) FROM doctors").executeQuery();
            if(rs.next()) stats.put("doctors", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM users WHERE role='patient'").executeQuery();
            if(rs.next()) stats.put("patients", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM appointments").executeQuery();
            if(rs.next()) stats.put("appointments", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM appointments WHERE status='pending'").executeQuery();
            if(rs.next()) stats.put("pending", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM departments").executeQuery();
            if(rs.next()) stats.put("departments", rs.getInt(1));
            rs = con.prepareStatement("SELECT COUNT(*) FROM staff WHERE status='active'").executeQuery();
            if(rs.next()) stats.put("staff", rs.getInt(1));
            rs = con.prepareStatement("SELECT COALESCE(SUM(amount),0) FROM bills WHERE status='paid'").executeQuery();
            if(rs.next()) stats.put("revenue", rs.getInt(1));
            rs = con.prepareStatement("SELECT COALESCE(SUM(amount),0) FROM bills WHERE status='unpaid'").executeQuery();
            if(rs.next()) stats.put("unpaid", rs.getInt(1));
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public List<User> getAllPatients() {
        List<User> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM users WHERE role='patient' ORDER BY id DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Fetches all appointments globally
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT a.*, d.specialization, u1.full_name as doctor_name, u2.full_name as patient_name " +
                           "FROM appointments a " +
                           "INNER JOIN doctors d ON a.doctor_id = d.user_id " +
                           "INNER JOIN users u1 ON d.user_id = u1.id " +
                           "INNER JOIN users u2 ON a.patient_id = u2.id " +
                           "ORDER BY a.appointment_date DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setId(rs.getInt("id"));
                ap.setPatientId(rs.getInt("patient_id"));
                ap.setDoctorId(rs.getInt("doctor_id"));
                ap.setPatientName(rs.getString("patient_name"));
                ap.setDoctorName(rs.getString("doctor_name") + " (" + rs.getString("specialization") + ")");
                ap.setAppointmentDate(rs.getString("appointment_date"));
                ap.setTimeSlot(rs.getString("time_slot"));
                ap.setReason(rs.getString("reason"));
                ap.setStatus(rs.getString("status"));
                list.add(ap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addDoctor(User u, String specialization) {
        boolean f = false;
        try {
            Connection con = DBConnection.getConnection();
            con.setAutoCommit(false);
            String q1 = "INSERT INTO users(full_name, email, password, phone, role) VALUES(?, ?, ?, ?, 'doctor')";
            PreparedStatement ps1 = con.prepareStatement(q1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, u.getFullName());
            ps1.setString(2, u.getEmail());
            ps1.setString(3, u.getPassword());
            ps1.setString(4, u.getPhone());
            int i1 = ps1.executeUpdate();
            if (i1 == 1) {
                ResultSet rs = ps1.getGeneratedKeys();
                if (rs.next()) {
                    int newUserId = rs.getInt(1);
                    String q2 = "INSERT INTO doctors(user_id, specialization) VALUES(?, ?)";
                    PreparedStatement ps2 = con.prepareStatement(q2);
                    ps2.setInt(1, newUserId);
                    ps2.setString(2, specialization);
                    int i2 = ps2.executeUpdate();
                    if (i2 == 1) { con.commit(); f = true; } else { con.rollback(); }
                }
            } else { con.rollback(); }
        } catch (Exception e) { e.printStackTrace(); }
        return f;
    }

    public boolean deleteDoctor(int userId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=? AND role='doctor'");
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deletePatient(int userId) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=? AND role='patient'");
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateAppointmentStatus(int id, String status) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE appointments SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- Billing ----
    public List<Bill> getAllBills() {
        List<Bill> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT b.*, u1.full_name as patient_name, u2.full_name as doctor_name FROM bills b JOIN users u1 ON b.patient_id=u1.id JOIN users u2 ON b.doctor_id=u2.id ORDER BY b.created_at DESC";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) {
                Bill b = new Bill();
                b.setId(rs.getInt("id")); b.setPatientId(rs.getInt("patient_id")); b.setDoctorId(rs.getInt("doctor_id"));
                b.setDescription(rs.getString("description")); b.setAmount(rs.getDouble("amount"));
                b.setStatus(rs.getString("status")); b.setCreatedAt(rs.getString("created_at")); b.setPaidAt(rs.getString("paid_at"));
                b.setPatientName(rs.getString("patient_name")); b.setDoctorName(rs.getString("doctor_name"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addBill(Bill b) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO bills(patient_id,doctor_id,appointment_id,description,amount) VALUES(?,?,?,?,?)");
            ps.setInt(1, b.getPatientId()); ps.setInt(2, b.getDoctorId()); ps.setInt(3, b.getAppointmentId());
            ps.setString(4, b.getDescription()); ps.setDouble(5, b.getAmount());
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteBill(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM bills WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- Departments ----
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT d.*, u.full_name as head_name FROM departments d LEFT JOIN users u ON d.head_doctor_id=u.id ORDER BY d.name";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id")); d.setName(rs.getString("name")); d.setDescription(rs.getString("description"));
                d.setHeadDoctorId(rs.getInt("head_doctor_id")); d.setHeadDoctorName(rs.getString("head_name")); d.setCreatedAt(rs.getString("created_at"));
                list.add(d);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addDepartment(Department d) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO departments(name,description,head_doctor_id) VALUES(?,?,?)");
            ps.setString(1, d.getName()); ps.setString(2, d.getDescription());
            if (d.getHeadDoctorId() > 0) ps.setInt(3, d.getHeadDoctorId()); else ps.setNull(3, java.sql.Types.INTEGER);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteDepartment(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM departments WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- Staff ----
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT s.*, d.name as dept_name FROM staff s LEFT JOIN departments d ON s.department_id=d.id ORDER BY s.full_name";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) {
                Staff s = new Staff();
                s.setId(rs.getInt("id")); s.setFullName(rs.getString("full_name")); s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone")); s.setRole(rs.getString("role")); s.setDepartmentId(rs.getInt("department_id"));
                s.setDepartmentName(rs.getString("dept_name")); s.setStatus(rs.getString("status")); s.setJoinedAt(rs.getString("joined_at"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addStaff(Staff s) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO staff(full_name,email,phone,role,department_id) VALUES(?,?,?,?,?)");
            ps.setString(1, s.getFullName()); ps.setString(2, s.getEmail()); ps.setString(3, s.getPhone()); ps.setString(4, s.getRole());
            if (s.getDepartmentId() > 0) ps.setInt(5, s.getDepartmentId()); else ps.setNull(5, java.sql.Types.INTEGER);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteStaff(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM staff WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean toggleStaffStatus(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("UPDATE staff SET status = IF(status='active','inactive','active') WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- User Management ----
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            ResultSet rs = con.prepareStatement("SELECT * FROM users ORDER BY role, full_name").executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("id"), rs.getString("full_name"), rs.getString("email"), "", rs.getString("phone"), rs.getString("role"));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteUser(int id) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=? AND role != 'admin'");
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ---- Analytics ----
    public List<Map<String, Object>> getMonthlyAppointments() {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT DATE_FORMAT(appointment_date,'%b %Y') as month, COUNT(*) as total, SUM(status='completed') as completed, SUM(status='pending') as pending FROM appointments GROUP BY DATE_FORMAT(appointment_date,'%Y-%m') ORDER BY MIN(appointment_date) DESC LIMIT 6";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("month", rs.getString("month")); row.put("total", rs.getInt("total"));
                row.put("completed", rs.getInt("completed")); row.put("pending", rs.getInt("pending"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getDoctorPerformance() {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String q = "SELECT u.full_name, d.specialization, COUNT(a.id) as total, SUM(a.status='completed') as completed FROM doctors d JOIN users u ON d.user_id=u.id LEFT JOIN appointments a ON a.doctor_id=d.user_id GROUP BY d.user_id ORDER BY total DESC LIMIT 10";
            ResultSet rs = con.prepareStatement(q).executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("full_name")); row.put("spec", rs.getString("specialization"));
                row.put("total", rs.getInt("total")); row.put("completed", rs.getInt("completed"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
