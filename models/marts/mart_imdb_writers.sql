with 

source as (
    select 
        imdb_id, 
        writers
    from {{ ref('stg_imdb__movies_crew') }}
),

split_writers as (
    select 
        imdb_id,
        value as writer
    FROM source as s, LATERAL SPLIT_TO_TABLE(s.writers, ',')
)

SELECT * 
FROM split_writers
