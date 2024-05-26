with 

movies as (
    select *
    from {{ ref('movies') }}
),

aggregate_by_country as (
    select
        o_country as country,
        year(o_release_date) as release_year,
        count(imdb_id) as nb_movies_per_country,
        sum(adjusted_budget_usd) as total_adjusted_budget_usd,
        sum(adjusted_revenue_usd) as total_adjusted_revenue_usd,
        sum(adjusted_profit_usd) as total_adjusted_profit_usd
    from movies
    group by country, release_year
),

top10 as (
    select
        country,
        sum(nb_movies_per_country) as total_movies
    from aggregate_by_country
    group by country
    order by total_movies desc
    limit 10
),

final as (
    select c.*
    from aggregate_by_country as c
    inner join top10 as t using (country)
)

select * 
from final
