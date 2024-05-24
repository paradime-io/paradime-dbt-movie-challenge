 WITH combined as (   
    SELECT 
        omdb_imdb_id,
        tmdb_imdb_id,
        omdb_tmdb_id,
        tmdb_tmdb_id,
        omdb_title,
        tmdb_title,
        coalesce(omdb_title, tmdb_title) as title,
        tmdb_original_title as original_title,
        NULLIF(tmdb_tagline, '') as tagline,
        tmdb_keywords as keywords,
        NULLIF(REPLACE(omdb_director, 'N/A', ''), '') as director,
        NULLIF(REPLACE(omdb_writer, 'N/A'), '') as writer,
        NULLIF(REPLACE(omdb_actors, 'N/A'), '') as actors,

        omdb_language,
        tmdb_spoken_languages,
        --  concat(omdb_language, ', ', tmdb_spoken_languages) as languages,
        {{target.schema}}.f_concat_lists_get_distinct(omdb_language, tmdb_spoken_languages) as languages,
        tmdb_original_language as original_language,

        omdb_genre,
        tmdb_genre_names,
        --  concat(omdb_genre, ', ', tmdb_genre_names) as genres,
        {{target.schema}}.f_concat_lists_get_distinct(omdb_genre, tmdb_genre_names) as genres,

        omdb_production,
        tmdb_production_company_names,
        --  concat(omdb_production, ', ', tmdb_production_company_names) as production_companies,
        {{target.schema}}.f_concat_lists_get_distinct(omdb_production, tmdb_production_company_names) as production_companies,

        omdb_country,
        tmdb_production_country_names,
        --  concat(omdb_country, ', ', tmdb_production_country_names) as production_countries,
        {{target.schema}}.f_concat_lists_get_distinct(omdb_country, tmdb_production_country_names) as production_countries,

        omdb_released_date,
        tmdb_release_date,
        --  concat(omdb_released_date, ', ', tmdb_release_date) as release_dates,
        --  {{target.schema}}.f_concat_lists_get_distinct(omdb_released_date, tmdb_release_date) as release_date_cleaned,
        to_date(
            {{target.schema}}.f_concat_lists_get_min(omdb_released_date, tmdb_release_date),
                'yyyy-mm-dd') as release_date,
        
        omdb_release_year,
        to_number(coalesce(omdb_release_year, year(release_date))) as release_year,

        tmdb_status as release_status,

        omdb_runtime,
        tmdb_runtime,
        --  concat(omdb_runtime, ', ', tmdb_runtime) as runtimes,
        --  {{target.schema}}.f_concat_lists_get_distinct(omdb_runtime, tmdb_runtime) as runtimes_cleaned,
        to_number(NULLIFZERO({{target.schema}}.f_concat_lists_get_max(omdb_runtime, tmdb_runtime))) as runtime,

        NULLIF(REPLACE(omdb_awards, 'N/A', ''), '') as awards,
        NULLIF(REPLACE(omdb_dvd, 'N/A', ''), '') as dvd,
        NULLIFZERO(tmdb_budget) as budget,
        NULLIFZERO(tmdb_revenue) as revenue,
        to_varchar(tmdb_belongs_to_collection:name) as collection_name,
        omdb_ratings as ratings,
        NULLIFZERO(omdb_imdb_votes) as imdb_votes, -- get imdb_rating from ratings field, use votes to indicate general popularity
        identifier_unique_key

    FROM
        {{ ref('join_omdb_and_tmdb_test') }}
 )

 select 
    *
from 
    combined