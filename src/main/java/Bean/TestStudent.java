package Bean;

public class TestStudent {
    private int testId;
    private int studentId;
    private Double point;

    public TestStudent() {
    }

    public TestStudent(int testId, int studentId, Double point) {
        this.testId = testId;
        this.studentId = studentId;
        this.point = point;
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

    public Double getPoint() {
        return point;
    }

    public void setPoint(Double point) {
        this.point = point;
    }

    @Override
    public String toString() {
        return "TestStudent{testId=" + testId + ", studentId=" + studentId + ", point=" + point + "}";
    }
}
