-- ==========================================================================
-- @class:  DSA 4513
-- @asnmt:  Class Project
-- @task:   4
-- @author: Daniel Carpenter, ID: 113009743
-- @description: 
--     Queries to create tables, contraints, and indiceds of the job-shop 
--     accounting system database
-- ==========================================================================

-- Use Daniel Carpenter's Azure Database for all queries
USE [cs-dsa-4513-sql-db]

-- ==========================================================================
-- DROP TABLES IF ALREADY EXISTING
-- Note: Using schema named 'Project' for this Project's Tables
-- ==========================================================================

    -- Tables ---------------------------------------------------------------
    DROP TABLE IF EXISTS [Project].[P_Fit];
    DROP TABLE IF EXISTS [Project].[P_Paint];
    DROP TABLE IF EXISTS [Project].[P_Cut];
    DROP TABLE IF EXISTS [Project].[J_Fit];
    DROP TABLE IF EXISTS [Project].[J_Paint];
    DROP TABLE IF EXISTS [Project].[J_Cut];
    DROP TABLE IF EXISTS [Project].[Orders];
    DROP TABLE IF EXISTS [Project].[Manufactures];
    DROP TABLE IF EXISTS [Project].[ManagedBy];
    DROP TABLE IF EXISTS [Project].[Records];
    DROP TABLE IF EXISTS [Project].[Customer];
    DROP TABLE IF EXISTS [Project].[Job];
    DROP TABLE IF EXISTS [Project].[Transaction];
    DROP TABLE IF EXISTS [Project].[Account];           
    DROP TABLE IF EXISTS [Project].[Assemblies];
    DROP TABLE IF EXISTS [Project].[Process];
    DROP TABLE IF EXISTS [Project].[Department];


-- ==========================================================================
-- CREATE TABLES, INDICES, AND CONSTRAINTS FOR JOB-SHOP DATABASE
-- ==========================================================================

-- Create the Customer Table ------------------------------------------------
CREATE TABLE [Project].Customer (
	[name] 	        VARCHAR(255) PRIMARY KEY,
    [address] 	    VARCHAR(255) NOT NULL,
    [category] 	    INT NOT NULL,
    CONSTRAINT      CTGRY_RANGE CHECK(category >= 1 AND category <= 10)
)
-- Create B+ Tree Index on name of Customer table
CREATE INDEX [IDX_Customer_ON_name] ON [Project].Customer([name]);


-- Create the Assemblies Table ----------------------------------------------
CREATE TABLE [Project].Assemblies (
	[id] 	        INT PRIMARY KEY,
    [dateOrdered] 	DATE NOT NULL,
    [details] 	    VARCHAR(255) DEFAULT NULL,
    [details1] 	    REAL DEFAULT 0,
    CONSTRAINT      [NON_NEG_id_Assemblies] CHECK(id > 0)
)
-- Create B+ Tree Index on id of Assemblies table
CREATE INDEX [IDX_Assemblies_ON_id] ON [Project].Assemblies(id);


-- Create the Orders Table --------------------------------------------------
CREATE TABLE [Project].Orders (
	[customerName] 	VARCHAR(255) FOREIGN KEY REFERENCES [Project].Customer,
    [assembliesID] 	INT NOT NULL FOREIGN KEY REFERENCES [Project].Assemblies
)

-- Create the Fit Table for Processes ---------------------------------------
CREATE TABLE [Project].P_Fit (
	[processID] 	        INT PRIMARY KEY,
    [type] 	        VARCHAR(255) DEFAULT NULL,
    CONSTRAINT      [NON_NEG_id_P_Fit] CHECK(processID > 0)
)


-- Create the Paint Table for Processes -------------------------------------
CREATE TABLE [Project].P_Paint (
	[processID] 	        INT PRIMARY KEY,
    [type] 	        VARCHAR(255) DEFAULT NULL,
    [method] 	    VARCHAR(255) DEFAULT NULL,
    CONSTRAINT      [NON_NEG_id_P_Paint] CHECK(processID > 0)
)


-- Create the Cut Table for Processes ---------------------------------------
CREATE TABLE [Project].P_Cut (
	[processID] 	        INT PRIMARY KEY,
    [cutType] 	    VARCHAR(255) DEFAULT NULL,
    [machineType] 	VARCHAR(255) DEFAULT NULL,
    CONSTRAINT      [NON_NEG_id_P_Cut] CHECK(processID > 0)
)


-- Create the Table for Departments------------------------------------------
CREATE TABLE [Project].Department (
	[deptNo]        INT PRIMARY KEY,
    [details2] 	    REAL DEFAULT 0,
    CONSTRAINT      [NON_NEG_deptNo_Department] CHECK(deptNo > 0)
)
-- Create B+ Tree Index on deptNo of the Department table
CREATE INDEX [IDX_Department_ON_deptNo] ON [Project].Department(deptNo);


-- Create the Table for Processes -------------------------------------------
CREATE TABLE [Project].Process (
	[id] 	        INT PRIMARY KEY,
	[deptNo]        INT FOREIGN KEY REFERENCES [Project].Department,
    [details3] 	    REAL DEFAULT 0,
    CONSTRAINT      [NON_NEG_id_Process] CHECK(id > 0)
)


-- Create the Relation Table between the Process and Assemblies tables ------
CREATE TABLE [Project].Manufactures (
	[assembliesID] 	INT NOT NULL FOREIGN KEY REFERENCES [Project].Assemblies,
    [processID] 	INT NOT NULL FOREIGN KEY REFERENCES [Project].Process
)
--Create B+ Tree Index on deptNo of the Manufactures table 
CREATE INDEX [IDX_Manufactures_ON_assembliesID] ON [Project].Manufactures(assembliesID);


