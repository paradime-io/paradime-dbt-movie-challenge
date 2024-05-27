WITH ActorSplit AS (
    SELECT 
        imdb_id,
       -- EXTRACT(YEAR FROM released_date) - EXTRACT(YEAR FROM released_date) % 10 AS decade,
        title,
        imdb_rating,
        TRIM(actor_value.VALUE::STRING) AS actor
    FROM {{ ref('stg_omdb_movies') }},
    LATERAL FLATTEN(INPUT => SPLIT(actors, ',')) AS actor_value
    WHERE released_date IS NOT NULL
        AND imdb_votes >= 10000
)

SELECT 
    --concat(gs.decade,'s') as decade,
    imdb_id,
    title,
    imdb_rating,
    actor
FROM ActorSplit
