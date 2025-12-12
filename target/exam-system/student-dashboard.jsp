<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<% 
    String username = (String) session.getAttribute("username"); 
    String role = (String) session.getAttribute("role"); 
    String fullname = (String) session.getAttribute("fullname"); 
    if (username == null || role == null || !role.equals("STUDENT")) { 
        response.sendRedirect("login.jsp"); 
        return; 
    } 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/student-dashboard.css">
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
                    <div class="user-role">Sinh Viên</div>
                </div>
            </div>
            <a href="logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="content-wrapper">
            <div class="welcome-section">
                <h2>Chào mừng, <%= fullname %>! 👋</h2>
                <div class="info-box">
                    <span class="icon">💡</span>
                    <span>Mỗi sinh viên chỉ được thi 1 lần cho mỗi bài thi. Hãy chuẩn bị kỹ trước khi bắt đầu!</span>
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=list'">
                    <div class="card-icon">📝</div>
                    <h3>Danh Sách Cuộc Thi</h3>
                    <p>Xem các cuộc thi sẵn sàng để tham gia và lựa chọn bài thi phù hợp với bạn</p>
                    <button class="card-btn">Xem Danh Sách</button>
                </div>

                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=results'">
                    <div class="card-icon">📊</div>
                    <h3>Kết Quả Thi</h3>
                    <p>Xem điểm số và kết quả chi tiết các bài thi đã hoàn thành của bạn</p>
                    <button class="card-btn">Xem Kết Quả</button>
                </div>

                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=guide'">
                    <div class="card-icon">❓</div>
                    <h3>Hướng Dẫn</h3>
                    <p>Hướng dẫn chi tiết về cách sử dụng hệ thống thi trắc nghiệm một cách hiệu quả</p>
                    <button class="card-btn">Xem Hướng Dẫn</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>