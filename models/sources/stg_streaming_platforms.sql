WITH source AS (
    SELECT 
        TITLE,
        ROTTEN_TOMATOES,
        NETFLIX,
        HULU,
        PRIME_VIDEO,
        DISNEY_PLUS
    FROM 
        {{ source('EXTRA_DATASETS', 'STREAMING_PLATFORMS') }}
)

SELECT 
    * 
FROM 
    source