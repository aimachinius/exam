package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Bean.Student;

public class StudentDao {
    UsersDao usersDao = new UsersDao();

    public Student getStudentByIdUser(int IdUser) {
        String sql = "SELECT id, class_name, user_id FROM student WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, IdUser);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setClassName(rs.getString("class_name"));
                student.setUserId(rs.getInt("user_id"));
                return student;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.util.List<Student> getAllStudents() {
        java.util.List<Student> list = new java.util.ArrayList<>();
        String sql = "SELECT id, user_id, class_name FROM student ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setUserId(rs.getInt("user_id"));
                s.setClassName(rs.getString("class_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<Student> getStudentsByClass(String className) {
        java.util.List<Student> list = new java.util.ArrayList<>();
        String sql = "SELECT id, user_id, class_name FROM student WHERE class_name = ? ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, className);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setUserId(rs.getInt("user_id"));
                s.setClassName(rs.getString("class_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
