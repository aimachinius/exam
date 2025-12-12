package Bo;

import Bean.Professor;
import Dao.ProfessorDao;

public class ProfessorBo {
    private ProfessorDao professorDao = new ProfessorDao();

    public boolean createStudent(String username, String password, String fullname, String birthday, String className) {
        // Validate
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            return false;
        }

        return professorDao.createStudent(username, password, fullname, birthday, className);
    }

    public boolean createProfessor(String username, String password, String fullname, String birthday,
            String department) {
        // Validate
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            return false;
        }

        return professorDao.createProfessor(username, password, fullname, birthday, department);
    }

    public boolean isUsernameExists(String username) {
        return professorDao.isUsernameExists(username);
    }

    public Professor getProfessorByIdUser(int IdUser) {
        return professorDao.getProfessorByIdUser(IdUser);
    }
}
