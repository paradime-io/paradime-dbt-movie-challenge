WITH source AS (
    SELECT 
        TMDB_ID,
        IMDB_ID,
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
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)


/* How many records are there?
908351
*/
--  select count(*) from source

/* Which ID should we use? 
    - TMDB is unique and non-null, so this makes most sense.
*/
--  select
--      count(distinct tmdb_id) = count(*) as TMDB_ID_count,
--      count(distinct imdb_id) = count(*) as IMDB_ID_count,
--  from source


select * from source