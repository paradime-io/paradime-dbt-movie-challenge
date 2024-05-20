{% macro calculate_combined_success_rating(
    imdb_rating_weight = 1,
    imdb_votes_normalized_weight = 1,
    combined_rotten_tomato_rating_normalized_weight = 1,
    number_of_awards_won_normalized_won_weight = 1,
    viewer_vote_average_weight = 1,
    viewer_vote_count_normalized_weight = 1,
    revenue_normalized_weight = 1
) %}

    round(
        coalesce(imdb_rating, 0) * {{ imdb_rating_weight }} +
        coalesce(imdb_votes_normalized, 0) * {{ imdb_votes_normalized_weight }} +
        coalesce(combined_rotten_tomato_rating_normalized, 0) * {{ combined_rotten_tomato_rating_normalized_weight }} +
        coalesce(number_of_awards_won_normalized, 0) * {{ number_of_awards_won_normalized_won_weight }} +
        coalesce(viewer_vote_average, 0) * {{ viewer_vote_average_weight }} +
        coalesce(viewer_vote_count_normalized, 0) * {{ viewer_vote_count_normalized_weight }} +
        coalesce(revenue_normalized, 0) * {{ revenue_normalized_weight }},
    1) as combined_success

{% endmacro %}