select 
    *,
    extract(YEAR from release_date) as release_year
    
from
{{ ref('fantasy_scifi_movies') }}
