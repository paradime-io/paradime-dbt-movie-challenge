-- actor_director_success.sql

with final as (
    select
        director_actor_key,
        director,
        actor,
        count(distinct imdb_id) as movie_occurence_count,
        avg(imdb_rating) as avg_imdb_rating,
        avg(imdb_votes) as avg_imdb_votes,
        avg(combined_rotten_tomato_rating) as avg_combined_rotten_tomato_rating,
        avg(number_of_awards_won) as avg_number_of_awards_won,
        avg(viewer_vote_average) as avg_viewer_vote_average,
        avg(viewer_vote_count) as avg_viewer_vote_count,
        avg(revenue) as avg_revenue,
        avg(normalized_revenue) as avg_normalized_revenue,
        avg(combined_success_rating) as avg_combined_success_rating
    from {{ ref('int_collaboration_network_actor_director') }}
    group by 1, 2, 3

)

select * from final
