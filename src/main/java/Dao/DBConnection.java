package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String jdbcURL = "jdbc:mysql://localhost:3306/exam";
    private static final String jdbcUsername = "root";
    private static final String jdbcPassword = "inevergiveup@GRU";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
