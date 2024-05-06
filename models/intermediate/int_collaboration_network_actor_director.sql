with collaborations as (
    select
        {{ dbt_utils.generate_surrogate_key(['d.value', 'a.value']) }} as director_actor_key,
        trim(d.value) as director,
        trim(a.value) as actor,  -- Cleaning up any extra spaces around actor names
        m.imdb_id,
        m.title,
        m.imdb_rating
    from
        {{ ref('int_movies_mapping') }} as m,
        lateral flatten(input => split(director, ',')) as d,
        lateral flatten(input => split(actors, ',')) as a  -- Splitting and flattening the actor list
    where
        m.director is not null and m.director != 'N/A'
        and m.actors is not null and m.actors != 'N/A'
        and m.imdb_rating between 0 and 10
        and m.imdb_id is not null
    group by
        1, 2, 3, 4, 5, 6
),

avg_ratings as (
    select
        director_actor_key,
        director,
        actor,
        avg(imdb_rating) as avg_imdb_rating,
        count(distinct imdb_id) as movie_occurence_count
    from collaborations
    group by 1, 2, 3
    order by 5 desc, 4 desc
),

movies as (
    select c.*
    from avg_ratings as a
        left join collaborations as c
            on a.director_actor_key = c.director_actor_key
    where a.director_actor_key = '3346fd7be1df7e13d4748d539ea96b9e'
)


select * from avg_ratings
