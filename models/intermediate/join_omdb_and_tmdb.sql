WITH tmdb_deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY imdb_id, tmdb_id
            ORDER BY title
        ) as imdb_tmdb_id_row_no,
        ROW_NUMBER() OVER (
            PARTITION BY title, release_date
            ORDER BY imdb_id
        ) as title_release_date_row_no
    FROM
        {{ ref('stg_tmdb_movies') }}
    QUALIFY 
        imdb_tmdb_id_row_no = 1
        AND title_release_date_row_no = 1   
),

tmdb AS (
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
        }} as tmdb_unique_key
    FROM
        tmdb_deduplicated
), 

omdb_deduplicated as (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY imdb_id, tmdb_id
            ORDER BY title
        ) as imdb_tmdb_id_row_no,
        ROW_NUMBER() OVER (
            PARTITION BY title, released_date
            ORDER BY imdb_id
        ) as title_release_date_row_no
    FROM
        {{ ref('stg_omdb_movies') }}
    WHERE 
        title NOT LIKE '%#DUPE%'
    QUALIFY 
        imdb_tmdb_id_row_no = 1
        AND title_release_date_row_no = 1
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
                'tmdb_id'
            ])
        }} as omdb_unique_key
    FROM
        omdb_deduplicated
), 

joined_tmdb_and_omdb_id AS (
    SELECT
        *,
        CASE 
            WHEN omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_imdb_id = tmdb.tmdb_imdb_id THEN 1
            WHEN omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_title = tmdb.tmdb_title THEN 2
            WHEN omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
                AND omdb.omdb_title = tmdb.tmdb_title THEN 3
            WHEN omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_title = tmdb.tmdb_original_title THEN 4
            WHEN omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
                AND omdb.omdb_title = tmdb.tmdb_original_title THEN 5
        END AS match_type   
    FROM
        tmdb
    JOIN
        omdb 
            ON (omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_imdb_id = tmdb.tmdb_imdb_id)

            OR (omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_title = tmdb.tmdb_title)

            OR (omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
                AND omdb.omdb_title = tmdb.tmdb_title)

            OR (omdb.omdb_tmdb_id = tmdb.tmdb_tmdb_id
                AND omdb.omdb_title = tmdb.tmdb_original_title)

            OR (omdb.omdb_imdb_id = tmdb.tmdb_imdb_id
                AND omdb.omdb_title = tmdb.tmdb_original_title)     
),

joined_deduped_tmdb_unique_key AS (
    SELECT
        *
    FROM
        joined_tmdb_and_omdb_id
    QUALIFY ROW_NUMBER() OVER (
            PARTITION BY tmdb_unique_key
            ORDER BY match_type
        ) = 1
),

joined_deduped_omdb_unique_key AS (
    SELECT
        *
    FROM
        joined_deduped_tmdb_unique_key
    QUALIFY ROW_NUMBER() OVER (
            PARTITION BY omdb_unique_key
            ORDER BY match_type
        ) = 1
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
        omdb_tmdb_id,
        omdb_unique_key
    FROM 
        joined_deduped_omdb_unique_key
)

SELECT 
    *
FROM 
    joined


