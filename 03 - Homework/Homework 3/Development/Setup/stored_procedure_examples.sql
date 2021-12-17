DROP TABLE IF EXISTS Persons;
CREATE TABLE Persons(
    [PersonID] int PRIMARY KEY,
    [Name] varchar(25),
    [Age]int, 
    [City]varchar(25));

INSERT INTO Persons(
    [PersonID],[Name],[Age],[City])
VALUES
    (1,'Naveen',25,'Norman'),
    (2,'Taras',28,'Dallas'),
    (3,'Ryan',21,'Norman'),
    (4,'Jack',22,'Chicago'),
    (5,'Joe',31,'OKC'),
    (6,'Bryan',36,'SFO');

-- Procedure without any parameters 
-- Creating a procedure sp_test1 which selects all records from Persons table 

DROP PROCEDURE IF EXISTS sp_test1;

GO
CREATE PROCEDURE sp_test1 
AS 
BEGIN 
    SELECT * FROM Persons 
END

-- Executing the procedure sp_test1 
GO 
EXEC sp_test1; 

-- Procedure that uses one input parameter

DROP PROCEDURE IF EXISTS sp_test2;

GO 
CREATE PROCEDURE sp_test2 
    @age INT 
AS 
BEGIN 
    SELECT * FROM Persons WHERE age > @age; 
END

-- Executing the procedure sp_test2
GO 
EXEC sp_test2 @age = 25;

-- Procedure which takes two input parameters 

DROP PROCEDURE IF EXISTS sp_test3;

GO 
CREATE PROCEDURE sp_test3 
    @age INT, 
    @city VARCHAR(20) 
AS 
BEGIN 
    SELECT * FROM Persons WHERE age >= @age and city = @city; 
END

-- Executing the procedure sp_test3
GO 
EXEC sp_test3 @age = 20, @city = 'Norman'; 

-- Procedure that uses a temporary variable and some conditional logic.
-- Insert a new person into the database. If they're an oldest person to date
--     set their city to OKC. Otherwise set it to Norman.

DROP PROCEDURE IF EXISTS sp_test4;

GO
CREATE PROCEDURE sp_test4
    @pid INT,
    @name VARCHAR(25),
    @age INT 
AS
BEGIN
    DECLARE @max_age INT;
    SET @max_age = (SELECT max(age) FROM Persons);

    IF @age > @max_age
        INSERT INTO Persons VALUES (@pid, @name, @age, 'OKC');
    ELSE
        INSERT INTO Persons VALUES (@pid, @name, @age, 'Norman');
END
GO

EXEC sp_test4 @pid = 7, @name = "Leopold", @age = 40;
SELECT * FROM Persons WHERE PersonID = 7;
