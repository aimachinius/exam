<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
    <%@ page import="java.util.List" %>
        <%@ page import="Bean.Question" %>

            <% String username=(String) session.getAttribute("username"); String role=(String)
                session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
                (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
                return; } @SuppressWarnings("unchecked") List<Question> questions = (List<Question>)
                    request.getAttribute("questions");
                    %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Quản Lý Câu Hỏi - Hệ Thống Thi Trắc Nghiệm</title>
                        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/professor-common.css">
                        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage-question.css">
                    </head>

                    <body>
                        <div class="navbar">
                            <div class="navbar-brand">
                                <div class="logo">📚</div>
                                <h1>Hệ Thống Thi Trắc Nghiệm</h1>
                            </div>
                            <div class="navbar-right">
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <%= username.charAt(0) %>
                                    </div>
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
                                <div class="header">
                                    <h2>❓ Quản Lý Câu Hỏi</h2>
                                    <a href="<%= request.getContextPath() %>/professor?action=add-question"
                                        class="btn btn-primary">+ Thêm Câu Hỏi Mới</a>
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

                                                    <% if (questions==null || questions.isEmpty()) { %>
                                                        <div class="empty-state">
                                                            <div class="empty-state-icon">📭</div>
                                                            <h3>Không có câu hỏi nào</h3>
                                                            <p>Hãy tạo câu hỏi mới để bắt đầu</p>
                                                        </div>
                                                        <% } else { %>
                                                            <div class="questions-list">
                                                                <% for (Question question : questions) { %>
                                                                    <div class="question-card">
                                                                        <div class="question-header">
                                                                            <div class="question-content">
                                                                                <div class="question-text">
                                                                                    Q<%= question.getId() %>: <%=
                                                                                            question.getContent().substring(0,
                                                                                            Math.min(60,
                                                                                            question.getContent().length()))
                                                                                            %>...
                                                                                </div>
                                                                                <div class="question-meta">
                                                                                    ID: <%= question.getId() %> | Chuyên
                                                                                        Đề ID: <%= question.getTermId()
                                                                                            %>
                                                                                </div>
                                                                            </div>
                                                                            <div class="question-actions">
                                                                                <a href="<%= request.getContextPath() %>/professor?action=edit-question&id=<%= question.getId() %>"
                                                                                    class="btn-small btn-edit">✏️
                                                                                    Sửa</a>
                                                                                <form method="POST"
                                                                                    action="<%= request.getContextPath() %>/professor"
                                                                                    onsubmit="return confirm('Bạn chắc chắn muốn xóa?');"
                                                                                    style="display:inline;margin:0;">
                                                                                    <input type="hidden" name="action"
                                                                                        value="delete-question" />
                                                                                    <input type="hidden" name="id"
                                                                                        value="<%= question.getId() %>" />
                                                                                    <button type="submit"
                                                                                        class="btn-small btn-delete">🗑️
                                                                                        Xóa</button>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                            <% } %>

                                                                <div class="back-link">
                                                                    <a href="professor-dashboard.jsp">← Quay lại
                                                                        Dashboard</a>
                                                                </div>
                            </div>
                        </div>
                    </body>

                    </html>