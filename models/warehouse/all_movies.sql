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
        director,
        writer,
        actors,
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

movies_with_ratings_columns as (
    select 
        *
    from 
        {{ref('movies_with_ratings_columns')}}

),

joined as (
    select 
        cc.*,
        rc.imdb_rating,
        rc.rotten_tomatoes_rating,
        rc.metacritic_rating
    from 
        all_movies_combined_columns as cc
    left join movies_with_ratings_columns as rc
        ON rc.identifier_unique_key = cc.identifier_unique_key
)

select 
    *
from 
    joined