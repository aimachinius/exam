package Bean;

public class TestSession {
    private int testId;
    private int studentId;
    private java.sql.Timestamp startedAt;
    private String questionOrderJson; // JSON array of question IDs in chosen order
    private String answersJson; // JSON object mapping questionId->selectedOption
    private int timeSpentSeconds; // time already spent
    private boolean submitted;

    public TestSession() {
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public java.sql.Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(java.sql.Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public String getQuestionOrderJson() {
        return questionOrderJson;
    }

    public void setQuestionOrderJson(String questionOrderJson) {
        this.questionOrderJson = questionOrderJson;
    }

    public String getAnswersJson() {
        return answersJson;
    }

    public void setAnswersJson(String answersJson) {
        this.answersJson = answersJson;
    }

    public int getTimeSpentSeconds() {
        return timeSpentSeconds;
    }

    public void setTimeSpentSeconds(int timeSpentSeconds) {
        this.timeSpentSeconds = timeSpentSeconds;
    }

    public boolean isSubmitted() {
        return submitted;
    }

    public void setSubmitted(boolean submitted) {
        this.submitted = submitted;
    }
}
