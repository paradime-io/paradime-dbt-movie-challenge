WITH source AS (
    SELECT 
        RELEASE_ID,
        TITLE_ID
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_BRAND_RELEASE_TITLE') }}
)

SELECT 
    * 
FROM 
    source