select imdb_id, trim(my_split.value) as country
from  {{ ref('stg_omdb_tmdb_movies_join') }}, lateral split_to_table(country,',') as my_split
where country != 'N/A'