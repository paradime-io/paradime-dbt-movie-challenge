/*
This model is used to create a table that contains the unique genre-movie allocations from both the OMDB and TMDB datasets.
If a movie is categorized as a Comedy in one and as a Horror in the other, this will result in two rows here.
*/

WITH CTE_UNION AS (
SELECT
  O.IMDB_ID,
  TRIM(G.VALUE) AS GENRE
FROM {{ ref('int_omdb_movies_proper') }} AS O,
LATERAL SPLIT_TO_TABLE(O.GENRE, ',') AS G

UNION 

SELECT 
  T.IMDB_ID, 
  TRIM(G.VALUE) AS GENRE
FROM {{ ref('int_tmdb_movies_proper') }} as T,
LATERAL SPLIT_TO_TABLE(T.GENRE, ',') AS G
)

SELECT
IMDB_ID,
GENRE,
COUNT(*) OVER (PARTITION BY IMDB_ID) AS NUMBER_OF_GENRES_THIS_MOVIE
FROM CTE_UNION
