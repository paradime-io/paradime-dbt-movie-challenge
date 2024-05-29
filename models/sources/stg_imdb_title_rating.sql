WITH source AS (
    SELECT 
        TCONST as imdb_id,
        AVERAGERATING as rating_avg,
        NUMVOTES as vote_total
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_TITLE_RATING') }}
)

SELECT 
    * 
FROM 
    source