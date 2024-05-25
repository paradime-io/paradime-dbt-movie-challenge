with
    revenue as (
        select
            epoch,
            replace(value, '"', '') as director,
            sum(revenue_adj) as total_revenue_adj
        from {{ ref('combined_omdb_and_tmdb') }},
            table(flatten(directors))
        where revenue_adj >= 100
        group by 1, 2
    ),

    ranked_directors as (
        select
            epoch,
            director,
            total_revenue_adj,
            total_revenue_adj / sum(total_revenue_adj) over (partition by epoch) as share_of_revenue,
            rank() over(partition by epoch order by total_revenue_adj) as revenue_rank
        from revenue
    )

select * from ranked_directors as t1
where
    t1.revenue_rank <= (select ceil(0.01 * count(*)) from ranked_directors as t2 where t1.epoch=t2.epoch)