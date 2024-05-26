with 

movies as (
    select *
    from {{ ref('int_omdb_tmdb_imdb_joined') }}
),

-- get only released filtering out canceled movies, movies expected to be released, etc.
filtered as (
    select *
    from movies
    where i_type = 'movie'
        and t_status = 'Released' 
        -- movies cannot be 'Released' and be in the future
        and o_release_year <= year(current_date())
        -- remove data point with data quality issues:
        and imdb_id != 'tt0345819'
),

filter_data as (
    select 
        -- ids
        imdb_id,
        tmdb_id,
        -- dimensions
        t_movie_title,
        t_keywords,
        o_production,
        o_dvd,
        o_metascore,
        case
            when o_country like '%USA%' then replace(o_country, 'USA', 'United States')
            else o_country
        end as o_country,
        -- metrics
        o_rating_avg,
        o_nb_votes,
        t_runtime,
        t_rating_avg,
        t_revenue_usd,
        t_budget_usd,
        -- date/datetime
        o_release_date,
        o_release_year,
        t_release_date
    from filtered
    where t_budget_usd is not null and t_revenue_usd is not null 
        and t_runtime is not null and o_release_date is not null
        and o_country is not null and year(o_release_date) >= {{ var('start_year') }} 
        and year(o_release_date) <= {{ var('end_year') }} 
)

SELECT *
FROM filter_data
