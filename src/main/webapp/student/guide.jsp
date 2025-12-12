<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hướng Dẫn Sử Dụng</title>
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
        .content { background: white; border-radius: 10px; box-shadow: 0 5px 20px rgba(0,0,0,0.2); padding: 40px; width: 100%; max-width: 1000px; max-height: 85vh; overflow-y: auto; }
        h2 { color: #333; margin-bottom: 30px; font-size: 28px; }
        .guide-section { margin-bottom: 35px; }
        .guide-section h3 { color: #667eea; font-size: 20px; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .guide-section p { color: #666; line-height: 1.8; margin: 10px 0; font-size: 15px; }
        .guide-section ul { color: #666; margin-left: 25px; margin: 15px 0; }
        .guide-section li { margin: 8px 0; line-height: 1.6; }
        .guide-section strong { color: #333; }
        .note-box { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; border-radius: 4px; margin: 15px 0; font-size: 14px; color: #856404; }
        .warning-box { background: #f8d7da; border-left: 4px solid #e74c3c; padding: 15px; border-radius: 4px; margin: 15px 0; font-size: 14px; color: #721c24; }
        .info-box { background: #d1ecf1; border-left: 4px solid #17a2b8; padding: 15px; border-radius: 4px; margin: 15px 0; font-size: 14px; color: #0c5460; }
        .actions { display: flex; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; }
        .btn { padding: 12px 24px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-back { background: #95a5a6; color: white; }
        .btn-back:hover { background: #7f8c8d; }
        .btn-dashboard { background: #667eea; color: white; }
        .btn-dashboard:hover { background: #5568d3; }
        .step-number { display: inline-flex; align-items: center; justify-content: center; width: 30px; height: 30px; background: #667eea; color: white; border-radius: 50%; font-weight: bold; margin-right: 10px; }
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
            <h2>❓ Hướng Dẫn Sử Dụng Hệ Thống Thi Trắc Nghiệm</h2>

            <div class="guide-section">
                <h3>🏠 Trang Chủ (Dashboard)</h3>
                <p>Đây là nơi bạn sẽ thấy ba tính năng chính của hệ thống:</p>
                <ul>
                    <li><strong>Danh Sách Cuộc Thi:</strong> Xem các cuộc thi mà bạn có thể tham gia</li>
                    <li><strong>Kết Quả Thi:</strong> Xem lại điểm số và kết quả các bài thi đã hoàn thành</li>
                    <li><strong>Hướng Dẫn:</strong> Trang này để giúp bạn hiểu cách sử dụng hệ thống</li>
                </ul>
                <div class="info-box">
                    💡 <strong>Mẹo:</strong> Bạn có thể quay lại trang chủ bất kỳ lúc nào bằng cách click nút "← Dashboard"
                </div>
            </div>

            <div class="guide-section">
                <h3>📝 Danh Sách Cuộc Thi</h3>
                <p>Trang này hiển thị tất cả các cuộc thi sẵn sàng cho bạn tham gia:</p>
                <ul>
                    <li><strong>Tên Cuộc Thi:</strong> Tiêu đề của bài thi</li>
                    <li><strong>Thời Lượng:</strong> Số phút bạn có để hoàn thành bài thi</li>
                    <li><strong>Số Câu:</strong> Tổng số câu hỏi trong bài thi</li>
                    <li><strong>Kết Thúc:</strong> Thời gian hết hạn để tham gia cuộc thi</li>
                </ul>
                <div class="warning-box">
                    ⚠️ <strong>Lưu Ý:</strong> Mỗi sinh viên chỉ được thi <strong>1 lần duy nhất</strong>. Sau khi nộp bài, bạn sẽ không thể làm lại được. Hãy chuẩn bị kỹ trước khi bắt đầu!
                </div>
            </div>

            <div class="guide-section">
                <h3>✏️ Trang Thi</h3>
                <p>Khi bạn bắt đầu thi, bạn sẽ thấy:</p>
                <ul>
                    <li><strong>Đồng Hồ Đếm Ngược:</strong> Hiển thị thời gian còn lại (phút:giây). Khi hết thời gian, bài thi sẽ tự động nộp</li>
                    <li><strong>Thông Tin Bài Thi:</strong> Số câu tổng cộng, thời lượng, và ghi chú quan trọng</li>
                    <li><strong>Câu Hỏi:</strong> Mỗi câu hỏi có 4 đáp án A, B, C, D. Chọn đáp án bằng cách click vào radio button</li>
                    <li><strong>Autosave:</strong> Câu trả lời của bạn tự động lưu mỗi 10 giây. Bạn không cần lo lắng mất dữ liệu!</li>
                </ul>
                <div class="info-box">
                    ℹ️ <strong>Thông Tin:</strong> Các đáp án luôn được hiển thị theo thứ tự A, B, C, D để dễ theo dõi
                </div>
            </div>

            <div class="guide-section">
                <h3>💾 Cách Trả Lời Câu Hỏi</h3>
                <ol style="margin-left: 25px;">
                    <li><strong>Đọc kỹ câu hỏi</strong> và 4 đáp án được đưa ra</li>
                    <li><strong>Click vào radio button</strong> của đáp án bạn chọn (đáp án được chọn sẽ highlight xanh dương)</li>
                    <li><strong>Tiếp tục</strong> với câu hỏi tiếp theo. Câu trả lời của bạn sẽ tự động lưu</li>
                    <li><strong>Để thay đổi</strong> câu trả lời, chỉ cần click vào đáp án khác</li>
                    <li><strong>Để bỏ trả lời</strong>, bạn không cần click gì cả — nếu không chọn, câu đó sẽ được coi là sai</li>
                </ol>
            </div>

            <div class="guide-section">
                <h3>🚀 Nộp Bài Thi</h3>
                <p>Khi bạn hoàn thành tất cả các câu hỏi:</p>
                <ol style="margin-left: 25px;">
                    <li><strong>Click nút "💾 Nộp bài"</strong> ở cuối trang</li>
                    <li><strong>Xác nhận</strong> trong hộp thoại xuất hiện (hành động này không thể hoàn tác!)</li>
                    <li><strong>Chờ</strong> hệ thống chấm bài tự động. Bạn sẽ nhận được thông báo với điểm số</li>
                    <li><strong>Điểm sẽ được lưu</strong> và có thể xem lại trong "Kết Quả Thi"</li>
                </ol>
                <div class="warning-box">
                    ⚠️ <strong>Quan Trọng:</strong> Hệ thống sẽ <strong>tự động nộp bài</strong> khi hết thời gian. Không cần chủ động nộp nếu bạn không muốn, nhưng hãy hoàn thành sớm để kiểm tra lại câu trả lời.
                </div>
            </div>

            <div class="guide-section">
                <h3>📊 Xem Kết Quả Thi</h3>
                <p>Sau khi thi xong, bạn có thể xem lại kết quả của mình:</p>
                <ul>
                    <li><strong>Click vào "Kết Quả Thi"</strong> trên Dashboard hoặc từ Danh Sách Cuộc Thi</li>
                    <li><strong>Xem bảng kết quả</strong> với thông tin:
                        <ul>
                            <li>Tên cuộc thi</li>
                            <li>Điểm số bạn nhận được (hiển thị dưới dạng XX.XX/100)</li>
                            <li>Thời lượng bài thi</li>
                            <li>Ngày và giờ bạn thi</li>
                        </ul>
                    </li>
                    <li><strong>Màu sắc điểm:</strong>
                        <ul>
                            <li><span style="color: #27ae60;"><strong>🟢 Xanh</strong></span> = Điểm cao (≥ 8.0)</li>
                            <li><span style="color: #f39c12;"><strong>🟡 Vàng</strong></span> = Điểm trung bình (5.0 - 8.0)</li>
                            <li><span style="color: #e74c3c;"><strong>🔴 Đỏ</strong></span> = Điểm thấp (< 5.0)</li>
                        </ul>
                    </li>
                </ul>
            </div>

            <div class="guide-section">
                <h3>❓ Câu Hỏi Thường Gặp (FAQ)</h3>
                <div style="margin-top: 15px;">
                    <div style="margin: 20px 0;">
                        <strong>Q: Nếu tôi bị mất kết nối internet giữa buổi thi thì sao?</strong><br>
                        A: Đừng lo! Bài thi của bạn đã được lưu tự động. Đơn giản là kết nối lại và tiếp tục làm bài. Hệ thống sẽ tự động khôi phục phiên làm bài của bạn.
                    </div>
                    <div style="margin: 20px 0;">
                        <strong>Q: Tôi có thể quay lại làm lại bài thi nếu không hài lòng với kết quả?</strong><br>
                        A: Không. Mỗi sinh viên chỉ được thi <strong>1 lần duy nhất</strong>. Hãy chuẩn bị kỹ trước khi bắt đầu!
                    </div>
                    <div style="margin: 20px 0;">
                        <strong>Q: Làm sao tôi biết câu trả lời đúng sau khi thi xong?</strong><br>
                        A: Hiện tại, hệ thống chỉ hiển thị điểm số. Bạn cần liên hệ với giảng viên để biết chi tiết về từng câu.
                    </div>
                    <div style="margin: 20px 0;">
                        <strong>Q: Thời gian hết giờ là tính theo máy tính của tôi hay máy chủ?</strong><br>
                        A: Tính theo máy chủ. Hãy đảm bảo đồng hồ máy tính của bạn chính xác để tránh bất ngờ.
                    </div>
                    <div style="margin: 20px 0;">
                        <strong>Q: Tôi có thể xem lại bài thi của mình?</strong><br>
                        A: Bạn chỉ có thể xem điểm số. Để xem chi tiết câu trả lời, vui lòng liên hệ với giảng viên.
                    </div>
                </div>
            </div>

            <div class="guide-section">
                <h3>💪 Mẹo Để Làm Bài Tốt</h3>
                <ul>
                    <li>🎯 <strong>Chuẩn bị trước:</strong> Ôn tập kỹ trước khi bắt đầu thi</li>
                    <li>⏰ <strong>Quản lý thời gian:</strong> Đừng dành quá nhiều thời gian cho một câu, hãy vượt qua nó và quay lại sau</li>
                    <li>📖 <strong>Đọc kỹ:</strong> Hãy đọc kỹ câu hỏi và tất cả các đáp án trước khi chọn</li>
                    <li>🔄 <strong>Kiểm tra lại:</strong> Nếu còn thời gian, hãy kiểm tra lại các câu trả lời của bạn</li>
                    <li>❌ <strong>Loại bỏ đáp án sai:</strong> Nếu không chắc chắn, hãy loại bỏ những đáp án rõ ràng là sai trước</li>
                    <li>🧠 <strong>Tín tưởng vào trực giác:</strong> Thường câu trả lời đầu tiên bạn chọn là chính xác</li>
                </ul>
            </div>

            <div class="note-box">
                📌 <strong>Ghi Chú Cuối Cùng:</strong> Nếu bạn gặp vấn đề kỹ thuật hoặc có câu hỏi không được giải đáp ở đây, vui lòng liên hệ với quản trị viên hoặc giảng viên của bạn.
            </div>

            <div class="actions">
                <a href="<%= request.getContextPath() %>/student?action=list" class="btn btn-back">← Danh Sách Thi</a>
                <a href="student-dashboard.jsp" class="btn btn-dashboard">→ Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
