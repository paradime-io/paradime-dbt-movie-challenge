with omdb as (
    select
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        COUNTRY,
        RATED,
        IMDB_VOTES,
        RELEASED_DATE,
        RELEASE_YEAR,
        RUNTIME,
        DVD,
        PRODUCTION,
        TMDB_ID
    from {{ref('cleaned_omdb_movies')}}
),

tmdb as (
    select 
        TMDB_ID,
        ORIGINAL_LANGUAGE,
        BUDGET,
        REVENUE,
        IMDB_ID
    from
        {{ref('cleaned_tmdb_movies')}}
),

joined as (
select 
    omdb.IMDB_ID,
    omdb.TITLE,
    omdb.DIRECTOR,
    omdb.WRITER,
    omdb.ACTORS,
    omdb.GENRE,
    omdb.LANGUAGE,
    omdb.COUNTRY,
    omdb.RATED,
    omdb.IMDB_VOTES,
    omdb.RELEASED_DATE,
    omdb.RELEASE_YEAR,
    omdb.RUNTIME,
    omdb.DVD,
    omdb.PRODUCTION,
    tmdb.TMDB_ID,
    tmdb.BUDGET,
    tmdb.REVENUE
from
    omdb join tmdb   
    on omdb.imdb_id = tmdb.imdb_id and
    omdb.tmdb_id = tmdb.tmdb_id
)

select 
    *
FROM
    joined