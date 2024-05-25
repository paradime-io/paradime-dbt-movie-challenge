with movies_src as (
    select 
        imdb_id,
        genres
    from 
        {{ref('all_movies_combined_columns')}}
),

all_movies_and_genres  as (
    SELECT 
        imdb_id,
        trim(gen.value) AS genre
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(genres, ',') AS gen
),

consolidated as (
    SELECT
        imdb_id,
        IFNULL(genre_lookup.to_name, gen.genre) as genre
    FROM 
        all_movies_and_genres as gen
    LEFT JOIN {{ref('movie_genre_consolidation')}} as genre_lookup
        ON genre_lookup.from_name = gen.genre
)

select 
    imdb_id,
    genre
from 
    consolidated