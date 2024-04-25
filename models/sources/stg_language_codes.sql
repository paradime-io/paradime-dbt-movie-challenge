with source as (
    select 
        *
    from {{ source('MOVIE_CHALLENGE_EXTRA', 'LANGUAGE_CODES') }}
)

select *
from source