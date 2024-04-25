with source as (
    select 
        *
    from {{ source('MOVIE_CHALLENGE_EXTRA', 'DOMESTIC_BOX_OFFICE') }}
)

select *
from source