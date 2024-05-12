{% macro calculate_combined_success_rating(
    imdb_rating_weight=1,
    imdb_votes_weight=1,
    combined_rotten_tomato_rating_weight=1,
    number_of_awards_won_weight=1,
    viewer_vote_average_weight=1,
    viewer_vote_count_weight=1,
    normalized_revenue_weight=1
) %}

    round(
        coalesce(imdb_rating, 0) * {{ imdb_rating_weight }} +
        coalesce(imdb_votes, 0) * {{ imdb_votes_weight }} +
        coalesce(combined_rotten_tomato_rating, 0) * {{ combined_rotten_tomato_rating_weight }} +
        coalesce(number_of_awards_won, 0) * {{ number_of_awards_won_weight }} +
        coalesce(viewer_vote_average, 0) * {{ viewer_vote_average_weight }} +
        coalesce(viewer_vote_count, 0) * {{ viewer_vote_count_weight }} +
        coalesce(normalized_revenue, 0) * {{ normalized_revenue_weight }},
    1) as combined_success_rating

{% endmacro %}