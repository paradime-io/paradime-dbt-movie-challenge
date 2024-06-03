-- One row per movie-genre combination in the resulting table including
-- all relevant fields from dwh_movies

with movie_genres as (
    select 
        imdb_id,
        genre
    from 
        {{ref('dwh_movie_genres')}}
),

movies as (
    select 
        imdb_id,
        original_language,
        release_date,
        release_year,
        runtime,
        awards,
        budget,
        revenue,
        imdb_votes,
        imdb_rating,
        rotten_tomatoes_rating,
        metacritic_rating,
        bechdel_rating
    from 
        {{ref('dwh_movies')}}
)

select
    mg.imdb_id,
    mg.genre,
    m.original_language,
    m.release_date,
    date_part('MONTH', m.release_date) as release_month,
    m.release_year,
    m.runtime,
    m.awards,
    m.budget,
    m.revenue,
    m.imdb_votes,
    m.imdb_rating,
    m.rotten_tomatoes_rating,
    m.metacritic_rating,
    m.bechdel_rating
from 
    movie_genres as mg
join movies as m
    on m.imdb_id = mg.imdb_id
