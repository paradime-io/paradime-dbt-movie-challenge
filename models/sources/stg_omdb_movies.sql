WITH 

source AS (
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
    FROM {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
    -- bad data when imdb_id != imdbid. All of them have title = '#DUPE#'
    where IMDB_ID = IMDBID
)

SELECT * 
FROM source
