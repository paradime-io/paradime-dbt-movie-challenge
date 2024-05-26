with unioned as (

    {{ dbt_utils.union_relations(
        relations = [
            ref('stg_tmdb__movies'),
            ref('stg_tmdb__tv_series')
        ])
    }}

),

languages as (
    select * from {{ ref('seed_standards__languages') }}
),


final as (

    select

        -- KEYS
        {{ dbt_utils.generate_surrogate_key([
            'unioned.tmdb_id',
            'unioned.media_type'
            ])
        }}                                      as record_key,

        unioned.tmdb_id                         as tmdb_id,
        unioned.imdb_id                         as imdb_id,


        -- MEDIA DETAILS
        unioned.title                           as title,
        unioned.description                     as description,
        unioned.tagline                         as tagline,
        unioned.genres                          as genres,
        unioned.status                          as status,
        unioned.release_date                    as release_date,
        unioned.release_year                    as release_year,
        unioned.media_type                      as media_type,


        /*
            Unlike the OMBb dataset, the TMDb data source's 'spoken_languages' array isn't
            always reliable for providing information on the languages spoken in a movie.
            The following logic converts ISO 639-1 language codes into language names (e.g.
            'EN' to 'English') and appends them to the 'spoken_languages' array.
        */

        iff(unioned.spoken_languages is null,
            array_construct(languages.language_name),
            array_distinct(array_prepend(
                unioned.spoken_languages,
                languages.language_name))
            )                                   as languages,

        unioned.production_companies            as production_companies,
        unioned.tmdb_score                      as tmdb_score,
        unioned.tmdb_vote_count                 as tmdb_vote_count,
        unioned.tmdb_url                        as tmdb_url,
        unioned.poster_url                      as poster_url,


        -- MOVIE DETAILS
        unioned.runtime_minutes                 as runtime_minutes,
        unioned.tags                            as tags,
        unioned.production_countries            as production_countries,
        unioned.budget_amount_usd               as budget_amount_usd,
        unioned.gross_revenue_amount_usd        as gross_revenue_amount_usd,
        unioned.imdb_url                        as imdb_url,
        unioned.homepage_url                    as homepage_url,
        unioned.backdrop_url                    as backdrop_url,
        unioned.does_belong_to_collection       as does_belong_to_collection,
        unioned.collection_name                 as collection_name,
        unioned.collection_poster_url           as collection_poster_url,


        -- TV SERIES DETAILS
        unioned.number_of_seasons               as number_of_seasons,
        unioned.number_of_episodes              as number_of_episodes,
        unioned.last_air_date                   as last_air_date,
        unioned.creators                        as creators

    from unioned

    left join languages
        on unioned.original_language_code = languages.language_code

)

select * from final
