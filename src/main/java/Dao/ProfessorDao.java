package Dao;

import Bean.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import Bean.Professor;

public class ProfessorDao {
    private UsersDao usersDao = new UsersDao();

    public boolean createStudent(String username, String password, String fullname, String birthday, String className) {
        // Check if username exists
        if (usersDao.isUsernameExists(username)) {
            return false;
        }

        // Create user
        Users user = new Users();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("STUDENT");
        user.setFullname(fullname);
        if (birthday != null && !birthday.isEmpty()) {
            user.setBirthday(java.sql.Date.valueOf(birthday));
        }

        return usersDao.createUser(user);
    }

    public Professor getProfessorByIdUser(int IdUser) {
        String sql = "SELECT id, department, user_id FROM professor WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, IdUser);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Professor professor = new Professor();
                professor.setId(rs.getInt("id"));
                professor.setDepartment(rs.getString("department"));
                professor.setUserId(rs.getInt("user_id"));
                return professor;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createProfessor(String username, String password, String fullname, String birthday,
            String department) {
        // Check if username exists
        if (usersDao.isUsernameExists(username)) {
            return false;
        }

        // Create user
        Users user = new Users();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("PROFESSOR");
        user.setFullname(fullname);
        if (birthday != null && !birthday.isEmpty()) {
            user.setBirthday(java.sql.Date.valueOf(birthday));
        }

        return usersDao.createUser(user);
    }

    public boolean isUsernameExists(String username) {
        return usersDao.isUsernameExists(username);
    }
}
