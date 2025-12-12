<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.Map,Bean.Test" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Thi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/results.css">
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
            <h2>📊 Kết Quả Thi Của Bạn</h2>
            <% @SuppressWarnings("unchecked") Map<Test, Double> results = (Map<Test, Double>) request.getAttribute("results"); %>
            <% if (results==null || results.isEmpty()) { %>
                <div class="empty-state">
                    <p>Bạn chưa thi bài nào hoặc kết quả chưa được chấm. Vui lòng quay lại sau.</p>
                </div>
            <% } else { %>
                <table class="results-table">
                    <thead>
                        <tr>
                            <th style="width: 50%;">Tên Cuộc Thi</th>
                            <th style="width: 15%;">Điểm</th>
                            <th style="width: 20%;">Thời Lượng</th>
                            <th style="width: 15%;">Ngày Thi</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (Test test : results.keySet()) { 
                        Double point = results.get(test);
                        String scoreClass = "score-medium";
                        if (point >= 8.0) scoreClass = "score-high";
                        else if (point < 5.0) scoreClass = "score-low";
                        String dateStr = test.getStartTime() != null ? test.getStartTime().toString().substring(0, 19) : "N/A";
                    %>
                        <tr>
                            <td class="test-name"><%= test.getName() %></td>
                            <td class="score-cell <%= scoreClass %>"><%= String.format("%.2f", point) %>/100</td>
                            <td><%= test.getTime() %> phút</td>
                            <td class="date-cell"><%= dateStr %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
