select
    imdb_id,
    trim(keyword.value::string) AS keyword
from
    {{ ref('int_movies_enriched') }},
    LATERAL SPLIT_TO_TABLE(int_movies_enriched.keywords, ',') AS keyword
where int_movies_enriched.keywords != 'N/A'