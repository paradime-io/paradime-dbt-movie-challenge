-- stg_imdb_name_basics.sql
with source as (
    select
        nconst as name_id,
        primaryName as primary_name,
        birthYear as start_year,
        deathYear as end_year,
    from {{ ref('imdb_name_basics') }}
)

select *
from source