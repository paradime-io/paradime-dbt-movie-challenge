WITH platforms AS (
    SELECT
        title,
        rotten_tomatoes,
        netflix,
        hulu,
        prime_video,
        disney_plus
    FROM
        {{ ref('stg_streaming_platforms') }}
),
tv_series AS (
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
        {{ ref('stg_tmdb_tv_series') }}
)

SELECT
    tv.ID,
    tv.NAME,
    tv.GENRE_NAMES,
    tv.CREATED_BY_NAMES,
    tv.ORIGINAL_LANGUAGE,
    tv.STATUS,
    tv.IN_PRODUCTION,
    tv.FIRST_AIR_DATE,
    tv.LAST_AIR_DATE,
    tv.NUMBER_OF_SEASONS,
    tv.NUMBER_OF_EPISODES,
    tv.VOTE_AVERAGE,
    tv.VOTE_COUNT,
    tv.POPULARITY,
    tv.PRODUCTION_COMPANY_NAMES,
    SPLIT_PART(p.rotten_tomatoes, '/', 1) AS rotten_tomatoes_score,
    p.netflix,
    p.hulu,
    p.prime_video,
    p.disney_plus,
    p.netflix + p.hulu + p.prime_video + p.disney_plus AS total_platforms
FROM
    tv_series tv
JOIN
    platforms p
ON
    LOWER(REPLACE(tv.NAME, ' ', '')) = LOWER(REPLACE(p.title, ' ', ''))

    