-- ==========================================================================
-- @class:  DSA 4513
-- @asnmt:  Class Project
-- @task:   5 (a)
-- @author: Daniel Carpenter, ID: 113009743
-- @description: 
--     Queries to create procedures for queries 1 - 15 and 17 of the  
--     job-shop accounting system database
-- ==========================================================================

-- Use Daniel Carpenter's Azure Database for all queries
USE [cs-dsa-4513-sql-db]

-- ==========================================================================
-- DROP PROCEDURES IF ALREADY EXISTING
-- Note: Using schema named 'Project' for this Project's Tables
-- ==========================================================================

    -- Drop Procedures  -----------------------------------------------------
    DROP PROCEDURE IF EXISTS [Project].addCustomer;         -- 1
    DROP PROCEDURE IF EXISTS [Project].addDepartment;       -- 2
    DROP PROCEDURE IF EXISTS [Project].addProcess;          -- 3
    DROP PROCEDURE IF EXISTS [Project].addAssembly;         -- 4
    DROP PROCEDURE IF EXISTS [Project].addAccount;          -- 5
    DROP PROCEDURE IF EXISTS [Project].addJob;              -- 6
    DROP PROCEDURE IF EXISTS [Project].setJobAsCompleted;   -- 7
    DROP PROCEDURE IF EXISTS [Project].addTransaction;      -- 8
    DROP PROCEDURE IF EXISTS [Project].getTotalCosts;       -- 9
    DROP PROCEDURE IF EXISTS [Project].getTotalLaborTime;   -- 10
    DROP PROCEDURE IF EXISTS [Project].getProcessUpdate;    -- 11
    DROP PROCEDURE IF EXISTS [Project].getJobs;             -- 12
    DROP PROCEDURE IF EXISTS [Project].getCustomers;        -- 13
    DROP PROCEDURE IF EXISTS [Project].deleteJobs;          -- 14
    DROP PROCEDURE IF EXISTS [Project].setPaintJob;         -- 15
    DROP PROCEDURE IF EXISTS [Project].getCustomersInRange; -- 17


-- ==========================================================================
-- CREATE PROCDURES USED IN JAVA
-- ==========================================================================


-----------------------------------------------------------------------------
-- 1. Enter a new customer 
-----------------------------------------------------------------------------
    
    GO
    CREATE PROCEDURE [Project].addCustomer
        @name       VARCHAR(255),
        @address 	VARCHAR(255),
        @category 	INT

        AS 
        BEGIN
            INSERT INTO [Project].Customer VALUES (@name, @address, @category)
        END

    GO


-----------------------------------------------------------------------------
-- 2. Enter a new department 
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addDepartment
        @deptNo INT

        AS
        BEGIN
            INSERT INTO [Project].Department VALUES (@deptNo, 0)
        END
    GO


-----------------------------------------------------------------------------
-- 3. Enter a new process-id and its department together with its type and information 
-- relevant to the type
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addProcess
        @id         INT,
        @deptNo     INT

        AS 
        BEGIN
            -- Update the process table
            INSERT INTO [Project].Process VALUES (@id, @deptNo, 0) -- assumes that the department already exists

            -- Insert the Process into Job Cut, Fit, and Paint table
            -- with other attributes assumed null or 0 where applicable
            INSERT INTO [Project].[P_Cut]   (processID) VALUES (@id) 
            INSERT INTO [Project].[P_Fit]   (processID) VALUES (@id) 
            INSERT INTO [Project].[P_Paint] (processID) VALUES (@id) 
        END
    GO


-----------------------------------------------------------------------------
-- 4. Enter a new assembly with its customer-name, assembly-details, assembly-id, 
-- and dateordered and associate it with one or more processes
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addAssembly
        @assID 	        INT,
        @dateOrdered 	DATE,
        @details        VARCHAR(255),
        @customerName   VARCHAR(255),
        @processID      INT

        AS
        BEGIN
            -- Add the assembly
            INSERT INTO [Project].Assemblies VALUES (@assID, @dateOrdered, @details, 0)
            
            -- Add assembly id and customer name to the relation table 'Orders'
            INSERT INTO [Project].Orders     VALUES (@customerName, @assID)

            -- Update into the Relation table manufactures
            INSERT INTO [Project].Manufactures VALUES (@assID, @processID)
        END
    GO


