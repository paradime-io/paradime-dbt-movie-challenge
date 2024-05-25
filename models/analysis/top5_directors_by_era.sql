with
    source as (
        select
            epoch,
            replace(value, '"', '') as director,
            ifnull(revenue_adj, 0) as revenue_adj
        from {{ ref('combined_omdb_and_tmdb')}} t1,
            table(flatten(directors))
    ),

    final as (
        select
            epoch,
            director,
            sum(revenue_adj) as revenue_adj
        from source
        group by 1, 2
    )

select
    epoch,
    director,
    revenue_adj
from final
qualify
    row_number() over (partition by epoch order by revenue_adj desc) <= 5