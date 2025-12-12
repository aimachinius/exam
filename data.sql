-- 1. Users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role ENUM('PROFESSOR','STUDENT') NOT NULL,
    fullname VARCHAR(200) NOT NULL,
    birthday DATE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Professor
CREATE TABLE professor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    department VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Student
CREATE TABLE student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 4. Term
CREATE TABLE term (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    professor_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES professor(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5. Question
CREATE TABLE question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content LONGTEXT NOT NULL,
    term_id INT NOT NULL,
    professor_id INT NOT NULL,
    FOREIGN KEY (term_id) REFERENCES term(id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professor(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 6. Answer
CREATE TABLE answer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_key CHAR(1) NOT NULL COMMENT 'A/B/C/D',
    content LONGTEXT NOT NULL,
    is_correct TINYINT(1) NOT NULL,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 8. Test (cuộc thi)
CREATE TABLE test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    time INT NOT NULL,
    professor_id INT NOT NULL,
    numbers_question INT NOT NULL,   -- tổng số câu
    FOREIGN KEY (professor_id) REFERENCES professor(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE test_term (
    id INT AUTO_INCREMENT PRIMARY KEY,
    test_id INT NOT NULL,
    term_id INT NOT NULL,
    number_questions INT NOT NULL,
    FOREIGN KEY (test_id) REFERENCES test(id) ON DELETE CASCADE,
    FOREIGN KEY (term_id) REFERENCES term(id) ON DELETE CASCADE,
    UNIQUE (test_id, term_id)   -- 1 test chỉ có 1 record cho 1 term
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


-- 10. Liên kết Test - Student (lưu điểm)
CREATE TABLE test_student (
    test_id INT NOT NULL,
    student_id INT NOT NULL,
    point DOUBLE, -- lưu điểm sau khi chấm tự động
    PRIMARY KEY(test_id, student_id),
    FOREIGN KEY (test_id) REFERENCES test(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 11. Session for in-progress student tests (to persist question order, answers, time)
CREATE TABLE IF NOT EXISTS test_student_session (
    test_id INT NOT NULL,
    student_id INT NOT NULL,
    started_at DATETIME,
    question_order TEXT,
    answers_json TEXT,
    time_spent_seconds INT DEFAULT 0,
    submitted TINYINT(1) DEFAULT 0,
    PRIMARY KEY(test_id, student_id),
    FOREIGN KEY (test_id) REFERENCES test(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);
