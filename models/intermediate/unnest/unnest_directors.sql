select imdb_id, trim(my_split.value) as director
from  {{ ref('stg_omdb_tmdb_movies_join') }}, lateral split_to_table(director,',') as my_split
where director != 'N/A'