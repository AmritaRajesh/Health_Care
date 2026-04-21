package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // ─── Change these to match your MySQL setup ───────────────────────────────
    private static final String HOST     = "localhost";
    private static final String PORT     = "3306";
    private static final String DATABASE = "hospital_db";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";   // XAMPP default = no password
    // ──────────────────────────────────────────────────────────────────────────

    private static final String URL =
        "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
        + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            System.err.println("[DBConnection] Failed to connect to MySQL: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}
