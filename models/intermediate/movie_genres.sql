with movies_src as (
    select 
        identifier_unique_key,
        genres
    from 
        {{ref('all_movies_combined_columns')}}
),

all_movies_and_genres  as (
    SELECT 
        identifier_unique_key as movie_id,
        trim(gen.value) AS genre
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(genres, ',') AS gen
)

select 
    *
from 
    all_movies_and_genres