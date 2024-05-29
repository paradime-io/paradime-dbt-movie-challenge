WITH source AS (
    SELECT 
        TITLEID as imdb_id,
        ordering,
        TITLE,
        REGION,
        LANGUAGE,
        TYPES,
        ATTRIBUTED,
        ISORIGINALTITLE as is_original_title
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_TITLE_AKAS') }}
)

SELECT 
    * 
FROM 
    source