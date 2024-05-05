select imdb_id, trim(my_split.value) as director
from  {{ ref('stg_omdb_movies') }}, lateral split_to_table(director,',') as my_split
where director != 'N/A'