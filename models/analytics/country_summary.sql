-- One row per person in the resulting table, including:
-- all relevant fields from dwh_movie_people
-- any summary data aggregated on a per-person basis from other tables, eg. dwh_movies

with movie_countries as (
    select 
        movie_id,
        production_country
    from 
        {{ref('dwh_movie_countries')}}
),

movies as (
    select 
        identifier_unique_key,
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
    mc.movie_id,
    mc.production_country,
    m.original_language,
    m.release_date,
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
    movie_countries as mc
join movies as m
    on m.identifier_unique_key = mc.movie_id
