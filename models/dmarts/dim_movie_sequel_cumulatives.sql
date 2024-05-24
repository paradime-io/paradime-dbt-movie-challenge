WITH movie_cumulative_sums AS (
    SELECT * FROM {{ ref('movie_cumulative_sums') }}
)
select * from movie_cumulative_sums