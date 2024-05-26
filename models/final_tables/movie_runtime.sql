select
    imdb_id,
    title,
    release_date,
    extract(YEAR FROM release_date) as release_year,
    runtime
from {{ ref('joined_movies') }}
where genre not like '%Short%'
and imdb_votes >= 10000