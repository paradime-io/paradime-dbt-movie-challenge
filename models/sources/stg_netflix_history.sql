WITH netflix_history AS (
    select *
    from {{ source('NETFLIX', 'RAW_NETFLIX_USER_HISTORY') }}
)

select 
    *
from netflix_history