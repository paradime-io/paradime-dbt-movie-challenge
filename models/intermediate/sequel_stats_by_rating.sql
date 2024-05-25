with
cleaned_movies as (
    select *
    from
        {{ref('clean_combined_movies')}}
    where movie_series_check = true
    order by movie_series, release_year
),

finalized_table as (
    select
        movie_series,
        count(*) as num_of_movies_in_series,
        round(avg(vote_average), 2) as avg_rating_for_series
    from cleaned_movies
    group by movie_series
    having num_of_movies_in_series > 1
    order by avg_rating_for_series desc
)
select * from finalized_table