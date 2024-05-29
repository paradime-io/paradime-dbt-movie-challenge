WITH source AS (
    SELECT 
        TCONST as imdb_id,
        DIRECTORS,
        writers
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_CREW') }}
)

SELECT 
    * 
FROM 
    source