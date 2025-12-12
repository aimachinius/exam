package Bean;

public class Term {
    private int id;
    private String name;
    private int professorId;

    public Term() {
    }

    public Term(int id, String name, int professorId) {
        this.id = id;
        this.name = name;
        this.professorId = professorId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getProfessorId() {
        return professorId;
    }

    public void setProfessorId(int professorId) {
        this.professorId = professorId;
    }

    @Override
    public String toString() {
        return "Term{id=" + id + ", name='" + name + "'}";
    }
}
