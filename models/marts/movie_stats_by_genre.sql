with 

movies as (
    select *
    from {{ ref('movies') }}
),

genres as (
    select 
        imdb_id,
        genre
    FROM {{ ref('genres') }}
),

aggregate_by_genre as (
    select
        g.genre, 
        m.o_release_year as release_year,
        count(m.imdb_id) as nb_movies_per_genre
    from movies as m
    left join genres as g using (imdb_id)
    group by g.genre, release_year
),

top10 as (
    select
        genre,
        sum(nb_movies_per_genre) as total_movies
    from aggregate_by_genre
    group by genre
    order by total_movies desc
    limit 10
),

final as (
    select g.*
    from aggregate_by_genre as g
    inner join top10 as t using (genre)
)

select * 
from final
