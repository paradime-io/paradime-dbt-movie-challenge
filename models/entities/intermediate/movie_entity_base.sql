WITH base AS (
    SELECT 
        movie_id_puppini.MOVIE_ID
        , MIN(stg_omdb_movies.IMDB_ID) AS IMDB_ID
        , MIN(stg_tmdb_movies.TMDB_ID) AS TMDB_ID
        , MIN(COALESCE(stg_omdb_movies.TITLE, stg_tmdb_movies.TITLE)) AS TITLE
        , MIN(COALESCE(stg_omdb_movies.PLOT, stg_tmdb_movies.OVERVIEW)) AS PLOT
        , MIN(COALESCE(stg_omdb_movies.RELEASED_DATE, stg_tmdb_movies.RELEASE_DATE)) AS RELEASE_DATE
        , MAX(COALESCE(stg_omdb_movies.RUNTIME, stg_tmdb_movies.RUNTIME)) AS RUNTIME
    FROM {{ ref('movie_id_puppini')}}
    LEFT JOIN {{ ref('stg_omdb_movies') }}
        ON movie_id_puppini.IMDB_ID = stg_omdb_movies.IMDB_ID
    LEFT JOIN  {{ ref('stg_tmdb_movies') }}
        ON movie_id_puppini.TMDB_ID = stg_tmdb_movies.TMDB_ID
    GROUP BY movie_id_puppini.MOVIE_ID
)
SELECT 
    MOVIE_ID
    , IMDB_ID
    , TMDB_ID
    , TITLE
    , PLOT
    , RELEASE_DATE
    , RUNTIME
FROM base
WHERE RUNTIME >= 40 -- Generally considered a movie is at least 40 minutes long
