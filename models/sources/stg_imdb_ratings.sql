-- stg_imdb_ratings.sql
with source as (
    select
        tconst as imdb_title_id,
        averagerating as imdb_rating,
        numvotes as number_of_votes
    from {{ ref('imdb_ratings') }}
)

select *
from source
