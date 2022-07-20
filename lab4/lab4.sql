-- Write some SQL queries to explore the tables.
SELECT column_name, data_type, character_maximum_length, column_default, is_nullable
FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'actors';

SELECT column_name, data_type, character_maximum_length, column_default, is_nullable
FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'u2base';

SELECT * FROM u2base LIMIT 10;
SELECT COUNT(*) FROM actors; 



-- Create a view for the following
-- average rating of all movies
-- number of actors in each movie
-- number of ratings for each movie
DROP VIEW IF EXISTS movieanduser;
DROP VIEW IF EXISTS userratings;
CREATE VIEW movieanduser AS
WITH data1 AS(SELECT movieid, AVG(CAST(rating AS INTEGER)) AS avg_rating FROM u2base GROUP BY movieid),
data2 AS
(SELECT movieid, COUNT(DISTINCT actorid) as numberofactors FROM movies2actors GROUP BY movieid),
data3 AS
(SELECT movieid, COUNT(rating) as numberofratingspermovie FROM u2base GROUP BY movieid)
SELECT movieid, avg_rating, numberofactors, numberofratingspermovie FROM 
data1 NATURAL JOIN data2 NATURAL JOIN data3;

SELECT * FROM movieanduser LIMIT 10;


-- number of ratings by each user
CREATE VIEW userratings AS SELECT userid, COUNT(rating) FROM u2base GROUP BY userid;
SELECT * FROM userratings;





-- Find the number of users who have rated at least one movie.
SELECT COUNT(DISTINCT userid) AS userrated1ormore FROM u2base;
--6039

-- Find the number of unrated movies.
SELECT COUNT(movieid) FROM movies WHERE movieid NOT IN (SELECT DISTINCT movieid FROM u2base); 
--171

-- Find top 10 highest rated movies and the actors who played in those movies.
SELECT movieid, actorid, movierating FROM (
(SELECT movieid, AVG(CAST(rating AS INTEGER)) as movierating FROM u2base GROUP BY movieid ORDER BY movierating DESC LIMIT 10) AS data1
NATURAL JOIN movies2actors);

--(movieid, actorid, movierating)
--(2325949, 116060, 5.0)
--(2325949, 450640, 5.0)
-- "         "       "
