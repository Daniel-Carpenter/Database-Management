-- Daniel Carpenter
-- 113009743

--=====================================================================================
-- OPTION 1 STORED PROCEDURE - EXPERIENCE BASED ON did
--=====================================================================================

DROP PROCEDURE IF EXISTS spUploadAvg1;

GO
-- Create the stored procedure with the following parameters
CREATE PROCEDURE spUploadAvg1
    @pid INT,
    @pname VARCHAR(64),
    @age INT
AS
BEGIN
    DECLARE @avgExperience INT;

    -- average experience when filtering on +/- 10 years of age
    SET @avgExperience = (
            SELECT AVG(years_of_experience)
            FROM Performer
            WHERE 
                    age < @age + 10 
                AND age > @age - 10
    )

    -- if avg exists then insert the age and rest of record into the table
    IF @avgExperience IS NOT NULL
        INSERT INTO Performer VALUES (@pid, @pname, @avgExperience, @age);

    -- If the age does not exist and 18 years less than the average is positive, then enter former calc as exp
    ELSE IF @avgExperience IS NULL AND @age - 18 > 0
        INSERT INTO Performer VALUES (@pid, @pname, @age - 18, @age);

    -- if non positive then enter no experience
    ELSE 
        INSERT INTO Performer VALUES (@pid, @pname, 0, @age);

END
GO


--=====================================================================================
-- OPTION 2 STORED PROCEDURE - EXPERIENCE BASED ON did
--=====================================================================================

DROP PROCEDURE IF EXISTS spUploadAvg2;

GO
-- Create the stored procedure with the following parameters
CREATE PROCEDURE spUploadAvg2
    @pid INT,
    @pname VARCHAR(64),
    @age INT,
    @did INT
AS
BEGIN
    -- get the average age of performers who acted based on inputted did (director id)
    DECLARE @avgExperience INT;
    SET @avgExperience = (
        SELECT AVG(years_of_experience) 
        FROM
            -- Performer data
            [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
            
            -- Acted data
            LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
                ON [perf].pid = [act].pid

            -- Movie Data
            RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
                ON [act].mname = [movi].mname
        WHERE did = @did
    )

    -- if avg exists then insert the age and rest of record into the table
    IF @avgExperience IS NOT NULL
        INSERT INTO Performer VALUES (@pid, @pname, @avgExperience, @age);

    -- If the age does not exist and 18 years less than the average is positive, then enter former calc as exp
    ELSE IF @avgExperience IS NULL AND @age - 18 > 0
        INSERT INTO Performer VALUES (@pid, @pname, @age - 18, @age);

    -- if non positive then enter no experience
    ELSE 
        INSERT INTO Performer VALUES (@pid, @pname, 0, @age);
END
GO