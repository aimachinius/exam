package Bean;

public class TermInfo {
    private int id; // test_term id
    private int testId;
    private int termId;
    private String termName;
    private int numberQuestions;

    public TermInfo() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getTermId() {
        return termId;
    }

    public void setTermId(int termId) {
        this.termId = termId;
    }

    public String getTermName() {
        return termName;
    }

    public void setTermName(String termName) {
        this.termName = termName;
    }

    public int getNumberQuestions() {
        return numberQuestions;
    }

    public void setNumberQuestions(int numberQuestions) {
        this.numberQuestions = numberQuestions;
    }

    @Override
    public String toString() {
        return "TermInfo{id=" + id + ", testId=" + testId + ", termId=" + termId + ", termName='" + termName
                + "', numberQuestions=" + numberQuestions + "}";
    }
}
