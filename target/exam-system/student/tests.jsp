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
        .tests-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .test-card { border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: #f9f9f9; transition: all 0.3s; }
        .test-card:hover { box-shadow: 0 5px 15px rgba(0,0,0,0.1); transform: translateY(-2px); }
        .test-card h3 { color: #333; margin-bottom: 10px; }
        .test-card p { color: #666; font-size: 13px; margin: 6px 0; }
        .test-card .meta { background: #f0f0f0; padding: 10px; border-radius: 4px; margin: 15px 0; font-size: 12px; }
        .test-card .actions { display: flex; gap: 10px; margin-top: 15px; }
        .btn { padding: 10px 16px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5568d3; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }
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
            <a href="student-dashboard.jsp" class="logout-btn">← Dashboard</a>
            <a href="logout" class="logout-btn">Đăng Xuất</a>
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