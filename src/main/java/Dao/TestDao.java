package Dao;

import Bean.Test;
import Bean.TestTerm;
import Bean.StudentInfo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TestDao {

    public int createTest(Test test) {
        String sql = "INSERT INTO test (name, start_time, end_time, time, professor_id, numbers_question) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, test.getName());
            pstmt.setTimestamp(2, test.getStartTime());
            pstmt.setTimestamp(3, test.getEndTime());
            pstmt.setInt(4, test.getTime());
            pstmt.setInt(5, test.getProfessorId());
            pstmt.setInt(6, test.getNumbersQuestion());

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int createTestTerm(TestTerm testTerm) {
        String sql = "INSERT INTO test_term (test_id, term_id, number_questions) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, testTerm.getTestId());
            pstmt.setInt(2, testTerm.getTermId());
            pstmt.setInt(3, testTerm.getNumberQuestions());

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean createTestStudentIfNotExists(int testId, int studentId) {
        String checkSql = "SELECT COUNT(*) FROM test_student WHERE test_id = ? AND student_id = ?";
        String insertSql = "INSERT INTO test_student (test_id, student_id, point) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement check = conn.prepareStatement(checkSql);
                PreparedStatement insert = conn.prepareStatement(insertSql)) {

            check.setInt(1, testId);
            check.setInt(2, studentId);
            ResultSet rs = check.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // already exists
            }

            insert.setInt(1, testId);
            insert.setInt(2, studentId);
            insert.setNull(3, java.sql.Types.DOUBLE); // point = NULL by default
            return insert.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Test> getTestsByProfessor(int professorId) {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT id, name, start_time, end_time, time, professor_id, numbers_question FROM test WHERE professor_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, professorId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setStartTime(rs.getTimestamp("start_time"));
                test.setEndTime(rs.getTimestamp("end_time"));
                test.setTime(rs.getInt("time"));
                test.setProfessorId(rs.getInt("professor_id"));
                test.setNumbersQuestion(rs.getInt("numbers_question"));
                tests.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tests;
    }

    // Tests that a student can join: assigned to student and end_time > NOW() and
    // point IS NULL
    public java.util.List<Test> getAvailableTestsForStudent(int studentId) {
        java.util.List<Test> res = new java.util.ArrayList<>();
        String sql = "SELECT t.id, t.name, t.start_time, t.end_time, t.time, t.professor_id, t.numbers_question "
                + "FROM test t JOIN test_student ts ON t.id = ts.test_id "
                + "WHERE ts.student_id = ? AND t.end_time > NOW() AND ts.point IS NULL ORDER BY t.id DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setStartTime(rs.getTimestamp("start_time"));
                test.setEndTime(rs.getTimestamp("end_time"));
                test.setTime(rs.getInt("time"));
                test.setProfessorId(rs.getInt("professor_id"));
                test.setNumbersQuestion(rs.getInt("numbers_question"));
                res.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    public Test getTestById(int testId) {
        String sql = "SELECT id, name, start_time, end_time, time, professor_id, numbers_question FROM test WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setStartTime(rs.getTimestamp("start_time"));
                test.setEndTime(rs.getTimestamp("end_time"));
                test.setTime(rs.getInt("time"));
                test.setProfessorId(rs.getInt("professor_id"));
                test.setNumbersQuestion(rs.getInt("numbers_question"));
                return test;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TestTerm> getTestTermsByTest(int testId) {
        List<TestTerm> testTerms = new ArrayList<>();
        String sql = "SELECT id, test_id, term_id, number_questions FROM test_term WHERE test_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                TestTerm tt = new TestTerm();
                tt.setId(rs.getInt("id"));
                tt.setTestId(rs.getInt("test_id"));
                tt.setTermId(rs.getInt("term_id"));
                tt.setNumberQuestions(rs.getInt("number_questions"));
                testTerms.add(tt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return testTerms;
    }

    // New: return TestTerm info along with term name without changing TestTerm bean
    public List<Bean.TermInfo> getTestTermInfosByTest(int testId) {
        List<Bean.TermInfo> infos = new ArrayList<>();
        String sql = "SELECT tt.id, tt.test_id, tt.term_id, tt.number_questions, t.name AS term_name "
                + "FROM test_term tt LEFT JOIN term t ON tt.term_id = t.id WHERE tt.test_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Bean.TermInfo info = new Bean.TermInfo();
                info.setId(rs.getInt("id"));
                info.setTestId(rs.getInt("test_id"));
                info.setTermId(rs.getInt("term_id"));
                info.setNumberQuestions(rs.getInt("number_questions"));
                info.setTermName(rs.getString("term_name"));
                infos.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return infos;
    }

    public List<StudentInfo> getTestStudents(int testId) {
        List<StudentInfo> students = new ArrayList<>();
        String sql = "SELECT s.id, s.class_name, u.fullname FROM student s " +
                "INNER JOIN test_student ts ON s.id = ts.student_id " +
                "INNER JOIN users u ON s.user_id = u.id " +
                "WHERE ts.test_id = ? ORDER BY s.id";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                StudentInfo info = new StudentInfo();
                info.setId(rs.getInt("id"));
                info.setClassName(rs.getString("class_name"));
                info.setName(rs.getString("fullname"));
                students.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean updateTest(int testId, String name, java.sql.Timestamp startTime, java.sql.Timestamp endTime,
            int time, int professorId) {
        String sql = "UPDATE test SET name = ?, start_time = ?, end_time = ?, time = ? WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setTimestamp(2, startTime);
            pstmt.setTimestamp(3, endTime);
            pstmt.setInt(4, time);
            pstmt.setInt(5, testId);
            pstmt.setInt(6, professorId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTest(int testId, int professorId) {
        String sql = "DELETE FROM test WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            pstmt.setInt(2, professorId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeStudentFromTest(int testId, int studentId) {
        String sql = "DELETE FROM test_student WHERE test_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            pstmt.setInt(2, studentId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTestStudentPoint(int testId, int studentId, double point) {
        String sql = "UPDATE test_student SET point = ? WHERE test_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, point);
            pstmt.setInt(2, testId);
            pstmt.setInt(3, studentId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isTestBelongsToProfessor(int testId, int professorId) {
        String sql = "SELECT COUNT(*) FROM test WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            pstmt.setInt(2, professorId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addStudentToTest(int testId, int studentId) {
        String sql = "INSERT IGNORE INTO test_student (test_id, student_id, point) VALUES (?, ?, null)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, testId);
            pstmt.setInt(2, studentId);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTestTermNumberQuestions(int testTermId, int numberQuestions) {
        String sql = "UPDATE test_term SET number_questions = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, numberQuestions);
            pstmt.setInt(2, testTermId);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.Map<Test, Double> getTestResultsForStudent(int studentId) {
        java.util.Map<Test, Double> results = new java.util.LinkedHashMap<>();
        String sql = "SELECT ts.test_id, ts.point, t.id, t.name, t.start_time, t.end_time, t.time, t.professor_id, t.numbers_question "
                +
                "FROM test_student ts " +
                "JOIN test t ON ts.test_id = t.id " +
                "WHERE ts.student_id = ? AND ts.point IS NOT NULL " +
                "ORDER BY t.start_time DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setStartTime(rs.getTimestamp("start_time"));
                test.setEndTime(rs.getTimestamp("end_time"));
                test.setTime(rs.getInt("time"));
                test.setProfessorId(rs.getInt("professor_id"));
                test.setNumbersQuestion(rs.getInt("numbers_question"));

                Double point = rs.getDouble("point");
                results.put(test, point);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
}