select
    tmdb_id,
    trim(my_split.value) as writer
from  {{ ref('clean_combined_movies') }}, lateral split_to_table(writer,',') as my_split
where writer != 'N/A'