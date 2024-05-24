WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('movie_stats_by_sequels') }}
)
,
final as(
    select
        *
    from movie_stats_by_sequels
    order by total_profit_for_series asc
    limit 10
)
select * from final