-- actor_director_success.sql

with success as (
    select
        director_actor_key,
        director,
        actor,
        movie_occurence_count,
        avg_imdb_rating,
        avg_revenue,
        avg_runtime,
        avg_imdb_votes,
        avg_rt_rating,
        round((movie_occurence_count * 0.4305
        + avg_imdb_rating * 0.1721
        + avg_rt_rating * 0.1659
        + avg_revenue * 0.1599
        + avg_runtime * 0.0717
        + avg_imdb_votes * 0.00), 1) as combined_success
    from {{ ref('int_collaboration_network_features') }}

)

select * from success
