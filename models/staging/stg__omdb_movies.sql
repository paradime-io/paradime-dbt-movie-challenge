with base as (

    select *
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}

), renamed as (

    select 
        TITLE as title,
        DIRECTOR as director,
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

    from base
)

select * 
from source
