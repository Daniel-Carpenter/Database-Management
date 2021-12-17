-- While working on the database design, it's useful to start from scratch every time
-- Hence, we drop tables in reverse order they are created (so the foreign key constraints are not violated) 
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Class;
DROP TABLE IF EXISTS Student;

-- Create tables
CREATE TABLE Student (
    id INT PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    gpa real,
    major VARCHAR(16) NOT NULL,
    classification VARCHAR(10) NOT NULL,

    -- Some examples of attribute value constraints
    CONSTRAINT CHK_gpa CHECK (gpa BETWEEN 0.0 AND 4.0),
    CONSTRAINT CHK_classification CHECK (classification IN ('Freshman', 'Sophomore', 'Junior', 'Senior'))
);

CREATE TABLE Class (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(64),
    description VARCHAR(1024)
);

CREATE TABLE Enrollment (
    student_id INT,
    class_code VARCHAR(10),
    semester VARCHAR(6) NOT NULL,
    year INT NOT NULL,
    grade CHAR(1),

    -- Multi-attribute primary key
    CONSTRAINT PK_enrollment PRIMARY KEY (student_id, class_code, semester, year),

    -- Some foreign key constraint examples
    CONSTRAINT FK_student_id FOREIGN KEY (student_id) REFERENCES Student,
    CONSTRAINT FK_class_code FOREIGN KEY (class_code) REFERENCES Class,

    CONSTRAINT CHK_semester CHECK (semester IN ('Spring', 'Fall')),
    CONSTRAINT CHK_grade CHECK (grade IN ('A', 'B', 'C', 'D', 'F'))
);

-- Insert some valid records

-- Students without GPA
INSERT INTO Student
    (id, first_name, last_name, major, classification)
VALUES
    (1, 'John', 'Doe', 'CS', 'Freshman'),
    (2, 'Jane', 'Doe', 'DSA', 'Freshman');

-- Students with GPA
INSERT INTO Student
VALUES
    (3, 'Jack', 'Doe', 4.0, 'CS', 'Sophomore'),
    (4, 'Jill', 'Doe', 4.0, 'DSA', 'Sophomore');

-- Classes
INSERT INTO Class
VALUES
    ('CS4513', 'Database Management Systems', 'Just read the sylabus.'),
    ('CS5513', 'Advanced Database Management Systems', NULL);

-- Enrollments without grades
INSERT INTO Enrollment
    (student_id, class_code, semester, year)
VALUES
    (1, 'CS4513', 'Fall', 2020),
    (2, 'CS4513', 'Fall', 2020);

-- Enrollments with grades
INSERT INTO Enrollment
VALUES
    (3, 'CS5513', 'Spring', 2020, 'A'),
    (4, 'CS5513', 'Spring', 2020, 'A');

-- Try inserting some invalid records (none should succeed)
INSERT INTO Student VALUES (1, 'Valid', 'Val', 4.0, 'CS', 'Sophomore'); -- PK Violation
INSERT INTO Student VALUES (5, NULL, 'Val', 4.0, 'CS', 'Sophomore'); -- NOT NULL Violation
INSERT INTO Student VALUES (5, 'Valid', 'Val', 4.0, 'CS', 'Master'); -- CHK_classification Violation
INSERT INTO Student VALUES (5, 'Valid', 'Val', 5.0, 'CS', 'Sophomore'); -- CHK_gpa Violation
INSERT INTO Enrollment VALUES (3, 'CS5513', 'Spring', 2020, 'A'); -- PK_enrollment violation
INSERT INTO Enrollment VALUES (10, 'CS5513', 'Spring', 2020, 'A'); -- FK_student_id violation
INSERT INTO Enrollment VALUES (3, 'CS1234', 'Spring', 2020, 'A'); -- FK_class_code violation

-- Run some sample SELECT queries
SELECT * FROM Student; -- Get everything stored in Student table
SELECT description FROM Class WHERE code = 'CS4513'; -- Get the description of the DBMS class

-- Get the average GPA of students for each classification
SELECT classification, avg(gpa)
FROM Student
GROUP BY classification;

-- Get the names of students who ever got an A in CS5513 class
SELECT first_name, last_name
FROM Student, Enrollment
WHERE
    Student.id = Enrollment.student_id AND
    Enrollment.class_code = 'CS5513' AND
    Enrollment.grade = 'A';

-- Run some UPDATE queries AND DELETE queries
UPDATE Enrollment SET grade = 'B' WHERE student_id = 1 AND class_code = 'CS4513' AND semester = 'Fall' AND year = 2020;
DELETE FROM Enrollment WHERE student_id = 2 AND class_code = 'CS4513' AND semester = 'Fall' AND year = 2020;
SELECT * FROM Enrollment; -- Verify results
