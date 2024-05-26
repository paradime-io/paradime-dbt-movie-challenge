select
    director,
    title,
    revenue
from {{ ref('joined_movies') }}
where revenue is not null
and revenue <> 0