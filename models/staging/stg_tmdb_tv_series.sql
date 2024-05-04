WITH src_tmdb_tv_series AS (
    SELECT 
        ID as tv_series_id,
        NAME as title,
        OVERVIEW,
        TAGLINE,
        GENRE_NAMES as genres,
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
        POSTER_PATH
    FROM 
        {{ ref('src_tmdb_tv_series') }}
)

SELECT 
    * 
FROM 
    src_tmdb_tv_series