package Dao;

import Bean.Question;
import Bean.Answer;
import Bean.Term;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao {

    public List<Term> getTermsByProfessor(int professorId) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT id, name, professor_id FROM term WHERE professor_id = ?";
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

    public int createQuestion(Question question) {
        String sql = "INSERT INTO question (content, term_id, professor_id) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, question.getContent());
            pstmt.setInt(2, question.getTermId());
            pstmt.setInt(3, question.getProfessorId());

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

    public boolean createAnswers(int questionId, List<Answer> answers) {
        String sql = "INSERT INTO answer (question_id, option_key, content, is_correct) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (Answer answer : answers) {
                pstmt.setInt(1, questionId);
                pstmt.setString(2, answer.getOptionKey());
                pstmt.setString(3, answer.getContent());
                pstmt.setBoolean(4, answer.isCorrect());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            return results.length == answers.size();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Question getQuestionById(int questionId) {
        String sql = "SELECT id, content, term_id, professor_id FROM question WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setContent(rs.getString("content"));
                question.setTermId(rs.getInt("term_id"));
                question.setProfessorId(rs.getInt("professor_id"));
                return question;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Answer> getAnswersByQuestion(int questionId) {
        List<Answer> answers = new ArrayList<>();
        String sql = "SELECT id, question_id, option_key, content, is_correct FROM answer WHERE question_id = ? ORDER BY option_key";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Answer answer = new Answer();
                answer.setId(rs.getInt("id"));
                answer.setQuestionId(rs.getInt("question_id"));
                answer.setOptionKey(rs.getString("option_key"));
                answer.setContent(rs.getString("content"));
                answer.setCorrect(rs.getBoolean("is_correct"));
                answers.add(answer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answers;
    }

    public List<Question> getQuestionsByProfessor(int professorId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.id, q.content, q.term_id, q.professor_id, t.name AS term_name FROM question q " +
                "JOIN term t ON q.term_id = t.id WHERE q.professor_id = ? ORDER BY q.id DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, professorId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setContent(rs.getString("content"));
                question.setTermId(rs.getInt("term_id"));
                question.setProfessorId(rs.getInt("professor_id"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    public List<Question> getQuestionsByTerm(int termId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT id, content, term_id, professor_id FROM question WHERE term_id = ? ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, termId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setContent(rs.getString("content"));
                question.setTermId(rs.getInt("term_id"));
                question.setProfessorId(rs.getInt("professor_id"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    public boolean updateQuestion(int questionId, String content, int termId, int professorId) {
        String sql = "UPDATE question SET content = ?, term_id = ? WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, content);
            pstmt.setInt(2, termId);
            pstmt.setInt(3, questionId);
            pstmt.setInt(4, professorId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAnswers(int questionId, List<Answer> answers) {
        String sql = "UPDATE answer SET content = ?, is_correct = ? WHERE question_id = ? AND option_key = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (Answer answer : answers) {
                pstmt.setString(1, answer.getContent());
                pstmt.setBoolean(2, answer.isCorrect());
                pstmt.setInt(3, questionId);
                pstmt.setString(4, answer.getOptionKey());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            return results.length == answers.size();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteQuestion(int questionId, int professorId) {
        // Delete answers first
        String deleteAnswersSql = "DELETE FROM answer WHERE question_id IN " +
                "(SELECT id FROM question WHERE id = ? AND professor_id = ?)";
        String deleteQuestionSql = "DELETE FROM question WHERE id = ? AND professor_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt1 = conn.prepareStatement(deleteAnswersSql);
                PreparedStatement pstmt2 = conn.prepareStatement(deleteQuestionSql)) {

            // Delete answers
            pstmt1.setInt(1, questionId);
            pstmt1.setInt(2, professorId);
            pstmt1.executeUpdate();

            // Delete question
            pstmt2.setInt(1, questionId);
            pstmt2.setInt(2, professorId);
            return pstmt2.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isQuestionBelongsToProfessor(int questionId, int professorId) {
        String sql = "SELECT COUNT(*) FROM question WHERE id = ? AND professor_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, questionId);
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

    public int countQuestionsByTerm(int termId) {
        String sql = "SELECT COUNT(*) FROM question WHERE term_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, termId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
