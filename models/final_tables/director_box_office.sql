select
    director,
    title,
    revenue
from {{ ref('joined_movies') }}