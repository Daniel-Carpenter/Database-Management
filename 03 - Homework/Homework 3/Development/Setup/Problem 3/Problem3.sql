
-- Problem 3


-- Drop table for dev purposes
DROP TABLE IF EXISTS [ComputerRepairSpecialists];

-- Create the table with constraints
CREATE TABLE [ComputerRepairSpecialists] (
    [name]          VARCHAR(64) PRIMARY KEY, 
    certificateNo   INT NOT NULL, 
    city            VARCHAR(64) NOT NULL, 
    price_per_hour  REAL NOT NULL
)

-- CREATE INDEX nameIndex ON ComputerRepairSpecialists([name])
-- CREATE INDEX nameIndex2 ON ComputerRepairSpecialists([name], price_per_hour)
CREATE INDEX nameIndex3 ON ComputerRepairSpecialists(certificateNo)


-- Insert the records in the table
INSERT INTO [ComputerRepairSpecialists] 
    ([name], certificateNo, city, price_per_hour)
VALUES 
    ('Johnson', 11, 'Yukon',  20), 
    ('Black',   33, 'OKC',    20), 
    ('Grant',   22, 'Norman', 15), 
    ('White',   77, 'OKC',    20), 
    ('Chapman', 44, 'Edmond', 20), 
    ('Ford',    66, 'Enid',   25), 
    ('Haas',    99, 'OKC',    20), 
    ('Hougen',  88, 'Yukon',  25),
    ('Clinton', 55, 'Tulsa',  25)


SELECT * FROM ComputerRepairSpecialists