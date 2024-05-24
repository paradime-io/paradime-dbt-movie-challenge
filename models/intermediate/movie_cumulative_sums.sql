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
        budget,
        profit
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
    budget,
    sum(budget) over (partition by movie_series order by release_date) as cumulative_budget,
    profit,
    sum(profit) over (partition by movie_series order by release_date) as cumulative_profit,
    round(vote_average, 2) as vote_average,
    round(avg(vote_average) over (partition by movie_series order by release_date), 2) as cumulative_voting_average
from movies_with_sequels
order by movie_series, release_year