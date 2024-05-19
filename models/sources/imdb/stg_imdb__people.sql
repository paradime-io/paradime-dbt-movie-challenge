with 

source as (
    select 
        nconst as person_id, 
        primaryname as person_name,
        birthyear as birth_year,
        deathyear as death_year
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_PEOPLE') }}
    where primaryname is not null
)

select * 
from source
