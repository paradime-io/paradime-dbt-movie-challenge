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
        avg_combined_rotten_tomato_rating,
        round((movie_occurence_count
        + avg_imdb_rating
        + avg_combined_rotten_tomato_rating
        + avg_number_of_awards_won
        + avg_viewer_vote_average
        + avg_viewer_vote_count
        + avg_revenue
        ), 1) as combined_success
    from {{ ref('int_collaboration_network_features') }}

)

select * from success
