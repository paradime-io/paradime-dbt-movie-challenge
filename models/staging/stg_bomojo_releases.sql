WITH source AS (
    SELECT 
        *
    FROM
        {{ source('MOVIE_EXPANDED', 'BOMOJO_RELEASES') }}
)

, filtered AS (
    SELECT 
        IMDB_ID
        , RELEASE_GROUP
        , ROLLOUT
        , MARKETS
        , DOMESTIC AS DOMESTIC_GROSS
        , INTERNATIONAL AS INTERNATIONAL_GROSS
        , WORLDWIDE AS WORLDWIDE_GROSS
    FROM 
        source
    WHERE 
        NOT(DOMESTIC = 0 AND INTERNATIONAL = 0 AND WORLDWIDE = 0)

)

SELECT
    *
FROM
    filtered