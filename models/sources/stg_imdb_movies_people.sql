with 

source as (
    select
        tconst as imdb_id, 
        nconst as person_id, 
        category,
        job
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_MOVIES_PEOPLE') }}
)

select * 
from source
