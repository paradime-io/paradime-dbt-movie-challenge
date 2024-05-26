WITH flattened_directors AS (
    SELECT
        imdb_id
        , trim(value) AS name
        , 'Director' AS role
    FROM 
        {{ ref('stg_omdb_movies') }},
            lateral flatten(input => split(director, ','))
)

, flattened_writers AS (
    SELECT 
        imdb_id
        , trim(value) AS name
        , 'Writer' AS role
    FROM
        {{ ref('stg_omdb_movies') }},
            lateral flatten(input => split(writer, ','))
)

, combined as (
    SELECT 
        * 
    FROM
        flattened_directors

    UNION ALL

    SELECT 
        * 
    FROM 
        flattened_writers
)

SELECT 
    imdb_id
    , name
    , role
FROM 
    combined