<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Sinh Viên</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; flex-direction: column; }
        
        .navbar { background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #333; font-size: 24px; }
        .navbar-right { display: flex; align-items: center; gap: 30px; }
        .user-info { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: #667eea; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 18px; }
        .logout-btn { background: #e74c3c; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; text-decoration: none; transition: background 0.3s; font-weight: 600; }
        .logout-btn:hover { background: #c0392b; }
        
        .container { flex: 1; display: flex; justify-content: center; align-items: flex-start; padding: 40px 20px; }
        .content-wrapper { width: 100%; max-width: 1200px; }
        
        .welcome-section { background: white; border-radius: 10px; padding: 40px; margin-bottom: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .welcome-section h2 { color: #333; font-size: 32px; margin-bottom: 15px; }
        .welcome-section p { color: #666; font-size: 16px; line-height: 1.6; }
        
        .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; }
        .card { background: white; border-radius: 10px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: all 0.3s; cursor: pointer; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.15); }
        
        .card-icon { font-size: 50px; margin-bottom: 15px; }
        .card h3 { color: #333; font-size: 20px; margin-bottom: 10px; }
        .card p { color: #666; font-size: 14px; margin-bottom: 20px; line-height: 1.5; }
        
        .card-btn { background: #667eea; color: white; border: none; padding: 12px 24px; border-radius: 5px; cursor: pointer; font-weight: 600; transition: all 0.3s; width: 100%; }
        .card-btn:hover { background: #5568d3; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
        
        .info-box { background: #f0f8ff; border-left: 4px solid #2196f3; padding: 15px; border-radius: 5px; margin-top: 20px; color: #1565c0; font-size: 14px; }
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
            <a href="logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="content-wrapper">
            <div class="welcome-section">
                <h2>Chào mừng, <%= fullname %>! 👋</h2>
                <p>Đây là dashboard của bạn. Bạn có thể xem danh sách các cuộc thi sẵn sàng để tham gia và bắt đầu thi ngay.</p>
                <div class="info-box">
                    💡 Mỗi sinh viên chỉ được thi 1 lần. Hãy chuẩn bị kỹ trước khi bắt đầu!
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=list'">
                    <div class="card-icon">📝</div>
                    <h3>Danh Sách Cuộc Thi</h3>
                    <p>Xem các cuộc thi sẵn sàng để tham gia</p>
                    <button class="card-btn">Xem Danh Sách</button>
                </div>

                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=results'">
                    <div class="card-icon">📊</div>
                    <h3>Kết Quả Thi</h3>
                    <p>Xem điểm số và kết quả các bài thi đã hoàn thành</p>
                    <button class="card-btn">Xem Kết Quả</button>
                </div>

                <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student?action=guide'">
                    <div class="card-icon">❓</div>
                    <h3>Hướng Dẫn</h3>
                    <p>Hướng dẫn sử dụng hệ thống thi trắc nghiệm</p>
                    <button class="card-btn">Xem Hướng Dẫn</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>