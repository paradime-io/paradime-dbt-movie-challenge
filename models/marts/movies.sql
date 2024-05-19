with 

movies as (
    select * 
    from {{ ref('int_omdb_and_tmdb_movies_released_filtered') }}
),

financial as (
    select *
    from {{ ref('int_financial_metrics') }}
),

-- get most up-to-date cpi available in the data
movies_summary as (
    select 
        m.imdb_id,
        f.movie_year,
        f.adjusted_budget_usd,
        f.adjusted_revenue_usd
    from movies as m 
    left join financial as f on m.imdb_id = f.imdb_id
)

SELECT * 
FROM movies_summary
