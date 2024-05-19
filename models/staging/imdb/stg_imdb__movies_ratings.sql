with 

source as (
    select
        tconst as imdb_id, 
        averagerating as avg_rating, 
        numvotes as nb_votes
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_RATINGS') }}
)

select * 
from source
