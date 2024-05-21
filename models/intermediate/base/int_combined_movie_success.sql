-- int_combined_movie_success.sql

with min_max as (
  select 
    min(imdb_votes) as min_imdb_votes,
    max(imdb_votes) as max_imdb_votes,
    min(number_of_awards_won) as min_number_of_awards_won,
    max(number_of_awards_won) as max_number_of_awards_won,
    min(viewer_vote_count) as min_viewer_vote_count,
    max(viewer_vote_count) as max_viewer_vote_count,
    min(inflation_corrected_revenue) as min_inflation_corrected_revenue,
    max(inflation_corrected_revenue) as max_inflation_corrected_revenue,
  from {{ ref('int_movies_mapping') }}
),

success_metrics as (
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
        round(10 * (imdb_votes - min_imdb_votes) / (max_imdb_votes - min_imdb_votes),1) as imdb_votes_normalized,
        number_of_awards_won,
        round(10 * (number_of_awards_won - min_number_of_awards_won) / (max_number_of_awards_won- min_number_of_awards_won),1) as number_of_awards_won_normalized,
        combined_rotten_tomato_rating,
        round(viewer_vote_average,1) as viewer_vote_average,
        viewer_vote_count,
        round(10 * (viewer_vote_count - min_viewer_vote_count) / (max_viewer_vote_count - min_viewer_vote_count),1) as viewer_vote_count_normalized,
        revenue,
        inflation_corrected_revenue,
        round(10 * (inflation_corrected_revenue - min_inflation_corrected_revenue) / (max_inflation_corrected_revenue - min_inflation_corrected_revenue),1) as revenue_normalized,
 
        -- Combined success metric
        {{ calculate_combined_success_rating(
            imdb_rating_weight=1,
            imdb_votes_normalized_weight=0.8,
            combined_rotten_tomato_rating_weight=0.5,
            number_of_awards_won_normalized_won_weight=0.3,
            viewer_vote_average_weight=0.8,
            viewer_vote_count_normalized_weight=0.5,
            revenue_normalized_weight=0.4
        ) }},
        -- Normalize the combined success rating to be between 0 and 100
        round((cast(combined_success as decimal) - min(combined_success) over ()) / (max(combined_success) over () - min(combined_success) over ()) * 10, 1) as combined_success_rating
    from {{ ref('int_movies_mapping') }}, min_max
)

select * from success_metrics
