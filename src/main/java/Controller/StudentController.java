package Controller;

import Bean.*;
import Dao.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class StudentController extends HttpServlet {
    private TestDao testDao = new TestDao();
    private TestSessionDao sessionDao = new TestSessionDao();
    private QuestionDao questionDao = new QuestionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null
                || !session.getAttribute("role").equals("STUDENT")) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty())
            action = "list";

        if ("list".equals(action)) {
            handleListTests(request, response);
        } else if ("take".equals(action)) {
            handleTakeTestPage(request, response);
        } else if ("results".equals(action)) {
            handleResultsPage(request, response);
        } else if ("guide".equals(action)) {
            handleGuidePage(request, response);
        } else {
            handleListTests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null
                || !session.getAttribute("role").equals("STUDENT")) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("start-test".equals(action)) {
            handleStartTest(request, response);
        } else if ("autosave".equals(action)) {
            handleAutosave(request, response);
        } else if ("submit-test".equals(action)) {
            handleSubmitTest(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/student?action=list");
        }
    }

    private void handleListTests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studentId = (Integer) request.getSession().getAttribute("studentId");
        List<Test> tests = testDao.getAvailableTestsForStudent(studentId);
        request.setAttribute("tests", tests);
        request.getRequestDispatcher("student/tests.jsp").forward(request, response);
    }

    private void handleTakeTestPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("id");
        if (testIdStr == null || testIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student?action=list");
            return;
        }
        int testId = Integer.parseInt(testIdStr);
        int studentId = (Integer) request.getSession().getAttribute("studentId");

        // Verify assigned and not already graded
        Test test = testDao.getTestById(testId);
        if (test == null) {
            response.sendRedirect(request.getContextPath() + "/student?action=list");
            return;
        }

        TestSession ts = sessionDao.getSession(testId, studentId);
        if (ts == null) {
            // no session -> redirect to start endpoint to create session
            request.setAttribute("testId", testId);
            request.getRequestDispatcher("student/start-confirm.jsp").forward(request, response);
            return;
        }

        if (ts.isSubmitted()) {
            request.setAttribute("error", "Bạn đã nộp bài. Không thể thi lại.");
            request.getRequestDispatcher("student/tests.jsp").forward(request, response);
            return;
        }

        // compute remaining time
        long now = System.currentTimeMillis();
        long endMillis = test.getEndTime().getTime();
        int remainingByEnd = (int) Math.max(0, (endMillis - now) / 1000);
        int remainingByTime = test.getTime() * 60 - ts.getTimeSpentSeconds();
        int remaining = (int) Math.min(remainingByEnd, remainingByTime);

        // build question list and answers based on session
        List<Integer> qOrder = new ArrayList<>();
        if (ts.getQuestionOrderJson() != null && !ts.getQuestionOrderJson().isEmpty()) {
            // parse simple comma-separated or JSON array; we used JSON array
            try {
                com.google.gson.Gson g = new com.google.gson.Gson();
                Integer[] arr = g.fromJson(ts.getQuestionOrderJson(), Integer[].class);
                qOrder = Arrays.asList(arr);
            } catch (Exception ex) {
                // fallback empty
            }
        }

        List<Question> questions = new ArrayList<>();
        Map<Integer, List<Bean.Answer>> answersMap = new HashMap<>();
        // parse answers_json to get order and selected if present
        Map<Integer, List<String>> orderMap = new HashMap<>();
        Map<Integer, String> selectedMap = new HashMap<>();
        if (ts.getAnswersJson() != null && !ts.getAnswersJson().isEmpty()) {
            try {
                com.google.gson.Gson gg = new com.google.gson.Gson();
                Map parsed = gg.fromJson(ts.getAnswersJson(), Map.class);
                Object ord = parsed.get("order");
                if (ord instanceof Map) {
                    Map om = (Map) ord;
                    for (Object k : om.keySet()) {
                        try {
                            Integer qk = Integer.parseInt(k.toString());
                            List list = (List) om.get(k);
                            List<String> arr = new ArrayList<>();
                            if (list != null)
                                for (Object v : list)
                                    arr.add(v.toString());
                            orderMap.put(qk, arr);
                        } catch (Exception ex) {
                        }
                    }
                }
                Object sel = parsed.get("selected");
                if (sel instanceof Map) {
                    Map sm = (Map) sel;
                    for (Object k : sm.keySet()) {
                        try {
                            Integer qk = Integer.parseInt(k.toString());
                            Object v = sm.get(k);
                            if (v != null)
                                selectedMap.put(qk, v.toString());
                        } catch (Exception ex) {
                        }
                    }
                }
            } catch (Exception ex) {
            }
        }

        for (Integer qid : qOrder) {
            Question q = questionDao.getQuestionById(qid);
            if (q != null) {
                questions.add(q);
                List<Bean.Answer> answers = questionDao.getAnswersByQuestion(qid);
                // reorder answers according to orderMap if present
                List<Bean.Answer> ordered = new ArrayList<>();
                if (orderMap.containsKey(qid)) {
                    List<String> keys = orderMap.get(qid);
                    for (String k : keys) {
                        for (Bean.Answer a : answers) {
                            if (a.getOptionKey().equals(k)) {
                                ordered.add(a);
                                break;
                            }
                        }
                    }
                    // any missing append
                    for (Bean.Answer a : answers)
                        if (!ordered.contains(a))
                            ordered.add(a);
                } else
                    ordered = answers;
                answersMap.put(qid, ordered);
            }
        }

        request.setAttribute("test", test);
        request.setAttribute("questions", questions);
        request.setAttribute("answersMap", answersMap);
        request.setAttribute("remainingSeconds", remaining);
        request.setAttribute("testSession", ts);
        request.getRequestDispatcher("student/take-test.jsp").forward(request, response);
    }

    private void handleStartTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studentId = (Integer) request.getSession().getAttribute("studentId");
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null || testIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student?action=list");
            return;
        }
        int testId = Integer.parseInt(testIdStr);
        TestDao td = new TestDao();
        Test test = td.getTestById(testId);
        if (test == null) {
            response.sendRedirect(request.getContextPath() + "/student?action=list");
            return;
        }

        // build questions: for each test_term pick random questions
        List<TestTerm> tterms = td.getTestTermsByTest(testId);
        List<Integer> chosen = new ArrayList<>();
        for (TestTerm tt : tterms) {
            List<Question> pool = questionDao.getQuestionsByTerm(tt.getTermId());
            Collections.shuffle(pool);
            int take = Math.min(tt.getNumberQuestions(), pool.size());
            for (int i = 0; i < take; i++)
                chosen.add(pool.get(i).getId());
        }
        Collections.shuffle(chosen);

        // build answer order mapping for each question (keep natural A, B, C, D order)
        Map<Integer, List<String>> orderMap = new HashMap<>();
        for (Integer qid : chosen) {
            List<Bean.Answer> answers = questionDao.getAnswersByQuestion(qid);
            List<String> keys = new ArrayList<>();
            for (Bean.Answer a : answers)
                keys.add(a.getOptionKey());
            // Sort to maintain A, B, C, D order
            Collections.sort(keys);
            orderMap.put(qid, keys);
        }

        // build JSON
        com.google.gson.Gson g = new com.google.gson.Gson();
        String questionOrderJson = g.toJson(chosen);
        Map<String, Object> sessionJson = new HashMap<>();
        sessionJson.put("order", orderMap);
        sessionJson.put("selected", new HashMap<Integer, String>());
        String answersJson = g.toJson(sessionJson);

        TestSession ts = new TestSession();
        ts.setTestId(testId);
        ts.setStudentId(studentId);
        ts.setStartedAt(new Timestamp(System.currentTimeMillis()));
        ts.setQuestionOrderJson(questionOrderJson);
        ts.setAnswersJson(answersJson);
        ts.setTimeSpentSeconds(0);
        ts.setSubmitted(false);

        sessionDao.upsertSession(ts);

        response.sendRedirect(request.getContextPath() + "/student?action=take&id=" + testId);
    }

    private void handleAutosave(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int studentId = (Integer) request.getSession().getAttribute("studentId");
        int testId = Integer.parseInt(request.getParameter("testId"));
        String answersJson = request.getParameter("answersJson");
        String timeSpentStr = request.getParameter("timeSpentSeconds");
        int timeSpent = 0;
        try {
            timeSpent = Integer.parseInt(timeSpentStr);
        } catch (Exception ex) {
        }

        TestSession ts = sessionDao.getSession(testId, studentId);
        if (ts == null) {
            response.setStatus(400);
            response.getWriter().write("No session");
            return;
        }
        // Merge incoming selected with existing order to avoid overwriting order
        // mapping
        try {
            com.google.gson.Gson g = new com.google.gson.Gson();
            Map incoming = g.fromJson(answersJson, Map.class);
            Map existingAll = null;
            if (ts.getAnswersJson() != null && !ts.getAnswersJson().isEmpty()) {
                existingAll = g.fromJson(ts.getAnswersJson(), Map.class);
            }
            Map merged = new HashMap();
            if (existingAll != null && existingAll.get("order") != null)
                merged.put("order", existingAll.get("order"));
            if (incoming != null && incoming.get("selected") != null)
                merged.put("selected", incoming.get("selected"));
            String mergedJson = g.toJson(merged);
            ts.setAnswersJson(mergedJson);
            ts.setTimeSpentSeconds(timeSpent);
            sessionDao.upsertSession(ts);
        } catch (Exception ex) {
            ts.setAnswersJson(answersJson);
            ts.setTimeSpentSeconds(timeSpent);
            sessionDao.upsertSession(ts);
        }
        response.getWriter().write("OK");
    }

    private void handleSubmitTest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int studentId = (Integer) request.getSession().getAttribute("studentId");
        int testId = Integer.parseInt(request.getParameter("testId"));
        String answersJson = request.getParameter("answersJson");
        String timeSpentStr = request.getParameter("timeSpentSeconds");
        int timeSpent = 0;
        try {
            timeSpent = Integer.parseInt(timeSpentStr);
        } catch (Exception ex) {
        }

        TestSession ts = sessionDao.getSession(testId, studentId);
        if (ts == null) {
            response.setStatus(400);
            response.getWriter().write("No session");
            return;
        }

        // parse answersJson to obtain selected mapping
        com.google.gson.Gson g = new com.google.gson.Gson();
        try {
            Map parsed = g.fromJson(answersJson, Map.class);
            Map selected = (Map) parsed.get("selected");
            // compute score
            int total = 0;
            int correct = 0;
            // get question order
            Integer[] qarr = g.fromJson(ts.getQuestionOrderJson(), Integer[].class);
            for (Integer qid : qarr) {
                total++;
                List<Bean.Answer> answers = questionDao.getAnswersByQuestion(qid);
                String chosen = null;
                if (selected != null) {
                    Object o = selected.get(String.valueOf(qid));
                    if (o == null)
                        o = selected.get(qid);
                    if (o != null)
                        chosen = o.toString();
                }
                boolean isCorrect = false;
                if (chosen != null) {
                    for (Bean.Answer a : answers) {
                        if (a.getOptionKey().equals(chosen) && a.isCorrect()) {
                            isCorrect = true;
                            break;
                        }
                    }
                }
                if (isCorrect)
                    correct++;
            }

            double score = 0.0;
            if (total > 0)
                score = ((double) correct / (double) total) * 100.0;
            score = Math.round(score * 100.0) / 100.0; // 2 decimals

            // mark session submitted and save answers/time
            ts.setAnswersJson(answersJson);
            ts.setTimeSpentSeconds(timeSpent);
            ts.setSubmitted(true);
            sessionDao.upsertSession(ts);

            // save score to test_student
            TestDao td = new TestDao();
            td.updateTestStudentPoint(testId, studentId, score);

            response.getWriter().write("OK|" + score);
        } catch (Exception ex) {
            ex.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("ERR");
        }
    }

    private void handleResultsPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studentId = (Integer) request.getSession().getAttribute("studentId");
        Map<Test, Double> results = testDao.getTestResultsForStudent(studentId);
        request.setAttribute("results", results);
        request.getRequestDispatcher("student/results.jsp").forward(request, response);
    }

    private void handleGuidePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("student/guide.jsp").forward(request, response);
    }
}
