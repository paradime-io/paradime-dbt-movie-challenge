with 

source as (
    select 
        tconst as imdb_id, 
        directors,
        writers
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_CREW') }}
)

select * 
from source
