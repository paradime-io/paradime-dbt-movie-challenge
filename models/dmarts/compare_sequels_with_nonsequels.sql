WITH
clean_movies AS (
    SELECT * FROM {{ ref('clean_combined_movies') }}
),
final as(
    select
        tmdb_id,
        imdb_id,
        movie_series_check,
        movie_series,
        title,
        release_date,
        release_year,
        vote_average,
        imdb_rating,
        imdb_votes,
        revenue,
        budget,
        profit

    from clean_movies
    where
        revenue != 0 and
        budget != 0 and
        runtime > 40
),
calc_1 as(
    select 
        movie_series_check,
        round(avg(profit),0) as average_profit,
        round(avg(revenue),0) as average_revenue,
        round(avg(budget),0) as average_budget,
        round(avg(imdb_rating),2) as average_imdb_rating,
        round(avg(vote_average),2) as average_rating
    from final
    group by movie_series_check
)
select * from calc_1
--  select 
--      movie_series_check,
--      (profit - avg(profit))/(stddev_samp(profit)) as normalized_profit
--  from final
--  group by movie_series_check
