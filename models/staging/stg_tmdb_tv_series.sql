WITH source AS (
    SELECT 
        ID,
        NAME,
        OVERVIEW,
        TAGLINE,
        GENRE_NAMES,
        CREATED_BY_NAMES,
        ORIGINAL_LANGUAGE,
        STATUS,
        IN_PRODUCTION,
        FIRST_AIR_DATE,
        LAST_AIR_DATE,
        NUMBER_OF_SEASONS,
        NUMBER_OF_EPISODES,
        VOTE_AVERAGE,
        VOTE_COUNT,
        POPULARITY,
        POSTER_PATH,
        PRODUCTION_COMPANY_NAMES
    FROM 
        {{ source('MOVIE_BASE', 'TMDB_TV_SERIES') }}
)

SELECT 
    * 
FROM 
    source