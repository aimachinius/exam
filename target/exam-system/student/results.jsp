<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.Map,Bean.Test" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Thi</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .navbar { background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #333; font-size: 24px; }
        .navbar-right { display: flex; align-items: center; gap: 30px; }
        .user-info { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: #667eea; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .logout-btn { background: #e74c3c; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; text-decoration: none; transition: background 0.3s; }
        .logout-btn:hover { background: #c0392b; }
        .container { display: flex; justify-content: center; align-items: flex-start; padding: 40px 20px; flex: 1; }
        .content { background: white; border-radius: 10px; box-shadow: 0 5px 20px rgba(0,0,0,0.2); padding: 40px; width: 100%; max-width: 1000px; }
        h2 { color: #333; margin-bottom: 30px; font-size: 28px; }
        .empty-state { text-align: center; padding: 40px; color: #999; }
        .results-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .results-table th { background: #f5f5f5; padding: 15px; text-align: left; font-weight: 600; color: #333; border-bottom: 2px solid #ddd; }
        .results-table td { padding: 15px; border-bottom: 1px solid #ddd; }
        .results-table tr:hover { background: #f9f9f9; }
        .test-name { font-weight: 600; color: #333; }
        .score-cell { font-size: 16px; font-weight: 600; }
        .score-high { color: #27ae60; }
        .score-medium { color: #f39c12; }
        .score-low { color: #e74c3c; }
        .date-cell { color: #666; font-size: 13px; }
        .actions { display: flex; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; }
        .btn { padding: 12px 24px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-back { background: #95a5a6; color: white; }
        .btn-back:hover { background: #7f8c8d; }
        .btn-dashboard { background: #667eea; color: white; }
        .btn-dashboard:hover { background: #5568d3; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📚 Hệ Thống Thi Trắc Nghiệm</h1>
        <div class="navbar-right">
            <div class="user-info">
                <div class="user-avatar"><%= username.charAt(0) %></div>
                <div>
                    <div style="font-weight: 600;"><%= fullname %></div>
                    <div style="font-size: 12px; opacity: 0.8;">Sinh Viên</div>
                </div>
            </div>
            <a href="../student-dashboard.jsp" class="logout-btn">← Dashboard</a>
            <a href="logout" class="logout-btn">Đăng Xuất</a>
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
            
            <div class="actions">
                <a href="<%= request.getContextPath() %>/student?action=list" class="btn btn-back">← Danh Sách Thi</a>
                <a href="student-dashboard.jsp" class="btn btn-dashboard">→ Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
