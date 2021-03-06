-----------------------
-- Homework 3
-- Daniel Carpenter
-----------------------

USE [cs-dsa-4513-sql-db]; 

--=============================================================================================
-- PROBLEM 1.1
--=============================================================================================

-- 1.1. To verify whether Azure SQL can check for integrity constraint violations, 
    -- using the relational database that you have created for Problem 2 in Graded Homework 2, 
    -- write SQL statements that implement the following queries, run them on Azure SQL, 
    -- and capture the error messages generated by Azure SQL: 
    
    -- a) One insertion query that violates the uniqueness of the primary key of a table. 
        INSERT INTO Performer
            (pid, pname, years_of_experience, age)
        VALUES
            (1, 'Daniel', 25, 26) -- pid violated, not unique

        
    -- b) One insertion query that violates the not-null value of the primary key of a table. 
        INSERT INTO Performer
            (pid, pname, years_of_experience, age)
        VALUES
            (NULL, 'Daniel', 25, 26) -- pid violated, null value instead of non-null expected int

    
    -- c) One insertion query, one deletion query, and one update query 
    --    that violate the foreign key constraint of a table.

        -- Insertion (Violates FK)
        INSERT INTO Acted
            (pid, mname)
        VALUES (999, 'Dog Shows') -- both violate FK constraint since do not exist in other tables

        -- Deletion (Violates FK)
        DELETE FROM Director 
        WHERE Director.did = 1 -- cannot delete since Movie table references did

        -- Update Query (Violates FK
        UPDATE Movie
        SET did = 999 
        WHERE did = 1 -- cannot update did to '999' since does not exist in director table

    
    -- d) One retrieval query that violates the domain constraint of an attribute of a table.
        SELECT * 
        FROM Director
        WHERE did = 'ID = 1' -- must be int value, not a string (varchar(64) in this case)


--=============================================================================================
-- PROBLEM 1.2
--=============================================================================================

-- write SQL statement(s) to create an index on that table ------------------------------------

    -- Drop for dev purposes 
    DROP INDEX IF EXISTS didMovieIndex ON Movie

    -- Create index
    CREATE INDEX didMovieIndex ON Movie(did)

    -- rerun the queries that need to access the table and index -------------------------------

        -- Remove data from director
        -- UPDATE Director
        --     SET did NOT NULL


-- Provide your detailed explanations as to why you chose that table and that search key for indexing, 
-- whether that index is primary or secondary,
    -- ANSWER: The reason for creating and index on Movie is because 'did' is solely used for joining to the 
    --          Director table. By putting a primary index on 'did' which is a foreign key, it will enhance the 
    --          execution time of the joins of the two tables.

-- and why you chose those queries to rerun.
    -- ANSWER: I reran the update queries on Director so it can update the index on the Movie table
    --          so that next time a j   oin happens, it is faster. 




