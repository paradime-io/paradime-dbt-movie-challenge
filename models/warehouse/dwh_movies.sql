-- The data in this table should contain all fields about the movie entity only, 
-- and not fields relating to other entities, eg. people. This will be added as required
-- in the analytics schema.

-- All movie columns combined from joined set omdb_movies + tmdb_movies
-- Plus split out movie ratings
-- Plus bechdel test ratings
with all_movies_combined_columns as (
    select 
        identifier_unique_key,
        omdb_imdb_id,
        tmdb_imdb_id,
        omdb_tmdb_id,
        tmdb_tmdb_id,
        title,
        original_title,
        tagline,
        keywords,
        languages,
        original_language,
        genres,
        production_companies,
        production_countries,
        release_date,
        release_year,
        release_status,
        runtime,
        awards,
        dvd,
        budget,
        revenue,
        collection_name,
        imdb_votes
    from 
        {{ref('all_movies_combined_columns')}}

),

movie_ratings as (
    select 
        *
    from 
        {{ref('movies_with_ratings_columns')}}

),

movie_bechdel_ratings as (
    SELECT 
        IMDB_ID,
        bechdel_rating,
        title,
        release_year
    FROM 
        {{ref('stg_movies_bechdel_rating')}}
),

movies_all_columns as (
    select 
        cc.*,
        10*(left(rc.imdb_rating, LENGTH(rc.imdb_rating) -3)) as imdb_rating,
        left(rc.rotten_tomatoes_rating, LENGTH(rc.rotten_tomatoes_rating)-4) as rotten_tomatoes_rating,
        left(rc.metacritic_rating, LENGTH(rc.metacritic_rating)-1) as metacritic_rating,
        br.bechdel_rating
    from 
        all_movies_combined_columns as cc
    left join movie_ratings as rc
        ON rc.identifier_unique_key = cc.identifier_unique_key
    left join movie_bechdel_ratings as br 
        on br.IMDB_ID = cc.omdb_imdb_id
)
select 
    *
from 
    movies_all_columns