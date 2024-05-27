with tmdb as (
    SELECT *
    FROM {{ ref('stg_tmdb_tv_series') }}
), 

netflix_titles as (
    select *
    from {{ ref('stg_netflix_titles') }}
    where content_type = 'tv'
)

select distinct
*

-- remove dates of watching
from tmdb
full outer join netflix_titles
on tmdb.name = netflix_titles.title 
and year(tmdb.first_air_date) = netflix_titles.year
where netflix_titles.title_id is not null

