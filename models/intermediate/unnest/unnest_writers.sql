select imdb_id, trim(my_split.value) as writer
from  {{ ref('stg_omdb_tmdb_movies_join') }}, lateral split_to_table(writer,',') as my_split
where writer != 'N/A'