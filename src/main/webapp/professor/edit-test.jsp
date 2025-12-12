<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="Bean.Test" %>
<%@ page import="Bean.TestTerm" %>
<%@ page import="Bean.StudentInfo" %>

<% String username=(String) session.getAttribute("username"); String role=(String)
    session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
    (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
    return; } Test test = (Test) request.getAttribute("test");
    @SuppressWarnings("unchecked") List<TestTerm>
    testTerms = (List<TestTerm>) request.getAttribute("testTerms");
    @SuppressWarnings("unchecked") List<Bean.TermInfo> testTermInfos = (List<Bean.TermInfo>) request.getAttribute("testTermInfos");
    @SuppressWarnings("unchecked") List<StudentInfo> assignedStudents = (List<StudentInfo>) request.getAttribute("students");
    @SuppressWarnings("unchecked") List<StudentInfo> allStudents = (List<StudentInfo>) request.getAttribute("allStudents");
    if (test==null) { response.sendRedirect("professor?action=manage-test"); return; } %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Cuộc Thi - Hệ Thống Thi Trắc Nghiệm</title>
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
            max-width: 1000px;
            max-height: 85vh;
            overflow-y: auto;
        }

        h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        input[type="text"],
        input[type="datetime-local"],
        input[type="number"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border 0.3s;
            font-family: inherit;
        }

        input[type="text"]:focus,
        input[type="datetime-local"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
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
            margin-right: 10px;
            margin-bottom: 10px;
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

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
        }

        .form-section {
            background: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }

        .form-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 16px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .empty-state {
            text-align: center;
            padding: 20px;
            color: #999;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-top: 10px;
        }

        .students-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .students-table thead {
            background: #f0f0f0;
        }

        .students-table th,
        .students-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .students-table th {
            font-weight: 600;
            color: #333;
        }

        .students-table tbody tr:hover {
            background: #fafafa;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-remove {
            background: #e74c3c;
            color: white;
        }

        .btn-remove:hover {
            background: #c0392b;
        }

        .btn-add {
            background: #27ae60;
            color: white;
        }

        .btn-add:hover {
            background: #229954;
        }

        .add-student-section {
            background: #f0f8ff;
            border: 1px solid #bce4f7;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
        }

        .add-student-section h4 {
            color: #2196f3;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .add-row {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }

        .add-row select {
            flex: 1;
        }

        .add-row button {
            flex: 0 0 auto;
            padding: 10px 15px;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }

        .button-group button {
            flex: 1;
        }

        .button-group a {
            flex: 1;
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

        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
            color: #1565c0;
        }

        .term-edit-row {
            display: grid;
            grid-template-columns: 1fr 1fr 2fr;
            gap: 10px;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .term-edit-row:last-child {
            border-bottom: none;
        }

        @media (max-width: 600px) {
            .content-wrapper {
                padding: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .term-edit-row {
                grid-template-columns: 1fr;
            }

            .students-table {
                font-size: 12px;
            }

            .students-table th,
            .students-table td {
                padding: 8px;
            }

            .add-row {
                flex-direction: column;
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
            <h2>✏️ Chỉnh Sửa Cuộc Thi: <%= test.getName() %></h2>

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

                                <form method="POST" action="<%= request.getContextPath() %>/professor" onsubmit="return confirm('Lưu tất cả các thay đổi này vào cơ sở dữ liệu?');">
                                    <input type="hidden" name="action" value="edit-test" />
                                    <input type="hidden" name="id" value="<%= test.getId() %>" />

                                    <!-- Section 1: Thông Tin Cuộc Thi -->
                                    <div class="form-section">
                                        <h3>📋 Thông Tin Cuộc Thi</h3>

                                        <div class="form-group">
                                            <label for="name">Tên Cuộc Thi <span style="color: red;">*</span></label>
                                            <input type="text" id="name" name="name" value="<%= test.getName() %>" required />
                                        </div>

                                        <div class="form-row">
                                            <div class="form-group">
                                                <label for="startTime">Thời Gian Bắt Đầu <span style="color: red;">*</span></label>
                                                <input type="datetime-local" id="startTime" name="startTime" value="<%= test.getStartTime().toString().replace(" ", "T").substring(0, 16) %>" required />
                                            </div>
                                            <div class="form-group">
                                                <label for="endTime">Thời Gian Kết Thúc <span style="color: red;">*</span></label>
                                                <input type="datetime-local" id="endTime" name="endTime" value="<%= test.getEndTime().toString().replace(" ", "T").substring(0, 16) %>" required />
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="time">Thời Lượng (Phút) <span style="color: red;">*</span></label>
                                            <input type="number" id="time" name="time" value="<%= test.getTime() %>" min="1" required />
                                        </div>
                                    </div>

                                    <!-- Section 2: Chỉnh Sửa Kỳ Thi (Term) -->
                                    <div class="form-section">
                                        <h3>📚 Chỉnh Sửa Số Câu Hỏi Theo Chuyên Đề</h3>
                                        <div class="info-box">
                                            Tổng số câu hỏi hiện tại: <strong><%= test.getNumbersQuestion() %></strong> câu
                                        </div>

                                        <% java.util.List<?> sourceTerms = (testTermInfos!=null && !testTermInfos.isEmpty()) ? testTermInfos : testTerms; %>
                                        <% if (sourceTerms==null || sourceTerms.isEmpty()) { %>
                                            <div class="empty-state">
                                                <p>Chưa có chuyên đề nào</p>
                                            </div>
                                            <% } else { %>
                                                <% for (Object o : sourceTerms) {
                                                       if (o instanceof Bean.TermInfo) {
                                                           Bean.TermInfo tt = (Bean.TermInfo) o;
                                                %>
                                                    <div class="term-edit-row">
                                                        <div>
                                                            <label>Chuyên Đề: <strong><%= (tt.getTermName()!=null && !tt.getTermName().isEmpty()) ? tt.getTermName() : ("ID " + tt.getTermId()) %></strong></label>
                                                        </div>
                                                        <div>
                                                            <label for="numQuestions_<%= tt.getId() %>">Số Câu Hỏi</label>
                                                            <input type="number" id="numQuestions_<%= tt.getId() %>" name="numQuestions_<%= tt.getId() %>" value="<%= tt.getNumberQuestions() %>" min="1" />
                                                        </div>
                                                        <div style="text-align: right;">
                                                            <small style="color: #999;">ID TestTerm: <%= tt.getId() %> | Term ID: <%= tt.getTermId() %></small>
                                                        </div>
                                                    </div>
                                                <% } else if (o instanceof TestTerm) {
                                                       TestTerm tt = (TestTerm) o;
                                                %>
                                                    <div class="term-edit-row">
                                                        <div>
                                                            <label>Chuyên Đề : <strong><%= tt.getTermId() %></strong></label>
                                                        </div>
                                                        <div>
                                                            <label for="numQuestions_<%= tt.getId() %>">Số Câu Hỏi</label>
                                                            <input type="number" id="numQuestions_<%= tt.getId() %>" name="numQuestions_<%= tt.getId() %>" value="<%= tt.getNumberQuestions() %>" min="1" />
                                                        </div>
                                                        <div style="text-align: right;">
                                                            <small style="color: #999;">ID TestTerm: <%= tt.getId() %></small>
                                                        </div>
                                                    </div>
                                                <% }
                                                   } %>
                                                <% } %>
                                    </div>

                                    <!-- Section 3: Quản Lý Sinh Viên -->
                                    <div class="form-section">
                                        <h3>👥 Quản Lý Sinh Viên Thi</h3>

                                        <!-- Danh sách sinh viên được phép thi -->
                                        <% if (assignedStudents==null || assignedStudents.isEmpty()) { %>
                                            <div class="empty-state">
                                                <p>Chưa có sinh viên nào được gán vào cuộc thi</p>
                                            </div>
                                            <% } else { %>
                                                <h4 style="margin-bottom: 10px; color: #333;">Sinh Viên Đã Được Gán (Nhấn Xóa Để Gỡ)</h4>
                                                <div class="table-wrapper">
                                                    <table class="students-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Mã Sinh Viên</th>
                                                                <th>Tên Sinh Viên</th>
                                                                <th>Lớp</th>
                                                                <th>Hành Động</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (StudentInfo student : assignedStudents) { %>
                                                                <tr>
                                                                    <td><%= student.getId() %></td>
                                                                    <td><%= student.getName() %></td>
                                                                    <td><%= student.getClassName() %></td>
                                                                    <td>
                                                                        <form method="POST" action="<%= request.getContextPath() %>/professor" style="display:inline;margin:0;">
                                                                            <input type="hidden" name="action" value="remove-student-from-test" />
                                                                            <input type="hidden" name="testId" value="<%= test.getId() %>" />
                                                                            <input type="hidden" name="studentId" value="<%= student.getId() %>" />
                                                                            <button type="submit" class="btn-small btn-remove">🗑️ Xóa</button>
                                                                        </form>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <% } %>

                                        <!-- Thêm sinh viên mới -->
                                        <div class="add-student-section">
                                            <h4>➕ Thêm Sinh Viên Mới</h4>
                                            <% if (allStudents==null || allStudents.isEmpty()) { %>
                                                <p style="color: #999; font-size: 13px;">Không có sinh viên nào trong hệ thống</p>
                                                <% } else { %>
                                                    <form method="POST" action="<%= request.getContextPath() %>/professor">
                                                        <div class="add-row">
                                                            <select name="studentIdToAdd" required>
                                                                <option value="">-- Chọn sinh viên --</option>
                                                                <% for (StudentInfo s : allStudents) { %>
                                                                    <option value="<%= s.getId() %>"><%= s.getId() %> - <%= s.getName() %> - <%= s.getClassName() %></option>
                                                                    <% } %>
                                                            </select>
                                                            <input type="hidden" name="action" value="add-student-to-test" />
                                                            <input type="hidden" name="testId" value="<%= test.getId() %>" />
                                                            <button type="submit" class="btn-small btn-add">➕ Thêm</button>
                                                        </div>
                                                    </form>
                                                    <% } %>
                                        </div>
                                    </div>

                                    <!-- Nút lưu và quay lại -->
                                    <div class="button-group">
                                        <button type="submit" class="btn btn-primary">💾 Lưu Tất Cả Thay Đổi</button>
                                        <a href="<%= request.getContextPath() %>/professor?action=manage-test"
                                            class="btn btn-secondary" style="text-align: center;">← Quay Lại</a>
                                    </div>
                                </form>

                                <div class="back-link" style="margin-top: 30px;">
                                    <a href="professor-dashboard.jsp">← Quay lại Dashboard</a>
                                </div>
        </div>
    </div>
</body>

</html>
