-- stg_imdb_crew.sql
with source as (
    select
        tconst as imdb_title_id,
        directors,
        writers
    from {{ ref('imdb_crew') }}
)

select *
from source