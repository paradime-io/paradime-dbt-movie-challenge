-- actor_director_success.sql

with success as (
    select
        director_actor_key,
        director,
        actor,
        movie_occurence_count,
        avg_imdb_rating,
        avg_revenue,
        avg_imdb_votes,
        avg_rt_rating,
        round((movie_occurence_count * 0.3485
        + avg_imdb_rating * 0.2338
        + avg_imdb_votes * 0.1999
        + avg_revenue * 0.1635
        + avg_rt_rating * 0.0543), 1) as combined_success
    from {{ ref('int_collaboration_network_features') }}

)

select * from success
