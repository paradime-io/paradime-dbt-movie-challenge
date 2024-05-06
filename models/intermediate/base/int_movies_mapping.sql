with final as (
    select
    -- IDs
        tmdb.tmdb_id,
        tmdb.imdb_id,

        -- Strings
        tmdb.original_title,
        tmdb.overview,
        tmdb.keywords,
        --tmdb.tagline,
        omdb.director,
        omdb.writer,
        omdb.actors,
        omdb.type,
        tmdb.status,
        tmdb.homepage,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        --tmdb.poster_path,
        --tmdb_backdrop_path,
        --tmdb.spoken_languages,
        --tmdb.production_company_names,
        --tmdb.production_country_names,

        -- Numbers
        tmdb.budget,
        omdb.imdb_rating,
        omdb.imdb_votes,
        omdb.box_office,
        omdb.awards,
        tmdb.video as is_video,
        omdb.release_year,
        coalesce(omdb.title, tmdb.title) as title,
        coalesce(omdb.genre, tmdb.genre_names) as genre,

        -- Booleans
        coalesce(omdb.language, tmdb.original_language) as language,

        -- Dates/Timestamps
        coalesce(omdb.runtime, tmdb.runtime) as runtime,
        coalesce(omdb.released_date, tmdb.release_date) as release_date

    from
        {{ ref('stg_tmdb_movies') }} as tmdb
        left join {{ ref('stg_omdb_movies') }} as omdb
            on tmdb.imdb_id = omdb.imdb_id
)

select *
from
    final
