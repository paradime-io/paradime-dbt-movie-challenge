with

source as (
    select * from {{ ref('int_movies') }}
),

final as (
    select * from source
)

select * from final