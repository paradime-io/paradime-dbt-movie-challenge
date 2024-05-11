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
        tmdb_id,
        round(try_to_number(replace(iff(f.value:Source = 'Rotten Tomatoes', f.value:Value, null), '%', '')) / 10, 1) as omdb_rt_rating,
        to_number(regexp_substr(awards, '([0-9]+)\\s*wins?', 1, 1, 'e')) as number_of_awards_won
    from
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }},
        lateral flatten(input => ratings) as f
)

select *
from
    source
