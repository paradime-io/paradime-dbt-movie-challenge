WITH source AS (
    SELECT 
        ID AS id,
        NAME AS name,
        OVERVIEW AS overview,
        TAGLINE AS tagline,
        GENRE_NAMES AS genre_names,
        CREATED_BY_NAMES AS created_by_names,
        ORIGINAL_LANGUAGE AS original_language,
        STATUS AS status,
        IN_PRODUCTION AS in_production,
        FIRST_AIR_DATE AS first_air_date,
        LAST_AIR_DATE AS last_air_date,
        NUMBER_OF_SEASONS AS number_of_seasons,
        NUMBER_OF_EPISODES AS number_of_episodes,
        VOTE_AVERAGE AS vote_average,
        VOTE_COUNT AS vote_count,
        POPULARITY AS popularity,
        POSTER_PATH AS poster_path,
        PRODUCTION_COMPANY_NAMES AS production_company_names
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_TV_SERIES') }}
)

SELECT 
    * 
FROM 
    source