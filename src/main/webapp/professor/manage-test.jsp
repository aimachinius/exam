<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="Bean.Test" %>

<% String username=(String) session.getAttribute("username"); String role=(String)
    session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
    (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
    return; } @SuppressWarnings("unchecked") List<Test> tests = (List<Test>) request.getAttribute("tests");
    %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Cuộc Thi - Hệ Thống Thi Trắc Nghiệm</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            color: #333;
            font-size: 24px;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 18px;
        }

        .logout-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: #c0392b;
        }

        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
        }

        .content-wrapper {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
            padding: 40px;
            width: 100%;
            max-width: 900px;
            max-height: 85vh;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h2 {
            color: #333;
            font-size: 28px;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
        }

        .alert-error {
            background: #ffe5e5;
            color: #c0392b;
            border: 1px solid #e74c3c;
        }

        .alert-success {
            background: #e5ffe5;
            color: #27ae60;
            border: 1px solid #2ecc71;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .tests-list {
            display: grid;
            gap: 15px;
        }

        .test-card {
            background: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s;
        }

        .test-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
            background: white;
        }

        .test-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .test-info {
            flex: 1;
        }

        .test-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .test-meta {
            font-size: 12px;
            color: #999;
            margin-bottom: 8px;
        }

        .test-time {
            font-size: 13px;
            color: #666;
        }

        .test-actions {
            display: flex;
            gap: 10px;
        }

        .btn-small {
            padding: 8px 15px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
        }

        .btn-edit {
            background: #3498db;
            color: white;
        }

        .btn-edit:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .content-wrapper {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .test-card {
                padding: 15px;
            }

            .test-header {
                flex-direction: column;
                gap: 10px;
            }

            .test-actions {
                width: 100%;
            }

            .btn-small {
                flex: 1;
            }

            .navbar {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }
    </style>
</head>

<body>
    <div class="navbar">
        <h1>📚 Hệ Thống Thi Trắc Nghiệm</h1>
        <div class="navbar-right">
            <div class="user-info">
                <div class="user-avatar">
                    <%= username.charAt(0) %>
                </div>
                <div>
                    <div style="font-weight: 600;">
                        <%= fullname %>
                    </div>
                    <div style="font-size: 12px; opacity: 0.8;">Giáo Viên</div>
                </div>
            </div>
            <a href="logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="content-wrapper">
            <div class="header">
                <h2>📝 Quản Lý Cuộc Thi</h2>
                <a href="<%= request.getContextPath() %>/professor?action=create-test"
                    class="btn btn-primary">+ Tạo Cuộc Thi Mới</a>
            </div>

            <% String error=(String) request.getAttribute("error"); String success=(String)
                request.getAttribute("success"); %>

                <% if (error !=null) { %>
                    <div class="alert alert-error">
                        <%= error %>
                    </div>
                    <% } %>

                        <% if (success !=null) { %>
                            <div class="alert alert-success">
                                <%= success %>
                            </div>
                            <% } %>

                                <% if (tests==null || tests.isEmpty()) { %>
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📭</div>
                                        <h3>Không có cuộc thi nào</h3>
                                        <p>Hãy tạo cuộc thi mới để bắt đầu</p>
                                    </div>
                                    <% } else { %>
                                        <div class="tests-list">
                                            <% for (Test test : tests) { %>
                                                <div class="test-card">
                                                    <div class="test-header">
                                                        <div class="test-info">
                                                            <div class="test-name">
                                                                <%= test.getName() %>
                                                            </div>
                                                            <div class="test-meta">
                                                                ID: <%= test.getId() %> | Tổng câu hỏi: <%= test.getNumbersQuestion() %> | Thời gian: <%= test.getTime() %> phút
                                                            </div>
                                                            <div class="test-time">
                                                                🕐 Từ <%= test.getStartTime() %> đến <%= test.getEndTime() %>
                                                            </div>
                                                        </div>
                                                        <div class="test-actions">
                                                            <a href="<%= request.getContextPath() %>/professor?action=edit-test&id=<%= test.getId() %>"
                                                                class="btn-small btn-edit">✏️ Sửa</a>
                                                            <form method="POST" action="<%= request.getContextPath() %>/professor" onsubmit="return confirm('Bạn chắc chắn muốn xóa cuộc thi này?');" style="display:inline;margin:0;">
                                                                <input type="hidden" name="action" value="delete-test" />
                                                                <input type="hidden" name="id" value="<%= test.getId() %>" />
                                                                <button type="submit" class="btn-small btn-delete">🗑️ Xóa</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } %>
                                        </div>
                                        <% } %>

                                            <div class="back-link">
                                                <a href="professor-dashboard.jsp">← Quay lại Dashboard</a>
                                            </div>
        </div>
    </div>
</body>

</html>
