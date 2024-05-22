with

source as (
    select * from {{ ref('int_movies') }}
),

actors as (
    SELECT
        m.imdb_id,
        m.tmdb_id,
        t.value AS actor
    FROM source m,
        LATERAL SPLIT_TO_TABLE(m.actors, ',') t
),

final as (
    select * from actors
)

select * from final