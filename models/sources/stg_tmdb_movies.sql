WITH source AS (
    SELECT 
        TMDB_ID AS tmdb_id,
        NULLIF(TITLE, 'N/A') AS title,
        NULLIF(ORIGINAL_TITLE, 'N/A') AS original_title,
        NULLIF(OVERVIEW, 'N/A') AS overview,
        NULLIF(TAGLINE, 'N/A') AS tagline,
        NULLIF(KEYWORDS, 'N/A') As keywords,
        NULLIF(ORIGINAL_LANGUAGE, 'N/A') AS original_language,
        NULLIF(STATUS, 'N/A') AS status,
        VIDEO AS video,
        RELEASE_DATE AS release_date,
        RUNTIME AS runtime,
        BUDGET AS budget,
        REVENUE AS revenue,
        NULLIF(VOTE_AVERAGE, 0) AS vote_average,
        NULLIF(VOTE_COUNT, 'N/A') AS vote_count,
        NULLIF(HOMEPAGE, 'N/A') AS homepage,
        NULLIF(POSTER_PATH, 'N/A') AS poster_path,
        NULLIF(BACKDROP_PATH, 'N/A') AS backdrop_path,
        BELONGS_TO_COLLECTION AS belongs_to_collection,
        IMDB_ID AS imdb_id,
        GENRE_NAMES AS genre_names,
        NULLIF(SPOKEN_LANGUAGES, 'N/A') AS spoken_languages,
        PRODUCTION_COMPANY_NAMES AS production_company_names,
        PRODUCTION_COUNTRY_NAMES AS production_country_names
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source

