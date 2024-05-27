with netflix_titles as (
    select *
    from {{ ref('stg_netflix_titles') }}
)

/* 
    Each title has an array of moods. There's a potential for high cardinality.
    Let's just instead treat each mood as observations.
*/

select 
    title_id
    , value as mood
from netflix_titles, lateral flatten(parse_json(to_json(STRTOK_TO_ARRAY(moods, ', ')))) as mood
