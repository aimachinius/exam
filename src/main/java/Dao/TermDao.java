package Dao;

import Bean.Term;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TermDao {

    public List<Term> getTermsByProfessor(int professorId) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT id, name, professor_id FROM term WHERE professor_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, professorId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Term term = new Term();
                term.setId(rs.getInt("id"));
                term.setName(rs.getString("name"));
                term.setProfessorId(rs.getInt("professor_id"));
                terms.add(term);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public Term getTermById(int termId) {
        String sql = "SELECT id, name, professor_id FROM term WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, termId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Term term = new Term();
                term.setId(rs.getInt("id"));
                term.setName(rs.getString("name"));
                term.setProfessorId(rs.getInt("professor_id"));
                return term;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createTerm(Term term) {
        String sql = "INSERT INTO term (name, professor_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, term.getName());
            pstmt.setInt(2, term.getProfessorId());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateTerm(Term term) {
        String sql = "UPDATE term SET name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, term.getName());
            pstmt.setInt(2, term.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTerm(int termId) {
        String sql = "DELETE FROM term WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, termId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isTermBelongsToProfessor(int termId, int professorId) {
        String sql = "SELECT id FROM term WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, termId);
            pstmt.setInt(2, professorId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
