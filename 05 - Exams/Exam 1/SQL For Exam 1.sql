--PROGRAMERS (ProgrammerID, LastName, FirstName, age, salary)--
--SOFTWARE (SoftwareName, SoftwareVersionID, ManagerName, CompletionDate)
--ASSIGNMENTS (SoftwareName, SoftwareVersionID, ProgrammerID, AssignmentDate)

CREATE TABLE PROGRAMERS (
    ProgrammerID    INT PRIMARY KEY, 
    LastName        VARCHAR(64) NOT NULL, 
    FirstName       VARCHAR(64) NOT NULL,   
    age             INT NOT NULL, 
    salary          REAL NOT NULL
)

CREATE TABLE SOFTWARE (
    SoftwareName        INT PRIMARY KEY, 
    SoftwareVersionID   INT NOT NULL, 
    ManagerName         VARCHAR(64) NOT NULL,
    CompletionDate      DATE NOT NULL
)

CREATE TABLE ASSIGNMENTS (
    SoftwareName        INT PRIMARY KEY, 
    SoftwareVersionID   INT NOT NULL,
    ProgrammerID        INT FOREIGN KEY REFERENCES PROGRAMERS,
    AssignmentDate      DATE NOT NULL
)

SELECT 
    SoftwareName
    COUNT(SoftwareVersionID) AS VersionCount
FROM SOFTWARE
GROUP BY SoftwareName

--C - Write an SQL statement that displays the IDs and names of all programmers 
-- assigned to the software package named “Azure SQL” 
-- managed by the manager named “Johnson”

SELECT 
    ProgrammerID,
    FirstName,
    LastName

WHERE 
        SoftwareName = 'Azure SQL' -- assumes the name is the package name
    AND ManagerName  = 'Johnson'

FROM 
    PROGRAMERS [prog]
    
    LEFT JOIN ASSIGNMENTS [assn]
        ON [prog].ProgrammerID = [assn].ProgrammerID

    LEFT JOIN SOFTWARE [soft]
        ON [assn].SoftwareName = [soft].SoftwareName