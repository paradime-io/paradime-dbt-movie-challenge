with 

movies as (
    select 
        *,
        year(o_release_date) as movie_year,
        month(o_release_date) as movie_month
    from {{ ref('int_omdb_tmdb_imdb_filtered') }}
),

imdb_ratings as (
    select *
    from {{ ref('stg_imdb__movie_ratings') }}
),

cpi as (
    select *
    from {{ ref('int_bls_cpi_values_unpivoted') }}
),

people as (
    select *
    from {{ ref('stg_imdb__movie_people') }}
),

academy_awards as (
    select *
    from {{ ref('stg_davidlu__academy_awards') }}
),

academy_awards_aggregated as (
    select 
        imdb_id,
        count(*) as academy_nominations,
        sum(case when winner = true then 1 else 0 end) as academy_awards
    from academy_awards
    group by imdb_id
),

people_aggregated as (
    select 
        imdb_id,
        count(*) as movie_workers
    from people
    group by imdb_id
),

join_metrics as (
    select 
        m.*,
        coalesce(a.academy_nominations, 0) as academy_nominations, 
        coalesce(a.academy_awards, 0) as academy_awards,
        coalesce(p.movie_workers, 0) as movie_workers,
        i.rating_avg as i_rating_avg, 
        i.nb_votes as i_nb_votes
    from movies as m
    left join academy_awards_aggregated as a using (imdb_id)
    left join people_aggregated as p using (imdb_id)
    left join imdb_ratings as i using (imdb_id)
),

-- get most up-to-date cpi available in the data
current_cpi as (
    select cpi_value as current_cpi
    from cpi
    order by cpi_year desc, cpi_month desc
    limit 1
),

-- get cpi for the month and year of the release of the movie
movie_cpi as (
    select 
        m.*,
        c.cpi_value as movie_date_cpi
    from join_metrics as m
    left join cpi as c on m.movie_year = c.cpi_year and m.movie_month = c.cpi_month
),

adjusted_values as (
    select 
        imdb_id,
        tmdb_id,
        -- dimensions
        t_movie_title,
        t_movie_title || ' (' || o_release_year || ')' as movie_title_year,
        t_movie_title || ' (' || o_release_year || ') - ' || imdb_id as movie_title_unique,
        o_production,
        o_dvd,
        o_country,
        -- metrics
        t_runtime,
        t_rating_avg,
        i_rating_avg,
        i_nb_votes,
        academy_nominations,
        academy_awards,
        movie_workers,
        t_revenue_usd,
        t_budget_usd,
        -- date/datetime
        o_release_date,
        o_release_year,
        -- Movies released in the current month won't have a cpi yet
        coalesce(m.movie_date_cpi, c.current_cpi) as movie_cpi, 
        round((m.t_budget_usd * c.current_cpi) / movie_cpi,0) AS adjusted_budget_usd,
        round((m.t_revenue_usd * c.current_cpi) / movie_cpi,0) AS adjusted_revenue_usd
    from movie_cpi as m
    cross join current_cpi as c
),

add_ranking as (
    select 
        *,
        (adjusted_revenue_usd - adjusted_budget_usd) as adjusted_profit_usd,
        dense_rank() over (order by adjusted_revenue_usd desc) as revenue_rank,
        dense_rank() over (order by adjusted_budget_usd desc) as budget_rank,
        dense_rank() over (order by adjusted_profit_usd desc) as profit_rank,
        dense_rank() over (order by academy_nominations desc) as academy_nominations_rank,
        dense_rank() over (order by academy_awards desc) as academy_awards_rank,
        dense_rank() over (order by movie_workers desc) as workers_rank
    from adjusted_values
)

SELECT * 
FROM add_ranking
