package Dao;

import Bean.TestSession;
import java.sql.*;

public class TestSessionDao {

    public boolean upsertSession(TestSession s) {
        String check = "SELECT COUNT(*) FROM test_student_session WHERE test_id = ? AND student_id = ?";
        String insert = "INSERT INTO test_student_session (test_id, student_id, started_at, question_order, answers_json, time_spent_seconds, submitted) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String update = "UPDATE test_student_session SET started_at = ?, question_order = ?, answers_json = ?, time_spent_seconds = ?, submitted = ? WHERE test_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pc = conn.prepareStatement(check);
                PreparedStatement pi = conn.prepareStatement(insert);
                PreparedStatement pu = conn.prepareStatement(update)) {

            pc.setInt(1, s.getTestId());
            pc.setInt(2, s.getStudentId());
            ResultSet rs = pc.executeQuery();
            boolean exists = false;
            if (rs.next())
                exists = rs.getInt(1) > 0;

            if (!exists) {
                pi.setInt(1, s.getTestId());
                pi.setInt(2, s.getStudentId());
                pi.setTimestamp(3, s.getStartedAt());
                pi.setString(4, s.getQuestionOrderJson());
                pi.setString(5, s.getAnswersJson());
                pi.setInt(6, s.getTimeSpentSeconds());
                pi.setBoolean(7, s.isSubmitted());
                return pi.executeUpdate() > 0;
            } else {
                pu.setTimestamp(1, s.getStartedAt());
                pu.setString(2, s.getQuestionOrderJson());
                pu.setString(3, s.getAnswersJson());
                pu.setInt(4, s.getTimeSpentSeconds());
                pu.setBoolean(5, s.isSubmitted());
                pu.setInt(6, s.getTestId());
                pu.setInt(7, s.getStudentId());
                return pu.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public TestSession getSession(int testId, int studentId) {
        String sql = "SELECT test_id, student_id, started_at, question_order, answers_json, time_spent_seconds, submitted FROM test_student_session WHERE test_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, testId);
            ps.setInt(2, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TestSession s = new TestSession();
                s.setTestId(rs.getInt("test_id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setStartedAt(rs.getTimestamp("started_at"));
                s.setQuestionOrderJson(rs.getString("question_order"));
                s.setAnswersJson(rs.getString("answers_json"));
                s.setTimeSpentSeconds(rs.getInt("time_spent_seconds"));
                s.setSubmitted(rs.getBoolean("submitted"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteSession(int testId, int studentId) {
        String sql = "DELETE FROM test_student_session WHERE test_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
