WITH source AS (
    SELECT 
        IMDB_ID AS imdb_id,
        TITLE AS title,
        DIRECTOR AS director,
        WRITER AS writer,
        ACTORS AS actors,
        GENRE AS genre,
        LANGUAGE AS language,
        COUNTRY AS country,
        TYPE AS type,
        PLOT AS plot,
        RATED AS rated,
        RATINGS AS ratings,
        METASCORE AS metascore,
        IMDB_RATING AS imdb_rating,
        IMDB_VOTES AS imdb_votes,
        RELEASED_DATE AS released_date,
        RELEASE_YEAR AS release_year,
        RUNTIME AS runtime,
        DVD AS dvd,
        BOX_OFFICE AS box_office,
        POSTER AS poster,
        PRODUCTION AS production,
        WEBSITE AS website,
        AWARDS AS awards,
        TMDB_ID AS tmdb_id
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
