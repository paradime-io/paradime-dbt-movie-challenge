select
    tmdb_id,
    trim(my_split.value) as genre_names
from  {{ ref('clean_combined_movies') }},
lateral split_to_table(genre_names,',') as my_split
where genre_names != 'N/A'