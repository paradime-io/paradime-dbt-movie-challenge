select
    tmdb_id,
    trim(my_split.value) as director
from  {{ ref('clean_combined_movies') }},
lateral split_to_table(director,',') as my_split
where director != 'N/A'