-- Create the Table for Jobs ------------------------------------------------
CREATE TABLE [Project].Job (
	[jobNo] 	    INT PRIMARY KEY,
    [startDate]     DATE NOT NULL,
    [endDate] 	    DATE DEFAULT NULL,
    [otherInfo]     VARCHAR(255) DEFAULT NULL,
	[assembliesID] 	INT NOT NULL FOREIGN KEY REFERENCES [Project].Assemblies,
    [processID] 	INT NOT NULL FOREIGN KEY REFERENCES [Project].Process,
    [deptNo]        INT NOT NULL FOREIGN KEY REFERENCES [Project].Department,
    CONSTRAINT      [NON_NEG_JobNo_Job] CHECK(JobNo > 0),
    CONSTRAINT      [POS_VAR_DATES_Job] CHECK(endDate >= startDate)
)
-- Create B+ Tree Index on id of Job table
CREATE INDEX [IDX_Job_ON_JobNo] ON [Project].Job(JobNo);


-- Create the Fit Table for Jobs --------------------------------------------
CREATE TABLE [Project].J_Fit (
	[jobNo] 	    INT FOREIGN KEY REFERENCES [Project].Job,
    [timeOfLabor] 	INT DEFAULT 0,
    CONSTRAINT      [NON_NEG_id_J_Fit] CHECK(jobNo > 0),
    CONSTRAINT      [NON_NEG_timeOfLabor_J_Fit] CHECK([timeOfLabor] >= 0)
)
-- Create non-clustered index in place of ideal static hash table
CREATE NONCLUSTERED INDEX [IDX_J_Fit_ON_id] ON [Project].J_Fit(jobNo);


-- Create the Paint Table for Jobs ------------------------------------------
CREATE TABLE [Project].J_Paint (
	[jobNo] 	    INT FOREIGN KEY REFERENCES [Project].Job,
    [color] 	    VARCHAR(255) DEFAULT NULL,
    [volume] 	    REAL DEFAULT 0 NOT NULL,
    [timeOfLabor] 	INT DEFAULT 0 NOT NULL,
    CONSTRAINT      [NON_NEG_id_J_Paint] CHECK(jobNo > 0),
    CONSTRAINT      [NON_NEG_timeOfLabor_J_Paint] CHECK([timeOfLabor] >= 0)
)
-- Create non-clustered index in place of dunamic hash table on id
CREATE NONCLUSTERED INDEX [IDX_J_Paint_ON_id] ON [Project].J_Paint(jobNo);

-- Create B+ tree index for color 
CREATE INDEX [IDX_J_Paint_ON_color] ON [Project].J_Paint(color);

-- Create the Cut Table for Jobs --------------------------------------------
CREATE TABLE [Project].J_Cut (
	[jobNo] 	    INT FOREIGN KEY REFERENCES [Project].Job,
    [material] 	    VARCHAR(255) DEFAULT NULL,
    [timeOfLabor] 	INT DEFAULT 0 NOT NULL,
    [type] 	        VARCHAR(255) DEFAULT NULL,
    [amount] 	    REAL DEFAULT 0 NOT NULL,
    CONSTRAINT      [NON_NEG_id_J_Cut]          CHECK(jobNo > 0),
    CONSTRAINT      [NON_NEG_timeOfLabor_J_Cut] CHECK([timeOfLabor] >= 0)
)
-- Create non-clustered index in place of ideal static hash table
CREATE NONCLUSTERED INDEX [IDX_J_Cut_ON_id] ON [Project].J_Cut(jobNo);

-- Create the Table for Transactions -----------------------------------------
CREATE TABLE [Project].[Transaction] (
	[transactionNo] INT PRIMARY KEY,
    [cost] 	        REAL DEFAULT 0 NOT NULL,
    CONSTRAINT      [NON_NEG_transactionNo_Transaction] CHECK(transactionNo > 0),
    CONSTRAINT      [NON_NEG_cost_Transaction]          CHECK(cost >= 0)
)
-- Create non-clustered index in place of ideal dynamic hash table
CREATE NONCLUSTERED INDEX [IDX_Transaction_ON_transactionNo] ON [Project].[Transaction](transactionNo);


-- Create the Relation Table for the Job and Transactions tables -------------
CREATE TABLE [Project].Records (
	[jobNo] 	    INT NOT NULL FOREIGN KEY REFERENCES [Project].Job,
    [transactionNo] INT NOT NULL FOREIGN KEY REFERENCES [Project].[Transaction]
)
-- Create non-clustered index in place of ideal dynamic hash table
CREATE NONCLUSTERED INDEX [IDX_Records_ON_jobNo] ON [Project].Records(jobNo);


-- Create the Table for Accounts ---------------------------------------------
CREATE TABLE [Project].Account (
	[acctNo] 	        INT PRIMARY KEY,
    [dateEstablished] 	DATE NOT NULL,
	[assembliesID] 	    INT NOT NULL FOREIGN KEY REFERENCES [Project].Assemblies,
    [processID] 	    INT NOT NULL FOREIGN KEY REFERENCES [Project].Process,
    [deptNo] 	        INT NOT NULL FOREIGN KEY REFERENCES [Project].Department,
    CONSTRAINT          [NON_NEG_acctNo_Account] CHECK(acctNo > 0)
)
-- Create B+ Tree Index on id of Accounts table
CREATE INDEX [IDX_Account_ON_acctNo] ON [Project].Account(acctNo);
