WITH
inflation_rates AS (
    SELECT
        year,
        inflation_factor_to_2024
    FROM {{ ref('historical_inflation_factor') }}
),

movie_monetary AS (
    SELECT
        tmdb_id,
        release_year,
        revenue,
        budget,
        profit
    FROM {{ ref('clean_combined_movies') }}
    where release_year is not null
),
join_table as(
    select
        mm.*,
        round(mm.revenue*ir.inflation_factor_to_2024,0) as inf_revenue,
        round(mm.budget*ir.inflation_factor_to_2024,0) as inf_budget,
        round(mm.profit*ir.inflation_factor_to_2024,0) as inf_profit,
    from movie_monetary mm
    left join inflation_rates ir
        on mm.release_year = ir.year
)

--  select
--      *,
--      round(revenue*inflation_factor_to_2024,0) as inf_revenue,
--      round(budget*inflation_factor_to_2024,0) as inf_budget,
--      round(profit*inflation_factor_to_2024,0) as inf_profit,
--  from join_table
--  where profit != 0

select * from join_table where profit != 0