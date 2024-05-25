WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('sequel_stats_by_profit') }}
)
,
final as(
    select
        *
    from movie_stats_by_sequels
    order by total_inf_profit_for_series desc
    limit 10
)
select * from final