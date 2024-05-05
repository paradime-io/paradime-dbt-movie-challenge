select imdb_id, trim(my_split.value) as language
from  {{ ref('stg_omdb_movies') }}, lateral split_to_table(language,',') as my_split
where language != 'N/A'