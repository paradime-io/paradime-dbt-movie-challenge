WITH m AS (
    SELECT * FROM {{ ref('inter_movies_genre_pivot') }}
)
,
nmp as (
    select * from {{ref('inter_num_movies_per_year')}}
)

select
    m.*,
    nmp.total_movies
from m
left join nmp
    on m.release_year = nmp.release_year