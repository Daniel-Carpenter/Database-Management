-- Daniel Carpenter
-- 113009743

USE [cs-dsa-4513-sql-db];

-- Drop tables since this is a repeated excercise for database design 
DROP TABLE IF EXISTS [Acted];
DROP TABLE IF EXISTS [Movie];
DROP TABLE IF EXISTS [Director];
DROP TABLE IF EXISTS [Performer];

-- CREATE TABLES ==================================================

    -- Performer table --------------------------------------------
    CREATE TABLE [Performer] (
        pid                 INT PRIMARY KEY,
        pname               VARCHAR(64) NOT NULL,
        years_of_experience INT NOT NULL,
        age                 INT NOT NULL
    )

    -- Director Table ---------------------------------------------
    CREATE TABLE [Director] (
        did      INT PRIMARY KEY,
        dname    VARCHAR(64) NOT NULL,
        earnings REAL NOT NULL
    )

    -- Movie Table ------------------------------------------------
    CREATE TABLE [Movie] (
        [mname]         VARCHAR(64) PRIMARY KEY,
        [genre]         VARCHAR(64) NOT NULL,
        [minutes]       INT NOT NULL,
        [release_year]  INT NOT NULL,
        [did]           INT FOREIGN KEY REFERENCES [Director]
    )

    -- Movie Table ------------------------------------------------
    CREATE TABLE [Acted] (
        pid     INT         FOREIGN KEY REFERENCES [Performer],
        mname   VARCHAR(64) FOREIGN KEY REFERENCES [Movie]
    )

-- ADD DATA TO TABLES =============================================

    -- Performer table --------------------------------------------
    INSERT INTO Performer
        (pid, pname, years_of_experience, age)
    VALUES
        (1, 'Morgan',48, 67),
        (2, 'Cruz',  14, 28),
        (3, 'Adams', 1,  16),
        (4, 'Perry', 18, 32),
        (5, 'Hanks', 36, 55),
        (6, 'Hanks', 15, 24),
        (7, 'Lewis', 13, 32)

    -- Director table --------------------------------------------
    INSERT INTO Director
        (did, dname, earnings)
    VALUES
        (1, 'Parker', 580000),
        (2, 'Black',  2500000),
        (3, 'Black',  30000),
        (4, 'Stone',  820000)

    -- Movie table -----------------------------------------------
    INSERT INTO Movie
        ([mname], [genre], [minutes], [release_year], [did])
    VALUES
        ('Jurassic Park',        'Action',      125, 1984, 2),
        ('Shawshank Redemption', 'Drama',       105, 2001, 2),
        ('Fight Club',           'Drama',       144, 2015, 2),
        ('The Departed',         'Drama',       130, 1969, 3),
        ('Back to the Future',   'Comedy',      89,  2008, 3),
        ('The Lion King',        'Animation',   97,  1990, 1),
        ('Alien',                'Sci-Fi',      115, 2006, 3),
        ('Toy Story',            'Animation',   104, 1978, 1),
        ('Scarface',             'Drama',       124, 2003, 1),
        ('Up',                   'Animation',   111, 1999, 4)

    -- Acted table -----------------------------------------------
    INSERT INTO Acted
        (pid, mname)
    VALUES
        (4, 'Fight Club'),
        (5, 'Fight Club'),
        (6, 'Shawshank Redemption'),
        (4, 'Up'),
        (5, 'Shawshank Redemption'),
        (1, 'The Departed'),
        (2, 'Fight Club'),
        (3, 'Fight Club'),
        (4, 'Alien')