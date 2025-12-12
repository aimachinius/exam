<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
    <%@ page import="Bean.Term" %>

        <% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role");
            String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null ||
            !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp"); return; } Term term=(Term)
            request.getAttribute("term"); boolean isEdit=term !=null; %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <%= isEdit ? "Sửa" : "Thêm" %> Chuyên Đề - Hệ Thống Thi Trắc Nghiệm
                </title>
                <link rel="stylesheet" href="<%= request.getContextPath() %>/css/professor-common.css">
                <link rel="stylesheet" href="css/add-term.css">
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
                    <div class="form-container">
                        <h2>
                            <%= isEdit ? "✏️ Sửa Chuyên Đề" : "➕ Thêm Chuyên Đề Mới" %>
                        </h2>

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

                                            <form id="termForm" method="POST"
                                                action="<%= request.getContextPath() %>/professor">
                                                <input type="hidden" name="action" value='<%= isEdit ? "edit-term"
                                                    : "add-term" %>'>
                                                <% if (isEdit) { %>
                                                    <input type="hidden" name="id" value="<%= term.getId() %>">
                                                    <% } %>

                                                        <div class="form-group">
                                                            <label for="name">Tên Chuyên Đề *</label>
                                                            <input type="text" id="name" name="name" required
                                                                placeholder="Nhập tên chuyên đề"
                                                                value="<%= isEdit && term != null ? term.getName() : "" %>">
                                                        </div>

                                                        <div class="form-actions">
                                                            <button type="submit" class="btn btn-primary">
                                                                <%= isEdit ? "Cập Nhật" : "Thêm Chuyên Đề" %>
                                                            </button>
                                                            <!-- <button type="reset" class="btn btn-secondary">Xóa</button> -->
                                                        </div>
                                            </form>

                                            <div class="back-link">
                                                <a href="<%= request.getContextPath() %>/professor?action=manage-term">←
                                                    Quay lại Danh Sách Chuyên Đề</a>
                                            </div>
                    </div>
                </div>
            </body>

            </html>