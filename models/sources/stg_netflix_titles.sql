WITH netflix_history AS (
    select distinct *
    from {{ source('NETFLIX', 'RAW_NETFLIX_TITLES') }}
)

select *
    , regexp_substr(duration, '(\\d+)(h)', 1 , 1, 'e', 1) as movie_hours
    , regexp_substr(duration, '(\\d+)(m)', 1 , 1, 'e', 1) as movie_minutes
    , (movie_hours * 60) + movie_minutes as total_movie_minutes
    , episodes_runtime / nullif(episodes_count,0) as avg_tv_episode_minutes
    , coalesce(total_movie_minutes,avg_tv_episode_minutes,0) runtime_minutes
    , case  when (episodes_count > 0 or title ilike any ('%season%', '%series%', '%episode%', '%jeopardy%')) then 'tv'
        else 'movie'
        end as content_type
from netflix_history