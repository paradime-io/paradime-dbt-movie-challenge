with 

source as (
    select
        imdb_id, 
        person_id, 
        category
    from {{ ref('stg_imdb__movie_people') }}
),

selected_movies as (
    select
        imdb_id
    from {{ ref('int_omdb_tmdb_imdb_filtered') }}
),

-- get people's info only for the movies we want to analyze
filtered as (
    select s.*
    from selected_movies as m
    inner join source as s using (imdb_id)
),

categorized as (
    select 
        imdb_id, 
        person_id, 
        case 
            when category in ('self', 'actress', 'actor') then 'acting'
            else category
        end as category        
    from filtered
)

select * 
from categorized
