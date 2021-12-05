USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin WITH, it is beneficial to know the shape of the tables AND whether any column hAS null values.
 Further in this segment, you will take a look at 'movies' AND 'genre' tables.*/



-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT
	COUNT(*) FROM director_mapping;

SELECT
	COUNT(*) FROM genre;

SELECT
	COUNT(*) FROM movie;

SELECT
	COUNT(*) FROM names;

SELECT
	COUNT(*) FROM ratings;

SELECT
	COUNT(*) FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	SUM(CASE 
		WHEN m.id IS NULL THEN 1 ELSE 0 END) AS Null_Id,
	SUM(CASE 
		WHEN m.title IS NULL THEN 1 ELSE 0 END) AS Null_Title,
	SUM(CASE 
		WHEN m.year IS NULL THEN 1 ELSE 0 END) AS Null_Year,
	SUM(CASE 
		WHEN m.date_published IS NULL THEN 1 ELSE 0 END) AS Null_Date_Published,
	SUM(CASE 
		WHEN m.duration IS NULL THEN 1 ELSE 0 END) AS Null_Duration,
	SUM(CASE 
		WHEN m.country IS NULL THEN 1 ELSE 0 END) AS Null_country,
	SUM(CASE 
		WHEN m.worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS Null_Worlwide_gross_income,
	SUM(CASE 
		WHEN m.languages IS NULL THEN 1 ELSE 0 END)  AS Null_Languages,
	SUM(CASE 
		WHEN m.production_company IS NULL THEN 1 ELSE 0 END)  AS Null_Production_Company
FROM movie AS m;

-- Now AS you can see four columns of the movie table hAS null values. Let's look at the at the movies releASed each year. 
-- Q3. Find the total number of movies releASed each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1- Checking Movies Yearby

SELECT 
	year, 
	COUNT(id) AS Number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- 2- Checking Movies monthwise
SELECT
	month(date_published) AS Month_number,
	COUNT(id) AS Number_of_movies
FROM movie
GROUP BY Month_number
ORDER BY Month_number;

-- So FROM the output for the above queries we can conclude that the year 2017 hAS produced highest number of movies
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA AND India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the lASt year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	COUNT(*) FROM movie
WHERE
	year=2019 AND
	(country like '%INDIA%' or country like '%USA%');


/* USA AND India produced more than a thousAND movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the datASet.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT
	DISTINCT genre 
FROM
	genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the lASt year?
Combining both the movie AND genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced OVERall?
-- Type your code below:

SELECT
	genre,
	COUNT(m.id) AS movie_COUNT
FROM
	movie m
	JOIN genre g
	on g.movie_id= m.id	
GROUP BY genre
ORDER BY movie_COUNT DESC;


/* So, bASed on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the COUNT of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Movie_with1genre AS 
(
SELECT 
	movie_id,
	COUNT(genre)
FROM 
	genre
GROUP BY movie_id
having COUNT(movie_id)=1
)
SELECT 
	COUNT(*) 
FROM 
	Movie_with1genre;

/* There are more than three thousAND movies which hAS only one genre ASsociated WITH them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	AVG_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre,
	ROUND(AVG(duration),2) AS Average_duration
FROM
	movie m
	JOIN genre g
	on g.movie_id= m.id
GROUP BY genre
ORDER BY Average_duration DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) hAS the average duration of 106.77 MINs.
Lets find WHERE the movies of genre 'thriller' on the bASis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_COUNT	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
	genre, 
	COUNT(movie_id),
	DENSE_RANK() OVER(
			ORDER BY COUNT(movie_id)DESC) AS genre_rank
FROM genre
GROUP BY genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies AND genres tables. 
 In this segment, you will analyse the ratings table AS well.
To start WITH lets get the MIN AND MAX values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the MINimum AND MAXimum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| MIN_AVG_rating|	MAX_AVG_rating	|	MIN_total_votes   |	MAX_total_votes 	 |MIN_median_rating|MAX_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	MIN(AVG_rating) AS MIN_AVG_rating , 
	MAX(AVG_rating) AS MAX_AVG_rating , 
	MIN(total_votes) AS total_votesMIN_total_votes , 
	MAX(total_votes) AS MAX_total_votes , 
	MIN(median_rating) AS MIN_median_rating , 
	MAX(median_rating) AS MAX_median_rating
FROM ratings;
    
/* So, the MINimum AND MAXimum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies bASed on average rating.*/

-- Q11. Which are the top 10 movies bASed on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		AVG_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT
	m.title,
	AVG_rating,
	rank() OVER(ORDER BY AVG_rating DESC) AS movie_rank
FROM 
	ratings r
	INNER JOIN movie m
	on m.id=r.movie_id
LIMIT 10;

/* Do you find you favourite movie FAN in the top 10 movies WITH an average rating of 9.6? If not, pleASe check your code again!!
So, now that you know the top 10 movies, do you think character actors AND filler actors can be FROM these movies?
SUMmarising the ratings table bASed on the movie COUNTs by median rating can give an excellent insight.*/

-- Q12. SUMmarise the ratings table bASed on the movie COUNTs by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_COUNT		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- ORDER BY is good to have

SELECT 
	median_rating,
    COUNT(movie_id) AS movie_COUNT
FROM ratings
GROUP BY median_rating
ORDER BY median_rating ASC;

/* Movies WITH a median rating of 7 is highest in number. 
Now, let's find out the production house WITH which RSVP Movies can partner for its next project.*/

-- Q13. Which production house hAS produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_COUNT	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company, 
	COUNT(id) AS movie_COUNT, 
	DENSE_RANK() OVER( ORDER BY COUNT(id) )AS prod_company_rank
FROM
	movie m
	INNER JOIN ratings r
	on m.id=r.movie_id
WHERE 
	  AVG_rating>8 AND
	  production_company is NOT NULL
GROUP BY production_company
ORDER  BY movie_COUNT DESC;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies releASed in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_COUNT		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	genre,
    COUNT(id) AS movie_COUNT
FROM movie m
	 INNER JOIN genre g
		on m.id=g.movie_id
	INNER JOIN ratings r
		on g.movie_id = r.movie_id
WHERE year = 2017 AND
	  total_votes>1000 AND
      country="USA" AND
      month(date_published)=3
GROUP BY genre
ORDER BY movie_COUNT DESC;
      

-- Lets try to analyse WITH a unique problem statement.
-- Q15. Find movies of each genre that start WITH the word ‘The’ AND which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		AVG_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	title,
    AVG_rating,
    genre
FROM movie m
	 INNER JOIN genre g
		on m.id=g.movie_id
	 INNER JOIN ratings r
		on g.movie_id = r.movie_id
WHERE 
	  title like "The%" AND
	  AVG_rating>8
ORDER BY AVG_rating DESC,
		 genre,
		 title;

-- You should also try your hAND at median rating AND check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies releASed BETWEEN 1 April 2018 AND 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
	COUNT(id)
FROM movie m
	 INNER JOIN ratings r
	 on m.id=r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating
having median_rating=8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German AND Italian movies.
-- Type your code below:


SELECT COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	   COUNT(CASE WHEN LOWER(m.languages) LIKE '%Italian%' THEN m.id END) AS italian_movie_count
FROM movie m
	 INNER JOIN ratings r
		ON m.id = r.movie_id; 

-- Answer is Yes

/* Now that you have analysed the movies, genres AND ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	   SUM(CASE
				WHEN NAME IS NULL THEN 1 ELSE 0 END) AS name_nulls,
       SUM(CASE 
				WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
       SUM(CASE 
				WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
       SUM(CASE 
				WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies WITH an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_COUNT		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3_genre AS 
(
SELECT 
	genre,
    COUNT(g.movie_id) AS COUNTm
FROM genre g
	 JOIN  ratings r
		ON r.movie_id = g.movie_id
WHERE AVG_rating > 8
GROUP BY genre
ORDER BY COUNTm DESC LIMIT 3
)
SELECT 
	NAME AS director_name,
    COUNT(DISTINCT dm.movie_id) AS movie_COUNT
FROM director_mapping dm
	 JOIN names n
		ON n.id = dm.name_id
	 JOIN ratings r
		ON r.movie_id = dm.movie_id
	 JOIN genre g
		ON g.movie_id = dm.movie_id
WHERE r.AVG_rating > 8 AND
	  genre IN (SELECT genre FROM top3_genre)
GROUP BY dm.name_id
ORDER BY movie_COUNT DESC 
LIMIT 3; 

/* James Mangold can be hired AS the director for RSVP's next project. Do you remeber his movies, 'Logan' AND 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_COUNT		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT NAME AS actor_name,
	   COUNT(rm.movie_id) AS movie_COUNT
FROM names n
	 INNER JOIN role_mapping rm
		ON n.id = rm.name_id
	 INNER JOIN ratings r
		ON rm.movie_id = r.movie_id
WHERE  median_rating >= 8
GROUP  BY actor_name
ORDER BY movie_COUNT DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, pleASe check your code again. 
RSVP Movies plans to partner WITH other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses bASed on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_COUNT			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	   production_company,
	   SUM(total_votes) AS vote_COUNT, 
	   DENSE_RANK() OVER(
				ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
	INNER JOIN ratings r 
		on m.id=r.movie_id
WHERE production_company IS NOT NULL
GROUP BY production_company
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses bASed on the number of votes received by the movies they have produced.

Since RSVP Movies is bASed out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoMINg project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors WITH movies releASed in India bASed on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at leASt five Indian movies. 
-- (Hint: You should use the weighted average bASed on votes. If the ratings clASh, then the total number of votes should act AS the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_COUNT		  |	actor_AVG_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actor AS 
(
SELECT NAME AS actor_nameS, 
	   SUM(total_votes) AS total_votes,
	   COUNT(rm.movie_id) AS movie_COUNT, 
       ROUND(SUM(AVG_rating * total_votes) / SUM(total_votes),2) AS actor_AVG_rating,
	   DENSE_RANK() OVER (
					ORDER BY SUM(AVG_rating * total_votes)/SUM(total_votes) DESC )AS actor_rank
    FROM  names n 
		JOIN role_mapping AS rm 
			ON n.id = rm.name_id
		JOIN ratings AS r 
			ON rm.movie_id = r.movie_id 
		JOIN movie AS m 
			ON m.id = r.movie_id
    WHERE category = 'actor' AND
		  country LIKE '%India%'
	GROUP BY NAME
	HAVING movie_COUNT >= 5
    )
	SELECT *
    FROM top_actor
	ORDER BY actor_AVG_rating DESC,
			 total_votes DESC; 


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies releASed in India bASed on their average ratings? 
-- Note: The actresses should have acted in at leASt three Indian movies. 
-- (Hint: You should use the weighted average bASed on votes. If the ratings clASh, then the total number of votes should act AS the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_COUNT		  |	actress_AVG_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress AS 
(
SELECT NAME AS actress_names, 
	   SUM(total_votes) AS total_votes,
	   COUNT(rm.movie_id) AS movie_COUNT, 
	   ROUND(SUM(AVG_rating * total_votes) / SUM(total_votes),2) AS actress_AVG_rating,
	   DENSE_RANK() OVER (
					ORDER BY SUM(AVG_rating * total_votes)/SUM(total_votes) DESC )AS actress_rank 
FROM  names n 
	JOIN role_mapping AS rm 
		ON n.id = rm.name_id
    JOIN ratings AS r 
		ON rm.movie_id = r.movie_id 
    JOIN movie AS m 
		ON m.id = r.movie_id
WHERE category = 'actress' AND
		  country LIKE '%India%'
GROUP BY NAME
HAVING movie_COUNT >= 5)
SELECT * 
FROM top_actress
ORDER BY actress_AVG_rating DESC,
total_votes DESC; 

/* Taapsee Pannu tops WITH average rating 7.74. 
Now let us divide all the thriller movies in the following categories AND find out their numbers.*/


/* Q24. SELECT thriller movies AS per AVG rating AND clASsify them in the following category: 

			Rating > 8: Superhit movies
			Rating BETWEEN 7 AND 8: Hit movies
			Rating BETWEEN 5 AND 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
	   AVG_rating,
	   CASE WHEN
				AVG_rating > 8 THEN 'Superhit movies'
			WHEN
				AVG_rating BETWEEN 7 AND 8 THEN 'Hit movies'
			WHEN
				AVG_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			ELSE
				'Flop movies' END AS category
FROM movie m
	INNER JOIN ratings r
		ON m.id=r.movie_id 
	INNER JOIN genre g
		ON r.movie_id= g.movie_id
WHERE genre="Thriller"
ORDER BY AVG_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tASks that will give you a broader understANDing of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total AND moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	AVG_duration	|running_total_duration|moving_AVG_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH Genre_SUMMARY AS 
(
SELECT genre,
	   ROUND(AVG(duration),2) AS AVG_duration
FROM genre g
	 JOIN movie m
		ON g.movie_id=m.id
GROUP BY genre
)
SELECT *,
	   SUM(AVG_duration) OVER( ORDER BY GENRE ROWS unbounded preceding) AS running_total_duration,
	   ROUND(AVG(AVG_duration) OVER( ORDER BY GENRE ROWS unbounded preceding),2) AS moving_AVG_duration
FROM Genre_SUMMARY;

-- ROUND is good to have AND not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year WITH top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres bASed on most number of movies
WITH Top5_Genre AS 
(
SELECT genre
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 3
),
Top5_Movie AS
( 
SELECT genre,
		 year, 
         title AS movie_name, 
         worlwide_gross_income,
         DENSE_RANK() OVER( partition by year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM genre g
     JOIN movie m
		ON g.movie_id = m.id
    WHERE genre in(SELECT * FROM Top5_Genre)
)
SELECT * FROM Top5_Movie
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_COUNT		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_COUNT,
       DENSE_RANK() OVER(
				ORDER BY COUNT(id) DESC)AS prod_comp_rank
FROM movie m
	 INNER JOIN ratings r
		ON m.id=r.movie_id
WHERE production_company is NOT NULL AND
	  median_rating>8 AND 
      POSITION(',' IN languages) > 0
GROUP BY production_company 
LIMIT 2;
    

-- Multilingual is the important piece in the above question. It wAS created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses bASed on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_COUNT		  |actress_AVG_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT  name AS actress_name,
		SUM(total_votes) AS total_votes,
		COUNT(g.movie_id) AS movie_COUNT,
		ROUND(AVG(AVG_rating),2) AS actress_AVG_rating,	 
        DENSE_RANK() OVER( ORDER BY COUNT(r.movie_id)DESC) AS actress_rank
FROM names AS n
	 INNER JOIN role_mapping AS r
		ON n.id = r.name_id
	 INNER JOIN ratings AS rat
		ON r.movie_id = rat.movie_id
	 INNER JOIN genre AS g
		ON r.movie_id = g.movie_id
WHERE
	AVG_rating > 8 AND
    genre = 'Drama'AND
    category = 'actress'
GROUP BY name
LIMIT 3;

/* Q29. Get the following details for top 9 directors (bASed on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
MIN rating
MAX rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	AVG_inter_movie_days |	AVG_rating	| total_votes  | MIN_rating	| MAX_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_directors AS
(
SELECT name_id AS director_id,
	   NAME    AS director_name,
       dm.movie_id, 
       duration, 
       AVG_rating, 
	   total_votes,
       AVG_rating * total_votes AS rating_COUNT,
       date_published,
       Lead(date_published, 1) OVER (partition BY NAME ORDER BY date_published, NAME) AS next_date_published
FROM director_mapping dm
	JOIN names n    
		ON n.id = dm.name_id
	JOIN movie m    
		ON m.id = dm.movie_id
    JOIN ratings r  
		ON r.movie_id = m.id 
)
SELECT director_id,
	   director_name,
	   COUNT(movie_id)  AS number_of_movies,
       ROUND(SUM(rating_COUNT) /SUM(total_votes),2)  AS AVG_rating,
       ROUND(SUM(Datediff(next_date_published, date_published))/(COUNT(movie_id)-1)) AS AVG_inter_movie_days,
       SUM(total_votes) AS total_votes,
	   MIN(AVG_rating) AS MIN_rating,
	   MAX(AVG_rating) AS MAX_rating,
       SUM(duration) AS total_duration
FROM     top_directors
GROUP BY director_id
ORDER BY number_of_movies DESC LIMIT 9;


-- -- 