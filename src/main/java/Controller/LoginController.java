package Controller;

import Bo.LoginBo;
import Bean.Users;
import Bean.Professor;
import Bean.Student;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import Bo.ProfessorBo;
import Bo.StudentBo;

public class LoginController extends HttpServlet {
    private LoginBo loginBo = new LoginBo();
    private ProfessorBo professorBo = new ProfessorBo();
    private StudentBo studentBo = new StudentBo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập username và password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Users user = loginBo.login(username, password);

        if (user != null) {
            // Tạo session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.getRole().equals("PROFESSOR")) {
                Professor professor = professorBo.getProfessorByIdUser(user.getId());
                System.out.println(professor);
                session.setAttribute("userId", professor.getId());
            } else {
                Student student = studentBo.getStudentByIdUser(user.getId());
                session.setAttribute("userId", student.getId());
                session.setAttribute("studentId", student.getId());
            }
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullname", user.getFullname());

            // Redirect dựa theo role
            String redirectPage = loginBo.getRedirectPage(user.getRole());
            response.sendRedirect(redirectPage);
        } else {
            request.setAttribute("error", "Username hoặc password không chính xác");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
