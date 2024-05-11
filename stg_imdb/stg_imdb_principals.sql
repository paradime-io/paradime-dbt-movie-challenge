-- stg_imdb_principals.sql
with source as (
    select
        tconst as imdb_title_id,
        nconst as name_id,
        ordering,
        category,
        job,
        characters
    from {{ ref('imdb_principals') }}
)

select *
from source