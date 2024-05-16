WITH financials AS (
    SELECT
        ID,
        NAME,
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
),
platforms AS (
    SELECT
        platform,
        show_id,
        type,
        title,
        director,
        country,
        date_added,
        release_year,
        rating,
        seasons,
        listed_in
    FROM 
        {{ ref('int_tvshows_on_all_platforms') }}
),
joined_tables AS (
    SELECT
        f.ID,
        f.NAME,
        f.GENRE_NAMES,
        f.CREATED_BY_NAMES,
        f.ORIGINAL_LANGUAGE,
        f.STATUS,
        f.IN_PRODUCTION,
        f.FIRST_AIR_DATE,
        f.LAST_AIR_DATE,
        f.NUMBER_OF_SEASONS,
        f.NUMBER_OF_EPISODES,
        f.VOTE_AVERAGE,
        f.VOTE_COUNT,
        f.POPULARITY,
        f.POSTER_PATH,
        f.PRODUCTION_COMPANY_NAMES,
        CASE WHEN p.platform IS NULL THEN 'None' ELSE p.platform END as platform,
        p.show_id,
        p.type,
        p.title,
        p.director,
        p.country,
        p.date_added,
        p.release_year,
        p.rating,
        p.seasons,
        p.listed_in
    FROM
        financials f
    LEFT JOIN
        platforms p
    ON
        LOWER(REPLACE(p.title, ' ', '')) = LOWER(REPLACE(f.NAME, ' ', ''))
        AND release_year <= year(first_air_date)
)
SELECT * FROM joined_tables
