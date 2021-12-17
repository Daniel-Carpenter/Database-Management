DROP TABLE IF EXISTS movie_night; --Drop the table if it was previously created

--Create the new table for movie_nights schedule
CREATE TABLE movie_night (
      start_time DATETIME PRIMARY KEY,
      movie_name VARCHAR(64),
      duration_min INT,
      guest_1 VARCHAR(64),
      guest_2 VARCHAR(64),
      guest_3 VARCHAR(64),
      guest_4 VARCHAR(64),
      guest_5 VARCHAR(64),
);

--Insert two records to begin with
INSERT INTO movie_night
 (start_time, movie_name, duration_min, guest_1, guest_2)
VALUES
 ('2019-12-31 20:00:00', 'Home Alone', 150, 'Taras', 'Jared'),
 ('2020-01-03 19:00:00', 'Diehard', 180, 'Taras', 'Aaron');
