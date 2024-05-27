/* unique combinations of (principal) actor x film combinations */

with omdb as (
    SELECT distinct *
    FROM {{ ref('stg_omdb_movies') }}
)

select 
    imdb_id
    , trim(value) as actor
    , md5(imdb_id || actor) as acting_role_id
from omdb, lateral flatten(parse_json(to_json(STRTOK_TO_ARRAY(actors, ',')))) as actors
where actor != 'N/A'
and actor is not null