-- First deduplicate stg_tmdb_movies as it has some rows completely duplicated
WITH tmdb AS (
    SELECT
        tmdb_id as tmdb_tmdb_id,
        title as tmdb_title,
        original_title as tmdb_original_title,
        tagline as tmdb_tagline,
        keywords as tmdb_keywords,
        original_language as tmdb_original_language,
        status as tmdb_status,
        release_date as tmdb_release_date,
        runtime as tmdb_runtime,
        budget as tmdb_budget,
        revenue as tmdb_revenue,
        belongs_to_collection as tmdb_belongs_to_collection,
        imdb_id as tmdb_imdb_id,
        genre_names as tmdb_genre_names,
        spoken_languages as tmdb_spoken_languages,
        production_company_names as tmdb_production_company_names,
        production_country_names as tmdb_production_country_names,
        {{ dbt_utils.generate_surrogate_key([
                'tmdb_id',
                'title',
                'original_title',
                'tagline',
                'keywords',
                'original_language',
                'status',
                'release_date',
                'runtime',
                'budget',
                'revenue',
                'belongs_to_collection',
                'imdb_id',
                'genre_names',
                'spoken_languages',
                'production_company_names',
                'production_country_names' 
            ])
        }} as tmdb_unique_key -- this is used for debugging to check if one row has matched multiple rows in the other table
    FROM
        {{ ref('stg_tmdb_movies') }}
), 

omdb AS (
    SELECT 
        imdb_id as omdb_imdb_id,
        title as omdb_title,
        genre as omdb_genre,
        director as omdb_director,
        writer as omdb_writer,
        actors as omdb_actors,
        language as omdb_language,
        country as omdb_country,
        awards as omdb_awards,
        dvd as omdb_dvd,
        production as omdb_production,
        release_year as omdb_release_year,
        released_date as omdb_released_date,
        runtime as omdb_runtime,
        ratings as omdb_ratings,
        imdb_rating as omdb_imdb_rating,
        imdb_votes as omdb_imdb_votes,
        tmdb_id as omdb_tmdb_id,
        {{ dbt_utils.generate_surrogate_key([
                'imdb_id',
                'title',
                'genre',
                'director',
                'writer',
                'actors',
                'language',
                'country',
                'awards',
                'dvd',
                'production',
                'release_year',
                'released_date',
                'runtime',
                'ratings',
                'imdb_rating',
                'imdb_votes',
                'tmdb_id'
            ])
        }} as omdb_unique_key -- this is used for debugging to check if one row has matched multiple rows in the other table
    FROM
        {{ ref('stg_omdb_movies') }}
), 

joined_tmdb_and_omdb AS (
    SELECT
        * 
    FROM
        tmdb
    LEFT JOIN
        omdb 
            ON omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
),

joined_omdb_and_tmdb AS (
    SELECT
        * 
    FROM
        omdb
    LEFT JOIN
        tmdb 
            ON omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
),

joined AS (
    SELECT 
        tmdb_tmdb_id,
        tmdb_title,
        tmdb_original_title,
        tmdb_tagline,
        tmdb_keywords,
        tmdb_original_language,
        tmdb_status,
        tmdb_release_date,
        tmdb_runtime,
        tmdb_budget,
        tmdb_revenue,
        tmdb_belongs_to_collection,
        tmdb_imdb_id,
        tmdb_genre_names,
        tmdb_spoken_languages,
        tmdb_production_company_names,
        tmdb_production_country_names,
        tmdb_unique_key,
        omdb_imdb_id,
        omdb_title,
        omdb_genre,
        omdb_director,
        omdb_writer,
        omdb_actors,
        omdb_language,
        omdb_country,   
        omdb_awards,
        omdb_dvd,
        omdb_production,
        omdb_release_year,
        omdb_released_date,
        omdb_runtime,
        omdb_ratings,
        omdb_imdb_votes,
        omdb_tmdb_id,
        omdb_unique_key,
        {{ dbt_utils.generate_surrogate_key([
                'omdb_imdb_id',
                'tmdb_imdb_id',
                'omdb_tmdb_id',
                'tmdb_tmdb_id'
            ])
        }} as identifier_unique_key
    FROM 
        joined_tmdb_and_omdb

    UNION

    SELECT 
        tmdb_tmdb_id,
        tmdb_title,
        tmdb_original_title,
        tmdb_tagline,
        tmdb_keywords,
        tmdb_original_language,
        tmdb_status,
        tmdb_release_date,
        tmdb_runtime,
        tmdb_budget,
        tmdb_revenue,
        tmdb_belongs_to_collection,
        tmdb_imdb_id,
        tmdb_genre_names,
        tmdb_spoken_languages,
        tmdb_production_company_names,
        tmdb_production_country_names,
        tmdb_unique_key,
        omdb_imdb_id,
        omdb_title,
        omdb_genre,
        omdb_director,
        omdb_writer,
        omdb_actors,
        omdb_language,
        omdb_country,   
        omdb_awards,
        omdb_dvd,
        omdb_production,
        omdb_release_year,
        omdb_released_date,
        omdb_runtime,
        omdb_ratings,
        omdb_imdb_votes,
        omdb_tmdb_id,
        omdb_unique_key,
        {{ dbt_utils.generate_surrogate_key([
                'omdb_imdb_id',
                'tmdb_imdb_id',
                'omdb_tmdb_id',
                'tmdb_tmdb_id'
            ])
        }} as identifier_unique_key
    FROM 
        joined_omdb_and_tmdb
)

SELECT 
    *
FROM 
    joined


