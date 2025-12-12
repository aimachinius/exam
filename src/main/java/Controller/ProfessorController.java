package Controller;

import Bo.ProfessorBo;
import Bo.QuestionBo;
import Bo.TermBo;
import Bo.TestBo;
import Dao.StudentDao;
import Dao.QuestionDao;
import Dao.UsersDao;
import Bean.Student;
import Bean.StudentInfo;
import Bean.Term;
import Bean.Test;
import java.sql.Timestamp;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ProfessorController extends HttpServlet {
    private ProfessorBo professorBo = new ProfessorBo();
    private QuestionBo questionBo = new QuestionBo();
    private TermBo termBo = new TermBo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check session - chỉ professor mới được vào
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null
                || !session.getAttribute("role").equals("PROFESSOR")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("create-user".equals(action)) {
            request.getRequestDispatcher("professor/create-user.jsp").forward(request, response);
        } else if ("create-test".equals(action)) {
            handleCreateTestPage(request, response);
        } else if ("manage-test".equals(action)) {
            handleManageTestPage(request, response);
        } else if ("edit-test".equals(action)) {
            handleEditTestPage(request, response);
        } else if ("add-question".equals(action)) {
            handleAddQuestionPage(request, response);
        } else if ("manage-question".equals(action)) {
            handleManageQuestionPage(request, response);
        } else if ("edit-question".equals(action)) {
            handleEditQuestionPage(request, response);
        } else if ("manage-term".equals(action)) {
            handleManageTermPage(request, response);
        } else if ("add-term".equals(action)) {
            handleAddTermPage(request, response);
        } else if ("edit-term".equals(action)) {
            // System.out.println("HHHHHH");
            handleEditTermPage(request, response);
        } else {
            request.getRequestDispatcher("professor-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null
                || !session.getAttribute("role").equals("PROFESSOR")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("create-user".equals(action)) {
            handleCreateUser(request, response);
        } else if ("create-test".equals(action)) {
            handleCreateTest(request, response);
        } else if ("edit-test".equals(action)) {
            handleEditTest(request, response);
        } else if ("delete-test".equals(action)) {
            handleDeleteTest(request, response);
        } else if ("remove-student-from-test".equals(action)) {
            handleRemoveStudentFromTest(request, response);
        } else if ("add-student-to-test".equals(action)) {
            handleAddStudentToTest(request, response);
        } else if ("add-question".equals(action)) {
            handleAddQuestion(request, response);
        } else if ("edit-question".equals(action)) {
            handleEditQuestion(request, response);
        } else if ("delete-question".equals(action)) {
            handleDeleteQuestion(request, response);
        } else if ("add-term".equals(action)) {
            handleAddTerm(request, response);
        } else if ("edit-term".equals(action)) {
            // System.out.println("HEHE");
            handleEditTerm(request, response);
        } else if ("delete-term".equals(action)) {
            // System.out.println("HUHU");
            handleDeleteTerm(request, response);
        }
    }

    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String birthday = request.getParameter("birthday");
        String userType = request.getParameter("userType");
        String additionalInfo = request.getParameter("additionalInfo");

        // Validate input
        if (username == null || username.isEmpty() || password == null || password.isEmpty()
                || fullname == null || fullname.isEmpty() || userType == null || userType.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            request.getRequestDispatcher("professor/create-user.jsp").forward(request, response);
            return;
        }

        // Check if username exists
        if (professorBo.isUsernameExists(username)) {
            request.setAttribute("error", "Username đã tồn tại");
            request.getRequestDispatcher("professor/create-user.jsp").forward(request, response);
            return;
        }

        boolean success = false;

        if ("STUDENT".equals(userType)) {
            success = professorBo.createStudent(username, password, fullname, birthday, additionalInfo);
        } else if ("PROFESSOR".equals(userType)) {
            success = professorBo.createProfessor(username, password, fullname, birthday, additionalInfo);
        }

        if (success) {
            request.setAttribute("success", "Tạo tài khoản thành công!");
            request.getRequestDispatcher("professor/create-user.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
            request.getRequestDispatcher("professor/create-user.jsp").forward(request, response);
        }
    }

    private void handleAddQuestionPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
        request.getRequestDispatcher("professor/add-question.jsp").forward(request, response);
    }

    private void handleCreateTestPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        // terms and counts
        List<Term> terms = questionBo.getTermsByProfessor(professorId);
        Map<Integer, Integer> termCounts = new HashMap<>();
        QuestionDao qd = new QuestionDao();
        if (terms != null) {
            for (Term t : terms) {
                termCounts.put(t.getId(), qd.countQuestionsByTerm(t.getId()));
            }
        }

        // students
        StudentDao sd = new StudentDao();
        List<Student> students = sd.getAllStudents();

        request.setAttribute("terms", terms);
        request.setAttribute("termCounts", termCounts);
        request.setAttribute("students", students);
        request.getRequestDispatcher("professor/create-test.jsp").forward(request, response);
    }

    private void handleAddQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String content = request.getParameter("content");
        String termIdStr = request.getParameter("termId");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");

        // Validate
        if (content == null || content.isEmpty() || termIdStr == null || termIdStr.isEmpty() ||
                optionA == null || optionA.isEmpty() ||
                optionB == null || optionB.isEmpty() ||
                optionC == null || optionC.isEmpty() ||
                optionD == null || optionD.isEmpty() ||
                correctAnswer == null || correctAnswer.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            int termId = Integer.parseInt(termIdStr);
            request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
            request.setAttribute("selectedTermId", termId);
            request.getRequestDispatcher("professor/add-question.jsp").forward(request, response);
            return;
        }

        int termId = Integer.parseInt(termIdStr);

        boolean success = questionBo.createQuestion(content, termId, professorId,
                optionA, optionB, optionC, optionD, correctAnswer);

        if (success) {
            request.setAttribute("success", "Tạo câu hỏi thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
        }

        request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
        request.getRequestDispatcher("professor/add-question.jsp").forward(request, response);
    }

    private void handleCreateTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String name = request.getParameter("name");
        String startStr = request.getParameter("startTime");
        String endStr = request.getParameter("endTime");
        String timeStr = request.getParameter("time");

        if (name == null || name.isEmpty() || startStr == null || endStr == null || timeStr == null) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin cơ bản");
            handleCreateTestPage(request, response);
            return;
        }

        try {
            // convert datetime-local (YYYY-MM-DDTHH:MM) to Timestamp
            Timestamp start = Timestamp.valueOf(startStr.replace('T', ' ') + ":00");
            Timestamp end = Timestamp.valueOf(endStr.replace('T', ' ') + ":00");
            int timeMinutes = Integer.parseInt(timeStr);
            
            // Validate: start time must be after current time
            Timestamp now = new Timestamp(System.currentTimeMillis());
            if (start.before(now) || start.equals(now)) {
                request.setAttribute("error", "Thời gian bắt đầu phải sau thời điểm hiện tại");
                handleCreateTestPage(request, response);
                return;
            }
            
            // Validate: end time must be after start time
            if (end.before(start) || end.equals(start)) {
                request.setAttribute("error", "Thời gian kết thúc phải sau thời gian bắt đầu");
                handleCreateTestPage(request, response);
                return;
            }

            String[] termIds = request.getParameterValues("termIds");
            if (termIds == null || termIds.length == 0) {
                request.setAttribute("error", "Vui lòng chọn ít nhất một chuyên đề");
                handleCreateTestPage(request, response);
                return;
            }

            Map<Integer, Integer> termMap = new HashMap<>();
            for (String tid : termIds) {
                String numStr = request.getParameter("num_" + tid);
                int num = 0;
                try {
                    num = Integer.parseInt(numStr);
                } catch (Exception ex) {
                    num = 0;
                }
                termMap.put(Integer.parseInt(tid), num);
            }

            String[] studentIds = request.getParameterValues("studentIds");
            if (studentIds == null || studentIds.length == 0) {
                request.setAttribute("error", "Vui lòng chọn ít nhất một sinh viên tham gia");
                handleCreateTestPage(request, response);
                return;
            }
            List<Integer> students = new ArrayList<>();
            for (String s : studentIds)
                students.add(Integer.parseInt(s));

            TestBo tb = new TestBo();
            boolean ok = tb.createTests(name, start, end, timeMinutes, professorId, termMap, students);
            if (ok) {
                request.setAttribute("success", "Tạo cuộc thi thành công");
            } else {
                request.setAttribute("error", "Có lỗi: kiểm tra số câu mỗi chuyên đề hoặc dữ liệu");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Dữ liệu ngày giờ hoặc số không hợp lệ");
        }

        handleCreateTestPage(request, response);
    }

    private void handleManageTermPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        request.setAttribute("terms", termBo.getTermsByProfessor(professorId));
        request.getRequestDispatcher("professor/manage-term.jsp").forward(request, response);
    }

    private void handleAddTermPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
    }

    private void handleEditTermPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String termIdStr = request.getParameter("id");
        if (termIdStr != null && !termIdStr.isEmpty()) {
            int termId = Integer.parseInt(termIdStr);
            request.setAttribute("term", termBo.getTermById(termId));
        }
        request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
    }

    private void handleAddTerm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        System.out.println("PROF ID = " + professorId);
        String name = request.getParameter("name");

        // Validate
        if (name == null || name.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên chuyên đề");
            request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
            return;
        }

        boolean success = termBo.createTerm(name, professorId);

        if (success) {
            request.setAttribute("success", "Tạo chuyên đề thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
        }

        request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
    }

    private void handleEditTerm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("HOHO");
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String termIdStr = request.getParameter("id");
        String name = request.getParameter("name");

        // Validate
        if (termIdStr == null || termIdStr.isEmpty() || name == null || name.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
            return;
        }

        int termId = Integer.parseInt(termIdStr);
        boolean success = termBo.updateTerm(termId, name, professorId);

        if (success) {
            request.setAttribute("success", "Cập nhật chuyên đề thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
        }
        System.out.println("HAHA");
        request.setAttribute("term", termBo.getTermById(termId));
        request.getRequestDispatcher("professor/add-term.jsp").forward(request, response);
    }

    private void handleDeleteTerm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String termIdStr = request.getParameter("id");

        if (termIdStr != null && !termIdStr.isEmpty()) {
            int termId = Integer.parseInt(termIdStr);
            termBo.deleteTerm(termId, professorId);
        }

        response.sendRedirect(request.getContextPath() + "/professor?action=manage-term");
    }

    private void handleManageQuestionPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        request.setAttribute("questions", questionBo.getQuestionsByProfessor(professorId));
        request.getRequestDispatcher("professor/manage-question.jsp").forward(request, response);
    }

    private void handleEditQuestionPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionIdStr = request.getParameter("id");
        if (questionIdStr != null && !questionIdStr.isEmpty()) {
            int questionId = Integer.parseInt(questionIdStr);
            int professorId = (Integer) request.getSession().getAttribute("userId");
            request.setAttribute("question", questionBo.getQuestionById(questionId));
            request.setAttribute("answers", questionBo.getAnswersByQuestion(questionId));
            request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
        }
        request.getRequestDispatcher("professor/edit-question.jsp").forward(request, response);
    }

    private void handleEditQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String questionIdStr = request.getParameter("id");
        String content = request.getParameter("content");
        String termIdStr = request.getParameter("termId");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");

        // Validate
        if (questionIdStr == null || questionIdStr.isEmpty() || content == null || content.isEmpty() ||
                termIdStr == null || termIdStr.isEmpty() ||
                optionA == null || optionA.isEmpty() ||
                optionB == null || optionB.isEmpty() ||
                optionC == null || optionC.isEmpty() ||
                optionD == null || optionD.isEmpty() ||
                correctAnswer == null || correctAnswer.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            int questionId = Integer.parseInt(questionIdStr);
            request.setAttribute("question", questionBo.getQuestionById(questionId));
            request.setAttribute("answers", questionBo.getAnswersByQuestion(questionId));
            request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
            request.getRequestDispatcher("professor/edit-question.jsp").forward(request, response);
            return;
        }

        int questionId = Integer.parseInt(questionIdStr);
        int termId = Integer.parseInt(termIdStr);

        boolean success = questionBo.updateQuestion(questionId, content, termId, professorId,
                optionA, optionB, optionC, optionD, correctAnswer);

        if (success) {
            request.setAttribute("success", "Cập nhật câu hỏi thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại");
        }

        request.setAttribute("question", questionBo.getQuestionById(questionId));
        request.setAttribute("answers", questionBo.getAnswersByQuestion(questionId));
        request.setAttribute("terms", questionBo.getTermsByProfessor(professorId));
        request.getRequestDispatcher("professor/edit-question.jsp").forward(request, response);
    }

    private void handleDeleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String questionIdStr = request.getParameter("id");

        if (questionIdStr != null && !questionIdStr.isEmpty()) {
            int questionId = Integer.parseInt(questionIdStr);
            questionBo.deleteQuestion(questionId, professorId);
        }

        response.sendRedirect(request.getContextPath() + "/professor?action=manage-question");
    }

    private void handleManageTestPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        TestBo testBo = new TestBo();
        request.setAttribute("tests", testBo.getTestsByProfessor(professorId));
        request.getRequestDispatcher("professor/manage-test.jsp").forward(request, response);
    }

    private void handleEditTestPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("id");
        if (testIdStr != null && !testIdStr.isEmpty()) {
            int testId = Integer.parseInt(testIdStr);
            TestBo testBo = new TestBo();
            Test test = testBo.getTestById(testId);
            if (test != null) {
                request.setAttribute("test", test);
                request.setAttribute("testTerms", testBo.getTestTermsByTest(testId));
                request.setAttribute("testTermInfos", testBo.getTestTermInfosByTest(testId));
                request.setAttribute("students", testBo.getTestStudents(testId));
                // Load all students for the "add student" dropdown as StudentInfo (with
                // fullname)
                StudentDao sd = new StudentDao();
                UsersDao ud = new UsersDao();
                java.util.List<Student> raw = sd.getAllStudents();
                java.util.List<StudentInfo> allStudents = new java.util.ArrayList<>();
                if (raw != null) {
                    for (Student s : raw) {
                        Bean.Users u = ud.getUserById(s.getUserId());
                        String fullname = (u != null) ? u.getFullname() : "";
                        StudentInfo info = new StudentInfo();
                        info.setId(s.getId());
                        info.setClassName(s.getClassName());
                        info.setName(fullname);
                        allStudents.add(info);
                    }
                }
                request.setAttribute("allStudents", allStudents);
            }
        }
        request.getRequestDispatcher("professor/edit-test.jsp").forward(request, response);
    }

    private void handleEditTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String testIdStr = request.getParameter("id");
        String name = request.getParameter("name");
        String startStr = request.getParameter("startTime");
        String endStr = request.getParameter("endTime");
        String timeStr = request.getParameter("time");

        // Validate
        if (testIdStr == null || testIdStr.isEmpty() || name == null || name.isEmpty() ||
                startStr == null || endStr == null || timeStr == null) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            handleEditTestPage(request, response);
            return;
        }

        try {
            int testId = Integer.parseInt(testIdStr);
            Timestamp start = Timestamp.valueOf(startStr.replace('T', ' ') + ":00");
            Timestamp end = Timestamp.valueOf(endStr.replace('T', ' ') + ":00");
            int timeMinutes = Integer.parseInt(timeStr);
            
            // Validate: start time must be after current time
            Timestamp now = new Timestamp(System.currentTimeMillis());
            if (start.before(now) || start.equals(now)) {
                request.setAttribute("error", "Thời gian bắt đầu phải sau thời điểm hiện tại");
                handleEditTestPage(request, response);
                return;
            }
            
            // Validate: end time must be after start time
            if (end.before(start) || end.equals(start)) {
                request.setAttribute("error", "Thời gian kết thúc phải sau thời gian bắt đầu");
                handleEditTestPage(request, response);
                return;
            }

            TestBo testBo = new TestBo();
            boolean success = testBo.updateTest(testId, name, start, end, timeMinutes, professorId);

            if (success) {
                request.setAttribute("success", "Cập nhật cuộc thi thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra hoặc cuộc thi không tồn tại");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Dữ liệu ngày giờ hoặc số không hợp lệ");
        }

        handleEditTestPage(request, response);
    }

    private void handleDeleteTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String testIdStr = request.getParameter("id");

        if (testIdStr != null && !testIdStr.isEmpty()) {
            int testId = Integer.parseInt(testIdStr);
            TestBo testBo = new TestBo();
            testBo.deleteTest(testId, professorId);
        }

        response.sendRedirect(request.getContextPath() + "/professor?action=manage-test");
    }

    private void handleRemoveStudentFromTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String testIdStr = request.getParameter("testId");
        String studentIdStr = request.getParameter("studentId");

        if (testIdStr != null && !testIdStr.isEmpty() && studentIdStr != null && !studentIdStr.isEmpty()) {
            int testId = Integer.parseInt(testIdStr);
            int studentId = Integer.parseInt(studentIdStr);
            TestBo testBo = new TestBo();
            testBo.removeStudentFromTest(testId, studentId, professorId);
        }

        response.sendRedirect(request.getContextPath() + "/professor?action=edit-test&id=" + testIdStr);
    }

    private void handleAddStudentToTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int professorId = (Integer) request.getSession().getAttribute("userId");
        String testIdStr = request.getParameter("testId");
        String studentIdStr = request.getParameter("studentIdToAdd");

        if (testIdStr != null && !testIdStr.isEmpty() && studentIdStr != null && !studentIdStr.isEmpty()) {
            int testId = Integer.parseInt(testIdStr);
            int studentId = Integer.parseInt(studentIdStr);
            TestBo testBo = new TestBo();
            testBo.addStudentToTest(testId, studentId, professorId);
        }

        response.sendRedirect(request.getContextPath() + "/professor?action=edit-test&id=" + testIdStr);
    }
}