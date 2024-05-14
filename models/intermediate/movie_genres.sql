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
),

consolidated as (
    SELECT
        movie_id,
        replace(genre, 'Sci-Fi', 'Science Fiction') as genre
    FROM 
        all_movies_and_genres
)

select 
    *
from 
    consolidated