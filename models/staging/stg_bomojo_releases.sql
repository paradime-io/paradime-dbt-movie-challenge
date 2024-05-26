WITH source AS (
    SELECT 
        *
    FROM
        {{ source('MOVIE_EXPANDED', 'BOMOJO_RELEASES') }}
)

, filtered AS (
    SELECT 
        imdb_id
        , release_group
        , rollout
        , markets
        , domestic AS domestic_gross
        , international AS international_gross
        , worldwide AS worldwide_gross
    FROM 
        source
    WHERE 
        NOT(domestic = 0 AND international = 0 AND worldwide = 0)
)

SELECT
    *
FROM
    filtered