package Bean;

public class Users {
    private int id;
    private String username;
    private String password;
    private String role;
    private String fullname;
    private java.sql.Date birthday;

    public Users() {
    }

    public Users(int id, String username, String password, String role, String fullname, java.sql.Date birthday) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.fullname = fullname;
        this.birthday = birthday;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public java.sql.Date getBirthday() {
        return birthday;
    }

    public void setBirthday(java.sql.Date birthday) {
        this.birthday = birthday;
    }

    @Override
    public String toString() {
        return "Users{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
