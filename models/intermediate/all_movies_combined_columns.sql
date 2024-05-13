 WITH combined as (   
    SELECT 
        omdb_imdb_id,
        tmdb_imdb_id,
        coalesce(omdb_title, tmdb_title) as title,
        tmdb_original_title as original_title,
        omdb_director as directory,
        omdb_writer as writer,
        omdb_actors as actors,
        concat(omdb_language, ', ', tmdb_spoken_languages) as languages,
        concat(omdb_genre, ', ', tmdb_genre_names) as genre_words,
        concat(omdb_production, ', ', tmdb_production_company_names) as production_companies,
        concat(omdb_country, ', ', tmdb_production_country_names) as production_countries,
        omdb_awards as awards,
        omdb_dvd
    FROM
        {{ ref('join_omdb_and_tmdb') }}
 )

 select 
    *
from 
    combined