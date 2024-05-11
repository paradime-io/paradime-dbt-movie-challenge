-- int_collaboration_network_features.sql

with success_features as (
    select
        director_actor_key,
        director,
        actor,
        count(distinct imdb_id) as movie_occurence_count,
        avg(imdb_rating) as avg_imdb_rating,
        avg(imdb_votes) as avg_imdb_votes,
        avg(revenue) as avg_revenue,
        avg(rt_rating) as avg_rt_rating
    from {{ ref('int_collaboration_network_actor_director') }}
    group by 1, 2, 3

)

select * from success_features
