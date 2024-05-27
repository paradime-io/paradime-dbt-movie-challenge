WITH
clean_movies AS (
    SELECT *
    FROM {{ ref('clean_combined_movies')}}
    where 
        inf_revenue != 0 and
        inf_budget != 0 and
        runtime > 40 
),
final as (
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
    order by vote_average desc
    limit 20
)
select * from final