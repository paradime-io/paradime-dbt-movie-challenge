with source as (
    select
        imdb_id,
        title,
        director,
        writer,
        actors,
        genre,
        language,
        country,
        type,
        plot,
        rated,
        ratings,
        metascore,
        imdb_rating,
        imdb_votes,
        released_date,
        release_year,
        runtime,
        dvd,
        box_office,
        poster,
        production,
        website,
        awards,
        tmdb_id
    from
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

select *
from
    source
