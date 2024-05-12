with source as (
    select
        id,
        name,
        overview,
        tagline,
        genre_names,
        created_by_names,
        original_language,
        status,
        in_production,
        first_air_date,
        last_air_date,
        number_of_seasons,
        number_of_episodes,
        vote_average,
        vote_count,
        popularity,
        poster_path,
        production_company_names
    from
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_TV_SERIES') }}
)

select *
from
    source