-----------------------------------------------------------------------------
-- 5. Create a new account and associate it with the process, assembly, or department 
-- to which it is applicable
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addAccount
        @acctNo             INT,
        @dateEstablished 	DATE,
        @assembliesID       INT,
        @processID	        INT,
        @deptNo	            INT

        AS
        BEGIN
            -- Add an account to the 'Account' table
            INSERT INTO [Project].Account VALUES (@acctNo, @dateEstablished, @assembliesID, @processID, @deptNo)
            
        END
    GO
    

-----------------------------------------------------------------------------
-- 6. Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addJob
        @jobNo 	        INT,
        @startDate      DATE,
        @assembliesID   INT,
        @processID 	    INT,
        @deptNo        INT

        AS
        BEGIN
            -- Insert only releveant values into Job table, 
            -- intentionally omitting end date and other info attributes
            INSERT INTO [Project].Job (jobNo,   startDate,  assembliesID,  processID,  deptNo)
            VALUES                    (@jobNo, @startDate, @assembliesID, @processID, @deptNo)

            -- Insert the job into Job Cut, Fit, and Paint table
            -- with other attributes assumed null or 0 where applicable
            INSERT INTO [Project].[J_Cut]   (jobNo) VALUES (@jobNo) 
            INSERT INTO [Project].[J_Fit]   (jobNo) VALUES (@jobNo) 
            INSERT INTO [Project].[J_Paint] (jobNo) VALUES (@jobNo) 
        END
    GO


-----------------------------------------------------------------------------
-- 7. At the completion of a job, enter the date it completed and the information 
-- relevant to the type of job 
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].setJobAsCompleted
        @jobNo      INT,
        @endDate    DATE,
        @otherInfo  VARCHAR(255)
    
        AS
        BEGIN
            -- Update existing job's end date and other info 
            UPDATE  [Project].Job
            SET [Project].Job.endDate   = @endDate,
                [Project].Job.otherInfo = @otherInfo

            -- only show selected values for a given job number
            WHERE [Project].Job.jobNo   = @jobNo
        END
    GO

-----------------------------------------------------------------------------
-- 8. Enter a transaction-no and its sup-cost and update all the costs (details) of the 
-- affected accounts by adding sup-cost to their current values of details 
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].addTransaction
    	@transactionNo  INT,
        @cost 	        REAL,
        @deptNo         INT,
        @assembliesID   INT,
        @processID      INT,
        @jobNo          INT

        AS
        BEGIN
            -- Update the transaction table
            INSERT INTO [Project].[Transaction] VALUES (@transactionNo, @cost)

            -- Update the Relation table Records to associate with a job
            INSERT INTO [Project].[Records] VALUES (@jobNo, @transactionNo)

            UPDATE  [Project].Assemblies 
            SET     [Project].Assemblies.details1 += @cost -- Adds to the existing values in field
            WHERE   [Project].Assemblies.id = @assembliesID

            -- Update the Department Table for the given department
            UPDATE  [Project].Department
            SET     [Project].Department.details2 += @cost -- Adds to the existing values in field
            WHERE   [Project].Department.deptNo = @deptNo

            -- Update the Process table for the given Process
            UPDATE  [Project].Process
            SET     [Project].Process.details3 += @cost -- Adds to the existing values in field
            WHERE   [Project].Process.id = @processID
        END
    GO

-----------------------------------------------------------------------------
-- 9. Retrieve the total cost incurred on an assembly-id 
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getTotalCosts
        @id INT

    AS
        BEGIN   
            SELECT details1 AS TOTAL_COST
            FROM [Project].Assemblies

            -- Only show the selected assemblies ID
            WHERE id = @id
        END
    GO

