<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
    <%@ page import="java.util.List" %>
        <%@ page import="Bean.Term" %>

            <% String username=(String) session.getAttribute("username"); String role=(String)
                session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if
                (username==null || role==null || !role.equals("PROFESSOR")) { response.sendRedirect("../login.jsp");
                return; } @SuppressWarnings("unchecked") List<Term> terms = (List<Term>) request.getAttribute("terms");
                    Integer selectedTermId = (Integer) request.getAttribute("selectedTermId");
                    %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Thêm Câu Hỏi - Hệ Thống Thi Trắc Nghiệm</title>
                        <link rel="stylesheet" href="css/add-question.css">
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
                                <h2>➕ Thêm Câu Hỏi Mới</h2>

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

                                                    <form id="addQuestionForm" method="POST"
                                                        action="<%= request.getContextPath() %>/professor">
                                                        <input type="hidden" name="action" value="add-question">

                                                        <div class="form-section">
                                                            <h3>📋 Thông Tin Câu Hỏi</h3>

                                                            <div class="form-group">
                                                                <label for="termId">Chọn Chuyên Đề *</label>
                                                                <select id="termId" name="termId" required>
                                                                    <option value="">-- Chọn chuyên đề --</option>
                                                                    <% if (terms !=null && !terms.isEmpty()) { for (Term
                                                                        term : terms) { %>
                                                                        <option value="<%= term.getId() %>"
                                                                            <%=selectedTermId !=null &&
                                                                            selectedTermId==term.getId() ? "selected"
                                                                            : "" %>>
                                                                            <%= term.getName() %>
                                                                        </option>
                                                                        <% } } %>
                                                                </select>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="content">Nội Dung Câu Hỏi *</label>
                                                                <textarea id="content" name="content" required
                                                                    placeholder="Nhập nội dung câu hỏi"></textarea>
                                                            </div>
                                                        </div>

                                                        <div class="form-section">
                                                            <h3>🔤 Các Đáp Án</h3>

                                                            <div class="options-grid">
                                                                <div>
                                                                    <div class="option-label">
                                                                        <div class="option-badge">A</div>
                                                                        <span>Đáp án A</span>
                                                                    </div>
                                                                    <div class="form-group" style="margin-bottom: 0;">
                                                                        <input type="text" name="optionA" required
                                                                            placeholder="Nhập đáp án A">
                                                                    </div>
                                                                </div>

                                                                <div>
                                                                    <div class="option-label">
                                                                        <div class="option-badge"
                                                                            style="background: #16a085;">B</div>
                                                                        <span>Đáp án B</span>
                                                                    </div>
                                                                    <div class="form-group" style="margin-bottom: 0;">
                                                                        <input type="text" name="optionB" required
                                                                            placeholder="Nhập đáp án B">
                                                                    </div>
                                                                </div>

                                                                <div>
                                                                    <div class="option-label">
                                                                        <div class="option-badge"
                                                                            style="background: #c0392b;">C</div>
                                                                        <span>Đáp án C</span>
                                                                    </div>
                                                                    <div class="form-group" style="margin-bottom: 0;">
                                                                        <input type="text" name="optionC" required
                                                                            placeholder="Nhập đáp án C">
                                                                    </div>
                                                                </div>

                                                                <div>
                                                                    <div class="option-label">
                                                                        <div class="option-badge"
                                                                            style="background: #f39c12;">D</div>
                                                                        <span>Đáp án D</span>
                                                                    </div>
                                                                    <div class="form-group" style="margin-bottom: 0;">
                                                                        <input type="text" name="optionD" required
                                                                            placeholder="Nhập đáp án D">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="form-section">
                                                            <div class="correct-answer-section">
                                                                <label>✓ Chọn Đáp Án Đúng *</label>
                                                                <div class="radio-group">
                                                                    <label>
                                                                        <input type="radio" name="correctAnswer"
                                                                            value="A" required> A
                                                                    </label>
                                                                    <label>
                                                                        <input type="radio" name="correctAnswer"
                                                                            value="B" required> B
                                                                    </label>
                                                                    <label>
                                                                        <input type="radio" name="correctAnswer"
                                                                            value="C" required> C
                                                                    </label>
                                                                    <label>
                                                                        <input type="radio" name="correctAnswer"
                                                                            value="D" required> D
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="form-actions">
                                                            <button type="submit" class="btn btn-primary">Thêm Câu
                                                                Hỏi</button>
                                                            <button type="reset" class="btn btn-secondary">Xóa</button>
                                                        </div>
                                                    </form>

                                                    <div class="back-link">
                                                        <a href="../exam-system/professor-dashboard.jsp">← Quay
                                                            lại Dashboard</a>
                                                    </div>
                            </div>
                        </div>
                    </body>

                    </html>