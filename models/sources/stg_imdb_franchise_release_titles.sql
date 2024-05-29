WITH source AS (
    SELECT 
        RELEASE_ID,
        TITLE_ID
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_FRANCHISE_RELEASE_TITLE') }}
)

SELECT 
    * 
FROM 
    source