-- int_movies_mapping.sql

with final as (
    select
    -- IDs
        tmdb.tmdb_id,
        tmdb.imdb_id,

        -- Strings
        tmdb.original_title,
        tmdb.overview,
        tmdb.keywords,
        omdb.director,
        omdb.writer,
        omdb.actors,
        coalesce(omdb.title, tmdb.title) as title,
        coalesce(omdb.genre, tmdb.genre_names) as genre,
        omdb.type,
        tmdb.status,
        tmdb.homepage,
        tmdb.poster_path,
        tmdb.spoken_languages,
        coalesce(omdb.language, tmdb.original_language) as language,
        tmdb.production_company_names,
        tmdb.production_country_names,

        -- Numbers
        tmdb.budget,
        omdb.imdb_rating,
        omdb.imdb_votes,
        omdb.box_office,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        omdb.awards,
        coalesce(omdb.runtime, tmdb.runtime) as runtime,

        -- Booleans
        tmdb.video as is_video,

        -- Dates/Timestamps
        coalesce(omdb.released_date, tmdb.release_date) as release_date,
        omdb.release_year,

    from
        {{ ref('stg_tmdb_movies') }} as tmdb
        left join {{ ref('stg_omdb_movies') }} as omdb
            on tmdb.imdb_id = omdb.imdb_id
)

select *
from
    final
