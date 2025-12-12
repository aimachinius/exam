<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Hệ Thống Thi Trắc Nghiệm</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            .login-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 400px;
                padding: 40px;
            }

            .login-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .login-header h1 {
                color: #333;
                font-size: 28px;
                margin-bottom: 10px;
            }

            .login-header p {
                color: #666;
                font-size: 14px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
                font-size: 14px;
            }

            .form-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .form-group input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 5px rgba(102, 126, 234, 0.1);
            }

            .login-btn {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s;
            }

            .login-btn:hover {
                transform: translateY(-2px);
            }

            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px;
                border-radius: 5px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
                display: none;
            }

            .error-message.show {
                display: block;
            }

            .login-info {
                background-color: #d1ecf1;
                color: #0c5460;
                padding: 12px;
                border-radius: 5px;
                margin-bottom: 20px;
                border: 1px solid #bee5eb;
                font-size: 13px;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <div class="login-header">
                <h1>Đăng Nhập</h1>
                <p>Hệ Thống Thi Trắc Nghiệm</p>
            </div>

            <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                <div class="error-message show">
                    <%= error %>
                </div>
                <% } %>

                    <!-- <div class="login-info">
                        <strong>Tài khoản mặc định:</strong><br>
                        Username: admin<br>
                        Password: admin123
                    </div> -->

                    <form action="login" method="POST">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required placeholder="Nhập username">
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required placeholder="Nhập password">
                        </div>

                        <button type="submit" class="login-btn">Đăng Nhập</button>
                    </form>
        </div>
    </body>

    </html>