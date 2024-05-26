WITH source AS (
    SELECT 
        genre,
        vibe
    FROM 
        {{ source('ADDITIONAL_TABLES', 'GENRE_VIBES') }}
)

SELECT
    * 
FROM 
    source
