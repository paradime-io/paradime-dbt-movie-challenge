-- actor_director_success.sql

with avg_success_metrics as (
    select
        director_actor_key,
        director,
        actor,
        avg(imdb_rating) as avg_imdb_rating,
        avg(revenue) as avg_revenue,
        count(distinct imdb_id) as movie_occurence_count,
        count(distinct genre) as distinct_genre_count
    from {{ ref('int_collaboration_network_actor_director') }}
    group by 1, 2, 3
    order by 5 desc, 4 desc

),

highest_combined_success as (
    select
        director_actor_key,
        director,
        actor,
        movie_occurence_count,
        distinct_genre_count,
        round(avg_imdb_rating,1) as avg_imdb_rating,
        round(avg_revenue,1) as avg_revenue,
        -- Normalize and combine success metrics together
        round(
            avg_imdb_rating / 10.0
            + avg_revenue / (select max(avg_revenue) from avg_success_metrics)
            + movie_occurence_count / (select max(movie_occurence_count) from avg_success_metrics)
            + distinct_genre_count / (select max(distinct_genre_count) from avg_success_metrics)
        , 2) as combined_succes_metric
    from avg_success_metrics
    where movie_occurence_count > 1
    order by combined_succes_metric desc
),

movies as (
    select c.*
    from avg_success_metrics as a
        left join {{ ref('int_collaboration_network_actor_director') }} as c
            on a.director_actor_key = c.director_actor_key
    where a.director_actor_key = '4442c5366e6a12c4491ce83142d2ad64'
)


select * from highest_combined_success
