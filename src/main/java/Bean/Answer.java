package Bean;

public class Answer {
    private int id;
    private int questionId;
    private String optionKey;
    private String content;
    private boolean isCorrect;

    public Answer() {
    }

    public Answer(int id, int questionId, String optionKey, String content, boolean isCorrect) {
        this.id = id;
        this.questionId = questionId;
        this.optionKey = optionKey;
        this.content = content;
        this.isCorrect = isCorrect;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getOptionKey() {
        return optionKey;
    }

    public void setOptionKey(String optionKey) {
        this.optionKey = optionKey;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    @Override
    public String toString() {
        return "Answer{id=" + id + ", q=" + questionId + ", " + optionKey + "}";
    }
}
