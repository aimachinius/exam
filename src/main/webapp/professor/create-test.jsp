<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Bean.Term" %>
<%@ page import="Bean.Student" %>

<% String username=(String) session.getAttribute("username"); String role=(String)
    session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
    (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
    return; } @SuppressWarnings("unchecked") List<Term> terms = (List<Term>) request.getAttribute("terms");
    @SuppressWarnings("unchecked") Map<Integer,Integer> termCounts = (Map<Integer,Integer>) request.getAttribute("termCounts");
    @SuppressWarnings("unchecked") List<Student> students = (List<Student>) request.getAttribute("students"); %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo Cuộc Thi - Hệ Thống Thi Trắc Nghiệm</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/professor-common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/create-test.css">
    <script>
        function filterByClass() {
            var v = document.getElementById('classFilter').value.toLowerCase();
            var rows = document.querySelectorAll('.student-row');
            rows.forEach(function(r){
                var cls = r.getAttribute('data-class') || '';
                if (!v || cls.toLowerCase().indexOf(v) !== -1) r.style.display=''; else r.style.display='none';
            });
        }
    </script>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">
            <div class="logo">📚</div>
            <h1>Hệ Thống Thi Trắc Nghiệm</h1>
        </div>
        <div class="navbar-right">
            <div class="user-info">
                <div class="user-avatar"><%= username.charAt(0) %></div>
                <div class="user-details">
                    <div class="user-name"><%= fullname %></div>
                    <div class="user-role">Giáo Viên</div>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

<div class="container">
    <div class="content-wrapper">
    <h2>📝 Tạo Cuộc Thi Mới</h2>
    <% String error=(String) request.getAttribute("error"); String success=(String) request.getAttribute("success"); %>
    <% if (error != null) { %><div style="color:#c0392b"><%= error %></div><% } %>
    <% if (success != null) { %><div style="color:#27ae60"><%= success %></div><% } %>

    <form method="POST" action="<%= request.getContextPath() %>/professor">
        <input type="hidden" name="action" value="create-test" />

        <div class="section">
            <label>Tên cuộc thi: <input type="text" name="name" required /></label><br/>
            <label>Thời gian bắt đầu: <input type="datetime-local" name="startTime" required /></label><br/>
            <label>Thời gian kết thúc: <input type="datetime-local" name="endTime" required /></label><br/>
            <label>Thời lượng (phút): <input type="number" name="time" min="1" required /></label>
        </div>

        <div class="section">
            <h3>Chọn Chuyên Đề và Số câu</h3>
            <table>
                <thead><tr><th>Chọn</th><th>Chuyên Đề</th><th>Số câu tối đa</th><th>Số câu cho test</th></tr></thead>
                <tbody>
                <% if (terms != null) { for (Term t : terms) { int max = termCounts != null && termCounts.containsKey(t.getId()) ? termCounts.get(t.getId()) : 0; %>
                    <tr>
                        <td><input type="checkbox" name="termIds" value="<%= t.getId() %>" /></td>
                        <td><%= t.getName() %></td>
                        <td><%= max %></td>
                        <td><input type="number" name="num_<%= t.getId() %>" min="1" max="<%= max %>" /></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>

        <div class="section">
            <h3>Chọn Sinh Viên</h3>
            <label>Tìm theo lớp: <input id="classFilter" oninput="filterByClass()" placeholder="Nhập tên lớp" /></label>
            <table>
                <thead><tr><th>Chọn</th><th>ID</th><th>Lớp</th></tr></thead>
                <tbody>
                <% if (students != null) { for (Student s : students) { %>
                    <tr class="student-row" data-class="<%= s.getClassName() %>">
                        <td><input type="checkbox" name="studentIds" value="<%= s.getId() %>" /></td>
                        <td><%= s.getId() %></td>
                        <td><%= s.getClassName() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>

        <div class="section">
            <button type="submit">Tạo Cuộc Thi</button>
        </div>
    </form>
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/professor-dashboard.jsp">← Quay lại Trang Chủ</a>
    </div>
    </div>
</div>

</body>
</html>
