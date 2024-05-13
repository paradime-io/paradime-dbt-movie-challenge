with all_movies_combined_columns as (
    select 
        omdb_imdb_id,
        tmdb_imdb_id,
        omdb_tmdb_id,
        tmdb_tmdb_id,
        identifier_unique_key,title,
        original_title,
        NULLIF(tagline,'') as tagline,
        keywords,
        NULLIF(REPLACE(director, 'N/A', ''), '') as director,
        NULLIF(REPLACE(writer, 'N/A', ''), '') as writer,
        NULLIF(REPLACE(actors, 'N/A', ''), '') as actors,
        languages,
        original_language,
        genres,
        production_companies,
        production_countries,
        to_date(release_date, 'yyyy-mm-dd') as release_date,
        to_number(release_year) as release_year,
        release_status,
        to_number(NULLIFZERO(runtime)) as runtime,
        NULLIF(REPLACE(awards, 'N/A', ''), '') as awards,
        NULLIF(REPLACE(dvd, 'N/A', ''), '') as dvd,
        collection_name
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