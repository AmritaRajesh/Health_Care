-- ============================================================
--  Hospital Management System — Full Database Setup
--  Run this once in MySQL / phpMyAdmin / MySQL Workbench
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hospital_db;

-- ── 1. Users (all roles share this table) ────────────────────
CREATE TABLE IF NOT EXISTS users (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100)  NOT NULL,
    email     VARCHAR(100)  UNIQUE NOT NULL,
    password  VARCHAR(255)  NOT NULL,
    phone     VARCHAR(20),
    role      ENUM('patient','doctor','admin') NOT NULL
);

-- ── 2. Doctors (extends users) ───────────────────────────────
CREATE TABLE IF NOT EXISTS doctors (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT         NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── 3. Appointments ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS appointments (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    patient_id       INT  NOT NULL,
    doctor_id        INT  NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot        VARCHAR(50),
    reason           TEXT,
    status           ENUM('pending','approved','completed','rejected') DEFAULT 'pending',
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES users(id) ON DELETE CASCADE
);

-- ── 4. Schedules (doctor availability) ──────────────────────
CREATE TABLE IF NOT EXISTS schedules (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id   INT         NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    start_time  TIME        NOT NULL,
    end_time    TIME        NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── 5. Prescriptions ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prescriptions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id      INT  NOT NULL,
    patient_id     INT  NOT NULL,
    appointment_id INT,
    medicines      TEXT NOT NULL,
    dosage         TEXT NOT NULL,
    notes          TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id)      REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (patient_id)     REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- ── 6. Reports (uploaded files) ──────────────────────────────
CREATE TABLE IF NOT EXISTS reports (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id      INT          NOT NULL,
    patient_id     INT          NOT NULL,
    appointment_id INT,
    report_title   VARCHAR(200) NOT NULL,
    file_name      VARCHAR(255) NOT NULL,
    file_path      VARCHAR(500) NOT NULL,
    uploaded_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id)      REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (patient_id)     REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- ── 7. Notifications ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT  NOT NULL,
    message    TEXT NOT NULL,
    is_read    TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── 8. Departments ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS departments (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE,
    description    TEXT,
    head_doctor_id INT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (head_doctor_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ── 9. Staff ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS staff (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    role          VARCHAR(50)  NOT NULL,
    department_id INT,
    status        ENUM('active','inactive') DEFAULT 'active',
    joined_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- ── 10. Bills ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bills (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    patient_id     INT            NOT NULL,
    doctor_id      INT            NOT NULL,
    appointment_id INT,
    description    VARCHAR(255)   NOT NULL,
    amount         DECIMAL(10,2)  NOT NULL,
    status         ENUM('unpaid','paid') DEFAULT 'unpaid',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid_at        TIMESTAMP NULL,
    FOREIGN KEY (patient_id)     REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)      REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- ── 11. Legacy patients table (kept for compatibility) ───────
CREATE TABLE IF NOT EXISTS patients (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(100) NOT NULL,
    age     INT,
    disease VARCHAR(100)
);

-- ============================================================
--  Demo seed data  (INSERT IGNORE = safe to re-run)
-- ============================================================

-- Default accounts
-- Admin  : admin@hms.com   / admin123
-- Doctor : doctor@hms.com  / doc123
-- Patient: patient@hms.com / pat123

INSERT IGNORE INTO users (id, full_name, email, password, phone, role) VALUES
(1, 'Admin User',       'admin@hms.com',   'admin123', '111-111-1111', 'admin'),
(2, 'Dr. Sarah Johnson','doctor@hms.com',  'doc123',   '+91-9876543210', 'doctor'),
(3, 'Test Patient',     'patient@hms.com', 'pat123',   '333-333-3333', 'patient');

INSERT IGNORE INTO doctors (id, user_id, specialization) VALUES
(1, 2, 'Cardiology');

INSERT IGNORE INTO schedules (doctor_id, day_of_week, start_time, end_time) VALUES
(2, 'Monday',    '09:00:00', '17:00:00'),
(2, 'Wednesday', '09:00:00', '17:00:00'),
(2, 'Friday',    '09:00:00', '17:00:00');

INSERT IGNORE INTO departments (name, description) VALUES
('Cardiology',   'Heart and cardiovascular care'),
('Neurology',    'Brain and nervous system'),
('Pediatrics',   'Child healthcare'),
('Orthopedics',  'Bone and joint care'),
('Emergency',    'Emergency and trauma care'),
('Dermatology',  'Skin care and treatment'),
('Radiology',    'Imaging and diagnostics');

-- ============================================================
--  Done. Open http://localhost:8080/<context>/login to start.
-- ============================================================

-- ============================================================
--  PHASE 2 — Additional Tables for Full Feature Set
-- ============================================================

-- ── 12. Rooms / Beds ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rooms (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    room_number   VARCHAR(20)  NOT NULL UNIQUE,
    room_type     ENUM('general','private','icu','emergency') DEFAULT 'general',
    department_id INT,
    capacity      INT DEFAULT 1,
    occupied      INT DEFAULT 0,
    status        ENUM('available','full','maintenance') DEFAULT 'available',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- ── 13. Room Admissions ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS room_admissions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    room_id        INT NOT NULL,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    admitted_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    discharged_at  TIMESTAMP NULL,
    notes          TEXT,
    status         ENUM('admitted','discharged') DEFAULT 'admitted',
    FOREIGN KEY (room_id)    REFERENCES rooms(id)   ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES users(id)   ON DELETE CASCADE
);

-- ── 14. Emergency Cases ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS emergency_cases (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    patient_id   INT,
    contact      VARCHAR(20),
    description  TEXT NOT NULL,
    severity     ENUM('low','medium','high','critical') DEFAULT 'high',
    status       ENUM('open','in_progress','resolved') DEFAULT 'open',
    assigned_doctor_id INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at  TIMESTAMP NULL,
    FOREIGN KEY (patient_id)          REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_doctor_id)  REFERENCES users(id) ON DELETE SET NULL
);

-- ── 15. Feedback & Ratings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS feedback (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    patient_id  INT NOT NULL,
    doctor_id   INT,
    rating      TINYINT DEFAULT NULL,
    subject     VARCHAR(200),
    message     TEXT NOT NULL,
    type        ENUM('feedback','complaint') DEFAULT 'feedback',
    status      ENUM('open','reviewed','closed') DEFAULT 'open',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES users(id) ON DELETE SET NULL
);

-- ── 16. Chat Messages ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS messages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT NOT NULL,
    receiver_id INT NOT NULL,
    message     TEXT NOT NULL,
    is_read     TINYINT(1) DEFAULT 0,
    sent_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── 17. Lab Tests ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lab_tests (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id      INT NOT NULL,
    patient_id     INT NOT NULL,
    appointment_id INT,
    test_name      VARCHAR(200) NOT NULL,
    instructions   TEXT,
    status         ENUM('recommended','sample_collected','completed') DEFAULT 'recommended',
    result         TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id)      REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (patient_id)     REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL
);

-- ── 18. Medicine Reminders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS medicine_reminders (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT NOT NULL,
    prescription_id INT,
    medicine_name   VARCHAR(200) NOT NULL,
    dosage          VARCHAR(100),
    reminder_time   TIME NOT NULL,
    days_of_week    VARCHAR(50) DEFAULT 'Daily',
    is_active       TINYINT(1) DEFAULT 1,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id)      REFERENCES users(id)          ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id)  ON DELETE SET NULL
);

-- ── 19. Audit Log ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_log (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT,
    action     VARCHAR(200) NOT NULL,
    details    TEXT,
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Demo rooms
INSERT IGNORE INTO rooms (room_number, room_type, capacity) VALUES
('101', 'general',   4),
('102', 'general',   4),
('201', 'private',   1),
('202', 'private',   1),
('ICU-1', 'icu',     2),
('ICU-2', 'icu',     2),
('ER-1',  'emergency', 4);

-- ============================================================
--  FIX: If feedback table already exists with CHECK constraint,
--  run this to remove it (MySQL 8.0.16+)
-- ============================================================
-- ALTER TABLE feedback MODIFY COLUMN rating TINYINT DEFAULT NULL;
