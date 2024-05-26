with 

source as (
    select 
        imdb_id, 
        genres
    from {{ ref('stg_imdb__movies') }}
),

selected_movies as (
    select imdb_id
    from {{ ref('int_omdb_tmdb_imdb_filtered') }}
),

-- get genre's info only for the movies we want to analyze
filtered as (
    select s.*
    from selected_movies as m
    inner join source as s using (imdb_id)
),

split_genres as (
    select 
        imdb_id,
        value as genre,
        genres as original_genres
    FROM filtered as s, LATERAL SPLIT_TO_TABLE(s.genres, ',')
)

select * 
from split_genres
