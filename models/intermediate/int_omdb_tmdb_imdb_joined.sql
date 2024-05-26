with 

tmdb as (
    select *
    from {{ ref('stg_tmdb__movies') }}
), 

omdb as (
    select *
    from {{ ref('stg_omdb__movies') }}
), 

imdb as (
    select *
    from {{ ref('stg_imdb__movies') }}
),

join_tmdb_and_omdb as (
    select
        t.imdb_id,
        t.tmdb_id,
        t.movie_title,
        t.tagline,
        t.keywords,
        t.status,
        t.runtime,
        t.vote_average,
        t.revenue_usd,
        t.budget_usd,
        t.t_release_date,
        t.t_release_year,

        o.director,
        o.writer,
        o.actors,
        o.awards,
        o.production,
        o.dvd,
        o.metascore,
        o.country,
        o.imdb_rating,
        o.imdb_votes,
        o.box_office,
        o.o_release_date,
        year(o.o_release_date) as o_release_year        
    FROM tmdb as t
    inner join omdb as o using (imdb_id)
),

remove_duplicates as (
    select *
    from join_tmdb_and_omdb
    -- tmdb data points are entered by users, sometimes, repeatedly 
    -- so we need to exclude possible duplicates by no particular criteria
    qualify row_number() over (partition by imdb_id order by tmdb_id) = 1
),

-- identify joined data sources using prefix to identify where each column 
-- is coming from for data quality verification purposes.
add_imdb as (
    select 
        f.imdb_id,
        f.tmdb_id,
        f.movie_title as t_movie_title,
        f.tagline as t_tagline,
        f.keywords as t_keywords,
        f.status as t_status,
        f.runtime as t_runtime,
        f.vote_average as t_rating_avg,
        f.revenue_usd as t_revenue_usd,
        f.budget_usd as t_budget_usd,
        f.t_release_date,
        f.t_release_year,

        f.production as o_production,
        f.dvd as o_dvd,
        f.metascore as o_metascore,
        f.country as o_country,
        f.imdb_rating as o_rating_avg,
        f.imdb_votes as o_nb_votes,
        f.box_office as o_box_office,
        f.o_release_year,
        f.o_release_date,

        i.type as i_type,
        i.primary_title as i_primary_title,
        i.original_title as i_original_title,
        i.release_year as i_release_year,
        i.runtime_min as i_runtime_min
    from remove_duplicates as f
    inner join imdb as i using (imdb_id)
)

select *
from add_imdb
