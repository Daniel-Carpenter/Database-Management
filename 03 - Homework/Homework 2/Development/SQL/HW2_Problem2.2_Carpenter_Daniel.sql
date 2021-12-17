-- Daniel Carpenter
-- 113009743

-- 1. Display all the data you store in the database to verify that you have populated the relations correctly.
    SELECT 
        [perf].[pid],
        [pname],
        [years_of_experience],
        [age],
        [movi].[mname],
        [genre],
        [minutes],
        [release_year],
        [direct].[did],
        [dname],
        [earnings]

    FROM 
        -- Performer data
        [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
        
        -- Acted data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
            ON [perf].pid = [act].pid

        -- Movie Data
        RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
            ON [act].mname = [movi].mname

        -- Director Data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Director] AS [direct]
            ON [movi].did = [direct].did


-- 2. Find the names of all Action movies.
    SELECT mname
    FROM [cs-dsa-4513-sql-db].[dbo].[Movie]
    WHERE genre = 'Action'


-- 3. For each genre, display the genre and the average length (minutes) of movies for that genre.
    SELECT 
        genre,
        AVG([minutes]) AS avgMinutes

    FROM [cs-dsa-4513-sql-db].[dbo].[Movie]
    GROUP BY genre


-- 4. Find the names of all performers with at least 20 years of experience who have acted in a movie directed by Black.
    SELECT DISTINCT
        [perf].pid,
        [perf].pname

    FROM 
        -- Performer data
        [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
        
        -- Acted data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
            ON [perf].pid = [act].pid

        -- Movie Data
        RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
            ON [act].mname = [movi].mname

        -- Director Data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Director] AS [direct]
            ON [movi].did = [direct].did

    WHERE 
        years_of_experience >= 20
    AND dname = 'Black'


-- 5. Find the age of the oldest performer who is either named “Hanks” or has acted in a movie named “The Departed”.
    SELECT TOP 1
        [perf].pid,
        [perf].pname
    FROM 
        -- Performer data
        [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
        
        -- Acted data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
            ON [perf].pid = [act].pid

        -- Movie Data
        RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
            ON [act].mname = [movi].mname
    WHERE 
        pname = 'Hanks' 
    OR  [movi].mname = 'The Departed'
    
    ORDER BY age DESC 

    
-- 6. Find the names of all movies that are either a Comedy or have had more than one performer act in them.
    SELECT
        [movi].mname
        -- genre,
        -- COUNT([movi].mname) AS numPerformers
    FROM
        -- Performer data
        [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
        
        -- Acted data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
            ON [perf].pid = [act].pid

        -- Movie Data
        RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
            ON [act].mname = [movi].mname

    GROUP BY  
        [movi].mname,
        genre
    
    HAVING 
            COUNT([perf].pid) > 1 
        OR  genre = 'Comedy'


-- 7. Find the names and pid's of all performers who have acted in at least two movies that have the same genre.
    SELECT
        [perf].pid,
        pname,
        genre,
        COUNT([movi].mname) AS countOfMovies
    FROM
        -- Performer data
        [cs-dsa-4513-sql-db].[dbo].[Performer]          AS [perf]
        
        -- Acted data
        LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Acted]    AS [act]
            ON [perf].pid = [act].pid

        -- Movie Data
        RIGHT JOIN [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
            ON [act].mname = [movi].mname
    
    -- Account for movies with no performers listed
    WHERE [perf].pid IS NOT NULL

    GROUP BY 
        [perf].pid,
        pname,
        genre

    -- acted in at least two movies
    HAVING COUNT([movi].mname) >= 2 


-- 8. Decrease the earnings of all directors who directed “Up” by 10%.

    -- Inputs for decrease % for salaries, and the name of the movie who directed
    DECLARE @decreaseAmt AS REAL
    DECLARE @movieName   AS VARCHAR(64)

    SET @decreaseAmt = -0.10
    SET @movieName   = 'Up'

    -- Update table to show new earnings
    UPDATE Director
            SET earnings = earnings * (1 + @decreaseAmt)

        -- Get director's did who directed selected Movie ('Up')
        WHERE 
            did = (
                SELECT [direct].did
                    
                FROM
                    [cs-dsa-4513-sql-db].[dbo].[Movie]    AS [movi] 
                    
                    -- Director Data
                    LEFT JOIN [cs-dsa-4513-sql-db].[dbo].[Director] AS [direct]
                        ON [movi].did = [direct].did

                WHERE mname = @movieName
        )


-- 9. Delete all movies released in the 70's and 80's (1970 <= release_year <= 1989).
    
    DELETE FROM Movie 
    WHERE Movie.release_year BETWEEN 1970 AND 1989 
    