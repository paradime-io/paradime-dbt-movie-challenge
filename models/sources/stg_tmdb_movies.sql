WITH source AS (
    SELECT 
        TMDB_ID AS tmdb_id,
        TITLE AS title,
        ORIGINAL_TITLE AS original_title,
        OVERVIEW AS overview,
        TAGLINE AS tagline,
        KEYWORDS As keywords,
        ORIGINAL_LANGUAGE AS original_language,
        STATUS AS status,
        VIDEO AS video,
        RELEASE_DATE AS release_date,
        RUNTIME AS runtime,
        BUDGET AS budget,
        REVENUE AS revenue,
        VOTE_AVERAGE AS vote_average,
        VOTE_COUNT AS vote_count,
        HOMEPAGE AS homepage,
        POSTER_PATH AS poster_path,
        BACKDROP_PATH AS backdrop_path,
        BELONGS_TO_COLLECTION AS belongs_to_collection,
        IMDB_ID AS imdb_id,
        GENRE_NAMES AS genre_names,
        SPOKEN_LANGUAGES AS spoken_languages,
        PRODUCTION_COMPANY_NAMES AS production_company_names,
        PRODUCTION_COUNTRY_NAMES AS production_country_names
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source

