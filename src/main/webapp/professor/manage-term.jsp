<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
    <%@ page import="java.util.List" %>
        <%@ page import="Bean.Term" %>

            <% String username=(String) session.getAttribute("username"); String role=(String)
                session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
                (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
                return; } @SuppressWarnings("unchecked") List<Term> terms = (List<Term>) request.getAttribute("terms");
                    %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Quản Lý Chuyên Đề - Hệ Thống Thi Trắc Nghiệm</title>
                        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/professor-common.css">
                        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/manage-term.css">
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
                                    <h2>📚 Quản Lý Chuyên Đề</h2>
                                    <a href="<%= request.getContextPath() %>/professor?action=add-term"
                                        class="btn btn-primary">+ Thêm Chuyên Đề Mới</a>
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

                                                    <% if (terms==null || terms.isEmpty()) { %>
                                                        <div class="empty-state">
                                                            <div class="empty-state-icon">📭</div>
                                                            <h3>Không có chuyên đề nào</h3>
                                                            <p>Hãy tạo chuyên đề mới để bắt đầu</p>
                                                        </div>
                                                        <% } else { %>
                                                            <div class="terms-list">
                                                                <% for (Term term : terms) { %>
                                                                    <div class="term-card">
                                                                        <div class="term-info">
                                                                            <div class="term-name">
                                                                                <%= term.getName() %>
                                                                            </div>
                                                                            <div class="term-id">ID: <%= term.getId() %>
                                                                            </div>
                                                                        </div>
                                                                        <div class="term-actions">
                                                                            <a href="<%= request.getContextPath() %>/professor?action=edit-term&id=<%= term.getId() %>"
                                                                                class="btn-small btn-edit">✏️ Sửa</a>
                                                                            <form method="POST" action="<%= request.getContextPath() %>/professor" onsubmit="return confirm('Bạn chắc chắn muốn xóa?');" style="display:inline;margin:0;">
                                                                                <input type="hidden" name="action" value="delete-term" />
                                                                                <input type="hidden" name="id" value="<%= term.getId() %>" />
                                                                                <button type="submit" class="btn-small btn-delete">🗑️ Xóa</button>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                            <% } %>

                                                                <div class="back-link">
                                                                    <a href="professor-dashboard.jsp">← Quay
                                                                        lại
                                                                        Dashboard</a>
                                                                </div>
                            </div>
                        </div>
                    </body>

                    </html>