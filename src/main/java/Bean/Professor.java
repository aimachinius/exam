package Bean;

public class Professor {
    private int id;
    private int userId;
    private String department;

    public Professor() {
    }

    public Professor(int id, int userId, String department) {
        this.id = id;
        this.userId = userId;
        this.department = department;
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

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    @Override
    public String toString() {
        return "Professor{id=" + id + ", userId=" + userId + "}";
    }
}
