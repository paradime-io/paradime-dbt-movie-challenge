WITH movies_data_with_financials AS (
     SELECT
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        IMDB_VOTES,
        IMDB_RATING,
        WINS,
        NOMINATIONS,
        BUDGET,
        REVENUE,
        ROI
    FROM 
        {{ ref('movie_critical_acclaim_and_financials') }}
)
,

movie_genres AS (
    SELECT
        MOVIE_ID,
        MAIN_GENRE
    FROM
        {{ ref('stg_movie_genres') }}
)    
,

movie_acclaim_financials_genre AS (
    SELECT 
        IMDB_ID,
        TITLE,
        MAIN_GENRE AS GENRE,
        DIRECTOR,
        WRITER,
        IMDB_VOTES,
        IMDB_RATING,
        WINS,
        NOMINATIONS,
        BUDGET,
        REVENUE,
        ROI
    FROM 
        movies_data_with_financials
    LEFT JOIN
        movie_genres
    ON 
        IMDB_ID = MOVIE_ID
)

SELECT 
    *
FROM
    movie_acclaim_financials_genre