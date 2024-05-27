
with title_history as(
    select *
    from {{ ref('stg_netflix_history') }}
)

, netflix_top_10_weekly as (
    select *
    from {{ ref('stg_netflix_weekly_rankings') }}
)

, history_aggs as (
    select 
        title_history.date
        , dayname(title_history.date) as day_of_week
        , title_history.title_id
        , title_history.user_id
        , case 
            when user_id = 1 then 'Spence' 
            when user_id = 2 then 'Zoe'
        end as viewer_name
        , row_number() over(partition by title_history.user_id, title_history.title_id order by date asc) as episode_number_watched
        , min(date) over(partition by title_history.user_id, title_history.title_id) as series_started_date
        , max(date) over(partition by title_history.user_id, title_history.title_id) as series_last_watched_date
        , series_last_watched_date - series_started_date as num_days_between_first_and_last_watched
    from title_history
)

, final as(


select 
    history_aggs.*
    , max(netflix_top_10_weekly.title_id is not null) as had_top_ten_status_at_view_time
    , min(netflix_top_10_weekly.reporting_week_start_date) as week_of_top_ten_status
    , min(netflix_top_10_weekly.netflix_weekly) as netflix_rank
    , max(netflix_top_10_weekly.num_weeks_in_top_ten) as num_weeks_in_top_ten
from history_aggs
-- Let's show that a title was on a top 10 week the week it was viewed
left join netflix_top_10_weekly
    on (history_aggs.title_id = netflix_top_10_weekly.title_id
        and history_aggs.date >= netflix_top_10_weekly.reporting_week_start_date
        and history_aggs.date <= netflix_top_10_weekly.reporting_week_end_date)
group by all
)

select *
from final