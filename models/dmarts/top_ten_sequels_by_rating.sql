WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('sequel_stats_by_rating') }}
)
,
top_movie_series as(
    select
        *
    from movie_stats_by_sequels
    order by avg_rating_for_series desc
    limit 10
)

select * from top_movie_series