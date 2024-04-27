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
        case when IMDB_ID = '' then null -- might want to automate this later across all columns, removing blanks and replacing as nulls manually for now where needed
        else imdb_id
        end as imdb_id,
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

