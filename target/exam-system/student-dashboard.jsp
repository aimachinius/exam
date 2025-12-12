<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page session="true" %>
        <% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role");
            String fullname=(String) session.getAttribute("fullname"); if (username==null || !role.equals("STUDENT")) {
            response.sendRedirect("login.jsp"); return; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Học Sinh</title>
                <link rel="stylesheet" href="css/student-dashboard.css">
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
                                <div style="font-size: 12px; opacity: 0.8;">Học Sinh</div>
                            </div>
                        </div>
                        <a href="logout" class="logout-btn">Đăng Xuất</a>
                    </div>
                </div>

                <div class="container">
                    <div class="welcome-section">
                        <h2>Chào mừng, <%= fullname %>! 👋</h2>
                        <p>Đây là dashboard dành cho học sinh. Bạn có thể làm bài thi, xem kết quả và lịch sử thi cử.
                        </p>
                    </div>

                    <div class="dashboard-grid">
                        <div class="card">
                            <div class="card-icon">📋</div>
                            <h3>Làm Bài Thi</h3>
                            <p>Tham gia làm bài thi trắc nghiệm mới</p>
                            <button class="card-btn">Tham Gia</button>
                        </div>

                        <div class="card">
                            <div class="card-icon">📊</div>
                            <h3>Xem Kết Quả</h3>
                            <p>Xem kết quả bài thi đã hoàn thành</p>
                            <button class="card-btn">Xem Chi Tiết</button>
                        </div>

                        <div class="card">
                            <div class="card-icon">📜</div>
                            <h3>Lịch Sử Thi</h3>
                            <p>Xem tất cả lịch sử tham gia bài thi</p>
                            <button class="card-btn">Lịch Sử</button>
                        </div>

                        <div class="card">
                            <div class="card-icon">⚙️</div>
                            <h3>Cài Đặt</h3>
                            <p>Quản lý thông tin cá nhân của bạn</p>
                            <button class="card-btn">Cài Đặt</button>
                        </div>
                    </div>
                </div>
            </body>

            </html>