WITH top_profit_movie_series AS (
    SELECT movie_series FROM {{ ref('top_ten_sequels_by_profit') }}
),
sequel_stats_by_rating AS (
    SELECT * FROM {{ ref('sequel_stats_by_rating') }}
)
,
top_movie_series as(
    select
        sr.*
    from top_profit_movie_series tms
    left join sequel_stats_by_rating sr
        on tms.movie_series = sr.movie_series
    order by avg_rating_for_series desc
)

select * from top_movie_series
