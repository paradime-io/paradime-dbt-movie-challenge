with 

source as (
    select
        tconst as imdb_id, 
        averagerating as rating_avg, 
        numvotes as nb_votes
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_RATINGS') }}
)

select * 
from source
