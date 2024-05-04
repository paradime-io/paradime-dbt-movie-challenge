WITH combine_movies_db AS (
    SELECT * FROM {{ ref('combine_movies_db') }}
)
select
    *,
    case
        when (tmdb_release_date is null) then omdb_release_date
        when (omdb_release_date is null) then tmdb_release_date
        when (tmdb_release_date != omdb_release_date) then tmdb_release_date
        when (tmdb_release_date = omdb_release_date) then omdb_release_date
        else Null
        end AS release_date2
from combine_movies_db