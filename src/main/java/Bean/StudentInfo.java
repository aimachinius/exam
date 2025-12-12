package Bean;

public class StudentInfo {
    private int id;
    private String className;
    private String name;

    public StudentInfo() {
    }

    public StudentInfo(int id, String className, String name) {
        this.id = id;
        this.className = className;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
