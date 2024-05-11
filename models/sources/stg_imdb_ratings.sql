-- stg_imdb_ratings.sql
with source as (
    select
        tconst as imdb_id,
        averageRating as imdb_rating,
        numVotes as number_of_votes
    from {{ ref('imdb_ratings') }}
)

select *
from source