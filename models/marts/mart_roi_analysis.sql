with 

fact as (
    select 
        *,
        year(o_release_date) as movie_year,
        month(o_release_date) as movie_month
    from {{ ref('int_complete_data_points') }}
),

cpi as (
    select *
    from {{ ref('int_consumer_price_index_unpivoted') }}
),

-- get most up-to-date cpi available in the data
current_cpi as (
    select cpi_value as current_cpi
    from cpi
    order by cpi_year desc, cpi_month desc
    limit 1
),

movie_cpi as (
    select 
        f.*,
        c.cpi_value as movie_date_cpi
    from fact as f
    left join cpi as c on f.movie_year = c.cpi_year and f.movie_month = c.cpi_month
),

adjusted_roi as (
    select 
        m.*,
        -- I may have a movie for the current month for each there's no cpi yet
        coalesce(m.movie_date_cpi, c.current_cpi) as movie_cpi, 
        c.current_cpi,
        round((m.roi_usd * c.current_cpi) / movie_cpi,0) AS adjusted_roi_usd
    from movie_cpi as m
    cross join current_cpi as c
)

SELECT * 
FROM adjusted_roi
