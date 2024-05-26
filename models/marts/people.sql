with 

source as (
    select
        person_id, 
        person_name,
        birth_year,
        death_year
    from {{ ref('stg_imdb__people') }}
),

movies as (
    select 
        person_id,
        count(distinct(imdb_id)) as nb_movies_worked
    from {{ ref('movie_people') }}
    group by person_id
),

filtered as (
    select 
        s.*,
        m.nb_movies_worked,
        dense_rank() over (order by m.nb_movies_worked desc) as movies_worked_rank
    from movies as m
    inner join source as s using (person_id)
)

select * 
from filtered
