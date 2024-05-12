-- movie_success.sql

with final as (
    select *
    from {{ ref('int_combined_movie_success') }}
)

select * from final
