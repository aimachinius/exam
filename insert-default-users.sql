-- Insert tài khoản Admin (Professor) mặc định
INSERT INTO users (username, password, role, fullname, birthday) 
VALUES ('admin', 'admin123', 'PROFESSOR', 'Admin User', '1990-01-01');

-- Insert tài khoản Student mẫu
INSERT INTO users (username, password, role, fullname, birthday) 
VALUES ('student1', 'password123', 'STUDENT', 'Sinh Viên 1', '2005-01-15');

INSERT INTO users (username, password, role, fullname, birthday) 
VALUES ('student2', 'password123', 'STUDENT', 'Sinh Viên 2', '2005-02-20');

-- Insert Professor record cho admin
INSERT INTO professor (user_id, department) 
VALUES (1, 'Khoa Công Nghệ Thông Tin');

-- Insert Student records
INSERT INTO student (user_id, class_name) 
VALUES (2, 'Lớp 10A');

INSERT INTO student (user_id, class_name) 
VALUES (3, 'Lớp 10A');
