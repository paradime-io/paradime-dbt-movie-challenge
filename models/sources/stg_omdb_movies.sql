WITH source AS (
    SELECT 
        IMDB_ID AS imdb_id,
        NULLIF(TITLE, 'N/A') AS title,
        NULLIF(DIRECTOR, 'N/A') AS director,
        NULLIF(WRITER, 'N/A') AS writer,
        NULLIF(ACTORS, 'N/A') AS actors,
        NULLIF(GENRE, 'N/A') AS genre,
        NULLIF(LANGUAGE, 'N/A') AS language,
        NULLIF(COUNTRY, 'N/A') AS country,
        NULLIF(TYPE, 'N/A') AS type,
        NULLIF(PLOT, 'N/A') AS plot,
        NULLIF(RATED, 'N/A') AS rated,
        RATINGS AS ratings,
        NULLIF(METASCORE, 0) AS metascore,
        NULLIF(IMDB_RATING, 0) AS imdb_rating,
        NULLIF(IMDB_VOTES, 0) AS imdb_votes,
        RELEASED_DATE AS released_date,
        RELEASE_YEAR AS release_year,
        RUNTIME AS runtime,
        NULLIF(DVD, 'N/A') AS dvd,
        BOX_OFFICE AS box_office,
        NULLIF(POSTER, 'N/A') AS poster,
        NULLIF(PRODUCTION, 'N/A') AS production,
        NULLIF(WEBSITE, 'N/A') AS website,
        AWARDS AS awards,
        TMDB_ID AS tmdb_id
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
