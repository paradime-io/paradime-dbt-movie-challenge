WITH source AS (
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
    WHERE 
        title != '#DUPE#'
)

SELECT 
    * 
FROM 
    source
qualify row_number() over (partition by IMDB_ID order by RELEASED_DATE) = 1