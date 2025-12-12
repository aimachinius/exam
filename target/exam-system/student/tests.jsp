<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="Bean.Test" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách cuộc thi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/tests.css">
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">
            <div class="logo">📚</div>
            <h1>Hệ Thống Thi Trắc Nghiệm</h1>
        </div>
        <div class="navbar-right">
            <a href="<%= request.getContextPath() %>/student-dashboard.jsp" class="home-btn">🏠 Trang chủ</a>
            <div class="user-info">
                <div class="user-avatar"><%= username.charAt(0) %></div>
                <div class="user-details">
                    <div class="user-name"><%= fullname %></div>
                    <div class="user-role">Sinh Viên</div>
                </div>
            </div>
            <a href="../logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>
    
    <div class="container">
        <div class="content">
            <h2>📋 Danh sách cuộc thi có thể tham gia</h2>
            <% @SuppressWarnings("unchecked") List<Test> tests = (List<Test>) request.getAttribute("tests"); %>
            <% if (tests==null || tests.isEmpty()) { %>
                <div class="empty-state">
                    <p>Không có cuộc thi nào để tham gia. Vui lòng quay lại sau.</p>
                </div>
            <% } else { %>
                <div class="tests-grid">
                <% for (Test t : tests) { %>
                    <div class="test-card">
                        <h3><%= t.getName() %></h3>
                        <div class="meta">
                            <p><strong>⏰ Thời lượng:</strong> <%= t.getTime() %> phút</p>
                            <p><strong>❓ Số câu:</strong> <%= t.getNumbersQuestion() %> câu</p>
                            <p><strong>📅 Kết thúc:</strong> <%= t.getEndTime().toString().substring(0, 16) %></p>
                        </div>
                        <div class="actions">
                            <form method="POST" action="<%= request.getContextPath() %>/student" style="flex:1;">
                                <input type="hidden" name="action" value="start-test" />
                                <input type="hidden" name="testId" value="<%= t.getId() %>" />
                                <button type="submit" class="btn btn-primary" style="width:100%;">Bắt đầu / Tiếp tục</button>
                            </form>
                        </div>
                    </div>
                <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>