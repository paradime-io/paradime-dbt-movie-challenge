WITH source AS (
    SELECT 
        TCONST as imdb_id,
        ordering,
        NCONST as imdb_name_id,
        case when category = 'actress' then 'actor' else category end as category,
        job,
        CHARACTERS
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_PRINCIPAL') }}
)

SELECT 
    * 
FROM 
    source