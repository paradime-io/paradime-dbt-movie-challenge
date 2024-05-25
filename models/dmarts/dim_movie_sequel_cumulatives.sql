WITH movie_cumulative_sums AS (
    SELECT * FROM {{ ref('movie_cumulative_sums') }}
),
top_movie_series as(
    select
        sum(inf_profit),
        movie_series
    from movie_cumulative_sums
    group by movie_series
    order by sum(inf_profit) desc
    limit 10
),

top_movie_series_movie_ids as(
    select 
        mcs.*
    from top_movie_series tms
    left join movie_cumulative_sums mcs
        on tms.movie_series = mcs.movie_series

)

select * from top_movie_series_movie_ids