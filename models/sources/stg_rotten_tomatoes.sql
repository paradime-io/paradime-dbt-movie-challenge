-- stg_rotten_tomatoes.sql
with source as (
    select
        id as rotten_tomatoes_id,
        title,
        audienceScore as audience_score,
        tomatoMeter as tomato_meter,
        runtimeMinutes as runtime_minutes,
        genre as genre,
        boxOffice as box_office
    from {{ ref('rotten_tomatoes_ratings') }}
)

select *
from source
