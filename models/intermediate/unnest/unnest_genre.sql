select imdb_id, trim(my_split.value) as genre
from  {{ ref('stg_omdb_tmdb_movies_join') }}, lateral split_to_table(genre,',') as my_split
where genre != 'N/A'