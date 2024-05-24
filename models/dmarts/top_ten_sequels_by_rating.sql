WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('movie_stats_by_sequels') }}
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