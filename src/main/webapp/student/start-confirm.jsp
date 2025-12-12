<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<% String testId = String.valueOf(request.getAttribute("testId")); %>
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"/><title>Xác nhận bắt đầu</title></head>
<body>
    <h3>Bạn sắp bắt đầu bài thi. Lưu ý: mỗi sinh viên chỉ được thi 1 lần.</h3>
    <form method="POST" action="<%= request.getContextPath() %>/student">
        <input type="hidden" name="action" value="start-test" />
        <input type="hidden" name="testId" value="<%= testId %>" />
        <button type="submit">Bắt đầu</button>
    </form>
    <a href="<%= request.getContextPath() %>/student?action=list">Quay lại</a>
</body>
</html>