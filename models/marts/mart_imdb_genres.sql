with 

source as (
    select 
        imdb_id, 
        genres
    from {{ ref('stg_imdb__movies') }}
),

split_genres as (
    select 
        imdb_id,
        value as genre
    FROM source as s, LATERAL SPLIT_TO_TABLE(s.genres, ',')
)

SELECT * 
FROM split_genres
