select 
    *,
    extract(YEAR from release_date) as release_year,
    concat(EXTRACT(YEAR FROM released_date) - EXTRACT(YEAR FROM released_date) % 10,'s') AS decade,
    
from
{{ ref('fantasy_scifi_movies') }}
