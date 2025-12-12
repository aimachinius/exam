package Bean;

public class Student {
    private int id;
    private int userId;
    private String className;

    public Student() {
    }

    public Student(int id, int userId, String className) {
        this.id = id;
        this.userId = userId;
        this.className = className;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    @Override
    public String toString() {
        return "Student{id=" + id + ", userId=" + userId + "}";
    }
}
