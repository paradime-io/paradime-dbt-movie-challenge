-- int_collaboration_network_features.sql

with success_features as (
    select
        director_actor_key,
        director,
        actor,
        count(distinct imdb_id) as movie_occurence_count,
        avg(imdb_rating) as avg_imdb_rating,
        avg(imdb_votes) as avg_imdb_votes,
        avg((omdb_rt_rating + audience_score + tomato_meter) / 3) as avg_combined_rotten_tomato_rating,
        avg(number_of_awards_won) as avg_number_of_awards_won,
        avg(viewer_vote_average) as avg_viewer_vote_average,
        avg(viewer_vote_count) as avg_viewer_vote_count,
        avg(revenue) as avg_revencue,
    from {{ ref('int_collaboration_network_actor_director') }}
    group by 1, 2, 3

)

select * from success_features
