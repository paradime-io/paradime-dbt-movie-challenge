-- int_movies_mapping.sql
with rotten_tomatoes_ratings as (
    select
        a.imdb_id,
        b.*
    from (
        select
            imdb_id,
            lower(regexp_replace(title, '[^a-zA-Z0-9]', '')) as clean_title
        from {{ ref('stg_tmdb_movies') }}
    ) as a
        inner join (
            select
                audience_score / 10 as audience_score,
                tomato_meter / 10 as tomato_meter,
                lower(regexp_replace(title, '[^a-zA-Z0-9]', '')) as clean_title
            from {{ ref('stg_rotten_tomatoes') }}
        ) as b
            on a.clean_title = b.clean_title
),


final as (
    select
    -- IDs
        tmdb.tmdb_id,
        tmdb.imdb_id,

        -- Strings
        coalesce(omdb.title, tmdb.title) as title,
        tmdb.original_title,
        tmdb.overview,
        tmdb.keywords,
        omdb.director,
        omdb.writer,
        omdb.actors,
        omdb.type,
        coalesce(omdb.genre, tmdb.genre_names) as genre,
        coalesce(omdb.language, tmdb.original_language) as language,

        -- Numbers
        coalesce(omdb.runtime, tmdb.runtime) as runtime,
        coalesce(imdb.imdb_rating, omdb.imdb_rating) as imdb_rating,
        coalesce(imdb.number_of_votes, omdb.imdb_votes) as imdb_votes,
        omdb.omdb_rt_rating,
        rt.audience_score,
        rt.tomato_meter,
        omdb.number_of_awards_won,
        tmdb.viewer_vote_average,
        tmdb.viewer_vote_count,
        tmdb.revenue,
        mr.normalized_revenue,

        -- Dates/Timestamps
        coalesce(omdb.released_date, tmdb.release_date) as release_date

    from
        {{ ref('stg_tmdb_movies') }} as tmdb
        left join rotten_tomatoes_ratings as rt
            on tmdb.imdb_id = rt.imdb_id
        left join {{ ref('stg_imdb_ratings') }} as imdb
            on tmdb.imdb_id = imdb.imdb_title_id
        left join {{ ref('stg_omdb_movies') }} as omdb
            on tmdb.imdb_id = omdb.imdb_id
        left join {{ ref('normalized_revenue_movies') }} as mr
            on tmdb.imdb_id = mr.imdb_id

    where
        tmdb.imdb_id is not null
        and tmdb.imdb_id != ''
)

select *
from
    final
