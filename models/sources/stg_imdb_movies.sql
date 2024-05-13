with 

source as (
    select 
        tconst as imdb_id, 
        titletype as type,
        primarytitle as primary_title,
        originaltitle as original_title,
        startyear as release_year,
        runtimeminutes as runtime_min,
        genres
    from {{ source('MOVIES_ADDITIONAL', 'IMDB_MOVIES') }}
)

select * 
from source
