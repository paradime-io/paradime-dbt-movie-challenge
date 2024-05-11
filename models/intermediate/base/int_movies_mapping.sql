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
        omdb.type,
        coalesce(omdb.title, tmdb.title) as title,
        coalesce(omdb.genre, tmdb.genre_names) as genre,
        coalesce(omdb.language, tmdb.original_language) as language,
        tmdb.status,
        tmdb.production_company_names,
        tmdb.production_country_names,

        -- Numbers
        imdb.imdb_rating,
        imdb.number_of_votes as imdb_votes,
        round(try_to_number(replace(iff(f.value:Source = 'Rotten Tomatoes', f.value:Value, null), '%', '')) / 10, 1) as rt_rating,
        omdb.awards,
        tmdb.vote_average,
        tmdb.vote_count,
        tmdb.revenue,
        coalesce(omdb.runtime, tmdb.runtime) as runtime,

        -- Dates/Timestamps
        coalesce(omdb.released_date, tmdb.release_date) as release_date,
        omdb.release_year

    from
        {{ ref('stg_tmdb_movies') }} as tmdb
        left join {{ ref('stg_imdb_ratings') }} as imdb
            on tmdb.imdb_id = imdb.imdb_title_id
        left join {{ ref('stg_omdb_movies') }} as omdb
            on tmdb.imdb_id = omdb.imdb_id,
        lateral flatten(input => omdb.ratings) as f

)

select *
from
    final
