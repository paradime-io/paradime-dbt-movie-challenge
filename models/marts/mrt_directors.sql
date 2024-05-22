with

source as (
    select * from {{ ref('int_movies') }}
),

directors as (
    SELECT
        d.imdb_id,
        d.tmdb_id,
        t.value AS director
    FROM source d,
        LATERAL SPLIT_TO_TABLE(d.director, ',') t
),

final as (
    select * from directors
)

select * from final