-- ===== PORTFOLIO DATABASE SCHEMA =====
-- This file contains the SQL schema for the portfolio website database
-- Use this if you want to store contact form submissions in a database

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS portfolio_db;
USE portfolio_db;

-- Contacts table for storing contact form submissions
CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Projects table for dynamic project management (optional)
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    technologies TEXT,
    image_url VARCHAR(500),
    project_url VARCHAR(500),
    github_url VARCHAR(500),
    featured BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_featured (featured),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Skills table for dynamic skill management (optional)
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category ENUM('programming', 'web_dev', 'tools', 'principles') NOT NULL,
    proficiency INT DEFAULT 0 CHECK (proficiency >= 0 AND proficiency <= 100),
    icon VARCHAR(100),
    sort_order INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (active),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Experience table for dynamic experience management (optional)
CREATE TABLE IF NOT EXISTS experience (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    company VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    current BOOLEAN DEFAULT FALSE,
    type ENUM('work', 'volunteer', 'internship') DEFAULT 'work',
    sort_order INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type (type),
    INDEX idx_active (active),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Education table for dynamic education management (optional)
CREATE TABLE IF NOT EXISTS education (
    id INT AUTO_INCREMENT PRIMARY KEY,
    degree VARCHAR(200) NOT NULL,
    institution VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    gpa DECIMAL(3,2),
    type ENUM('degree', 'certification', 'course') DEFAULT 'degree',
    sort_order INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type (type),
    INDEX idx_active (active),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Settings table for website configuration (optional)
CREATE TABLE IF NOT EXISTS settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default settings
INSERT INTO settings (setting_key, setting_value, setting_type, description) VALUES
('site_title', 'Saif Aldin Ahmed - Full-Stack .NET Developer', 'string', 'Website title'),
('site_description', 'Portfolio website of Saif Aldin Ahmed, a Full-Stack .NET Developer from Giza, Egypt', 'string', 'Website description'),
('contact_email', 'saifahmedelbattawy@gmail.com', 'string', 'Primary contact email'),
('linkedin_url', 'https://linkedin.com/in/saif-aldin-ahmed', 'string', 'LinkedIn profile URL'),
('phone_number', '01012034328', 'string', 'Phone number'),
('location', 'Giza, Egypt', 'string', 'Location'),
('enable_contact_form', 'true', 'boolean', 'Enable/disable contact form'),
('enable_analytics', 'false', 'boolean', 'Enable/disable analytics'),
('maintenance_mode', 'false', 'boolean', 'Enable/disable maintenance mode');

-- Insert sample projects (optional)
INSERT INTO projects (title, description, technologies, featured, sort_order) VALUES
('SA School LMS', 'Responsive Learning Management System with dashboards, bilingual support, and user management.', 'HTML5,CSS3/SASS,Bootstrap 5,JavaScript,PHP,MySQL', TRUE, 1),
('3D SPHERE Company Website', 'Interactive web presence for a software business with modern design and functionality.', 'HTML,CSS,JavaScript,PHP,MySQL', TRUE, 2),
('Bank Management System', 'C++ desktop application with OOP principles and transaction handling capabilities.', 'C++,OOP,Desktop App', FALSE, 3),
('Employee & Client Manager', 'C++ console application with modular structure and comprehensive data validation.', 'C++,Console App,Data Validation', FALSE, 4);

-- Insert sample skills (optional)
INSERT INTO skills (name, category, proficiency, sort_order) VALUES
('C#', 'programming', 90, 1),
('C++', 'programming', 85, 2),
('JavaScript', 'programming', 80, 3),
('PHP', 'programming', 75, 4),
('Python', 'programming', 70, 5),
('HTML/CSS', 'web_dev', 95, 1),
('Bootstrap', 'web_dev', 90, 2),
('React.js', 'web_dev', 75, 3),
('SQL', 'web_dev', 85, 4),
('Git', 'tools', 85, 1),
('GitHub', 'tools', 90, 2),
('SQL Server', 'tools', 80, 3),
('Visual Studio', 'tools', 85, 4),
('VS Code', 'tools', 90, 5),
('OOP', 'principles', 90, 1),
('SOLID', 'principles', 85, 2),
('Clean Code', 'principles', 80, 3),
('Design Patterns', 'principles', 75, 4),
('Agile', 'principles', 80, 5);

-- Insert sample experience (optional)
INSERT INTO experience (title, company, description, start_date, end_date, current, type, sort_order) VALUES
('Full-Stack .NET Internship', 'Digital Egypt Pioneers', 'Gained hands-on experience in Full-Stack development using .NET technologies.', '2025-01-01', NULL, TRUE, 'internship', 1),
('Team Leader – .NET Track', 'Digital Egypt Pioneers', 'Leading and mentoring team members in .NET development projects.', '2024-01-01', NULL, TRUE, 'work', 2),
('Front-End Developer', 'Haya Karima Initiative', 'Volunteer work as a front-end developer for social initiatives.', '2024-01-01', NULL, TRUE, 'volunteer', 3),
('Public Relations', 'Evolve Group', 'Handling public relations and communication for student organizations.', '2023-01-01', '2024-01-01', FALSE, 'volunteer', 4);

-- Insert sample education (optional)
INSERT INTO education (degree, institution, description, start_date, end_date, gpa, type, sort_order) VALUES
('BSc in Information Systems', 'Misr University for Science & Technology', 'Bachelor of Science in Information Systems with focus on software development and system analysis.', '2021-09-01', '2025-06-01', 3.0, 'degree', 1),
('Full-Stack .NET Internship', 'Digital Egypt Pioneers', 'Comprehensive internship program covering full-stack development with .NET technologies.', '2025-01-01', '2025-06-01', NULL, 'certification', 2),
('+Value Program', 'NTA', 'National Technology Academy program focusing on advanced programming concepts.', '2024-01-01', '2024-12-01', NULL, 'certification', 3),
('Intro to Cybersecurity', 'Cisco', 'Introduction to cybersecurity fundamentals and best practices.', '2024-01-01', '2024-06-01', NULL, 'certification', 4);

-- Create user for database access (optional - change credentials)
-- CREATE USER 'portfolio_user'@'localhost' IDENTIFIED BY 'your_secure_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON portfolio_db.* TO 'portfolio_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Show tables
SHOW TABLES;

-- Show sample data
SELECT 'Contacts' as table_name, COUNT(*) as record_count FROM contacts
UNION ALL
SELECT 'Projects', COUNT(*) FROM projects
UNION ALL
SELECT 'Skills', COUNT(*) FROM skills
UNION ALL
SELECT 'Experience', COUNT(*) FROM experience
UNION ALL
SELECT 'Education', COUNT(*) FROM education
UNION ALL
SELECT 'Settings', COUNT(*) FROM settings; 