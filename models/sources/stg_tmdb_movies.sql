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
        IMDB_ID,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        SPLIT_PART(PRODUCTION_COUNTRY_NAMES,',',1) AS production_country
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
WHERE production_country IS NOT NULL

