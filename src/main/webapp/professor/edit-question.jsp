<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
    <%@ page import="Bean.Question" %>
        <%@ page import="Bean.Answer" %>
            <%@ page import="Bean.Term" %>
                <%@ page import="java.util.List" %>

                    <% String username=(String) session.getAttribute("username"); String role=(String)
                        session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
                        (username==null || role==null || !role.equals("PROFESSOR")) {
                        response.sendRedirect("../login.jsp"); return; } Question question=(Question)
                        request.getAttribute("question"); @SuppressWarnings("unchecked") List<Answer> answers = (List
                        <Answer>) request.getAttribute("answers");
                            @SuppressWarnings("unchecked") List<Term> terms = (List<Term>)
                                    request.getAttribute("terms");
                                    boolean isEdit=question !=null; %>

                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>
                                            <%= isEdit ? "Sửa" : "Thêm" %> Câu Hỏi - Hệ Thống Thi Trắc Nghiệm
                                        </title>
                                        <link rel="stylesheet" href="css/edit-question.css">
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
                                            <div class="form-container">
                                                <h2>
                                                    <%= isEdit ? "✏️ Sửa Câu Hỏi" : "➕ Thêm Câu Hỏi Mới" %>
                                                </h2>

                                                <% String error=(String) request.getAttribute("error"); String
                                                    success=(String) request.getAttribute("success"); %>

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

                                                                    <form id="questionForm" method="POST"
                                                                        action="<%= request.getContextPath() %>/professor">
                                                                        <input type="hidden" name="action"
                                                                            value="<%= isEdit ? "edit-question"
                                                                            : "add-question" %>">
                                                                        <% if (isEdit) { %>
                                                                            <input type="hidden" name="id"
                                                                                value="<%= question.getId() %>">
                                                                            <% } %>

                                                                                <div class="form-group">
                                                                                    <label for="termId">Chọn Chuyên Đề
                                                                                        *</label>
                                                                                    <select id="termId" name="termId"
                                                                                        required>
                                                                                        <option value="">-- Chọn Chuyên
                                                                                            Đề --</option>
                                                                                        <% if (terms !=null) { for (Term
                                                                                            term : terms) { %>
                                                                                            <option
                                                                                                value="<%= term.getId() %>"
                                                                                                <%=isEdit &&
                                                                                                question.getTermId()==term.getId()
                                                                                                ? "selected" : "" %>>
                                                                                                <%= term.getName() %>
                                                                                            </option>
                                                                                            <% } } %>
                                                                                    </select>
                                                                                </div>

                                                                                <div class="form-group">
                                                                                    <label for="content">Nội Dung Câu
                                                                                        Hỏi *</label>
                                                                                    <textarea id="content"
                                                                                        name="content" required
                                                                                        placeholder="Nhập nội dung câu hỏi"><%= isEdit && question != null ? question.getContent() : "" %></textarea>
                                                                                </div>

                                                                                <div
                                                                                    style="background: #f0f0f0; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                                                                                    <h3
                                                                                        style="color: #333; margin-bottom: 15px; font-size: 16px;">
                                                                                        📋 Các Đáp Án</h3>

                                                                                    <% String[] optionKeys={"A","B","C","D"}; 
                                                                                    String[] optionNames={"Đáp án A","Đáp án B","Đáp án C","Đáp án D"}; 
                                                                                    if (isEdit && answers !=null && !answers.isEmpty()) { 
                                                                                        for (Answer answer : answers) { %>
                                                                                        <div class="answer-group">
                                                                                            <div class="answer-header">
                                                                                                <span
                                                                                                    class="answer-label">
                                                                                                    <%= answer.getOptionKey()
                                                                                                        %>:
                                                                                                </span>
                                                                                                <input type="text"
                                                                                                    name="option<%= answer.getOptionKey() %>"
                                                                                                    required
                                                                                                    placeholder="Nhập nội dung đáp án"
                                                                                                    value="<%= answer.getContent() %>"
                                                                                                    style="flex: 1; margin: 0; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                                                                                                <input type="checkbox"
                                                                                                    id="correct<%= answer.getOptionKey() %>"
                                                                                                    name="correctAnswer"
                                                                                                    value="<%= answer.getOptionKey() %>"
                                                                                                    class="answer-checkbox"
                                                                                                    <%=answer.isCorrect()
                                                                                                    ? "checked" : "" %>>
                                                                                                <label
                                                                                                    for="correct<%= answer.getOptionKey() %>"
                                                                                                    class="answer-checkbox-label">Đáp
                                                                                                    án đúng</label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <% } } else { for (int i=0; i <
                                                                                            optionKeys.length; i++) {
                                                                                            String key=optionKeys[i]; %>
                                                                                            <div class="answer-group">
                                                                                                <div
                                                                                                    class="answer-header">
                                                                                                    <span
                                                                                                        class="answer-label">
                                                                                                        <%= key %>:
                                                                                                    </span>
                                                                                                    <input type="text"
                                                                                                        name="option<%= key %>"
                                                                                                        required
                                                                                                        placeholder="Nhập nội dung đáp án"
                                                                                                        style="flex: 1; margin: 0; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                                                                                                    <input
                                                                                                        type="checkbox"
                                                                                                        id="correct<%= key %>"
                                                                                                        name="correctAnswer"
                                                                                                        value="<%= key %>"
                                                                                                        class="answer-checkbox">
                                                                                                    <label
                                                                                                        for="correct<%= key %>"
                                                                                                        class="answer-checkbox-label">Đáp
                                                                                                        án đúng</label>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } %>
                                                                                </div>

                                                                                <div class="form-actions">
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary">
                                                                                        <%= isEdit ? "Cập Nhật"
                                                                                            : "Thêm Câu Hỏi" %>
                                                                                    </button>
                                                                                    <!-- <button type="reset"
                                                                                        class="btn btn-secondary">Xóa</button> -->
                                                                                </div>
                                                                    </form>

                                                                    <div class="back-link">
                                                                        <a
                                                                            href="<%= request.getContextPath() %>/professor?action=manage-question">←
                                                                            Quay
                                                                            lại Danh Sách Câu Hỏi</a>
                                                                    </div>
                                            </div>
                                        </div>
                                    </body>

                                    </html>