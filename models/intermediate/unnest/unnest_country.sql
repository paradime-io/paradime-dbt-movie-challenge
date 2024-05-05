select imdb_id, trim(my_split.value) as country
from  {{ ref('stg_omdb_movies') }}, lateral split_to_table(country,',') as my_split
where country != 'N/A'