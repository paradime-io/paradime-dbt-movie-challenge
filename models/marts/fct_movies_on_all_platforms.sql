SELECT
    platform,
    show_id,
    title,
    director,
    country,
    date_added,
    release_year,
    rating,
    duration_mins,
    listed_in,
FROM 
    {{ ref('int_movies_on_all_platforms') }}