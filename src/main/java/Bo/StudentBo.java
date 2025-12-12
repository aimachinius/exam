package Bo;

import Dao.StudentDao;
import Bean.Student;

public class StudentBo {
    private StudentDao studentDao = new StudentDao();

    public Student getStudentByIdUser(int IdUser) {
        return studentDao.getStudentByIdUser(IdUser);
    }
}
