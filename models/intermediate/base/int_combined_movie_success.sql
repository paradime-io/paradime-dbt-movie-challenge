-- int_combined_movie_success.sql

with success_metrics as (
    select
        imdb_id,
        original_title,
        title,
        genre,
        language,
        director,
        actors,
        runtime,
        release_date,

        -- Success metrics
        imdb_rating,
        imdb_votes,
        round((coalesce(omdb_rt_rating, 0) + coalesce(audience_score, 0) + coalesce(tomato_meter, 0)) / 3, 0) as combined_rotten_tomato_rating,
        number_of_awards_won,
        viewer_vote_average,
        viewer_vote_count,
        revenue,
        normalized_revenue,
        {{ calculate_combined_success_rating(
            imdb_rating_weight=2,
            imdb_votes_weight=2,
            combined_rotten_tomato_rating_weight=1,
            number_of_awards_won_weight=1,
            viewer_vote_average_weight=0.3,
            viewer_vote_count_weight=0.3,
            normalized_revenue_weight=0.1
        ) }},
        -- Normalize the combined success rating to be between 0 and 100
        round((cast(combined_success as decimal) - min(combined_success) over ()) /
        (max(combined_success) over () - min(combined_success) over ()) * 100, 1) as combined_success_rating
    from {{ ref('int_movies_mapping') }}

)

select * from success_metrics
