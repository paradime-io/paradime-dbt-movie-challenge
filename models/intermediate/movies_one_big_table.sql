WITH tmdb AS (
    SELECT
        *
    FROM
        {{ ref('stg_tmdb_movies') }} 
), 

omdb AS (
    SELECT 
        *
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined AS (
    SELECT
        *
    FROM
        tmdb t
    LEFT JOIN
        omdb o 
    WHERE true 
        AND (o.imdb_id = t.imdb_id or (o.tmdb_id = t.tmdb_id and o.title = t.title))
)
SELECT
    *
FROM
    joined