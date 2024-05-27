/* unique combinations of (principal) actors */

with actors as (
    SELECT *
    FROM {{ ref('acting_roles') }}
)

select 
    actors.imdb_id
    , actors.actor
    , costar.actor as costar_actor
from actors
left join actors as costar
on actors.imdb_id = costar.imdb_id
and actors.actor != costar.actor 
where costar_actor is not null
