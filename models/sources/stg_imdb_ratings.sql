WITH source AS (
    SELECT 
        IMDB_ID,
        AVERAGE_RATING,
        NUMBER_OF_VOTES
    FROM 
        {{ source('ADDITIONAL_SOURCES', 'IMDB_RATINGS') }}
)

SELECT 
    * 
FROM 
    source
