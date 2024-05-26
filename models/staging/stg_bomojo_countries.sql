WITH source AS (
    SELECT 
        *
    FROM
        {{ source('MOVIE_EXPANDED', 'BOMOJO_COUNTRIES') }}
)

SELECT
    *
FROM
    source