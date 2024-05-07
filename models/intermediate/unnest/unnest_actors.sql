select imdb_id, trim(my_split.value) as actor
from  {{ ref('stg_omdb_tmdb_movies_join') }}, lateral split_to_table(actors,',') as my_split
where actor != 'N/A'