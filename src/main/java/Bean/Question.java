package Bean;

public class Question {
    private int id;
    private String content;
    private int termId;
    private int professorId;

    public Question() {
    }

    public Question(int id, String content, int termId, int professorId) {
        this.id = id;
        this.content = content;
        this.termId = termId;
        this.professorId = professorId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getTermId() {
        return termId;
    }

    public void setTermId(int termId) {
        this.termId = termId;
    }

    public int getProfessorId() {
        return professorId;
    }

    public void setProfessorId(int professorId) {
        this.professorId = professorId;
    }

    @Override
    public String toString() {
        return "Question{id=" + id + "}";
    }
}
