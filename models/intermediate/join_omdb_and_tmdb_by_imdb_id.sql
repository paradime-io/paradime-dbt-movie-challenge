with 

tmdb as (
    select
        imdb_id,
        tmdb_id,
        title,
        genre_names,
        tagline,
        keywords,
        status,
        runtime,
        vote_average,
        revenue_usd,
        budget_usd,
        t_release_date,
        t_release_year
    from {{ ref('stg_tmdb_movies') }}
), 

omdb as (
    select 
        imdb_id,
        tmdb_id,
        director,
        writer,
        actors,
        awards,
        production,
        dvd,
        metascore,
        country,
        imdb_rating,
        imdb_votes,
        box_office,
        o_release_year,
        o_release_date
    from {{ ref('stg_omdb_movies') }}
), 

joined as (
    select
        t.imdb_id,
        t.tmdb_id,
        t.title,
        t.genre_names,
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
        o.o_release_year,
        o.o_release_date
    FROM tmdb as t
    inner join omdb as o using (imdb_id)
)

select *
from joined
-- tmdb data points are entered by users, sometimes, repeatedly 
-- so we need to exclude possible duplicates by no particular criteria
qualify row_number() over (partition by imdb_id order by tmdb_id) = 1
