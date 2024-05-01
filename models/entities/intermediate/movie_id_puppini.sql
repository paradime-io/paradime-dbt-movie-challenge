WITH base AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['IMDB_ID', 'TMDB_ID']) }} AS MOVIE_ID
        , stg_omdb_movies.IMDB_ID
        , stg_tmdb_movies.TMDB_ID
    FROM {{ ref('stg_omdb_movies') }}
    FULL OUTER JOIN {{ ref('stg_tmdb_movies') }}
        USING(IMDB_ID, TMDB_ID)
)
SELECT 
    IMDB_ID
    , NULL AS TMDB_ID
    , MOVIE_ID
FROM base
WHERE IMDB_ID IS NOT NULL

UNION ALL

SELECT
    NULL AS IMDB_ID
    , TMDB_ID
    , MOVIE_ID
FROM base
WHERE TMDB_ID IS NOT NULL



