DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
  actorid integer  NOT NULL,
  a_gender char NOT NULL,
  a_quality integer NOT NULL,
  PRIMARY KEY (actorid)
);

--
-- Table structure for table directors
--
DROP TABLE IF EXISTS directors;
CREATE TABLE directors (
  directorid integer  NOT NULL,
  d_quality integer NOT NULL,
  avg_revenue integer NOT NULL,
  PRIMARY KEY (directorid)
);

--
-- Table structure for table movies
--
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
  movieid integer  NOT NULL DEFAULT 0,
  year integer NOT NULL,
  isEnglish char NOT NULL,
  country varchar(50) NOT NULL,
  runningtime integer NOT NULL,
  PRIMARY KEY (movieid)
);

--
-- Table structure for table movies2actors
--
DROP TABLE IF EXISTS movies2actors;
CREATE TABLE movies2actors (
  movieid integer  NOT NULL,
  actorid integer  NOT NULL,
  cast_num integer NOT NULL,
  PRIMARY KEY (movieid,actorid),
  FOREIGN KEY (actorid) REFERENCES actors (actorid) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (movieid) REFERENCES movies (movieid) ON DELETE CASCADE ON UPDATE CASCADE
);
--
-- Table structure for table movies2directors
--
DROP TABLE IF EXISTS movies2directors;
CREATE TABLE movies2directors (
  movieid integer  NOT NULL,
  directorid integer  NOT NULL,
  genre varchar(15) NOT NULL,
  PRIMARY KEY (movieid,directorid),
  FOREIGN KEY (directorid) REFERENCES directors (directorid) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (movieid) REFERENCES movies (movieid) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table users
--
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  userid integer NOT NULL DEFAULT 0,
  age varchar(5) NOT NULL,
  u_gender varchar(5) NOT NULL,
  occupation varchar(45) NOT NULL,
  PRIMARY KEY (userid)
);

--
-- Table structure for table u2base
--
DROP TABLE IF EXISTS u2base;
CREATE TABLE u2base (
  userid integer NOT NULL DEFAULT 0,
  movieid integer  NOT NULL,
  rating varchar(45) NOT NULL,
  PRIMARY KEY (userid,movieid),
  FOREIGN KEY (movieid) REFERENCES movies (movieid) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (userid) REFERENCES users (userid) ON DELETE CASCADE ON UPDATE CASCADE
);

