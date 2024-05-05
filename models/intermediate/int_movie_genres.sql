select
    imdb_id,
    trim(genre_name.value::string) AS genre_name
from
    {{ ref('int_movies_enriched') }},
    LATERAL SPLIT_TO_TABLE(int_movies_enriched.genre_names, ',') AS genre_name
where int_movies_enriched.genre_names != 'N/A'