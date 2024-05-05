select imdb_id
      ,tmdb_id 
from {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}