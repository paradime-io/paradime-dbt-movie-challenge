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
        number_of_awards_won,
        round((coalesce(omdb_rt_rating, 0) + coalesce(audience_score, 0) + coalesce(tomato_meter, 0)) / 3, 0) as combined_rotten_tomato_rating,
        viewer_vote_average,
        revenue,
        inflation_corrected_revenue,

        -- Success metrics normalized (0-10)
        round((cast(imdb_votes as decimal) - min(imdb_votes) over ()) /
            (max(imdb_votes) over () - min(imdb_votes) over ()) * 10, 1) as imdb_votes_normalized,
        round((cast(number_of_awards_won as decimal) - min(number_of_awards_won) over ()) /
            (max(number_of_awards_won) over () - min(number_of_awards_won) over ()) * 10, 1) as number_of_awards_won_normalized,
        round((cast(viewer_vote_count as decimal) - min(viewer_vote_count) over ()) /
            (max(viewer_vote_count) over () - min(viewer_vote_count) over ()) * 10, 1) as viewer_vote_count_normalized,
        round((cast(inflation_corrected_revenue as decimal) - min(inflation_corrected_revenue) over ()) /
            (max(inflation_corrected_revenue) over () - min(inflation_corrected_revenue) over ()) * 10, 1) as revenue_normalized,
        round((cast(imdb_votes as decimal) - min(imdb_votes) over ()) /
            (max(imdb_votes) over () - min(imdb_votes) over ()) * 10, 1) as combined_rotten_tomato_rating_normalized,
        
        -- Combined success metric
        {{ calculate_combined_success_rating(
            imdb_rating_weight=2,
            imdb_votes_normalized_weight=2,
            combined_rotten_tomato_rating_normalized_weight=1,
            number_of_awards_won_normalized_won_weight=1,
            viewer_vote_average_weight=0.3,
            viewer_vote_count_normalized_weight=0.3,
            revenue_normalized_weight=0.1
        ) }},
        -- Normalize the combined success rating to be between 0 and 100
        round((cast(combined_success as decimal) - min(combined_success) over ()) /
            (max(combined_success) over () - min(combined_success) over ()) * 100, 1) as combined_success_rating
    from {{ ref('int_movies_mapping') }}

)

select * from success_metrics
