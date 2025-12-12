<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>

    <% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role");
        String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null ||
        !role.equals("PROFESSOR")) { response.sendRedirect("login.jsp"); return; } %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dashboard Giáo Viên</title>

            <link rel="stylesheet" href="css/pro-dashboard.css">
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
                <div class="welcome-section">
                    <h2>Chào mừng, <%= fullname %>! 👋</h2>
                    <p>Đây là dashboard dành cho giáo viên. Bạn có thể tạo bài thi, quản lý câu hỏi và xem kết quả học
                        sinh.</p>
                </div>

                <div class="dashboard-grid">
                    <div class="card">
                        <div class="card-icon">📝</div>
                        <h3>Tạo Cuộc Thi</h3>
                        <p>Tạo cuộc thi cho sinh viên</p>
                        <button class="card-btn" onclick="window.location.href='<%= request.getContextPath() %>/professor?action=create-test'">Tạo Mới</button>
                    </div>

                    <div class="card">
                        <div class="card-icon">�</div>
                        <h3>Quản Lý Cuộc Thi</h3>
                        <p>Xem, chỉnh sửa, xóa các cuộc thi đã tạo</p>
                        <button class="card-btn"
                            onclick="window.location.href='<%= request.getContextPath() %>/professor?action=manage-test'">Quản Lý</button>
                    </div>

                    <div class="card">
                        <div class="card-icon">�📚</div>
                        <h3>Quản Lý Chuyên Đề</h3>
                        <p>Quản lý các chuyên đề và bộ câu hỏi</p>
                        <button class="card-btn"
                            onclick="window.location.href='<%= request.getContextPath() %>/professor?action=manage-term'">Quản
                            Lý</button>
                    </div>

                    <div class="card">
                        <div class="card-icon">❓</div>
                        <h3>Quản Lý Câu Hỏi</h3>
                        <p>Tạo và quản lý các câu hỏi trắc nghiệm</p>
                        <button class="card-btn"
                            onclick="window.location.href='<%= request.getContextPath() %>/professor?action=manage-question'">Quản
                            Lý</button>
                    </div>

                    <div class="card">
                        <div class="card-icon">👥</div>
                        <h3>Quản Lý Người Dùng</h3>
                        <p>Tạo tài khoản giáo viên và học sinh mới</p>
                        <button class="card-btn"
                            onclick="window.location.href='<%= request.getContextPath() %>/professor?action=create-user'">Quản
                            Lý</button>
                    </div>
                </div>
                
                
            </div>
            
        </body>

        </html>