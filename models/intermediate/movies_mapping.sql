with final as (
    select
        -- IDs
        tmdb.tmdb_id,
        tmdb.imdb_id,

        -- Strings
        coalesce(omdb.title, tmdb.title) as title,
        tmdb.original_title,
        tmdb.overview,
        --tmdb.tagline,
        tmdb.keywords,
        coalesce(omdb.genre, tmdb.genre_names) as genre,
        coalesce(omdb.language, tmdb.original_language) as language,
        omdb.director,
        omdb.writer,
        omdb.actors,
        tmdb.status,
        tmdb.homepage,
        --tmdb.poster_path,
        --tmdb_backdrop_path,
        --tmdb.spoken_languages,
        --tmdb.production_company_names,
        --tmdb.production_country_names,
        
        -- Numbers
        coalesce(omdb.runtime, tmdb.runtime) as runtime,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        tmdb.budget,
        omdb.imdb_rating,
        omdb.imdb_votes,
        omdb.box_office,
        omdb.awards,

        -- Booleans
        tmdb.video as is_video,

        -- Dates/Timestamps
       coalesce(omdb.released_date, tmdb.release_date) as release_date,
       omdb.release_year,

    from
        {{ ref('stg_tmdb_movies') }} tmdb
    left join {{ ref('stg_omdb_movies') }} omdb
        on tmdb.imdb_id = omdb.imdb_id
)

select
    *
from
    final