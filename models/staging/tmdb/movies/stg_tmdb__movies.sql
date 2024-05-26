with source as (
    select * from {{ source('tmdb', 'movies') }}
),

final as (

    select

        -- KEYS
        source.tmdb_id::string                                  as tmdb_id,
        nullif(source.imdb_id, '')                              as imdb_id,
        source.belongs_to_collection:id::string                 as collection_id,


        -- MOVIE DETAILS
        source.title                                            as title,
        source.original_title                                   as original_title,
        nullif(source.overview, '')                             as description,
        iff(source.video, 'Video', 'Movie')                     as media_type,
        nullif(source.tagline, '')                              as tagline,
        split(source.genre_names, ', ')                         as genres,
        nullif(source.runtime, 0)                               as runtime_minutes,
        source.release_date                                     as release_date,
        date_trunc('year', source.release_date)                 as release_year,
        split(source.keywords, ', ')                            as tags,
        upper(nullif(source.original_language, 'xx'))           as original_language_code,
        split(source.spoken_languages, ', ')                    as spoken_languages,
        split(source.production_country_names, ', ')            as production_countries,
        split(source.production_company_names, ', ')            as production_companies,
        source.status = 'Released'                              as is_released,
        source.status                                           as status,
        nullif(source.budget, 0)::number(38, 2)                 as budget_amount_usd,
        nullif(source.revenue, 0)::number(38, 2)                as gross_revenue_amount_usd,


        -- SCORE DETAIL
        nullif(source.vote_average, 0)                          as tmdb_score,
        nullif(source.vote_count, 0)                            as tmdb_vote_count,


        -- URL LINKS
        concat('https://www.themoviedb.org/movie/',
            source.tmdb_id)                                     as tmdb_url,

        concat('https://www.imdb.com/title/',
            nullif(source.imdb_id, ''))                         as imdb_url,

        source.homepage                                         as homepage_url,

        concat('https://image.tmdb.org/t/p/w1280',
            source.poster_path)                                 as poster_url,

        concat('https://image.tmdb.org/t/p/w1280',
            source.backdrop_path)                               as backdrop_url,


        -- COLLECTION DETAILS
        source.belongs_to_collection:id is not null             as does_belong_to_collection,
        source.belongs_to_collection:name::string               as collection_name,

        concat('https://image.tmdb.org/t/p/w1280',
            source.belongs_to_collection:backdrop_path)         as collection_backdrop_url,

        concat('https://image.tmdb.org/t/p/w1280',
            source.belongs_to_collection:poster_path)           as collection_poster_url

    from source

)

select * from final
