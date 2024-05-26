WITH src AS (
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
        case 
            when IMDB_ID = '' 
                then NULL
            else 
                IMDB_ID
        end as IMDB_ID,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
),

deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY imdb_id, tmdb_id
            ORDER BY title
        ) as imdb_tmdb_id_row_no,
        ROW_NUMBER() OVER (
            PARTITION BY title, release_date
            ORDER BY imdb_id
        ) as title_release_date_row_no
    FROM
        src
    QUALIFY 
        imdb_tmdb_id_row_no = 1
        AND title_release_date_row_no = 1   
)

SELECT 
    * 
FROM 
    deduplicated

