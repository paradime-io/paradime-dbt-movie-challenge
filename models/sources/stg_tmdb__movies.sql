with 

source as (
    select *
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
),

basic_cleanup as (
    select 
        -- ids
        tmdb_id,
        imdb_id,
        -- dimensions
        title,
        tagline,
        keywords,
        original_language,
        status,
        video,
        belongs_to_collection,
        genre_names,
        spoken_languages,
        production_company_names,
        production_country_names,
        -- metrics
        vote_average,
        vote_count,
        iff(runtime != 0, runtime, null) as runtime,
        iff(budget != 0, budget, null) as budget_usd,
        iff(revenue != 0, revenue, null) as revenue_usd,
        -- datetime
        release_date as t_release_date,
        year(release_date) as t_release_year
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

select * 
from basic_cleanup
