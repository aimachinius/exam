package Bean;

public class TestTerm {
    private int id;
    private int testId;
    private int termId;
    private int numberQuestions;

    public TestTerm() {
    }

    public TestTerm(int id, int testId, int termId, int numberQuestions) {
        this.id = id;
        this.testId = testId;
        this.termId = termId;
        this.numberQuestions = numberQuestions;
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

    public int getNumberQuestions() {
        return numberQuestions;
    }

    public void setNumberQuestions(int numberQuestions) {
        this.numberQuestions = numberQuestions;
    }

    @Override
    public String toString() {
        return "TestTerm{id=" + id + ", testId=" + testId + ", termId=" + termId + ", numberQuestions="
                + numberQuestions + "}";
    }
}
