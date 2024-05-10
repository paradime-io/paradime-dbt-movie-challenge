WITH source AS (
    SELECT DISTINCT
        MOVIE_ID,
        SPLIT_PART(GENRE, ',', 1) AS main_genre
    FROM 
        {{ source('EXTRA_DATASETS', 'MOVIE_GENRES') }}
)

SELECT 
    * 
FROM 
    source