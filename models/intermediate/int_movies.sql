-- have to remove nulls to generate unique movie ids

with removing_nulls as (
    select
        coalesce(tmdb_id, 'na') as tmdb_id
        , coalesce(imdb_id, 'na') as imdb_id
        , omdb_title
        , tmdb_title
    from {{ ref('tr_movies') }}
)

select
    md5(tmdb_id || imdb_id) as movie_id
    , case
        when tmdb_id = 'na' then null
        else tmdb_id
        end as tmdb_id
    , case
        when imdb_id = 'na' then null
        else imdb_id
        end as imdb_id
    , omdb_title
    , tmdb_title
from removing_nulls