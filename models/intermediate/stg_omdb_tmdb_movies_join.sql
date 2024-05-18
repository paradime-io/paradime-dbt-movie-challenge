{{
  config(
    materialized = 'table',
    )
}}

WITH  JOINED AS (
    SELECT
        coalesce(o.imdb_id, t.imdb_id) AS imdb_id,
        coalesce(o.tmdb_id, t.tmdb_id) AS tmdb_id,
        coalesce(o.title, t.title) AS title,
        ORIGINAL_TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        ORIGINAL_LANGUAGE,
        COUNTRY,
        TYPE,
        PLOT,
        RATED,
        RATINGS,
        METASCORE,
        IMDB_RATING,
        IMDB_VOTES,
        RELEASED_DATE,
        RELEASE_YEAR,
        coalesce(o.RUNTIME, t.RUNTIME) AS RUNTIME,
        DVD,
        BOX_OFFICE,
        POSTER,
        PRODUCTION,
        WEBSITE,
        AWARDS,
        OVERVIEW,
        TAGLINE,
        KEYWORDS,
        STATUS,
        VIDEO,
        RELEASE_DATE,
        NULLIFZERO(BUDGET) AS BUDGET,
        NULLIFZERO(REVENUE) AS REVENUE,
        NULLIFZERO(REVENUE)-NULLIFZERO(BUDGET) AS PROFIT,
        NULLIFZERO(VOTE_AVERAGE) AS VOTE_AVERAGE,
        NULLIFZERO(VOTE_COUNT) AS VOTE_COUNT,
        HOMEPAGE,
        POSTER_PATH,
        BACKDROP_PATH,
        BELONGS_TO_COLLECTION,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM
        {{ ref('stg_tmdb') }} t
    JOIN
        {{ ref('stg_omdb') }} o 
    WHERE true 
        AND (o.imdb_id = t.imdb_id) or (o.tmdb_id = t.tmdb_id))
SELECT *
FROM JOINED 
QUALIFY row_number() over (partition by imdb_id order by VOTE_AVERAGE, budget, release_date, production_company_names) = 1