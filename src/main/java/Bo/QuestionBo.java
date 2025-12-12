package Bo;

import Dao.QuestionDao;
import Bean.Question;
import Bean.Answer;
import Bean.Term;
import java.util.ArrayList;
import java.util.List;

public class QuestionBo {
    private QuestionDao questionDao = new QuestionDao();

    public List<Term> getTermsByProfessor(int professorId) {
        return questionDao.getTermsByProfessor(professorId);
    }

    public List<Question> getQuestionsByProfessor(int professorId) {
        return questionDao.getQuestionsByProfessor(professorId);
    }

    public boolean createQuestion(String content, int termId, int professorId,
            String optionA, String optionB, String optionC, String optionD,
            String correctAnswer) {
        // Validate
        if (content == null || content.isEmpty() ||
                optionA == null || optionA.isEmpty() ||
                optionB == null || optionB.isEmpty() ||
                optionC == null || optionC.isEmpty() ||
                optionD == null || optionD.isEmpty() ||
                correctAnswer == null || correctAnswer.isEmpty()) {
            return false;
        }

        // Create question
        Question question = new Question();
        question.setContent(content);
        question.setTermId(termId);
        question.setProfessorId(professorId);

        int questionId = questionDao.createQuestion(question);

        if (questionId > 0) {
            // Create answers
            List<Answer> answers = new ArrayList<>();
            answers.add(new Answer(0, questionId, "A", optionA, "A".equals(correctAnswer)));
            answers.add(new Answer(0, questionId, "B", optionB, "B".equals(correctAnswer)));
            answers.add(new Answer(0, questionId, "C", optionC, "C".equals(correctAnswer)));
            answers.add(new Answer(0, questionId, "D", optionD, "D".equals(correctAnswer)));

            return questionDao.createAnswers(questionId, answers);
        }

        return false;
    }

    public boolean updateQuestion(int questionId, String content, int termId, int professorId,
            String optionA, String optionB, String optionC, String optionD, String correctAnswer) {
        // Validate ownership
        if (!questionDao.isQuestionBelongsToProfessor(questionId, professorId)) {
            return false;
        }

        // Validate input
        if (content == null || content.isEmpty() ||
                optionA == null || optionA.isEmpty() ||
                optionB == null || optionB.isEmpty() ||
                optionC == null || optionC.isEmpty() ||
                optionD == null || optionD.isEmpty() ||
                correctAnswer == null || correctAnswer.isEmpty()) {
            return false;
        }

        // Update question
        if (!questionDao.updateQuestion(questionId, content, termId, professorId)) {
            return false;
        }

        // Update answers
        List<Answer> answers = new ArrayList<>();
        answers.add(new Answer(0, questionId, "A", optionA, "A".equals(correctAnswer)));
        answers.add(new Answer(0, questionId, "B", optionB, "B".equals(correctAnswer)));
        answers.add(new Answer(0, questionId, "C", optionC, "C".equals(correctAnswer)));
        answers.add(new Answer(0, questionId, "D", optionD, "D".equals(correctAnswer)));

        return questionDao.updateAnswers(questionId, answers);
    }

    public boolean deleteQuestion(int questionId, int professorId) {
        // Validate ownership
        if (!questionDao.isQuestionBelongsToProfessor(questionId, professorId)) {
            return false;
        }
        return questionDao.deleteQuestion(questionId, professorId);
    }

    public Question getQuestionById(int questionId) {
        return questionDao.getQuestionById(questionId);
    }

    public List<Answer> getAnswersByQuestion(int questionId) {
        return questionDao.getAnswersByQuestion(questionId);
    }
}
