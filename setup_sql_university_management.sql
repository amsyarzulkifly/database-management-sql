-- =========================================
-- University Course Management System
-- =========================================

-- Drop & Create Database
DROP DATABASE IF EXISTS UniversityDB;
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- ================================
-- 1. Tables
-- ================================

-- Departments
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

-- Instructors
CREATE TABLE Instructors (
    InstructorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Courses
CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseCode VARCHAR(10) UNIQUE NOT NULL,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Students
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    EnrollmentDate DATE
);

-- Enrollments
CREATE TABLE Enrollments (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- ================================
-- 2. Sample Data
-- ================================

-- Departments
INSERT INTO Departments (DepartmentName) VALUES 
('Computer Science'), ('Mathematics'), ('Physics');

-- Instructors
INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID) VALUES
('Ali', 'Rahman', 'ali.rahman@uni.edu', 1),
('John', 'Doe', 'john.doe@uni.edu', 2),
('Siti', 'Zahra', 'siti.zahra@uni.edu', 1);

-- Courses
INSERT INTO Courses (CourseCode, CourseName, DepartmentID, Credits) VALUES
('CS101', 'Intro to Programming', 1, 4),
('MATH201', 'Calculus I', 2, 3),
('PHY150', 'General Physics', 3, 4),
('CS201', 'Data Structures', 1, 4);

-- Students
INSERT INTO Students (FirstName, LastName, Email, EnrollmentDate) VALUES
('Amir', 'Hakim', 'amir.hakim@student.uni.edu', '2023-08-01'),
('Lisa', 'Tan', 'lisa.tan@student.uni.edu', '2023-08-03'),
('Muhammad', 'Zaid', 'zaid@student.uni.edu', '2023-08-05');

-- Enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, Grade) VALUES
(1, 1, '2023-08-10', 'A'),
(1, 4, '2023-08-11', 'B'),
(2, 2, '2023-08-12', 'A'),
(2, 3, '2023-08-13', 'C'),
(3, 1, '2023-08-14', 'B');

-- ================================
-- 3. Sample Queries
-- ================================

-- List all students and their enrolled courses
SELECT 
    S.FirstName AS StudentFirstName,
    S.LastName AS StudentLastName,
    C.CourseName,
    E.Grade
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
JOIN Courses C ON E.CourseID = C.CourseID;

-- Average grade per course
SELECT 
    C.CourseName,
    AVG(CASE 
        WHEN E.Grade = 'A' THEN 4
        WHEN E.Grade = 'B' THEN 3
        WHEN E.Grade = 'C' THEN 2
        WHEN E.Grade = 'D' THEN 1
        ELSE 0
    END) AS GPA
FROM Courses C
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;

-- Students with GPA above 3.0
SELECT 
    S.FirstName,
    S.LastName,
    AVG(CASE 
        WHEN E.Grade = 'A' THEN 4
        WHEN E.Grade = 'B' THEN 3
        WHEN E.Grade = 'C' THEN 2
        WHEN E.Grade = 'D' THEN 1
        ELSE 0
    END) AS GPA
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.StudentID
HAVING GPA > 3.0;

-- Total students per department
SELECT 
    D.DepartmentName,
    COUNT(DISTINCT E.StudentID) AS TotalStudents
FROM Departments D
JOIN Courses C ON D.DepartmentID = C.DepartmentID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY D.DepartmentName;

-- ================================
-- Done!
-- ================================