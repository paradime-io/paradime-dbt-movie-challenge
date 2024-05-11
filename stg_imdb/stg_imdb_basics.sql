-- stg_imdb_ratings.sql
-- stg_imdb_basics.sql
with source as (
    select
        tconst as imdb_title_id,
        titleType as title_type,
        primaryTitle as primary_title,
        originalTitle as original_title,
        genres,
        isAdult as is_adult,
        startYear as start_year,
        endYear as end_year,
        runtimeMinutes as runtime_minutes,
        averageRating as imdb_rating,
        numVotes as number_of_votes
    from {{ ref('imdb_basics') }}
)

select *
from source