-- actor_director_success.sql

with most_successfull_movie as (
    select
        director_actor_key,
        title
    from (
        select
            director_actor_key,
            title,
            row_number() over (partition by director_actor_key order by combined_success_rating desc) as rn
        from {{ ref('int_collaboration_network_actor_director') }}
    ) as ranked
    where rn = 1
),



final as (
    select
        ad.director_actor_key,
        ad.director,
        ad.actor,
        sm.title as best_movie_of_director_actor,
        count(distinct ad.imdb_id) as movie_occurence_count,
        round(avg(ad.imdb_rating), 0) as avg_imdb_rating,
        round(avg(ad.imdb_votes), 0) as avg_imdb_votes,
        round(avg(ad.combined_rotten_tomato_rating), 0) as avg_combined_rotten_tomato_rating,
        round(avg(ad.number_of_awards_won), 0) as avg_number_of_awards_won,
        round(avg(ad.viewer_vote_average), 0) as avg_viewer_vote_average,
        round(avg(ad.viewer_vote_count), 0) as avg_viewer_vote_count,
        round(avg(ad.revenue), 0) as avg_revenue,
        round(avg(ad.normalized_revenue), 0) as avg_normalized_revenue,
        round(avg(ad.combined_success_rating), 0) as avg_combined_success_rating

    from {{ ref('int_collaboration_network_actor_director') }} as ad
        left join most_successfull_movie as sm
            on ad.director_actor_key = sm.director_actor_key
    group by 1, 2, 3, 4

)

select * from final
