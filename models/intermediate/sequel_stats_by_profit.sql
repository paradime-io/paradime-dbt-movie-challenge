with
cleaned_movies as (
    select *
    from
        {{ref('clean_combined_movies')}}
    where movie_series_check = true
    order by movie_series, release_year
),

finalized_table as (
    select
        movie_series,
        count(*) as num_of_movies_in_series,
        sum(revenue) as total_revenue_per_series,
        sum(budget) as total_budget_for_series,
        sum(profit) as total_profit_for_series,
        sum(inf_revenue) as total_inf_revenue_per_series,
        sum(inf_budget) as total_inf_budget_for_series,
        sum(inf_profit) as total_inf_profit_for_series
    from cleaned_movies
    where budget != 0 or revenue != 0
    group by movie_series
    order by total_inf_profit_for_series desc
)
select * from finalized_table