<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="Bean.Test" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Danh sách cuộc thi</title>
</head>
<body>
    <h2>Danh sách cuộc thi có thể tham gia</h2>
    <% @SuppressWarnings("unchecked") List<Test> tests = (List<Test>) request.getAttribute("tests"); %>
    <% if (tests==null || tests.isEmpty()) { %>
        <p>Không có cuộc thi nào để tham gia.</p>
    <% } else { %>
        <table border="1" cellpadding="6">
            <thead><tr><th>ID</th><th>Tên</th><th>Bắt đầu</th><th>Kết thúc</th><th>Thời lượng (phút)</th><th>Hành động</th></tr></thead>
            <tbody>
            <% for (Test t : tests) { %>
                <tr>
                    <td><%= t.getId() %></td>
                    <td><%= t.getName() %></td>
                    <td><%= t.getStartTime() %></td>
                    <td><%= t.getEndTime() %></td>
                    <td><%= t.getTime() %></td>
                    <td>
                        <form method="POST" action="<%= request.getContextPath() %>/student">
                            <input type="hidden" name="action" value="start-test" />
                            <input type="hidden" name="testId" value="<%= t.getId() %>" />
                            <button type="submit">Bắt đầu / Tiếp tục</button>
                        </form>
                        <a href="<%= request.getContextPath() %>/student?action=take&id=<%= t.getId() %>">Mở trang thi</a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</body>
</html>