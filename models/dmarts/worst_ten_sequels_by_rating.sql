WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('sequel_stats_by_rating') }}
)
,
final as(
    select
        *
    from movie_stats_by_sequels
    order by avg_rating_for_series asc
    limit 10
)

select * from final