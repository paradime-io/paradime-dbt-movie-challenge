with inter_movies_genre as (
    select * from {{ref('inter_movies_genre')}}
) 

select
    release_year,
    count(*) as total_movies,
from inter_movies_genre
group by release_year