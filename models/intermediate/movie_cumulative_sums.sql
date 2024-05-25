WITH

clean_combined_movies AS (
    SELECT * FROM {{ ref('clean_combined_movies') }}
),
movies_with_sequels as(
    select
        movie_series,
        tmdb_id,
        title,
        release_date,
        release_year,
        vote_average,
        vote_count,
        revenue,
        inf_revenue,
        budget,
        inf_budget,
        profit,
        inf_profit
    from clean_combined_movies
    where movie_series is not null
    order by movie_series, release_year
)
select 
    movie_series,
    title,
    release_date,
    release_year,
    revenue,
    sum(revenue) over (partition by movie_series order by release_date) as cumulative_revenue,
    inf_revenue,
    sum(inf_revenue) over (partition by movie_series order by release_date) as cumulative_inf_revenue,
    budget,
    sum(budget) over (partition by movie_series order by release_date) as cumulative_budget,
    inf_budget,
    sum(inf_budget) over (partition by movie_series order by release_date) as cumulative_inf_budget,
    profit,
    sum(profit) over (partition by movie_series order by release_date) as cumulative_profit,
    inf_profit,
    sum(inf_profit) over (partition by movie_series order by release_date) as cumulative_inf_profit,
    round(vote_average, 2) as vote_average,
    round(avg(vote_average) over (partition by movie_series order by release_date), 2) as cumulative_voting_average
from movies_with_sequels
order by movie_series, release_year