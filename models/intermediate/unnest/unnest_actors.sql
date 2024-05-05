select imdb_id, trim(my_split.value) as actor
from  {{ ref('stg_omdb_movies') }}, lateral split_to_table(actors,',') as my_split
where actor != 'N/A'