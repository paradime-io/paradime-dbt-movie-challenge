SELECT
    platform,
    show_id,
    title,
    director,
    country,
    date_added,
    release_year,
    rating,
    seasons,
    listed_in,
FROM 
    {{ ref('int_tvshows_on_all_platforms') }}