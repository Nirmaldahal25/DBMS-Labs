ALTER TABLE actors ADD PRIMARY KEY (id);
ALTER TABLE directors ADD PRIMARY KEY (id);
ALTER TABLE movies ADD PRIMARY KEY (id);


ALTER TABLE movies_genres ADD FOREIGN KEY (movie_id) REFERENCES movies(id);
ALTER TABLE directors_genres ADD FOREIGN KEY (director_id) REFERENCES directors(id);

ALTER TABLE movies_directors ADD FOREIGN KEY (movie_id) REFERENCES movies(id);
ALTER TABLE movies_directors ADD FOREIGN KEY (director_id) REFERENCES directors(id);

ALTER TABLE roles ADD FOREIGN KEY (actor_id) REFERENCES actors(id);
ALTER TABLE roles ADD FOREIGN KEY (movie_id) REFERENCES movies(id);

ALTER TABLE actors DROP film_count;


SELECT 
(SELECT COUNT(*) FROM actors) as numactors,
(SELECT COUNT(*) FROM directors) AS numdirectors,
(SELECT COUNT(*) FROM movies) AS nummovies,
(SELECT COUNT(*) FROM (SELECT genre FROM directors_genres UNION SELECT genre FROM movies_genres) AS genre) AS numgenres;


SELECT CONCAT_WS(' ',first_name, last_name) AS fullname, role FROM (SELECT * FROM roles JOIN actors ON actors.id = roles.actor_id AND movie_id IN (SELECT id FROM movies WHERE name='titanic')) AS T;

SELECT genre, COUNT(movie_id) AS noofmovies FROM movies_genres GROUP BY genre; 

SELECT AVG(moviecount) AS MovieCount FROM (SELECT COUNT(DISTINCT movie_id) AS moviecount, actor_id FROM roles GROUP BY actor_id) AS t1;

SELECT AVG(actorcount) AS ActorCount FROM (SELECT COUNT(DISTINCT actor_id) AS actorcount, movie_id FROM roles GROUP BY movie_id) AS t1;

SELECT name, `rank` from movies WHERE `rank`  IS NOT NULL ORDER BY `rank` DESC LIMIT 5;

SELECT CONCAT_WS(' ', first_name, last_name) as Name FROM directors WHERE id IN (SELECT director_id FROM (SELECT director_id, COUNT(movie_id) AS nummovie FROM movies_directors GROUP BY director_id HAVING nummovie >= 2) AS T1);

SELECT name FROM movies WHERE id IN (SELECT DISTINCT movie_id FROM roles WHERE actor_id IN (SELECT id FROM actors WHERE CONCAT_WS(' ',first_name, last_name) = 'Kevin Bacon'));

SELECT * FROM movies HAVING `year` BETWEEN 1990 AND 2000 ORDER BY `year`; 