with 

source as (
    select 
        imdb_id, 
        directors
    from {{ ref('stg_imdb__movies_crew') }}
),

split_directors as (
    select 
        imdb_id,
        value as director
    FROM source as s, LATERAL SPLIT_TO_TABLE(s.directors, ',')
)

SELECT * 
FROM split_directors
