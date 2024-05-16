with source as (
    select distinct
        tmdb_id,
        title,
        original_title,
        overview,
        tagline,
        keywords,
        original_language,
        status,
        video,
        release_date,
        runtime,
        budget,
        revenue,
        vote_average as viewer_vote_average,
        vote_count as viewer_vote_count,
        homepage,
        poster_path,
        backdrop_path,
        belongs_to_collection,
        imdb_id,
        genre_names,
        spoken_languages,
        production_company_names,
        production_country_names
    from
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

select *
from
    source
