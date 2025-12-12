package Bo;

import Dao.UsersDao;
import Bean.Users;

public class LoginBo {
    private UsersDao usersDao = new UsersDao();

    public Users login(String username, String password) {
        if (usersDao.validateLogin(username, password)) {
            return usersDao.getUserByUsername(username);
        }
        return null;
    }

    public String getRedirectPage(String role) {
        if (role == null) {
            return "login.jsp";
        }

        switch (role) {
            case "PROFESSOR":
                return "professor-dashboard.jsp";
            case "STUDENT":
                return "student-dashboard.jsp";
            default:
                return "login.jsp";
        }
    }
}
