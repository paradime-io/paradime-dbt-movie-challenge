WITH
clean_movies AS (
    SELECT *
    FROM {{ ref('clean_combined_movies')}}
    where 
        inf_revenue != 0 and
        inf_budget != 0 and
        runtime > 40 
),
non_sequel_top_profits as(
    select
        tmdb_id,
        imdb_id,
        movie_series_check,
        movie_series,
        title,
        release_date,
        release_year,
        vote_average,
        inf_revenue,
        inf_budget,
        inf_profit
    from clean_movies
    where
        movie_series_check = false
    order by inf_profit desc
    limit 10
),
sequel_top_profits as(
    select
        tmdb_id,
        imdb_id,
        movie_series_check,
        movie_series,
        title,
        release_date,
        release_year,
        vote_average,
        inf_revenue,
        inf_budget,
        inf_profit
    from clean_movies
    where
        movie_series_check = true
    order by inf_profit desc
    limit 10
)


select * from non_sequel_top_profits
UNION
select * from sequel_top_profits
