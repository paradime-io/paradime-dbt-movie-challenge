{{
    config(
        enable=false
    )
}}

with
    source as (
        select
            epoch,
            tmdb_id,
            replace(d.value, '"', '') as director,
            replace(a.value, '"', '') as actor
        from {{ ref('combined_omdb_and_tmdb')}},
            table(flatten(directors)) d,
            table(flatten(actors)) a
    ),

    director_degree as (
        select
            director,
            count(distinct tmdb_id) as total_movies,
            count(distinct actor) as total_actors
        from source
        group by 1
    )

select * from director_degree