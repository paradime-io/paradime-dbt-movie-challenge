WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('movie_stats_by_sequels') }}
)
select * from movie_stats_by_sequels