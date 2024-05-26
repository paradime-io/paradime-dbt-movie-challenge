with source as (
    select * from {{ source('tmdb', 'tv_series') }}
),

final as (

    select

        -- KEYS
        source.id::string                               as tmdb_id,


        -- TV SERIES DETAILS
        source.name                                     as title,
        source.overview                                 as description,
        'TV Series'                                     as media_type,
        nullif(source.tagline, '')                      as tagline,
        source.status                                   as status,
        split(source.genre_names, ', ')                 as genres,
        nullif(source.number_of_seasons, 0)             as number_of_seasons,
        nullif(source.number_of_episodes, 0)            as number_of_episodes,
        source.first_air_date                           as release_date,
        date_trunc('year', source.first_air_date)       as release_year,
        source.last_air_date                            as last_air_date,
        source.status = 'Ended'                         as has_ended,
        source.in_production                            as is_in_production,
        upper(nullif(source.original_language, 'xx'))   as original_language_code,


        -- SCORE DETAIL
        source.popularity                               as tmdb_popularity,
        nullif(source.vote_average, 0)                  as tmdb_score,
        nullif(source.vote_count, 0)                    as tmdb_vote_count,


        -- URL LINKS
        concat('https://www.themoviedb.org/tv/',
            source.id)                                  as tmdb_url,

        concat('https://image.tmdb.org/t/p/w1280',
            source.poster_path)                         as poster_url,

        split(source.created_by_names, ', ')            as creators,
        split(source.production_company_names, ', ')    as production_companies


    from source

)

select * from final
