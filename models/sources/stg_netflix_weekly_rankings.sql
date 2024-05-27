WITH netflix_weekly_rankings AS (
    select distinct *
    from {{ source('NETFLIX', 'RAW_NETFLIX_WEEKLY_RANKINGS') }}
)

select to_date(week::varchar, 'YYYYMMDD') as reporting_week_end_date
, dateadd('days', -6, reporting_week_end_date) as reporting_week_start_date
, id as episode_id
, showid as title_id
, category as reporting_category
, rank as netflix_weekly
, weeksintopten as num_weeks_in_top_ten
, rankmetric as ranking_metric_used
, hours as num_weekly_hours_watched
/* fyi Netflix switched metric used in these reports so this will be 0 for a ton or records
    in theory, it could be backfilled, but doing so would likely alter the rankings */
, hoursoverruntime as hours_over_runtime
, runtime as reported_runtime
, isstaggeredlaunch as is_staggered_launch

from netflix_weekly_rankings
