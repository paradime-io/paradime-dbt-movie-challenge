with tv_series as 
(   
    SELECT
    name,
    SPLIT_PART(genre_names, ',', 1) AS main_genre,
    number_of_seasons,
    number_of_episodes,
    ROUND(number_of_episodes/number_of_seasons,0) as avg_episodes_per_season,
    ROUND(vote_average,2) as avg_vote,
    vote_count
FROM
    {{ ref('stg_tmdb_tv_series') }}
where 
    number_of_episodes is not null
    and number_of_episodes > 1
    and number_of_seasons > 0
    and vote_count > 10
    and main_genre is not null
    and 
)

SELECT
    *
FROM
    tv_series
