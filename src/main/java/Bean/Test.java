package Bean;

public class Test {
    private int id;
    private String name;
    private java.sql.Timestamp startTime;
    private java.sql.Timestamp endTime;
    private int time;
    private int professorId;
    private int numbersQuestion;

    public Test() {
    }

    public Test(int id, String name, java.sql.Timestamp startTime, java.sql.Timestamp endTime,
            int time, int professorId, int numbersQuestion) {
        this.id = id;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.time = time;
        this.professorId = professorId;
        this.numbersQuestion = numbersQuestion;
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

    public java.sql.Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(java.sql.Timestamp startTime) {
        this.startTime = startTime;
    }

    public java.sql.Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(java.sql.Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public int getProfessorId() {
        return professorId;
    }

    public void setProfessorId(int professorId) {
        this.professorId = professorId;
    }

    public int getNumbersQuestion() {
        return numbersQuestion;
    }

    public void setNumbersQuestion(int numbersQuestion) {
        this.numbersQuestion = numbersQuestion;
    }

    @Override
    public String toString() {
        return "Test{id=" + id + ", name='" + name + "'}";
    }
}
