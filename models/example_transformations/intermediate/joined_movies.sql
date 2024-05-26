with movies as(
    select 
    IMDB_ID,
    TITLE,
    RATED,
    IMDB_VOTES,
    RELEASED_DATE,
    RELEASE_YEAR,
    RUNTIME,
    DVD,
    PRODUCTION,
    TMDB_ID
    BUDGET,
    REVENUE
    from 
    {{ref('omdb_join_tmdb')}}
)

select 
    * 
from
    movies