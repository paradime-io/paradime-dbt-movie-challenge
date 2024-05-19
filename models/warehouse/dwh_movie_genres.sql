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
        IFNULL(genre_lookup.to_name, gen.genre) as genre
    FROM 
        all_movies_and_genres as gen
    LEFT JOIN {{ref('movie_genre_consolidation')}} as genre_lookup
        ON genre_lookup.from_name = gen.genre
)

select 
    movie_id,
    genre
from 
    consolidated