-----------------------------------------------------------------------------
-- 10. Retrieve the total labor time within a department for jobs completed in the 
-- department during a given date
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getTotalLaborTime
        @deptNo  INT,
        @endDate DATE

    AS  
        BEGIN
            SELECT 
                deptNo,
                fit.timeOfLabor + cut.timeOfLabor + paint.timeOfLabor AS totalTimeOfLabor

            FROM [Project].Job job
                -- Join job cut table
                LEFT JOIN [Project].J_Cut cut
                    ON job.jobNo = cut.jobNo
                
                -- Join job fit table
                LEFT JOIN [Project].J_Fit fit
                    ON job.jobNo = fit.jobNo
                
                -- Join job paint table
                LEFT JOIN [Project].J_Paint paint
                    ON job.jobNo = paint.jobNo

            -- Only show the selected deptNo and end date
            WHERE 
                    deptNo  = @deptNo
                AND endDate = @endDate
        END
    GO

-----------------------------------------------------------------------------
-- 11. Retrieve the processes through which a given assembly-id has passed so far 
-- (in datecommenced order) and the department responsible for each process
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getProcessUpdate
        @assID INT

    AS
    BEGIN
        SELECT 
            dateOrdered,
            processID,
            deptNo
        FROM [Project].Process [p]

            -- Relation table between manufactures and assemblies
            LEFT JOIN [Project].Manufactures [m]
                ON p.id = m.processID

            -- Join assemblies table
            LEFT JOIN [Project].[Assemblies] [a]
                ON m.assembliesID = a.id

        -- Only show the given assemblies ID
        WHERE a.id = @assID

        ORDER BY dateOrdered
    END
    
    GO

-----------------------------------------------------------------------------
-- 12. Retrieve the jobs (together with their type information and assembly-id) 
-- completed during a given date in a given department
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getJobs
            @deptNo  INT,
            @endDate DATE

    AS  
        BEGIN
            SELECT 
                job.jobNo,
                otherInfo,
                assembliesID

            FROM [Project].Job job
                -- Join job cut table
                LEFT JOIN [Project].J_Cut cut
                    ON job.jobNo = cut.jobNo
                
                -- Join job fit table
                LEFT JOIN [Project].J_Fit fit
                    ON job.jobNo = fit.jobNo
                
                -- Join job paint table
                LEFT JOIN [Project].J_Paint paint
                    ON job.jobNo = paint.jobNo
            WHERE 

                -- Conditional upon selected dept and date
                    deptNo  = @deptNo
                AND endDate = @endDate
        END
    GO

-----------------------------------------------------------------------------
-- 13. Retrieve the customers (in name order) whose category is in a given range
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getCustomers
        @min INT,
        @max INT

    AS
        BEGIN
            SELECT [name]
            FROM [Project].Customer

            -- Get the customers with category between min and max range
            WHERE category BETWEEN @min AND @max
            ORDER BY [name]
        END
    GO

-----------------------------------------------------------------------------
-- 14. Delete all cut-jobs whose job-no is in a given range
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].deleteJobs
        @min INT,
        @max INT

    AS
        BEGIN
            DELETE FROM [Project].J_Cut

            -- Delete cuts between min and max job number range 
            -- (with data related to a cut job)
            WHERE 
                    jobNo BETWEEN @min AND @max 
                AND material IS NOT NULL
        END
    GO

-----------------------------------------------------------------------------
-- 15. Change the color of a given paint job
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].setPaintJob
        @newColor   VARCHAR(255),
        @jobNo      INT

    AS
        BEGIN
            UPDATE  [Project].J_Paint
            SET     [Project].J_Paint.color = @newColor
            WHERE   [Project].J_Paint.jobNo = @jobNo
        END
    GO

-----------------------------------------------------------------------------
-- 17. Retrieve the customers (in name order) whose category is in a given range
-----------------------------------------------------------------------------

    GO
    CREATE PROCEDURE [Project].getCustomersInRange
        @min INT,
        @max INT

    AS
        BEGIN
            SELECT * 
            FROM [Project].Customer

            -- Only within the min and max range
            WHERE category BETWEEN @min AND @max
            ORDER BY [name]
        END
    GO


