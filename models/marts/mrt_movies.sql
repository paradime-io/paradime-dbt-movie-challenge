with

movies as (
    select * from {{ ref('int_movies') }}
),

final as (
    select * from movies
)

select * from final
