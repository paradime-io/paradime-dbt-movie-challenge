WITH movie_stats_by_sequels AS (
    SELECT * FROM {{ ref('movie_stats_by_sequels') }}
)
,
top_movie_series as(
    select
        avg_rating_for_series,
        movie_series
    from movie_stats_by_sequels
    --  group by movie_series
    order by avg_rating_for_series desc
    limit 10
)

top_movie_series_movie_ids as(
    select 
        mcs.*
    from top_movie_series tms
    left join movie_cumulative_sums mcs
        on tms.movie_series = mcs.movie_series

)

select * from top_movie_series