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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/professor-common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/edit-test.css">
    <script>
        // Set minimum datetime for start time (current datetime)
        window.addEventListener('DOMContentLoaded', function() {
            var now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            var minDateTime = now.toISOString().slice(0, 16);
            
            var startInput = document.querySelector('input[name="startTime"]');
            var endInput = document.querySelector('input[name="endTime"]');
            
            startInput.min = minDateTime;
            
            // When start time changes, update end time minimum
            startInput.addEventListener('change', function() {
                endInput.min = this.value;
                if (endInput.value && endInput.value <= this.value) {
                    alert('Thời gian kết thúc phải sau thời gian bắt đầu!');
                    endInput.value = '';
                }
            });
            
            // Validate end time
            endInput.addEventListener('change', function() {
                if (startInput.value && this.value <= startInput.value) {
                    alert('Thời gian kết thúc phải sau thời gian bắt đầu!');
                    this.value = '';
                }
            });
        });
        
        function validateEditTestForm() {
            var startTime = document.querySelector('input[name="startTime"]').value;
            var endTime = document.querySelector('input[name="endTime"]').value;
            var now = new Date();
            
            if (!startTime || !endTime) {
                alert('Vui lòng nhập đầy đủ thời gian bắt đầu và kết thúc!');
                return false;
            }
            
            var start = new Date(startTime);
            var end = new Date(endTime);
            
            if (start <= now) {
                alert('Thời gian bắt đầu phải sau thời điểm hiện tại!');
                return false;
            }
            
            if (end <= start) {
                alert('Thời gian kết thúc phải sau thời gian bắt đầu!');
                return false;
            }
            
            return confirm('Lưu tất cả các thay đổi này vào cơ sở dữ liệu?');
        }
    </script>
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
                    <div class="user-role">Giáo Viên</div>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Đăng Xuất</a>
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

                                <form method="POST" action="<%= request.getContextPath() %>/professor" onsubmit="return validateEditTestForm();">
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
