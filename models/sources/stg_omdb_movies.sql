WITH src AS (
    SELECT 
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
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
        RUNTIME,
        DVD,
        BOX_OFFICE,
        POSTER,
        PRODUCTION,
        WEBSITE,
        AWARDS,
        TMDB_ID
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
),

deduplicated as (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY imdb_id, tmdb_id
            ORDER BY title
        ) as imdb_tmdb_id_row_no,
        ROW_NUMBER() OVER (
            PARTITION BY title, released_date
            ORDER BY imdb_id
        ) as title_release_date_row_no
    FROM
        src
    WHERE 
        title NOT LIKE '%#DUPE%'
    QUALIFY 
        imdb_tmdb_id_row_no = 1
        AND title_release_date_row_no = 1
)

SELECT 
    * 
FROM 
    deduplicated
