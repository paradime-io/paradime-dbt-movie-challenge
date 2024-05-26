with roi as (
    select
    release_decade
    ,year(release_date) as release_year
    ,count(distinct imdb_id) as movie_count
    ,sum(case
        when (revenue/budget) > 1 then 1
        else 0
    end) as positive_ROI_movies
    ,sum(case
        when (revenue/budget) < 1 then 1
        else 0
    end) as negative_ROI_movies
    ,sum(revenue) as total_revenue
    ,sum(budget) as total_budget
    ,sum(revenue)/sum(budget) as total_roi
    
    from {{ ref('split_genre_names_to_rows') }}
    where budget > 0
    and revenue > 0
    and year(release_date) between 1960 and 2024
    and index = 1
    and imdb_id != ''
    group by 1,2
)

select
*
,positive_roi_movies/negative_roi_movies as positive_neg_roi_ratio

from roi
order by release_year