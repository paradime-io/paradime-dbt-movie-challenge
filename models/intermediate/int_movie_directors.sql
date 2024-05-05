select
    imdb_id,
    trim(director_name.value::string) AS director_name
from
    {{ ref('int_movies_enriched') }},
    LATERAL SPLIT_TO_TABLE(int_movies_enriched.director, ',') AS director_name
where int_movies_enriched.director != 'N/A'