WITH source AS (
    SELECT 
TMDB_ID,
        TITLE,
        ORIGINAL_TITLE,
        OVERVIEW,
        TAGLINE,
        KEYWORDS,
        ORIGINAL_LANGUAGE,
        STATUS,
        VIDEO,
        RELEASE_DATE,
        RUNTIME,
        BUDGET,
        REVENUE,
        VOTE_AVERAGE,
        VOTE_COUNT,
        HOMEPAGE,
        POSTER_PATH,
        BACKDROP_PATH,
        BELONGS_TO_COLLECTION,
        CASE
            WHEN IMDB_ID = ''
                then null
            ELSE IMDB_ID
        END as IMDB_ID,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source

