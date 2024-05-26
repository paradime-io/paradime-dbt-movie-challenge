{{ config(tags=['lightdash']) }}


with tmdb_media as (
    select * from {{ ref('int_tmdb__media') }}
),

omdb_media as (
    select * from {{ ref('stg_omdb__movies') }}
),

inflation_adjustments as (
    select * from {{ ref('int_inflation_adjustments__yearly') }}
),

standard_country_names as (
    select * from {{ ref('seed_standards__country_names') }}
),


-- MODEL VARIABLES
{% set inflation_adjustment_year = 2024 %}

{% set common_columns = [
    'imdb_id',
    'title',
    'description',
    'genres',
    'release_date',
    'release_year',
    'media_type',
    'languages',
    'production_companies',
    'poster_url',
    'runtime_minutes',
    'production_countries',
    'gross_revenue_amount_usd',
    'imdb_url',
    'homepage_url'
    ]
%}


joined as (

    select

        /*
            TMDb data appears to be more accurate than OMDb data. Therefore, 
            for shared columns, TMDb data is prioritized by placing it first 
            in the 'coalesce()' function.
        */

        -- COMMON COLUMNS
        {% for column in common_columns %}


            coalesce(
                tmdb_media.{{ column }},
                omdb_media.{{ column }}) as {{ column }},

        {% endfor %}

        -- TMDb COLUMNS
        tmdb_media.tmdb_id,
        tmdb_media.tagline,
        tmdb_media.status,
        tmdb_media.tmdb_score,
        tmdb_media.tmdb_vote_count,
        tmdb_media.tmdb_url,
        tmdb_media.tags,
        tmdb_media.backdrop_url,
        tmdb_media.does_belong_to_collection,
        tmdb_media.collection_name,
        tmdb_media.collection_poster_url,
        tmdb_media.budget_amount_usd,
        tmdb_media.number_of_seasons,
        tmdb_media.number_of_episodes,
        tmdb_media.last_air_date,
        tmdb_media.creators,


        -- OMDb COLUMNS
        omdb_media.associated_tmdb_ids,
        omdb_media.film_rating,
        omdb_media.dvd_release_date,
        omdb_media.oscar_win_count,
        omdb_media.award_nomination_count,
        omdb_media.award_win_count,
        omdb_media.imdb_score,
        omdb_media.imdb_vote_count,
        omdb_media.metacritic_score_percent,
        omdb_media.rotten_tomatoes_percent

    from tmdb_media

    full join omdb_media
        on tmdb_media.imdb_id = omdb_media.imdb_id

),


/*
    The following CTE standardizes country names to a unified format
    Example: Values such 'US', 'USA', and 'United States of America'
    becomes unified 'United States'.

    Note: While this transformation (and some other transformations in
    this model) could have been performed in the upstream Staging layer,
    it has been implemented here to maintain a DRY codebase.
*/

countries_corrected as (

    select

        joined.tmdb_id,
        array_agg(standard_country_names.country_name) as production_countries

    from joined

    inner join lateral flatten(input => joined.production_countries) as country

    left join standard_country_names
        on lower(country.value) = standard_country_names.country_name_input

    group by all

),


final as (


    select


        /*
            To maintain data integrity, we are introducing a surrogate key composed
            of 'imdb_id', 'tmdb_id', and 'media_type' values. The 'media_type' field
            is essential because the same 'tmdb_id' can be shared across both 'Movies'
            and 'TV Series' in the TMDb database.

            Example:
                - https://www.themoviedb.org/movie/220387 Blogumentary (2004)
                - https://www.themoviedb.org/tv/220387 Camp Radio (2022)
        */

        {{ dbt_utils.generate_surrogate_key([
            'joined.imdb_id',
            'joined.tmdb_id',
            'joined.media_type'
            ])
        }}                                         as record_key,

        joined.imdb_id                             as imdb_id,
        joined.tmdb_id                             as tmdb_id,


        -- MEDIA DETAILS
        joined.media_type                          as media_type,
        joined.title                               as title,
        joined.description                         as description,
        joined.tagline                             as tagline,
        joined.genres                              as genres,
        joined.release_date                        as release_date,
        joined.release_year                        as release_year,
        joined.dvd_release_date                    as dvd_release_date,
        joined.runtime_minutes                     as runtime_minutes,
        joined.languages                           as languages,
        joined.tags                                as tags,
        joined.film_rating                         as film_rating,


        -- PRODUCTION DETAILS
        joined.production_companies                as production_companies,
        countries_corrected.production_countries   as production_countries,
        joined.status                              as status,
        joined.budget_amount_usd                   as budget_amount_usd,
        joined.gross_revenue_amount_usd            as gross_revenue_amount_usd,


        /*
            Adjusting movie budget and gross revenue amount for inflation to provide
            a fair comparison of a film's financial performance across different years.

            Example: The movie 'Titanic' (1997) earned approximately $2.26 billion
            worldwide. Adjusted for inflation, this would be $4.35 billion in 2024.
        */

        iff(year(joined.release_year) < {{ inflation_adjustment_year }},
            joined.budget_amount_usd * inflation_adjustments.cpi_ratio,
            joined.budget_amount_usd
            )::number(38, 2)                       as budget_usd_{{ inflation_adjustment_year }}_adjusted,

        iff(year(joined.release_year) < {{ inflation_adjustment_year }},
            joined.gross_revenue_amount_usd * inflation_adjustments.cpi_ratio,
            joined.gross_revenue_amount_usd
            )::number(38, 2)                       as gross_revenue_usd_{{ inflation_adjustment_year }}_adjusted,


        -- TV SERIES DETAILS
        joined.number_of_seasons                   as number_of_seasons,
        joined.number_of_episodes                  as number_of_episodes,
        joined.last_air_date                       as last_air_date,
        joined.creators                            as creators,


        -- URL LINKS
        joined.homepage_url                        as homepage_url,
        joined.imdb_url                            as imdb_url,
        joined.tmdb_url                            as tmdb_url,
        joined.poster_url                          as poster_url,
        joined.backdrop_url                        as backdrop_url,
        joined.collection_poster_url               as collection_poster_url,


        -- SCORES & AWARDS
        joined.oscar_win_count                     as oscar_win_count,
        joined.award_nomination_count              as award_nomination_count,
        joined.award_win_count                     as award_win_count,
        joined.tmdb_score                          as tmdb_score,
        joined.tmdb_vote_count                     as tmdb_vote_count,
        joined.imdb_score                          as imdb_score,
        joined.imdb_vote_count                     as imdb_vote_count,
        joined.metacritic_score_percent            as metacritic_percent,
        joined.rotten_tomatoes_percent             as rotten_tomatoes_percent,


        -- COLLECTION DETAILS
        joined.does_belong_to_collection           as does_belong_to_collection,
        joined.collection_name                     as collection_name

    from joined

    left join inflation_adjustments
        on year(joined.release_year) = inflation_adjustments.price_year
        and inflation_adjustments.target_year = {{ inflation_adjustment_year }}

    left join countries_corrected
        on joined.tmdb_id = countries_corrected.tmdb_id

)

select * from final
