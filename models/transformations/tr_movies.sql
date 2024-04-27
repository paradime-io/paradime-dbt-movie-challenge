-- all omdb_movies rows have a tmdb_id but not all of its tmdb_ids are in tmdb_movies

with omdb_movies as (
    select
        cast(imdb_id as varchar) as imdb_id
        , cast(tmdb_id as varchar) as tmdb_id
        , title as omdb_title
    from {{ ref('stg_omdb_movies') }}
    )
    
, tmdb_movies as (
    select
        cast(imdb_id as varchar) as imdb_id
        , cast(tmdb_id as varchar) as tmdb_id
        , title as tmdb_title
    from {{ ref('stg_tmdb_movies') }}
)

select
    tm.tmdb_id
    , coalesce(tm.imdb_id, om.imdb_id) as imdb_id
    , omdb_title
    , tmdb_title
from omdb_movies om
full join tmdb_movies tm
on om.tmdb_id = tm.tmdb_id