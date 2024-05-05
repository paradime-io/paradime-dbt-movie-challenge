select
    imdb_id,
    trim(actor_name.value::string) AS actor_name
from
    {{ ref('int_movies_enriched') }},
    LATERAL SPLIT_TO_TABLE(int_movies_enriched.actors, ',') AS actor_name
where int_movies_enriched.actors != 'N/A'