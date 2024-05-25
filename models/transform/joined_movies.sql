with omdb as (
    select * from {{ ref('stg_omdb_movies') }}
),
    tmdb as (
    select * from {{ ref('stg_tmdb_movies') }}
), joined as (
select 
    coalesce(omdb.imdb_id, tmdb.imdb_id) as imdb_id,
    coalesce(omdb.title, tmdb.title) as title,
    omdb.director,
    omdb.writer,
    omdb.actors,
    coalesce(omdb.genre,tmdb.genre_names) as genre,
    coalesce(omdb.language, tmdb.original_language) as language,
    omdb.country,
    coalesce(omdb.plot, tmdb.overview) as plot,
    omdb.rated,
    omdb.metascore,
    omdb.imdb_rating,
    omdb.imdb_votes,
    coalesce(omdb.released_date,tmdb.release_date) as release_date,
    coalesce(omdb.runtime,tmdb.runtime) as runtime,
    coalesce(omdb.box_office,tmdb.revenue) as revenue,
    coalesce(omdb.poster,tmdb.poster_path) as poster,
    omdb.awards,
    coalesce(omdb.tmdb_id,tmdb.tmdb_id) as tmdb_id,
    tmdb.budget

from omdb full outer join tmdb on omdb.tmdb_id = tmdb.tmdb_id
)
select * from joined
where imdb_rating is not null


