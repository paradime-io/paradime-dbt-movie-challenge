select
    imdb_id,
    title,
    release_date,
    runtime
from {{ ref('joined_movies') }}
where genre not like '%Short%'
and imdb_votes >= 10000