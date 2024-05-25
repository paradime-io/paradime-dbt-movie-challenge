WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('sequel_stats_by_profit') }}
)

select * from movie_stats_by_sequels