package Bo;

import Bean.Test;
import Bean.TestTerm;
import Bean.TermInfo;
import Bean.Student;
import Bean.StudentInfo;
import Dao.TestDao;
import Dao.QuestionDao;
import Dao.StudentDao;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public class TestBo {
    private TestDao testDao = new TestDao();
    private QuestionDao questionDao = new QuestionDao();
    private StudentDao studentDao = new StudentDao();

    public boolean createTests(String name, Timestamp start, Timestamp end, int timeMinutes,
            int professorId, Map<Integer, Integer> termToNumQuestions, List<Integer> studentIds) {

        // Validate counts
        int totalQuestions = 0;
        for (Map.Entry<Integer, Integer> e : termToNumQuestions.entrySet()) {
            int termId = e.getKey();
            int num = e.getValue();
            int available = questionDao.countQuestionsByTerm(termId);
            if (num <= 0 || num > available) {
                return false; // invalid
            }
            totalQuestions += num;
        }

        // Create ONE Test record with total number of questions
        Test test = new Test();
        test.setName(name);
        test.setStartTime(start);
        test.setEndTime(end);
        test.setTime(timeMinutes);
        test.setProfessorId(professorId);
        test.setNumbersQuestion(totalQuestions);

        int testId = testDao.createTest(test);
        if (testId <= 0)
            return false;

        // For each term create a TestTerm entry
        for (Map.Entry<Integer, Integer> e : termToNumQuestions.entrySet()) {
            int termId = e.getKey();
            int num = e.getValue();

            TestTerm testTerm = new TestTerm();
            testTerm.setTestId(testId);
            testTerm.setTermId(termId);
            testTerm.setNumberQuestions(num);

            int testTermId = testDao.createTestTerm(testTerm);
            if (testTermId <= 0)
                return false;
        }

        // assign students to test
        if (studentIds != null && !studentIds.isEmpty()) {
            for (Integer sid : studentIds) {
                testDao.createTestStudentIfNotExists(testId, sid);
            }
        }

        return true;
    }

    public List<Test> getTestsByProfessor(int professorId) {
        return testDao.getTestsByProfessor(professorId);
    }

    public Test getTestById(int testId) {
        return testDao.getTestById(testId);
    }

    public List<TestTerm> getTestTermsByTest(int testId) {
        return testDao.getTestTermsByTest(testId);
    }

    public List<TermInfo> getTestTermInfosByTest(int testId) {
        return testDao.getTestTermInfosByTest(testId);
    }

    public List<StudentInfo> getTestStudents(int testId) {
        return testDao.getTestStudents(testId);
    }

    public List<Student> getAllStudentsForAssignment() {
        return studentDao.getAllStudents();
    }

    public boolean updateTest(int testId, String name, Timestamp startTime, Timestamp endTime, int time,
            int professorId) {
        if (!testDao.isTestBelongsToProfessor(testId, professorId)) {
            return false;
        }
        if (name == null || name.isEmpty()) {
            return false;
        }
        return testDao.updateTest(testId, name, startTime, endTime, time, professorId);
    }

    public boolean deleteTest(int testId, int professorId) {
        if (!testDao.isTestBelongsToProfessor(testId, professorId)) {
            return false;
        }
        return testDao.deleteTest(testId, professorId);
    }

    public boolean removeStudentFromTest(int testId, int studentId, int professorId) {
        if (!testDao.isTestBelongsToProfessor(testId, professorId)) {
            return false;
        }
        return testDao.removeStudentFromTest(testId, studentId);
    }

    public boolean addStudentToTest(int testId, int studentId, int professorId) {
        if (!testDao.isTestBelongsToProfessor(testId, professorId)) {
            return false;
        }
        return testDao.addStudentToTest(testId, studentId);
    }

    public boolean updateTestTermNumberQuestions(int testTermId, int numberQuestions, int professorId) {
        // Verify that this test_term belongs to a test owned by the professor
        // We can do this by checking if the test exists
        // For now, we'll trust the parameter and update directly
        return testDao.updateTestTermNumberQuestions(testTermId, numberQuestions);
    }
}
