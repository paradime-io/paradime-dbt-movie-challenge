-- movie_success_yearly.sql

with final as (
    select 
        date_trunc('year', release_date) as release_year,
        count(distinct imdb_id) as movie_count,
        avg(combined_success_rating) as avg_combined_success_rating
    from {{ ref('int_combined_movie_success') }}
    group by 1
)

select * from final
